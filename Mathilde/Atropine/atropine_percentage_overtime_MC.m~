
%%
%% FLX
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
%merge saline path
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirBasal_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_dreadd_PFC = RestrictPathForExperiment(DirBasal_dreadd_PFC,'nMice',[1197 1198 1235 1236 1237 1238]);
Dir_sal2 = MergePathForExperiment(DirBasal_dreadd_PFC,DirSaline_retoCre);
DirSaline = MergePathForExperiment(Dir_sal,Dir_sal2);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1196 1237 1238 1245 1248 1247]);

%%PathForExperimentsFLX_MC
DirAtropine = PathForExperimentsFLX_MC('dreadd_PFC_saline_flx');

%% DIR ATROPINE
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1112 1245 1247 1248]); %

DirAtropine = PathForExperimentsAtropine_MC('Atropine');

%% parameters
st_epoch_preInj = 0*1E8;
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.6*1E8;
en_epoch_postInj = 3*1E8;

%

for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        a{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        
    elseif exist('SleepScoring_OBGamma.mat')
        a{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
   
    %pre injection
    same_epoch{j} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreInj_saline{j} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post injection
    epoch_PostInj_saline{j} = intervalSet(st_epoch_postInj,en_epoch_postInj);

    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_saline=DensitySleepStage_MC(and(a{j}.Wake,same_epoch{j}),and(a{j}.SWSEpoch,same_epoch{j}),and(a{j}.REMEpoch,same_epoch{j}),'wake',3600);
        density_WAKE_saline{j}=D_WAKE_saline;
        D_SWS_saline=DensitySleepStage_MC(and(a{j}.Wake,same_epoch{j}),and(a{j}.SWSEpoch,same_epoch{j}),and(a{j}.REMEpoch,same_epoch{j}),'sws',3600);
        density_SWS_saline{j}=D_SWS_saline;
        D_REM_saline=DensitySleepStage_MC(and(a{j}.Wake,same_epoch{j}),and(a{j}.SWSEpoch,same_epoch{j}),and(a{j}.REMEpoch,same_epoch{j}),'rem',3600);
        density_REM_saline{j}=D_REM_saline;
     
    else
    end
end


%
for imouse=1:length(density_REM_saline)
    data_density_REM_saline(imouse,:) = Data(density_REM_saline{imouse});
    data_density_SWS_saline(imouse,:) = Data(density_SWS_saline{imouse});
    data_density_WAKE_saline(imouse,:) = Data(density_WAKE_saline{imouse});
end




for k=1:length(DirAtropine.path)
    cd(DirAtropine.path{k}{1});
    %%load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        
    elseif exist('SleepScoring_OBGamma.mat')
        c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
   
    %pre injection
    same_epoch{k} =  intervalSet(st_epoch_preInj, en_epoch_postInj);
    epoch_PreInj_atropine{k} = intervalSet(st_epoch_preInj, en_epoch_preInj);
    %post injection
    epoch_PostInj_atropine{k} = intervalSet(st_epoch_postInj,en_epoch_postInj);

    %%compute stages density
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        D_WAKE_atropine=DensitySleepStage_MC(and(c{k}.Wake,same_epoch{k}),and(c{k}.SWSEpoch,same_epoch{k}),and(c{k}.REMEpoch,same_epoch{k}),'wake',3600);
        density_WAKE_atropine{k}=D_WAKE_atropine;
        D_SWS_atropine=DensitySleepStage_MC(and(c{k}.Wake,same_epoch{k}),and(c{k}.SWSEpoch,same_epoch{k}),and(c{k}.REMEpoch,same_epoch{k}),'sws',3600);
        density_SWS_atropine{k}=D_SWS_atropine;
        D_REM_atropine=DensitySleepStage_MC(and(c{k}.Wake,same_epoch{k}),and(c{k}.SWSEpoch,same_epoch{k}),and(c{k}.REMEpoch,same_epoch{k}),'rem',3600);
        density_REM_atropine{k}=D_REM_atropine;
     
    else
    end
end


%
for imouse=1:length(density_REM_atropine)
    data_density_REM_atropine(imouse,:) = Data(density_REM_atropine{imouse});
    data_density_SWS_atropine(imouse,:) = Data(density_SWS_atropine{imouse});
    data_density_WAKE_atropine(imouse,:) = Data(density_WAKE_atropine{imouse});
end




%%
figure, subplot(311)
plot(nanmean(data_density_WAKE_saline),'linestyle','-','marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_density_WAKE_saline), stdError(data_density_WAKE_saline),'color','k')
plot(nanmean(data_density_WAKE_atropine),'linestyle','-','marker','o','markerfacecolor',[.2 .8 0],'color',[.2 .8 0])
errorbar(nanmean(data_density_WAKE_atropine), stdError(data_density_WAKE_atropine),'color',[.2 .8 0])
xticklabels({'9','10','11','12','13','14','15','16','17'})
makepretty
xlim([0 10])
ylabel('%')
xlabel('Time of the day')
title('WAKE')

subplot(312), 
plot(nanmean(data_density_SWS_saline),'linestyle','-','marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_density_SWS_saline), stdError(data_density_SWS_saline),'color','k')
plot(nanmean(data_density_SWS_atropine),'linestyle','-','marker','o','markerfacecolor',[.2 .8 0],'color',[.2 .8 0])
errorbar(nanmean(data_density_SWS_atropine), stdError(data_density_SWS_atropine),'color',[.2 .8 0])
xticklabels({'9','10','11','12','13','14','15','16','17'})
makepretty
xlim([0 10])
ylabel('%')
xlabel('Time of the day')
title('NREM')

subplot(313), 
plot(nanmean(data_density_REM_saline),'linestyle','-','marker','o','markerfacecolor','k','color','k'), hold on
errorbar(nanmean(data_density_REM_saline), stdError(data_density_REM_saline),'color','k')
plot(nanmean(data_density_REM_atropine),'linestyle','-','marker','o','markerfacecolor',[.2 .8 0],'color',[.2 .8 0])
errorbar(nanmean(data_density_REM_atropine), stdError(data_density_REM_atropine),'color',[.2 .8 0])
xticklabels({'9','10','11','12','13','14','15','16','17'})
makepretty
xlim([0 10])
ylabel('%')
xlabel('Time of the day')
title('REM')

