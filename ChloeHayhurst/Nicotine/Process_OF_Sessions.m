clear all, close all
load('behavResources.mat')

if not(exist('B_Low_Spectrum.mat'))
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    LowSpectrumSB([cd filesep],channel,'B')
end

if not(exist('B_Low_Spectrum.mat'))
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    HighSpectrum([cd filesep],channel,'B')
end


if not(exist('StateEpochSB.mat'))
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    FindNoiseEpoch_BM([cd filesep],channel,0);
end

load('ChannelsToAnalyse/Bulb_deep.mat')
load(strcat('LFPData/LFP',num2str(channel),'.mat'));

% find gamma epochs
disp('... Creating Gamma Epochs ');
smootime=3;
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);
smooth_ghi=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));

save('StateEpochSB.mat','smooth_ghi','-append');

CreateRipplesSleep('stim',0,'restrict',0,'sleep',0,'plotavg',0)


thtps_immob=2;
smoofact_Acc = 30;
th_immob_Acc = 1.7e7;

NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);

save('behavResources.mat', 'FreezeAccEpoch','-append');

clear channel
if not(exist('HeartBeatInfo.mat'))
    close all
    try
        clear EKG channel
        Options.TemplateThreshStd=3;
        Options.BeatThreshStd=0.05;
        load('ChannelsToAnalyse/EKG.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        load('StateEpochSB.mat','TotalNoiseEpoch')
        load('ExpeInfo.mat')
        load('behavResources.mat')
        NoiseEpoch=TotalNoiseEpoch;
        [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(LFP,NoiseEpoch,Options,1);
        EKG.HBTimes=ts(Times);
        EKG.HBShape=Template;
        EKG.DetectionOptions=Options;
        EKG.HBRate=HeartRate;
        EKG.GoodEpoch=GoodEpoch;
        
        save('HeartBeatInfo.mat','EKG')
        saveas(1,'EKGCheck.fig'),
        saveas(1,'EKGCheck.png')
        close all
        clear EKG NoiseEpoch TotalNoiseEpoch TTLInfo LFP EKG HearRate Template Times
    end
end

satisfied = 0;
if not(exist('AlignedXtsd','var'))
    while satisfied ==0
        
        X=Data(Xtsd);Y=Data(Ytsd);
        figure
        %         imagesc(double(ref)), colormap jet, hold on
        plot(X,Y)
        title('give 3 corners : bottom left, bottom right and top left')
        [x,y] = ginput(3);
        
        close all
        
        AlignedXtsd = tsd(Range(Xtsd),(X-x(1))./(x(2)-x(1)));
        AlignedYtsd = tsd(Range(Ytsd),(Y-y(1))./(y(3)-y(1)));
        
        figure, hold on
        plot(Data(AlignedXtsd),Data(AlignedYtsd))
        hline(0,'r--'); hline(1,'r--'); vline(0,'r--'); vline(1,'r--'); 
        
        satisfied = input('Satisfied? (0/1)')
    end
end
save('behavResources.mat', 'AlignedXtsd', 'AlignedYtsd','-append');

