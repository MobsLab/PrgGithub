% % %% input dir
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline=RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1149 1150 1217 1218 1219 1220]);
% 
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149 1150]);
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1217 1218 1219 1220]);

% % % DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1148 1149]); % restrict to mice with behav resouces
% % % DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149]);

%% input dir : inhi DREADD in PFC
% %baseline sleep
% % DirBasal_KJ=PathForExperimentsAllBasalSleep('Basal');
% % DirBasal_BM=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% % DirBasal=MergePathForExperiment(DirBasal_KJ,DirBasal_BM);
% % DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% %cno
% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

%% input dir ATROPINE
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

% DirCNO = PathForExperimentsAtropine_MC('Atropine');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1105 1107 1112]);

% DirBaseline_atropine = PathForExperimentsAtropine_MC('BaselineSleep');

%%
spectro = 'dHPC_deep_Low_Spectrum.mat';
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('dHPC_deep_Low_Spectrum.mat');

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get the data
% saline condition
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %period of time
    durtotal_saline{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_saline{i} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_saline_all{i} = intervalSet(st_epoch_postInj,durtotal_saline{i});
    epoch_PostInj_saline_3h{i} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);

    %     %threshold on speed to get period of high/low activity
    %     thresh_sal{i} = a{i}.Info.mov_threshold;
    %     b{i} = load('behavResources.mat', 'MovAcctsd');
    %     thresh_sal{i} = mean(Data(b{i}.Vtsd))+std(Data(b{i}.Vtsd));
    %     highMov_sal{i} = thresholdIntervals(b{i}.MovAcctsd, thresh_sal{i}, 'Direction', 'Above');
    %     lowMov_sal{i} = thresholdIntervals(b{i}.MovAcctsd, thresh_sal{i}, 'Direction', 'Below');
    
    if exist(spectro)==2
        load(spectro);
        spectre_saline = tsd(Spectro{2}*1E4,Spectro{1});
        freq_saline = Spectro{3};
        sp_sal{i}  = spectre_saline;
        frq_sal{i}  = freq_saline;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
end

%% CNO condition
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    c{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch','Info');
    %period of time
    durtotal_cno{j} = max([max(End(c{j}.Wake)),max(End(c{j}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno{j} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_cno_all{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
    epoch_PostInj_cno_3h{j} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);

    %     %threshold on speed to get period of high/low activity
    %     thresh_CNO{j} = c{j}.Info.mov_threshold;
    %     d{j} = load('behavResources.mat', 'MovAcctsd');
    %     thresh_CNO{j} = mean(Data(d{j}.Vtsd))+std(Data(d{j}.Vtsd));
    %     highMov_CNO{j} = thresholdIntervals(d{j}.MovAcctsd, thresh_CNO{j}, 'Direction', 'Above');
    %     lowMov_CNO{j} = thresholdIntervals(d{j}.MovAcctsd, thresh_CNO{j}, 'Direction', 'Below');
    
    if exist(spectro)==2
        load(spectro);
        spectre_cno = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_cno = Spectro{3};
        temps_cno = Spectro{2};
        sp_cno{j} = spectre_cno;
        frq_cno{j} = frequence_cno;
        tps_cno{j} = temps_cno;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
end
%%
% calculate mean spectrum for each mouse
% mean saline
for i=1:length(sp_sal)
    SpectreSaline_Wake_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_BeforeInj_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PreInj_saline{i},a{i}.REMEpoch)))),1);

    SpectreSaline_Wake_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_AfterInj_all_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_all{i},a{i}.REMEpoch)))),1);
       
    SpectreSaline_Wake_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.Wake)))),1);
    SpectreSaline_SWS_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.SWSEpoch)))),1);
    SpectreSaline_REM_AfterInj_3h_mean(i,:)= nanmean(10*(Data(Restrict(sp_sal{i},and(epoch_PostInj_saline_3h{i},a{i}.REMEpoch)))),1);
   
