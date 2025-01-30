%% input dir : exi DREADD VLPO CRH-neurons
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149 1150]);
% % DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
%
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1217 1218 1219 1220]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1217 1218 1219 1220]);

%% input dir basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%% input dir (sleep inhi DREADD in PFC)
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1198]);
DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');


%% input dir (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir (atropine experiment)

% DirBaselineMC = PathForExperimentsAtropine_MC('Baseline');
% DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');
% DirBaselineMC = RestrictPathForExperiment(DirBaselineMC, 'nMice', [1105 1106 1107]);
% DirAtropineMC = RestrictPathForExperiment(DirAtropineMC, 'nMice', [1105 1106 1107]);

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data
%%baseline
for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    %%load substages
    if exist('SleepSubstages.mat')==2
        substage_basal{k} = load('SleepSubstages.mat','Epoch');
        %%rename epoch
        SWSEpoch_basal{k} = substage_basal{k}.Epoch{7}; Wake_basal{k} = substage_basal{k}.Epoch{4}; REMEpoch_basal{k} = substage_basal{k}.Epoch{5};
        N1_basal{k} = substage_basal{k}.Epoch{1}; N2_basal{k} = substage_basal{k}.Epoch{2}; N3_basal{k} = substage_basal{k}.Epoch{3}; TOTsleep_basal{k} = substage_basal{k}.Epoch{10};
        
        %%separate recording before/after injection
        durtotal_basal{k} = max([max(End(Wake_basal{k})),max(End(SWSEpoch_basal{k}))]);
        epoch_pre_basal{k} = intervalSet(0,en_epoch_preInj);
        epoch_post_basal{k} = intervalSet(st_epoch_postInj,durtotal_basal{k});
        %%3h post injection
        epoch_3hPostInj_basal{k} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
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
    
    if exist('SleepSubstages.mat')
        if isempty(ripp_basal{k})==0
            %%get ripples density
            [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_basal{k}.RipplesEpoch);
            RippDensity_basal{k} = Ripples_tsd;
            %%find deltas in specific stage and period
            %%pre injection
            ripp_SWS_pre_basal{k} = Restrict(RippDensity_basal{k}, and(SWSEpoch_basal{k}, epoch_pre_basal{k}));
            ripp_Wake_pre_basal{k} = Restrict(RippDensity_basal{k}, and(Wake_basal{k}, epoch_pre_basal{k}));
            ripp_REM_pre_basal{k} = Restrict(RippDensity_basal{k}, and(REMEpoch_basal{k}, epoch_pre_basal{k}));
            ripp_N1_pre_basal{k} = Restrict(RippDensity_basal{k}, and(N1_basal{k}, epoch_pre_basal{k}));
            ripp_N2_pre_basal{k} = Restrict(RippDensity_basal{k}, and(N2_basal{k}, epoch_pre_basal{k}));
            ripp_N3_pre_basal{k} = Restrict(RippDensity_basal{k}, and(N3_basal{k}, epoch_pre_basal{k}));
            %%post injection
            ripp_SWS_post_basal{k} = Restrict(RippDensity_basal{k}, and(SWSEpoch_basal{k}, epoch_post_basal{k}));
            ripp_Wake_post_basal{k} = Restrict(RippDensity_basal{k}, and(Wake_basal{k}, epoch_post_basal{k}));
            ripp_REM_post_basal{k} = Restrict(RippDensity_basal{k}, and(REMEpoch_basal{k}, epoch_post_basal{k}));
            ripp_N1_post_basal{k} = Restrict(RippDensity_basal{k}, and(N1_basal{k}, epoch_post_basal{k}));
            ripp_N2_post_basal{k} = Restrict(RippDensity_basal{k}, and(N2_basal{k}, epoch_post_basal{k}));
            ripp_N3_post_basal{k} = Restrict(RippDensity_basal{k}, and(N3_basal{k}, epoch_post_basal{k}));
            %%3h post injection
            ripp_SWS_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(SWSEpoch_basal{k}, epoch_3hPostInj_basal{k}));
            ripp_Wake_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(Wake_basal{k}, epoch_3hPostInj_basal{k}));
            ripp_REM_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(REMEpoch_basal{k}, epoch_3hPostInj_basal{k}));
            ripp_N1_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(N1_basal{k}, epoch_3hPostInj_basal{k}));
            ripp_N2_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(N2_basal{k}, epoch_3hPostInj_basal{k}));
            ripp_N3_3hPostInj_basal{k} = Restrict(RippDensity_basal{k}, and(N3_basal{k}, epoch_3hPostInj_basal{k}));
        else
        end
    else
    end
