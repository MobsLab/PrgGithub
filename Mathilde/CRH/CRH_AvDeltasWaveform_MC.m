% %% input dir : excitatory DREADD in VLPO CRH-neurons
% % DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1148 1149 1150]);
% % DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1217 1218 1219 1220]);

% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1197 1198 1235 1236 1238]);%1196

%% input dir : inhi DREADD in PFC
% % %baseline sleep
% % DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% %cno
% % DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

% %saline
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);


% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% % DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% 
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% 
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% 
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
% DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1196 1197 1198 1105 1106 1148 1149 1150 1217  1218 1219 1220 1245 1247 1248]); %


%% input dir : control mice
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir : atropine experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);
DirSaline = RestrictPathForExperiment(DirSaline,'nMice',[1105 1106 1245 1247 1248 1112]); %1107

DirCNO = PathForExperimentsAtropine_MC('Atropine');


%% input dir (opto experiment)
% DirSaline=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% DirCNO=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1075 1111 1112]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [733 1076 1109 1136 1137]);

%% get data
% saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    %%load sleep scoring
    a{i}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    %%load deltas
    if exist('DeltaWaves.mat')
        delt_sal{i}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_sal{i} = [];
    end
    
    if isempty(delt_sal{i})==0
        %WAKE
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,delt_sal{i}.alldeltas_PFCx,'wake');
        dataDeltaDeep_Ctrl_WakePre{i} = Tdeep_pre;
        dataDeltaSup_Ctrl_WakePre{i} = Tsup_pre;
        dataDeltaDeep_Ctrl_WakePost{i} = Tdeep_post;
        dataDeltaSup_Ctrl_WakePost{i} = Tsup_post;
        %%REM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,delt_sal{i}.alldeltas_PFCx,'rem');
        dataDeltaDeep_Ctrl_REMPre{i} = Tdeep_pre;
        dataDeltaSup_Ctrl_REMPre{i} = Tsup_pre;
        dataDeltaDeep_Ctrl_REMPost{i} = Tdeep_post;
        dataDeltaSup_Ctrl_REMPost{i} = Tsup_post;
        %%NREM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,delt_sal{i}.alldeltas_PFCx,'sws');
        dataDeltaDeep_Ctrl_SWSPre{i} = Tdeep_pre;
        dataDeltaSup_Ctrl_SWSPre{i} = Tsup_pre;
        dataDeltaDeep_Ctrl_SWSPost{i} = Tdeep_post;
        dataDeltaSup_Ctrl_SWSPost{i} = Tsup_post;
    else
    end
end

