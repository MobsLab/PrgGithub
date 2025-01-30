%% input dir : exi DREADD VLPO CRH-neurons
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% % DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149 1150]);
% % DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
% 
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149]);


%% input dir : inhi DREADD in PFC
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_PFC = RestrictPathForExperiment(DirSaline_dreadd_PFC,'nMice',[1196 1197]);

DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1149]);

DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
DirCNO = RestrictPathForExperiment(DirCNO,'nMice',[1196 1197]);

DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

%% input dir (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir (atropine experiment)

% DirBaselineMC = PathForExperimentsAtropine_MC('Baseline');
% DirAtropineMC = PathForExperimentsAtropine_MC('Atropine');
% DirBaselineMC = RestrictPathForExperiment(DirBaselineMC, 'nMice', [1105 1106 1107]);
% DirAtropineMC = RestrictPathForExperiment(DirAtropineMC, 'nMice', [1105 1106 1107]);

%% get the data saline
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_sal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    Epoch_pre_sal{i} = intervalSet(0,durtotal_sal{i}/2);
    Epoch_post_sal{i} = intervalSet(durtotal_sal{i}/2,durtotal_sal{i});
    
    %%restrict to period with low movement
%     b{i} = load('behavResources.mat', 'Vtsd','FreezeAccEpoch');
%     % threshold on speed to get period of high/low activity
%     thresh_sal{i} = mean(Data(b{i}.Vtsd))+std(Data(b{i}.Vtsd));
%     highMov_sal{i} = thresholdIntervals(b{i}.Vtsd, thresh_sal{i}, 'Direction', 'Above');
%     lowMov_sal{i} = thresholdIntervals(b{i}.Vtsd, thresh_sal{i}, 'Direction', 'Below');
    
    %%load ripples
    if exist('SWR.mat')
        rippSal{i} = load('SWR','RipplesEpoch');
    else
        rippSal{i} = load('Ripples','RipplesEpoch');
    end
    %get ripples density
    [Ripples_tsd] = GetRipplesDensityTSD_MC(rippSal{i}.RipplesEpoch);
    RippDensity_sal{i} = Ripples_tsd;
    % find ripples in specific epoch
    ripp_SWSbefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.SWSEpoch, Epoch_pre_sal{i}));
    ripp_SWSafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.SWSEpoch, Epoch_post_sal{i}));
    ripp_Wakebefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.Wake, Epoch_pre_sal{i}));
    ripp_Wakeafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.Wake, Epoch_post_sal{i}));
    ripp_REMbefore_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.REMEpoch, Epoch_pre_sal{i}));
    ripp_REMafter_sal{i} = Restrict(RippDensity_sal{i}, and(a{i}.REMEpoch, Epoch_post_sal{i}));
    
%     ripp_Freezebefore_sal{i} = Restrict(ripples_sal{i}, and(b{i}.FreezeAccEpoch,Epoch1_sal{i}));
%     ripp_Freezeafter_sal{i} = Restrict(ripples_sal{i}, and(b{i}.FreezeAccEpoch,Epoch2_sal{i}));
%     
%     % find ripples in wake with high/low mov
%     ripp_Wakebefore_lowMov_sal{i} = Restrict(ripples_sal{i}, and(and(a{i}.Wake,lowMov_sal{i}), Epoch1_sal{i}));
%     ripp_Wakebefore_highMov_sal{i} = Restrict(ripples_sal{i}, and(and(a{i}.Wake,highMov_sal{i}), Epoch1_sal{i}));
%     ripp_Wakeafter_lowMov_sal{i} = Restrict(ripples_sal{i}, and(and(a{i}.Wake,lowMov_sal{i}), Epoch2_sal{i}));
%     ripp_Wakeafter_highMov_sal{i} = Restrict(ripples_sal{i}, and(and(a{i}.Wake,highMov_sal{i}), Epoch2_sal{i}));
end

%% calculate mean for deltas

% ripples
for ii=1:length(ripp_SWSbefore_sal)
    avRippPerMin_SWSbefore_sal(ii,:)=nanmean(Data(ripp_SWSbefore_sal{ii}(:,:)),1);
    avRippPerMin_Wakebefore_sal(ii,:)=nanmean(Data(ripp_Wakebefore_sal{ii}(:,:)),1);
    avRippPerMin_REMbefore_sal(ii,:)=nanmean(Data(ripp_REMbefore_sal{ii}(:,:)),1);
%     % for wake with high/low mov
%     avRippPerMin_Wakebefore_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_lowMov_sal{ii}(:,:)),1);
%     avRippPerMin_Wakebefore_highMov_sal(ii,:)=nanmean(Data(ripp_Wakebefore_highMov_sal{ii}(:,:)),1);
end
for ii=1:length(ripp_SWSafter_sal)
    avRippPerMin_SWSafter_sal(ii,:)=nanmean(Data(ripp_SWSafter_sal{ii}(:,:)),1);
    avRippPerMin_Wakeafter_sal(ii,:)=nanmean(Data(ripp_Wakeafter_sal{ii}(:,:)),1);
    avRippPerMin_REMafter_sal(ii,:)=nanmean(Data(ripp_REMafter_sal{ii}(:,:)),1);