end
%%saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    %%load substages
    if exist('SleepSubstages.mat')==2
        substage_sal{i} = load('SleepSubstages.mat','Epoch');
        %%rename epoch
        SWSEpoch_sal{i} = substage_sal{i}.Epoch{7}; Wake_sal{i} = substage_sal{i}.Epoch{4}; REMEpoch_sal{i} = substage_sal{i}.Epoch{5};
        N1_sal{i} = substage_sal{i}.Epoch{1}; N2_sal{i} = substage_sal{i}.Epoch{2}; N3_sal{i} = substage_sal{i}.Epoch{3}; TOTsleep_sal{i} = substage_sal{i}.Epoch{10};
        
        %%separate recording before/after injection
        durtotal_sal{i} = max([max(End(Wake_sal{i})),max(End(SWSEpoch_sal{i}))]);
        epoch_pre_sal{i} = intervalSet(0,en_epoch_preInj);
        epoch_post_sal{i} = intervalSet(st_epoch_postInj,durtotal_sal{i});
        %%3h post injection
        epoch_3hPostInj_sal{i} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    else
    end
    
    %%load ripples
    if exist('SWR.mat')
        ripp_sal{i} = load('SWR','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_sal{i} = load('Ripples','RipplesEpoch');
    else
        ripp_sal{i} =[];
    end
    
    if exist('SleepSubstages.mat')
        if isempty(ripp_sal{i})==0
            %%get ripples density
            [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_sal{i}.RipplesEpoch);
            RippDensity_sal{i} = Ripples_tsd;
            %%find deltas in specific stage and period
            %%pre injection
            ripp_SWS_pre_sal{i} = Restrict(RippDensity_sal{i}, and(SWSEpoch_sal{i}, epoch_pre_sal{i}));
            ripp_Wake_pre_sal{i} = Restrict(RippDensity_sal{i}, and(Wake_sal{i}, epoch_pre_sal{i}));
            ripp_REM_pre_sal{i} = Restrict(RippDensity_sal{i}, and(REMEpoch_sal{i}, epoch_pre_sal{i}));
            ripp_N1_pre_sal{i} = Restrict(RippDensity_sal{i}, and(N1_sal{i}, epoch_pre_sal{i}));
            ripp_N2_pre_sal{i} = Restrict(RippDensity_sal{i}, and(N2_sal{i}, epoch_pre_sal{i}));
            ripp_N3_pre_sal{i} = Restrict(RippDensity_sal{i}, and(N3_sal{i}, epoch_pre_sal{i}));
            %%post injection
            ripp_SWS_post_sal{i} = Restrict(RippDensity_sal{i}, and(SWSEpoch_sal{i}, epoch_post_sal{i}));
            ripp_Wake_post_sal{i} = Restrict(RippDensity_sal{i}, and(Wake_sal{i}, epoch_post_sal{i}));
            ripp_REM_post_sal{i} = Restrict(RippDensity_sal{i}, and(REMEpoch_sal{i}, epoch_post_sal{i}));
            ripp_N1_post_sal{i} = Restrict(RippDensity_sal{i}, and(N1_sal{i}, epoch_post_sal{i}));
            ripp_N2_post_sal{i} = Restrict(RippDensity_sal{i}, and(N2_sal{i}, epoch_post_sal{i}));
            ripp_N3_post_sal{i} = Restrict(RippDensity_sal{i}, and(N3_sal{i}, epoch_post_sal{i}));
            %%3h post injection
            ripp_SWS_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(SWSEpoch_sal{i}, epoch_3hPostInj_sal{i}));
            ripp_Wake_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(Wake_sal{i}, epoch_3hPostInj_sal{i}));
            ripp_REM_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(REMEpoch_sal{i}, epoch_3hPostInj_sal{i}));
            ripp_N1_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(N1_sal{i}, epoch_3hPostInj_sal{i}));
            ripp_N2_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(N2_sal{i}, epoch_3hPostInj_sal{i}));
            ripp_N3_3hPostInj_sal{i} = Restrict(RippDensity_sal{i}, and(N3_sal{i}, epoch_3hPostInj_sal{i}));
        else
        end
    else
    end