%% calculate mean
for ii=1:length(dataDeltaDeep_Ctrl_WakePre)
    %%Wake pre
    if size(dataDeltaDeep_Ctrl_WakePre{ii},2)==1
        AvData_DeltaDeepCtrl_WakePre(ii,:)=dataDeltaDeep_Ctrl_WakePre{ii}';
        AvData_DeltaSupCtrl_WakePre(ii,:)=dataDeltaSup_Ctrl_WakePre{ii}';
    else
        AvData_DeltaDeepCtrl_WakePre(ii,:)=nanmean(dataDeltaDeep_Ctrl_WakePre{ii},1);AvData_DeltaDeepCtrl_WakePre(AvData_DeltaDeepCtrl_WakePre==0)=NaN;
        AvData_DeltaSupCtrl_WakePre(ii,:)=nanmean(dataDeltaSup_Ctrl_WakePre{ii},1);AvData_DeltaSupCtrl_WakePre(AvData_DeltaSupCtrl_WakePre==0)=NaN;
    end
    
    %%NREM pre
    AvData_DeltaDeepCtrl_SWSPre(ii,:)=nanmean(dataDeltaDeep_Ctrl_SWSPre{ii}(:,:),1);
    AvData_DeltaSupCtrl_SWSPre(ii,:)=nanmean(dataDeltaSup_Ctrl_SWSPre{ii}(:,:),1);
    
    %%REM pre
    if size(dataDeltaDeep_Ctrl_REMPre{ii},2)==1
        AvData_DeltaDeepCtrl_REMPre(ii,:)=dataDeltaDeep_Ctrl_REMPre{ii}';
        AvData_DeltaSupCtrl_REMPre(ii,:)=dataDeltaSup_Ctrl_REMPre{ii}';
    else
        AvData_DeltaDeepCtrl_REMPre(ii,:)=nanmean(dataDeltaDeep_Ctrl_REMPre{ii},1);AvData_DeltaDeepCtrl_REMPre(AvData_DeltaDeepCtrl_REMPre==0)=NaN;
        AvData_DeltaSupCtrl_REMPre(ii,:)=nanmean(dataDeltaSup_Ctrl_REMPre{ii},1);AvData_DeltaSupCtrl_REMPre(AvData_DeltaSupCtrl_REMPre==0)=NaN;
    end
    
    
    %%Wake Post
    if size(dataDeltaDeep_Ctrl_WakePost{ii},2)==1
        AvData_DeltaDeepCtrl_WakePost(ii,:)=dataDeltaDeep_Ctrl_WakePost{ii}';
        AvData_DeltaSupCtrl_WakePost(ii,:)=dataDeltaSup_Ctrl_WakePost{ii}';
    else
        AvData_DeltaDeepCtrl_WakePost(ii,:)=nanmean(dataDeltaDeep_Ctrl_WakePost{ii},1);AvData_DeltaDeepCtrl_WakePost(AvData_DeltaDeepCtrl_WakePost==0)=NaN;
        AvData_DeltaSupCtrl_WakePost(ii,:)=nanmean(dataDeltaSup_Ctrl_WakePost{ii},1);AvData_DeltaSupCtrl_WakePost(AvData_DeltaSupCtrl_WakePost==0)=NaN;
    end
    
    %%NREM post
    AvData_DeltaDeepCtrl_SWSPost(ii,:)=nanmean(dataDeltaDeep_Ctrl_SWSPost{ii}(:,:),1);
    AvData_DeltaSupCtrl_SWSPost(ii,:)=nanmean(dataDeltaSup_Ctrl_SWSPost{ii}(:,:),1);
    
    %%REM post
    if size(dataDeltaDeep_Ctrl_REMPost{ii},2)==1
        AvData_DeltaDeepCtrl_REMPost(ii,:)=dataDeltaDeep_Ctrl_REMPost{ii}';
        AvData_DeltaSupCtrl_REMPost(ii,:)=dataDeltaSup_Ctrl_REMPost{ii}';
    else
        AvData_DeltaDeepCtrl_REMPost(ii,:)=nanmean(dataDeltaDeep_Ctrl_REMPost{ii},1);AvData_DeltaDeepCtrl_REMPost(AvData_DeltaDeepCtrl_REMPost==0)=NaN;
        AvData_DeltaSupCtrl_REMPost(ii,:)=nanmean(dataDeltaSup_Ctrl_REMPost{ii},1);AvData_DeltaSupCtrl_REMPost(AvData_DeltaSupCtrl_REMPost==0)=NaN;
    end
end


%% get data CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    %%load sleep scoring
    %     if exist('SleepScoring_Accelero.mat')
    b{j}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    %     else
    %         b{j}=load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch');
    %     end
    %%load deltas
    if exist('DeltaWaves.mat')
        delt_cno{j}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_cno{j} = [];
    end
    
    if isempty(delt_cno{j})==0
        %%WAKE
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,delt_cno{j}.alldeltas_PFCx,'wake');
        dataDeltaDeep_CNO_WakePre{j} = Tdeep_pre;
        dataDeltaSup_CNO_WakePre{j} = Tsup_pre;
        dataDeltaDeep_CNO_WakePost{j} = Tdeep_post;
        dataDeltaSup_CNO_WakePost{j} = Tsup_post;
        %%REM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,delt_cno{j}.alldeltas_PFCx,'rem');
        dataDeltaDeep_CNO_REMPre{j} = Tdeep_pre;
        dataDeltaSup_CNO_REMPre{j} = Tsup_pre;
        dataDeltaDeep_CNO_REMPost{j} = Tdeep_post;
        dataDeltaSup_CNO_REMPost{j} = Tsup_post;
        %%NREM
        [Mdeep_pre,Mdeep_post,Mdeep_all,Msup_pre,Msup_post,Msup_all,Tdeep_pre,Tdeep_post,Tdeep_all,Tsup_pre,Tsup_post,Tsup_all] = PlotWaveformDeltas_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,delt_cno{j}.alldeltas_PFCx,'sws');
        dataDeltaDeep_CNO_SWSPre{j} = Tdeep_pre;
        dataDeltaSup_CNO_SWSPre{j} = Tsup_pre;
        dataDeltaDeep_CNO_SWSPost{j} = Tdeep_post;
        dataDeltaSup_CNO_SWSPost{j} = Tsup_post;
    else
    end