%     % for wake with high/low activity
%     SpectreSaline_WakeLowMov_Before_mean(i,:) =  nanmean(10*(Data(Restrict(Spectro_Saline{i},and(Epoch1_Saline{i},and(WakeEp_Saline{i},lowMov_sal{i}))))),1);
%     SpectreSaline_WakeLowMov_After_mean(i,:) =  nanmean(10*(Data(Restrict(Spectro_Saline{i},and(Epoch2_Saline{i},and(WakeEp_Saline{i},lowMov_sal{i}))))),1);
%     SpectreSaline_WakeHighMov_Before_mean(i,:) =  nanmean(10*(Data(Restrict(Spectro_Saline{i},and(Epoch1_Saline{i},and(WakeEp_Saline{i},highMov_sal{i}))))),1);
%     SpectreSaline_WakeHighMov_After_mean(i,:) =  nanmean(10*(Data(Restrict(Spectro_Saline{i},and(Epoch2_Saline{i},and(WakeEp_Saline{i},highMov_sal{i}))))),1);
end
% sem saline
SpectreSaline_Wake_BeforeInj_SEM = nanstd(SpectreSaline_Wake_BeforeInj_mean)/sqrt(size(SpectreSaline_Wake_BeforeInj_mean,1));
SpectreSaline_SWS_BeforeInj_SEM = nanstd(SpectreSaline_SWS_BeforeInj_mean)/sqrt(size(SpectreSaline_SWS_BeforeInj_mean,1));
SpectreSaline_REM_BeforeInj_SEM = nanstd(SpectreSaline_REM_BeforeInj_mean)/sqrt(size(SpectreSaline_REM_BeforeInj_mean,1));

SpectreSaline_Wake_AfterInj_all_SEM = nanstd(SpectreSaline_Wake_AfterInj_all_mean)/sqrt(size(SpectreSaline_Wake_AfterInj_all_mean,1));
SpectreSaline_SWS_AfterInj_all_SEM = nanstd(SpectreSaline_SWS_AfterInj_all_mean)/sqrt(size(SpectreSaline_SWS_AfterInj_all_mean,1));
SpectreSaline_REM_AfterInj_all_SEM = nanstd(SpectreSaline_REM_AfterInj_all_mean)/sqrt(size(SpectreSaline_REM_AfterInj_all_mean,1));

SpectreSaline_Wake_AfterInj_3h_SEM = nanstd(SpectreSaline_Wake_AfterInj_3h_mean)/sqrt(size(SpectreSaline_Wake_AfterInj_3h_mean,1));
SpectreSaline_SWS_AfterInj_3h_SEM = nanstd(SpectreSaline_SWS_AfterInj_3h_mean)/sqrt(size(SpectreSaline_SWS_AfterInj_3h_mean,1));
SpectreSaline_REM_AfterInj_3h_SEM = nanstd(SpectreSaline_REM_AfterInj_3h_mean)/sqrt(size(SpectreSaline_REM_AfterInj_3h_mean,1));

% % for wake with high/low activity
% SpectreSaline_WakeLowMov_Before_SEM = nanstd(SpectreSaline_WakeLowMov_Before_mean)/sqrt(size(SpectreSaline_WakeLowMov_Before_mean,1));
% SpectreSaline_WakeLowMov_After_SEM = nanstd(SpectreSaline_WakeLowMov_After_mean)/sqrt(size(SpectreSaline_WakeLowMov_After_mean,1));
% SpectreSaline_WakeHighMov_Before_SEM = nanstd(SpectreSaline_WakeHighMov_Before_mean)/sqrt(size(SpectreSaline_WakeHighMov_Before_mean,1));
% SpectreSaline_WakeHighMov_After_SEM = nanstd(SpectreSaline_WakeHighMov_After_mean)/sqrt(size(SpectreSaline_WakeHighMov_After_mean,1));

