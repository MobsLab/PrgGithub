%% input dir : effect CNO alone
% DirSaline_CtrlMice = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline = MergePathForExperiment(DirSaline,DirSaline_CtrlMice);
%
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir : CONTROL exi DREADD VLPO CRH-neurons (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir : exi DREADD VLPO CRH-neurons
DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149 1150]);
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1217 1218 1219 1220 1371 1372]);


% DirCNO=PathForExperiments_TG('PFC-VLPO_dreadd-ex_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1035, 1036]);

%% input dir basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
% % DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% % DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%% input dir : inhi DREADD in PFC
% %saline PFC experiment
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');

% DirCNO = PathForExperimentsAtropine_MC('Atropine');
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1217 1218 1219 1220]);

% DirSaline = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');


%% input dir ATROPINE
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112
% 
% DirCNO = PathForExperimentsAtropine_MC('Atropine');
% % DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1107 1245 1247 1248]); %1112
% 
% % DirCNO = PathForExperimentsAtropine_MC('CNO_Atropine_DreaddMouse');

%% FLX
% 
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirBasal_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% DirBasal_dreadd_PFC = RestrictPathForExperiment(DirBasal_dreadd_PFC,'nMice',[1197 1198 1235 1236 1237 1238]);
% 
% 
% Dir_sal2 = MergePathForExperiment(DirBasal_dreadd_PFC,DirSaline_retoCre);
% DirSaline = MergePathForExperiment(Dir_sal,Dir_sal2);
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1196 1237 1238 1245 1248 1247]);
% 
% %%PathForExperimentsFLX_MC
% DirCNO = PathForExperimentsFLX_MC('dreadd_PFC_saline_flx');