end


%% calculate mean
for ii=1:length(dataDeltaDeep_CNO_WakePre)
    %%Wake pre
    if size(dataDeltaDeep_CNO_WakePre{ii},2)==1
        AvData_DeltaDeepCNO_WakePre(ii,:)=dataDeltaDeep_CNO_WakePre{ii}';
        AvData_DeltaSupCNO_WakePre(ii,:)=dataDeltaSup_CNO_WakePre{ii}';
    else
        AvData_DeltaDeepCNO_WakePre(ii,:)=nanmean(dataDeltaDeep_CNO_WakePre{ii},1);AvData_DeltaDeepCNO_WakePre(AvData_DeltaDeepCNO_WakePre==0)=NaN;
        AvData_DeltaSupCNO_WakePre(ii,:)=nanmean(dataDeltaSup_CNO_WakePre{ii},1);AvData_DeltaSupCNO_WakePre(AvData_DeltaSupCNO_WakePre==0)=NaN;
    end
    
    %%NREM pre
    AvData_DeltaDeepCNO_SWSPre(ii,:)=nanmean(dataDeltaDeep_CNO_SWSPre{ii}(:,:),1);
    AvData_DeltaSupCNO_SWSPre(ii,:)=nanmean(dataDeltaSup_CNO_SWSPre{ii}(:,:),1);
    
    %%REM pre
    if size(dataDeltaDeep_CNO_REMPre{ii},2)==1
        AvData_DeltaDeepCNO_REMPre(ii,:)=dataDeltaDeep_CNO_REMPre{ii}';
        AvData_DeltaSupCNO_REMPre(ii,:)=dataDeltaSup_CNO_REMPre{ii}';
    else
        AvData_DeltaDeepCNO_REMPre(ii,:)=nanmean(dataDeltaDeep_CNO_REMPre{ii},1);AvData_DeltaDeepCNO_REMPre(AvData_DeltaDeepCNO_REMPre==0)=NaN;
        AvData_DeltaSupCNO_REMPre(ii,:)=nanmean(dataDeltaSup_CNO_REMPre{ii},1);AvData_DeltaSupCNO_REMPre(AvData_DeltaSupCNO_REMPre==0)=NaN;
    end
    
    
    %%Wake Post
    if size(dataDeltaDeep_CNO_WakePost{ii},2)==1
        AvData_DeltaDeepCNO_WakePost(ii,:)=dataDeltaDeep_CNO_WakePost{ii}';
        AvData_DeltaSupCNO_WakePost(ii,:)=dataDeltaSup_CNO_WakePost{ii}';
    else
        AvData_DeltaDeepCNO_WakePost(ii,:)=nanmean(dataDeltaDeep_CNO_WakePost{ii},1);AvData_DeltaDeepCNO_WakePost(AvData_DeltaDeepCNO_WakePost==0)=NaN;
        AvData_DeltaSupCNO_WakePost(ii,:)=nanmean(dataDeltaSup_CNO_WakePost{ii},1);AvData_DeltaSupCNO_WakePost(AvData_DeltaSupCNO_WakePost==0)=NaN;
    end
    
    %%NREM post
    AvData_DeltaDeepCNO_SWSPost(ii,:)=nanmean(dataDeltaDeep_CNO_SWSPost{ii}(:,:),1);
    AvData_DeltaSupCNO_SWSPost(ii,:)=nanmean(dataDeltaSup_CNO_SWSPost{ii}(:,:),1);
    
    %%REM post
    if size(dataDeltaDeep_CNO_REMPost{ii},2)==1
        AvData_DeltaDeepCNO_REMPost(ii,:)=dataDeltaDeep_CNO_REMPost{ii}';
        AvData_DeltaSupCNO_REMPost(ii,:)=dataDeltaSup_CNO_REMPost{ii}';
    else
        AvData_DeltaDeepCNO_REMPost(ii,:)=nanmean(dataDeltaDeep_CNO_REMPost{ii},1);AvData_DeltaDeepCNO_REMPost(AvData_DeltaDeepCNO_REMPost==0)=NaN;
        AvData_DeltaSupCNO_REMPost(ii,:)=nanmean(dataDeltaSup_CNO_REMPost{ii},1);AvData_DeltaSupCNO_REMPost(AvData_DeltaSupCNO_REMPost==0)=NaN;
    end
