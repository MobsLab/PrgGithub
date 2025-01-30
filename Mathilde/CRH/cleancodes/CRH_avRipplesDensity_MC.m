%% input dir : exi DREADD VLPO CRH-neurons
% % % DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1217 1218 1219 1220]);

% % DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149 1150]);
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1217 1218 1219 1220]);

%% input dir basal sleep
% DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
% DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
% DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
% DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
% % DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% % DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

%% input dir (sleep inhi DREADD in PFC)
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1197 1198 1236 1237 1238]);
% DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

%% input dir (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir (atropine experiment)
%% input dir ATROPINE
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112

DirCNO = PathForExperimentsAtropine_MC('Atropine');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data
%baseline
for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    
    if exist('SleepScoring_Accelero.mat')
        stage_basal{k} = load('SleepScoring_Accelero.mat', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_OBGamma.mat')
        stage_basal{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    %%load ripples
    if exist('SWR.mat')
        ripp_basal{k} = load('SWR','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_basal{k} = load('Ripples','RipplesEpoch');
    else
        ripp_basal{k} =[];
    end
    
    % separate recording before/after injection
    durtotal_basal{k} = max([max(End(stage_basal{k}.Wake)),max(End(stage_basal{k}.SWSEpoch))]);
    epoch_pre_basal{k} = intervalSet(0,en_epoch_preInj);
    epoch_post_basal{k} = intervalSet(st_epoch_postInj,durtotal_basal{k});
    %3h post injection
    epoch_3hPostInj_basal{k} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
 %%restrict to period with low movement
    behav_basal{k} = load('behavResources.mat', 'MovAcctsd');
    try
    % threshold on speed to get period of high/low activity
    thresh_basal{k} = mean(Data(behav_basal{k}.MovAcctsd))+std(Data(behav_basal{k}.MovAcctsd));
    highMov_basal{k} = thresholdIntervals(behav_basal{k}.MovAcctsd, thresh_basal{k}, 'Direction', 'Above');
    lowMov_basal{k} = thresholdIntervals(behav_basal{k}.MovAcctsd, thresh_basal{k}, 'Direction', 'Below');
    end
    
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        
        if isempty(ripp_basal{k})==0
            
            
            
            
            %             %%load deltas
            %                 rippBasal{k} = load('DeltaWaves.mat','deltas_PFCx');
            % get deltas density
            [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_basal{k}.RipplesEpoch);
            RippDensity_basal{k} = Ripples_tsd;
            % find deltas in specific epoch
            ripp_SWSbefore_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.SWSEpoch, epoch_pre_basal{k}));
            ripp_Wakebefore_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.Wake, epoch_pre_basal{k}));
            ripp_REMbefore_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.REMEpoch, epoch_pre_basal{k}));
            
            ripp_SWSafter_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.SWSEpoch, epoch_post_basal{k}));
            ripp_Wakeafter_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.Wake, epoch_post_basal{k}));
            ripp_REMafter_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.REMEpoch, epoch_post_basal{k}));
            
            ripp_SWS_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.SWSEpoch, epoch_3hPostInj_basal{k}));
            ripp_Wake_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.Wake, epoch_3hPostInj_basal{k}));
            ripp_REM_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(stage_basal{k}.REMEpoch, epoch_3hPostInj_basal{k}));
            
    %%find ripples during wake with high/low mov
    if isempty(lowMov_basal{k})==0
    ripp_Wakebefore_lowMov_basal{k} = Restrict(RippDensity_basal{k}, and(and(stage_basal{k}.Wake,lowMov_basal{k}), epoch_pre_basal{k}));
    ripp_Wakebefore_highMov_basal{k} = Restrict(RippDensity_basal{k}, and(and(stage_basal{k}.Wake,highMov_basal{k}), epoch_pre_basal{k}));
    ripp_Wakeafter_lowMov_basal{k} = Restrict(RippDensity_basal{k}, and(and(stage_basal{k}.Wake,lowMov_basal{k}), epoch_post_basal{k}));
    ripp_Wakeafter_highMov_basal{k} = Restrict(RippDensity_basal{k}, and(and(stage_basal{k}.Wake,highMov_basal{k}), epoch_post_basal{k}));
    else
    end
        else
        end
    else
    end
    %
end