%%
% mean CNO
for j=1:length(sp_cno)
    if isempty(sp_cno{j})==0
        
            SpectreCNO_mean(j,:)= nanmean(10*(Data(sp_cno{j})),1); SpectreCNO_mean(SpectreCNO_mean==0)=NaN;

    SpectreCNO_Wake_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.Wake)))),1); SpectreCNO_Wake_BeforeInj_mean(SpectreCNO_Wake_BeforeInj_mean==0)=NaN;
        SpectreCNO_SWS_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_BeforeInj_mean(SpectreCNO_SWS_BeforeInj_mean==0)=NaN;
    SpectreCNO_REM_BeforeInj_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PreInj_cno{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_BeforeInj_mean(SpectreCNO_REM_BeforeInj_mean==0)=NaN;

    SpectreCNO_Wake_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.Wake)))),1); SpectreCNO_Wake_AfterInj_all_mean(SpectreCNO_Wake_AfterInj_all_mean==0)=NaN;
    SpectreCNO_SWS_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_AfterInj_all_mean(SpectreCNO_SWS_AfterInj_all_mean==0)=NaN;
    SpectreCNO_REM_AfterInj_all_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_all{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_AfterInj_all_mean(SpectreCNO_REM_AfterInj_all_mean==0)=NaN;
    
        SpectreCNO_Wake_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.Wake)))),1); SpectreCNO_Wake_AfterInj_3h_mean(SpectreCNO_Wake_AfterInj_3h_mean==0)=NaN;
    SpectreCNO_SWS_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.SWSEpoch)))),1); SpectreCNO_SWS_AfterInj__3h_mean(SpectreCNO_SWS_AfterInj_3h_mean==0)=NaN;
    SpectreCNO_REM_AfterInj_3h_mean(j,:)= nanmean(10*(Data(Restrict(sp_cno{j},and(epoch_PostInj_cno_3h{j},c{j}.REMEpoch)))),1); SpectreCNO_REM_AfterInj_3h_mean(SpectreCNO_REM_AfterInj_3h_mean==0)=NaN;
    
    else
    end
    
% %     % for wake with high/low activity
%     SpectreCNO_WakeLowMov_Before_mean(j,:) =  nanmean(10*(Data(Restrict(Spectro_CNO{j},and(Epoch1_CNO{j},and(WakeEp_CNO{j},lowMov_CNO{j}))))),1);
%     SpectreCNO_WakeLowMov_After_mean(j,:) =  nanmean(10*(Data(Restrict(Spectro_CNO{j},and(Epoch2_CNO{j},and(WakeEp_CNO{j},lowMov_CNO{j}))))),1);
%     SpectreCNO_WakeHighMov_Before_mean(j,:) =  nanmean(10*(Data(Restrict(Spectro_CNO{j},and(Epoch1_CNO{j},and(WakeEp_CNO{j},highMov_CNO{j}))))),1);
%     SpectreCNO_WakeHighMov_After_mean(j,:) =  nanmean(10*(Data(Restrict(Spectro_CNO{j},and(Epoch2_CNO{j},and(WakeEp_CNO{j},highMov_CNO{j}))))),1);
end
% sem CNO
SpectreCNO_Wake_BeforeInj_SEM = nanstd(SpectreCNO_Wake_BeforeInj_mean)/sqrt(size(SpectreCNO_Wake_BeforeInj_mean,1));
SpectreCNO_SWS_BeforeInj_SEM = nanstd(SpectreCNO_SWS_BeforeInj_mean)/sqrt(size(SpectreCNO_SWS_BeforeInj_mean,1));
SpectreCNO_REM_BeforeInj_SEM = nanstd(SpectreCNO_REM_BeforeInj_mean)/sqrt(size(SpectreCNO_REM_BeforeInj_mean,1));

SpectreCNO_Wake_AfterInj_all_SEM = nanstd(SpectreCNO_Wake_AfterInj_all_mean)/sqrt(size(SpectreCNO_Wake_AfterInj_all_mean,1));
SpectreCNO_SWS_AfterInj_all_SEM = nanstd(SpectreCNO_SWS_AfterInj_all_mean)/sqrt(size(SpectreCNO_SWS_AfterInj_all_mean,1));
SpectreCNO_REM_AfterInj_all_SEM = nanstd(SpectreCNO_REM_AfterInj_all_mean)/sqrt(size(SpectreCNO_REM_AfterInj_all_mean,1));

