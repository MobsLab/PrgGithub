%% input dir : DO NOT CHANGE THIS

% DirControl1 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am'); 
% DirSocialDefeat1 = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_CNOInjection_10am');
% 
% % DirControl = PathForExperimentsSD_MC('SleepPostSD'); 
% % DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibDREADD_PFC_CNOInjection');
% 
% DirControl2 = PathForExperiments_DREADD_MC('noDREADD_SalineInjection_10am'); 
% DirSocialDefeat2 = PathForExperiments_DREADD_MC('noDREADD_CNOInjection_10am');
% 
% DirControl = MergePathForExperiment(DirControl1, DirControl2);
% DirSocialDefeat = MergePathForExperiment(DirSocialDefeat1, DirSocialDefeat2);
% 

DirControl=PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_SalineInjection_10am');
DirSocialDefeat = PathForExperiments_DREADD_MC('mCherry_retroCre_PFC_VLPO_CNOInjection_10am');


%%
% inhib_PFC_VLPO_SD_SleepStages_Overtime_MC.m
% inhib_SD_mean_dur_stages_overtime_MC.m
% inhib_PFC_VLPO_SD_transitionProba_overtime_MC_VF.m

%% parameters
st_record = 0*1E8;
en_record = 2.85*1E8;

tempbin = 3600;

%% GET DATA
%%Control group
for j=1:length(DirControl.path)
    cd(DirControl.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_control{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_control{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    durtotal_control{j} = max([max(End(stages_control{j}.Wake)),max(End(stages_control{j}.SWSEpoch))]);
    same_epoch{j} =  intervalSet(st_record, en_record);

    %%compute stages density/percentage
    D_WAKE_control=DensitySleepStage_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'wake',3600);
    density_WAKE_saline{j}=D_WAKE_control;
    D_SWS_control=DensitySleepStage_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'sws',3600);
    density_SWS_saline{j}=D_SWS_control;
    D_REM_control=DensitySleepStage_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'rem',3600);
    density_REM_saline{j}=D_REM_control;
    
    %%compute mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'wake',tempbin);
    dur_WAKE_control{j}=dur_moyenne_ep_WAKE;
    num_WAKE_control{j}=num_moyen_ep_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'sws',tempbin);
    dur_SWS_control{j}=dur_moyenne_ep_SWS;
    num_SWS_control{j}=num_moyen_ep_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'rem',tempbin);
    dur_REM_control{j}=dur_moyenne_ep_REM;
    num_REM_control{j}=num_moyen_ep_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),'rem',tempbin);
    dur_TOT_REM_control{j}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_control{j}.Wake,same_epoch{j}),and(stages_control{j}.SWSEpoch,same_epoch{j}),and(stages_control{j}.REMEpoch,same_epoch{j}),tempbin);
    all_trans_REM_REM_control{j} = trans_REM_to_REM;
    all_trans_REM_SWS_control{j} = trans_REM_to_SWS;
    all_trans_REM_WAKE_control{j} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_control{j} = trans_SWS_to_REM;
    all_trans_SWS_SWS_control{j} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_control{j} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_control{j} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_control{j} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_control{j} = trans_WAKE_to_WAKE;
end

%%percentage
for imouse=1:length(density_REM_saline)
    data_density_REM_control(imouse,:) = Data(density_REM_saline{imouse});
    data_density_SWS_control(imouse,:) = Data(density_SWS_saline{imouse});
    data_density_WAKE_control(imouse,:) = Data(density_WAKE_saline{imouse});
end

