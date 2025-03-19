%% input dir : exi DREADD VLPO CRH-neurons
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149]);
% 
% % DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% % DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');


%% input dir : inhi DREADD in PFC
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% DirSaline_dreadd_PFC = RestrictPathForExperiment(DirSaline_dreadd_PFC,'nMice',[1196 1197]);

DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1149]);
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1197]);

%%
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    %get sleep states and epoch pre/post injection
    a{i} = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    durtotal_sal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    Epoch_pre_sal{i} = intervalSet(0, (durtotal_sal{i})/2);
    Epoch_post_sal{i} = intervalSet((durtotal_sal{i})/2,durtotal_sal{i});
    
%       Epoch_pre_sal{i} = intervalSet(0, 1.4e8);
%     Epoch_post_sal{i} = intervalSet(1.6e8,durtotal_sal{i});
    %load ripples epoch
    if exist('SWR.mat')
        b{i} = load('SWR', 'RipplesEpoch')
    else
        b{i} = load('Ripples.mat', 'RipplesEpoch')
    end
    
    %load delta epoch
    c{i} = load('DeltaWaves.mat','alldeltas_PFCx');
    
%     %get ripples and deltas density
    [Ripples_tsd,Delta_tsd] = GetRipplesDeltasDensityTSD_MC(b{i}.RipplesEpoch,c{i}.alldeltas_PFCx);
    RippDensity_sal{i} = Ripples_tsd;
    RippDensity_SWS_sal{i} = Restrict(RippDensity_sal{i},a{i}.SWSEpoch);
    RippDensity_Wake_sal{i} = Restrict(RippDensity_sal{i},a{i}.Wake);
    RippDensity_REM_sal{i} = Restrict(RippDensity_sal{i},a{i}.REMEpoch);
    %ripples pre inj
    RippDensity_SWS_pre_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.SWSEpoch,Epoch_pre_sal{i}));
    RippDensity_Wake_pre_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.Wake,Epoch_pre_sal{i}));
    RippDensity_REM_pre_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.REMEpoch,Epoch_pre_sal{i}));
    %ripples post inj
    RippDensity_SWS_post_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.SWSEpoch,Epoch_post_sal{i}));
    RippDensity_Wake_post_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.Wake,Epoch_post_sal{i}));
    RippDensity_REM_post_sal{i} = Restrict(RippDensity_sal{i},and(a{i}.REMEpoch,Epoch_post_sal{i}));
%     
    DeltDensity_sal{i} = Delta_tsd;
    DeltDensity_SWS_sal{i} = Restrict(DeltDensity_sal{i},a{i}.SWSEpoch);
    DeltDensity_Wake_sal{i} = Restrict(DeltDensity_sal{i},a{i}.Wake);
    DeltDensity_REM_sal{i} = Restrict(DeltDensity_sal{i},a{i}.REMEpoch);
    %deltas pre inj
    DeltDensity_SWS_pre_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.SWSEpoch,Epoch_pre_sal{i}));
    DeltDensity_Wake_pre_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.Wake,Epoch_pre_sal{i}));
    DeltDensity_REM_pre_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.REMEpoch,Epoch_pre_sal{i}));
    %deltas post inj
    DeltDensity_SWS_post_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.SWSEpoch,Epoch_post_sal{i}));
    DeltDensity_Wake_post_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.Wake,Epoch_post_sal{i}));
    DeltDensity_REM_post_sal{i} = Restrict(DeltDensity_sal{i},and(a{i}.REMEpoch,Epoch_post_sal{i}));
end

