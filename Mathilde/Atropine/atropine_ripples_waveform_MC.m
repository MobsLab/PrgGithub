%% input dir : atropine experiment
%% DIR ATROPINE
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112

DirCNO = PathForExperimentsAtropine_MC('Atropine');


%% get data
% saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    stage_sal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','SmoothTheta','Info');
    gamma_sal{i} = load('SleepScoring_OBGamma', 'SmoothGamma', 'Info');
    
    if exist('SWR.mat')
        A{i}=load('SWR.mat','ripples','tRipples');
    else
        A{i}=load('Ripples.mat','ripples','tRipples');
    end

    
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(stage_sal{i}.Wake,stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,A{i}.tRipples,'wake',0);
    dataRippCtrl_WakePre{i} = M_pre;
    if isempty(dataRippCtrl_WakePre{i})==1
        dataRippCtrl_WakePre{i}(1001,4) = NaN;
    else
    end
    
    dataRippCtrl_WakePost{i} = M_post;
    if isempty(dataRippCtrl_WakePost{i})==1
        dataRippCtrl_WakePost{i}(1001,4) = NaN;
    else
    end
    
    
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(stage_sal{i}.Wake,stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,A{i}.tRipples,'rem',0);
    dataRippCtrl_REMPre{i} = M_pre;
    if isempty(dataRippCtrl_REMPre{i})==1
        dataRippCtrl_REMPre{i}(1001,4) = NaN;
    else
    end
    
    
    dataRippCtrl_REMPost{i} = M_post;
    if isempty(dataRippCtrl_REMPost{i})==1
        dataRippCtrl_REMPost{i}(1001,4) = NaN;
    else
    end
    
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(stage_sal{i}.Wake,stage_sal{i}.SWSEpoch,stage_sal{i}.REMEpoch,A{i}.tRipples,'sws',0);
    dataRippCtrl_SWSPre{i} = M_pre;
    if isempty(dataRippCtrl_SWSPre{i})==1
        dataRippCtrl_SWSPre{i}(1001,4) = NaN;
    else
    end
    
    dataRippCtrl_SWSPost{i} = M_post;
    if isempty(dataRippCtrl_SWSPost{i})==1
        dataRippCtrl_SWSPost{i}(1001,4) = NaN;
    else
    end
    
end





%% CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    stage_cno{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','ThetaEpoch','SmoothTheta','Info');
    gamma_cno{j} = load('SleepScoring_OBGamma', 'SmoothGamma', 'Info');
    
    if exist('SWR.mat')
        ripp_cno{j}=load('SWR.mat','ripples','tRipples');
    elseif exist('Ripples.mat')
        ripp_cno{j}=load('Ripples.mat','ripples','tRipples');
    else
        ripp_cno{j}=[];
    end

    if isempty(ripp_cno{j})==0
        [M_wake_pre_cno,M_wake_post_cno,M_wake_all_cno, T_wake_pre_cno,T_wake_post_cno,T_wake_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'wake',0);
        dataRippCNO_WakePre{j} = M_wake_pre_cno;
        if isempty(dataRippCNO_WakePre{j})==1
            dataRippCNO_WakePre{j}(1001,4) = NaN;
        else
        end
        
        dataRippCNO_WakePost{j} = M_wake_post_cno;
        if isempty(dataRippCNO_WakePost{j})==1
            dataRippCNO_WakePost{j}(1001,4) = NaN;
        else
        end
     
        
        [M_rem_pre_cno,M_rem_post_cno,M_rem_all_cno, T_rem_pre_cno,T_rem_post_cno,T_rem_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'rem',0);
        dataRippCNO_REMPre{j} = M_rem_pre_cno;
        if isempty(dataRippCNO_REMPre{j})==1
            dataRippCNO_REMPre{j}(1001,4) = NaN;
        else
        end
        
        dataRippCNO_REMPost{j} = M_rem_post_cno;
        if isempty(dataRippCNO_REMPost{j})==1
            dataRippCNO_REMPost{j}(1001,4) = NaN;
        else
        end
        
        
        [M_sws_pre_cno,M_sws_post_cno,M_sws_all_cno, T_sws_pre_cno,T_sws_post_cno,T_sws_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,...
            stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'sws',0);
        dataRippCNO_SWSPre{j} = M_sws_pre_cno;
        if isempty(dataRippCNO_SWSPre{j})==1
            dataRippCNO_SWSPre{j}(1001,4) = NaN;
        else
        end
        
        dataRippCNO_SWSPost{j} = M_sws_post_cno;
        if isempty(dataRippCNO_SWSPost{j})==1
            dataRippCNO_SWSPost{j}(1001,4) = NaN;
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
    s=shadedErrorBar(dataRippCtrl_WakePre{imouse}(:,1), dataRippCtrl_WakePre{imouse}(:,2), dataRippCtrl_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCtrl_WakePost{imouse}(:,1), dataRippCtrl_WakePost{imouse}(:,2), dataRippCtrl_WakePost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %NREM
    ax(2)=subplot(3,s2,s3+s2),
    s=shadedErrorBar(dataRippCtrl_SWSPre{imouse}(:,1), dataRippCtrl_SWSPre{imouse}(:,2), dataRippCtrl_SWSPre{imouse}(:,3), clrs_pre, 1);hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCtrl_SWSPost{imouse}(:,1), dataRippCtrl_SWSPost{imouse}(:,2), dataRippCtrl_SWSPost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),
    s=shadedErrorBar(dataRippCtrl_REMPre{imouse}(:,1), dataRippCtrl_REMPre{imouse}(:,2), dataRippCtrl_REMPre{imouse}(:,3), clrs_pre, 1);hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCtrl_REMPost{imouse}(:,1), dataRippCtrl_REMPost{imouse}(:,2), dataRippCtrl_REMPost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    set(ax,'xlim',[-0.05 +0.15],'ylim',[-1000 +3000])
    
    s3=s3+1;
end

%%

clrs_pre = ':k';
clrs_post = 'g';

s2=length(DirCNO.path);
s3=1;

figure
for imouse=1:length(DirCNO.path)
    %WAKE
    ax(1)= subplot(3,s2,s3),
    s=shadedErrorBar(dataRippCNO_WakePre{imouse}(:,1), dataRippCNO_WakePre{imouse}(:,2), dataRippCNO_WakePre{imouse}(:,3), clrs_pre, 1); hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCNO_WakePost{imouse}(:,1), dataRippCNO_WakePost{imouse}(:,2), dataRippCNO_WakePost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %NREM
    ax(2)=subplot(3,s2,s3+s2),
    s=shadedErrorBar(dataRippCNO_SWSPre{imouse}(:,1), dataRippCNO_SWSPre{imouse}(:,2), dataRippCNO_SWSPre{imouse}(:,3), clrs_pre, 1);hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCNO_SWSPost{imouse}(:,1), dataRippCNO_SWSPost{imouse}(:,2), dataRippCNO_SWSPost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),
    s=shadedErrorBar(dataRippCNO_REMPre{imouse}(:,1), dataRippCNO_REMPre{imouse}(:,2), dataRippCNO_REMPre{imouse}(:,3), clrs_pre, 1);hold on
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    s=shadedErrorBar(dataRippCNO_REMPost{imouse}(:,1), dataRippCNO_REMPost{imouse}(:,2), dataRippCNO_REMPost{imouse}(:,3), clrs_post, 1);
    set(s.edge, 'linewidth', 0.1, 'color', 'none');
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    set(ax,'xlim',[-0.05 +0.15],'ylim',[-1000 +3000])
    
    s3=s3+1;
end