%%duration/number
for imouse=1:length(dur_REM_control)
    data_dur_TOT_REM_control(imouse,:) = dur_TOT_REM_control{imouse}; data_dur_TOT_REM_control(isnan(data_dur_TOT_REM_control)==1)=0;
    
    data_dur_REM_control(imouse,:) = dur_REM_control{imouse}; data_dur_REM_control(isnan(data_dur_REM_control)==1)=0;
    data_dur_SWS_control(imouse,:) = dur_SWS_control{imouse}; data_dur_SWS_control(isnan(data_dur_SWS_control)==1)=0;
    data_dur_WAKE_control(imouse,:) = dur_WAKE_control{imouse}; data_dur_WAKE_control(isnan(data_dur_WAKE_control)==1)=0;
    
    data_num_REM_control(imouse,:) = num_REM_control{imouse}; data_num_REM_control(isnan(data_num_REM_control)==1)=0;
    data_num_SWS_control(imouse,:) = num_SWS_control{imouse}; data_num_SWS_control(isnan(data_num_SWS_control)==1)=0;
    data_num_WAKE_control(imouse,:) = num_WAKE_control{imouse}; data_num_WAKE_control(isnan(data_num_WAKE_control)==1)=0;
end

%%probability
for imouse=1:length(all_trans_REM_REM_control)
    data_REM_REM_control(imouse,:) = all_trans_REM_REM_control{imouse}; data_REM_REM_control(isnan(data_REM_REM_control)==1)=0;
    data_REM_SWS_control(imouse,:) = all_trans_REM_SWS_control{imouse}; data_REM_SWS_control(isnan(data_REM_SWS_control)==1)=0;
    data_REM_WAKE_control(imouse,:) = all_trans_REM_WAKE_control{imouse}; data_REM_WAKE_control(isnan(data_REM_WAKE_control)==1)=0;
    
    data_SWS_SWS_control(imouse,:) = all_trans_SWS_SWS_control{imouse}; data_SWS_SWS_control(isnan(data_SWS_SWS_control)==1)=0;
    data_SWS_REM_control(imouse,:) = all_trans_SWS_REM_control{imouse}; data_SWS_REM_control(isnan(data_SWS_REM_control)==1)=0;
    data_SWS_WAKE_control(imouse,:) = all_trans_SWS_WAKE_control{imouse}; data_SWS_WAKE_control(isnan(data_SWS_WAKE_control)==1)=0;
    
    data_WAKE_WAKE_control(imouse,:) = all_trans_WAKE_WAKE_control{imouse}; data_WAKE_WAKE_control(isnan(data_WAKE_WAKE_control)==1)=0;
    data_WAKE_REM_control(imouse,:) = all_trans_WAKE_REM_control{imouse}; data_WAKE_REM_control(isnan(data_WAKE_REM_control)==1)=0;
    data_WAKE_SWS_control(imouse,:) = all_trans_WAKE_SWS_control{imouse}; data_WAKE_SWS_control(isnan(data_WAKE_SWS_control)==1)=0;
end


