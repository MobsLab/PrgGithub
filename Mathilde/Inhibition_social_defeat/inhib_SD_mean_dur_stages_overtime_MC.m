

%% input dir 
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112 1148 1149 1150 1217 1218 1219 1220]);
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112]);

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
% DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[1075 1107 1112 1148 1149 1150 1217 1218 1219 1220]);
DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[1075 1107 1112]);

DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');



%% paramete
% st_epoch_preInj_basal = 0*1E8; %0

st_epoch_preInj = 0*1E8;
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.6*1E8;
en_epoch_postInj = 2.85*1E8;%85

tempbin = 3600;

for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
    %%load sleep scoring
    stages_basal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    
%     %pre injection
%     same_epoch{j} =  intervalSet(st_epoch_preInj_basal, en_epoch_postInj);
%     epoch_PreInj_basal{j} = intervalSet(st_epoch_preInj, en_epoch_preInj);
%     %post injection
%     epoch_PostInj_basal{j} = intervalSet(st_epoch_postInj,en_epoch_postInj);

        same_epoch{j} =  intervalSet(0.5*1e8, 3*1e8);

%         
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, rg]=Get_Mean_Dur_Num_Overtime_Basal_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'wake',tempbin);
    dur_WAKE_basal{j}=dur_moyenne_ep_WAKE;
    num_WAKE_basal{j}=num_moyen_ep_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, rg]=Get_Mean_Dur_Num_Overtime_Basal_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'sws',tempbin);
    dur_SWS_basal{j}=dur_moyenne_ep_SWS;
    num_SWS_basal{j}=num_moyen_ep_SWS;

    [dur_moyenne_ep_REM, num_moyen_ep_REM, rg]=Get_Mean_Dur_Num_Overtime_Basal_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'rem',tempbin);
    dur_REM_basal{j}=dur_moyenne_ep_REM;
    num_REM_basal{j}=num_moyen_ep_REM;
    
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_Basal_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'rem',tempbin);
    dur_TOT_REM_basal{j}=dur_TOT_moyenne_ep;
    
end
%
for imouse=1:length(dur_REM_basal)
    data_dur_TOT_REM_basal(imouse,:) = dur_TOT_REM_basal{imouse}; data_dur_TOT_REM_basal(isnan(data_dur_TOT_REM_basal)==1)=0;
    
    data_dur_REM_basal(imouse,:) = dur_REM_basal{imouse}; data_dur_REM_basal(isnan(data_dur_REM_basal)==1)=0;
    data_dur_SWS_basal(imouse,:) = dur_SWS_basal{imouse}; data_dur_SWS_basal(isnan(data_dur_SWS_basal)==1)=0;
    data_dur_WAKE_basal(imouse,:) = dur_WAKE_basal{imouse}; data_dur_WAKE_basal(isnan(data_dur_WAKE_basal)==1)=0;
    
    data_num_REM_basal(imouse,:) = num_REM_basal{imouse}; data_num_REM_basal(isnan(data_num_REM_basal)==1)=0;
    data_num_SWS_basal(imouse,:) = num_SWS_basal{imouse}; data_num_SWS_basal(isnan(data_num_SWS_basal)==1)=0;
    data_num_WAKE_basal(imouse,:) = num_WAKE_basal{imouse}; data_num_WAKE_basal(isnan(data_num_WAKE_basal)==1)=0;    
end

data_dur_TOT_REM_basal = data_dur_TOT_REM_basal(:,2:end);

data_dur_REM_basal = data_dur_REM_basal(:,2:end);
data_dur_SWS_basal = data_dur_SWS_basal(:,2:end);
data_dur_WAKE_basal = data_dur_WAKE_basal(:,2:end);

data_num_REM_basal = data_num_REM_basal(:,2:end);
data_num_SWS_basal = data_num_SWS_basal(:,2:end);
data_num_WAKE_basal = data_num_WAKE_basal(:,2:end);


