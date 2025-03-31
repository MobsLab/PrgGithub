% Code Use for 11th april draft
clear all
smootime=1;
EMGmice
%% Trigger EMG on OB transitions and OB on EMG transitions
% figures per mouse
% average over mice
for mm=1:m
    mm
    cd (filename{mm,1})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi','gamma_thresh','Epoch')
    %load('StateEpochSB.mat','smooth_ghi','gamma_thresh','Epoch')


    
    %load('StateEpochEMGSB.mat','EMGData','EMG_thresh','SWSEpoch','REMEpoch','Wake')
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh')
   Wake=mergeCloseIntervals(Wake,3*1e4);
    smooth_ghi=tsd(Range(smooth_ghi),Data(smooth_ghi)-gamma_thresh); EMGData=tsd(Range(EMGData),Data(EMGData)-EMG_thresh);
    
    load('H_Low_Spectrum.mat')
    mnH=mean(Spectro{1}(:,20:end)');
    HPowtsd=tsd(Spectro{2}*1e4,runmean(mnH',ceil(smootime/median(diff(Spectro{2})))));
HPowtsd=Restrict(HPowtsd,Epoch);
    
    [aft_cell,bef_cell]=transEpoch(or(SWSEpoch,REMEpoch),Wake);
    [M,T]= PlotRipRaw(EMGData,Start(bef_cell{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    EMGWS(:,mm)=M(:,2);
    [M,T]=PlotRipRaw(EMGData,Start(bef_cell{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    EMGSW(:,mm)=M(:,2);
    
    [M,T]=PlotRipRaw(smooth_ghi,Start(bef_cell{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    GammaWS(:,mm)=M(:,2);
    [M,T]= PlotRipRaw(smooth_ghi,Start(bef_cell{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    GammaSW(:,mm)=M(:,2);
    tpsG=M(:,1);
    [M,T]=PlotRipRaw(HPowtsd,Start(bef_cell{1,2},'s'),5000*4,0,0);%beginning of all sleep that is preceded by Wake
    HPCWS(:,mm)=M(:,2);
    [M,T]= PlotRipRaw(HPowtsd,Start(bef_cell{2,1},'s'),5000*4,0,0);%beginning of all Wake  that is preceded by sleep
    HPCSW(:,mm)=M(:,2);
    tpsH=M(:,1);

end
save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGOBHPCAtGammaTransitions.mat','EMGSW','EMGWS','GammaWS','GammaSW','HPCSW','HPCSW')
figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGWS)')',500),[runmean(stdError(zscore(EMGWS)'),500);runmean(stdError(zscore(EMGWS)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaWS)')',500),[runmean(stdError(zscore(GammaWS)'),500);runmean(stdError(zscore(GammaWS)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCWS)')',1),[runmean(stdError(zscore(HPCWS)'),1);runmean(stdError(zscore(HPCWS)'),1)]','r')

figure
g=shadedErrorBar(tpsG,runmean(mean(zscore(EMGSW)')',500),[runmean(stdError(zscore(EMGSW)'),500);runmean(stdError(zscore(EMGSW)'),500)]')
hold on
g=shadedErrorBar(tpsG,runmean(mean(zscore(GammaSW)')',500),[runmean(stdError(zscore(GammaSW)'),500);runmean(stdError(zscore(GammaWS)'),500)]','b')
g=shadedErrorBar(tpsH,runmean(mean(zscore(HPCSW)')',1),[runmean(stdError(zscore(HPCSW)'),1);runmean(stdError(zscore(HPCSW)'),1)]','r')