%     % for wake with high/low mov
%     avRippPerMin_Wakeafter_lowMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_lowMov_sal{ii}(:,:)),1);
%     avRippPerMin_Wakeafter_highMov_sal(ii,:)=nanmean(Data(ripp_Wakeafter_highMov_sal{ii}(:,:)),1);
%     
%     avRippPerMin_Freezebefore_sal(ii,:)=nanmean(Data(ripp_Freezebefore_sal{ii}(:,:)),1);
%     avRippPerMin_Freezeafter_sal(ii,:)=nanmean(Data(ripp_Freezeafter_sal{ii}(:,:)),1);
end

%% get data CNO
for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    d{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%separate recording before/after injection
    durtotal_CNO{j} = max([max(End(d{j}.Wake)),max(End(d{j}.SWSEpoch))]);
    Epoch_pre_CNO{j} = intervalSet(0,durtotal_CNO{j}/2);
    Epoch_post_CNO{j} = intervalSet(durtotal_CNO{j}/2,durtotal_CNO{j});
    
    %%restrict to period with low movement
    %     e{j} = load('behavResources.mat', 'Vtsd','FreezeAccEpoch');
    %     % threshold on speed to get period of high/low activity
    %     thresh_cno{j} = mean(Data(e{j}.Vtsd))+std(Data(e{j}.Vtsd));
    %     highMov_cno{j} = thresholdIntervals(e{j}.Vtsd, thresh_cno{j}, 'Direction', 'Above');
    %     lowMov_cno{j} = thresholdIntervals(e{j}.Vtsd, thresh_cno{j}, 'Direction', 'Below');
    
    %%load ripples
    if exist('SWR.mat')
        rippCNO{j} = load('SWR','RipplesEpoch');
        
    else
        rippCNO{j} = load('Ripples','RipplesEpoch');
    end
    %%get ripples density
    [Ripples_tsd] = GetRipplesDensityTSD_MC(rippCNO{j}.RipplesEpoch);
    RippDensity_cno{j} = Ripples_tsd;
    % find ripples density in specific epoch
    ripp_SWSbefore_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.SWSEpoch, Epoch_pre_CNO{j}));
    ripp_SWSafter_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.SWSEpoch, Epoch_post_CNO{j}));
    ripp_Wakebefore_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.Wake, Epoch_pre_CNO{j}));
    ripp_Wakeafter_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.Wake, Epoch_post_CNO{j}));
    ripp_REMbefore_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.REMEpoch, Epoch_pre_CNO{j}));
    ripp_REMafter_cno{j} = Restrict(RippDensity_cno{j}, and(d{j}.REMEpoch, Epoch_post_CNO{j}));
    
%     ripp_Freezebefore_cno{j} = Restrict(ripples_cno{j}, and(e{j}.FreezeAccEpoch,Epoch1_CNO{j}));
%     ripp_Freezeafter_cno{j} = Restrict(ripples_cno{j}, and(e{j}.FreezeAccEpoch,Epoch2_CNO{j}));

%     % for wake with high/low mov
%     ripp_Wakebefore_lowMov_cno{j} = Restrict(ripples_cno{j}, and(and(d{j}.Wake,lowMov_cno{j}), Epoch1_CNO{j}));
%     ripp_Wakebefore_highMov_cno{j} = Restrict(ripples_cno{j}, and(and(d{j}.Wake,highMov_cno{j}), Epoch1_CNO{j}));
%     rip_Wakeafter_lowMov_cno{j} = Restrict(ripples_cno{j}, and(and(d{j}.Wake,lowMov_cno{j}), Epoch2_CNO{j}));
%     ripp_Wakeafter_highMov_cno{j} = Restrict(ripples_cno{j}, and(and(d{j}.Wake,highMov_cno{j}), Epoch2_CNO{j}));
    
    
end

%% calculate mean

% ripples
for jj=1:length(ripp_SWSbefore_cno)
    avRippPerMin_SWSbefore_cno(jj,:)=nanmean(Data(ripp_SWSbefore_cno{jj}(:,:)),1);
    avRippPerMin_Wakebefore_cno(jj,:)=nanmean(Data(ripp_Wakebefore_cno{jj}(:,:)),1);
    avRippPerMin_REMbefore_cno(jj,:)=nanmean(Data(ripp_REMbefore_cno{jj}(:,:)),1);
%     % for wake with high/low mov
%     avRippPerMin_Wakebefore_lowMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_lowMov_cno{jj}(:,:)),1);
%     avRippPerMin_Wakebefore_highMov_cno(jj,:)=nanmean(Data(ripp_Wakebefore_highMov_cno{jj}(:,:)),1);
end
for jj=1:length(ripp_SWSafter_cno)
    avRippPerMin_SWSafter_cno(jj,:)=nanmean(Data(ripp_SWSafter_cno{jj}(:,:)),1);
    avRippPerMin_Wakeafter_cno(jj,:)=nanmean(Data(ripp_Wakeafter_cno{jj}(:,:)),1);
    avRippPerMin_REMafter_cno(jj,:)=nanmean(Data(ripp_REMafter_cno{jj}(:,:)),1);
