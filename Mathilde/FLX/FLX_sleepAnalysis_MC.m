%% input dir
%%basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

%%saline
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);


%% FLX
DirCNO = PathForExperimentsFLX_MC('dreadd_PFC_saline_flx');
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1196 1237 1238 1245 1248 1247]);


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%% get data BASELINE sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
        %post injection
        epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%percentage : all session
        Restemp_basal{i}=ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
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
        Restemp_totSleep_basal{i}=ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
        %percentage pre injection
        percREM_totSleep_basal_pre(i)=Restemp_totSleep_basal{i}(3,2); percREM_totSleep_basal_pre(percREM_totSleep_basal_pre==0)=NaN;
        %percentage post injection
        percREM_totSleep_basal_post(i)=Restemp_totSleep_basal{i}(3,3); percREM_totSleep_basal_post(percREM_totSleep_basal_post==0)=NaN;
        %percentage 3h post injection
        percREM_totSleep_basal_3hPostInj(i)=Restemp_totSleep_basal{i}(3,4); percREM_totSleep_basal_3hPostInj(percREM_totSleep_basal_3hPostInj==0)=NaN;
        
        %number of bouts pre injection
        NumSWS_basal_pre(i)=length(length(and(a{i}.SWSEpoch,epoch_PreInj_basal{i}))); NumSWS_basal_pre(NumSWS_basal_pre==0)=NaN;
        NumWAKE_basal_pre(i)=length(length(and(a{i}.Wake,epoch_PreInj_basal{i}))); NumWAKE_basal_pre(NumWAKE_basal_pre==0)=NaN;
        NumREM_basal_pre(i)=length(length(and(a{i}.REMEpoch,epoch_PreInj_basal{i}))); NumREM_basal_pre(NumREM_basal_pre==0)=NaN;
        %number of bouts post injection
        NumSWS_basal_post(i)=length(length(and(a{i}.SWSEpoch,epoch_PostInj_basal{i}))); NumSWS_basal_post(NumSWS_basal_post==0)=NaN;
        NumWAKE_basal_post(i)=length(length(and(a{i}.Wake,epoch_PostInj_basal{i}))); NumWAKE_basal_post(NumWAKE_basal_post==0)=NaN;
        NumREM_basal_post(i)=length(length(and(a{i}.REMEpoch,epoch_PostInj_basal{i}))); NumREM_basal_post(NumREM_basal_post==0)=NaN;
        %number of bouts 3h post injection
        NumSWS_basal_3hPostInj(i)=length(length(and(a{i}.SWSEpoch,epoch_3hPostInj_basal{i}))); NumSWS_basal_3hPostInj(NumSWS_basal_3hPostInj==0)=NaN;
        NumWAKE_basal_3hPostInj(i)=length(length(and(a{i}.Wake,epoch_3hPostInj_basal{i}))); NumWAKE_basal_3hPostInj(NumWAKE_basal_3hPostInj==0)=NaN;
        NumREM_basal_3hPostInj(i)=length(length(and(a{i}.REMEpoch,epoch_3hPostInj_basal{i}))); NumREM_basal_3hPostInj(NumREM_basal_3hPostInj==0)=NaN;
        
        %duration of bouts pre injection
        durWAKE_basal_pre(i)=mean(End(and(a{i}.Wake,epoch_PreInj_basal{i}))-Start(and(a{i}.Wake,epoch_PreInj_basal{i})))/1E4;
        durSWS_basal_pre(i)=mean(End(and(a{i}.SWSEpoch,epoch_PreInj_basal{i}))-Start(and(a{i}.SWSEpoch,epoch_PreInj_basal{i})))/1E4;
        durREM_basal_pre(i)=mean(End(and(a{i}.REMEpoch,epoch_PreInj_basal{i}))-Start(and(a{i}.REMEpoch,epoch_PreInj_basal{i})))/1E4;
        durWAKE_basal_pre(durWAKE_basal_pre==0)=NaN;
        durSWS_basal_pre(durSWS_basal_pre==0)=NaN;
        durREM_basal_pre(durREM_basal_pre==0)=NaN;
        %duration of bouts post injection
        durWAKE_basal_post(i)=mean(End(and(a{i}.Wake,epoch_PostInj_basal{i}))-Start(and(a{i}.Wake,epoch_PostInj_basal{i})))/1E4;
        durSWS_basal_post(i)=mean(End(and(a{i}.SWSEpoch,epoch_PostInj_basal{i}))-Start(and(a{i}.SWSEpoch,epoch_PostInj_basal{i})))/1E4;
        durREM_basal_post(i)=mean(End(and(a{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(a{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
        durWAKE_basal_post(durWAKE_basal_post==0)=NaN;
        durSWS_basal_post(durSWS_basal_post==0)=NaN;
        durREM_basal_post(durREM_basal_post==0)=NaN;
        %duration of bouts 3h post injection
        durWAKE_basal_3hPostInj(i)=mean(End(and(a{i}.Wake,epoch_3hPostInj_basal{i}))-Start(and(a{i}.Wake,epoch_3hPostInj_basal{i})))/1E4;
        durSWS_basal_3hPostInj(i)=mean(End(and(a{i}.SWSEpoch,epoch_3hPostInj_basal{i}))-Start(and(a{i}.SWSEpoch,epoch_3hPostInj_basal{i})))/1E4;
        durREM_basal_3hPostInj(i)=mean(End(and(a{i}.REMEpoch,epoch_3hPostInj_basal{i}))-Start(and(a{i}.REMEpoch,epoch_3hPostInj_basal{i})))/1E4;
        durWAKE_basal_3hPostInj(durWAKE_basal_3hPostInj==0)=NaN;
        durSWS_basal_3hPostInj(durSWS_basal_3hPostInj==0)=NaN;
        durREM_basal_3hPostInj(durREM_basal_3hPostInj==0)=NaN;
    else
    end
end

%% get data SALINE sleep
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
%     b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    b{j} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
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

%% get data SALINE FLX
for k=1:length(DirSalineFLX.path)
    cd(DirSalineFLX.path{k}{1});
%     c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate day in different periods
    durtotal_flx{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_sal_flx_flx{k} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_sal_flx{i} = intervalSet(0, durtotal{i}/2);
    %post injection
    epoch_PostInj_sal_flx{k} = intervalSet(st_epoch_postInj,durtotal_flx{k});
    %     epoch_PostInj_sal_flx{i} = intervalSet(durtotal{i}/2,durtotal{i});
    %3h post injection
    epoch_3hPostInj_flx{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    Restemp_sal_flx{k}=ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch); %get states percentage
    %percentage pre injection
    percWAKE_sal_flx_pre(k)=Restemp_sal_flx{k}(1,2);
    percSWS_sal_flx_pre(k)=Restemp_sal_flx{k}(2,2);
    percREM_sal_flx_pre(k)=Restemp_sal_flx{k}(3,2);
    %percentage post injection
    percWAKE_sal_flx_post(k)=Restemp_sal_flx{k}(1,3);
    percSWS_sal_flx_post(k)=Restemp_sal_flx{k}(2,3);
    percREM_sal_flx_post(k)=Restemp_sal_flx{k}(3,3);
    %percentage 3h post injection
    percWAKE_sal_flx_3hPostInj(k)=Restemp_sal_flx{k}(1,4);
    percSWS_sal_flx_3hPostInj(k)=Restemp_sal_flx{k}(2,4);
    percREM_sal_flx_3hPostInj(k)=Restemp_sal_flx{k}(3,4);
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_sal_flx{k}=ComputeSleepStagesPercentagesWithoutWakeMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_sal_flx_pre(k)=Restemp_totSleep_sal_flx{k}(3,2); percREM_totSleep_sal_flx_pre(percREM_totSleep_sal_flx_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_sal_flx_post(k)=Restemp_totSleep_sal_flx{k}(3,3); percREM_totSleep_sal_flx_post(percREM_totSleep_sal_flx_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_sal_flx_3hPostInj(k)=Restemp_totSleep_sal_flx{k}(3,4); percREM_totSleep_sal_flx_3hPostInj(percREM_totSleep_sal_flx_3hPostInj==0)=NaN;
    
    %number of bouts pre injection
    NumSWS_sal_flx_pre(k)=length(length(and(c{k}.SWSEpoch,epoch_PreInj_sal_flx_flx{k})));
    NumWAKE_sal_flx_pre(k)=length(length(and(c{k}.Wake,epoch_PreInj_sal_flx_flx{k})));
    NumREM_sal_flx_pre(k)=length(length(and(c{k}.REMEpoch,epoch_PreInj_sal_flx_flx{k})));
    %number of bouts post injection
    NumSWS_sal_flx_post(k)=length(length(and(c{k}.SWSEpoch,epoch_PostInj_sal_flx{k})));
    NumWAKE_sal_flx_post(k)=length(length(and(c{k}.Wake,epoch_PostInj_sal_flx{k})));
    NumREM_sal_flx_post(k)=length(length(and(c{k}.REMEpoch,epoch_PostInj_sal_flx{k})));
    %nuumber of bouts 3h post injection
    NumSWS_sal_flx_3hPostInj(k)=length(length(and(c{k}.SWSEpoch,epoch_3hPostInj_flx{k})));
    NumWAKE_sal_flx_3hPostInj(k)=length(length(and(c{k}.Wake,epoch_3hPostInj_flx{k})));
    NumREM_sal_flx_3hPostInj(k)=length(length(and(c{k}.REMEpoch,epoch_3hPostInj_flx{k})));
    
    %duration of bouts pre injection
    durWAKE_sal_flx_pre(k)=mean(End(and(c{k}.Wake,epoch_PreInj_sal_flx_flx{k}))-Start(and(c{k}.Wake,epoch_PreInj_sal_flx_flx{k})))/1E4;
    durSWS_sal_flx_pre(k)=mean(End(and(c{k}.SWSEpoch,epoch_PreInj_sal_flx_flx{k}))-Start(and(c{k}.SWSEpoch,epoch_PreInj_sal_flx_flx{k})))/1E4;
    durREM_sal_flx_pre(k)=mean(End(and(c{k}.REMEpoch,epoch_PreInj_sal_flx_flx{k}))-Start(and(c{k}.REMEpoch,epoch_PreInj_sal_flx_flx{k})))/1E4;
    %duration of bouts post injection
    durWAKE_sal_flx_post(k)=mean(End(and(c{k}.Wake,epoch_PostInj_sal_flx{k}))-Start(and(c{k}.Wake,epoch_PostInj_sal_flx{k})))/1E4;
    durSWS_sal_flx_post(k)=mean(End(and(c{k}.SWSEpoch,epoch_PostInj_sal_flx{k}))-Start(and(c{k}.SWSEpoch,epoch_PostInj_sal_flx{k})))/1E4;
    durREM_sal_flx_post(k)=mean(End(and(c{k}.REMEpoch,epoch_PostInj_sal_flx{k}))-Start(and(c{k}.REMEpoch,epoch_PostInj_sal_flx{k})))/1E4;
    %diration of bouts 3h post injection
    durWAKE_sal_flx_3hPostInj(k)=mean(End(and(c{k}.Wake,epoch_3hPostInj_flx{k}))-Start(and(c{k}.Wake,epoch_3hPostInj_flx{k})))/1E4;
    durSWS_sal_flx_3hPostInj(k)=mean(End(and(c{k}.SWSEpoch,epoch_3hPostInj_flx{k}))-Start(and(c{k}.SWSEpoch,epoch_3hPostInj_flx{k})))/1E4;
    durREM_sal_flx_3hPostInj(k)=mean(End(and(c{k}.REMEpoch,epoch_3hPostInj_flx{k}))-Start(and(c{k}.REMEpoch,epoch_3hPostInj_flx{k})))/1E4;
end

%% get data SALINE FLX
for l=1:length(DirCNOFLX.path)
    cd(DirCNOFLX.path{l}{1});
%     d{l} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    d{l} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate day in different periods
    durtotal_flx{l} = max([max(End(d{l}.Wake)),max(End(d{l}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno_flx_flx{l} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_cno_flx{i} = intervalSet(0, durtotal{i}/2);
    %post injection
    epoch_PostInj_cno_flx{l} = intervalSet(st_epoch_postInj,durtotal_flx{l});
    %     epoch_PostInj_cno_flx{i} = intervalSet(durtotal{i}/2,durtotal{i});
    %3h post injection
    epoch_3hPostInj_flx{l}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    Restemp_cno_flx{l}=ComputeSleepStagesPercentagesMC(d{l}.Wake,d{l}.SWSEpoch,d{l}.REMEpoch); %get states percentage
    %percentage pre injection
    percWAKE_cno_flx_pre(l)=Restemp_cno_flx{l}(1,2);
    percSWS_cno_flx_pre(l)=Restemp_cno_flx{l}(2,2);
    percREM_cno_flx_pre(l)=Restemp_cno_flx{l}(3,2);
    %percentage post injection
    percWAKE_cno_flx_post(l)=Restemp_cno_flx{l}(1,3);
    percSWS_cno_flx_post(l)=Restemp_cno_flx{l}(2,3);
    percREM_cno_flx_post(l)=Restemp_cno_flx{l}(3,3);
    %percentage 3h post injection
    percWAKE_cno_flx_3hPostInj(l)=Restemp_cno_flx{l}(1,4);
    percSWS_cno_flx_3hPostInj(l)=Restemp_cno_flx{l}(2,4);
    percREM_cno_flx_3hPostInj(l)=Restemp_cno_flx{l}(3,4);
    
    %%percentage of REM out of total sleep
    Restemp_totSleep_cno_flx{l}=ComputeSleepStagesPercentagesWithoutWakeMC(d{l}.Wake,d{l}.SWSEpoch,d{l}.REMEpoch);
    %percentage pre injection
    percREM_totSleep_cno_flx_pre(l)=Restemp_totSleep_cno_flx{l}(3,2); percREM_totSleep_cno_flx_pre(percREM_totSleep_cno_flx_pre==0)=NaN;
    %percentage post injection
    percREM_totSleep_cno_flx_post(l)=Restemp_totSleep_cno_flx{l}(3,3); percREM_totSleep_cno_flx_post(percREM_totSleep_cno_flx_post==0)=NaN;
    %percentage 3h post injection
    percREM_totSleep_cno_flx_3hPostInj(l)=Restemp_totSleep_cno_flx{l}(3,4); percREM_totSleep_cno_flx_3hPostInj(percREM_totSleep_cno_flx_3hPostInj==0)=NaN;
    
    %number of bouts pre injection
    NumSWS_cno_flx_pre(l)=length(length(and(d{l}.SWSEpoch,epoch_PreInj_cno_flx_flx{l})));
    NumWAKE_cno_flx_pre(l)=length(length(and(d{l}.Wake,epoch_PreInj_cno_flx_flx{l})));
    NumREM_cno_flx_pre(l)=length(length(and(d{l}.REMEpoch,epoch_PreInj_cno_flx_flx{l})));
    %number of bouts post injection
    NumSWS_cno_flx_post(l)=length(length(and(d{l}.SWSEpoch,epoch_PostInj_cno_flx{l})));
    NumWAKE_cno_flx_post(l)=length(length(and(d{l}.Wake,epoch_PostInj_cno_flx{l})));
    NumREM_cno_flx_post(l)=length(length(and(d{l}.REMEpoch,epoch_PostInj_cno_flx{l})));
    %nuumber of bouts 3h post injection
    NumSWS_cno_flx_3hPostInj(l)=length(length(and(d{l}.SWSEpoch,epoch_3hPostInj_flx{l})));
    NumWAKE_cno_flx_3hPostInj(l)=length(length(and(d{l}.Wake,epoch_3hPostInj_flx{l})));
    NumREM_cno_flx_3hPostInj(l)=length(length(and(d{l}.REMEpoch,epoch_3hPostInj_flx{l})));
    
    %duration of bouts pre injection
    durWAKE_cno_flx_pre(l)=mean(End(and(d{l}.Wake,epoch_PreInj_cno_flx_flx{l}))-Start(and(d{l}.Wake,epoch_PreInj_cno_flx_flx{l})))/1E4;
    durSWS_cno_flx_pre(l)=mean(End(and(d{l}.SWSEpoch,epoch_PreInj_cno_flx_flx{l}))-Start(and(d{l}.SWSEpoch,epoch_PreInj_cno_flx_flx{l})))/1E4;
    durREM_cno_flx_pre(l)=mean(End(and(d{l}.REMEpoch,epoch_PreInj_cno_flx_flx{l}))-Start(and(d{l}.REMEpoch,epoch_PreInj_cno_flx_flx{l})))/1E4;
    %duration of bouts post injection
    durWAKE_cno_flx_post(l)=mean(End(and(d{l}.Wake,epoch_PostInj_cno_flx{l}))-Start(and(d{l}.Wake,epoch_PostInj_cno_flx{l})))/1E4;
    durSWS_cno_flx_post(l)=mean(End(and(d{l}.SWSEpoch,epoch_PostInj_cno_flx{l}))-Start(and(d{l}.SWSEpoch,epoch_PostInj_cno_flx{l})))/1E4;
    durREM_cno_flx_post(l)=mean(End(and(d{l}.REMEpoch,epoch_PostInj_cno_flx{l}))-Start(and(d{l}.REMEpoch,epoch_PostInj_cno_flx{l})))/1E4;
    %diration of bouts 3h post injection
    durWAKE_cno_flx_3hPostInj(l)=mean(End(and(d{l}.Wake,epoch_3hPostInj_flx{l}))-Start(and(d{l}.Wake,epoch_3hPostInj_flx{l})))/1E4;
    durSWS_cno_flx_3hPostInj(l)=mean(End(and(d{l}.SWSEpoch,epoch_3hPostInj_flx{l}))-Start(and(d{l}.SWSEpoch,epoch_3hPostInj_flx{l})))/1E4;
    durREM_cno_flx_3hPostInj(l)=mean(End(and(d{l}.REMEpoch,epoch_3hPostInj_flx{l}))-Start(and(d{l}.REMEpoch,epoch_3hPostInj_flx{l})))/1E4;
end

%% figures
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

col_pre_saline = [0 .6 1]; %%bleu
col_post_saline = [0 .6 1];

col_pre_sal_flx = [0 .4 .8];
col_post_sal_flx = [0 .4 .8];

col_pre_cno_flx = [0 0 .6];
col_post_cno_flx = [0 0 .6];

%% all session
figure
subplot(433)
MakeSpreadAndBoxPlot2_SB({percREM_totSleep_basal_pre,percREM_totSleep_sal_pre,percREM_totSleep_sal_flx_pre,percREM_totSleep_cno_flx_pre, ...
    percREM_totSleep_basal_post,percREM_totSleep_sal_post,percREM_totSleep_sal_flx_post,percREM_totSleep_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('REM percentage (%)')
title('/ total sleep')


subplot(434)
MakeSpreadAndBoxPlot2_SB({percWAKE_basal_pre,percWAKE_sal_pre,percWAKE_sal_flx_pre,percWAKE_cno_flx_pre, ...
    percWAKE_basal_post,percWAKE_sal_post,percWAKE_sal_flx_post,percWAKE_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Wake percentage (%)')

subplot(435)
MakeSpreadAndBoxPlot2_SB({percSWS_basal_pre,percSWS_sal_pre,percSWS_sal_flx_pre,percSWS_cno_flx_pre, ...
    percSWS_basal_post,percSWS_sal_post,percSWS_sal_flx_post,percSWS_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('NREM percentage (%)')

subplot(436)
MakeSpreadAndBoxPlot2_SB({percREM_basal_pre,percREM_sal_pre,percREM_sal_flx_pre,percREM_cno_flx_pre, ...
    percREM_basal_post,percREM_sal_post,percREM_sal_flx_post,percREM_cno_flx_post},...    
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('REM percentage (%)')
title('/ total session')

subplot(437)
MakeSpreadAndBoxPlot2_SB({NumWAKE_basal_pre,NumWAKE_sal_pre,NumWAKE_sal_flx_pre,NumWAKE_cno_flx_pre ...
    NumWAKE_basal_post,NumWAKE_sal_post, NumWAKE_sal_flx_post,NumWAKE_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# Wake bouts')

subplot(438)
MakeSpreadAndBoxPlot2_SB({NumSWS_basal_pre,NumSWS_sal_pre,NumSWS_sal_flx_pre,NumSWS_cno_flx_pre ...
    NumSWS_basal_post,NumSWS_sal_post, NumSWS_sal_flx_post,NumSWS_cno_flx_post},...    
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# NREM bouts')

subplot(439)
MakeSpreadAndBoxPlot2_SB({NumREM_basal_pre,NumREM_sal_pre,NumREM_sal_flx_pre,NumREM_cno_flx_pre ...
    NumREM_basal_post,NumREM_sal_post, NumREM_sal_flx_post,NumREM_cno_flx_post},... 
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# REM bouts')

subplot(4,3,10)
MakeSpreadAndBoxPlot2_SB({durWAKE_basal_pre,durWAKE_sal_pre,durWAKE_sal_flx_pre,durWAKE_cno_flx_pre, ...
    durWAKE_basal_post,durWAKE_sal_post, durWAKE_sal_flx_post,durWAKE_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Mean duration of Wake (s)')

subplot(4,3,11)
MakeSpreadAndBoxPlot2_SB({durSWS_basal_pre,durSWS_sal_pre,durSWS_sal_flx_pre,durSWS_cno_flx_pre, ...
    durSWS_basal_post,durSWS_sal_post, durSWS_sal_flx_post,durSWS_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Mean duration of NREM (s)')

subplot(4,3,12)
MakeSpreadAndBoxPlot2_SB({durREM_basal_pre,durREM_sal_pre,durREM_sal_flx_pre,durREM_cno_flx_pre, ...
    durREM_basal_post,durREM_sal_post, durREM_sal_flx_post,durREM_cno_flx_post},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:8],{},'paired',0,'optiontest','ranksum');
xticks([2.5 6.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Mean duration of REM (s)')


%% 3h post injection
figure
subplot(433)
MakeSpreadAndBoxPlot_SB({percREM_totSleep_basal_pre,percREM_totSleep_sal_pre,percREM_totSleep_sal_flx_pre,percREM_totSleep_cno_flx_pre, ...
    percREM_totSleep_basal_3hPostInj,percREM_totSleep_sal_3hPostInj,percREM_totSleep_sal_flx_3hPostInj,percREM_totSleep_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('REM percentage (%)')
title('/ total sleep')


subplot(434)
MakeSpreadAndBoxPlot_SB({percWAKE_basal_pre,percWAKE_sal_pre,percWAKE_sal_flx_pre,percWAKE_cno_flx_pre, ...
    percWAKE_basal_3hPostInj,percWAKE_sal_3hPostInj,percWAKE_sal_flx_3hPostInj,percWAKE_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('Wake percentage (%)')

subplot(435)
MakeSpreadAndBoxPlot_SB({percSWS_basal_pre,percSWS_sal_pre,percSWS_sal_flx_pre,percSWS_cno_flx_pre, ...
    percSWS_basal_3hPostInj,percSWS_sal_3hPostInj,percSWS_sal_flx_3hPostInj,percSWS_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('NREM percentage (%)')

subplot(436)
MakeSpreadAndBoxPlot_SB({percREM_basal_pre,percREM_sal_pre,percREM_sal_flx_pre,percREM_cno_flx_pre, ...
    percREM_basal_3hPostInj,percREM_sal_3hPostInj,percREM_sal_flx_3hPostInj,percREM_cno_flx_3hPostInj},...    
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('REM percentage (%)')
title('/ total session')

subplot(437)
MakeSpreadAndBoxPlot_SB({NumWAKE_basal_pre,NumWAKE_sal_pre,NumWAKE_sal_flx_pre,NumWAKE_cno_flx_pre ...
    NumWAKE_basal_3hPostInj,NumWAKE_sal_3hPostInj, NumWAKE_sal_flx_3hPostInj,NumWAKE_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('# Wake bouts')

subplot(438)
MakeSpreadAndBoxPlot_SB({NumSWS_basal_pre,NumSWS_sal_pre,NumSWS_sal_flx_pre,NumSWS_cno_flx_pre ...
    NumSWS_basal_3hPostInj,NumSWS_sal_3hPostInj, NumSWS_sal_flx_3hPostInj,NumSWS_cno_flx_3hPostInj},...    
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('# NREM bouts')

subplot(439)
MakeSpreadAndBoxPlot_SB({NumREM_basal_pre,NumREM_sal_pre,NumREM_sal_flx_pre,NumREM_cno_flx_pre ...
    NumREM_basal_3hPostInj,NumREM_sal_3hPostInj, NumREM_sal_flx_3hPostInj,NumREM_cno_flx_3hPostInj},... 
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('# REM bouts')

subplot(4,3,10)
MakeSpreadAndBoxPlot_SB({durWAKE_basal_pre,durWAKE_sal_pre,durWAKE_sal_flx_pre,durWAKE_cno_flx_pre, ...
    durWAKE_basal_3hPostInj,durWAKE_sal_3hPostInj, durWAKE_sal_flx_3hPostInj,durWAKE_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('Mean duration of Wake (s)')

subplot(4,3,11)
MakeSpreadAndBoxPlot_SB({durSWS_basal_pre,durSWS_sal_pre,durSWS_sal_flx_pre,durSWS_cno_flx_pre, ...
    durSWS_basal_3hPostInj,durSWS_sal_3hPostInj, durSWS_sal_flx_3hPostInj,durSWS_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('Mean duration of NREM (s)')

subplot(4,3,12)
MakeSpreadAndBoxPlot_SB({durREM_basal_pre,durREM_sal_pre,durREM_sal_flx_pre,durREM_cno_flx_pre, ...
    durREM_basal_3hPostInj,durREM_sal_3hPostInj, durREM_sal_flx_3hPostInj,durREM_cno_flx_3hPostInj},...
    {col_pre_basal col_pre_saline col_pre_sal_flx col_pre_cno_flx col_post_basal col_post_saline col_post_sal_flx col_post_cno_flx},[1:4,6:9],{},1,0);
xticks([2.5 7.5]); xticklabels({'pre','post'})
ylabel('Mean duration of REM (s)')
