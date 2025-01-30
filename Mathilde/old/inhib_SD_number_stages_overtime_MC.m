

%% input dir 
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[1075 1107 1112 1148 1149 1150 1217 1218 1219 1220]);

DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');



%% paramete
st_epoch_preInj_basal = 0*1E8;
st_epoch_preInj = 0*1E8;
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.6*1E8;
en_epoch_postInj = 2.85*1E8;

tempbin = 3600;

for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
    %%load sleep scoring
    stages_basal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');

    %pre injection
    same_epoch{j} =  intervalSet(st_epoch_preInj_basal, en_epoch_postInj);
    epoch_PreInj_basal{j} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post injection
    epoch_PostInj_basal{j} = intervalSet(st_epoch_postInj,en_epoch_postInj);

    N_WAKE_basal=GetNumberStagesOvertime_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'wake',tempbin);
    number_WAKE_basal{j}=N_WAKE_basal;
    
    N_SWS_basal=GetNumberStagesOvertime_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'sws',tempbin);
    number_SWS_basal{j}=N_SWS_basal;
    
    N_REM_basal=GetNumberStagesOvertime_MC(and(stages_basal{j}.Wake,same_epoch{j}),and(stages_basal{j}.SWSEpoch,same_epoch{j}),and(stages_basal{j}.REMEpoch,same_epoch{j}),'rem',tempbin);
    number_REM_basal{j}=N_REM_basal;
    
end
%
for imouse=1:length(number_REM_basal)
    data_number_REM_basal(imouse,:) = Data(number_REM_basal{imouse});
    data_number_SWS_basal(imouse,:) = Data(number_SWS_basal{imouse});
    data_number_WAKE_basal(imouse,:) = Data(number_WAKE_basal{imouse});
end

%%
for i=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{i}{1});
    %%load sleep scoring
    stages_SD{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');

    %pre injection
    same_epoch{i} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreInj_SD{i} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post injection
    epoch_PostInj_SD{i} = intervalSet(st_epoch_postInj,en_epoch_postInj);

    N_WAKE_SD=GetNumberStagesOvertime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'wake',tempbin);
    number_WAKE_SD{i}=N_WAKE_SD;
    
    N_SWS_SD=GetNumberStagesOvertime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'sws',tempbin);
    number_SWS_SD{i}=N_SWS_SD;
    
    N_REM_SD=GetNumberStagesOvertime_MC(and(stages_SD{i}.Wake,same_epoch{i}),and(stages_SD{i}.SWSEpoch,same_epoch{i}),and(stages_SD{i}.REMEpoch,same_epoch{i}),'rem',tempbin);
    number_REM_SD{i}=N_REM_SD;
    
end
%
for imouse=1:length(number_REM_SD)
    data_number_REM_SD(imouse,:) = Data(number_REM_SD{imouse});
    data_number_SWS_SD(imouse,:) = Data(number_SWS_SD{imouse});
    data_number_WAKE_SD(imouse,:) = Data(number_WAKE_SD{imouse});
end

%%
for k=1:length(DirSocialDefeat_inhibPFC.path)
    cd(DirSocialDefeat_inhibPFC.path{k}{1});
    %%load sleep scoring
    stages_SD_inhib{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');

    %pre injection
    same_epoch{k} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreInj_SD_inhib{k} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post injection
    epoch_PostInj_SD_inhib{k} = intervalSet(st_epoch_postInj,en_epoch_postInj);

    N_WAKE_SD_inhib=GetNumberStagesOvertime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'wake',tempbin);
    number_WAKE_SD_inhib{k}=N_WAKE_SD_inhib;
    
    N_SWS_SD_inhib=GetNumberStagesOvertime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'sws',tempbin);
    number_SWS_SD_inhib{k}=N_SWS_SD_inhib;
    
    N_REM_SD_inhib=GetNumberStagesOvertime_MC(and(stages_SD_inhib{k}.Wake,same_epoch{k}),and(stages_SD_inhib{k}.SWSEpoch,same_epoch{k}),and(stages_SD_inhib{k}.REMEpoch,same_epoch{k}),'rem',tempbin);
    number_REM_SD_inhib{k}=N_REM_SD_inhib;
    
end
%
for imouse=1:length(number_REM_SD_inhib)
    data_number_REM_SD_inhib(imouse,:) = Data(number_REM_SD_inhib{imouse});
    data_number_SWS_SD_inhib(imouse,:) = Data(number_SWS_SD_inhib{imouse});
    data_number_WAKE_SD_inhib(imouse,:) = Data(number_WAKE_SD_inhib{imouse});
end

%%

col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];