%% get the data saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    stage_sal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_sal{i} = max([max(End(stage_sal{i}.Wake)),max(End(stage_sal{i}.SWSEpoch))]);
    %pre injection
    epoch_pre_sal{i} = intervalSet(0,en_epoch_preInj);
    %post injection
    epoch_post_sal{i} = intervalSet(st_epoch_postInj,durtotal_sal{i});
    %3h post injection
    epoch_3hPostInj_sal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    %%restrict to period with low movement
    behav_sal{i} = load('behavResources.mat', 'Vtsd');
    try
    % threshold on speed to get period of high/low activity
    thresh_sal{i} = mean(Data(behav_sal{i}.Vtsd))+std(Data(behav_sal{i}.Vtsd));
    highMov_sal{i} = thresholdIntervals(behav_sal{i}.Vtsd, thresh_sal{i}, 'Direction', 'Above');
    lowMov_sal{i} = thresholdIntervals(behav_sal{i}.Vtsd, thresh_sal{i}, 'Direction', 'Below');
    end
    
    %%load ripples
    if exist('SWR.mat')
        ripp_sal{i} = load('SWR','RipplesEpoch');
    else
        ripp_sal{i} = load('Ripples','RipplesEpoch');
    end
    %get ripples density
    [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_sal{i}.RipplesEpoch);
    RippDensity_sal{i} = Ripples_tsd; %store it for all mice
    % find ripples in specific epoch
    ripp_SWSbefore_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.SWSEpoch, epoch_pre_sal{i}));
    ripp_Wakebefore_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.Wake, epoch_pre_sal{i}));
    ripp_REMbefore_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.REMEpoch, epoch_pre_sal{i}));
    
    ripp_SWSafter_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.SWSEpoch, epoch_post_sal{i}));
    ripp_Wakeafter_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.Wake, epoch_post_sal{i}));
    ripp_REMafter_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.REMEpoch, epoch_post_sal{i}));
    
    ripp_SWS_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.SWSEpoch, epoch_3hPostInj_sal{i}));
    ripp_Wake_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.Wake, epoch_3hPostInj_sal{i}));
    ripp_REM_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(stage_sal{i}.REMEpoch, epoch_3hPostInj_sal{i}));
    
%     %%find ripples during freezing periods
%     ripp_Freezebefore_sal{i} = Restrict(ripp_sal{i}, and(b{i}.FreezeAccEpoch,Epoch1_sal{i}));
%     ripp_Freezeafter_sal{i} = Restrict(ripp_sal{i}, and(b{i}.FreezeAccEpoch,Epoch2_sal{i}));
    
    %%find ripples during wake with high/low mov
    if isempty(lowMov_sal{i})==0
    ripp_Wakebefore_lowMov_sal{i} = Restrict(RippDensity_sal{i}, and(and(stage_sal{i}.Wake,lowMov_sal{i}), epoch_pre_sal{i}));
    ripp_Wakebefore_highMov_sal{i} = Restrict(RippDensity_sal{i}, and(and(stage_sal{i}.Wake,highMov_sal{i}), epoch_pre_sal{i}));
    ripp_Wakeafter_lowMov_sal{i} = Restrict(RippDensity_sal{i}, and(and(stage_sal{i}.Wake,lowMov_sal{i}), epoch_post_sal{i}));
    ripp_Wakeafter_highMov_sal{i} = Restrict(RippDensity_sal{i}, and(and(stage_sal{i}.Wake,highMov_sal{i}), epoch_post_sal{i}));
    else
    end
end



