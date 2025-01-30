%% input dir : exi DREADD VLPO CRH-neurons
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149 1150]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
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
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% 
% DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%% input dir (sleep inhi DREADD in PFC)
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% 
DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% % DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1198]);
% DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');


%% input dir (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir (atropine experiment)
%% input dir ATROPINE
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% 
% DirCNO = PathForExperimentsAtropine_MC('Atropine');

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%% get data
%baseline
for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    
    if exist('SleepScoring_OBGamma.mat')
        c{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_Accelero.mat')
        c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
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
    durtotal_basal{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    epoch_pre_basal{k} = intervalSet(0,en_epoch_preInj);
    epoch_post_basal{k} = intervalSet(st_epoch_postInj,durtotal_basal{k});
    %3h post injection
    epoch_3hPostInj_basal{k} = intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    
    if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
        
        if isempty(ripp_basal{k})==0
            
            
            
            
            %             %%load deltas
            %                 rippBasal{k} = load('DeltaWaves.mat','deltas_PFCx');
            % get deltas density
            [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_basal{k}.RipplesEpoch);
            RippDensity_basal{k} = Ripples_tsd;
            % find deltas in specific epoch
            ripp_SWSbefore_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.SWSEpoch, epoch_pre_basal{k}));
            ripp_Wakebefore_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.Wake, epoch_pre_basal{k}));
            ripp_REMbefore_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.REMEpoch, epoch_pre_basal{k}));

            ripp_SWSafter_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.SWSEpoch, epoch_post_basal{k}));
            ripp_Wakeafter_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.Wake, epoch_post_basal{k}));
            ripp_REMafter_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.REMEpoch, epoch_post_basal{k}));
            
            ripp_SWS_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.SWSEpoch, epoch_3hPostInj_basal{k}));
            ripp_Wake_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.Wake, epoch_3hPostInj_basal{k}));
            ripp_REM_3hPost_basal{k} = Restrict(RippDensity_basal{k}, and(c{k}.REMEpoch, epoch_3hPostInj_basal{k}));
           
            
        else
        end
    else
    end
    %
end



%% get the data saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_sal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %pre injection
    epoch_pre_sal{i} = intervalSet(0,en_epoch_preInj);
    %post injection
    epoch_post_sal{i} = intervalSet(st_epoch_postInj,durtotal_sal{i});
    %3h post injection
    epoch_3hPostInj_sal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    %     %%restrict to period with low movement
    %     d{j} = load('behavResources.mat', 'Vtsd','FreezeAccEpoch');
    %     % threshold on speed to get period of high/low activity
    %     thresh_sal{j} = mean(Data(d{j}.Vtsd))+std(Data(d{j}.Vtsd));
    %     highMov_sal{j} = thresholdIntervals(d{j}.Vtsd, thresh_sal{j}, 'Direction', 'Above');
    %     lowMov_sal{j} = thresholdIntervals(d{j}.Vtsd, thresh_sal{j}, 'Direction', 'Below');
    
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
    ripp_SWSbefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.SWSEpoch, epoch_pre_sal{i}));
    ripp_Wakebefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.Wake, epoch_pre_sal{i}));
    ripp_REMbefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.REMEpoch, epoch_pre_sal{i}));

    ripp_SWSafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.SWSEpoch, epoch_post_sal{i}));
    ripp_Wakeafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.Wake, epoch_post_sal{i}));
    ripp_REMafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.REMEpoch, epoch_post_sal{i}));
    
    ripp_SWS_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.SWSEpoch, epoch_3hPostInj_sal{i}));
    ripp_Wake_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.Wake, epoch_3hPostInj_sal{i}));
    ripp_REM_3hPost_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.REMEpoch, epoch_3hPostInj_sal{i}));
    
    %     %%find ripples during freezing periods
    %     ripp_Freezebefore_sal{j} = Restrict(ripples_sal{j}, and(d{j}.FreezeAccEpoch,Epoch1_sal{j}));
    %     ripp_Freezeafter_sal{j} = Restrict(ripples_sal{j}, and(d{j}.FreezeAccEpoch,Epoch2_sal{j}));
    %
    %     %%find ripples during wake with high/low mov
    %     ripp_Wakebefore_lowMov_sal{j} = Restrict(ripples_sal{j}, and(and(c{j}.Wake,lowMov_sal{j}), Epoch1_sal{j}));
    %     ripp_Wakebefore_highMov_sal{j} = Restrict(ripples_sal{j}, and(and(c{j}.Wake,highMov_sal{j}), Epoch1_sal{j}));
    %     ripp_Wakeafter_lowMov_sal{j} = Restrict(ripples_sal{j}, and(and(c{j}.Wake,lowMov_sal{j}), Epoch2_sal{j}));
    %     ripp_Wakeafter_highMov_sal{j} = Restrict(ripples_sal{j}, and(and(c{j}.Wake,highMov_sal{j}), Epoch2_sal{j}));