end


%%
col = {[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560],[0.4660 0.6740 0.1880], [0.3010 0.7450 0.9330], [0.6350 0.0780 0.1840]}
% col = {[0 0.4470 0.7410],[0.8500 0.3250 0.0980],[0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560]}

figure
subplot(334)
hold on
for imouse=1:length(DirCNO.path)
    plot(nanmean(dataDeltaDeep_CNO_SWSPre{imouse}),'color',col{imouse})
    plot(nanmean(dataDeltaSup_CNO_SWSPre{imouse}),'color',col{imouse})
end
% plot(nanmean(AvData_DeltaDeepCNO_SWSPre),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_SWSPre),'color','k','linewidth',3)

subplot(335)
hold on
for imouse=1:length(DirCNO.path)
    plot(nanmean(dataDeltaDeep_CNO_SWSPost{imouse}),'color',col{imouse})
    plot(nanmean(dataDeltaSup_CNO_SWSPost{imouse}),'color',col{imouse})
end

% plot(nanmean(AvData_DeltaDeepCNO_SWSPost),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_SWSPost),'color','k','linewidth',3)

subplot(331)
hold on
for imouse=1:length(DirCNO.path)
    if size(dataDeltaDeep_CNO_WakePre{imouse})>1
        plot(nanmean(dataDeltaDeep_CNO_WakePre{imouse}),'color',col{imouse})
        plot(nanmean(dataDeltaSup_CNO_WakePre{imouse}),'color',col{imouse})
    else
        plot(dataDeltaDeep_CNO_WakePre{imouse},'color',col{imouse})
        plot(dataDeltaSup_CNO_WakePre{imouse},'color',col{imouse})
    end
end% plot(nanmean(AvData_DeltaDeepCNO_WakePre),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_WakePre),'color','k','linewidth',3)

subplot(332)
hold on

for imouse=1:length(DirCNO.path)
    if size(dataDeltaDeep_CNO_WakePost{imouse})>1
        plot(nanmean(dataDeltaDeep_CNO_WakePost{imouse}),'color',col{imouse})
        plot(nanmean(dataDeltaSup_CNO_WakePost{imouse}),'color',col{imouse})
    else
        plot(dataDeltaDeep_CNO_WakePost{imouse},'color',col{imouse})
        plot(dataDeltaSup_CNO_WakePost{imouse},'color',col{imouse})
    end
end
% plot(nanmean(AvData_DeltaDeepCNO_WakePost),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_WakePost),'color','k','linewidth',3)


subplot(337)
hold on
for imouse=1:length(DirCNO.path)
    if size(dataDeltaDeep_CNO_REMPre{imouse})>1
        plot(nanmean(dataDeltaDeep_CNO_REMPre{imouse}),'color',col{imouse})
        plot(nanmean(dataDeltaSup_CNO_REMPre{imouse}),'color',col{imouse})
    else
        plot(dataDeltaDeep_CNO_REMPre{imouse},'color',col{imouse})
        plot(dataDeltaSup_CNO_REMPre{imouse},'color',col{imouse})
    end
end
% plot(nanmean(AvData_DeltaDeepCNO_REMPre),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_REMPre),'color','k','linewidth',3)

subplot(338)
hold on
for imouse=1:length(DirCNO.path)
    if size(dataDeltaDeep_CNO_REMPost{imouse})>1
        plot(nanmean(dataDeltaDeep_CNO_REMPost{imouse}),'color',col{imouse})
        plot(nanmean(dataDeltaSup_CNO_REMPost{imouse}),'color',col{imouse})
    else
        plot(dataDeltaDeep_CNO_REMPost{imouse},'color',col{imouse})
        plot(dataDeltaSup_CNO_REMPost{imouse},'color',col{imouse})
    end
end

% plot(nanmean(AvData_DeltaDeepCNO_REMPost),'color','k','linewidth',3)
% plot(nanmean(AvData_DeltaSupCNO_REMPost),'color','k','linewidth',3)