%% get data CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    stage_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_cno{j} = max([max(End(stage_cno{j}.Wake)),max(End(stage_cno{j}.SWSEpoch))]);
    %pre injection
    epoch_pre_cno{j} = intervalSet(0,en_epoch_preInj);
    %post injection
    epoch_post_cno{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
    %3h post injection
    epoch_3hPostInj_cno{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    %%restrict to period with low movement
    behav_cno{j} = load('behavResources.mat', 'Vtsd');
    try
    % threshold on speed to get period of high/low activity
    thresh_cno{j} = mean(Data(behav_cno{j}.Vtsd))+std(Data(behav_cno{j}.Vtsd));
    highMov_cno{j} = thresholdIntervals(behav_cno{j}.Vtsd, thresh_cno{j}, 'Direction', 'Above');
    lowMov_cno{j} = thresholdIntervals(behav_cno{j}.Vtsd, thresh_cno{j}, 'Direction', 'Below');
    end
    
    %%load ripples
    if exist('SWR.mat')
        ripp_cno{j} = load('SWR','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_cno{j} = load('Ripples','RipplesEpoch');
    else
        ripp_cno{j} = [];
    end
    
    if isempty(ripp_cno{j})==0
        %%get ripples density
        [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_cno{j}.RipplesEpoch);
        RippDensity_cno{j} = Ripples_tsd;
        % find ripples density in specific epoch
        ripp_SWSbefore_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.SWSEpoch, epoch_pre_cno{j}));
        ripp_Wakebefore_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.Wake, epoch_pre_cno{j}));
        ripp_REMbefore_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.REMEpoch, epoch_pre_cno{j}));
        
        ripp_SWSafter_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.SWSEpoch, epoch_post_cno{j}));
        ripp_Wakeafter_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.Wake, epoch_post_cno{j}));
        ripp_REMafter_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.REMEpoch, epoch_post_cno{j}));
        
        ripp_SWS_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.SWSEpoch, epoch_3hPostInj_cno{j}));
        ripp_Wake_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.Wake, epoch_3hPostInj_cno{j}));
        ripp_REM_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(stage_cno{j}.REMEpoch, epoch_3hPostInj_cno{j}));
        
%         %%find ripples during freezing periods
%         ripp_Freezebefore_cno{j} = Restrict(ripp_cno{j}, and(f{j}.FreezeAccEpoch,Epoch1_CNO{j}));
%         ripp_Freezeafter_cno{j} = Restrict(ripp_cno{j}, and(f{j}.FreezeAccEpoch,Epoch2_CNO{j}));
        
        %%find ripples during wake with high/low mov
        if isempty(lowMov_cno{j})==0
        ripp_Wakebefore_lowMov_cno{j} = Restrict(RippDensity_cno{j}, and(and(stage_cno{j}.Wake,lowMov_cno{j}), epoch_pre_cno{j}));
        ripp_Wakebefore_highMov_cno{j} = Restrict(RippDensity_cno{j}, and(and(stage_cno{j}.Wake,highMov_cno{j}), epoch_pre_cno{j}));
        rip_Wakeafter_lowMov_cno{j} = Restrict(RippDensity_cno{j}, and(and(stage_cno{j}.Wake,lowMov_cno{j}), epoch_post_cno{j}));
        ripp_Wakeafter_highMov_cno{j} = Restrict(RippDensity_cno{j}, and(and(stage_cno{j}.Wake,highMov_cno{j}), epoch_post_cno{j}));
        else
        end
    else
        
                ripp_SWSbefore_cno{j} =[];
        ripp_Wakebefore_cno{j} = [];
        ripp_REMbefore_cno{j} = [];
        
        ripp_SWSafter_cno{j} = [];
        ripp_Wakeafter_cno{j} = [];
        ripp_REMafter_cno{j} = [];
        
        ripp_SWS_3hPost_cno{j} = [];
        ripp_Wake_3hPost_cno{j} = [];
        ripp_REM_3hPost_cno{j} = [];
        
    end
end

%% calculate mean
%%baseline mice
for kk=1:length(ripp_SWSbefore_basal)
    if isempty(ripp_SWSbefore_basal{kk})==0
        avRippPerMin_SWSbefore_basal(kk,:)=nanmean(Data(ripp_SWSbefore_basal{kk}(:,:)),1); avRippPerMin_SWSbefore_basal(avRippPerMin_SWSbefore_basal==0)=NaN;
        avRippPerMin_Wakebefore_basal(kk,:)=nanmean(Data(ripp_Wakebefore_basal{kk}(:,:)),1); avRippPerMin_Wakebefore_basal(avRippPerMin_Wakebefore_basal==0)=NaN;
        avRippPerMin_REMbefore_basal(kk,:)=nanmean(Data(ripp_REMbefore_basal{kk}(:,:)),1); avRippPerMin_REMbefore_basal(avRippPerMin_REMbefore_basal==0)=NaN;
            %%for wake with high/low mov
        avRippPerMin_Wakebefore_lowMov_basal(kk,:)=nanmean(Data(ripp_Wakebefore_lowMov_basal{kk}(:,:)),1); avRippPerMin_Wakebefore_lowMov_basal(avRippPerMin_Wakebefore_lowMov_basal==0)=NaN;
        avRippPerMin_Wakebefore_highMov_basal(kk,:)=nanmean(Data(ripp_Wakebefore_highMov_basal{kk}(:,:)),1); avRippPerMin_Wakebefore_highMov_basal(avRippPerMin_Wakebefore_highMov_basal==0)=NaN;
    else
    end
