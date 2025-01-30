clear all
fig = figure;
MiceNumber=[490,507,508,509,510,512,514];
FreqBand = [2:1:7];
FreqBand = [2,3,4,5,7,10,14];

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse514/20170316/ProjectEmbReact_M514_20170316_SleepPre
load('B_Low_Spectrum.mat')
NoSleep = 0;
for mm=1:length(MiceNumber)
    mm
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'Cond');
    
    ToKeep = find(cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    x2 = strfind(Dir,'SoundTest');
    ToKeep = find(cellfun(@isempty,x2));
    Dir = Dir(ToKeep);
    
    cd(Dir{1})
    load('ChannelsToAnalyse/Bulb_deep.mat')
    LFP = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel);

        load('ChannelsToAnalyse/PFCx_deep.mat')
    LFP_PFC = ConcatenateDataFromFolders_SB(Dir,'lfp','channumber',channel);

    
    BSpec = ConcatenateDataFromFolders_SB(Dir,'spectrum','prefix','B_Low');
    BFreq = ConcatenateDataFromFolders_SB(Dir,'InstFreq','suffix_instfreq','B');
    BNeurPhase = ConcatenateDataFromFolders_SB(Dir,'spikephase','suffix_spikephase','B');
    % NoiseEpoch
    NoiseEp_concat=ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepoch');
    TotalEpoch = intervalSet(0,max(Range(LFP)));
    TotalEpoch = TotalEpoch - NoiseEp_concat;
    
    if NoSleep
        Sleepstate=ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sleepstates');
        TotalEpoch = and(TotalEpoch,Sleepstate{1});
    end
    
    InstFreq = Data(BFreq);
    tps = Range(BFreq);
    cols = jet(12);
    for freq = 1:length(FreqBand)-1
        freq
        IDEvents = find(InstFreq>FreqBand(freq) & InstFreq<FreqBand(freq+1));
        
        % Get rid of events not in right epoch
        times = Range(Restrict(ts(tps((IDEvents))),TotalEpoch));
        a = find(ismember((tps((IDEvents))),times));
        a(1) = [];
        a(end) = [];
        IDEventsbeg = IDEvents(a);
        
        
        LitEpoch = intervalSet(tps((IDEventsbeg)),tps((IDEventsbeg+1)));
        subplot(4,7,mm)
        plot(Spectro{3},nanmean((Data(Restrict(BSpec,LitEpoch)))),'color',cols(freq,:)), hold on
        
        Dur{mm}(freq) = sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
        
        
        [M,T] = PlotRipRaw(LFP,Start(LitEpoch,'s'),2000,0,0);
        BreathShape{mm}(freq,:) = M(:,2);
        
        [M,T] = PlotRipRaw(LFP_PFC,Start(LitEpoch,'s'),2000,0,0);
        BreathShapePFC{mm}(freq,:) = M(:,2);
        
        
        EventDur{mm}{freq} = (Stop(LitEpoch,'s')-Start(LitEpoch,'s'));
    end
    
    
    for freq = 1:length(FreqBand)-1
        freq
        IDEvents = find(InstFreq>FreqBand(freq) & InstFreq<FreqBand(freq+1));
        IDEvents(1) = [];
        IDEvents(end) = [];
        
        LitEpoch = intervalSet(tps((IDEvents)),tps((IDEvents+1)));
        
        LitEpoch = subset(LitEpoch,1:find(cumsum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))>=min(Dur{mm}),1,'first'));
        
        
        %             pause
        for i = 1:length(BNeurPhase.WV)
            if         size(Data(Restrict(BNeurPhase.WV{i}.Transf,LitEpoch)),1)>20
                [Ytemp,X] = hist(Data(Restrict(BNeurPhase.WV{i}.Transf,LitEpoch)),[-pi:0.3:pi]);
                rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/')
                rmpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats')
                [mu{mm}(freq,i), Kappa{mm}(freq,i), pval{mm}(freq,i)] = CircularMean(Data(Restrict(BNeurPhase.WV{i}.Transf,LitEpoch)));
                addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/FMAToolbox/General/'))
                addpath(genpath('/home/gruffalo/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats'))
                
                Y{mm}{i}(freq,:) = Ytemp/sum(Ytemp);
            else
                Y{mm}{i}(freq,:) = [-pi:0.3:pi]+NaN;
                mu{mm}(freq,i) = NaN;
                Kappa{mm}(freq,i)= NaN;
                pval{mm}(freq,i) = NaN;
            end
        end
    end
    
    subplot(4,7,mm+7)
    imagesc(zscore(BreathShape{mm}')'),clim([-2 2])
    subplot(4,7,mm+14)
    nhist(EventDur{mm},'noerror')
    subplot(4,7,mm+21)
    bar(Dur{mm})
    
    
end

if NoSleep
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD
    saveas(fig.Number,'UnitLockinAllFrequenciesMinFreq2to14HzNoSleep.fig')
    save('UnitLockinAllFrequenciesMinFreq2to14HzNoSleep.mat','Dur','Y','Kappa','mu','pval','MiceNumber','FreqBand','BreathShape','EventDur','BreathShapePFC')
else
    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD
    saveas(fig.Number,'UnitLockinAllFrequenciesMinFreq2to14Hz.fig')
    save('UnitLockinAllFrequenciesMinFreq2to14Hz.mat','Dur','Y','Kappa','mu','pval','MiceNumber','FreqBand','BreathShape','EventDur','BreathShapePFC')
end
close all

AllKappa = [];
AllPval = [];
for mm=1:length(MiceNumber)
    AllKappa = [AllKappa,Kappa{mm}];
    AllPval = [AllPval,pval{mm}];
end

for freq = 1:length(FreqBand)-1
    for freq2 = 1:length(FreqBand)-1
        NoNan = find(not(isnan(AllKappa(freq,:))) & not(isnan(AllKappa(freq2,:))));
        A = AllKappa(freq,NoNan);
        B = AllKappa(freq2,NoNan);
        [R,P] = corrcoef(A,B);
        RVal(freq,freq2) = R(1,2);
        PVal(freq,freq2) = P(1,2);
    end
end
figure
subplot(121)
imagesc(FreqBand(1:end-1)+0.5,FreqBand(1:end-1)+0.5,RVal)
set(gca,'XTick',[1.5:1:8.5],'YTick',[1.5:1:8.5])
clim([0.25 0.55])

RVal = nan(length(FreqBand)-1,length(FreqBand)-1);
PVal = nan(length(FreqBand)-1,length(FreqBand)-1);
CountNans = zeros(length(FreqBand)-1,length(FreqBand)-1);
for mm=1:length(MiceNumber)
    
for freq = 1:length(FreqBand)-1
    for freq2 = 1:length(FreqBand)-1
        NoNan = find(not(isnan(Kappa{mm}(freq,:))) & not(isnan(Kappa{mm}(freq2,:))));
        A = Kappa{mm}(freq,NoNan);
        B = Kappa{mm}(freq2,NoNan);
        [R,P] = corrcoef(A,B);
        RValtemp(freq,freq2) = R(1,2);
        PValtemp(freq,freq2) = P(1,2);
        DiffKappatemp(freq,freq2) = nanmean(abs(Kappa{mm}(freq,:)-Kappa{mm}(freq2,:))./(Kappa{mm}(freq,:)+Kappa{mm}(freq2,:)));
    end
end
RValRem{mm} = RValtemp;
tmp = cat(3,RVal,RValtemp);
RVal = nansum(tmp,3);

tmp = cat(3,PVal,PValtemp);
PVal = nansum(tmp,3);

tmp = cat(3,CountNans,not(isnan(DiffKappatemp)));
CountNans = nansum(tmp,3);

end

RVal = RVal./CountNans;
PVal = PVal./CountNans;


subplot(122)
imagesc(FreqBand(1:end-1)+0.5,FreqBand(1:end-1)+0.5,RVal)
set(gca,'XTick',[1.5:1:8.5],'YTick',[1.5:1:8.5])
clim([0.25 0.6])

for mm=1:length(MiceNumber)

HighFreqR(mm) = RValRem{mm}(4,5);

LowFreqR(mm) = RValRem{mm}(1,2);

LowHighFreqR(mm) = nanmean([RValRem{mm}(1,4),RValRem{mm}(1,5),RValRem{mm}(2,4),RValRem{mm}(2,5)]);

end