subplot(333), hold on
plot(nanmean(AvData_DeltaDeepCNO_WakePre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_WakePre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaDeepCNO_WakePost),'color','k','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_WakePost),'color','k','linewidth',3)

subplot(336), hold on
plot(nanmean(AvData_DeltaDeepCNO_SWSPre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_SWSPre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaDeepCNO_SWSPost),'color','k','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_SWSPost),'color','k','linewidth',3)

subplot(339), hold on
plot(nanmean(AvData_DeltaDeepCNO_REMPre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_REMPre),'color','k','linestyle',':','linewidth',3)
plot(nanmean(AvData_DeltaDeepCNO_REMPost),'color','k','linewidth',3)
plot(nanmean(AvData_DeltaSupCNO_REMPost),'color','k','linewidth',3)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%



figure
subplot(321), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_WakePre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_WakePre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_WakePre, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_WakePre, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty
subplot(322), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_WakePost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_WakePost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_WakePost, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_WakePost, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty
subplot(323), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_SWSPre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_SWSPre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_SWSPre, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_SWSPre, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty
subplot(324), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_SWSPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_SWSPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_SWSPost, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_SWSPost, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty
subplot(325), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_REMPre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_REMPre, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_REMPre, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_REMPre, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty
subplot(326), hold on
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCtrl_REMPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCtrl_REMPost, {@nanmean, @stdError},'k',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaDeepCNO_REMPost, {@nanmean, @stdError},'g',1)
shadedErrorBar(Mdeep_pre(:,1)', AvData_DeltaSupCNO_REMPost, {@nanmean, @stdError},'g',1)
xlim([-0.2 0.3])
ylim([-2000 3000])
makepretty

%% OVERVIEW SALINE MICE : average delta waveform for each individual mouse (before and after injection)
%color parameters
clrs_pre = [1 1 1];
clrs_post = [1 0 0];
%subplots parameters (to fit with any number of mice)
s2=length(DirSaline.path);
s3=1;

figure
for imouse=1:length(DirSaline.path)
    ax(1)= subplot(3,s2,s3),
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_WakePre(imouse,:),AvStdErr_DeltaDeepCtrl_WakePre(imouse,:),clrs_pre,1); hold on
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_WakePre(imouse,:),AvStdErr_DeltaSupCtrl_WakePre(imouse,:),clrs_pre,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_WakePost(imouse,:),AvStdErr_DeltaDeepCtrl_WakePost(imouse,:),clrs_post,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_WakePost(imouse,:),AvStdErr_DeltaSupCtrl_WakePost(imouse,:),clrs_post,1);
    makepretty
    ax(2)=subplot(3,s2,s3+s2),shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_SWSPre(imouse,:),AvStdErr_DeltaDeepCtrl_SWSPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_SWSPre(imouse,:),AvStdErr_DeltaSupCtrl_SWSPre(imouse,:),clrs_pre,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_SWSPost(imouse,:),AvStdErr_DeltaDeepCtrl_SWSPost(imouse,:),clrs_post,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_SWSPost(imouse,:),AvStdErr_DeltaSupCtrl_SWSPost(imouse,:),clrs_post,1);
    makepretty
    ax(3)=subplot(3,s2,s3+s2*2),shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_REMPre(imouse,:),AvStdErr_DeltaDeepCtrl_REMPre(imouse,:),clrs_pre,1);hold on
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_REMPre(imouse,:),AvStdErr_DeltaSupCtrl_REMPre(imouse,:),clrs_pre,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_REMPost(imouse,:),AvStdErr_DeltaDeepCtrl_REMPost(imouse,:),clrs_post,1);
    shadedErrorBar(Mdeep_pre(:,1),AvData_DeltaSupCtrl_REMPost(imouse,:),AvStdErr_DeltaSupCtrl_REMPost(imouse,:),clrs_post,1);
    makepretty
    set(ax,'xlim',[-0.2 +0.3],'ylim',[-2000 +3000])
    
    s3=s3+1;
end

figure
for imouse=1:length(DirSaline.path)
    ax(1)= subplot(3,s2,s3),
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_WakePre(imouse,:),clrs_pre,1); hold on
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_WakePre(imouse,:),clrs_pre,1);
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_WakePost(imouse,:),clrs_post,1);
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_WakePost(imouse,:),clrs_post,1);
    makepretty
    ax(2)=subplot(3,s2,s3+s2),
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_SWSPre(imouse,:),clrs_pre,1);hold on
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_SWSPre(imouse,:),clrs_pre,1);
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_SWSPost(imouse,:),clrs_post,1);
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_SWSPost(imouse,:),clrs_post,1);
    makepretty
    ax(3)=subplot(3,s2,s3+s2*2),
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_REMPre(imouse,:),clrs_pre,1);hold on
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_REMPre(imouse,:),clrs_pre,1);
    plot(Mdeep_pre(:,1),AvData_DeltaDeepCtrl_REMPost(imouse,:),clrs_post,1);
    plot(Mdeep_pre(:,1),AvData_DeltaSupCtrl_REMPost(imouse,:),clrs_post,1);
    makepretty
    set(ax,'xlim',[-0.2 +0.3],'ylim',[-2000 +3000])
    
    s3=s3+1;