end
for kk=1:length(ripp_SWSafter_basal)
    if isempty(ripp_SWSafter_basal{kk})==0
        avRippPerMin_SWSafter_basal(kk,:)=nanmean(Data(ripp_SWSafter_basal{kk}(:,:)),1); avRippPerMin_SWSafter_basal(avRippPerMin_SWSafter_basal==0)=NaN;
        avRippPerMin_Wakeafter_basal(kk,:)=nanmean(Data(ripp_Wakeafter_basal{kk}(:,:)),1); avRippPerMin_Wakeafter_basal(avRippPerMin_Wakeafter_basal==0)=NaN;
        avRippPerMin_REMafter_basal(kk,:)=nanmean(Data(ripp_REMafter_basal{kk}(:,:)),1); avRippPerMin_REMafter_basal(avRippPerMin_REMafter_basal==0)=NaN;
        
        avRippPerMin_SWS_3hPost_basal(kk,:)=nanmean(Data(ripp_SWS_3hPost_basal{kk}(:,:)),1); avRippPerMin_SWS_3hPost_basal(avRippPerMin_SWS_3hPost_basal==0)=NaN;
        avRippPerMin_Wake_3hPost_basal(kk,:)=nanmean(Data(ripp_Wake_3hPost_basal{kk}(:,:)),1); avRippPerMin_Wake_3hPost_basal(avRippPerMin_Wake_3hPost_basal==0)=NaN;
        avRippPerMin_REM_3hPost_basal(kk,:)=nanmean(Data(ripp_REM_3hPost_basal{kk}(:,:)),1); avRippPerMin_REM_3hPost_basal(avRippPerMin_REM_3hPost_basal==0)=NaN;
            %%for wake with high/low mov
        avRippPerMin_Wakeafter_lowMov_basal(kk,:)=nanmean(Data(ripp_Wakeafter_lowMov_basal{kk}(:,:)),1); avRippPerMin_Wakeafter_lowMov_basal(avRippPerMin_Wakeafter_lowMov_basal==0)=NaN;
        avRippPerMin_Wakeafter_highMov_basal(kk,:)=nanmean(Data(ripp_Wakeafter_highMov_basal{kk}(:,:)),1); avRippPerMin_Wakeafter_highMov_basal(avRippPerMin_Wakeafter_highMov_basal==0)=NaN;
    else
    end
end
%%
%%saline mice
for ii=1:length(ripp_SWSbefore_sal)
    avRippPerMin_SWSbefore_sal(ii,:)=nanmean(Data(ripp_SWSbefore_sal{ii}(:,:)),1);
    avRippPerMin_Wakebefore_sal(ii,:)=nanmean(Data(ripp_Wakebefore_sal{ii}(:,:)),1);
    avRippPerMin_REMbefore_sal(ii,:)=nanmean(Data(ripp_REMbefore_sal{ii}(:,:)),1);
        %%for wake with high/low mov
        avRippPerMin_Wakebefore_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_lowMov_sal{ii}(:,:)),1);
        avRippPerMin_Wakebefore_highMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_highMov_sal{ii}(:,:)),1);