end
%%cno
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    %%load substages
    if exist('SleepSubstages.mat')==2
        substage_cno{j} = load('SleepSubstages.mat','Epoch');
        %%rename epoch
        SWSEpoch_cno{j} = substage_cno{j}.Epoch{7}; Wake_cno{j} = substage_cno{j}.Epoch{4}; REMEpoch_cno{j} = substage_cno{j}.Epoch{5};
        N1_cno{j} = substage_cno{j}.Epoch{1}; N2_cno{j} = substage_cno{j}.Epoch{2}; N3_cno{j} = substage_cno{j}.Epoch{3}; TOTsleep_cno{j} = substage_cno{j}.Epoch{10};
        
        %%separate recording before/after injection
        durtotal_cno{j} = max([max(End(Wake_cno{j})),max(End(SWSEpoch_cno{j}))]);
        epoch_pre_cno{j} = intervalSet(0,en_epoch_preInj);
        epoch_post_cno{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
        %%3h post injection
        epoch_3hPostInj_cno{j} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    else
    end
    
    %%load ripples
    if exist('SWR.mat')
        ripp_cno{j} = load('SWR','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_cno{j} = load('Ripples','RipplesEpoch');
    else
        ripp_cno{j} =[];
    end
    
    if exist('SleepSubstages.mat')
        if isempty(ripp_cno{j})==0
            %%get ripples density
            [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_cno{j}.RipplesEpoch);
            RippDensity_cno{j} = Ripples_tsd;
            %%find deltas in specific stage and period
            %%pre injection
            ripp_SWS_pre_cno{j} = Restrict(RippDensity_cno{j}, and(SWSEpoch_cno{j}, epoch_pre_cno{j}));
            ripp_Wake_pre_cno{j} = Restrict(RippDensity_cno{j}, and(Wake_cno{j}, epoch_pre_cno{j}));
            ripp_REM_pre_cno{j} = Restrict(RippDensity_cno{j}, and(REMEpoch_cno{j}, epoch_pre_cno{j}));
            ripp_N1_pre_cno{j} = Restrict(RippDensity_cno{j}, and(N1_cno{j}, epoch_pre_cno{j}));
            ripp_N2_pre_cno{j} = Restrict(RippDensity_cno{j}, and(N2_cno{j}, epoch_pre_cno{j}));
            ripp_N3_pre_cno{j} = Restrict(RippDensity_cno{j}, and(N3_cno{j}, epoch_pre_cno{j}));
            %%post injection
            ripp_SWS_post_cno{j} = Restrict(RippDensity_cno{j}, and(SWSEpoch_cno{j}, epoch_post_cno{j}));
            ripp_Wake_post_cno{j} = Restrict(RippDensity_cno{j}, and(Wake_cno{j}, epoch_post_cno{j}));
            ripp_REM_post_cno{j} = Restrict(RippDensity_cno{j}, and(REMEpoch_cno{j}, epoch_post_cno{j}));
            ripp_N1_post_cno{j} = Restrict(RippDensity_cno{j}, and(N1_cno{j}, epoch_post_cno{j}));
            ripp_N2_post_cno{j} = Restrict(RippDensity_cno{j}, and(N2_cno{j}, epoch_post_cno{j}));
            ripp_N3_post_cno{j} = Restrict(RippDensity_cno{j}, and(N3_cno{j}, epoch_post_cno{j}));
            %%3h post injection
            ripp_SWS_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(SWSEpoch_cno{j}, epoch_3hPostInj_cno{j}));
            ripp_Wake_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(Wake_cno{j}, epoch_3hPostInj_cno{j}));
            ripp_REM_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(REMEpoch_cno{j}, epoch_3hPostInj_cno{j}));
            ripp_N1_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(N1_cno{j}, epoch_3hPostInj_cno{j}));
            ripp_N2_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(N2_cno{j}, epoch_3hPostInj_cno{j}));
            ripp_N3_3hPostInj_cno{j} = Restrict(RippDensity_cno{j}, and(N3_cno{j}, epoch_3hPostInj_cno{j}));
        else
        end
    else
    end
end

%% calculate mean
%%baseline mice
for kk=1:length(ripp_SWS_pre_basal)
    if isempty(ripp_SWS_pre_basal{kk})==0
        avRippPerMin_SWS_pre_basal(kk,:)=nanmean(Data(ripp_SWS_pre_basal{kk}(:,:)),1); avRippPerMin_SWS_pre_basal(avRippPerMin_SWS_pre_basal==0)=NaN;
        avRippPerMin_Wake_pre_basal(kk,:)=nanmean(Data(ripp_Wake_pre_basal{kk}(:,:)),1); avRippPerMin_Wake_pre_basal(avRippPerMin_Wake_pre_basal==0)=NaN;
        avRippPerMin_REM_pre_basal(kk,:)=nanmean(Data(ripp_REM_pre_basal{kk}(:,:)),1); avRippPerMin_REM_pre_basal(avRippPerMin_REM_pre_basal==0)=NaN;
        avRippPerMin_N1_pre_basal(kk,:)=nanmean(Data(ripp_N1_pre_basal{kk}(:,:)),1); avRippPerMin_N1_pre_basal(avRippPerMin_N1_pre_basal==0)=NaN;
        avRippPerMin_N2_pre_basal(kk,:)=nanmean(Data(ripp_N2_pre_basal{kk}(:,:)),1); avRippPerMin_N2_pre_basal(avRippPerMin_N2_pre_basal==0)=NaN;
        avRippPerMin_N3_pre_basal(kk,:)=nanmean(Data(ripp_N3_pre_basal{kk}(:,:)),1); avRippPerMin_N3_pre_basal(avRippPerMin_N3_pre_basal==0)=NaN;
    else
    end