%     % for wake with high/low mov
%     avRippPerMin_Wakeafter_lowMov_cno(jj,:)=nanmean(Data(rip_Wakeafter_lowMov_cno{jj}(:,:)),1);
%     avRippPerMin_Wakeafter_highMov_cno(jj,:)=nanmean(Data(ripp_Wakeafter_highMov_cno{jj}(:,:)),1);
%     
%     avRippPerMin_Freezebefore_cno(jj,:)=nanmean(Data(ripp_Freezebefore_cno{jj}(:,:)),1);
%     avRippPerMin_Freezeafter_cno(jj,:)=nanmean(Data(ripp_Freezeafter_cno{jj}(:,:)),1);
end


%% figure : ripples density for each state
avRippPerMin_REMafter_cno = NaN;
figure,subplot(171),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_sal avRippPerMin_Wakebefore_cno},'newfig',0, 'paired',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.7])
ylabel('ripples/s')
title('WAKE')
makepretty
subplot(172), PlotErrorBarN_KJ({avRippPerMin_SWSbefore_sal avRippPerMin_SWSbefore_cno},'newfig',0, 'paired',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.7])
ylabel('ripples/s')
title('NREM')
makepretty
subplot(173), PlotErrorBarN_KJ({avRippPerMin_REMbefore_sal avRippPerMin_REMbefore_cno},'newfig',0, 'paired',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.7])
ylabel('ripples/s')
title('REM')
makepretty
subplot(175),PlotErrorBarN_KJ({avRippPerMin_Wakeafter_sal avRippPerMin_Wakeafter_cno},'newfig',0, 'paired',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.7])
ylabel('ripples/s')
title('WAKE')
makepretty
subplot(176), PlotErrorBarN_KJ({avRippPerMin_SWSafter_sal avRippPerMin_SWSafter_cno},'newfig',0, 'paired',0);
ylim([0 0.7])
xticklabels({'sal','CNO'})
ylim([0 1])
ylabel('ripples/s')
title('NREM')
makepretty
subplot(177), PlotErrorBarN_KJ({avRippPerMin_REMafter_sal avRippPerMin_REMafter_cno},'newfig',0, 'paired',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.7])
ylabel('ripples/s')
title('REM')
makepretty








%% ripples density Version2
figure,
subplot(311),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_sal,avRippPerMin_Wakebefore_cno,avRippPerMin_Wakeafter_sal,avRippPerMin_Wakeafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('WAKE')
makepretty

subplot(312),PlotErrorBarN_KJ({avRippPerMin_SWSbefore_sal,avRippPerMin_SWSbefore_cno,avRippPerMin_SWSafter_sal,avRippPerMin_SWSafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('NREM')
makepretty

subplot(313),PlotErrorBarN_KJ({avRippPerMin_REMbefore_sal,avRippPerMin_REMbefore_cno,avRippPerMin_REMafter_sal,avRippPerMin_REMafter_cno},'newfig',0,'paired',0);
ylabel('Ripples/s')
ylim([0 0.65])
xticks([1.5 3.5])
xticklabels({'Pre','Post'})
title('REM')
makepretty












%%
figure


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






%% figure : ripples density during wake with high/low activity
figure
subplot(221), PlotErrorBarN_KJ({avRippPerMin_Wakebefore_lowMov_sal avRippPerMin_Wakebefore_lowMov_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.15])
ylabel('ripples/s')
title('Wake lowMov PRE inj')
makepretty
subplot(222),PlotErrorBarN_KJ({avRippPerMin_Wakeafter_lowMov_sal avRippPerMin_Wakeafter_lowMov_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.15])
ylabel('ripples/s')
title('Wake lowMov POST inj')
makepretty
subplot(223),PlotErrorBarN_KJ({avRippPerMin_Wakebefore_highMov_sal avRippPerMin_Wakebefore_highMov_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.15])
ylabel('ripples/s')
title('Wake highMov PRE inj')
makepretty
subplot(224), PlotErrorBarN_KJ({avRippPerMin_Wakeafter_highMov_sal avRippPerMin_Wakeafter_highMov_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
ylim([0 0.15])
ylabel('ripples/s')
title('Wake highMov POST inj')
makepretty


%% figure : ripples density during freezing
figure
subplot(121), PlotErrorBarN_KJ({avRippPerMin_Freezebefore_sal avRippPerMin_Freezebefore_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
% ylim([0 0.15])
ylabel('ripples/s')
makepretty
subplot(122),PlotErrorBarN_KJ({avRippPerMin_Freezeafter_sal avRippPerMin_Freezeafter_cno},'newfig',0, 'paired',1);
xticks([1 2])
xticklabels({'sal','CNO'})
% ylim([0 0.15])
ylabel('ripples/s')
makepretty