end
for ii=1:length(ripp_SWSafter_sal)
    avRippPerMin_SWSafter_sal(ii,:)=nanmean(Data(ripp_SWSafter_sal{ii}(:,:)),1);
    avRippPerMin_Wakeafter_sal(ii,:)=nanmean(Data(ripp_Wakeafter_sal{ii}(:,:)),1);
    avRippPerMin_REMafter_sal(ii,:)=nanmean(Data(ripp_REMafter_sal{ii}(:,:)),1);
    
    avRippPerMin_SWS_3hPost_sal(ii,:)=nanmean(Data(ripp_SWS_3hPost_sal{ii}(:,:)),1);
    avRippPerMin_Wake_3hPost_sal(ii,:)=nanmean(Data(ripp_Wake_3hPost_sal{ii}(:,:)),1);
    avRippPerMin_REM_3hPost_sal(ii,:)=nanmean(Data(ripp_REM_3hPost_sal{ii}(:,:)),1);

        %%for wake with high/low mov
        avRippPerMin_Wakeafter_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_lowMov_sal{ii}(:,:)),1);
        avRippPerMin_Wakeafter_highMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_highMov_sal{ii}(:,:)),1);
    %     %%for wake with freezing
    %     avRippPerMin_Freezebefore_sal(ii,:)=nanmean(Data(ripp_Freezebefore_sal{ii}(:,:)),1);
    %     avRippPerMin_Freezeafter_sal(ii,:)=nanmean(Data(ripp_Freezeafter_sal{ii}(:,:)),1);
end
%%
%cno mice
for jj=1:length(ripp_SWSbefore_cno)
    if isempty(ripp_SWSbefore_cno{jj})==0
        avRippPerMin_SWSbefore_cno(jj,:)=nanmean(Data(ripp_SWSbefore_cno{jj}(:,:)),1); avRippPerMin_SWSbefore_cno(avRippPerMin_SWSbefore_cno==0)=NaN;
        avRippPerMin_Wakebefore_cno(jj,:)=nanmean(Data(ripp_Wakebefore_cno{jj}(:,:)),1); avRippPerMin_Wakebefore_cno(avRippPerMin_Wakebefore_cno==0)=NaN;
        avRippPerMin_REMbefore_cno(jj,:)=nanmean(Data(ripp_REMbefore_cno{jj}(:,:)),1); avRippPerMin_REMbefore_cno(avRippPerMin_REMbefore_cno==0)=NaN;
            %%for wake with high/low mov
            avRippPerMin_Wakebefore_lowMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_lowMov_cno{jj}(:,:)),1); avRippPerMin_Wakebefore_lowMov_cno(avRippPerMin_Wakebefore_lowMov_cno==0)=NaN;
            avRippPerMin_Wakebefore_highMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_highMov_cno{jj}(:,:)),1); avRippPerMin_Wakebefore_highMov_cno(avRippPerMin_Wakebefore_highMov_cno==0)=NaN;
    else
    end
end
for jj=1:length(ripp_SWSafter_cno)
    if isempty(ripp_SWSafter_cno{jj})==0
        
        avRippPerMin_SWSafter_cno(jj,:)=nanmean(Data(ripp_SWSafter_cno{jj}(:,:)),1); avRippPerMin_SWSafter_cno(avRippPerMin_SWSafter_cno==0)=NaN;
        avRippPerMin_Wakeafter_cno(jj,:)=nanmean(Data(ripp_Wakeafter_cno{jj}(:,:)),1); avRippPerMin_Wakeafter_cno(avRippPerMin_Wakeafter_cno==0)=NaN;
        avRippPerMin_REMafter_cno(jj,:)=nanmean(Data(ripp_REMafter_cno{jj}(:,:)),1); avRippPerMin_REMafter_cno(avRippPerMin_REMafter_cno==0)=NaN;
        
        avRippPerMin_SWS_3hPost_cno(jj,:)=nanmean(Data(ripp_SWS_3hPost_cno{jj}(:,:)),1); avRippPerMin_SWS_3hPost_cno(avRippPerMin_SWS_3hPost_cno==0)=NaN;
        avRippPerMin_Wake_3hPost_cno(jj,:)=nanmean(Data(ripp_Wake_3hPost_cno{jj}(:,:)),1); avRippPerMin_Wake_3hPost_cno(avRippPerMin_Wake_3hPost_cno==0)=NaN;
        avRippPerMin_REM_3hPost_cno(jj,:)=nanmean(Data(ripp_REM_3hPost_cno{jj}(:,:)),1); avRippPerMin_REM_3hPost_cno(avRippPerMin_REM_3hPost_cno==0)=NaN;
        
            %%for wake with high/low mov
            avRippPerMin_Wakeafter_lowMov_cno(jj,:)=nanmean(Data(rip_Wakeafter_lowMov_cno{jj}(:,:)),1); avRippPerMin_Wakeafter_lowMov_cno(avRippPerMin_Wakeafter_lowMov_cno==0)=NaN;
            avRippPerMin_Wakeafter_highMov_cno(jj,:)=nanmean(Data(ripp_Wakeafter_highMov_cno{jj}(:,:)),1); avRippPerMin_Wakeafter_highMov_cno(avRippPerMin_Wakeafter_highMov_cno==0)=NaN;
        %     %%for wake with freezing
        %     avRippPerMin_Freezebefore_cno(jj,:)=nanmean(Data(ripp_Freezebefore_cno{jj}(:,:)),1);
        %     avRippPerMin_Freezeafter_cno(jj,:)=nanmean(Data(ripp_Freezeafter_cno{jj}(:,:)),1);
    else
    end
