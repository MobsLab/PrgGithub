% 

Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_1 = RestrictPathForExperiment(Dir_EPM_1,'nMice',[1449,1450,1451])
Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1429,1430,1431,1432])
Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SD');
% Dir_EPM_3 = RestrictPathForExperiment(Dir_EPM_3,'nMice',[1429,1430,1431,1432])

%% Figure trajectories black and orange
figure,
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    load ('behavResources.mat')
    subplot (3,11,i), title('Control'), axis square, xlim([0 100]),ylim([0 100]);
    for izone = 1:3
        hold on, plot (Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})), 'color',[0 0 0]);
    end
end

for j = 1:length(Dir_EPM_2.path)
    cd(Dir_EPM_2.path{j}{1})
    load ('behavResources.mat')
    subplot (3,11,length(Dir_EPM_1.path)+j),title('Post SD safe'), axis square, xlim([0 100]),ylim([0 100]);
    for izone = 1:3
        hold on, 
        plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[.31 .38 .61]);
    end
end

for k = 1:length(Dir_EPM_3.path)
    cd(Dir_EPM_3.path{k}{1})
    load ('behavResources.mat')
    subplot (3,11,length(Dir_EPM_1.path)+length(Dir_EPM_1.path)+k),title('Post SD dangerous'), axis square, xlim([0 100]),ylim([0 100]);
    for izone = 1:3
        hold on, 
        plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[.91 .53 .17]);
    end
end

%% EPM Baseline
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    behav_basal{i} = load ('behavResources.mat');
    
    %proportion (occupancy)
    occup_open_basal(i) = behav_basal{i}.Occup_redefined(1);
    occup_close_basal(i) = behav_basal{i}.Occup_redefined(2);
    occup_center_basal(i) = behav_basal{i}.Occup_redefined(3);
    
    %mean time
    dur_open_basal(i) = (nanmean([End(behav_basal{i}.ZoneEpoch_redefined{1}) - Start(behav_basal{i}.ZoneEpoch_redefined{1})]))/1E4;
    dur_close_basal(i) = (nanmean([End(behav_basal{i}.ZoneEpoch_redefined{2}) - Start(behav_basal{i}.ZoneEpoch_redefined{2})]))/1E4;
    dur_center_basal(i) = (nanmean([End(behav_basal{i}.ZoneEpoch_redefined{3}) - Start(behav_basal{i}.ZoneEpoch_redefined{3})]))/1E4;
    
    %speed
    speed_open_basal{i} = Data(Restrict(behav_basal{i}.Vtsd, behav_basal{i}.ZoneEpoch_redefined{1}));
    speed_close_basal{i} = Data(Restrict(behav_basal{i}.Vtsd, behav_basal{i}.ZoneEpoch_redefined{2}));
    speed_center_basal{i} = Data(Restrict(behav_basal{i}.Vtsd, behav_basal{i}.ZoneEpoch_redefined{3}));
    
    %entries
    for izone = 1:length(behav_basal{i}.ZoneIndices_redefined)
        if isempty(behav_basal{i}.ZoneIndices_redefined{izone})
            num_entries_basal{i}(izone) = 0;
        else
            num_entries_basal{i}(izone)=length(find(diff(behav_basal{i}.ZoneIndices_redefined{izone})>1))+1;
        end
    end
    num_entries_open_basal(i) = num_entries_basal{i}(1);
    num_entries_close_basal(i) = num_entries_basal{i}(2);
    num_entries_center_basal(i) = num_entries_basal{i}(3);
    
    %distance
    for izone = 1:length(behav_basal{i}.ZoneIndices_redefined)
        dist_basal {i}{izone} =  Data (Restrict (behav_basal{i}.Vtsd , behav_basal{i}.ZoneEpoch_redefined{izone}))*(behav_basal{i}.Occup_redefined(izone)*300);
    end
    dist_open_basal(i)= dist_basal{i}(1);
    dist_close_basal(i)= dist_basal{i}(2);
    dist_center_basal(i)= dist_basal{i}(3);
    
end