SpectreCNO_Wake_AfterInj_3h_SEM = nanstd(SpectreCNO_Wake_AfterInj_3h_mean)/sqrt(size(SpectreCNO_Wake_AfterInj_3h_mean,1));
SpectreCNO_SWS_AfterInj_3h_SEM = nanstd(SpectreCNO_SWS_AfterInj_3h_mean)/sqrt(size(SpectreCNO_SWS_AfterInj_3h_mean,1));
SpectreCNO_REM_AfterInj_3h_SEM = nanstd(SpectreCNO_REM_AfterInj_3h_mean)/sqrt(size(SpectreCNO_REM_AfterInj_3h_mean,1));
% % for wake with high/low activity
% SpectreCNO_WakeLowMov_Before_SEM = nanstd(SpectreCNO_WakeLowMov_Before_mean)/sqrt(size(SpectreCNO_WakeLowMov_Before_mean,1));
% SpectreCNO_WakeLowMov_After_SEM = nanstd(SpectreCNO_WakeLowMov_After_mean)/sqrt(size(SpectreCNO_WakeLowMov_After_mean,1));
% SpectreCNO_WakeHighMov_Before_SEM = nanstd(SpectreCNO_WakeHighMov_Before_mean)/sqrt(size(SpectreCNO_WakeHighMov_Before_mean,1));
% SpectreCNO_WakeHighMov_After_SEM = nanstd(SpectreCNO_WakeHighMov_After_mean)/sqrt(size(SpectreCNO_WakeHighMov_After_mean,1));

%% figures
%% saline VS cno for each stage
figure,
ax(1)=subplot(4,6,7), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'r',1);
ylabel('Power (a.u)')
title('WAKE pre')
makepretty
ax(2)=subplot(4,6,8), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'r',1);
title('NREM pre')
makepretty
ax(3)=subplot(4,6,9), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r',1);
title('REM pre')
makepretty

ax(4)=subplot(4,6,13), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'r',1);
title('WAKE post')
ylabel('Power (a.u)')
makepretty
ax(5)=subplot(4,6,14), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'r',1);
title('NREM post')
makepretty
ax(6)=subplot(4,6,15), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
title('REM post')
makepretty

ax(7)=subplot(4,6,19), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'r',1);
title('WAKE 3h post')
xlabel('Frequency(Hz)')
ylabel('Power (a.u)')
makepretty
ax(8)=subplot(4,6,20), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'r',1);
xlabel('Frequency(Hz)')
title('NREM 3h post')
makepretty
ax(9)=subplot(4,6,21), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
xlabel('Frequency(Hz)')
title('REM 3h post')
makepretty

ax(10)=subplot(4,6,4), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'r',1);
title('pre saline')
makepretty

ax(11)=subplot(4,6,5), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'r',1);
title('post saline')
makepretty

ax(12)=subplot(4,6,6), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'r',1);
title('3h post saline')
makepretty


ax(13)=subplot(4,6,10), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r',1);
title('pre atropine')
makepretty

ax(14)=subplot(4,6,11), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
title('post atropine')
makepretty

ax(15)=subplot(4,6,12), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
title('3h post atropine')
makepretty


ax(16)=subplot(4,6,16),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean), SpectreSaline_Wake_BeforeInj_SEM,'k:',1);hold on
% shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean), SpectreSaline_Wake_AfterInj_all_SEM,'k',1);
s1=shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean), SpectreSaline_Wake_AfterInj_3h_SEM,'k',1);
title('WAKE- saline')
makepretty
%sws saline
ax(17)=subplot(4,6,17),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean), SpectreSaline_SWS_BeforeInj_SEM,'b:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean), SpectreSaline_SWS_AfterInj_all_SEM,'b',1);
 shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean), SpectreSaline_SWS_AfterInj_3h_SEM,'b',1);
 title('NREM - saline')