%% mean delta
for ii=1:length(DeltDensity_SWS_pre_sal)
    AvDeltDensity_SWS_pre_sal(ii,:)=nanmean(Data(DeltDensity_SWS_pre_sal{ii}(:,:)),1);
    AvDeltDensity_Wake_pre_sal(ii,:)=nanmean(Data(DeltDensity_Wake_pre_sal{ii}(:,:)),1);
    AvDeltDensity_REM_pre_sal(ii,:)=nanmean(Data(DeltDensity_REM_pre_sal{ii}(:,:)),1);
    
    AvDeltDensity_SWS_post_sal(ii,:)=nanmean(Data(DeltDensity_SWS_post_sal{ii}(:,:)),1);
    AvDeltDensity_Wake_post_sal(ii,:)=nanmean(Data(DeltDensity_Wake_post_sal{ii}(:,:)),1);
    AvDeltDensity_REM_post_sal(ii,:)=nanmean(Data(DeltDensity_REM_post_sal{ii}(:,:)),1);
end
% mean ripples
for ii=1:length(RippDensity_SWS_pre_sal)
    AvRippDensity_SWS_pre_sal(ii,:)=nanmean(Data(RippDensity_SWS_pre_sal{ii}(:,:)),1);
    AvRippDensity_Wake_pre_sal(ii,:)=nanmean(Data(RippDensity_Wake_pre_sal{ii}(:,:)),1);
    AvRippDensity_REM_pre_sal(ii,:)=nanmean(Data(RippDensity_REM_pre_sal{ii}(:,:)),1);
    
    AvRippDensity_SWS_post_sal(ii,:)=nanmean(Data(RippDensity_SWS_post_sal{ii}(:,:)),1);
    AvRippDensity_Wake_post_sal(ii,:)=nanmean(Data(RippDensity_Wake_post_sal{ii}(:,:)),1);
    AvRippDensity_REM_post_sal(ii,:)=nanmean(Data(RippDensity_REM_post_sal{ii}(:,:)),1);
end
%%
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    %get sleep states and epoch pre/post injection
    d{j} = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    durtotal_cno{j} = max([max(End(d{j}.Wake)),max(End(d{j}.SWSEpoch))]);
    Epoch_pre_cno{j} = intervalSet(0, (durtotal_cno{j})/2);
    Epoch_post_cno{j} = intervalSet((durtotal_cno{j})/2,durtotal_cno{j});
%      Epoch_pre_cno{j} = intervalSet(0, 1.4e8);
%     Epoch_post_cno{j} = intervalSet(1.6e8,durtotal_cno{j});
    
    % load ripples epoch
    if exist('SWR.mat')
        e{j} = load('SWR', 'RipplesEpoch')
    else 
        e{j} = load('Ripples.mat', 'RipplesEpoch')
    end
    
    % load delta epoch
    f{j} = load('DeltaWaves.mat','alldeltas_PFCx');
    
%     % get ripples and deltas density
    [Ripples_tsd,Delta_tsd] = GetRipplesDeltasDensityTSD_MC(e{j}.RipplesEpoch,f{j}.alldeltas_PFCx);
    RippDensity_cno{j} = Ripples_tsd;
    % RippDensity_SWS{i} = Restrict(RippDensity{i},a{i}.SWSEpoch);
    % RippDensity_Wake{i} = Restrict(RippDensity{i},a{i}.Wake);
    % RippDensity_REM{i} = Restrict(RippDensity{i},a{i}.REMEpoch);
    % ripples pre inj
    RippDensity_SWS_pre_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.SWSEpoch,Epoch_pre_cno{j}));
    RippDensity_Wake_pre_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.Wake,Epoch_pre_cno{j}));
    RippDensity_REM_pre_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.REMEpoch,Epoch_pre_cno{j}));
    % ripples post inj
    RippDensity_SWS_post_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.SWSEpoch,Epoch_post_cno{j}));
    RippDensity_Wake_post_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.Wake,Epoch_post_cno{j}));
    RippDensity_REM_post_cno{j} = Restrict(RippDensity_cno{j},and(d{j}.REMEpoch,Epoch_post_cno{j}));
    
    DeltDensity_cno{j} = Delta_tsd;
    % DeltDensity_SWS{i} = Restrict(DeltDensity{i},a{i}.SWSEpoch);
    % DeltDensity_Wake{i} = Restrict(DeltDensity{i},a{i}.Wake);
    % DeltDensity_REM{i} = Restrict(DeltDensity{i},a{i}.REMEpoch);
    % deltas pre inj
    DeltDensity_SWS_pre_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.SWSEpoch,Epoch_pre_cno{j}));
    DeltDensity_Wake_pre_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.Wake,Epoch_pre_cno{j}));
    DeltDensity_REM_pre_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.REMEpoch,Epoch_pre_cno{j}));
    % deltas post inj
    DeltDensity_SWS_post_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.SWSEpoch,Epoch_post_cno{j}));
    DeltDensity_Wake_post_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.Wake,Epoch_post_cno{j}));
    DeltDensity_REM_post_cno{j} = Restrict(DeltDensity_cno{j},and(d{j}.REMEpoch,Epoch_post_cno{j}));