%% Mean computation saline
for i=1:length(Dir_EPM_1.path)
    mean_dur_open_basal(i) = nanmean(dur_open_basal(i));
    mean_dur_close_basal(i) = nanmean(dur_close_basal(i));
    mean_dur_center_basal(i) = nanmean(dur_center_basal(i));    
    
    mean_speed_open_basal(i) = nanmean(speed_open_basal{i});
    mean_speed_close_basal(i) = nanmean(speed_close_basal{i});
    mean_speed_center_basal(i) = nanmean(speed_center_basal{i});
    
    mean_entries_open_basal(i) = nanmean(num_entries_open_basal(i));
    mean_entries_close_basal(i) = nanmean(num_entries_close_basal(i));
    mean_entries_center_basal(i) = nanmean(num_entries_center_basal(i));
    
    mean_distance_open_basal(i) = nanmean(nanmean(dist_open_basal{i}));
    mean_distance_close_basal(i) = nanmean(nanmean(dist_close_basal{i}));
    mean_distance_center_basal(i) = nanmean(nanmean(dist_center_basal{i}));
end

%% EPM post Social Defeat safe
for i = 1:length(Dir_EPM_2.path)
    cd(Dir_EPM_2.path{i}{1})
    behav_SDsafe{i} = load ('behavResources.mat');
    
    %proportion (occupancy)
    occup_open_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(1);
    occup_close_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(2);
    occup_center_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(3);
    
    %mean time
    dur_open_SDsafe(i) = (nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{1}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{1})]))/1E4;
    dur_close_SDsafe(i) = (nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{2}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{2})]))/1E4;
    dur_center_SDsafe(i) = (nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{3}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{3})]))/1E4;
    
    %speed
    speed_open_SDsafe{i} = Data(Restrict(behav_SDsafe{i}.Vtsd, behav_SDsafe{i}.ZoneEpoch_redefined{1}));
    speed_close_SDsafe{i} = Data(Restrict(behav_SDsafe{i}.Vtsd, behav_SDsafe{i}.ZoneEpoch_redefined{2}));
    speed_center_SDsafe{i} = Data(Restrict(behav_SDsafe{i}.Vtsd, behav_SDsafe{i}.ZoneEpoch_redefined{3}));
    
    %entries
    for izone = 1:length(behav_SDsafe{i}.ZoneIndices_redefined)
        if isempty(behav_SDsafe{i}.ZoneIndices_redefined{izone})
            num_entries_SDsafe{i}(izone) = 0;
        else
            num_entries_SDsafe{i}(izone)=length(find(diff(behav_SDsafe{i}.ZoneIndices_redefined{izone})>1))+1;
        end
    end
    num_entries_open_SDsafe(i) = num_entries_SDsafe{i}(1);
    num_entries_close_SDsafe(i) = num_entries_SDsafe{i}(2);
    num_entries_center_SDsafe(i) = num_entries_SDsafe{i}(3);
    
    %distance
    for izone = 1:length(behav_SDsafe{i}.ZoneIndices_redefined)
        dist_SDsafe {i}{izone} =  Data (Restrict (behav_SDsafe{i}.Vtsd , behav_SDsafe{i}.ZoneEpoch_redefined{izone}))*(behav_SDsafe{i}.Occup_redefined(izone)*300);
    end
    dist_open_SDsafe(i)= dist_SDsafe{i}(1);
    dist_close_SDsafe(i)= dist_SDsafe{i}(2);
    dist_center_SDsafe(i)= dist_SDsafe{i}(3);

end

%% Mean computation SD safe
for i=1:length(Dir_EPM_2.path)
    mean_dur_open_SDsafe(i) = nanmean(dur_open_SDsafe(i));
    mean_dur_close_SDsafe(i) = nanmean(dur_close_SDsafe(i));
    mean_dur_center_SDsafe(i) = nanmean(dur_center_SDsafe(i));    
    
    mean_speed_open_SDsafe(i) = nanmean(speed_open_SDsafe{i});
    mean_speed_close_SDsafe(i) = nanmean(speed_close_SDsafe{i});
    mean_speed_center_SDsafe(i) = nanmean(speed_center_SDsafe{i});
    
    mean_entries_open_SDsafe(i) = nanmean(num_entries_open_SDsafe(i));
    mean_entries_close_SDsafe(i) = nanmean(num_entries_close_SDsafe(i));
    mean_entries_center_SDsafe(i) = nanmean(num_entries_center_SDsafe(i));
    
    mean_distance_open_SDsafe(i) = nanmean(nanmean(dist_open_SDsafe{i}));
    mean_distance_close_SDsafe(i) = nanmean(nanmean(dist_close_SDsafe{i}));
    mean_distance_center_SDsafe(i) = nanmean(nanmean(dist_center_SDsafe{i}));