makepretty
% rem saline
ax(18)=subplot(4,6,18), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean), SpectreSaline_REM_BeforeInj_SEM,'r:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean), SpectreSaline_REM_AfterInj_all_SEM,'r',1);
  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean), SpectreSaline_REM_AfterInj_3h_SEM,'r',1);
  title('REM - saline')
makepretty
%wake cno
ax(19)=subplot(4,6,22),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean), SpectreCNO_Wake_BeforeInj_SEM,'k:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean), SpectreCNO_Wake_AfterInj_all_SEM,'k',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean), SpectreCNO_Wake_AfterInj_3h_SEM,'k',1);
title('WAKE - atropine')
makepretty
xlabel('Frequency (Hz)')
%sws cno
ax(20)=subplot(4,6,23),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean), SpectreCNO_SWS_BeforeInj_SEM,'b:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj__all_mean), SpectreCNO_SWS_AfterInj_all_SEM,'b',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean), SpectreCNO_SWS_AfterInj_3h_SEM,'b',1);
title('NREM - atropine')
makepretty
xlabel('Frequency (Hz)')
%rem cno
ax(21)=subplot(4,6,24),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean), SpectreCNO_REM_BeforeInj_SEM,'r:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean), SpectreCNO_REM_AfterInj_all_SEM,'r',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean), SpectreCNO_REM_AfterInj_3h_SEM,'r',1);
makepretty
title('REM - atropine')
xlabel('Frequency (Hz)')

set(ax,'xlim',[0 15], 'ylim',[0 1e6])
% set(ax,'xlim',[20 100], 'ylim',[0 1.2e5])



%% individual trace
figure,
ax1=subplot(331),plot(frq_sal{1}, SpectreSaline_Wake_BeforeInj_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_Wake_BeforeInj_mean,'r');
xlabel('Frequency(Hz)')
title('Wake pre')
ylabel('Power (a.u)')
% makepretty
ax1(2)=subplot(332), plot(frq_sal{1}, SpectreSaline_SWS_BeforeInj_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_SWS_BeforeInj_mean,'r');
xlabel('Frequency(Hz)')
title('NREM pre')
% makepretty
ax1(3)=subplot(333), plot(frq_sal{1}, SpectreSaline_REM_BeforeInj_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_REM_BeforeInj_mean,'r');
xlabel('Frequency(Hz)')
title('REM pre')
% makepretty
ax1(4)=subplot(334), plot(frq_sal{1}, SpectreSaline_Wake_AfterInj_all_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_Wake_AfterInj_all_mean,'r');
xlabel('Frequency(Hz)')
title('Wake post')
ylabel('Power (a.u)')

% makepretty
ax1(5)=subplot(335), plot(frq_sal{1}, SpectreSaline_SWS_AfterInj_all_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_SWS_AfterInj_all_mean,'r');
xlabel('Frequency(Hz)')
title('NREM post')
% makepretty
ax1(6)=subplot(336), plot(frq_sal{1}, SpectreSaline_REM_AfterInj_all_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_REM_AfterInj_all_mean,'r');
xlabel('Frequency(Hz)')
title('REM post')
% makepretty



ax1(4)=subplot(337), plot(frq_sal{1}, SpectreSaline_Wake_AfterInj_3h_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_Wake_AfterInj_3h_mean,'r');
xlabel('Frequency(Hz)')
title('Wake post')
ylabel('Power (a.u)')

% makepretty
ax1(5)=subplot(338), plot(frq_sal{1}, SpectreSaline_SWS_AfterInj_3h_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_SWS_AfterInj_3h_mean,'r');
xlabel('Frequency(Hz)')
title('NREM post')
% makepretty
ax1(6)=subplot(339), plot(frq_sal{1}, SpectreSaline_REM_AfterInj_3h_mean,'k'); hold on
plot(frq_cno{1}, SpectreCNO_REM_AfterInj_3h_mean,'r');
xlabel('Frequency(Hz)')
title('REM post')


% set(ax1,'xlim',[0 15], 'ylim',[0 2.5e6])
set(ax,'xlim',[20 100], 'ylim',[0 1.2e5])