%% Social defeat group
for k=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{k}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_SD{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_SD{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    durtotal_SD{k} = max([max(End(stages_SD{k}.Wake)),max(End(stages_SD{k}.SWSEpoch))]);
    same_epoch{k} =  intervalSet(st_record, en_record);
    
    %%compute stages density/percentage
    D_WAKE_atropine=DensitySleepStage_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'wake',3600);
    density_WAKE_SD{k}=D_WAKE_atropine;
    D_SWS_atropine=DensitySleepStage_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'sws',3600);
    density_SWS_SD{k}=D_SWS_atropine;
    D_REM_atropine=DensitySleepStage_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'rem',3600);
    density_REM_SD{k}=D_REM_atropine;
    
    %%compute mean duration and number of bouts
    [dur_moyenne_ep_WAKE, num_moyen_ep_WAKE, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'wake',tempbin);
    dur_WAKE_SD{k}=dur_moyenne_ep_WAKE;
    num_WAKE_SD{k}=num_moyen_ep_WAKE;
    
    [dur_moyenne_ep_SWS, num_moyen_ep_SWS, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'sws',tempbin);
    dur_SWS_SD{k}=dur_moyenne_ep_SWS;
    num_SWS_SD{k}=num_moyen_ep_SWS;
    
    [dur_moyenne_ep_REM, num_moyen_ep_REM, rg]=Get_Mean_Dur_Num_Overtime_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'rem',tempbin);
    dur_REM_SD{k}=dur_moyenne_ep_REM;
    num_REM_SD{k}=num_moyen_ep_REM;
    
    [dur_TOT_moyenne_ep, rg]=Get_Mean_Dur_TOTALE_Overtime_MC(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),'rem',tempbin);
    dur_TOT_REM_SD{k}=dur_TOT_moyenne_ep;
    
    %%compute transition probabilities
    [trans_REM_to_REM, trans_REM_to_SWS, trans_REM_to_WAKE, trans_SWS_to_REM, trans_SWS_to_SWS, trans_SWS_to_WAKE, trans_WAKE_to_REM, trans_WAKE_to_SWS, trans_WAKE_to_WAKE]=...
        Get_proba_timebins_Overtime_MC_VF(and(stages_SD{k}.Wake,same_epoch{k}),and(stages_SD{k}.SWSEpoch,same_epoch{k}),and(stages_SD{k}.REMEpoch,same_epoch{k}),tempbin);
    all_trans_REM_REM_SD{k} = trans_REM_to_REM;
    all_trans_REM_SWS_SD{k} = trans_REM_to_SWS;
    all_trans_REM_WAKE_SD{k} = trans_REM_to_WAKE;
    
    all_trans_SWS_REM_SD{k} = trans_SWS_to_REM;
    all_trans_SWS_SWS_SD{k} = trans_SWS_to_SWS;
    all_trans_SWS_WAKE_SD{k} = trans_SWS_to_WAKE;
    
    all_trans_WAKE_REM_SD{k} = trans_WAKE_to_REM;
    all_trans_WAKE_SWS_SD{k} = trans_WAKE_to_SWS;
    all_trans_WAKE_WAKE_SD{k} = trans_WAKE_to_WAKE;
end

%%percentage
for imouse=1:length(density_REM_SD)
    data_density_REM_SD(imouse,:) = Data(density_REM_SD{imouse});
    data_density_SWS_SD(imouse,:) = Data(density_SWS_SD{imouse});
    data_density_WAKE_SD(imouse,:) = Data(density_WAKE_SD{imouse});
end

%%duration/number of bouts
for imouse=1:length(dur_REM_SD)
    data_dur_TOT_REM_SD(imouse,:) = dur_TOT_REM_SD{imouse}; data_dur_TOT_REM_SD(isnan(data_dur_TOT_REM_SD)==1)=0;
    
    data_dur_REM_SD(imouse,:) = dur_REM_SD{imouse}; data_dur_REM_SD(isnan(data_dur_REM_SD)==1)=0;
    data_dur_SWS_SD(imouse,:) = dur_SWS_SD{imouse}; data_dur_SWS_SD(isnan(data_dur_SWS_SD)==1)=0;
    data_dur_WAKE_SD(imouse,:) = dur_WAKE_SD{imouse}; data_dur_WAKE_SD(isnan(data_dur_WAKE_SD)==1)=0;
    
    data_num_REM_SD(imouse,:) = num_REM_SD{imouse}; data_num_REM_SD(isnan(data_num_REM_SD)==1)=0;
    data_num_SWS_SD(imouse,:) = num_SWS_SD{imouse}; data_num_SWS_SD(isnan(data_num_SWS_SD)==1)=0;
    data_num_WAKE_SD(imouse,:) = num_WAKE_SD{imouse}; data_num_WAKE_SD(isnan(data_num_WAKE_SD)==1)=0;
end