figure, subplot(311)
plot(nanmean(data_number_WAKE_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_number_WAKE_basal), stdError(data_number_WAKE_basal),'color',[.5 .5 .5])
plot(nanmean(data_number_WAKE_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_number_WAKE_SD), stdError(data_number_WAKE_SD),'color',col_SD)
plot(nanmean(data_number_WAKE_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_number_WAKE_SD_inhib), stdError(data_number_WAKE_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
% xlim([4 9])
makepretty
ylabel('Number')
xlabel('Time after injection (h)')
title('WAKE')

subplot(312), 
plot(nanmean(data_number_SWS_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_number_SWS_basal), stdError(data_number_SWS_basal),'color',[.5 .5 .5])
plot(nanmean(data_number_SWS_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_number_SWS_SD), stdError(data_number_SWS_SD),'color',col_SD)
plot(nanmean(data_number_SWS_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_number_SWS_SD_inhib), stdError(data_number_SWS_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
% xlim([4 9])
makepretty
ylabel('Number')
xlabel('Time after injection (h)')
title('NREM sleep')


subplot(313), 
plot(nanmean(data_number_REM_basal),'linestyle','-','marker','o','markerfacecolor',[.5 .5 .5],'color',[.5 .5 .5]), hold on
errorbar(nanmean(data_number_REM_basal), stdError(data_number_REM_basal),'color',[.5 .5 .5])
plot(nanmean(data_number_REM_SD),'linestyle','-','marker','o','markerfacecolor',col_SD,'color',col_SD)
errorbar(nanmean(data_number_REM_SD), stdError(data_number_REM_SD),'color',col_SD)
plot(nanmean(data_number_REM_SD_inhib),'linestyle','-','marker','o','markerfacecolor',[.4 0 0],'color',[.4 0 0])
errorbar(nanmean(data_number_REM_SD_inhib), stdError(data_number_REM_SD_inhib),'color',[.4 0 0])
% xticks([5 6 7 8 9])
% xticklabels({'1','2','3','4','5'})
% xlim([4 9])
makepretty
ylabel('Number')
xlabel('Time after injection (h)')
title('REM sleep')



%%


timebin = 3;

figure,subplot(325),
MakeSpreadAndBoxPlot2_SB({data_number_REM_basal(:,timebin), data_number_REM_SD(:,timebin), data_number_REM_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_REM_basal(:,timebin), data_number_REM_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_REM_SD(:,timebin), data_number_REM_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_REM_basal(:,timebin), data_number_REM_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



subplot(323), MakeSpreadAndBoxPlot2_SB({data_number_SWS_basal(:,timebin), data_number_SWS_SD(:,timebin), data_number_SWS_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_SWS_basal(:,timebin), data_number_SWS_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_SWS_SD(:,timebin), data_number_SWS_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_SWS_basal(:,timebin), data_number_SWS_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(321), MakeSpreadAndBoxPlot2_SB({data_number_WAKE_basal(:,timebin), data_number_WAKE_SD(:,timebin), data_number_WAKE_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_WAKE_basal(:,timebin), data_number_WAKE_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_WAKE_SD(:,timebin), data_number_WAKE_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_WAKE_basal(:,timebin), data_number_WAKE_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



timebin = 4;

subplot(326),
MakeSpreadAndBoxPlot2_SB({data_number_REM_basal(:,timebin), data_number_REM_SD(:,timebin), data_number_REM_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_REM_basal(:,timebin), data_number_REM_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_REM_SD(:,timebin), data_number_REM_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_REM_basal(:,timebin), data_number_REM_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(324), MakeSpreadAndBoxPlot2_SB({data_number_SWS_basal(:,timebin), data_number_SWS_SD(:,timebin), data_number_SWS_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_SWS_basal(:,timebin), data_number_SWS_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_SWS_SD(:,timebin), data_number_SWS_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_SWS_basal(:,timebin), data_number_SWS_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end

subplot(322), MakeSpreadAndBoxPlot2_SB({data_number_WAKE_basal(:,timebin), data_number_WAKE_SD(:,timebin), data_number_WAKE_SD_inhib(:,timebin)},{col_basal, col_SD,col_PFCinhib_SD},[1:3],{},'ShowPoints',1,'paired',0,'showsigstar','none');
[h,p_basal_SD]=ttest(data_number_WAKE_basal(:,timebin), data_number_WAKE_SD(:,timebin));
[h,p_SD_SDInhib]=ttest2(data_number_WAKE_SD(:,timebin), data_number_WAKE_SD_inhib(:,timebin));
[h,p_basal_SDInhib]=ttest2(data_number_WAKE_basal(:,timebin), data_number_WAKE_SD_inhib(:,timebin));

if p_basal_SD<0.05; sigstar_DB({[1 2]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[2 3]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[1 3]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end