%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data BASELINE sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
%     if exist('SleepScoring_OBGamma.mat')
%         b{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
%     elseif 
if exist('SleepScoring_Accelero.mat')
        b{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        b{i}.SWSEpoch = mergeCloseIntervals(b{i}.SWSEpoch, 1e4);
        b{i}.REMEpoch = mergeCloseIntervals(b{i}.REMEpoch, 1e4);
        b{i}.Wake = mergeCloseIntervals(b{i}.Wake, 1e4);
    else
    end
    
%     if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
    if exist('SleepScoring_Accelero.mat')

        %%periods of time
        durtotal_basal{i} = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
        %post injection
        epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
        %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%percentage : all session
        Restemp_basal{i}=ComputeSleepStagesPercentagesMC(b{i}.Wake,b{i}.SWSEpoch,b{i}.REMEpoch);
        %percentage pre injection
        percWAKE_basal_pre(i)=Restemp_basal{i}(1,2); percWAKE_basal_pre(percWAKE_basal_pre==0)=NaN;
        percSWS_basal_pre(i)=Restemp_basal{i}(2,2); percSWS_basal_pre(percSWS_basal_pre==0)=NaN;
        percREM_basal_pre(i)=Restemp_basal{i}(3,2); percREM_basal_pre(percREM_basal_pre==0)=NaN;
        %percentage post injection
        percWAKE_basal_post(i)=Restemp_basal{i}(1,3); percWAKE_basal_post(percWAKE_basal_post==0)=NaN;
        percSWS_basal_post(i)=Restemp_basal{i}(2,3); percSWS_basal_post(percSWS_basal_post==0)=NaN;
        percREM_basal_post(i)=Restemp_basal{i}(3,3); percREM_basal_post(percREM_basal_post==0)=NaN;
        %percentage 3h post injection
        percWAKE_basal_3hPostInj(i)=Restemp_basal{i}(1,4); percWAKE_basal_3hPostInj(percWAKE_basal_3hPostInj==0)=NaN;
        percSWS_basal_3hPostInj(i)=Restemp_basal{i}(2,4); percSWS_basal_3hPostInj(percSWS_basal_3hPostInj==0)=NaN;
        percREM_basal_3hPostInj(i)=Restemp_basal{i}(3,4); percREM_basal_3hPostInj(percREM_basal_3hPostInj==0)=NaN;
        
        %%percentage of REM out of total sleep
        Restemp_totSleep_basal{i}=ComputeSleepStagesPercentagesWithoutWakeMC(b{i}.Wake,b{i}.SWSEpoch,b{i}.REMEpoch);
        %percentage pre injection
        percREM_totSleep_basal_pre(i)=Restemp_totSleep_basal{i}(3,2); percREM_totSleep_basal_pre(percREM_totSleep_basal_pre==0)=NaN;
        %percentage post injection
        percREM_totSleep_basal_post(i)=Restemp_totSleep_basal{i}(3,3); percREM_totSleep_basal_post(percREM_totSleep_basal_post==0)=NaN;
        %percentage 3h post injection
        percREM_totSleep_basal_3hPostInj(i)=Restemp_totSleep_basal{i}(3,4); percREM_totSleep_basal_3hPostInj(percREM_totSleep_basal_3hPostInj==0)=NaN;
        
        %number of bouts pre injection
        NumSWS_basal_pre(i)=length(length(and(b{i}.SWSEpoch,epoch_PreInj_basal{i}))); NumSWS_basal_pre(NumSWS_basal_pre==0)=NaN;
        NumWAKE_basal_pre(i)=length(length(and(b{i}.Wake,epoch_PreInj_basal{i}))); NumWAKE_basal_pre(NumWAKE_basal_pre==0)=NaN;
        NumREM_basal_pre(i)=length(length(and(b{i}.REMEpoch,epoch_PreInj_basal{i}))); NumREM_basal_pre(NumREM_basal_pre==0)=NaN;
        %number of bouts post injection
        NumSWS_basal_post(i)=length(length(and(b{i}.SWSEpoch,epoch_PostInj_basal{i}))); NumSWS_basal_post(NumSWS_basal_post==0)=NaN;
        NumWAKE_basal_post(i)=length(length(and(b{i}.Wake,epoch_PostInj_basal{i}))); NumWAKE_basal_post(NumWAKE_basal_post==0)=NaN;
        NumREM_basal_post(i)=length(length(and(b{i}.REMEpoch,epoch_PostInj_basal{i}))); NumREM_basal_post(NumREM_basal_post==0)=NaN;
        %number of bouts 3h post injection
        NumSWS_basal_3hPostInj(i)=length(length(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i}))); NumSWS_basal_3hPostInj(NumSWS_basal_3hPostInj==0)=NaN;
        NumWAKE_basal_3hPostInj(i)=length(length(and(b{i}.Wake,epoch_3hPostInj_basal{i}))); NumWAKE_basal_3hPostInj(NumWAKE_basal_3hPostInj==0)=NaN;
        NumREM_basal_3hPostInj(i)=length(length(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i}))); NumREM_basal_3hPostInj(NumREM_basal_3hPostInj==0)=NaN;
        
        %duration of bouts pre injection
        durWAKE_basal_pre(i)=mean(End(and(b{i}.Wake,epoch_PreInj_basal{i}))-Start(and(b{i}.Wake,epoch_PreInj_basal{i})))/1E4;
        durSWS_basal_pre(i)=mean(End(and(b{i}.SWSEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PreInj_basal{i})))/1E4;
        durREM_basal_pre(i)=mean(End(and(b{i}.REMEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PreInj_basal{i})))/1E4;
        durWAKE_basal_pre(durWAKE_basal_pre==0)=NaN;
        durSWS_basal_pre(durSWS_basal_pre==0)=NaN;
        durREM_basal_pre(durREM_basal_pre==0)=NaN;
        %duration of bouts post injection
        durWAKE_basal_post(i)=mean(End(and(b{i}.Wake,epoch_PostInj_basal{i}))-Start(and(b{i}.Wake,epoch_PostInj_basal{i})))/1E4;
        durSWS_basal_post(i)=mean(End(and(b{i}.SWSEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PostInj_basal{i})))/1E4;
        durREM_basal_post(i)=mean(End(and(b{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
        durWAKE_basal_post(durWAKE_basal_post==0)=NaN;
        durSWS_basal_post(durSWS_basal_post==0)=NaN;
        durREM_basal_post(durREM_basal_post==0)=NaN;
        %duration of bouts 3h post injection
        durWAKE_basal_3hPostInj(i)=mean(End(and(b{i}.Wake,epoch_3hPostInj_basal{i}))-Start(and(b{i}.Wake,epoch_3hPostInj_basal{i})))/1E4;
        durSWS_basal_3hPostInj(i)=mean(End(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i})))/1E4;
        durREM_basal_3hPostInj(i)=mean(End(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i})))/1E4;
        durWAKE_basal_3hPostInj(durWAKE_basal_3hPostInj==0)=NaN;
        durSWS_basal_3hPostInj(durSWS_basal_3hPostInj==0)=NaN;
        durREM_basal_3hPostInj(durREM_basal_3hPostInj==0)=NaN;
    else
    end