end



%% get data CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_cno{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %pre injection
    epoch_pre_cno{j} = intervalSet(0,en_epoch_preInj);
    %post injection
    epoch_post_cno{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
    %3h post injection
    epoch_3hPostInj_cno{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
    
    %     %%restrict to period with low movement
    %     f{k} = load('behavResources.mat', 'Vtsd','FreezeAccEpoch');
    %     % threshold on speed to get period of high/low activity
    %     thresh_cno{k} = mean(Data(f{k}.Vtsd))+std(Data(f{k}.Vtsd));
    %     highMov_cno{k} = thresholdIntervals(f{k}.Vtsd, thresh_cno{k}, 'Direction', 'Above');
    %     lowMov_cno{k} = thresholdIntervals(f{k}.Vtsd, thresh_cno{k}, 'Direction', 'Below');
    
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
        ripp_SWSbefore_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.SWSEpoch, epoch_pre_cno{j}));
        ripp_Wakebefore_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.Wake, epoch_pre_cno{j}));
        ripp_REMbefore_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.REMEpoch, epoch_pre_cno{j}));

        ripp_SWSafter_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.SWSEpoch, epoch_post_cno{j}));
        ripp_Wakeafter_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.Wake, epoch_post_cno{j}));
        ripp_REMafter_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.REMEpoch, epoch_post_cno{j}));
        
                ripp_SWS_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.SWSEpoch, epoch_3hPostInj_cno{j}));
        ripp_Wake_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.Wake, epoch_3hPostInj_cno{j}));
        ripp_REM_3hPost_cno{j} = Restrict(RippDensity_cno{j}, and(b{j}.REMEpoch, epoch_3hPostInj_cno{j}));
        
        %     %%find ripples during freezing periods
        %     ripp_Freezebefore_cno{k} = Restrict(ripples_cno{k}, and(f{k}.FreezeAccEpoch,Epoch1_CNO{k}));
        %     ripp_Freezeafter_cno{k} = Restrict(ripples_cno{k}, and(f{k}.FreezeAccEpoch,Epoch2_CNO{k}));
        %
        %     %%find ripples during wake with high/low mov
        %     ripp_Wakebefore_lowMov_cno{k} = Restrict(ripples_cno{k}, and(and(f{k}.Wake,lowMov_cno{k}), Epoch1_CNO{k}));
        %     ripp_Wakebefore_highMov_cno{k} = Restrict(ripples_cno{k}, and(and(f{k}.Wake,highMov_cno{k}), Epoch1_CNO{k}));
        %     rip_Wakeafter_lowMov_cno{k} = Restrict(ripples_cno{k}, and(and(f{k}.Wake,lowMov_cno{k}), Epoch2_CNO{k}));
        %     ripp_Wakeafter_highMov_cno{k} = Restrict(ripples_cno{k}, and(and(f{k}.Wake,highMov_cno{k}), Epoch2_CNO{k}));
        
    else
    end
end

%% calculate mean
%baseline mice
for kk=1:length(ripp_SWSbefore_basal)
    if isempty(ripp_SWSbefore_basal{kk})==0
        
        avRippPerMin_SWSbefore_basal(kk,:)=nanmean(Data(ripp_SWSbefore_basal{kk}(:,:)),1); avRippPerMin_SWSbefore_basal(avRippPerMin_SWSbefore_basal==0)=NaN;
        avRippPerMin_Wakebefore_basal(kk,:)=nanmean(Data(ripp_Wakebefore_basal{kk}(:,:)),1); avRippPerMin_Wakebefore_basal(avRippPerMin_Wakebefore_basal==0)=NaN;
        avRippPerMin_REMbefore_basal(kk,:)=nanmean(Data(ripp_REMbefore_basal{kk}(:,:)),1); avRippPerMin_REMbefore_basal(avRippPerMin_REMbefore_basal==0)=NaN;
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
        
        
    else
    end