%%transition probabilities
for imouse=1:length(all_trans_REM_REM_SD)
    data_REM_REM_SD(imouse,:) = all_trans_REM_REM_SD{imouse}; data_REM_REM_SD(isnan(data_REM_REM_SD)==1)=0;
    data_REM_SWS_SD(imouse,:) = all_trans_REM_SWS_SD{imouse}; data_REM_SWS_SD(isnan(data_REM_SWS_SD)==1)=0;
    data_REM_WAKE_SD(imouse,:) = all_trans_REM_WAKE_SD{imouse}; data_REM_WAKE_SD(isnan(data_REM_WAKE_SD)==1)=0;
    
    data_SWS_SWS_SD(imouse,:) = all_trans_SWS_SWS_SD{imouse}; data_SWS_SWS_SD(isnan(data_SWS_SWS_SD)==1)=0;
    data_SWS_REM_SD(imouse,:) = all_trans_SWS_REM_SD{imouse}; data_SWS_REM_SD(isnan(data_SWS_REM_SD)==1)=0;
    data_SWS_WAKE_SD(imouse,:) = all_trans_SWS_WAKE_SD{imouse}; data_SWS_WAKE_SD(isnan(data_SWS_WAKE_SD)==1)=0;
    
    data_WAKE_WAKE_SD(imouse,:) = all_trans_WAKE_WAKE_SD{imouse}; data_WAKE_WAKE_SD(isnan(data_WAKE_WAKE_SD)==1)=0;
    data_WAKE_REM_SD(imouse,:) = all_trans_WAKE_REM_SD{imouse}; data_WAKE_REM_SD(isnan(data_WAKE_REM_SD)==1)=0;
    data_WAKE_SWS_SD(imouse,:) = all_trans_WAKE_SWS_SD{imouse}; data_WAKE_SWS_SD(isnan(data_WAKE_SWS_SD)==1)=0;
end

%% FIGURE

col_control = [0.9 0.9 0.9];
col_SD = [1 0 0];

ispaired=0;