end


%% get data SALINE sleep
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
            b{j}.SWSEpoch = mergeCloseIntervals(b{j}.SWSEpoch, 1e4);
        b{j}.REMEpoch = mergeCloseIntervals(b{j}.REMEpoch, 1e4);
        b{j}.Wake = mergeCloseIntervals(b{j}.Wake, 1e4);
        
        
%     b{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate day in different periods
    durtotal{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_sal{j} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_sal{i} = intervalSet(0, durtotal{i}/2);
    %post injection
    epoch_PostInj_sal{j} = intervalSet(st_epoch_postInj,durtotal{j});
    %     epoch_PostInj_sal{i} = intervalSet(durtotal{i}/2,durtotal{i});
    %3h post injection
    epoch_3hPostInj{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    Restemp_sal{j}=ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch); %get states percentage
    %percentage pre injection
    percWAKE_sal_pre(j)=Restemp_sal{j}(1,2);
    percSWS_sal_pre(j)=Restemp_sal{j}(2,2);
    percREM_sal_pre(j)=Restemp_sal{j}(3,2);
    %percentage post injection
    percWAKE_sal_post(j)=Restemp_sal{j}(1,3);
    percSWS_sal_post(j)=Restemp_sal{j}(2,3);
    percREM_sal_post(j)=Restemp_sal{j}(3,3);
    %percentage 3h post injection
    percWAKE_sal_3hPostInj(j)=Restemp_sal{j}(1,4);
    percSWS_sal_3hPostInj(j)=Restemp_sal{j}(2,4);
    percREM_sal_3hPostInj(j)=Restemp_sal{j}(3,4);
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_sal{j}=ComputeSleepStagesPercentagesWithoutWakeMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_sal_pre(j)=Restemp_totSleep_sal{j}(3,2); percREM_totSleep_sal_pre(percREM_totSleep_sal_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_sal_post(j)=Restemp_totSleep_sal{j}(3,3); percREM_totSleep_sal_post(percREM_totSleep_sal_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_sal_3hPostInj(j)=Restemp_totSleep_sal{j}(3,4); percREM_totSleep_sal_3hPostInj(percREM_totSleep_sal_3hPostInj==0)=NaN;
    
    
    
    %number of bouts pre injection
    NumSWS_sal_pre(j)=length(length(and(b{j}.SWSEpoch,epoch_PreInj_sal{j})));
    NumWAKE_sal_pre(j)=length(length(and(b{j}.Wake,epoch_PreInj_sal{j})));
    NumREM_sal_pre(j)=length(length(and(b{j}.REMEpoch,epoch_PreInj_sal{j})));
    %number of bouts post injection
    NumSWS_sal_post(j)=length(length(and(b{j}.SWSEpoch,epoch_PostInj_sal{j})));
    NumWAKE_sal_post(j)=length(length(and(b{j}.Wake,epoch_PostInj_sal{j})));
    NumREM_sal_post(j)=length(length(and(b{j}.REMEpoch,epoch_PostInj_sal{j})));
    %nuumber of bouts 3h post injection
    NumSWS_sal_3hPostInj(j)=length(length(and(b{j}.SWSEpoch,epoch_3hPostInj{j})));
    NumWAKE_sal_3hPostInj(j)=length(length(and(b{j}.Wake,epoch_3hPostInj{j})));
    NumREM_sal_3hPostInj(j)=length(length(and(b{j}.REMEpoch,epoch_3hPostInj{j})));
    
    %duration of bouts pre injection
    durWAKE_sal_pre(j)=mean(End(and(b{j}.Wake,epoch_PreInj_sal{j}))-Start(and(b{j}.Wake,epoch_PreInj_sal{j})))/1E4;
    durSWS_sal_pre(j)=mean(End(and(b{j}.SWSEpoch,epoch_PreInj_sal{j}))-Start(and(b{j}.SWSEpoch,epoch_PreInj_sal{j})))/1E4;
    durREM_sal_pre(j)=mean(End(and(b{j}.REMEpoch,epoch_PreInj_sal{j}))-Start(and(b{j}.REMEpoch,epoch_PreInj_sal{j})))/1E4;
    %duration of bouts post injection
    durWAKE_sal_post(j)=mean(End(and(b{j}.Wake,epoch_PostInj_sal{j}))-Start(and(b{j}.Wake,epoch_PostInj_sal{j})))/1E4;
    durSWS_sal_post(j)=mean(End(and(b{j}.SWSEpoch,epoch_PostInj_sal{j}))-Start(and(b{j}.SWSEpoch,epoch_PostInj_sal{j})))/1E4;
    durREM_sal_post(j)=mean(End(and(b{j}.REMEpoch,epoch_PostInj_sal{j}))-Start(and(b{j}.REMEpoch,epoch_PostInj_sal{j})))/1E4;
    %diration of bouts 3h post injection
    durWAKE_sal_3hPostInj(j)=mean(End(and(b{j}.Wake,epoch_3hPostInj{j}))-Start(and(b{j}.Wake,epoch_3hPostInj{j})))/1E4;
    durSWS_sal_3hPostInj(j)=mean(End(and(b{j}.SWSEpoch,epoch_3hPostInj{j}))-Start(and(b{j}.SWSEpoch,epoch_3hPostInj{j})))/1E4;
    durREM_sal_3hPostInj(j)=mean(End(and(b{j}.REMEpoch,epoch_3hPostInj{j}))-Start(and(b{j}.REMEpoch,epoch_3hPostInj{j})))/1E4;
end


%% CNO
for k=1:length(DirCNO.path)
    cd(DirCNO.path{k}{1});
%     mname{k}=DirCNO.nMice{k};
%     if mname{k}==1037
%         c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
%     else
        c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        c{k}.SWSEpoch = mergeCloseIntervals(c{k}.SWSEpoch, 1e4);
        c{k}.REMEpoch = mergeCloseIntervals(c{k}.REMEpoch, 1e4);
        c{k}.Wake = mergeCloseIntervals(c{k}.Wake, 1e4);
%     end
    %     c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate day in different periods
    durtotal_cno{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_cno{j} = intervalSet(0, durtotal_cno{j}/2);
    %post injection
    epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal_cno{k});
    %     epoch_PostInj_cno{j} = intervalSet(durtotal_cno{j}/2,durtotal_cno{j});
    %3h post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    Restemp_cno{k}=ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    %percentage pre injection
    percWAKE_CNO_pre(k) = Restemp_cno{k}(1,2);
    percSWS_CNO_pre(k) = Restemp_cno{k}(2,2);
    percREM_CNO_pre(k) = Restemp_cno{k}(3,2);
    %percentage post injection
    percWAKE_CNO_post(k) = Restemp_cno{k}(1,3);
    percSWS_CNO_post(k) = Restemp_cno{k}(2,3);
    percREM_CNO_post(k) = Restemp_cno{k}(3,3);
    %percentage 3h post injection
    percWAKE_CNO_3hPostInj(k) = Restemp_cno{k}(1,4);
    percSWS_CNO_3hPostInj(k) = Restemp_cno{k}(2,4);
    percREM_CNO_3hPostInj(k) = Restemp_cno{k}(3,4);
    
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_cno{k}=ComputeSleepStagesPercentagesWithoutWakeMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_CNO_pre(k)=Restemp_totSleep_cno{k}(3,2); %percREM_totSleep_CNO_pre(percREM_totSleep_CNO_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_CNO_post(k)=Restemp_totSleep_cno{k}(3,3); %percREM_totSleep_CNO_post(percREM_totSleep_CNO_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_CNO_3hPostInj(k)=Restemp_totSleep_cno{k}(3,4); %percREM_totSleep_CNO_3hPostInj(percREM_totSleep_CNO_3hPostInj==0)=NaN;
    
    
    
    %number of bouts pre injection
    NumSWS_CNO_pre(k) = length(length(and(c{k}.SWSEpoch,epoch_PreInj_cno{k})));
    NumWAKE_CNO_pre(k) = length(length(and(c{k}.Wake,epoch_PreInj_cno{k})));
    NumREM_CNO_pre(k) = length(length(and(c{k}.REMEpoch,epoch_PreInj_cno{k})));
    %number of bouts post injection
    NumSWS_CNO_post(k) = length(length(and(c{k}.SWSEpoch,epoch_PostInj_cno{k})));
    NumWAKE_CNO_post(k) = length(length(and(c{k}.Wake,epoch_PostInj_cno{k})));
    NumREM_CNO_post(k) = length(length(and(c{k}.REMEpoch,epoch_PostInj_cno{k})));
    %number of bouts 3h post injection
    NumSWS_CNO_3hPostInj(k) = length(length(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k})));
    NumWAKE_CNO_3hPostInj(k) = length(length(and(c{k}.Wake,epoch_3hPostInj_cno{k})));
    NumREM_CNO_3hPostInj(k) = length(length(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k})));
    
    %duration of bouts pre injection
    durWAKE_CNO_pre(k) = mean(End(and(c{k}.Wake,epoch_PreInj_cno{k}))-Start(and(c{k}.Wake,epoch_PreInj_cno{k})))/1E4;
    durSWS_CNO_pre(k) = mean(End(and(c{k}.SWSEpoch,epoch_PreInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_PreInj_cno{k})))/1E4;
    durREM_CNO_pre(k) = mean(End(and(c{k}.REMEpoch,epoch_PreInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_PreInj_cno{k})))/1E4;
    %duration of bouts post injection
    durWAKE_CNO_post(k) = mean(End(and(c{k}.Wake,epoch_PostInj_cno{k}))-Start(and(c{k}.Wake,epoch_PostInj_cno{k})))/1E4;
    durSWS_CNO_post(k) = mean(End(and(c{k}.SWSEpoch,epoch_PostInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_PostInj_cno{k})))/1E4;
    durREM_CNO_post(k) = mean(End(and(c{k}.REMEpoch,epoch_PostInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_PostInj_cno{k})))/1E4;
    %duration of bouts 3h post injection
    durWAKE_CNO_3hPostInj(k) = mean(End(and(c{k}.Wake,epoch_3hPostInj_cno{k}))-Start(and(c{k}.Wake,epoch_3hPostInj_cno{k})))/1E4;
    durSWS_CNO_3hPostInj(k) = mean(End(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k}))-Start(and(c{k}.SWSEpoch,epoch_3hPostInj_cno{k})))/1E4;
    durREM_CNO_3hPostInj(k) = mean(End(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k}))-Start(and(c{k}.REMEpoch,epoch_3hPostInj_cno{k})))/1E4;
    
    if isnan(durREM_CNO_post(k))==1
        durREM_CNO_post(k)=0;
    else
    end
    
    
    if isnan(durREM_CNO_3hPostInj(k))==1
        durREM_CNO_3hPostInj(k)=0;
    else
    end
    
