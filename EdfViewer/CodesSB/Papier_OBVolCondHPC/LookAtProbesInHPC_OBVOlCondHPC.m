clear all
%% Go to file location
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', 994);
cd(Dir.path{1}{1})

%% Where to save stuff
SaveFolder = '/media/DataMOBsRAIDN/OBCoh_HPCProbes_4Hz/Mouse994_Probe1/';

%% load session info
load('behavResources.mat')
CondEpoch = SessionEpoch.Cond1;
CondEpoch = or(CondEpoch, SessionEpoch.Cond2);
CondEpoch = or(CondEpoch, SessionEpoch.Cond3);
CondEpoch = or(CondEpoch, SessionEpoch.Cond4);
FreezeEpoch = and(CondEpoch,FreezeAccEpoch);

Vsmo = tsd(Range(Vtsd),runmean(Data((Vtsd)),10));
RunEpoch=thresholdIntervals(Vsmo,2,'Direction','Above');
RunEpoch=dropShortIntervals(RunEpoch,3*1E4);

load('SleepScoring_OBGamma.mat','REMEpoch')
save([SaveFolder 'Epochs.mat'],'RunEpoch','FreezeEpoch','REMEpoch')

AllEpoch.FreezeEpoch = FreezeEpoch;
AllEpoch.RunEpoch = RunEpoch;
AllEpoch.REMEpoch = REMEpoch;
EpochNames = fieldnames(AllEpoch);
clear FreezeEpoch RunEpoch REMEpoch


%% Get channel info on probe
load('LFPData/InfoLFP.mat')
ThetaChan = 105;
PFCxChan = 54;
OBChan = 72;
RipplesFile.R = 'Ripples2.mat';
RipplesFile.L = 'Ripples2.mat';

HPCOrderChans={[123 109 110 111 119 120 106 107 108 116 121 103 104 105 117],...
    [59 45 46 47 55 56 42 43 44 52 57 39 40],...
    [61 50 60 34 35 48 51 62 63 33 30 32],...
    [26 27 24 12 3 2 28 29 14 13 0 1 31 15 49],...
    [5 19 16 17 9 6 20 21 18 10 7 25 22 23 11],...
    [101 102 114 125 124 98 99 112 115 126 127 97 94 96],...
    [90 91 88 76 67 66 92 93 78 77 64 65 95 79 113 ],...
    [69 83 80 81 73 70 84 85 82 74 71 89 86 87 75 ]};

%% Spectrogram parameters
[params,movingwin,suffix]=SpectrumParametersML('low');

%% Load OB and PFC
load(['LFPData/LFP',num2str(OBChan),'.mat'])
LFPOB=LFP;

load(['LFPData/LFP',num2str(PFCxChan),'.mat'])
LFPPFC=LFP;

%% Get OB phase
% Options.Fs=1250; % sampling rate of LFP
% Options.FilBand=[1 20];
% Options.std=[0.5 0.2]; % std limits for first and second round of peak
% % finding
% Options.TimeLim=0.08; % in second, minimum distance between two minima or
% % two maxima, 1./TimeLim gives max detecte freq
%
% AllPeaks=FindPeaksForFrequency(LFPOB,Options,0);
% AllPeaks(:,3)=[0:pi:pi*(length(AllPeaks)-1)];
% OptionsMiniMaxi=Options;
% Y=interp1(AllPeaks(:,1),AllPeaks(:,3),Range(LFP,'s'));
% if AllPeaks(1,2)==1
%     PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
% else
%     PhaseInterpol=tsd(Range(LFP),mod(Y+pi,2*pi));
% end
%
% save([SaveFolder 'MiniMaxiLFP','Bulb','.mat'],'channel','AllPeaks','OptionsMiniMaxi','PhaseInterpol','-v7.3')


%% Get theta reference
load(['LFPData/LFP',num2str(ThetaChan),'.mat'])
LFPHPC=LFP;
LFPHPC=FilterLFP(LFPHPC,[4 12],1024);
LFPHPCHil=hilbert(Data(LFPHPC));
LFPHPCPhase=angle(LFPHPCHil);
Phasetsd_Theta = tsd(Range(LFPHPC),LFPHPCPhase);

%% Trigger HPC on breathing
LFPOB_Fil=FilterLFP(LFPOB,[2 15],1024);
LFPOBHil=hilbert(Data(LFPOB_Fil));
LFPOBPhase=angle(LFPOBHil);
Phasetsd_OB = tsd(Range(LFPOB),LFPOBPhase);