%%
for i=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{i}{1});
    %%load sleep scoring
    stages_SD{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    
    %pre iniection
    same_epoch{i} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreIni_SD{i} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post iniection
    epoch_PostIni_SD{i} = intervalSet(st_epoch_postInj,en_epoch_postInj);
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'wake',tempbin);
    dur_WAKE_SD{i}=dur_moyenne_ep_WAKE;
    num_WAKE_SD{i}=num_moyen_ep_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'sws',tempbin);
    dur_SWS_SD{i}=dur_moyenne_ep_SWS;
    num_SWS_SD{i}=num_moyen_ep_SWS;

    [dur_moyenne_ep_REM, num_moyen_ep_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'rem',tempbin);
    dur_REM_SD{i}=dur_moyenne_ep_REM;
    num_REM_SD{i}=num_moyen_ep_REM;
    
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'rem',tempbin);
    dur_TOT_REM_SD{i}=dur_TOT_moyenne_ep;
    
    
    
end
%
for imouse=1:length(dur_REM_SD)
        data_dur_TOT_REM_SD(imouse,:) = dur_TOT_REM_SD{imouse}; data_dur_TOT_REM_SD(isnan(data_dur_TOT_REM_SD)==1)=0;
        
    data_dur_REM_SD(imouse,:) = dur_REM_SD{imouse}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(imouse,:) = dur_SWS_SD{imouse}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(imouse,:) = dur_WAKE_SD{imouse}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    
    data_num_REM_SD(imouse,:) = num_REM_SD{imouse}; data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(imouse,:) = num_SWS_SD{imouse}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(imouse,:) = num_WAKE_SD{imouse}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;    
end

%%
for k=1:length(DirSocialDefeat_inhibPFC.path)
    cd(DirSocialDefeat_inhibPFC.path{k}{1});
    %%load sleep scoring
    stages_SD_inhib{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    
    %pre iniection
    same_epoch{k} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreIni_SD_inhib{k} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post iniection
    epoch_PostIni_SD_inhib{k} = intervalSet(st_epoch_postInj,en_epoch_postInj);
    
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'wake',tempbin);
    dur_WAKE_SD_inhib{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SD_inhib{k}=num_moyen_ep_WAKE;

    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'sws',tempbin);
    dur_SWS_SD_inhib{k}=dur_moyenne_ep_SWS;
    num_SWS_SD_inhib{k}=num_moyen_ep_SWS;

    [dur_moyenne_ep_REM, num_moyen_ep_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'rem',tempbin);
    dur_REM_SD_inhib{k}=dur_moyenne_ep_REM;
    num_REM_SD_inhib{k}=num_moyen_ep_REM;
    
        [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'rem',tempbin);
    dur_TOT_REM_SD_inhib{k}=dur_TOT_moyenne_ep;
    
end
%
for imouse=1:length(dur_REM_SD_inhib)
        data_dur_TOT_REM_SD_inhib(imouse,:) = dur_TOT_REM_SD_inhib{imouse}; data_dur_TOT_REM_SD_inhib(isnan(data_dur_TOT_REM_SD_inhib)==1)=0;

        
    data_dur_REM_SD_inhib(imouse,:) = dur_REM_SD_inhib{imouse}; data_dur_REM_SD_inhib(isnan(data_dur_REM_SD_inhib)==1)=0;
    data_dur_SWS_SD_inhib(imouse,:) = dur_SWS_SD_inhib{imouse}; data_dur_SWS_SD_inhib(isnan(data_dur_SWS_SD_inhib)==1)=0;
    data_dur_WAKE_SD_inhib(imouse,:) = dur_WAKE_SD_inhib{imouse}; data_dur_WAKE_SD_inhib(isnan(data_dur_WAKE_SD_inhib)==1)=0;
    
    data_num_REM_SD_inhib(imouse,:) = num_REM_SD_inhib{imouse}; data_num_REM_SD_inhib(isnan(data_num_REM_SD_inhib)==1)=0;
    data_num_SWS_SD_inhib(imouse,:) = num_SWS_SD_inhib{imouse}; data_num_SWS_SD_inhib(isnan(data_num_SWS_SD_inhib)==1)=0;
    data_num_WAKE_SD_inhib(imouse,:) = num_WAKE_SD_inhib{imouse}; data_num_WAKE_SD_inhib(isnan(data_num_WAKE_SD_inhib)==1)=0;    
