

%%
GetSleepSessions_Drugs_BM


%% change channel
channel = 30;
save('ChannelsToAnalyse/PFCx_deltasup.mat','channel');
save('ChannelsToAnalyse/PFCx_sup.mat','channel');


%% Ripples
channel = input('non rip channel ? ');
save('ChannelsToAnalyse/nonRip.mat','channel')
CreateRipplesSleep_BM

%% Sleep event
disp('getting sleep signals')
CreateSleepSignals('recompute',0,'rip',0);

%% Substages
disp('getting sleep stages')
[featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch')
[Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
save('SleepSubstages', 'Epoch', 'NameEpoch')

%% Id figure 1
close all
disp('making ID fig1')
MakeIDSleepData
PlotIDSleepData
saveas(1,'IDFig1.png')
close all

%% Id figure 2
disp('making ID fig2')
MakeIDSleepData2
PlotIDSleepData2
saveas(1,'IDFig2.png')
close all


%% Generate spectrograms
if exist('B_Low_Spectrum.mat')==0
    disp('calculating OB')
    clear channel
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    LowSpectrumSB([cd filesep],channel,'B')
end

if exist('H_VHigh_Spectrum.mat')==0
    disp('calculating H_high')
    clear channel
    try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
        try,load('ChannelsToAnalyse/dHPC_sup.mat'),
        catch
            try,load('ChannelsToAnalyse/dHPC_deep.mat'),
            end
        end
    end
    channel;
    VeryHighSpectrum([cd filesep],channel,'H')
end

if exist('PFCx_Low_Spectrum.mat')==0
    disp('calculating PFC')
    clear channel
    load('ChannelsToAnalyse/PFCx_deep.mat')
    channel;
    LowSpectrumSB([cd filesep],channel,'PFCx')
end

if exist('B_Low_Spectrum.mat')==0
    disp('calculating OB')
    if exist('ChannelsToAnalyse/EKG.mat')>0 & exist('StateEpochSB.mat')>0 & exist('HeartBeatInfo.mat')==0
    
    clear TTLInfo Behav EKG channel

    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.5;
    load('ChannelsToAnalyse/EKG.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    load('StateEpochSB.mat','TotalNoiseEpoch')
    load('ExpeInfo.mat')
    if ExpeInfo.SleepSession==0
        load('behavResources.mat')
        try,  TTLInfo;
            NoiseEpoch=or(TotalNoiseEpoch,intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4));
        catch
            NoiseEpoch=TotalNoiseEpoch;
        end
    else
        NoiseEpoch=TotalNoiseEpoch;
    end
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
    clear channel
    load('ChannelsToAnalyse/Bulb_deep.mat')
    channel;
    MiddleSpectrum_BM([cd filesep],channel,'B')
end


%% noise 
load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
FindNoiseEpoch_BM([cd filesep],channel,0);


%% Heart rate
if exist('ChannelsToAnalyse/EKG.mat')>0 & exist('StateEpochSB.mat')>0 & exist('HeartBeatInfo.mat')==0
    
    clear TTLInfo Behav EKG channel

    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.5;
    load('ChannelsToAnalyse/EKG.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    load('StateEpochSB.mat','TotalNoiseEpoch')
    load('ExpeInfo.mat')
    if ExpeInfo.SleepSession==0
        load('behavResources.mat')
        try,  TTLInfo;
            NoiseEpoch=or(TotalNoiseEpoch,intervalSet(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+2*1e4));
        catch
            NoiseEpoch=TotalNoiseEpoch;
        end
    else
        NoiseEpoch=TotalNoiseEpoch;
    end
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

%% InstFreq
Structures={'B'};
AllCombi=combnk(1:3,2);

if (exist('InstFreqAndPhase.mat'))>0
    movefile('InstFreqAndPhase.mat','InstFreqAndPhase_B.mat')
    movefile('InstantaneousFrequencyEstimate.png','InstantaneousFrequencyEstimate_B.png')
end
Docalc=1;
clear Options

if Docalc
    clear Options
    Options.Fs=1250; % sampling rate of LFP
    Options.FilBand=[1 15];
    Options.std=[0.4 0.1]; % std limits for first and second round of peak
    Options.TimeLim=0.08; % in second, minimum distance between two minima or
    Options.NumOctaves=8;
    Options.VoicesPerOctave=48;
    Options.VoicesPerOctaveCoherence=32;
    Options.FreqLim=[1.5,30];
    Options.WVDownsample=10;
    Options.TimeBandWidth=15;
    Options1=Options;
    Options1.Fs=Options.Fs/Options.WVDownsample;
    
    
    
    %% Load relevant LFPs
    try
        clear channel LFP LFPdowns
        try,load('ChannelsToAnalyse/dHPC_rip.mat'), catch,
            try,
                load('ChannelsToAnalyse/dHPC_deep.mat'),
            catch
                load('ChannelsToAnalyse/dHPC_sup.mat'),
            end
        end
        load(['LFPData/LFP',num2str(channel),'.mat'])
        tps=Range((LFP));
        vals=Data((LFP));
        LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
        AllLFP.H=LFPdowns;
    end
    
    clear channel LFP LFPdowns
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    tps=Range((LFP));
    vals=Data((LFP));
    LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
    AllLFP.B=LFPdowns;
    
    try
        clear channel LFP LFPdowns
        load('ChannelsToAnalyse/PFCx_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        tps=Range((LFP));
        vals=Data((LFP));
        LFPdowns=tsd(tps(1:Options.WVDownsample:end),vals(1:Options.WVDownsample:end));
        AllLFP.PFCx=LFPdowns;
        clear channel LFP LFPdowns
    end
    
    %     rmpath([dropbox '/Kteam/PrgMatlab/chronux2/spectral_analysis/continuous/'])
    
    %%Get local phase and amplitude with two methods
    for struc=1:length(Structures)
        clear Wavelet val ind LocalFreq LocalPhase AllPeaks tpstemp
        % Wavelet method
        [Wavelet.spec,Wavelet.freq,Wavelet.coi,Wavelet.OutParams]=cwt_SB(Data(AllLFP.(Structures{struc})),Options.Fs/Options.WVDownsample,'NumOctaves',Options.NumOctaves,...
            'VoicesPerOctave',Options.VoicesPerOctave,'TimeBandwidth',Options.TimeBandWidth);
        Wavelet.spec=Wavelet.spec(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'),:);
        Wavelet.freq=Wavelet.freq(find(Wavelet.freq<Options.FreqLim(2),1,'first'):find(Wavelet.freq>Options.FreqLim(1),1,'last'));
        [val,ind]=max(abs(Wavelet.spec));
        LocalFreq.WV=tsd(Wavelet.OutParams.t*1e4,Wavelet.freq(ind));
        idx=sub2ind(size(Wavelet.spec),ind,1:length(ind));
        LocalPhase.WV=tsd(Wavelet.OutParams.t*1e4,angle(Wavelet.spec(idx))');
        % Peak-Trough method
        AllPeaks=FindPeaksForFrequency(AllLFP.(Structures{struc}),Options1,0);
        AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
        Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(AllLFP.(Structures{struc}),'s'));
        if AllPeaks(1,2)==1
            LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y,2*pi));
        else
            LocalPhase.PT=tsd(Range(AllLFP.(Structures{struc})),mod(Y+pi,2*pi));
        end
        tpstemp=AllPeaks(2:2:end,1);
        LocalFreq.PT=tsd(tpstemp(1:end-1)*1e4,1./diff(AllPeaks(2:2:end,1)));
        save(['InstFreqAndPhase_',Structures{struc},'.mat'],'LocalFreq','LocalPhase','AllPeaks','Options','Wavelet','-v7.3')
        
        % Figure
        fig=figure;fig.Position=[1 1 800 500];
        subplot(211)
        plotscalogramfreq_SB(Wavelet.OutParams.FourierFactor,Wavelet.OutParams.sigmaT,Wavelet.spec,Wavelet.freq,Wavelet.OutParams.t,Wavelet.OutParams.normalizedfreq)
        caxis([0 1000])
        colorbar off
        subplot(212)
        plot(Range(LocalFreq.WV,'s')/60,(Data(LocalFreq.WV)),'k'),hold on
        plot(Range(LocalFreq.PT,'s')/60,(Data(LocalFreq.PT)),'r')
        ylim([0 16]),xlim([0 max(Range(LocalFreq.PT,'s')/60)])
        legend('WV','PT')
        RemParams=Wavelet.OutParams;
        saveas(fig.Number,['InstantaneousFrequencyEstimate_',Structures{struc},'.png'])
        close all
    end
    
    clear AllLFP RemParams
end