for shanknum = 1:length(HPCOrderChans)
    
    disp(['Shank number' num2str(shanknum)])
    clear AllChans HPCTrigBreath','HPCTrigTheta
    
    %% Spetrogram
    for c=1:length(HPCOrderChans{shanknum})
        
        load(['LFPData/LFP',num2str(HPCOrderChans{shanknum}(c)),'.mat'])
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        chan2=HPCOrderChans{shanknum}(c);
        
        save([SaveFolder 'Spectro_HPC',num2str(chan2),'.mat'],'Sp','t','f')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
    end
    
    %% Coherence with LFP
    for c=1:length(HPCOrderChans{shanknum})
        
        load(['LFPData/LFP',num2str(HPCOrderChans{shanknum}(c)),'.mat'])
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(LFP),movingwin,params);
        chan1=OBChan;
        chan2=HPCOrderChans{shanknum}(c);
        
        save([SaveFolder 'Cohgram_OB_HPC',num2str(chan2),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(LFP),movingwin,params);
        chan1=PFCxChan;
        chan2=HPCOrderChans{shanknum}(c);
        save([SaveFolder 'Cohgram_PFCx_HPC',num2str(chan2),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        AllChans(c,:)=Data(LFP);
    end
    
    %% Difference
    y = AllChans';
    y = y - repmat(mean(y),size(AllChans,2),1);
    d = -diff(y,1,2);
    subtraction = d;
    
    for el=1:size(subtraction,2)
        subtsd=tsd(Range(LFP),subtraction(:,el));
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(subtsd),movingwin,params);
        chan1=PFCxChan;
        chan2=el;
        save(['Cohgram_PFCx_HPCDiff_Sk',num2str(shanknum),'_El',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(subtsd),movingwin,params);
        chan1=OBChan;
        chan2=el;
        save([SaveFolder 'Cohgram_OB_HPCDiff_Sk',num2str(shanknum),'_El',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
    end
    
    %% CSD
    d = -diff(y,2,2);
    csd = d;
    
    for el=1:size(csd,2)
        ctsd=tsd(Range(LFP),csd(:,el));
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPPFC),Data(ctsd),movingwin,params);
        chan1=PFCxChan;
        chan2=el;
        save(['Cohgram_PFCx_HPCCSD_Sk',num2str(shanknum),'_El',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
        
        [C,phi,S12,S1,S2,t,f,confC,phistd]=cohgramc(Data(LFPOB),Data(ctsd),movingwin,params);
        chan1=OBChan;
        chan2=el;
        save([SaveFolder 'Cohgram_OB_HPCCSD_Sk',num2str(shanknum),'_El',num2str(el),'.mat'],'C','phi','S12','confC','t','f','chan1','chan2')
        clear C phi S12 S1 S2 t f confC phist chan1 chan2
    end
    
    clear HPCTrigBreath HPCTrigTheta
    
    for ep = 1:length(EpochNames)
        
        %% Trigger on OB
        Phasetsd_Res = Restrict(Phasetsd_OB,AllEpoch.(EpochNames{ep}));
        TopBreath = thresholdIntervals(Phasetsd_Res,3.1,'Direction','Above');
        
        for c=1:length(HPCOrderChans{shanknum})
            load(['LFPData/LFP',num2str(HPCOrderChans{shanknum}(c)),'.mat'])
            [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),500,0,0);
            HPCTrigBreath.(EpochNames{ep})(c,:)=M(:,2);
        end
        
        %% Trigger on HPC
        Phasetsd_Res = Restrict(Phasetsd_Theta,AllEpoch.(EpochNames{ep}));
        TopBreath = thresholdIntervals(Phasetsd_Res,3.1,'Direction','Above');
        
        for c=1:length(HPCOrderChans{shanknum})
            load(['LFPData/LFP',num2str(HPCOrderChans{shanknum}(c)),'.mat'])
            [M,T]=PlotRipRaw(LFP,Start(TopBreath,'s'),500,0,0);
            HPCTrigTheta.(EpochNames{ep})(c,:)=M(:,2);
        end
        
    end
    
    tps = M(:,1);
    
    save([SaveFolder ,'HPCTriggered_Sk',num2str(shanknum),'.mat'],'HPCTrigTheta','HPCTrigBreath','tps')
end