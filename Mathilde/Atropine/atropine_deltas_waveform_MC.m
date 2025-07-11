%% input dir : atropine experiment
%% DIR ATROPINE
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112

DirCNO = PathForExperimentsAtropine_MC('Atropine');

%% parameters (to take off injection time (1pm))
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


% get data
%saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    stage_sal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','SmoothTheta','Info');
    gamma_sal{i} = load('SleepScoring_OBGamma', 'SmoothGamma', 'Info');
        
    % separate recording before/after injection
        durtotal_basal{i} = max([max(End(stage_sal{i}.Wake)),max(End(stage_sal{i}.SWSEpoch))]);
        epoch_pre_basal{i} = intervalSet(0,en_epoch_preInj);
        epoch_post_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
        
    if exist('DeltaWaves.mat')
        deltSal{i} = load('DeltaWaves.mat','alldeltas_PFCx');
        %%WAKE
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_sal{i}.Wake,...
            stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,deltSal{i}.alldeltas_PFCx,'wake',0);
        dataDeltaSup_Ctrl_WakePre{i} = Msup_pre;
        dataDeltaDeep_Ctrl_WakePre{i} = Mdeep_pre;
        if isempty(dataDeltaSup_Ctrl_WakePre{i})==1
            dataDeltaSup_Ctrl_WakePre{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_WakePre{i}(1001,4) = NaN;
        else
        end

        dataDeltaSup_Ctrl_WakePost{i} = Msup_post;
        dataDeltaDeep_Ctrl_WakePost{i} = Mdeep_post;
        if isempty(dataDeltaSup_Ctrl_WakePost{i})==1
            dataDeltaSup_Ctrl_WakePost{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_WakePost{i}(1001,4) = NaN;
        else
        end
        
        
        %%REM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_sal{i}.Wake,...
            stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,deltSal{i}.alldeltas_PFCx,'rem',0);
        dataDeltaSup_Ctrl_REMPre{i} = Msup_pre;
        dataDeltaDeep_Ctrl_REMPre{i} = Mdeep_pre;
        if isempty(dataDeltaSup_Ctrl_REMPre{i})==1
            dataDeltaSup_Ctrl_REMPre{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_REMPre{i}(1001,4) = NaN;
        else
        end
        

        dataDeltaSup_Ctrl_REMPost{i} = Msup_post;
        dataDeltaDeep_Ctrl_REMPost{i} = Mdeep_post;
        if isempty(dataDeltaSup_Ctrl_REMPost{i})==1
            dataDeltaSup_Ctrl_REMPost{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_REMPost{i}(1001,4) = NaN;
        else
        end
        
        %%NREM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_sal{i}.Wake,...
            stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,deltSal{i}.alldeltas_PFCx,'sws',0);
        dataDeltaSup_Ctrl_SWSPre{i} = Msup_pre;
        dataDeltaDeep_Ctrl_SWSPre{i} = Mdeep_pre;
        if isempty(dataDeltaSup_Ctrl_SWSPre{i})==1
            dataDeltaSup_Ctrl_SWSPre{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_SWSPre{i}(1001,4) = NaN;
        else
        end

        dataDeltaSup_Ctrl_SWSPost{i} = Msup_post;
        dataDeltaDeep_Ctrl_SWSPost{i} = Mdeep_post;
        if isempty(dataDeltaSup_Ctrl_SWSPost{i})==1
            dataDeltaSup_Ctrl_SWSPost{i}(1001,4) = NaN;
            dataDeltaDeep_Ctrl_SWSPost{i}(1001,4) = NaN;
        else
        end
    else
    end
end

%%
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    stage_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','SmoothTheta','Info');
    gamma_cno{j} = load('SleepScoring_OBGamma', 'SmoothGamma', 'Info');
        
    % separate recording before/after injection
        durtotal_bacno{j} = max([max(End(stage_cno{j}.Wake)),max(End(stage_cno{j}.SWSEpoch))]);
        epoch_pre_bacno{j} = intervalSet(0,en_epoch_preInj);
        epoch_post_bacno{j} = intervalSet(st_epoch_postInj,durtotal_bacno{j});
        
    if exist('DeltaWaves.mat')
        deltcno{j} = load('DeltaWaves.mat','alldeltas_PFCx');
        %%WAKE
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,deltcno{j}.alldeltas_PFCx,'wake',0);
        dataDeltaSup_CNO_WakePre{j} = Msup_pre;
        dataDeltaDeep_CNO_WakePre{j} = Mdeep_pre;
        if isempty(dataDeltaSup_CNO_WakePre{j})==1
            dataDeltaSup_CNO_WakePre{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_WakePre{j}(1001,4) = NaN;
        else
        end
        

        dataDeltaSup_CNO_WakePost{j} = Msup_post;
        dataDeltaDeep_CNO_WakePost{j} = Mdeep_post;
        if isempty(dataDeltaSup_CNO_WakePost{j})==1
            dataDeltaSup_CNO_WakePost{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_WakePost{j}(1001,4) = NaN;
        else
        end
        
        
        %%REM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,deltcno{j}.alldeltas_PFCx,'rem',0);
        dataDeltaSup_CNO_REMPre{j} = Msup_pre;
        dataDeltaDeep_CNO_REMPre{j} = Mdeep_pre;
        if isempty(dataDeltaSup_CNO_REMPre{j})==1
            dataDeltaSup_CNO_REMPre{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_REMPre{j}(1001,4) = NaN;
        else
        end

        dataDeltaSup_CNO_REMPost{j} = Msup_post;
        dataDeltaDeep_CNO_REMPost{j} = Mdeep_post;
        if isempty(dataDeltaSup_CNO_REMPost{j})==1
            dataDeltaSup_CNO_REMPost{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_REMPost{j}(1001,4) = NaN;
        else
        end
        
        %%NREM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,deltcno{j}.alldeltas_PFCx,'sws',0);
        dataDeltaSup_CNO_SWSPre{j} = Msup_pre;
        dataDeltaDeep_CNO_SWSPre{j} = Mdeep_pre;
        if isempty(dataDeltaSup_CNO_SWSPre{j})==1
            dataDeltaSup_CNO_SWSPre{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_SWSPre{j}(1001,4) = NaN;
        else
        end

        dataDeltaSup_CNO_SWSPost{j} = Msup_post;
        dataDeltaDeep_CNO_SWSPost{j} = Mdeep_post;
        if isempty(dataDeltaSup_CNO_SWSPost{j})==1
            dataDeltaSup_CNO_SWSPost{j}(1001,4) = NaN;
            dataDeltaDeep_CNO_SWSPost{j}(1001,4) = NaN;
        else
        end
    else
    end
end



                                          


%%



clrs_pre = ':k';
clrs_post = 'g';

s2=length(DirSaline.path);
s3=1;

figure
for imouse=1:length(DirSaline.path)
    %WAKE
    ax(1)= subplot(3,s2,s3),
    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_WakePre{imouse}(:,1), dataDeltaSup_Ctrl_WakePre{imouse}(:,2), dataDeltaSup_Ctrl_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_WakePre{imouse}(:,1), dataDeltaDeep_Ctrl_WakePre{imouse}(:,2), dataDeltaDeep_Ctrl_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_WakePost{imouse}(:,1), dataDeltaSup_Ctrl_WakePost{imouse}(:,2), dataDeltaSup_Ctrl_WakePost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_WakePost{imouse}(:,1), dataDeltaDeep_Ctrl_WakePost{imouse}(:,2), dataDeltaDeep_Ctrl_WakePost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %NREM
    ax(2)=subplot(3,s2,s3+s2),
    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_SWSPre{imouse}(:,1), dataDeltaSup_Ctrl_SWSPre{imouse}(:,2), dataDeltaSup_Ctrl_SWSPre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_SWSPre{imouse}(:,1), dataDeltaDeep_Ctrl_SWSPre{imouse}(:,2), dataDeltaDeep_Ctrl_SWSPre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_SWSPost{imouse}(:,1), dataDeltaSup_Ctrl_SWSPost{imouse}(:,2), dataDeltaSup_Ctrl_SWSPost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_SWSPost{imouse}(:,1), dataDeltaDeep_Ctrl_SWSPost{imouse}(:,2), dataDeltaDeep_Ctrl_SWSPost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),
    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_REMPre{imouse}(:,1), dataDeltaSup_Ctrl_REMPre{imouse}(:,2), dataDeltaSup_Ctrl_REMPre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_REMPre{imouse}(:,1), dataDeltaDeep_Ctrl_REMPre{imouse}(:,2), dataDeltaDeep_Ctrl_REMPre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_Ctrl_REMPost{imouse}(:,1), dataDeltaSup_Ctrl_REMPost{imouse}(:,2), dataDeltaSup_Ctrl_REMPost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_Ctrl_REMPost{imouse}(:,1), dataDeltaDeep_Ctrl_REMPost{imouse}(:,2), dataDeltaDeep_Ctrl_REMPost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    set(ax,'xlim',[-.5 .5],'ylim',[-1000 +3000])
    
    s3=s3+1;
end

%% 
s2=length(DirCNO.path);
s3=1;

figure
for imouse=1:length(DirCNO.path)
    %WAKE
    ax(1)= subplot(3,s2,s3),
    s_sup=shadedErrorBar(dataDeltaSup_CNO_WakePre{imouse}(:,1), dataDeltaSup_CNO_WakePre{imouse}(:,2), dataDeltaSup_CNO_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_WakePre{imouse}(:,1), dataDeltaDeep_CNO_WakePre{imouse}(:,2), dataDeltaDeep_CNO_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_CNO_WakePost{imouse}(:,1), dataDeltaSup_CNO_WakePost{imouse}(:,2), dataDeltaSup_CNO_WakePost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_WakePost{imouse}(:,1), dataDeltaDeep_CNO_WakePost{imouse}(:,2), dataDeltaDeep_CNO_WakePost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %NREM
    ax(2)=subplot(3,s2,s3+s2),
    s_sup=shadedErrorBar(dataDeltaSup_CNO_SWSPre{imouse}(:,1), dataDeltaSup_CNO_SWSPre{imouse}(:,2), dataDeltaSup_CNO_SWSPre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_SWSPre{imouse}(:,1), dataDeltaDeep_CNO_SWSPre{imouse}(:,2), dataDeltaDeep_CNO_SWSPre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_CNO_SWSPost{imouse}(:,1), dataDeltaSup_CNO_SWSPost{imouse}(:,2), dataDeltaSup_CNO_SWSPost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_SWSPost{imouse}(:,1), dataDeltaDeep_CNO_SWSPost{imouse}(:,2), dataDeltaDeep_CNO_SWSPost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),
    s_sup=shadedErrorBar(dataDeltaSup_CNO_REMPre{imouse}(:,1), dataDeltaSup_CNO_REMPre{imouse}(:,2), dataDeltaSup_CNO_REMPre{imouse}(:,3), clrs_pre, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_REMPre{imouse}(:,1), dataDeltaDeep_CNO_REMPre{imouse}(:,2), dataDeltaDeep_CNO_REMPre{imouse}(:,3), clrs_pre, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');

    s_sup=shadedErrorBar(dataDeltaSup_CNO_REMPost{imouse}(:,1), dataDeltaSup_CNO_REMPost{imouse}(:,2), dataDeltaSup_CNO_REMPost{imouse}(:,3), clrs_post, 1); hold on
    s_deep=shadedErrorBar(dataDeltaDeep_CNO_REMPost{imouse}(:,1), dataDeltaDeep_CNO_REMPost{imouse}(:,2), dataDeltaDeep_CNO_REMPost{imouse}(:,3), clrs_post, 1); hold on
    set(s_sup.edge, 'linewidth', 0.1, 'color', 'none');
    set(s_deep.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    set(ax,'xlim',[-.5 .5],'ylim',[-1000 +3000])
    
    s3=s3+1;
end