end

%% EPM post Social Defeat dangerous
for j = 1:length(Dir_EPM_3.path)
    cd(Dir_EPM_3.path{j}{1})
    behav_SD{j} = load ('behavResources.mat');
    
    %proportion (occupancy)
    occup_open_SD(j) = behav_SD{j}.Occup_redefined(1);
    occup_close_SD(j) = behav_SD{j}.Occup_redefined(2);
    occup_center_SD(j) = behav_SD{j}.Occup_redefined(3);
    
    %mean time
    dur_open_SD(j) = (nanmean([End(behav_SD{j}.ZoneEpoch_redefined{1}) - Start(behav_SD{j}.ZoneEpoch_redefined{1})]))/1E4;
    dur_close_SD(j) = (nanmean([End(behav_SD{j}.ZoneEpoch_redefined{2}) - Start(behav_SD{j}.ZoneEpoch_redefined{2})]))/1E4;
    dur_center_SD(j) = (nanmean([End(behav_SD{j}.ZoneEpoch_redefined{3}) - Start(behav_SD{j}.ZoneEpoch_redefined{3})]))/1E4;
    
    %speed
    speed_open_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{1}));
    speed_close_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{2}));
    speed_center_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{3}));
    
    %entries
    for izone = 1:length(behav_SD{j}.ZoneIndices_redefined)
        if isempty(behav_SD{j}.ZoneIndices_redefined{izone})
            num_entries_SD{j}(izone) = 0;
        else
            num_entries_SD{j}(izone)=length(find(diff(behav_SD{j}.ZoneIndices_redefined{izone})>1))+1;
        end
    end
    num_entries_open_SD(j) = num_entries_SD{j}(1);
    num_entries_close_SD(j) = num_entries_SD{j}(2);
    num_entries_center_SD(j) = num_entries_SD{j}(3);
    
    %distance
    for izone = 1:length(behav_SD{j}.ZoneIndices_redefined)
        dist_SD {j}{izone} =  Data (Restrict (behav_SD{j}.Vtsd , behav_SD{j}.ZoneEpoch_redefined{izone}))*(behav_SD{j}.Occup_redefined(izone)*300);
    end
    dist_open_SD(j)= dist_SD{j}(1);
    dist_close_SD(j)= dist_SD{j}(2);
    dist_center_SD(j)= dist_SD{j}(3);
    
end

%% Mean computation SD dangerous
for j=1:length(Dir_EPM_3.path)
    mean_dur_open_SD(j) = nanmean(dur_open_SD(j));
    mean_dur_close_SD(j) = nanmean(dur_close_SD(j));
    mean_dur_center_SD(j) = nanmean(dur_center_SD(j));    
    
    mean_speed_open_SD(j) = nanmean(speed_open_SD{j});
    mean_speed_close_SD(j) = nanmean(speed_close_SD{j});
    mean_speed_center_SD(j) = nanmean(speed_center_SD{j});
    
    mean_entries_open_SD(j) = nanmean(num_entries_open_SD(j));
    mean_entries_close_SD(j) = nanmean(num_entries_close_SD(j));
    mean_entries_center_SD(j) = nanmean(num_entries_center_SD(j));
    
    mean_distance_open_SD(j) = nanmean(nanmean(dist_open_SD{j})); mean_distance_open_SD(isnan(mean_distance_open_SD)==1)=0;
    mean_distance_close_SD(j) = nanmean(nanmean(dist_close_SD{j})); mean_distance_close_SD(isnan(mean_distance_close_SD)==1)=0;
    mean_distance_center_SD(j) = nanmean(nanmean(dist_center_SD{j})); mean_distance_center_SD(isnan(mean_distance_center_SD)==1)=0;
