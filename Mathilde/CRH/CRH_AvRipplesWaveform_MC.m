%% input dir : excitatory DREADD in VLPO CRH-neurons
% % DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1217 1218 1219 1220]);

% DirCNO = PathForExperimentsAtropine_MC('Atropine');


% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1197 1198 1236 1237 1238]);

% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');

%% input dir : inhi DREADD in PFC
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1198]);
% DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

%% input dir : control mice
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir : atropine experiment
%% DIR ATROPINE
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1107 1245 1247 1248]); %1112
% 
% DirCNO = PathForExperimentsAtropine_MC('Atropine');


DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
DirSaline = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirCNO = RestrictPathForExperiment(DirOpto, 'nMice', [733 1076 1109 1136 1137]);
%% input dir (opto experiment)
% DirSaline=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% DirCNO=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1075 1111 1112]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [733 1076 1109 1136 1137]);

%% get data
% saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero.mat','Wake','REMEpoch','SWSEpoch');
        if exist('SWR.mat')
        A{i}=load('SWR.mat','ripples','tRipples');
    else
        A{i}=load('Ripples.mat','ripples','tRipples');
        end
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,A{i}.tRipples,'wake',0);
    dataRippCtrl_WakePre{i} = T_pre;
    dataRippCtrl_WakePost{i} = T_post;
    stdErrCtrl_WakePre{i} = M_pre(:,4);
    stdErrCtrl_WakePost{i} = M_post(:,4);
    
    %     [M_pre, M_post, T_pre, T_post] = PlotWaveformRipples_MC('wakeLowMov',0);
    %     dataRippCtrl_WakeLowMovPre{i} = T_pre;
    %     dataRippCtrl_WakeLowMovPost{i} = T_post;
    %     stdErrCtrl_WakeLowMovPre{i} = M_pre(:,4);
    %     stdErrCtrl_WakeLowMovPost{i} = M_post(:,4);
    
    
    %     [M_pre, M_post, T_pre, T_post] = PlotWaveformRipples_MC('wakeHighMov',0);
    %     dataRippCtrl_WakeHighMovPre{i} = T_pre;
    %     dataRippCtrl_WakeHighMovPost{i} = T_post;
    %     stdErrCtrl_WakeHighMovPre{i} = M_pre(:,4);
    %     stdErrCtrl_WakeHighMovPost{i} = M_post(:,4);
    
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,A{i}.tRipples,'rem',0);
    dataRippCtrl_REMPre{i} = T_pre;
    dataRippCtrl_REMPost{i} = T_post;
    stdErrCtrl_REMPre{i} = M_pre(:,4);
    stdErrCtrl_REMPost{i} = M_post(:,4);
    
    [M_pre,M_post,M_all, T_pre,T_post,T_all] = PlotWaveformRipples_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,A{i}.tRipples,'sws',0);
    dataRippCtrl_SWSPre{i} = T_pre;
    dataRippCtrl_SWSPost{i} = T_post;
    stdErrCtrl_SWSPre{i} = M_pre(:,4);
    stdErrCtrl_SWSPost{i} = M_post(:,4);