end

%% OVERVIEW SALINE MICE : average delta waveform for each individual mouse (before and after injection)
%colors parameters
clrs_pre = ':k';
clrs_post = 'r';
%subplots parameters (to fit with any number of mice)
s2=length(DirCNO.path);
s3=1;

figure
for imouse=1:length(DirCNO.path)
    %WAKE
    if isempty(AvData_DeltaDeepCNO_WakePre)==0
        ax(1)= subplot(3,s2,s3),
        shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_WakePre(imouse,:),nanstd(AvData_DeltaDeepCNO_WakePre),clrs_pre,1); hold on
        shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_WakePre(imouse,:),nanstd(AvData_DeltaSupCNO_WakePre),clrs_pre,1);
        shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_WakePost(imouse,:),nanstd(AvData_DeltaDeepCNO_WakePost),clrs_post,1);
        shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_WakePost(imouse,:),nanstd(AvData_DeltaSupCNO_WakePost),clrs_post,1);
        makepretty
    else
    end
    
    %NREM
    ax(2)=subplot(3,s2,s3+s2),
    shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_SWSPre(imouse,:),nanstd(AvData_DeltaDeepCNO_SWSPre),clrs_pre,1); hold on
    shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_SWSPre(imouse,:),nanstd(AvData_DeltaSupCNO_SWSPre),clrs_pre,1);
    shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_SWSPost(imouse,:),nanstd(AvData_DeltaDeepCNO_SWSPost),clrs_post,1);
    shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_SWSPost(imouse,:),nanstd(AvData_DeltaSupCNO_SWSPost),clrs_post,1);
    makepretty
    
    %REM
    if isempty(AvData_DeltaDeepCNO_REMPost)==0
        if isempty(AvData_DeltaSupCNO_REMPost)==0
            ax(3)=subplot(3,s2,s3+s2*2),
            shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_REMPre(imouse,:),nanstd(AvData_DeltaDeepCNO_REMPre),clrs_pre,1); hold on
            shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_REMPre(imouse,:),nanstd(AvData_DeltaSupCNO_REMPre),clrs_pre,1);
            shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaDeepCNO_REMPost(imouse,:),nanstd(AvData_DeltaDeepCNO_REMPost),clrs_post,1);
            shadedErrorBar(Mdeep_pre(:,1)',AvData_DeltaSupCNO_REMPost(imouse,:),nanstd(AvData_DeltaSupCNO_REMPost),clrs_post,1);
        else
        end
    else
    end
    makepretty
    %     set(ax,'xlim',[-0.2 +0.3],'ylim',[-2000 +3000])
    s3=s3+1;
end



%% figures
% %% AVERAGE : compare saline & cno
% %wake pre
% figure
% subplot(321)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_WakePre),nanmean(AvStdErr_DeltaDeepCNO_WakePre,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_WakePre),nanmean(AvStdErr_DeltaSupCNO_WakePre,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_WakePre),nanmean(AvStdErr_DeltaDeepCtrl_WakePre,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_WakePre),nanmean(AvStdErr_DeltaSupCtrl_WakePre,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('WAKE pre')
% % wake post
% subplot(322)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_WakePost),nanmean(AvStdErr_DeltaDeepCNO_WakePost,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_WakePost),nanmean(AvStdErr_DeltaSupCNO_WakePost,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_WakePost),nanmean(AvStdErr_DeltaDeepCtrl_WakePost,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_WakePost),nanmean(AvStdErr_DeltaSupCtrl_WakePost,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('WAKE post')
% % sws pre
% subplot(323)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_SWSPre),nanmean(AvStdErr_DeltaDeepCNO_SWSPre,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_SWSPre),nanmean(AvStdErr_DeltaSupCNO_SWSPre,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_SWSPre),nanmean(AvStdErr_DeltaDeepCtrl_SWSPre,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_SWSPre),nanmean(AvStdErr_DeltaSupCtrl_SWSPre,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('NREM pre')
% %sws post
% subplot(324)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_SWSPost),nanmean(AvStdErr_DeltaDeepCNO_SWSPost,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_SWSPost),nanmean(AvStdErr_DeltaSupCNO_SWSPost,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_SWSPost),nanmean(AvStdErr_DeltaDeepCtrl_SWSPost,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_SWSPost),nanmean(AvStdErr_DeltaSupCtrl_SWSPost,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('NREM post')
% %rem pre
% subplot(325)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_REMPre),nanmean(AvStdErr_DeltaDeepCNO_REMPre,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_REMPre),nanmean(AvStdErr_DeltaSupCNO_REMPre,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_REMPre),nanmean(AvStdErr_DeltaDeepCtrl_REMPre,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_REMPre),nanmean(AvStdErr_DeltaSupCtrl_REMPre,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('REM pre')
% % rem post
% subplot(326)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_REMPost),nanmean(AvStdErr_DeltaDeepCNO_REMPost,1),'-r',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_REMPost),nanmean(AvStdErr_DeltaSupCNO_REMPost,1),'-r',1)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_REMPost),nanmean(AvStdErr_DeltaDeepCtrl_REMPost,1),'-k',1), hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_REMPost),nanmean(AvStdErr_DeltaSupCtrl_REMPost,1),'-k',1)
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('REM post')