end


%% Figures

col_basal = [1 1 1];
col_SDsafe = [.31 .38 .61]; %bleu
col_SDdanger = [.91 .53 .17]; %orange

%% Compared 2groups Baseline/SD danger

figure,
%proportion (occupancy)
subplot (231),
PlotErrorBarN_KJ({occup_open_basal*100,occup_open_SD*100,occup_close_basal*100,occup_close_SD*100,occup_center_basal*100,occup_center_SD*100},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Occupation (%)');
makepretty

[p_basal_SD_open,h]=ranksum(occup_open_basal,occup_open_SD);
% [h,p_basal_cno_open]=ttest2(occup_open_basal, occup_open_SD);
if p_basal_SD_open<0.05; sigstar_DB({[1 2]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end

[p_basal_SD_close,h]=ranksum(occup_close_basal,occup_close_SD);
% [h,p_basal_SD_close]=ttest2(occup_close_basal, occup_close_SD);
if p_basal_SD_close<0.05; sigstar_DB({[4 5]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end

[p_basal_SD_center,h]=ranksum(occup_center_basal,occup_center_SD);
% [h,p_basal_SD_center]=ttest2(occup_center_basal, occup_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[7 8]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end


%entries
subplot (232),
PlotErrorBarN_KJ({mean_entries_open_basal,mean_entries_open_SD,mean_entries_close_basal,mean_entries_close_SD,mean_entries_center_basal,mean_entries_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Nombre d entrées');
makepretty

% [p_sal_cno_open,h]=ranksum(mean_entries_open_sal,mean_entries_open_cno);
[h,p_basal_SD_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
if p_basal_SD_open<0.05; sigstar_DB({[1 2]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(mean_entries_close_sal,mean_entries_close_cno);
[h,p_basal_SD_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
if p_basal_SD_close<0.05; sigstar_DB({[4 5]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SD);
[h,p_basal_SD_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[7 8]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end


%mean time
subplot (234),
PlotErrorBarN_KJ({mean_dur_open_basal,mean_dur_open_SD,mean_dur_close_basal,mean_dur_close_SD,mean_dur_center_basal,mean_dur_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Temps moyen passé (s)');
makepretty

% [p_sal_cno_open,h]=ranksum(dur_open_basal,dur_open_SD);
[h,p_basal_SD_open]=ttest2(dur_open_basal,dur_open_SD);
if p_basal_SD_open<0.05; sigstar_DB({[1 2]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end

[p_basal_SD_close,h]=ranksum(dur_close_basal,dur_close_SD);
% [h,p_sal_cno_close]=ttest2(dur_close_sal,dur_close_cno);
if p_basal_SD_close<0.05; sigstar_DB({[4 5]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(dur_center_sal,dur_center_cno);
[h,p_basal_SD_center]=ttest2(dur_center_basal,dur_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[7 8]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end


%speed
subplot (235),
PlotErrorBarN_KJ({mean_speed_open_basal,mean_speed_open_SD,mean_speed_close_basal,mean_speed_close_SD,mean_speed_center_basal,mean_speed_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Vitesse (cm/s)');
makepretty

[p_basal_SD_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SD);
% [h,p_sal_cno_open]=ttest2(mean_speed_open_sal,mean_speed_open_cno);
if p_basal_SD_open<0.05; sigstar_DB({[1 2]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(mean_speed_close_sal,mean_speed_close_cno);
[h,p_basal_SD_close]=ttest2(mean_speed_close_basal,mean_speed_close_SD);
if p_basal_SD_close<0.05; sigstar_DB({[4 5]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(mean_speed_center_sal,mean_speed_center_cno);
[p_basal_SD_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[7 8]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end


%distance
subplot (236),
PlotErrorBarN_KJ({mean_distance_open_basal,mean_distance_open_SD,mean_distance_close_basal,mean_distance_close_SD,mean_distance_center_basal,mean_distance_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDdanger,col_basal, col_SDdanger,col_basal, col_SDdanger});
xticks([1.5 4.5 7.5]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Distance (cm)');
makepretty

[p_basal_SD_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SD);
% [h,p_sal_cno_open]=ttest2(mean_distance_open_sal,mean_distance_open_cno);
if p_basal_SD_open<0.05; sigstar_DB({[1 2]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_close,h]=ranksum(mean_distance_close_sal,mean_distance_close_cno);
[h,p_basal_SD_close]=ttest2(mean_distance_close_basal,mean_distance_close_SD);
if p_basal_SD_close<0.05; sigstar_DB({[4 5]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end

% [p_sal_cno_center,h]=ranksum(mean_distance_center_sal,mean_distance_center_cno);
[h,p_basal_SD_center]=ttest2(mean_distance_center_basal,mean_distance_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[7 8]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end

%% Compared 3 groups Baseline/SD safe /SD danger

figure,
%proportion (occupancy)
subplot (231),
PlotErrorBarN_KJ({occup_open_basal, occup_open_SDsafe, occup_open_SD,occup_close_basal ,occup_close_SDsafe,occup_close_SD,occup_center_basal ,occup_center_SDsafe,occup_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Occupation (%)');
makepretty

[p_basal_SD_open,h]=ranksum(occup_open_basal,occup_open_SD);
% [p_basal_SDsafe_open,h]=ranksum(occup_open_basal,occup_open_SDsafe);
[p_SD_SDsafe_open,h]=ranksum(occup_open_SD,occup_open_SDsafe);
% [h,p_basal_SD_open]=ttest2(occup_open_basal, occup_open_SD);
[h,p_basal_SDsafe_open]=ttest2(occup_open_basal,occup_open_SDsafe);
% [h,p_SD_SDsafe_open]=ttest2(occup_open_SD, occup_open_SDsafe);
if p_basal_SD_open<0.05; sigstar_DB({[1 3]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SD_SDsafe_open,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_close,h]=ranksum(occup_close_basal,occup_close_SD);
% [p_basal_SDsafe_close,h]=ranksum(occup_close_basal,occup_close_SDsafe);
% [p_SD_SDsafe_close,h]=ranksum(occup_close_SD,occup_close_SDsafe);
[h,p_basal_SD_close]=ttest2(occup_close_basal, occup_close_SD);
[h,p_basal_SDsafe_close]=ttest2(occup_close_basal, occup_close_SDsafe);
[h,p_SD_SDsafe_close]=ttest2(occup_close_SD, occup_close_SDsafe);
if p_basal_SD_close<0.05; sigstar_DB({[5 7]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SD_SDsafe_close,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_center,h]=ranksum(occup_center_basal,occup_center_SD);
% [p_basal_SDsafe_center,h]=ranksum(occup_center_basal,occup_center_SDsafe);
% [p_SD_SDsafe_center,h]=ranksum(occup_center_SD,occup_center_SDsafe);
[h,p_basal_SD_center]=ttest2(occup_center_basal, occup_center_SD);
[h,p_basal_SDsafe_center]=ttest2(occup_center_basal, occup_center_SDsafe);
[h,p_SD_SDsafe_center]=ttest2(occup_center_SD, occup_center_SDsafe);
if p_basal_SD_center<0.05; sigstar_DB({[9 11]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SD_SDsafe_center,0,'LineWigth',16,'StarSize',24);end


%entries
subplot (232),
PlotErrorBarN_KJ({mean_entries_open_basal,mean_entries_open_SDsafe,mean_entries_open_SD,mean_entries_close_basal,mean_entries_close_SDsafe,mean_entries_close_SD,mean_entries_center_basal,mean_entries_center_SDsafe,mean_entries_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Nombre d entrées');
makepretty

% [p_basal_SD_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SD);
[p_basal_SDsafe_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SDsafe);
[p_SD_SDsafe_open,h]=ranksum(mean_entries_open_SD,mean_entries_open_SDsafe);
[h,p_basal_SD_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
% [h,p_basal_SDsafe_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
% [h,p_SD_SDsafe_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
if p_basal_SD_open<0.05; sigstar_DB({[1 3]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SD_SDsafe_open,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SD);
[p_basal_SDsafe_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SDsafe);
[p_SD_SDsafe_close,h]=ranksum(mean_entries_close_SD,mean_entries_close_SDsafe);
[h,p_basal_SD_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
% [h,p_basal_SDsafe_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
% [h,p_SD_SDsafe_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
if p_basal_SD_close<0.05; sigstar_DB({[5 7]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SD_SDsafe_close,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SD);
[p_basal_SDsafe_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SDsafe);
[p_SD_SDsafe_center,h]=ranksum(mean_entries_center_SD,mean_entries_center_SDsafe);
[h,p_basal_SD_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
% [h,p_basal_SDsafe_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
% [h,p_SD_SDsafe_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
if p_basal_SD_center<0.05; sigstar_DB({[9 11]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SD_SDsafe_center,0,'LineWigth',16,'StarSize',24);end


%mean time
subplot (234),
PlotErrorBarN_KJ({dur_open_basal,dur_open_SDsafe,dur_open_SD,dur_close_basal,dur_close_SDsafe,dur_close_SD,dur_center_basal,dur_center_SDsafe,dur_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Temps moyen passé (s)');
makepretty

% [p_basal_SD_open,h]=ranksum(dur_open_basal,dur_open_SD);
% [p_basal_SDsafe_open,h]=ranksum(dur_open_basal,dur_open_SDsafe);
% [p_SD_SDsafe_open,h]=ranksum(dur_open_SD,dur_open_SDsafe);
[h,p_basal_SD_open]=ttest2(dur_open_basal,dur_open_SD);
[h,p_basal_SDsafe_open]=ttest2(dur_open_basal,dur_open_SDsafe);
[h,p_SD_SDsafe_open]=ttest2(dur_open_SD,dur_open_SDsafe);
if p_basal_SD_open<0.05; sigstar_DB({[1 3]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SD_SDsafe_open,0,'LineWigth',16,'StarSize',24);end

[p_basal_SD_close,h]=ranksum(dur_close_basal,dur_close_SD);
% [p_basal_SDsafe_close,h]=ranksum(dur_close_basal,dur_close_SDsafe);
[p_SD_SDsafe_close,h]=ranksum(dur_close_SD,dur_close_SDsafe);
% [h,p_basal_SD_close]=ttest2(dur_close_basal,dur_close_SD);
[h,p_basal_SDsafe_close]=ttest2(dur_close_basal,dur_close_SDsafe);
% [h,p_SD_SDsafe_close]=ttest2(dur_close_SD,dur_close_SDsafe);
if p_basal_SD_close<0.05; sigstar_DB({[5 7]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SD_SDsafe_close,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_center,h]=ranksum(dur_center_basal,dur_center_SD);
% [p_basal_SDsafe_center,h]=ranksum(dur_center_basal,dur_center_SDsafe);
% [p_SD_SDsafe_center,h]=ranksum(dur_center_SD,dur_center_SDsafe);
[h,p_basal_SD_center]=ttest2(dur_center_basal,dur_center_SD);
[h,p_basal_SDsafe_center]=ttest2(dur_center_basal,dur_center_SDsafe);
[h,p_SD_SDsafe_center]=ttest2(dur_center_SD,dur_center_SDsafe);
if p_basal_SD_center<0.05; sigstar_DB({[9 11]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SD_SDsafe_center,0,'LineWigth',16,'StarSize',24);end


%speed
subplot (235),
PlotErrorBarN_KJ({mean_speed_open_basal,mean_speed_open_SDsafe,mean_speed_open_SD,mean_speed_close_basal,mean_speed_close_SDsafe,mean_speed_close_SD,mean_speed_center_basal,mean_speed_center_SDsafe,mean_speed_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Vitesse (cm/s)');
makepretty

% [p_basal_SD_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SD);
% [p_basal_SDsafe_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SDsafe);
% [p_SD_SDsafe_open,h]=ranksum(mean_speed_open_SD,mean_speed_open_SDsafe);
[h,p_basal_SD_open]=ttest2(mean_speed_open_basal,mean_speed_open_SD);
[h,p_basal_SDsafe_open]=ttest2(mean_speed_open_basal,mean_speed_open_SDsafe);
[h,p_SD_SDsafe_open]=ttest2(mean_speed_open_SD,mean_speed_open_SDsafe);
if p_basal_SD_open<0.05; sigstar_DB({[1 3]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SD_SDsafe_open,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SD);
[p_basal_SDsafe_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SDsafe);
[p_SD_SDsafe_close,h]=ranksum(mean_speed_close_SD,mean_speed_close_SDsafe);
[h,p_basal_SD_close]=ttest2(mean_speed_close_basal,mean_speed_close_SD);
% [h,p_basal_SDsafe_close]=ttest2(mean_speed_close_basal,mean_speed_close_SDsafe);
% [h,p_SD_SDsafe_close]=ttest2(mean_speed_close_SD,mean_speed_close_SDsafe);
if p_basal_SD_close<0.05; sigstar_DB({[5 7]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SD_SDsafe_close,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SD);
% [p_basal_SDsafe_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SDsafe);
% [p_SD_SDsafe_center,h]=ranksum(mean_speed_center_SD,mean_speed_center_SDsafe);
[h,p_basal_SD_center]=ttest2(mean_speed_center_basal,mean_speed_center_SD);
[h,p_basal_SDsafe_center]=ttest2(mean_speed_center_basal,mean_speed_center_SDsafe);
[h,p_SD_SDsafe_center]=ttest2(mean_speed_center_SD,mean_speed_center_SDsafe);
if p_basal_SD_center<0.05; sigstar_DB({[9 11]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SD_SDsafe_center,0,'LineWigth',16,'StarSize',24);end


%distance
subplot (236),
PlotErrorBarN_KJ({mean_distance_open_basal,mean_distance_open_SDsafe,mean_distance_open_SD,mean_distance_close_basal,mean_distance_close_SDsafe,mean_distance_close_SD,mean_distance_center_basal,mean_distance_center_SDsafe,mean_distance_center_SD},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
xticks([2 6 10]); xticklabels ({'Bras ouvert', 'Bras fermé', 'Centre'});
title('Distance (cm)');
makepretty

[p_basal_SD_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SD);
% [p_basal_SDsafe_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SDsafe);
[p_SD_SDsafe_open,h]=ranksum(mean_distance_open_SD,mean_distance_open_SDsafe);
% [h,p_basal_SD_open]=ttest2(mean_distance_open_basal,mean_distance_open_SD);
[h,p_basal_SDsafe_open]=ttest2(mean_distance_open_basal,mean_distance_open_SDsafe);
% [h,p_SD_SDsafe_open]=ttest2(mean_distance_open_SD,mean_distance_open_SDsafe);
if p_basal_SD_open<0.05; sigstar_DB({[1 3]},p_basal_SD_open,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SD_SDsafe_open,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SD);
% [p_basal_SDsafe_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SDsafe);
% [p_SD_SDsafe_close,h]=ranksum(mean_distance_close_SD,mean_distance_close_SDsafe);
[h,p_basal_SD_close]=ttest2(mean_distance_close_basal,mean_distance_close_SD);
[h,p_basal_SDsafe_close]=ttest2(mean_distance_close_basal,mean_distance_close_SDsafe);
[h,p_SD_SDsafe_close]=ttest2(mean_distance_close_SD,mean_distance_close_SDsafe);
if p_basal_SD_close<0.05; sigstar_DB({[5 7]},p_basal_SD_close,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SD_SDsafe_close,0,'LineWigth',16,'StarSize',24);end

% [p_basal_SD_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SD);
[p_basal_SDsafe_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SDsafe);
[p_SD_SDsafe_center,h]=ranksum(mean_distance_center_SD,mean_distance_center_SDsafe);
[h,p_basal_SD_center]=ttest2(mean_distance_center_basal,mean_distance_center_SD);
% [h,p_basal_SDsafe_center]=ttest2(mean_distance_center_basal,mean_distance_center_SDsafe);
% [h,p_SD_SDsafe_center]=ttest2(mean_distance_center_SD,mean_distance_center_SDsafe);
if p_basal_SD_center<0.05; sigstar_DB({[9 11]},p_basal_SD_center,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SD_SDsafe_center,0,'LineWigth',16,'StarSize',24);end