end
% calculate mean saline
for ii=1:length(dataRippCtrl_WakePre)
    % mean pre
    AvDataRippCtrl_WakePre(ii,:)=nanmean(dataRippCtrl_WakePre{ii}(:,:),1);
    %         AvDataRippCtrl_WakeLowMovPre(ii,:)=nanmean(dataRippCtrl_WakeLowMovPre{ii}(:,:),1);
    %         AvDataRippCtrl_WakeHighMovPre(ii,:)=nanmean(dataRippCtrl_WakeHighMovPre{ii}(:,:),1);
    AvDataRippCtrl_REMPre(ii,:)=nanmean(dataRippCtrl_REMPre{ii}(:,:),1);
    AvDataRippCtrl_SWSPre(ii,:)=nanmean(dataRippCtrl_SWSPre{ii}(:,:),1);
    % mean post
    AvDataRippCtrl_WakePost(ii,:)=nanmean(dataRippCtrl_WakePost{ii}(:,:),1);
    %         AvDataRippCtrl_WakeLowMovPost(ii,:)=nanmean(dataRippCtrl_WakeLowMovPost{ii}(:,:),1);
    %         AvDataRippCtrl_WakeHighMovPost(ii,:)=nanmean(dataRippCtrl_WakeHighMovPost{ii}(:,:),1);
    AvDataRippCtrl_REMPost(ii,:)=nanmean(dataRippCtrl_REMPost{ii}(:,:),1);
    AvDataRippCtrl_SWSPost(ii,:)=nanmean(dataRippCtrl_SWSPost{ii}(:,:),1);
    % std pre
    AvStdErrCtrl_WakePre(ii,:)=nanmean(stdErrCtrl_WakePre{ii}(:,:),2);
    %         AvStdErrCtrl_WakeLowMovPre(ii,:)=nanmean(stdErrCtrl_WakeLowMovPre{ii}(:,:),2);
    %         AvStdErrCtrl_WakeHighMovPre(ii,:)=nanmean(stdErrCtrl_WakeHighMovPre{ii}(:,:),2);
    AvStdErrCtrl_REMPre(ii,:)=nanmean(stdErrCtrl_REMPre{ii}(:,:),2);
    AvStdErrCtrl_SWSPre(ii,:)=nanmean(stdErrCtrl_SWSPre{ii}(:,:),2);
    % std post
    AvStdErrCtrl_WakePost(ii,:)=nanmean(stdErrCtrl_WakePost{ii}(:,:),2);
    %         AvStdErrCtrl_WakeLowMovPost(ii,:)=nanmean(stdErrCtrl_WakeLowMovPost{ii}(:,:),2);
    %         AvStdErrCtrl_WakeHighMovPost(ii,:)=nanmean(stdErrCtrl_WakeHighMovPost{ii}(:,:),2);
    AvStdErrCtrl_REMPost(ii,:)=nanmean(stdErrCtrl_REMPost{ii}(:,:),2);
    AvStdErrCtrl_SWSPost(ii,:)=nanmean(stdErrCtrl_SWSPost{ii}(:,:),2);
end

%% CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
        stage_cno{j} = load('SleepScoring_Accelero.mat','Wake','REMEpoch','SWSEpoch');
        if exist('SWR.mat')
        ripp_cno{j}=load('SWR.mat','ripples','tRipples');
        elseif exist('Ripples.mat')
        ripp_cno{j}=load('Ripples.mat','ripples','tRipples');
        else
        ripp_cno{j}=[];
        end
        
        if isempty(ripp_cno{j})==0
    [M_wake_pre_cno,M_wake_post_cno,M_wake_all_cno, T_wake_pre_cno,T_wake_post_cno,T_wake_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'wake',0);
    dataRippCNO_WakePre{j} = T_wake_pre_cno;
    dataRippCNO_WakePost{j} = T_wake_post_cno;
    stdErrCNO_WakePre{j} = M_wake_pre_cno(:,4);
    stdErrCNO_WakePost{j} = M_wake_post_cno(:,4);
    
    %         [M_pre, M_post, T_pre, T_post] = PlotWaveformRipples_MC('wakeLowMov',0);
    %         dataRippCNO_WakeLowMovPre{j} = T_pre;
    %         dataRippCNO_WakeLowMovPost{j} = T_post;
    %         stdErrCNO_WakeLowMovPre{j} = M_pre(:,4);
    %         stdErrCNO_WakeLowMovPost{j} = M_post(:,4);
    %
    %         [M_pre, M_post, T_pre, T_post] = PlotWaveformRipples_MC('wakeHighMov',0);
    %         dataRippCNO_WakeHighMovPre{j} = T_pre;
    %         if isempty(T_post) % in case there is no REM after injection
    %             dataRippCNO_WakeHighMovPost{j}(:,1001) = NaN;
    %         else
    %             dataRippCNO_WakeHighMovPost{j} = T_post;
    %         end
    %         stdErrCNO_WakeHighMovPre{j} = M_pre(:,4);
    %         if isempty(M_post) % in case there is no REM after injection
    %             stdErrCNO_WakeHighMovPost{j} = zeros(1001,4);
    %             stdErrCNO_WakeHighMovPost{j}(:,:) = NaN;
    %         else
    %             stdErrCNO_WakeHighMovPost{j} = M_post(:,4);
    %         end
    
    [M_rem_pre_cno,M_rem_post_cno,M_rem_all_cno, T_rem_pre_cno,T_rem_post_cno,T_rem_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'rem',0);
    dataRippCNO_REMPre{j} = T_rem_pre_cno;
    stdErrCNO_REMPre{j} = M_rem_pre_cno(:,4);

    