end

%%

%% figure

col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];


figure, subplot(311)
plot(nanmean(data_num_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_num_WAKE_basal), stdError(data_num_WAKE_basal),'color',[.5 .5 .5])
plot(nanmean(data_num_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_WAKE_SD), stdError(data_num_WAKE_SD),'color',col_SD)
plot(nanmean(data_num_WAKE_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_num_WAKE_SD_inhib), stdError(data_num_WAKE_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Number')
xlabel('Time after stress (h)')
title('WAKE')



subplot(312)
plot(nanmean(data_num_SWS_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_num_SWS_basal), stdError(data_num_SWS_basal),'color',[.5 .5 .5])
plot(nanmean(data_num_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_SWS_SD), stdError(data_num_SWS_SD),'color',col_SD)
plot(nanmean(data_num_SWS_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_num_SWS_SD_inhib), stdError(data_num_SWS_SD_inhib),'color',[.4 0 0])
% xticks([5 5 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Number')
xlabel('Time after stress (h)')
title('NREM')



subplot(313)
plot(nanmean(data_num_REM_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_num_REM_basal), stdError(data_num_REM_basal),'color',[.5 .5 .5])
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'color',col_SD)
plot(nanmean(data_num_REM_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_num_REM_SD_inhib), stdError(data_num_REM_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Number')
xlabel('Time after stress (h)')
title('REM')


%% DUR

col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];


figure, subplot(311)
plot(nanmean(data_dur_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_dur_WAKE_basal), stdError(data_dur_WAKE_basal),'color',[.5 .5 .5])
plot(nanmean(data_dur_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_WAKE_SD), stdError(data_dur_WAKE_SD),'color',col_SD)
plot(nanmean(data_dur_WAKE_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_dur_WAKE_SD_inhib), stdError(data_dur_WAKE_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Mean duration (s)')
xlabel('Time after stress (h)')
title('WAKE')



subplot(312)
plot(nanmean(data_dur_SWS_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_dur_SWS_basal), stdError(data_dur_SWS_basal),'color',[.5 .5 .5])
plot(nanmean(data_dur_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_SWS_SD), stdError(data_dur_SWS_SD),'color',col_SD)
plot(nanmean(data_dur_SWS_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_dur_SWS_SD_inhib), stdError(data_dur_SWS_SD_inhib),'color',[.4 0 0])
% xticks([5 5 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Mean duration (s)')
xlabel('Time after stress (h)')
title('NREM')



subplot(313)
plot(nanmean(data_dur_REM_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_dur_REM_basal), stdError(data_dur_REM_basal),'color',[.5 .5 .5])
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'color',col_SD)
plot(nanmean(data_dur_REM_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_dur_REM_SD_inhib), stdError(data_dur_REM_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
xlim([0 8])
makepretty
ylabel('Mean duration (s)')
xlabel('Time after stress (h)')
title('REM')


%%

% timebin = 3;
% 
% figure,subplot(325),
% MakeSpreadAndBoxPlot2_SB({data_dur_REM_basal(:,timebin), data_dur_REM_SD(:,timebin), data_dur_REM_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_REM_basal(:,timebin), data_dur_REM_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_REM_SD(:,timebin), data_dur_REM_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_REM_basal(:,timebin), data_dur_REM_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 
% 
% 
% subplot(323), MakeSpreadAndBoxPlot2_SB({data_dur_SWS_basal(:,timebin), data_dur_SWS_SD(:,timebin), data_dur_SWS_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_SWS_basal(:,timebin), data_dur_SWS_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_SWS_SD(:,timebin), data_dur_SWS_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_SWS_basal(:,timebin), data_dur_SWS_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 
% 
% subplot(321), MakeSpreadAndBoxPlot2_SB({data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD(:,timebin), data_dur_WAKE_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_WAKE_SD(:,timebin), data_dur_WAKE_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 
% 
% 
% timebin = 4;
% 
% subplot(326),
% MakeSpreadAndBoxPlot2_SB({data_dur_REM_basal(:,timebin), data_dur_REM_SD(:,timebin), data_dur_REM_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_REM_basal(:,timebin), data_dur_REM_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_REM_SD(:,timebin), data_dur_REM_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_REM_basal(:,timebin), data_dur_REM_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 
% 
% subplot(324), MakeSpreadAndBoxPlot2_SB({data_dur_SWS_basal(:,timebin), data_dur_SWS_SD(:,timebin), data_dur_SWS_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_SWS_basal(:,timebin), data_dur_SWS_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_SWS_SD(:,timebin), data_dur_SWS_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_SWS_basal(:,timebin), data_dur_SWS_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 
% subplot(322), MakeSpreadAndBoxPlot2_SB({data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD(:,timebin), data_dur_WAKE_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
% [h,p_basal_SD]=ttest(data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD(:,timebin));
% [h,p_SD_SDInhib]=ttest2(data_dur_WAKE_SD(:,timebin), data_dur_WAKE_SD_inhib(:,timebin));
% [h,p_basal_SDInhib]=ttest2(data_dur_WAKE_basal(:,timebin), data_dur_WAKE_SD_inhib(:,timebin));
% 
% if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
% if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
% if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
% 


%%



timebin = 3:8;
figure
subplot(313),
MakeSpreadAndBoxPlot2_SB({nanmean(data_dur_REM_basal(:,timebin),2), nanmean(data_dur_REM_SD(:,timebin),2), nanmean(data_dur_REM_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_dur_REM_basal(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_dur_REM_SD(:,timebin),2), nanmean(data_dur_REM_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_dur_REM_basal(:,timebin),2), nanmean(data_dur_REM_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(312), MakeSpreadAndBoxPlot2_SB({nanmean(data_dur_SWS_basal(:,timebin),2), nanmean(data_dur_SWS_SD(:,timebin),2), nanmean(data_dur_SWS_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_dur_SWS_basal(:,timebin),2),nanmean(data_dur_SWS_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_dur_SWS_SD(:,timebin),2), nanmean(data_dur_SWS_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_dur_SWS_basal(:,timebin),2), nanmean(data_dur_SWS_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

subplot(311), MakeSpreadAndBoxPlot2_SB({nanmean(data_dur_WAKE_basal(:,timebin),2), nanmean(data_dur_WAKE_SD(:,timebin),2), nanmean(data_dur_WAKE_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_dur_WAKE_basal(:,timebin),2),nanmean(data_dur_WAKE_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_dur_WAKE_SD(:,timebin),2), nanmean(data_dur_WAKE_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_dur_WAKE_basal(:,timebin),2), nanmean(data_dur_WAKE_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



%%




timebin = 5:8;
figure
subplot(313),
MakeSpreadAndBoxPlot2_SB({nanmean(data_num_REM_basal(:,timebin),2), nanmean(data_num_REM_SD(:,timebin),2), nanmean(data_num_REM_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_num_REM_basal(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_num_REM_SD(:,timebin),2), nanmean(data_num_REM_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_num_REM_basal(:,timebin),2), nanmean(data_num_REM_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(312), MakeSpreadAndBoxPlot2_SB({nanmean(data_num_SWS_basal(:,timebin),2), nanmean(data_num_SWS_SD(:,timebin),2), nanmean(data_num_SWS_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_num_SWS_basal(:,timebin),2),nanmean(data_num_SWS_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_num_SWS_SD(:,timebin),2), nanmean(data_num_SWS_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_num_SWS_basal(:,timebin),2), nanmean(data_num_SWS_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

subplot(311), MakeSpreadAndBoxPlot2_SB({nanmean(data_num_WAKE_basal(:,timebin),2), nanmean(data_num_WAKE_SD(:,timebin),2), nanmean(data_num_WAKE_SD_inhib(:,timebin),2)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(nanmean(data_num_WAKE_basal(:,timebin),2),nanmean(data_num_WAKE_SD(:,timebin),2));
[h,p_SD_SDInhib]=ttest2(nanmean(data_num_WAKE_SD(:,timebin),2), nanmean(data_num_WAKE_SD_inhib(:,timebin),2));
[h,p_basal_SDInhib]=ttest2(nanmean(data_num_WAKE_basal(:,timebin),2), nanmean(data_num_WAKE_SD_inhib(:,timebin),2));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end