end

%% mean delta
for jj=1:length(DeltDensity_SWS_pre_cno)
    AvDeltDensity_SWS_pre_cno(jj,:)=nanmean(Data(DeltDensity_SWS_pre_cno{jj}(:,:)),1);
    AvDeltDensity_Wake_pre_cno(jj,:)=nanmean(Data(DeltDensity_Wake_pre_cno{jj}(:,:)),1);
    AvDeltDensity_REM_pre_cno(jj,:)=nanmean(Data(DeltDensity_REM_pre_cno{jj}(:,:)),1);
    
    AvDeltDensity_SWS_post_cno(jj,:)=nanmean(Data(DeltDensity_SWS_post_cno{jj}(:,:)),1);
    AvDeltDensity_Wake_post_cno(jj,:)=nanmean(Data(DeltDensity_Wake_post_cno{jj}(:,:)),1);
    AvDeltDensity_REM_post_cno(jj,:)=nanmean(Data(DeltDensity_REM_post_cno{jj}(:,:)),1);
end
% mean ripples
for jj=1:length(RippDensity_SWS_pre_cno)
    AvRippDensity_SWS_pre_cno(jj,:)=nanmean(Data(RippDensity_SWS_pre_cno{jj}(:,:)),1);
    AvRippDensity_Wake_pre_cno(jj,:)=nanmean(Data(RippDensity_Wake_pre_cno{jj}(:,:)),1);
    AvRippDensity_REM_pre_cno(jj,:)=nanmean(Data(RippDensity_REM_pre_cno{jj}(:,:)),1);
    
    AvRippDensity_SWS_post_cno(jj,:)=nanmean(Data(RippDensity_SWS_post_cno{jj}(:,:)),1);
    AvRippDensity_Wake_post_cno(jj,:)=nanmean(Data(RippDensity_Wake_post_cno{jj}(:,:)),1);
    AvRippDensity_REM_post_cno(jj,:)=nanmean(Data(RippDensity_REM_post_cno{jj}(:,:)),1);
end