figure
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_density_WAKE_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_WAKE_control), stdError(data_density_WAKE_control),'color',col_control)
plot(nanmean(data_density_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_WAKE_SD), stdError(data_density_WAKE_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('Wake percentage')

subplot(4,6,[3,4]) %NREM percentage overtime
plot(nanmean(data_density_SWS_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_SWS_control), stdError(data_density_SWS_control),'color',col_control)
plot(nanmean(data_density_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_SWS_SD), stdError(data_density_SWS_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('NREM percentage')

subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_density_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_REM_control), stdError(data_density_REM_control),'color',col_control)
plot(nanmean(data_density_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_REM_SD), stdError(data_density_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM percentage')


subplot(4,6,[7,8]) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_WAKE_control(:,1:2),2), nanmean(data_density_WAKE_SD(:,1:2),2),...
        nanmean(data_density_WAKE_control(:,3:4),2), nanmean(data_density_WAKE_SD(:,3:4),2),...
    nanmean(data_density_WAKE_control(:,5:8),2), nanmean(data_density_WAKE_SD(:,5:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5 7.5]); xticklabels({'1-2','3-4','5-8'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:2;
[p_saline_atropine,h] = ranksum(nanmean(data_density_WAKE_control(:,timebin),2),nanmean(data_density_WAKE_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=3:4;
[p_saline_atropine,h] = ranksum(nanmean(data_density_WAKE_control(:,timebin),2),nanmean(data_density_WAKE_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[4 5]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=5:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_WAKE_control(:,timebin),2),nanmean(data_density_WAKE_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[7 8]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_SWS_control(:,1:2),2), nanmean(data_density_SWS_SD(:,1:2),2),...
        nanmean(data_density_SWS_control(:,3:4),2), nanmean(data_density_SWS_SD(:,3:4),2),...
    nanmean(data_density_SWS_control(:,5:8),2), nanmean(data_density_SWS_SD(:,5:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5 7.5]); xticklabels({'1-2','3-4','5-8'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:2;
[p_saline_atropine,h] = ranksum(nanmean(data_density_SWS_control(:,timebin),2),nanmean(data_density_SWS_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=3:4;
[p_saline_atropine,h] = ranksum(nanmean(data_density_SWS_control(:,timebin),2),nanmean(data_density_SWS_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[5 6]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=5:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_SWS_control(:,timebin),2),nanmean(data_density_SWS_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[9 10]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_REM_control(:,1:2),2), nanmean(data_density_REM_SD(:,1:2),2),...
        nanmean(data_density_REM_control(:,3:4),2), nanmean(data_density_REM_SD(:,3:4),2),...
    nanmean(data_density_REM_control(:,5:8),2), nanmean(data_density_REM_SD(:,5:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5 7.5]); xticklabels({'1-2','3-4','5-8'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:2;
[p_saline_atropine,h] = ranksum(nanmean(data_density_REM_control(:,timebin),2),nanmean(data_density_REM_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


timebin=3:4;
[p_saline_atropine,h] = ranksum(nanmean(data_density_REM_control(:,timebin),2),nanmean(data_density_REM_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[4,5]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=5:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_REM_control(:,timebin),2),nanmean(data_density_REM_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[7,8]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]) % REM bouts number ovetime
plot(nanmean(data_num_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_num_REM_control), stdError(data_num_REM_control),'color',col_control)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM bouts number')


subplot(4,6,[15,16]) % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_dur_REM_control), stdError(data_dur_REM_control),'color',col_control)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM bouts mean duration (s)')

subplot(4,6,[17]) % FI REM (5-8h)
PlotErrorBarN_KJ({...
    nanmean(data_num_REM_control(:,5:8),2)./nanmean(data_dur_REM_control(:,5:8),2),...
    nanmean(data_num_REM_SD(:,5:8),2)./nanmean(data_dur_REM_SD(:,5:8),2)},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
ylabel('REM fragmentation index')
makepretty
xticks([1:3]); xticklabels({'Control','SDS+sal','SDS+cno'}); xtickangle(0)
    
timebin=4:8;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2)./nanmean(data_dur_REM_control(:,timebin),2), nanmean(data_num_REM_SD(:,timebin),2)./nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_num_REM_control(:,1:2),2), nanmean(data_num_REM_SD(:,1:2),2),...
        nanmean(data_num_REM_control(:,3:4),2), nanmean(data_num_REM_SD(:,3:4),2),...
        nanmean(data_num_REM_control(:,5:8),2), nanmean(data_num_REM_SD(:,5:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5 7.5]); xticklabels({'1-2','3-4','5-8'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time after stress (h)')

timebin=1:2;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=3:4;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[4,5]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:8;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[7,8]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot

PlotErrorBarN_KJ({...
        nanmean(data_dur_REM_control(:,1:2),2), nanmean(data_dur_REM_SD(:,1:2),2),...
        nanmean(data_dur_REM_control(:,3:4),2), nanmean(data_dur_REM_SD(:,3:4),2),...
    nanmean(data_dur_REM_control(:,5:8),2), nanmean(data_dur_REM_SD(:,5:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5 7.5]); xticklabels({'1-2','3-4','5-8'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time after stress (h)')

timebin=1:2;
[p_control_SD,h] = ranksum(nanmean(data_dur_REM_control(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=3:4;
[p_control_SD,h] = ranksum(nanmean(data_dur_REM_control(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[4,5]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=5:8;
[p_control_SD,h] = ranksum(nanmean(data_dur_REM_control(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[7,8]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[23]) %proba stay rem (5-8h)
PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_control(:,5:8),2)+nanmean(data_REM_WAKE_control(:,5:8),2)),...
    1-(nanmean(data_REM_SWS_SD(:,5:8),2)+nanmean(data_REM_WAKE_SD(:,5:8),2))},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty
ylim([.9 1])

timebin=5:8;
[p_control_SD,h]=ranksum(1-(nanmean(data_REM_SWS_control(:,timebin),2)+nanmean(data_REM_WAKE_control(:,timebin),2)),1-(nanmean(data_REM_SWS_SD(:,timebin),2)+nanmean(data_REM_WAKE_SD(:,timebin),2)));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[24]) %proba initiate rem (5-8h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_control(:,5:8),2)+nanmean(data_WAKE_REM_control(:,5:8),2),...
    nanmean(data_SWS_REM_SD(:,5:8),2)+nanmean(data_WAKE_REM_SD(:,5:8),2)},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

timebin=5:8;
[p_control_SD,h]=ranksum(nanmean(data_SWS_REM_control(:,timebin),2)+nanmean(data_WAKE_REM_control(:,timebin),2),nanmean(data_SWS_REM_SD(:,timebin),2)+nanmean(data_WAKE_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


%% figure w/ only 2 time periods

figure
subplot(4,6,[1,2]) % wake percentage overtime
plot(nanmean(data_density_WAKE_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_WAKE_control), stdError(data_density_WAKE_control),'color',col_control)
plot(nanmean(data_density_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_WAKE_SD), stdError(data_density_WAKE_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('Wake percentage')

subplot(4,6,[3,4]) %NREM percentage overtime
plot(nanmean(data_density_SWS_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_SWS_control), stdError(data_density_SWS_control),'color',col_control)
plot(nanmean(data_density_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_SWS_SD), stdError(data_density_SWS_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('NREM percentage')

subplot(4,6,[5,6]) %REM percentage overtime
plot(nanmean(data_density_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_density_REM_control), stdError(data_density_REM_control),'color',col_control)
plot(nanmean(data_density_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_density_REM_SD), stdError(data_density_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM percentage')


subplot(4,6,[7,8]) % wake percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_WAKE_control(:,1:3),2), nanmean(data_density_WAKE_SD(:,1:3),2),...
        nanmean(data_density_WAKE_control(:,4:8),2), nanmean(data_density_WAKE_SD(:,4:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('WAKE percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_saline_atropine,h] = ranksum(nanmean(data_density_WAKE_control(:,timebin),2),nanmean(data_density_WAKE_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_WAKE_control(:,timebin),2),nanmean(data_density_WAKE_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[4 5]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[9,10]) %NREM percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_SWS_control(:,1:2),2), nanmean(data_density_SWS_SD(:,1:2),2),...
        nanmean(data_density_SWS_control(:,4:8),2), nanmean(data_density_SWS_SD(:,4:8),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('NREM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_saline_atropine,h] = ranksum(nanmean(data_density_SWS_control(:,timebin),2),nanmean(data_density_SWS_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_SWS_control(:,timebin),2),nanmean(data_density_SWS_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[5 6]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[11,12]) %REM percentage quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_density_REM_control(:,1:2),2), nanmean(data_density_REM_SD(:,1:2),2),...
        nanmean(data_density_REM_control(:,3:4),2), nanmean(data_density_REM_SD(:,3:4),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('REM percentage')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_saline_atropine,h] = ranksum(nanmean(data_density_REM_control(:,timebin),2),nanmean(data_density_REM_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[1 2]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


timebin=4:8;
[p_saline_atropine,h] = ranksum(nanmean(data_density_REM_control(:,timebin),2),nanmean(data_density_REM_SD(:,timebin),2));
if p_saline_atropine<0.05; sigstar_DB({[4,5]},p_saline_atropine,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[13,14]) % REM bouts number ovetime
plot(nanmean(data_num_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_num_REM_control), stdError(data_num_REM_control),'color',col_control)
plot(nanmean(data_num_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_num_REM_SD), stdError(data_num_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM bouts number')


subplot(4,6,[15,16]) % REM bouts mean duraion overtime
plot(nanmean(data_dur_REM_control),'linestyle','-','marker','o','markerfacecolor',col_control,'color',col_control), hold on
errorbar(nanmean(data_dur_REM_control), stdError(data_dur_REM_control),'color',col_control)
plot(nanmean(data_dur_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_dur_REM_SD), stdError(data_dur_REM_SD),'color',col_SD)
xlim([0 8])
makepretty
ylabel('REM bouts mean duration (s)')


subplot(4,6,[17]) % FI REM (5-8h)
timebin=4:8;

PlotErrorBarN_KJ({...
    nanmean(data_num_REM_control(:,timebin),2)./nanmean(data_dur_REM_control(:,timebin),2),...
    nanmean(data_num_REM_SD(:,timebin),2)./nanmean(data_dur_REM_SD(:,timebin),2)},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD,col_control,col_SD,col_control,col_SD});
ylabel('REM fragmentation index')
makepretty
xticks([1:3]); xticklabels({'Control','SDS+sal','SDS+cno'}); xtickangle(0)
    
timebin=4:8;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2)./nanmean(data_dur_REM_control(:,timebin),2), nanmean(data_num_REM_SD(:,timebin),2)./nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[19,20]) % REM bouts number quantif barplot
PlotErrorBarN_KJ({...
        nanmean(data_num_REM_control(:,1:2),2), nanmean(data_num_REM_SD(:,1:2),2),...
        nanmean(data_num_REM_control(:,3:4),2), nanmean(data_num_REM_SD(:,3:4),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('REM bouts number')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_control_SD,h] = ranksum(nanmean(data_num_REM_control(:,timebin),2),nanmean(data_num_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[4,5]},p_control_SD,0,'LineWigth',16,'StarSize',24);end


subplot(4,6,[21,22]) % REM bouts mean duraion quantif barplot

PlotErrorBarN_KJ({...
        nanmean(data_dur_REM_control(:,1:2),2), nanmean(data_dur_REM_SD(:,1:2),2),...
        nanmean(data_dur_REM_control(:,3:4),2), nanmean(data_dur_REM_SD(:,3:4),2)},...
        'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2,4:5],'barcolors',{col_control,col_SD,col_control,col_SD});
xticks([1.5 4.5]); xticklabels({'1-3','4-8'}); xtickangle(0)
ylabel('REM bouts mean duration (s)')
makepretty
xlabel('Time after stress (h)')

timebin=1:3;
[p_control_SD,h] = ranksum(nanmean(data_dur_REM_control(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end

timebin=4:8;
[p_control_SD,h] = ranksum(nanmean(data_dur_REM_control(:,timebin),2),nanmean(data_dur_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[4,5]},p_control_SD,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[23]) %proba stay rem (5-8h)
timebin=4:8;

PlotErrorBarN_KJ({...
    1-(nanmean(data_REM_SWS_control(:,timebin),2)+nanmean(data_REM_WAKE_control(:,timebin),2)),...
    1-(nanmean(data_REM_SWS_SD(:,timebin),2)+nanmean(data_REM_WAKE_SD(:,timebin),2))},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM stay probability')
makepretty
ylim([.9 1])

[p_control_SD,h]=ranksum(1-(nanmean(data_REM_SWS_control(:,timebin),2)+nanmean(data_REM_WAKE_control(:,timebin),2)),1-(nanmean(data_REM_SWS_SD(:,timebin),2)+nanmean(data_REM_WAKE_SD(:,timebin),2)));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end



subplot(4,6,[24]) %proba initiate rem (5-8h)
PlotErrorBarN_KJ({...
    nanmean(data_SWS_REM_control(:,timebin),2)+nanmean(data_WAKE_REM_control(:,timebin),2),...
    nanmean(data_SWS_REM_SD(:,timebin),2)+nanmean(data_WAKE_REM_SD(:,timebin),2)},...
    'newfig',0,'paired',ispaired,'showsigstar','none','x_data',[1:2],'barcolors',{col_control,col_SD});
xticks([1:2]); xticklabels({'Control','SDS+sal'}); xtickangle(0)
ylabel('REM initiation probability')
makepretty

[p_control_SD,h]=ranksum(nanmean(data_SWS_REM_control(:,timebin),2)+nanmean(data_WAKE_REM_control(:,timebin),2),nanmean(data_SWS_REM_SD(:,timebin),2)+nanmean(data_WAKE_REM_SD(:,timebin),2));
if p_control_SD<0.05; sigstar_DB({[1 2]},p_control_SD,0,'LineWigth',16,'StarSize',24);end