end

%%
% clear jj
% for jj=1:length(ripp_REMafter_cno)
%     if isempty(ripp_REMafter_cno{jj})==0
%         
%         avRippPerMin_REMafter_cno(jj,:)=nanmean(Data(ripp_REMafter_cno{jj}(:,:)),1); avRippPerMin_REMafter_cno(avRippPerMin_REMafter_cno==0)=NaN;
%         
%     else
%     end
% end


%% figure

col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];

figure,
subplot(121)
MakeBoxPlot_MC({avRippPerMin_Wakebefore_lowMov_basal avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno avRippPerMin_Wakeafter_lowMov_basal avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake - low mov')
ylim([0 0.25])

subplot(122)
MakeBoxPlot_MC({avRippPerMin_Wakebefore_highMov_basal avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno avRippPerMin_Wakeafter_highMov_basal avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake - high mov')
ylim([0 0.25])


%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];

figure,
subplot(2,7,[1,2,8,9])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_basal,avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_basal,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake')
makepretty

subplot(2,7,[4,5,11,12])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_SWSbefore_basal,avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_basal,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('NREM')
makepretty

subplot(2,7,[6,7,13,14])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_REMbefore_basal,avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_basal,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('REM')
makepretty


subplot(2,7,3)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_lowMov_basal avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno avRippPerMin_Wakeafter_lowMov_basal avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake - low mov')
ylim([0 0.25])
makepretty

subplot(2,7,10)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_highMov_basal avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno avRippPerMin_Wakeafter_highMov_basal avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake - high mov')
ylim([0 0.25])
makepretty





%% figure : ripples density overtime
figure
%%ripples density overtime (saline)
for i=1:length(DirSaline.path)
    VecTimeDay_WAKE_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},stage_sal{i}.Wake)), 0);
    VecTimeDay_SWS_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},stage_sal{i}.SWSEpoch)), 0);
    VecTimeDay_REM_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},stage_sal{i}.REMEpoch)), 0);
    
    subplot(3,5,[1,2]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.Wake))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.Wake)),70),'.'), hold on
    plot(VecTimeDay_WAKE_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},stage_sal{i}.Wake)),70),'.'), hold on
    ylabel('Ripples/s')
    ylim([0 1.8])
    xlim([9 19])
    title('WAKE (saline)')
    set(gca,'FontSize',14)
    subplot(3,5,[6,7]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
    plot(VecTimeDay_SWS_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},stage_sal{i}.SWSEpoch)),70),'.'), hold on
    ylabel('Ripples/s')
    title('NREM (saline)')
    ylim([0 1.8])
    xlim([9 19])
    set(gca,'FontSize',14)
    subplot(3,5,[11,12]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
    plot(VecTimeDay_REM_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},stage_sal{i}.REMEpoch)),70),'.'), hold on
    ylabel('Ripples/s')
    title('REM (saline)')
    ylim([0 1.8])
    xlim([9 19])
    xlabel('Time (s)')
    set(gca,'FontSize',14)
    legend({'m1196','m1197','m1105','m1106','m1149'})
