%% Comparison RespiratoryRythmFromSpectrum_BM and GetInstPhaseAndFreq_EmbReact_SB using plethysmo
clear all

Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
cd(Dir.path{1})

for mouse=1:length(Dir.path)-1
    
    cd(Dir.path{mouse})
    
    load('B_Low_Spectrum.mat')
    load('BreathingInfo.mat')
    load('InstFreqAndPhase_B.mat', 'LocalFreq')
    
    clear Respi_BM
    Respi_BM=RespiratoryRythmFromSpectrum_BM(Spectro{1});
    Respi_BM=tsd(Spectro{2}'*1e4,Respi_BM');
    
    load('behavResources.mat')
    Respi_BM_Fz=Restrict(Respi_BM,FreezeEpoch);
    Frequecytsd_Fz=Restrict(Frequecytsd,FreezeEpoch);
    LocalFreqPT_Fz=Restrict(LocalFreq.PT,FreezeEpoch);
    
    RespiMeanValuesFz(mouse,1)=mean(Data(Frequecytsd_Fz));
    RespiMeanValuesFz(mouse,2)=nanmean(Data(Respi_BM_Fz));
    RespiMeanValuesFz(mouse,3)=mean(Data(LocalFreqPT_Fz));
      
    TotalEpoch = intervalSet(0,max(Range(Movtsd)));
    Non_FreezingEpoch=TotalEpoch-FreezeEpoch;
    
    Respi_BM_NoFz=Restrict(Respi_BM,Non_FreezingEpoch);
    Frequecytsd_NoFz=Restrict(Frequecytsd,Non_FreezingEpoch);
    LocalFreqPT_NoFz=Restrict(LocalFreq.PT,Non_FreezingEpoch);
    
    RespiMeanValuesNoFz(mouse,1)=mean(Data(Frequecytsd_NoFz));
    RespiMeanValuesNoFz(mouse,2)=nanmean(Data(Respi_BM_NoFz));
    RespiMeanValuesNoFz(mouse,3)=mean(Data(LocalFreqPT_NoFz));
    
    % Difference study
    Respi_BM = Restrict(Respi_BM,ts(Range(Frequecytsd)));
    LocalFreq.PT = Restrict(LocalFreq.PT,ts(Range(Frequecytsd)));
    
    clear SubstractionArray
    SubstractionArray(:,1)=abs(Data(Frequecytsd)-Data(Respi_BM ));
    SubstractionArray(:,2)=abs(Data(Frequecytsd)-Data(LocalFreq.PT ));
    SubstractionArrayFig(mouse,1)=nanmean(SubstractionArray(:,1));
    SubstractionArrayFig(mouse,2)=nanmean(SubstractionArray(:,2));
    
end

% Plotting the differents curves
figure
subplot(311)
plot(Range(Frequecytsd,'s'),Data(Frequecytsd))
title('Plethysmo')

subplot(312)
plot(Range(Respi_BM,'s'),Data(Respi_BM))
title('RespiratoryRythmFromSpectrum BM')
yticks([0 64 131 196 261])
yticklabels({'0','5','10','15','20'})
ylim([0 261])

subplot(313)
plot(Range(LocalFreq.PT,'s'),Data(LocalFreq.PT))
title('InstFreq')

% Plotting mean values
PlotErrorBarN_KJ(RespiMeanValuesFz)
xticks([1 2 3])
xticklabels({'Plethysmo','RRFromSpectrum BM','InstFreq'})
makepretty
xtickangle(45)
title('mean respiratory rate values while freezing')

PlotErrorBarN_KJ(RespiMeanValuesNoFz)
xticks([1 2 3])
xticklabels({'Plethysmo','RRFromSpectrum BM','InstFreq'})
makepretty
xtickangle(45)
title('mean respiratory rate values while active')


PlotErrorBarN_KJ(SubstractionArrayFig)

%% while sleeping 

Sess{1}='/media/nas4/ProjetMTZL/Mouse794/20181121/M794_SleepAfternoonPleythsmo_181121_143653';
Sess{2}='/media/nas4/ProjetMTZL/Mouse794/20181123/M794_SleepPlethysmo_181123_090246/';
Sess{3}='/media/nas4/ProjetMTZL/Mouse794/20181126/M794_SLeepPlethysmo_181126_091803';
Sess{4}='/media/nas4/ProjetMTZL/Mouse776/23102018';
Sess{5}='/media/nas4/ProjetMTZL/Mouse775/17102018/M775_SleepPlethysmo_181017_103647';
Sess{6}='/media/nas4/ProjetMTZL/Mouse779/20181005/M779_Plethysmo_181005_092219';


for mouse=1:length(Sess)

    cd(Sess{mouse})
    
    load('B_Low_Spectrum.mat')
    load('BreathingInfo.mat')
    load('InstFreqAndPhase_B.mat', 'LocalFreq')
    
    clear Respi_BM
    Respi_BM=RespiratoryRythmFromSpectrum_BM(Spectro{1});
    Respi_BM=tsd(Spectro{2}'*1e4,Respi_BM');
    
    load('SleepSubstages.mat')
    Respi_BM_Sleep=Restrict(Respi_BM,Epoch{10});
    Frequecytsd_Sleep=Restrict(Frequecytsd,Epoch{10});
    LocalFreqPT_Sleep=Restrict(LocalFreq.PT,Epoch{10});
    
    RespiMeanValuesSleep(mouse,1)=mean(Data(Frequecytsd_Sleep));
    RespiMeanValuesSleep(mouse,2)=nanmean(Data(Respi_BM_Sleep));
    RespiMeanValuesSleep(mouse,3)=mean(Data(LocalFreqPT_Sleep));
    
    Respi_BM_Wake=Restrict(Respi_BM,Epoch{5});
    Frequecytsd_Wake=Restrict(Frequecytsd,Epoch{5});
    LocalFreqPT_Wake=Restrict(LocalFreq.PT,Epoch{5});
    
    RespiMeanValuesWake(mouse,1)=mean(Data(Frequecytsd_Wake));
    RespiMeanValuesWake(mouse,2)=nanmean(Data(Respi_BM_Wake));
    RespiMeanValuesWake(mouse,3)=mean(Data(LocalFreqPT_Wake));
  
end

% Plot
PlotErrorBarN_KJ(RespiMeanValuesSleep)
xticks([1 2 3])
xticklabels({'Plethysmo','RRFromSpectrum BM','InstFreq'}) 
makepretty
xtickangle(45)
title('mean respiratory rate values while sleeping')

PlotErrorBarN_KJ(RespiMeanValuesWake)
xticks([1 2 3])
xticklabels({'Plethysmo','RRFromSpectrum BM','InstFreq'})
makepretty
xtickangle(45)
title('mean respiratory rate values while awake')


% Difference study
Respi_BM = Restrict(Respi_BM,ts(Range(Frequecytsd)));
LocalFreq.PT = Restrict(LocalFreq.PT,ts(Range(Frequecytsd)));

SubstractionArray(:,1)=abs(Data(Frequecytsd)-Data(Respi_BM ));
SubstractionArray(:,2)=abs(Data(Frequecytsd)-Data(LocalFreq.PT ));
SubstractionArrayFig(1)=nanmean(SubstractionArray(:,1));
SubstractionArrayFig(2)=nanmean(SubstractionArray(:,2));

figure
bar(SubstractionArrayFig)