%%
% 
% figure
% ax(1)=subplot(221), plot(frq_sal{1}, SpectreSaline_Wake_BeforeInj_mean,'k'); hold on
% plot(frq_sal{1}, SpectreSaline_SWS_BeforeInj_mean,'b');
% plot(frq_sal{1}, SpectreSaline_REM_BeforeInj_mean,'r');
% xlabel('Frequency (Hz)')
% ylabel('Power (a.u)')
% title('pre saline')
% makepretty
% 
% ax(2)=subplot(222), plot(frq_sal{1}, SpectreSaline_Wake_AfterInj_all_mean,'k'); hold on
% plot(frq_sal{1}, SpectreSaline_SWS_AfterInj_all_mean,'b');
% plot(frq_sal{1}, SpectreSaline_REM_AfterInj_all_mean,'r');
% xlabel('Frequency (Hz)')
% ylabel('Power (a.u)')
% title('post saline')
% makepretty
% 
% ax(3)=subplot(223), plot(frq_sal{1}, SpectreCNO_Wake_BeforeInj_mean,'k'); hold on
% plot(frq_sal{1}, SpectreCNO_SWS_BeforeInj_mean,'b');
% plot(frq_sal{1}, SpectreCNO_REM_BeforeInj_mean,'r');
% xlabel('Frequency (Hz)')
% ylabel('Power (a.u)')
% title('pre CNO')
% makepretty
% 
% ax(4)=subplot(224), plot(frq_sal{1}, SpectreCNO_Wake_AfterInj_all_mean,'k'); hold on
% plot(frq_sal{1}, SpectreCNO_SWS_AfterInj_all_mean,'b');
% plot(frq_sal{1}, SpectreCNO_REM_AfterInj_all_mean,'r');
% xlabel('Frequency (Hz)')
% ylabel('Power (a.u)')
% title('post CNO')
% makepretty
% % 
% % set(ax,'xlim',[0 15], 'ylim',[0 3e6])
% 
% %%
% %wake saline
% figure,
% ax(1)=subplot(231),plot(frq_sal{1}, SpectreSaline_Wake_BeforeInj_mean,'k:','linewidth',2);hold on
% plot(frq_sal{1}, SpectreSaline_Wake_AfterInj_all_mean,'k');
% makepretty
% ylabel('Power (A.U)')
% %sws saline
% ax(2)=subplot(232),plot(frq_sal{1}, SpectreSaline_SWS_BeforeInj_mean,'b:','linewidth',2);hold on
%  plot(frq_sal{1}, SpectreSaline_SWS_AfterInj_all_mean,'b');
% makepretty
% % rem saline
% ax(3)=subplot(233), plot(frq_sal{1}, SpectreSaline_REM_BeforeInj_mean,'r:','linewidth',2);hold on
%  plot(frq_sal{1}, SpectreSaline_REM_AfterInj_all_mean,'r');
% makepretty
% %wake cno
% ax(4)=subplot(234),plot(frq_cno{1}, SpectreCNO_Wake_BeforeInj_mean,'k:','linewidth',2);hold on
% plot(frq_cno{1}, SpectreCNO_Wake_AfterInj_all_mean,'k');
% makepretty
% xlabel('Frequency (Hz)')
% ylabel('Power (A.U)')
% %sws cno
% ax(5)=subplot(235),plot(frq_cno{1}, SpectreCNO_SWS_BeforeInj_mean,'b:','linewidth',2);hold on
% plot(frq_cno{1}, SpectreCNO_SWS_AfterInj_all_mean,'b');
% makepretty
% xlabel('Frequency (Hz)')
% %rem cno
% ax(6)=subplot(236),plot(frq_cno{1}, SpectreCNO_REM_BeforeInj_mean,'r:','linewidth',2);hold on
% plot(frq_cno{1}, SpectreCNO_REM_AfterInj_all_mean,'r');
% makepretty
% xlabel('Frequency (Hz)')
% 
% set(ax,'xlim',[0 15], 'ylim',[0 1e6])