end

%% correlations

change_percWAKE_basal = ((percWAKE_basal_post - percWAKE_basal_pre) ./ percWAKE_basal_pre).*100;
change_percWAKE_saline = ((percWAKE_sal_post - percWAKE_sal_pre) ./ percWAKE_sal_pre).*100;
change_percWAKE_cno = ((percWAKE_CNO_post - percWAKE_CNO_pre) ./ percWAKE_CNO_pre).*100;

change_percSWS_basal = ((percSWS_basal_post - percSWS_basal_pre) ./ percSWS_basal_pre).*100;
change_percSWS_saline = ((percSWS_sal_post - percSWS_sal_pre) ./ percSWS_sal_pre).*100;
change_percSWS_cno = ((percSWS_CNO_post - percSWS_CNO_pre) ./ percSWS_CNO_pre).*100;

change_percREM_basal = ((percREM_totSleep_basal_post - percREM_totSleep_basal_pre) ./ percREM_totSleep_basal_pre).*100;
change_percREM_saline = ((percREM_totSleep_sal_post - percREM_totSleep_sal_pre) ./ percREM_totSleep_sal_pre).*100;
change_percREM_cno = ((percREM_totSleep_CNO_post - percREM_totSleep_CNO_pre) ./ percREM_totSleep_CNO_pre).*100;