%% figures
%% SALINE VS CNO
%% deltas
figure
subplot(171),PlotErrorBarN_KJ({AvDeltDensity_Wake_pre_sal AvDeltDensity_Wake_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
ylabel('Deltas/s')
makepretty
title('WAKE pre')
subplot(172),PlotErrorBarN_KJ({AvDeltDensity_SWS_pre_sal AvDeltDensity_SWS_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
makepretty
title('NREM pre')
subplot(173),PlotErrorBarN_KJ({AvDeltDensity_REM_pre_sal AvDeltDensity_REM_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
makepretty
title('REM pre')
subplot(175),PlotErrorBarN_KJ({AvDeltDensity_Wake_post_sal AvDeltDensity_Wake_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
makepretty
title('WAKE post')
subplot(176),PlotErrorBarN_KJ({AvDeltDensity_SWS_post_sal AvDeltDensity_SWS_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
makepretty
title('NREM post')
subplot(177),PlotErrorBarN_KJ({AvDeltDensity_REM_post_sal AvDeltDensity_REM_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.4])
makepretty
title('REM post')
% suptitle('Deltas density (n=4)')

%% ripples
figure
subplot(171),PlotErrorBarN_KJ({AvRippDensity_Wake_pre_sal AvRippDensity_Wake_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
ylabel('Ripples/s')
makepretty
title('WAKE pre')
subplot(172),PlotErrorBarN_KJ({AvRippDensity_SWS_pre_sal AvRippDensity_SWS_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
makepretty
title('NREM pre')
subplot(173),PlotErrorBarN_KJ({AvRippDensity_REM_pre_sal AvRippDensity_REM_pre_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
makepretty
title('REM pre')
subplot(175),PlotErrorBarN_KJ({AvRippDensity_Wake_post_sal AvRippDensity_Wake_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
makepretty
title('WAKE post')
subplot(176),PlotErrorBarN_KJ({AvRippDensity_SWS_post_sal AvRippDensity_SWS_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
makepretty
title('NREM post')
subplot(177),PlotErrorBarN_KJ({AvRippDensity_REM_post_sal AvRippDensity_REM_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'sal','cno'})
ylim([0 1.3])
makepretty
title('REM post')
% suptitle('Ripples density (n=4)')


%% CNO mice
%% PRE / POST CNO DELTA
figure
subplot(333),PlotErrorBarN_KJ({AvDeltDensity_Wake_pre_cno AvDeltDensity_Wake_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('WAKE')
makepretty
subplot(336),PlotErrorBarN_KJ({AvDeltDensity_SWS_pre_cno AvDeltDensity_SWS_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('NREM')
makepretty
subplot(339),PlotErrorBarN_KJ({AvDeltDensity_REM_pre_cno AvDeltDensity_REM_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('REM')
makepretty
for j=1:length(DirCNO.path)
subplot(3,3,[1,2]),plot(Range(Restrict(DeltDensity_cno{j},d{j}.Wake))/1E4, runmean(Data(Restrict(DeltDensity_cno{j},d{j}.Wake)),70),'.'), hold on
ylabel('Deltas/s')
title('WAKE')
ylim([0 2])
makepretty
subplot(3,3,[4,5]),plot(Range(Restrict(DeltDensity_cno{j},d{j}.SWSEpoch))/1E4, runmean(Data(Restrict(DeltDensity_cno{j},d{j}.SWSEpoch)),70),'.'), hold on
ylabel('Deltas/s')
title('NREM')
ylim([0 2])
makepretty
subplot(3,3,[7,8]),plot(Range(Restrict(DeltDensity_cno{j},d{j}.REMEpoch))/1E4, runmean(Data(Restrict(DeltDensity_cno{j},d{j}.REMEpoch)),70),'.'), hold on
ylabel('Deltas/s')
title('REM')
xlabel('Time (s)')
ylim([0 2])
makepretty
legend({'mouse','mouse','mouse','mouse'})
end
suptitle('Deltas density CNO n=4')

%% PRE / POST CNO RIPPLES
figure
subplot(333),PlotErrorBarN_KJ({AvRippDensity_Wake_pre_cno AvRippDensity_Wake_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('WAKE')
makepretty
subplot(336),PlotErrorBarN_KJ({AvRippDensity_SWS_pre_cno AvRippDensity_SWS_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('NREM')
makepretty
subplot(339),PlotErrorBarN_KJ({AvRippDensity_REM_pre_cno AvRippDensity_REM_post_cno},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('REM')
makepretty
for j=1:length(DirCNO.path)
subplot(3,3,[1,2]),plot(Range(Restrict(RippDensity_cno{j},d{j}.Wake))/1E4, runmean(Data(Restrict(RippDensity_cno{j},d{j}.Wake)),70),'.'), hold on
ylabel('Ripples/s')
ylim([0 1.8])
title('WAKE')
makepretty
subplot(3,3,[4,5]),plot(Range(Restrict(RippDensity_cno{j},d{j}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},d{j}.SWSEpoch)),70),'.'), hold on
ylabel('Ripples/s')
title('NREM')
ylim([0 1.8])
makepretty
subplot(3,3,[7,8]),plot(Range(Restrict(RippDensity_cno{j},d{j}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_cno{j},d{j}.REMEpoch)),70),'.'), hold on
ylabel('Ripples/s')
title('REM')
ylim([0 1.8])
xlabel('Time (s)')
makepretty
legend({'mouse','mouse','mouse','mouse'})
end
suptitle('Ripples density CNO n=4')


%% SALINE MICE
%% PRE / POST saline DELTA
figure
subplot(333),PlotErrorBarN_KJ({AvDeltDensity_Wake_pre_sal AvDeltDensity_Wake_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('WAKE')
makepretty
subplot(336),PlotErrorBarN_KJ({AvDeltDensity_SWS_pre_sal AvDeltDensity_SWS_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('NREM')
makepretty
subplot(339),PlotErrorBarN_KJ({AvDeltDensity_REM_pre_sal AvDeltDensity_REM_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.5])
ylabel('Deltas/s')
title('REM')
makepretty
for i=1:length(DirSaline.path)
subplot(3,3,[1,2]),plot(Range(Restrict(DeltDensity_sal{i},a{i}.Wake))/1E4, runmean(Data(Restrict(DeltDensity_sal{i},a{i}.Wake)),70),'.'), hold on
ylabel('Deltas/s')
title('WAKE')
ylim([0 2])
makepretty
subplot(3,3,[4,5]),plot(Range(Restrict(DeltDensity_sal{i},a{i}.SWSEpoch))/1E4, runmean(Data(Restrict(DeltDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
ylabel('Deltas/s')
title('NREM')
ylim([0 2])
makepretty
subplot(3,3,[7,8]),plot(Range(Restrict(DeltDensity_sal{i},a{i}.REMEpoch))/1E4, runmean(Data(Restrict(DeltDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
ylabel('Deltas/s')
title('REM')
xlabel('Time (s)')
ylim([0 2])
makepretty
legend({'mouse','mouse','mouse','mouse'})
end
suptitle('Delta density saline n=4')

%% PRE / POST saline RIPPLES
figure
subplot(333),PlotErrorBarN_KJ({AvRippDensity_Wake_pre_sal AvRippDensity_Wake_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('WAKE')
makepretty
subplot(336),PlotErrorBarN_KJ({AvRippDensity_SWS_pre_sal AvRippDensity_SWS_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('NREM')
makepretty
subplot(339),PlotErrorBarN_KJ({AvRippDensity_REM_pre_sal AvRippDensity_REM_post_sal},'newfig',0,'paired',0)
xticks([1 2]), xticklabels({'pre','post'})
ylim([0 1.2])
ylabel('Ripples/s')
title('REM')
makepretty
for i=1:length(DirSaline.path)
subplot(3,3,[1,2]),plot(Range(Restrict(RippDensity_sal{i},a{i}.Wake))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.Wake)),70),'.'), hold on
ylabel('Ripples/s')
ylim([0 1.8])
title('WAKE')
makepretty
subplot(3,3,[4,5]),plot(Range(Restrict(RippDensity_sal{i},a{i}.SWSEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.SWSEpoch)),70),'.'), hold on
ylabel('Ripples/s')
title('NREM')
ylim([0 1.8])
makepretty
subplot(3,3,[7,8]),plot(Range(Restrict(RippDensity_sal{i},a{i}.REMEpoch))/1E4, runmean(Data(Restrict(RippDensity_sal{i},a{i}.REMEpoch)),70),'.'), hold on
ylabel('Ripples/s')
title('REM')
ylim([0 1.8])
xlabel('Time (s)')
makepretty
legend({'mouse1105','mouse1106','mouse1149','mouse'})
end
suptitle('Ripples density saline n=4')
