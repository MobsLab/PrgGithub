% Code Use for 11th april draft
clear all

EMGMice
%% Trigger EMG on OB transitions and OB on EMG transitions
% figures per mouse
% average over mice
for mm=1:m
    mm
    cd (filename{mm,1})
    load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake','smooth_ghi','gamma_thresh')
    Wake=mergeCloseIntervals(Wake,3*1e4);
    smooth_ghi=tsd(Range(smooth_ghi),Data(smooth_ghi)-gamma_thresh);
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh')
    EMGData=tsd(Range(EMGData),Data(EMGData)-EMG_thresh);
    
    [aft_cell,bef_cell]=transEpoch(Or(SWSEpoch,REMEpoch),Wake);
    [M,T]= PlotRipRaw(EMGData,Start(bef_cell{1,2},'s'),5000*4);%beginning of all sleep that is preceded by Wake
    EMGWS(:,mm)=M(:,2);
    [M,T]=PlotRipRaw(EMGData,Start(bef_cell{2,1},'s'),5000*4);%beginning of all Wake  that is preceded by sleep
    EMGSW(:,mm)=M(:,2);
    
    [M,T]=PlotRipRaw(smooth_ghi,Start(bef_cell{1,2},'s'),5000*4);%beginning of all sleep that is preceded by Wake
    GammaWS(:,mm)=M(:,2);
    [M,T]= PlotRipRaw(smooth_ghi,Start(bef_cell{2,1},'s'),5000*4);%beginning of all Wake  that is preceded by sleep
    GammaSW(:,mm)=M(:,2);
    close all
end
save('/media/DataMOBSSlSc/SleepScoringMice/AnalysisResults/EMGOBAtTransitions.mat','EMGSW','EMGWS','GammaWS','GammaSW')
figure
g=shadedErrorBar(M(:,1),runmean(mean(zscore(EMGWS)')',500),[runmean(stdError(zscore(EMGWS)'),500);runmean(stdError(zscore(EMGWS)'),500)]')
hold on
g=shadedErrorBar(M(:,1),runmean(mean(zscore(GammaWS)')',500),[runmean(stdError(zscore(GammaWS)'),500);runmean(stdError(zscore(GammaWS)'),500)]','b')

figure
g=shadedErrorBar(M(:,1),runmean(mean(zscore(EMGSW)')',500),[runmean(stdError(zscore(EMGSW)'),500);runmean(stdError(zscore(EMGSW)'),500)]')
hold on
g=shadedErrorBar(M(:,1),runmean(mean(zscore(GammaSW)')',500),[runmean(stdError(zscore(GammaSW)'),500);runmean(stdError(zscore(GammaWS)'),500)]','b')