%     if isempty(T_rem_post_cno)==0 % in case there is no REM after injection
        dataRippCNO_REMPost{j} = T_rem_post_cno;
%     else
%         dataRippCNO_REMPost{j} = zeros(1,1001);
%         dataRippCNO_REMPost{j}(:,:) = NaN;
%     end
%     
%     if isempty(M_rem_post_cno)==0 % in case there is no REM after injection
        stdErrRippCNO_REMPost{j} = M_rem_post_cno(:,4);
%     else
%                 stdErrRippCNO_REMPost{j} = zeros(1,1001);
%         stdErrRippCNO_REMPost{j}(:,:) = NaN;
%     end

    [M_sws_pre_cno,M_sws_post_cno,M_sws_all_cno, T_sws_pre_cno,T_sws_post_cno,T_sws_all_cno] = PlotWaveformRipples_MC(stage_cno{j}.Wake,stage_cno{j}.SWSEpoch,stage_cno{j}.REMEpoch,ripp_cno{j}.tRipples,'sws',0);
    dataRippCNO_SWSPre{j} = T_sws_pre_cno;
    dataRippCNO_SWSPost{j} = T_sws_post_cno;
    stdErrCNO_SWSPre{j} = M_sws_pre_cno(:,4);
    stdErrCNO_SWSPost{j} = M_sws_post_cno(:,4);
        else
        end
end
%%
% calculate mean
for jj=1:length(dataRippCNO_WakePre)
            if isempty(dataRippCNO_WakePre{jj})==0

    %mean pre
    AvDataRippCNO_WakePre(jj,:)=nanmean(dataRippCNO_WakePre{jj}(:,:),1);
%             AvDataRippCNO_WakeLowMovPre(jj,:)=nanmean(dataRippCNO_WakeLowMovPre{jj}(:,:),1);
%             AvDataRippCNO_WakeHighMovPre(jj,:)=nanmean(dataRippCNO_WakeHighMovPre{jj}(:,:),1);
    AvDataRippCNO_REMPre(jj,:)=nanmean(dataRippCNO_REMPre{jj}(:,:),1);
    AvDataRippCNO_SWSPre(jj,:)=nanmean(dataRippCNO_SWSPre{jj}(:,:),1);
    %mean post
    AvDataRippCNO_WakePost(jj,:)=nanmean(dataRippCNO_WakePost{jj}(:,:),1);
%             AvDataRippCNO_WakeLowMovPost(jj,:)=nanmean(dataRippCNO_WakeLowMovPost{jj}(:,:),1);
%             AvDataRippCNO_WakeHighMovPost(jj,:)=nanmean(dataRippCNO_WakeHighMovPost{jj}(:,:),1);
    AvDataRippCNO_SWSPost(jj,:)=nanmean(dataRippCNO_SWSPost{jj}(:,:),1);
AvDataRippCNO_REMPost(jj,:)=nanmean(dataRippCNO_REMPost{jj}(:,:),1);
    %std pre
    AvStdErrCNO_WakePre(jj,:)=nanmean(stdErrCNO_WakePre{jj}(:,:),2);
%             AvStdErrCNO_WakeLowMovPre(jj,:)=nanmean(stdErrCNO_WakeLowMovPre{jj}(:,:),2);
%             AvStdErrCNO_WakeHighMovPre(jj,:)=nanmean(stdErrCNO_WakeHighMovPre{jj}(:,:),2);
    AvStdErrCNO_REMPre(jj,:)=nanmean(stdErrCNO_REMPre{jj}(:,:),2);
    AvStdErrCNO_SWSPre(jj,:)=nanmean(stdErrCNO_SWSPre{jj}(:,:),2);
    %std post
    AvStdErrCNO_WakePost(jj,:)=nanmean(stdErrCNO_WakePost{jj}(:,:),2);
%             AvStdErrCNO_WakeLowMovPost(jj,:)=nanmean(stdErrCNO_WakeLowMovPost{jj}(:,:),2);
%             AvStdErrCNO_WakeHighMovPost(jj,:)=nanmean(stdErrCNO_WakeHighMovPost{jj}(:,:),2);
    AvStdErrCNO_SWSPost(jj,:)=nanmean(stdErrCNO_SWSPost{jj}(:,:),2);
            else
            end
