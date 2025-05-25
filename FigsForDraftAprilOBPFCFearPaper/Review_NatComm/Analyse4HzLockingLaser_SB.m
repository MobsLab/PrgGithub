clear all
Mice4HzStim  = {'D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse367_20160719-EXT-72h-laser4\20160719-EXT-72h-laser4',...
    'D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse363_20160719-EXT-72h-laser4\20160719-EXT-72h-laser4',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse458_20161021-EXT-72h-laser4\20161021-EXT-72h-laser4',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse459_20161021-EXT-72h-laser4\20161021-EXT-72h-laser4',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse466_20161222-EXT-72h-envC-laser4\20161222-EXT-72h-envC-laser4',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse467_20161222-EXT-72h-envC-laser4\20161222-EXT-72h-envC-laser4'};

Mice13HzStim  = {'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse499_20170309-EXT-24-laser13\20170309-EXT-24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse543_20170727-EXT24-laser13\20170727-EXT24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse542_20170727-EXT24-laser13\20170727-EXT24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse540_20170727-EXT24-laser13\20170727-EXT24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse537_20170727-EXT24-laser13\20170727-EXT24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse506_20170316-EXT-24-laser13\20170316-EXT-24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse505_20170316-EXT-24-laser13\20170316-EXT-24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse504_20170316-EXT-24-laser13\20170316-EXT-24-laser13',...
    'D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse498_20170309-EXT-24-laser13\20170309-EXT-24-laser13'};

DatToUse = Mice13HzStim; y  = zeros(1,length(Mice13HzStim));
% DatToUse = Mice4HzStim; y = -[600,600,500,400,400,400];
AmpToTry = [0.8:0.1:1.4];
for mm=1:length(DatToUse)
    cd(DatToUse{mm})
    disp(DatToUse{mm})
    clear LFP Laser RightPhase
    
    load(['LFPData' filesep 'LFP' num2str(32) '.mat'])
    Laser = LFP;
    
    
    LaserOnEpoch = thresholdIntervals(Laser,y(mm),'Direction','Below');
    
    try,load('ChannelsToAnalyse\PFCx_deep.mat')
    catch, try,load('ChannelsToAnalyse\PFCx_deep_left.mat'),
        catch, load('ChannelsToAnalyse\PFCx_deep_right.mat')
        end
    end
    load(['LFPData' filesep 'LFP' num2str(channel) '.mat'])
    load('behavResources.mat','FreezeAccEpoch')
    
    % clean the signal
    [M,T] = PlotRipRaw(LFP,Start(LaserOnEpoch,'s'),250,0,0);
    SigToAdd = M(312:end,2);
    NewData = Data(LFP)*0;
    st = Start(LaserOnEpoch);
    for k = 1:length(st)
        NewData(find(Range(LFP)>st(k),1,'first'): find(Range(LFP)>st(k),1,'first')+length(SigToAdd)-1) = SigToAdd;
    end
    
    for a = 1:length(AmpToTry)
        LFPCl = tsd(Range(LFP),Data(LFP)-NewData*AmpToTry(a));
        PhaseLFP = GetPhaseFilteredLFP(FilterLFP(LFPCl,[3 6],1024));
        VectStr(a) = sqrt(sum(cos(Data(Restrict(PhaseLFP,LaserOnEpoch)))).^2+sum(sin(Data(Restrict(PhaseLFP,LaserOnEpoch)))).^2)/length(Data(Restrict(PhaseLFP,LaserOnEpoch)));
    end
    [val,ind] = min(VectStr);
    LFPCl = tsd(Range(LFP),Data(LFP)-NewData*AmpToTry(ind));
    PhaseLFP = GetPhaseFilteredLFP(FilterLFP(LFPCl,[3 6],1024));
    RightPhase = thresholdIntervals(PhaseLFP,pi);
    
    for k = 1:length(Start(FreezeAccEpoch))
        LittleEpoch = subset(FreezeAccEpoch,k);
        %             hist(Data(Restrict(PhaseLFP,and(LaserOnEpoch,LittleEpoch))),200)
        %             title(num2str(Stop(LittleEpoch,'s')-Start(LittleEpoch,'s')))
        %             pause
        DurEp{mm}(k) = Stop(LittleEpoch,'s')-Start(LittleEpoch,'s');
        LaseInEp{mm}(k) = sum(Stop(and(LittleEpoch,LaserOnEpoch),'s')-Start(and(LittleEpoch,LaserOnEpoch),'s'));
        PropPhase{mm}(k) = length(Data(Restrict(LFP,and(RightPhase,and(LaserOnEpoch,LittleEpoch)))))./length(Data(Restrict(LFP,and(LaserOnEpoch,LittleEpoch))));
        EndLaserEp =and(mergeCloseIntervals(LaserOnEpoch,1E4),intervalSet(Stop(LittleEpoch)-4*1E4,Stop(LittleEpoch)));
        EndsWithLaser{mm}(k) = sum(Stop(EndLaserEp,'s')-Start(EndLaserEp,'s'));
    end
    
    SleepStages=PlotSleepStage(and(RightPhase,LaserOnEpoch),intervalSet(0,0),intervalSet(0,0),0);
    dat = Data(SleepStages); dat(dat==4) = 1; dat(dat==-1) = 0;
    SleepStages = tsd(Range(SleepStages),dat);
    [M,T] = PlotRipRaw(SleepStages,Stop(FreezeAccEpoch,'s'),3000,0,0);
    FzEndPhase{mm} = T(EndsWithLaser{mm}==4,:);
    
end

AllDur = []; AllProp = [];
for mm=1:length(DatToUse)
    plot(DurEp{mm},PropPhase{mm},'.','MarkerSize',12)
    AllDur = [AllDur,DurEp{mm}]; 
    AllProp = [AllProp,PropPhase{mm}];
    EndFz(mm,:) = nanmean(FzEndPhase{mm});
    hold on
end

%%%

OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 20];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;

Signal=LFP
AllPeaks=FindPeaksForFrequency(Signal,OptionsMiniMaxi,0);
AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(Signal,'s'));
if AllPeaks(1,2)==1
    PhaseInterpol=tsd(Range(Signal),mod(Y,2*pi));
else
    PhaseInterpol=tsd(Range(Signal),mod(Y+pi,2*pi));
end