figure
subplot(121)
s1=plot(change_percREM_basal, change_percWAKE_basal,'ko',change_percREM_saline, change_percWAKE_saline,'bs', change_percREM_cno, change_percWAKE_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep percentage change (%)')
ylabel('Wake sleep percentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('Baseline','Saline','CNO')
xlim([-110 110])
ylim([-100 100])
set(gca,'FontSize',14)

subplot(122)
s1=plot(change_percREM_basal, change_percSWS_basal,'ko',change_percREM_saline, change_percSWS_saline,'bs', change_percREM_cno, change_percSWS_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep percentage change (%)')
ylabel('NREM sleep percentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('Baseline','Saline','CNO')
xlim([-110 110])
ylim([-100 100])
set(gca,'FontSize',14)

%% figures
%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0];%rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2];
col_post_cno = [0.4 1 0.2];

figure
subplot(433)
MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal_pre,percREM_totSleep_sal_pre,percREM_totSleep_CNO_pre, percREM_totSleep_basal_post,percREM_totSleep_sal_post,percREM_totSleep_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('REM percentage (%)')
title('/ total sleep')

subplot(434)
MakeSpreadAndBoxPlot2_SB({percWAKE_basal_pre,percWAKE_sal_pre,percWAKE_CNO_pre, percWAKE_basal_post,percWAKE_sal_post, percWAKE_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Wake percentage (%)')

subplot(435)
MakeSpreadAndBoxPlot2_SB({percSWS_basal_pre,percSWS_sal_pre,percSWS_CNO_pre, percSWS_basal_post,percSWS_sal_post,percSWS_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('NREM percentage (%)')

subplot(436)
MakeSpreadAndBoxPlot2_SB({percREM_basal_pre,percREM_sal_pre,percREM_CNO_pre, percREM_basal_post,percREM_sal_post,percREM_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('REM percentage (%)')
title('/ total session')


subplot(437)
MakeSpreadAndBoxPlot2_SB({NumWAKE_basal_pre,NumWAKE_sal_pre,NumWAKE_CNO_pre, NumWAKE_basal_post,NumWAKE_sal_post, NumWAKE_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('# Wake bouts')

subplot(438)
MakeSpreadAndBoxPlot2_SB({NumSWS_basal_pre,NumSWS_sal_pre,NumSWS_CNO_pre, NumSWS_basal_post,NumSWS_sal_post,NumSWS_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('# NREM bouts')

subplot(439)
MakeSpreadAndBoxPlot2_SB({NumREM_basal_pre,NumREM_sal_pre,NumREM_CNO_pre, NumREM_basal_post,NumREM_sal_post,NumREM_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('# REM bouts')

subplot(4,3,10)
MakeSpreadAndBoxPlot2_SB({durWAKE_basal_pre,durWAKE_sal_pre,durWAKE_CNO_pre, durWAKE_basal_post,durWAKE_sal_post, durWAKE_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Mean duration of Wake (s)')

subplot(4,3,11)
MakeSpreadAndBoxPlot2_SB({durSWS_basal_pre,durSWS_sal_pre,durSWS_CNO_pre, durSWS_basal_post,durSWS_sal_post,durSWS_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Mean duration of NREM (s)')

subplot(4,3,12)
MakeSpreadAndBoxPlot2_SB({durREM_basal_pre,durREM_sal_pre,durREM_CNO_pre, durREM_basal_post,durREM_sal_post,durREM_CNO_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Mean duration of REM (s)')




%% 3h post SD


figure
subplot(433)
MakeBoxPlot_MC({percREM_totSleep_basal_pre,percREM_totSleep_sal_pre,percREM_totSleep_CNO_pre, percREM_totSleep_basal_3hPostInj,percREM_totSleep_sal_3hPostInj,percREM_totSleep_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('REM percentage (%)')
title('/ total sleep')

subplot(434)
MakeBoxPlot_MC({percWAKE_basal_pre,percWAKE_sal_pre,percWAKE_CNO_pre, percWAKE_basal_3hPostInj,percWAKE_sal_3hPostInj, percWAKE_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Wake percentage (%)')

subplot(435)
MakeBoxPlot_MC({percSWS_basal_pre,percSWS_sal_pre,percSWS_CNO_pre, percSWS_basal_3hPostInj,percSWS_sal_3hPostInj,percSWS_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('NREM percentage (%)')

subplot(436)
MakeBoxPlot_MC({percREM_basal_pre,percREM_sal_pre,percREM_CNO_pre, percREM_basal_3hPostInj,percREM_sal_3hPostInj,percREM_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('REM percentage (%)')
title('/ total session')


subplot(437)
MakeBoxPlot_MC({NumWAKE_basal_pre,NumWAKE_sal_pre,NumWAKE_CNO_pre, NumWAKE_basal_3hPostInj,NumWAKE_sal_3hPostInj, NumWAKE_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('# Wake bouts')

subplot(438)
MakeBoxPlot_MC({NumSWS_basal_pre,NumSWS_sal_pre,NumSWS_CNO_pre, NumSWS_basal_3hPostInj,NumSWS_sal_3hPostInj,NumSWS_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('# NREM bouts')

subplot(439)
MakeBoxPlot_MC({NumREM_basal_pre,NumREM_sal_pre,NumREM_CNO_pre, NumREM_basal_3hPostInj,NumREM_sal_3hPostInj,NumREM_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('# REM bouts')

subplot(4,3,10)
MakeBoxPlot_MC({durWAKE_basal_pre,durWAKE_sal_pre,durWAKE_CNO_pre, durWAKE_basal_3hPostInj,durWAKE_sal_3hPostInj, durWAKE_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of Wake (s)')

subplot(4,3,11)
MakeBoxPlot_MC({durSWS_basal_pre,durSWS_sal_pre,durSWS_CNO_pre, durSWS_basal_3hPostInj,durSWS_sal_3hPostInj,durSWS_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of NREM (s)')

subplot(4,3,12)
MakeBoxPlot_MC({durREM_basal_pre,durREM_sal_pre,durREM_CNO_pre, durREM_basal_3hPostInj,durREM_sal_3hPostInj,durREM_CNO_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of REM (s)')



%%%% figures
%%

col_pre_saline = [.7 .7 .7];
col_post_saline = [.7 .7 .7];

col_pre_cno = [1 .4 0];
col_post_cno = [1 .4 0];

% col_pre_cno = [.2 .8 0]; %vert
% col_post_cno = [.2 .8 0];


% col_pre_cno = [0 .4 .8]; % bleu
% col_post_cno = [0 .4 .8];


figure
subplot(344)
MakeSpreadAndBoxPlot2_SB({percREM_totSleep_sal_pre,percREM_totSleep_CNO_pre, percREM_totSleep_sal_post,percREM_totSleep_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('REM percentage (%)')
title('/ total sleep')
makepretty

subplot(341)
MakeSpreadAndBoxPlot2_SB({percWAKE_sal_pre,percWAKE_CNO_pre, percWAKE_sal_post, percWAKE_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Wake percentage (%)')
makepretty

subplot(342)
MakeSpreadAndBoxPlot2_SB({percSWS_sal_pre,percSWS_CNO_pre, percSWS_sal_post,percSWS_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('NREM percentage (%)')
makepretty

subplot(343)
MakeSpreadAndBoxPlot2_SB({percREM_sal_pre,percREM_CNO_pre, percREM_sal_post,percREM_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('REM percentage (%)')
title('/ total session')
makepretty


subplot(345)
MakeSpreadAndBoxPlot2_SB({NumWAKE_sal_pre,NumWAKE_CNO_pre, NumWAKE_sal_post, NumWAKE_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('# Wake bouts')
makepretty

subplot(346)
MakeSpreadAndBoxPlot2_SB({NumSWS_sal_pre,NumSWS_CNO_pre, NumSWS_sal_post,NumSWS_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('# NREM bouts')
makepretty

subplot(347)
MakeSpreadAndBoxPlot2_SB({NumREM_sal_pre,NumREM_CNO_pre, NumREM_sal_post,NumREM_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('# REM bouts')
makepretty

subplot(349)
MakeSpreadAndBoxPlot2_SB({durWAKE_sal_pre,durWAKE_CNO_pre, durWAKE_sal_post, durWAKE_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Mean duration of Wake (s)')
makepretty

subplot(3,4,10)
MakeSpreadAndBoxPlot2_SB({durSWS_sal_pre,durSWS_CNO_pre, durSWS_sal_post,durSWS_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Mean duration of NREM (s)')
makepretty

subplot(3,4,11)
MakeSpreadAndBoxPlot2_SB({durREM_sal_pre,durREM_CNO_pre, durREM_sal_post,durREM_CNO_post},...
    {col_pre_saline col_pre_cno col_post_saline col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','showsigstar','none','showpoints',0);
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Mean duration of REM (s)')
makepretty

%% ADD STATS
subplot(3,4,4)
[h,p_pre]=ttest(percREM_totSleep_sal_pre,percREM_totSleep_CNO_pre);
[h,p_post]=ttest(percREM_totSleep_sal_post,percREM_totSleep_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,1)
[h,p_pre]=ttest(percWAKE_sal_pre,percWAKE_CNO_pre);
[h,p_post]=ttest(percWAKE_sal_post, percWAKE_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,2)
[h,p_pre]=ttest(percSWS_sal_pre,percSWS_CNO_pre);
[h,p_post]=ttest(percSWS_sal_post,percSWS_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,3)
[h,p_pre]=ttest(percREM_sal_pre,percREM_CNO_pre);
[h,p_post]=ttest(percREM_sal_post,percREM_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,5)
[h,p_pre]=ttest(NumWAKE_sal_pre,NumWAKE_CNO_pre);
[h,p_post]=ttest(NumWAKE_sal_post, NumWAKE_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,6)
[h,p_pre]=ttest(NumSWS_sal_pre,NumSWS_CNO_pre);
[h,p_post]=ttest(NumSWS_sal_post,NumSWS_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,7)
[h,p_pre]=ttest(NumREM_sal_pre,NumREM_CNO_pre);
[h,p_post]=ttest(NumREM_sal_post,NumREM_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,9)
[h,p_pre]=ttest(durWAKE_sal_pre,durWAKE_CNO_pre);
[h,p_post]=ttest(durWAKE_sal_post, durWAKE_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,10)
[h,p_pre]=ttest(durSWS_sal_pre,durSWS_CNO_pre);
[h,p_post]=ttest(durSWS_sal_post,durSWS_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])


subplot(3,4,11)
[h,p_pre]=ttest(durREM_sal_pre,durREM_CNO_pre);
[h,p_post]=ttest(durREM_sal_post,durREM_CNO_post);

if p_pre<0.05; sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24); end
if p_post<0.05; sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24); end
title(['p pre = ', num2str(p_pre), ' p post = ', num2str(p_post)])