end

%saline mice
for ii=1:length(ripp_SWSbefore_sal)
    avRippPerMin_SWSbefore_sal(ii,:)=nanmean(Data(ripp_SWSbefore_sal{ii}(:,:)),1);
    avRippPerMin_Wakebefore_sal(ii,:)=nanmean(Data(ripp_Wakebefore_sal{ii}(:,:)),1);
    avRippPerMin_REMbefore_sal(ii,:)=nanmean(Data(ripp_REMbefore_sal{ii}(:,:)),1);
    %     %%for wake with high/low mov
    %     avRippPerMin_Wakebefore_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_lowMov_sal{ii}(:,:)),1);
    %     avRippPerMin_Wakebefore_highMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_highMov_sal{ii}(:,:)),1);
end
for ii=1:length(ripp_SWSafter_sal)
    avRippPerMin_SWSafter_sal(ii,:)=nanmean(Data(ripp_SWSafter_sal{ii}(:,:)),1);
    avRippPerMin_Wakeafter_sal(ii,:)=nanmean(Data(ripp_Wakeafter_sal{ii}(:,:)),1);
    avRippPerMin_REMafter_sal(ii,:)=nanmean(Data(ripp_REMafter_sal{ii}(:,:)),1);
    
        avRippPerMin_SWS_3hPost_sal(ii,:)=nanmean(Data(ripp_SWS_3hPost_sal{ii}(:,:)),1);
    avRippPerMin_Wake_3hPost_sal(ii,:)=nanmean(Data(ripp_Wake_3hPost_sal{ii}(:,:)),1);
    avRippPerMin_REM_3hPost_sal(ii,:)=nanmean(Data(ripp_REM_3hPost_sal{ii}(:,:)),1);
    
    
    %     %%for wake with high/low mov
    %     avRippPerMin_Wakeafter_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_lowMov_sal{ii}(:,:)),1);
    %     avRippPerMin_Wakeafter_highMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_highMov_sal{ii}(:,:)),1);
    %     %%for wake with freezing
    %     avRippPerMin_Freezebefore_sal(ii,:)=nanmean(Data(ripp_Freezebefore_sal{ii}(:,:)),1);
    %     avRippPerMin_Freezeafter_sal(ii,:)=nanmean(Data(ripp_Freezeafter_sal{ii}(:,:)),1);
end

%cno mice
for jj=1:length(ripp_SWSbefore_cno)
    if isempty(ripp_SWSbefore_cno{jj})==0
        
        avRippPerMin_SWSbefore_cno(jj,:)=nanmean(Data(ripp_SWSbefore_cno{jj}(:,:)),1); avRippPerMin_SWSbefore_cno(avRippPerMin_SWSbefore_cno==0)=NaN;
        avRippPerMin_Wakebefore_cno(jj,:)=nanmean(Data(ripp_Wakebefore_cno{jj}(:,:)),1); avRippPerMin_Wakebefore_cno(avRippPerMin_Wakebefore_cno==0)=NaN;
        avRippPerMin_REMbefore_cno(jj,:)=nanmean(Data(ripp_REMbefore_cno{jj}(:,:)),1); avRippPerMin_REMbefore_cno(avRippPerMin_REMbefore_cno==0)=NaN;
        %     %%for wake with high/low mov
        %     avRippPerMin_Wakebefore_lowMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_lowMov_cno{jj}(:,:)),1);
        %     avRippPerMin_Wakebefore_highMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_highMov_cno{jj}(:,:)),1);
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
        
        %     %%for wake with high/low mov
        %     avRippPerMin_Wakeafter_lowMov_cno(jj,:)=nanmean(Data(rip_Wakeafter_lowMov_cno{jj}(:,:)),1);
        %     avRippPerMin_Wakeafter_highMov_cno(jj,:)=nanmean(Data(ripp_Wakeafter_highMov_cno{jj}(:,:)),1);
        %     %%for wake with freezing
        %     avRippPerMin_Freezebefore_cno(jj,:)=nanmean(Data(ripp_Freezebefore_cno{jj}(:,:)),1);
        %     avRippPerMin_Freezeafter_cno(jj,:)=nanmean(Data(ripp_Freezeafter_cno{jj}(:,:)),1);
    else
    end