end


clear jj
for jj=1:length(stdErrRippCNO_REMPost)
    if isempty(stdErrRippCNO_REMPost{jj})==0
        
        AvStdErrCNO_REMPost(jj,:)=nanmean(stdErrRippCNO_REMPost{jj}(:,:),2);
    else
    end
end



%%
clear imouse

col = {}
figure

%%Wkae
subplot(331)
hold on
for imouse=1:length(dataRippCNO_WakePre)
    if isempty(dataRippCNO_WakePre{imouse})==0
        plot(nanmean(dataRippCNO_WakePre{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_WakePre),'color','k','linewidth',2)
% xlim([350 750])

subplot(332)
hold on
for imouse=1:length(dataRippCNO_WakePost)
    if isempty(dataRippCNO_WakePost{imouse})==0
        
        plot(nanmean(dataRippCNO_WakePost{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_WakePost),'color','k','linewidth',2)
% xlim([350 750])

%%SWS
subplot(334)
hold on
for imouse=1:length(dataRippCNO_SWSPre)
    if isempty(dataRippCNO_SWSPre{imouse})==0
        plot(nanmean(dataRippCNO_SWSPre{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_SWSPre),'color','k','linewidth',2)
% xlim([350 750])

subplot(335)
hold on
for imouse=1:length(dataRippCNO_SWSPost)
    if isempty(dataRippCNO_SWSPost{imouse})==0
        
        plot(nanmean(dataRippCNO_SWSPost{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_SWSPost),'color','k','linewidth',2)
% xlim([350 750])

%%REM
subplot(337)
hold on
for imouse=1:length(dataRippCNO_REMPre)
    if isempty(dataRippCNO_REMPre{imouse})==0
        plot(nanmean(dataRippCNO_REMPre{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_REMPre),'color','k','linewidth',2)
% xlim([350 750])

subplot(338)
hold on
for imouse=1:length(dataRippCNO_REMPost)
    if isempty(dataRippCNO_REMPost{imouse})==0
        
        plot(nanmean(dataRippCNO_REMPost{imouse}))
    else
    end
end
plot(nanmedian(AvDataRippCNO_REMPost),'color','k','linewidth',2)
% xlim([350 750])


subplot(333), hold on
plot(nanmedian(AvDataRippCNO_WakePre),'color','k','linestyle',':','linewidth',2)
plot(nanmedian(AvDataRippCNO_WakePost),'color','k','linewidth',2)
% xlim([350 750])

subplot(336), hold on
plot(nanmedian(AvDataRippCNO_SWSPre),'color','k','linestyle',':','linewidth',2)
plot(nanmedian(AvDataRippCNO_SWSPost),'color','k','linewidth',2)
% xlim([350 750])

subplot(339), hold on
plot(nanmedian(AvDataRippCNO_REMPre),'color','k','linestyle',':','linewidth',2)
plot(nanmedian(AvDataRippCNO_REMPost),'color','k','linewidth',2)
% xlim([350 750])

%% OVERVIEW SALINE MICE : average delta waveform for each individual mouse (before and after injection)
%color parameters
clrs_pre = ':k';
clrs_post = 'r';
%subplots parameters (to fit with any number of mice)
s2=length(DirSaline.path);
s3=1;
% s1,3,s3+2
figure
for imouse=1:length(DirSaline.path)
    %WAKE    
    ax(1)= subplot(3,s2,s3), shadedErrorBar(M_pre(:,1),AvDataRippCtrl_WakePre(imouse,:),AvStdErrCtrl_WakePre(imouse,:),clrs_pre,1); hold on
    shadedErrorBar(M_pre(:,1),AvDataRippCtrl_WakePost(imouse,:),AvStdErrCtrl_WakePost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    %NREM
    ax(2)=subplot(3,s2,s3+s2),shadedErrorBar(M_pre(:,1),AvDataRippCtrl_SWSPre(imouse,:),AvStdErrCtrl_SWSPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(M_pre(:,1),AvDataRippCtrl_SWSPost(imouse,:),AvStdErrCtrl_SWSPost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),shadedErrorBar(M_pre(:,1),AvDataRippCtrl_REMPre(imouse,:),AvStdErrCtrl_REMPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(M_pre(:,1),AvDataRippCtrl_REMPost(imouse,:),AvStdErrCtrl_REMPost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    set(ax,'xlim',[-0.05 +0.15],'ylim',[-1000 +3000])
    
    s3=s3+1;
end

%% OVERVIEW CNO MICE : average delta waveform for each individual mouse (before and after injection)
%color parameters
clrs_pre = ':k';
clrs_post = 'g';
%subplots parameters (to fit with any number of mice)
s2=length(DirCNO.path);
s3=1;
% s1,3,s3+2
figure
for imouse=1:length(DirCNO.path)
    %WAKE
    ax(1)= subplot(3,s2,s3), shadedErrorBar(M_pre(:,1),AvDataRippCNO_WakePre(imouse,:),AvStdErrCNO_WakePre(imouse,:),clrs_pre,1); hold on
    shadedErrorBar(M_pre(:,1),AvDataRippCNO_WakePost(imouse,:),AvStdErrCNO_WakePost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    %NREM
    ax(2)=subplot(3,s2,s3+s2),shadedErrorBar(M_pre(:,1),AvDataRippCNO_SWSPre(imouse,:),AvStdErrCNO_SWSPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(M_pre(:,1),AvDataRippCNO_SWSPost(imouse,:),AvStdErrCNO_SWSPost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    
    %REM
    ax(3)=subplot(3,s2,s3+s2*2),shadedErrorBar(M_rem_pre_cno(:,1),AvDataRippCNO_REMPre(imouse,:),AvStdErrCNO_REMPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(M_rem_pre_cno(:,1),AvDataRippCNO_REMPost(imouse,:),AvStdErrCNO_REMPost(imouse,:),clrs_post,1);
    line([0 0], ylim,'color','k','linestyle',':')
    makepretty
    set(ax,'xlim',[-0.2 +0.3],'ylim',[-2000 +3000])
    
    s3=s3+1;
end
%% figure
% %% compare saline & cno
% figure, subplot(321), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakePre),mean(AvStdErrCtrl_WakePre,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakePre),mean(AvStdErrCNO_WakePre,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake pre')
% subplot(322), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakePost),mean(AvStdErrCtrl_WakePost,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakePost),mean(AvStdErrCNO_WakePost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake post')
% subplot(323), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_SWSPre),mean(AvStdErrCtrl_SWSPre,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_SWSPre),mean(AvStdErrCNO_SWSPre,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM pre')
% subplot(324),shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_SWSPost),mean(AvStdErrCtrl_SWSPost,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_SWSPost),mean(AvStdErrCNO_SWSPost,1),'-r',1)
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM post')
% subplot(325), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_REMPre),mean(AvStdErrCtrl_REMPre,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_REMPre),mean(AvStdErrCNO_REMPre,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM pre')
% subplot(326), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_REMPost),mean(AvStdErrCtrl_REMPost,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_REMPost),mean(AvStdErrCNO_REMPost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM post')


% %% compare pre & post
% % wake sal
% figure, 
% subplot(321),
%  shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakePre),mean(AvStdErrCtrl_WakePre,1),':k',1); hold on
%  shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakePost),mean(AvStdErrCtrl_WakePost,1),'-k',1)
%  ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('SALINE')
% ylabel('WAKE')
% makepretty
% % wak cno
% subplot(322),
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakePre),mean(AvStdErrCNO_WakePre,1),':r',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakePost),mean(AvStdErrCNO_WakePost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('CNO')
% makepretty
% % sws sal
% subplot(323),
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_SWSPre),mean(AvStdErrCtrl_SWSPre,1),':k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_SWSPost),mean(AvStdErrCtrl_SWSPost,1),'-k',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% ylabel('NREM')
% makepretty
% % sws cno
% subplot(324),
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_SWSPre),mean(AvStdErrCNO_SWSPre,1),':r',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_SWSPost),mean(AvStdErrCNO_SWSPost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% makepretty
% % rem sal
% subplot(325),
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_REMPre),mean(AvStdErrCtrl_REMPre,1),':k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_REMPost),mean(AvStdErrCtrl_REMPost,1),'-k',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% ylabel('REM')
% xlabel('Time (s)')
% makepretty
% % rem cno
% subplot(326),
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_REMPre),mean(AvStdErrCNO_REMPre,1),':r',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_REMPost),mean(AvStdErrCNO_REMPost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% xlabel('Time (s)')
% makepretty


% %% wake with high / low movement
% figure, subplot(221), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakeLowMovPre),mean(AvStdErrCtrl_WakeLowMovPre,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakeLowMovPre),mean(AvStdErrCNO_WakeLowMovPre,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake low mov pre injection')
% 
% subplot(222), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakeLowMovPost),mean(AvStdErrCtrl_WakeLowMovPost,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakeLowMovPost),mean(AvStdErrCNO_WakeLowMovPost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake low mov post injection')
% 
% subplot(223), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakeHighMovPre),mean(AvStdErrCtrl_WakeHighMovPre,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakeHighMovPre),mean(AvStdErrCNO_WakeHighMovPre,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake high mov pre injection')
% 
% subplot(224), shadedErrorBar(M_pre(:,1),mean(AvDataRippCtrl_WakeHighMovPost),mean(AvStdErrCtrl_WakeHighMovPost,1),'-k',1); hold on
% shadedErrorBar(M_pre(:,1),mean(AvDataRippCNO_WakeHighMovPost),mean(AvStdErrCNO_WakeHighMovPost,1),'-r',1);
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake high mov post injection')


%% figure for single mouse

% figure, subplot(321), plot(M_pre(:,1),AvDataRippCtrl_WakePre(imouse,:),'-k'); hold on
% plot(M_pre(:,1),AvDataRippCNO_WakePre(imouse,:),'-r');
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake pre')
% 
% subplot(322), plot(M_pre(:,1),AvDataRippCtrl_WakePost(imouse,:),'-k'); hold on
% plot(M_pre(:,1),AvDataRippCNO_WakePost(imouse,:),'-r');
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('wake post')
% 
% subplot(323), plot(M_pre(:,1),AvDataRippCtrl_SWSPre(imouse,:),'-k'); hold on
% plot(M_pre(:,1),AvDataRippCNO_SWSPre(imouse,:),'-r');
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM pre')
% 
% subplot(324),plot(M_pre(:,1),AvDataRippCtrl_SWSPost(imouse,:),'-k'); hold on
% plot(M_pre(:,1), AvDataRippCNO_SWSPost(imouse,:),'-r')
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('NREM post')
% 
% subplot(325), plot(M_pre(:,1),AvDataRippCtrl_REMPre(imouse,:),'-k'); hold on
% plot(M_pre(:,1), AvDataRippCNO_REMPre(imouse,:),'-r');
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM pre')
% 
% subplot(326), plot(M_pre(:,1),AvDataRippCtrl_REMPost(imouse,:),'-k'); hold on
% plot(M_pre(:,1),AvDataRippCNO_REMPost(imouse,:),'-r');
% ylim([-1000 2000])
% xlim([-0.05 0.2])
% line([0 0], ylim,'color','k','linestyle',':')
% title('REM post')


%%


figure
subplot(321), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_WakePre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_WakePre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_WakePre, {@nanmedian, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_WakePre, {@nanmedian, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
ylabel('WAKE')
title('pre')
makepretty
subplot(322), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_WakePost, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_WakePost, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_WakePost, {@nanmedian, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_WakePost, {@nanmedian, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
title('post')
makepretty
subplot(323), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_SWSPre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_SWSPre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_SWSPre, {@nanmedian, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_SWSPre, {@nanmedian, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
ylabel('NREM')
makepretty
subplot(324), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_SWSPost, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_SWSPost, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_SWSPost, {@nanmedian, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_SWSPost, {@nanmedian, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
makepretty
subplot(325), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_REMPre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_REMPre, {@nanmedian, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_REMPre, {@nanmedian, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_REMPre, {@nanmedian, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
ylabel('REM')
makepretty
subplot(326), hold on
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_REMPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCtrl_REMPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_REMPost, {@nanmean, @stdError},'g',1)
shadedErrorBar(M_pre(:,1)', AvDataRippCNO_REMPost, {@nanmean, @stdError},'g',1)
xlim([-0.1 0.25])
ylim([-2000 3000])
makepretty