% %% AVERAGE : compare pre & post for saline and CNO conditions
% figure,
% % wake saline
% subplot(321)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_WakePre),nanmean(AvStdErr_DeltaDeepCtrl_WakePre,1),':k',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_WakePre),nanmean(AvStdErr_DeltaSupCtrl_WakePre,1),':k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_WakePost),nanmean(AvStdErr_DeltaDeepCtrl_WakePost,1),'-k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_WakePost),nanmean(AvStdErr_DeltaSupCtrl_WakePost,1),'-k',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% ylabel('WAKE')
% title('SALINE')
% % wake cno
% subplot(322)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_WakePre),nanmean(AvStdErr_DeltaDeepCNO_WakePre,1),':r',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_WakePre),nanmean(AvStdErr_DeltaSupCNO_WakePre,1),':r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_WakePost),nanmean(AvStdErr_DeltaDeepCNO_WakePost,1),'-r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_WakePost),nanmean(AvStdErr_DeltaSupCNO_WakePost,1),'-r',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% title('CNO')
% % sws saline
% subplot(323)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_SWSPre),nanmean(AvStdErr_DeltaDeepCtrl_SWSPre,1),':k',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_SWSPre),nanmean(AvStdErr_DeltaSupCtrl_SWSPre,1),':k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_SWSPost),nanmean(AvStdErr_DeltaDeepCtrl_SWSPost,1),'-k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_SWSPost),nanmean(AvStdErr_DeltaSupCtrl_SWSPost,1),'-k',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% ylabel('NREM')
% % sws cno
% subplot(324)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_SWSPre),nanmean(AvStdErr_DeltaDeepCNO_SWSPre,1),':r',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_SWSPre),nanmean(AvStdErr_DeltaSupCNO_SWSPre,1),':r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_SWSPost),nanmean(AvStdErr_DeltaDeepCNO_SWSPost,1),'-r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_SWSPost),nanmean(AvStdErr_DeltaSupCNO_SWSPost,1),'-r',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% % rem saline
% subplot(325)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_REMPre),nanmean(AvStdErr_DeltaDeepCtrl_REMPre,1),':k',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_REMPre),nanmean(AvStdErr_DeltaSupCtrl_REMPre,1),':k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCtrl_REMPost),nanmean(AvStdErr_DeltaDeepCtrl_REMPost,1),'-k',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCtrl_REMPost),nanmean(AvStdErr_DeltaSupCtrl_REMPost,1),'-k',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
% ylabel('REM')
% % rem cno
% subplot(326)
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_REMPre),nanmean(AvStdErr_DeltaDeepCNO_REMPre,1),':r',1); hold on
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_REMPre),nanmean(AvStdErr_DeltaSupCNO_REMPre,1),':r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaDeepCNO_REMPost),nanmean(AvStdErr_DeltaDeepCNO_REMPost,1),'-r',1);
% shadedErrorBar(Mdeep_pre(:,1),nanmean(AvData_DeltaSupCNO_REMPost),nanmean(AvStdErr_DeltaSupCNO_REMPost,1),'-r',1);
% ylim([-2000 +2000])
% xlim([-0.2 +0.3])
% makepretty