end


%% figure : ripples density (bars)
figure,
subplot(321),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_basal,avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_basal,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','Post'})
title('WAKE')
makepretty

subplot(323),PlotErrorBarN_KJ({avRippPerMin_SWSbefore_basal,avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_basal,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','Post'})
title('NREM')
makepretty

subplot(325),PlotErrorBarN_KJ({avRippPerMin_REMbefore_basal,avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_basal,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','Post'})
title('REM')
makepretty




subplot(322),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_basal,avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wake_3hPost_basal,avRippPerMin_Wake_3hPost_sal,avRippPerMin_Wake_3hPost_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','3h Post'})
title('WAKE')
makepretty

subplot(324),PlotErrorBarN_KJ({avRippPerMin_SWSbefore_basal,avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWS_3hPost_basal,avRippPerMin_SWS_3hPost_sal,avRippPerMin_SWS_3hPost_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','3h Post'})
title('NREM')
makepretty

subplot(326),PlotErrorBarN_KJ({avRippPerMin_REMbefore_basal,avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REM_3hPost_basal,avRippPerMin_REM_3hPost_sal,avRippPerMin_REM_3hPost_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([2 5])
xticklabels({'Pre','3h Post'})
title('REM')
makepretty



%% figure : ripples density overtime
figure
%%ripples density overtime (saline)
for i=1:length(DirSaline.path)
    VecTimeDay_WAKE_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},a{i}.Wake)), 0);
    VecTimeDay_SWS_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)), 0);
    VecTimeDay_REM_sal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_sal{i},a{i}.REMEpoch)), 0);
    
    subplot(3,5,[1,2]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.Wake))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.Wake)),70),'.'), hold on
    plot(VecTimeDay_WAKE_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},a{i}.Wake)),70),'.'), hold on
    ylabel('Ripples/s')
    ylim([0 1.8])
    xlim([9 19])
    title('WAKE (saline)')
    set(gca,'FontSize',14)
    subplot(3,5,[6,7]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
    plot(VecTimeDay_SWS_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
    ylabel('Ripples/s')
    title('NREM (saline)')
    ylim([0 1.8])
    xlim([9 19])
    set(gca,'FontSize',14)
    subplot(3,5,[11,12]),
    % plot(Range(Restrict(RippDensity_sal{i},a{i}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
    plot(VecTimeDay_REM_sal{i}, runmean(Data(Restrict(RippDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
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

    VecTimeDay_WAKE_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.Wake)), 0);
    VecTimeDay_SWS_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)), 0);
    VecTimeDay_REM_CNO{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_cno{j},b{j}.REMEpoch)), 0);
    
    subplot(3,5,[3,4]),
    % plot(Range(Restrict(RippDensity_cno{j},b{j}.Wake))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.Wake)),70),'.'), hold on
    plot(VecTimeDay_WAKE_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.Wake)),70),'.'), hold on
    ylim([0 1.8])
        xlim([9 19])
    title('WAKE (cno)')
    set(gca,'FontSize',14)
    subplot(3,5,[8,9]),
    % plot(Range(Restrict(RippDensity_cno{j},b{j}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)),70),'.'), hold on
    plot(VecTimeDay_SWS_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.SWSEpoch)),70),'.'), hold on
    title('NREM (cno)')
    ylim([0 1.8])
        xlim([9 19])
    set(gca,'FontSize',14)
    subplot(3,5,[13,14]),
    % plot(Range(Restrict(RippDensity_cno{j},b{j}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},b{j}.REMEpoch)),70),'.'), hold on
    plot(VecTimeDay_REM_CNO{j}, runmean(Data(Restrict(RippDensity_cno{j},b{j}.REMEpoch)),70),'.'), hold on
    title('REM (cno)')
    ylim([0 1.8])
    xlim([9 19])
    xlabel('Time (s)')
    set(gca,'FontSize',14)
    legend({'mouse1196','mouse1197'})
        else
        end