end
for kk=1:length(ripp_SWS_post_basal)
    if isempty(ripp_SWS_post_basal{kk})==0
        avRippPerMin_SWS_post_basal(kk,:)=nanmean(Data(ripp_SWS_post_basal{kk}(:,:)),1); avRippPerMin_SWS_post_basal(avRippPerMin_SWS_post_basal==0)=NaN;
        avRippPerMin_Wake_post_basal(kk,:)=nanmean(Data(ripp_Wake_post_basal{kk}(:,:)),1); avRippPerMin_Wake_post_basal(avRippPerMin_Wake_post_basal==0)=NaN;
        avRippPerMin_REM_post_basal(kk,:)=nanmean(Data(ripp_REM_post_basal{kk}(:,:)),1); avRippPerMin_REM_post_basal(avRippPerMin_REM_post_basal==0)=NaN;
        avRippPerMin_N1_post_basal(kk,:)=nanmean(Data(ripp_N1_post_basal{kk}(:,:)),1); avRippPerMin_N1_post_basal(avRippPerMin_N1_post_basal==0)=NaN;
        avRippPerMin_N2_post_basal(kk,:)=nanmean(Data(ripp_N2_post_basal{kk}(:,:)),1); avRippPerMin_N2_post_basal(avRippPerMin_N2_post_basal==0)=NaN;
        avRippPerMin_N3_post_basal(kk,:)=nanmean(Data(ripp_N3_post_basal{kk}(:,:)),1); avRippPerMin_N3_post_basal(avRippPerMin_N3_post_basal==0)=NaN;
        %%3h post injection
        avRippPerMin_SWS_3hPost_basal(kk,:)=nanmean(Data(ripp_SWS_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_SWS_3hPost_basal(avRippPerMin_SWS_3hPost_basal==0)=NaN;
        avRippPerMin_Wake_3hPost_basal(kk,:)=nanmean(Data(ripp_Wake_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_Wake_3hPost_basal(avRippPerMin_Wake_3hPost_basal==0)=NaN;
        avRippPerMin_REM_3hPost_basal(kk,:)=nanmean(Data(ripp_REM_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_REM_3hPost_basal(avRippPerMin_REM_3hPost_basal==0)=NaN;
        avRippPerMin_N1_3hPost_basal(kk,:)=nanmean(Data(ripp_N1_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_N1_3hPost_basal(avRippPerMin_N1_3hPost_basal==0)=NaN;
        avRippPerMin_N2_3hPost_basal(kk,:)=nanmean(Data(ripp_N2_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_N2_3hPost_basal(avRippPerMin_N2_3hPost_basal==0)=NaN;
        avRippPerMin_N3_3hPost_basal(kk,:)=nanmean(Data(ripp_N3_3hPostInj_basal{kk}(:,:)),1); avRippPerMin_N3_3hPost_basal(avRippPerMin_N3_3hPost_basal==0)=NaN;
    else
    end
end
%%saline mice
for ii=1:length(ripp_SWS_pre_sal)
    if isempty(ripp_SWS_pre_sal{ii})==0
        avRippPerMin_SWS_pre_sal(ii,:)=nanmean(Data(ripp_SWS_pre_sal{ii}(:,:)),1); avRippPerMin_SWS_pre_sal(avRippPerMin_SWS_pre_sal==0)=NaN;
        avRippPerMin_Wake_pre_sal(ii,:)=nanmean(Data(ripp_Wake_pre_sal{ii}(:,:)),1); avRippPerMin_Wake_pre_sal(avRippPerMin_Wake_pre_sal==0)=NaN;
        avRippPerMin_REM_pre_sal(ii,:)=nanmean(Data(ripp_REM_pre_sal{ii}(:,:)),1); avRippPerMin_REM_pre_sal(avRippPerMin_REM_pre_sal==0)=NaN;
        avRippPerMin_N1_pre_sal(ii,:)=nanmean(Data(ripp_N1_pre_sal{ii}(:,:)),1); avRippPerMin_N1_pre_sal(avRippPerMin_N1_pre_sal==0)=NaN;
        avRippPerMin_N2_pre_sal(ii,:)=nanmean(Data(ripp_N2_pre_sal{ii}(:,:)),1); avRippPerMin_N2_pre_sal(avRippPerMin_N2_pre_sal==0)=NaN;
        avRippPerMin_N3_pre_sal(ii,:)=nanmean(Data(ripp_N3_pre_sal{ii}(:,:)),1); avRippPerMin_N3_pre_sal(avRippPerMin_N3_pre_sal==0)=NaN;
    else
    end
end
for ii=1:length(ripp_SWS_post_sal)
    if isempty(ripp_SWS_post_sal{ii})==0
        avRippPerMin_SWS_post_sal(ii,:)=nanmean(Data(ripp_SWS_post_sal{ii}(:,:)),1); avRippPerMin_SWS_post_sal(avRippPerMin_SWS_post_sal==0)=NaN;
        avRippPerMin_Wake_post_sal(ii,:)=nanmean(Data(ripp_Wake_post_sal{ii}(:,:)),1); avRippPerMin_Wake_post_sal(avRippPerMin_Wake_post_sal==0)=NaN;
        avRippPerMin_REM_post_sal(ii,:)=nanmean(Data(ripp_REM_post_sal{ii}(:,:)),1); avRippPerMin_REM_post_sal(avRippPerMin_REM_post_sal==0)=NaN;
        avRippPerMin_N1_post_sal(ii,:)=nanmean(Data(ripp_N1_post_sal{ii}(:,:)),1); avRippPerMin_N1_post_sal(avRippPerMin_N1_post_sal==0)=NaN;
        avRippPerMin_N2_post_sal(ii,:)=nanmean(Data(ripp_N2_post_sal{ii}(:,:)),1); avRippPerMin_N2_post_sal(avRippPerMin_N2_post_sal==0)=NaN;
        avRippPerMin_N3_post_sal(ii,:)=nanmean(Data(ripp_N3_post_sal{ii}(:,:)),1); avRippPerMin_N3_post_sal(avRippPerMin_N3_post_sal==0)=NaN;
        %%3h post injection
        avRippPerMin_SWS_3hPost_sal(ii,:)=nanmean(Data(ripp_SWS_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_SWS_3hPost_sal(avRippPerMin_SWS_3hPost_sal==0)=NaN;
        avRippPerMin_Wake_3hPost_sal(ii,:)=nanmean(Data(ripp_Wake_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_Wake_3hPost_sal(avRippPerMin_Wake_3hPost_sal==0)=NaN;
        avRippPerMin_REM_3hPost_sal(ii,:)=nanmean(Data(ripp_REM_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_REM_3hPost_sal(avRippPerMin_REM_3hPost_sal==0)=NaN;
        avRippPerMin_N1_3hPost_sal(ii,:)=nanmean(Data(ripp_N1_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_N1_3hPost_sal(avRippPerMin_N1_3hPost_sal==0)=NaN;
        avRippPerMin_N2_3hPost_sal(ii,:)=nanmean(Data(ripp_N2_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_N2_3hPost_sal(avRippPerMin_N2_3hPost_sal==0)=NaN;
        avRippPerMin_N3_3hPost_sal(ii,:)=nanmean(Data(ripp_N3_3hPostInj_sal{ii}(:,:)),1); avRippPerMin_N3_3hPost_sal(avRippPerMin_N3_3hPost_sal==0)=NaN;    else
    end
end
%%cno mice
for jj=1:length(ripp_SWS_pre_cno)
    if isempty(ripp_SWS_pre_cno{jj})==0
        avRippPerMin_SWS_pre_cno(jj,:)=nanmean(Data(ripp_SWS_pre_cno{jj}(:,:)),1); avRippPerMin_SWS_pre_cno(avRippPerMin_SWS_pre_cno==0)=NaN;
        avRippPerMin_Wake_pre_cno(jj,:)=nanmean(Data(ripp_Wake_pre_cno{jj}(:,:)),1); avRippPerMin_Wake_pre_cno(avRippPerMin_Wake_pre_cno==0)=NaN;
        avRippPerMin_REM_pre_cno(jj,:)=nanmean(Data(ripp_REM_pre_cno{jj}(:,:)),1); avRippPerMin_REM_pre_cno(avRippPerMin_REM_pre_cno==0)=NaN;
        avRippPerMin_N1_pre_cno(jj,:)=nanmean(Data(ripp_N1_pre_cno{jj}(:,:)),1); avRippPerMin_N1_pre_cno(avRippPerMin_N1_pre_cno==0)=NaN;
        avRippPerMin_N2_pre_cno(jj,:)=nanmean(Data(ripp_N2_pre_cno{jj}(:,:)),1); avRippPerMin_N2_pre_cno(avRippPerMin_N2_pre_cno==0)=NaN;
        avRippPerMin_N3_pre_cno(jj,:)=nanmean(Data(ripp_N3_pre_cno{jj}(:,:)),1); avRippPerMin_N3_pre_cno(avRippPerMin_N3_pre_cno==0)=NaN;
    else
    end
end
for jj=1:length(ripp_SWS_post_cno)
    if isempty(ripp_SWS_post_cno{jj})==0
        avRippPerMin_SWS_post_cno(jj,:)=nanmean(Data(ripp_SWS_post_cno{jj}(:,:)),1); avRippPerMin_SWS_post_cno(avRippPerMin_SWS_post_cno==0)=NaN;
        avRippPerMin_Wake_post_cno(jj,:)=nanmean(Data(ripp_Wake_post_cno{jj}(:,:)),1); avRippPerMin_Wake_post_cno(avRippPerMin_Wake_post_cno==0)=NaN;
        avRippPerMin_REM_post_cno(jj,:)=nanmean(Data(ripp_REM_post_cno{jj}(:,:)),1); avRippPerMin_REM_post_cno(avRippPerMin_REM_post_cno==0)=NaN;
        avRippPerMin_N1_post_cno(jj,:)=nanmean(Data(ripp_N1_post_cno{jj}(:,:)),1); avRippPerMin_N1_post_cno(avRippPerMin_N1_post_cno==0)=NaN;
        avRippPerMin_N2_post_cno(jj,:)=nanmean(Data(ripp_N2_post_cno{jj}(:,:)),1); avRippPerMin_N2_post_cno(avRippPerMin_N2_post_cno==0)=NaN;
        avRippPerMin_N3_post_cno(jj,:)=nanmean(Data(ripp_N3_post_cno{jj}(:,:)),1); avRippPerMin_N3_post_cno(avRippPerMin_N3_post_cno==0)=NaN;
        %%3h post injection
                avRippPerMin_SWS_3hPost_cno(jj,:)=nanmean(Data(ripp_SWS_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_SWS_3hPost_cno(avRippPerMin_SWS_3hPost_cno==0)=NaN;
        avRippPerMin_Wake_3hPost_cno(jj,:)=nanmean(Data(ripp_Wake_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_Wake_3hPost_cno(avRippPerMin_Wake_3hPost_cno==0)=NaN;
        avRippPerMin_REM_3hPost_cno(jj,:)=nanmean(Data(ripp_REM_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_REM_3hPost_cno(avRippPerMin_REM_3hPost_cno==0)=NaN;
        avRippPerMin_N1_3hPost_cno(jj,:)=nanmean(Data(ripp_N1_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_N1_3hPost_cno(avRippPerMin_N1_3hPost_cno==0)=NaN;
        avRippPerMin_N2_3hPost_cno(jj,:)=nanmean(Data(ripp_N2_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_N2_3hPost_cno(avRippPerMin_N2_3hPost_cno==0)=NaN;
        avRippPerMin_N3_3hPost_cno(jj,:)=nanmean(Data(ripp_N3_3hPostInj_cno{jj}(:,:)),1); avRippPerMin_N3_3hPost_cno(avRippPerMin_N3_3hPost_cno==0)=NaN;
    else
    end
end


%% ripples density (boxplot)
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];
col_pre_saline = [1 0.6 0.6];
col_post_saline = [1 0.6 0.6];
col_pre_cno = [1 0 0];
col_post_cno = [1 0 0];

figure
subplot(231)
MakeBoxPlot_MC({avRippPerMin_Wake_pre_basal avRippPerMin_Wake_pre_sal avRippPerMin_Wake_pre_cno avRippPerMin_Wake_post_basal avRippPerMin_Wake_post_sal avRippPerMin_Wake_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake')
ylim([0 1])

subplot(232)
MakeBoxPlot_MC({avRippPerMin_SWS_pre_basal avRippPerMin_SWS_pre_sal avRippPerMin_SWS_pre_cno avRippPerMin_SWS_post_basal avRippPerMin_SWS_post_sal avRippPerMin_SWS_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('NREM')
ylim([0 1])

subplot(233)
MakeBoxPlot_MC({avRippPerMin_REM_pre_basal avRippPerMin_REM_pre_sal avRippPerMin_REM_pre_cno avRippPerMin_REM_post_basal avRippPerMin_REM_post_sal avRippPerMin_REM_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('REM')
ylim([0 1])

subplot(234)
MakeBoxPlot_MC({avRippPerMin_N1_pre_basal avRippPerMin_N1_pre_sal avRippPerMin_N1_pre_cno avRippPerMin_N1_post_basal avRippPerMin_N1_post_sal avRippPerMin_N1_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N1')
ylim([0 1])

subplot(235)
MakeBoxPlot_MC({avRippPerMin_N2_pre_basal avRippPerMin_N2_pre_sal avRippPerMin_N2_pre_cno avRippPerMin_N2_post_basal avRippPerMin_N2_post_sal avRippPerMin_N2_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N2')
ylim([0 1])

subplot(236)
MakeBoxPlot_MC({avRippPerMin_N3_pre_basal avRippPerMin_N3_pre_sal avRippPerMin_N3_pre_cno avRippPerMin_N3_post_basal avRippPerMin_N3_post_sal avRippPerMin_N3_post_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N3')
ylim([0 1])

%% figure : ripples density (barplot)

figure
subplot(231)
PlotErrorBarN_KJ({avRippPerMin_Wake_pre_basal avRippPerMin_Wake_pre_sal avRippPerMin_Wake_pre_cno avRippPerMin_Wake_post_basal avRippPerMin_Wake_post_sal avRippPerMin_Wake_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake')
ylim([0 1.5])
makepretty

subplot(232)
PlotErrorBarN_KJ({avRippPerMin_SWS_pre_basal avRippPerMin_SWS_pre_sal avRippPerMin_SWS_pre_cno avRippPerMin_SWS_post_basal avRippPerMin_SWS_post_sal avRippPerMin_SWS_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('NREM')
ylim([0 1.5])
makepretty

subplot(233)
PlotErrorBarN_KJ({avRippPerMin_REM_pre_basal avRippPerMin_REM_pre_sal avRippPerMin_REM_pre_cno avRippPerMin_REM_post_basal avRippPerMin_REM_post_sal avRippPerMin_REM_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('REM')
ylim([0 1.5])
makepretty

subplot(234)
PlotErrorBarN_KJ({avRippPerMin_N1_pre_basal avRippPerMin_N1_pre_sal avRippPerMin_N1_pre_cno avRippPerMin_N1_post_basal avRippPerMin_N1_post_sal avRippPerMin_N1_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N1')
ylim([0 1.5])
makepretty

subplot(235)
PlotErrorBarN_KJ({avRippPerMin_N2_pre_basal avRippPerMin_N2_pre_sal avRippPerMin_N2_pre_cno avRippPerMin_N2_post_basal avRippPerMin_N2_post_sal avRippPerMin_N2_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N2')
ylim([0 1.5])
makepretty

subplot(236)
PlotErrorBarN_KJ({avRippPerMin_N3_pre_basal avRippPerMin_N3_pre_sal avRippPerMin_N3_pre_cno avRippPerMin_N3_post_basal avRippPerMin_N3_post_sal avRippPerMin_N3_post_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('N3')
ylim([0 1.5])
makepretty

%% 3H POST INJECTION

%% ripples density (boxplot)
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];
col_pre_saline = [1 0.6 0.6];
col_post_saline = [1 0.6 0.6];
col_pre_cno = [1 0 0];
col_post_cno = [1 0 0];

figure
subplot(231)
MakeBoxPlot_MC({avRippPerMin_Wake_pre_basal avRippPerMin_Wake_pre_sal avRippPerMin_Wake_pre_cno avRippPerMin_Wake_3hPost_basal avRippPerMin_Wake_3hPost_sal avRippPerMin_Wake_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('Wake')
ylim([0 1])

subplot(232)
MakeBoxPlot_MC({avRippPerMin_SWS_pre_basal avRippPerMin_SWS_pre_sal avRippPerMin_SWS_pre_cno avRippPerMin_SWS_3hPost_basal avRippPerMin_SWS_3hPost_sal avRippPerMin_SWS_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('NREM')
ylim([0 1])

subplot(233)
MakeBoxPlot_MC({avRippPerMin_REM_pre_basal avRippPerMin_REM_pre_sal avRippPerMin_REM_pre_cno avRippPerMin_REM_3hPost_basal avRippPerMin_REM_3hPost_sal avRippPerMin_REM_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('REM')
ylim([0 1])

subplot(234)
MakeBoxPlot_MC({avRippPerMin_N1_pre_basal avRippPerMin_N1_pre_sal avRippPerMin_N1_pre_cno avRippPerMin_N1_3hPost_basal avRippPerMin_N1_3hPost_sal avRippPerMin_N1_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N1')
ylim([0 1])

subplot(235)
MakeBoxPlot_MC({avRippPerMin_N2_pre_basal avRippPerMin_N2_pre_sal avRippPerMin_N2_pre_cno avRippPerMin_N2_3hPost_basal avRippPerMin_N2_3hPost_sal avRippPerMin_N2_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N2')
ylim([0 1])

subplot(236)
MakeBoxPlot_MC({avRippPerMin_N3_pre_basal avRippPerMin_N3_pre_sal avRippPerMin_N3_pre_cno avRippPerMin_N3_3hPost_basal avRippPerMin_N3_3hPost_sal avRippPerMin_N3_3hPost_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N3')
ylim([0 1])

%% figure : ripples density (barplot)

figure
subplot(231)
PlotErrorBarN_KJ({avRippPerMin_Wake_pre_basal avRippPerMin_Wake_pre_sal avRippPerMin_Wake_pre_cno avRippPerMin_Wake_3hPost_basal avRippPerMin_Wake_3hPost_sal avRippPerMin_Wake_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('Wake')
ylim([0 1.5])
makepretty

subplot(232)
PlotErrorBarN_KJ({avRippPerMin_SWS_pre_basal avRippPerMin_SWS_pre_sal avRippPerMin_SWS_pre_cno avRippPerMin_SWS_3hPost_basal avRippPerMin_SWS_3hPost_sal avRippPerMin_SWS_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('NREM')
ylim([0 1.5])
makepretty

subplot(233)
PlotErrorBarN_KJ({avRippPerMin_REM_pre_basal avRippPerMin_REM_pre_sal avRippPerMin_REM_pre_cno avRippPerMin_REM_3hPost_basal avRippPerMin_REM_3hPost_sal avRippPerMin_REM_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('REM')
ylim([0 1.5])
makepretty

subplot(234)
PlotErrorBarN_KJ({avRippPerMin_N1_pre_basal avRippPerMin_N1_pre_sal avRippPerMin_N1_pre_cno avRippPerMin_N1_3hPost_basal avRippPerMin_N1_3hPost_sal avRippPerMin_N1_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N1')
ylim([0 1.5])
makepretty

subplot(235)
PlotErrorBarN_KJ({avRippPerMin_N2_pre_basal avRippPerMin_N2_pre_sal avRippPerMin_N2_pre_cno avRippPerMin_N2_3hPost_basal avRippPerMin_N2_3hPost_sal avRippPerMin_N2_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N2')
ylim([0 1.5])
makepretty

subplot(236)
PlotErrorBarN_KJ({avRippPerMin_N3_pre_basal avRippPerMin_N3_pre_sal avRippPerMin_N3_pre_cno avRippPerMin_N3_3hPost_basal avRippPerMin_N3_3hPost_sal avRippPerMin_N3_3hPost_cno},'newfig',0,'paired',0);
xticks([2 5]); xticklabels({'pre','3h post'})
ylabel('Ripples/s')
title('N3')
ylim([0 1.5])
makepretty

% %% figure : ripples density overtime
% figure
% %%ripples density overtime (saline)
% for j=1:length(DirSaline.path)
%     VecTimeDay_WAKE_sal{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},a{j}.Wake)), 0);
%     VecTimeDay_SWS_sal{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},a{j}.SWSEpoch)), 0);
%     VecTimeDay_REM_sal{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},a{j}.REMEpoch)), 0);
%
%     subplot(3,5,[1,2]),
%     % plot(Range(Restrict(RippDensity_sal{i},a{i}.Wake))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.Wake)),70),'.'), hold on
%     plot(VecTimeDay_WAKE_sal{j}, runmean(Data(Restrict(RippDensity_cno{j},a{j}.Wake)),70),'.'), hold on
%     ylabel('Ripples/s')
%     ylim([0 1.8])
%     title('WAKE (saline)')
%     makepretty
%     subplot(3,5,[6,7]),
%     % plot(Range(Restrict(RippDensity_sal{i},a{i}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
%     plot(VecTimeDay_SWS_sal{j}, runmean(Data(Restrict(RippDensity_cno{j},a{j}.SWSEpoch)),70),'.'), hold on
%     ylabel('Ripples/s')
%     title('NREM (saline)')
%     ylim([0 1.8])
%     makepretty
%     subplot(3,5,[11,12]),
%     % plot(Range(Restrict(RippDensity_sal{i},a{i}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
%     plot(VecTimeDay_REM_sal{j}, runmean(Data(Restrict(RippDensity_cno{j},a{j}.REMEpoch)),70),'.'), hold on
%     ylabel('Ripples/s')
%     title('REM (saline)')
%     ylim([0 1.8])
%     xlabel('Time (s)')
%     makepretty
%     legend({'m1196','m1197','m1105','m1106','m1149'})
% end
% %%ripples density overtime (CNO)
% for j=1:length(DirCNO.path)
%     VecTimeDay_WAKE_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.Wake)), 0);
%     VecTimeDay_SWS_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)), 0);
%     VecTimeDay_REM_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.REMEpoch)), 0);
%
%     subplot(3,5,[3,4]),
%     % plot(Range(Restrict(RippDensity_cno{j},b{j}.Wake))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.Wake)),70),'.'), hold on
%     plot(VecTimeDay_WAKE_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.Wake)),70),'.'), hold on
%     ylim([0 1.8])
%     title('WAKE (cno)')
%     makepretty
%     subplot(3,5,[8,9]),
%     % plot(Range(Restrict(RippDensity_cno{j},b{j}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)),70),'.'), hold on
%     plot(VecTimeDay_SWS_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)),70),'.'), hold on
%     title('NREM (cno)')
%     ylim([0 1.8])
%     makepretty
%     subplot(3,5,[13,14]),
%     % plot(Range(Restrict(RippDensity_cno{j},b{j}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.REMEpoch)),70),'.'), hold on
%     plot(VecTimeDay_REM_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.REMEpoch)),70),'.'), hold on
%     title('REM (cno)')
%     ylim([0 1.8])
%     xlabel('Time (s)')
%     makepretty
%     legend({'mouse1196','mouse1197'})
% end
% %%bar plot
% %%wake
% ax(1)=subplot(3,5,5),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% xticks([1.5 3.5])
% xticklabels({'Pre','Post'})
% title('WAKE')
% makepretty
% %%sws
% ax(2)=subplot(3,5,10),PlotErrorBarN_KJ({avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% xticks([1.5 3.5])
% xticklabels({'Pre','Post'})
% title('NREM')
% makepretty
% %%rem
% ax(3)=subplot(3,5,15),PlotErrorBarN_KJ({avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},'newfig',0,'paired',0);
% ylabel('Ripples/s')
% xticks([1.5 3.5])
% xticklabels({'Pre','Post'})
% title('REM')
% makepretty
%
% set(ax,'ylim',[0 1]);