end
%%ripples density overtime (CNO)
for j=1:length(DirCNO.path)
    if isempty(RippDensity_cno{j})==0
        
        VecTimeDay_WAKE_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},stage_cno{j}.Wake)), 0);
        VecTimeDay_SWS_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},stage_cno{j}.SWSEpoch)), 0);
        VecTimeDay_REM_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},stage_cno{j}.REMEpoch)), 0);
        
        subplot(3,5,[3,4]),
        % plot(Range(Restrict(RippDensity_cno{j},b{j}.Wake))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.Wake)),70),'.'), hold on
        plot(VecTimeDay_WAKE_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},stage_cno{j}.Wake)),70),'.'), hold on
        ylim([0 1.8])
        xlim([9 19])
        title('WAKE (cno)')
        set(gca,'FontSize',14)
        subplot(3,5,[8,9]),
        % plot(Range(Restrict(RippDensity_cno{j},b{j}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)),70),'.'), hold on
        plot(VecTimeDay_SWS_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},stage_cno{j}.SWSEpoch)),70),'.'), hold on
        title('NREM (cno)')
        ylim([0 1.8])
        xlim([9 19])
        set(gca,'FontSize',14)
        subplot(3,5,[13,14]),
        % plot(Range(Restrict(RippDensity_cno{j},b{j}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.REMEpoch)),70),'.'), hold on
        plot(VecTimeDay_REM_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},stage_cno{j}.REMEpoch)),70),'.'), hold on
        title('REM (cno)')
        ylim([0 1.8])
        xlim([9 19])
        xlabel('Time (s)')
        set(gca,'FontSize',14)
        legend({'mouse1196','mouse1197'})
    else
    end
end


%% fig finale
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [.8 .8 .8];
col_post_saline = [.8 .8 .8];
col_pre_cno = [.2 .8 0]; %vert
col_post_cno = [.2 .8 0];

figure,
subplot(2,7,[1,2,8,9])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake')
makepretty

subplot(2,7,[4,5,11,12])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('NREM')
makepretty

subplot(2,7,[6,7,13,14])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('REM')
makepretty


subplot(2,7,3)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake - low mov')
ylim([0 0.25])
makepretty

subplot(2,7,10)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake - high mov')
ylim([0 0.25])
makepretty



%% add stats


subplot(2,7,[1,2,8,9])
[h,p_pre]=ttest(avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))



subplot(2,7,[4,5,11,12])
[h,p_pre]=ttest(avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))



subplot(2,7,[6,7,13,14])
[h,p_pre]=ttest(avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))


subplot(2,7,3)
[h,p_pre]=ttest(avRippPerMin_Wakebefore_lowMov_sal, avRippPerMin_Wakebefore_lowMov_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_lowMov_sal, avRippPerMin_Wakeafter_lowMov_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))

subplot(2,7,10)
[h,p_pre]=ttest(avRippPerMin_Wakebefore_highMov_sal, avRippPerMin_Wakebefore_highMov_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_highMov_sal, avRippPerMin_Wakeafter_highMov_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))


%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [.8 .8 .8];
col_post_saline = [.8 .8 .8];
col_pre_cno = [.2 .8 0]; %vert
col_post_cno = [.2 .8 0];

figure,
subplot(2,7,[1,2,8,9])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake')
makepretty

subplot(2,7,[4,5,11,12])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('NREM')
makepretty

subplot(2,7,[6,7,13,14])
MakeSpreadAndBoxPlot2_SB({avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('REM')
makepretty


subplot(2,7,3)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake - low mov')
ylim([0 0.25])
makepretty

subplot(2,7,10)
MakeSpreadAndBoxPlot2_SB({avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'showpoints',0,'optiontest','ranksum','showsigstar','none');
xticks([1.5 3.5]); xticklabels({'Pre injection','Post injection'}); xtickangle(0)
ylabel('Ripples/s')
title('Wake - high mov')
ylim([0 0.25])
makepretty



%% add stats


subplot(2,7,[1,2,8,9])
[h,p_pre]=ttest(avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))



subplot(2,7,[4,5,11,12])
[h,p_pre]=ttest(avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))



subplot(2,7,[6,7,13,14])
[h,p_pre]=ttest(avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))


subplot(2,7,3)
[h,p_pre]=ttest(avRippPerMin_Wakebefore_lowMov_sal, avRippPerMin_Wakebefore_lowMov_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_lowMov_sal, avRippPerMin_Wakeafter_lowMov_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))

subplot(2,7,10)
[h,p_pre]=ttest(avRippPerMin_Wakebefore_highMov_sal, avRippPerMin_Wakebefore_highMov_cno);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end

[h,p_post]=ttest(avRippPerMin_Wakeafter_highMov_sal, avRippPerMin_Wakeafter_highMov_cno);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end

title(sprintf(['p pre = ', num2str(p_pre), ' \np post = ', num2str(p_post)]))