end
%% bar plot
%%wake
ax(1)=subplot(3,5,5),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('WAKE')
makepretty
%%sws
ax(2)=subplot(3,5,10),PlotErrorBarN_KJ({avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('NREM')
makepretty
%%rem
ax(3)=subplot(3,5,15),PlotErrorBarN_KJ({avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('REM')
makepretty

set(ax,'ylim',[0 1]);

%%
% %% figure : ripples density for each state
% avRippPerMin_REMafter_cno = NaN;
% figure,subplot(171),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_sal avRippPerMin_Wakebefore_cno},'newfig',0, 'paired',0);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.7])
% ylabel('ripples/s')
% title('WAKE')
% makepretty
% subplot(172), PlotErrorBarN_KJ({avRippPerMin_SWSbefore_sal avRippPerMin_SWSbefore_cno},'newfig',0, 'paired',0);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.7])
% ylabel('ripples/s')
% title('NREM')
% makepretty
% subplot(173), PlotErrorBarN_KJ({avRippPerMin_REMbefore_sal avRippPerMin_REMbefore_cno},'newfig',0, 'paired',0);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.7])
% ylabel('ripples/s')
% title('REM')
% makepretty
% subplot(175),PlotErrorBarN_KJ({avRippPerMin_Wakeafter_sal avRippPerMin_Wakeafter_cno},'newfig',0, 'paired',0);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.7])
% ylabel('ripples/s')
% title('WAKE')
% makepretty
% subplot(176), PlotErrorBarN_KJ({avRippPerMin_SWSafter_sal avRippPerMin_SWSafter_cno},'newfig',0, 'paired',0);
% ylim([0 0.7])
% xticklabels({'sal','CNO'})
% ylim([0 1])
% ylabel('ripples/s')
% title('NREM')
% makepretty
% subplot(177), PlotErrorBarN_KJ({avRippPerMin_REMafter_sal avRippPerMin_REMafter_cno},'newfig',0, 'paired',0);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.7])
% ylabel('ripples/s')
% title('REM')
% makepretty
%


% %% figure : ripples density during wake with high/low activity
% figure
% subplot(221), PlotErrorBarN_KJ({avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.15])
% ylabel('ripples/s')
% title('Wake lowMov PRE inj')
% makepretty
% subplot(222),PlotErrorBarN_KJ({avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.15])
% ylabel('ripples/s')
% title('Wake lowMov POST inj')
% makepretty
% subplot(223),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.15])
% ylabel('ripples/s')
% title('Wake highMov PRE inj')
% makepretty
% subplot(224), PlotErrorBarN_KJ({avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% ylim([0 0.15])
% ylabel('ripples/s')
% title('Wake highMov POST inj')
% makepretty


% %% figure : ripples density during freezing
% figure
% subplot(121), PlotErrorBarN_KJ({avRippPerMin_Freezebefore_sal avRippPerMin_Freezebefore_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% % ylim([0 0.15])
% ylabel('ripples/s')
% makepretty
% subplot(122),PlotErrorBarN_KJ({avRippPerMin_Freezeafter_sal avRippPerMin_Freezeafter_cno},'newfig',0, 'paired',1);
% xticks([1 2])
% xticklabels({'sal','CNO'})
% % ylim([0 0.15])
% ylabel('ripples/s')
% makepretty


%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

col_pre_saline = [1 0.6 0.6]; %%rose
col_post_saline = [1 0.6 0.6];
col_pre_cno = [1 0 0]; %rouge
col_post_cno = [1 0 0];

% col_pre_saline = [0.3 0.3 0.3]; %vert
% col_post_saline = [0.3 0.3 0.3];
% 
% col_pre_cno = [0.6 1 0.4]; %vert
% col_post_cno = [0.6 1 0.4];
% 
% col_pre_cno = [0.4 1 0.2]; %vert
% col_post_cno = [0.4 1 0.2];

figure,
subplot(131)
MakeBoxPlot_MC({avRippPerMin_Wakebefore_basal,avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_basal,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('Wake')

subplot(132)
MakeBoxPlot_MC({avRippPerMin_SWSbefore_basal,avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_basal,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('NREM')

subplot(133)
MakeBoxPlot_MC({avRippPerMin_REMbefore_basal,avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_basal,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Ripples/s')
title('REM')


