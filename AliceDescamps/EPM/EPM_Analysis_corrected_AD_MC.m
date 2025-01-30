%% Directories for EPM ZoneRedefined and XYRealigned

% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_saline');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_10h_behav_dreadd_exci_CRH_VLPO_cno');
Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_CRH_VLPO_saline');
Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_CRH_VLPO_cno');

% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_cno = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1429,1430,1431,1432])
% Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1466 1467 1468 1470])

% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SD');
% Dir_EPM_cno = RestrictPathForExperiment(Dir_EPM_3,'nMice',[1429,1430,1431,1432])

% %Comparing time of the day but also room in ctrl condition
% Dir_EPM_1 = PathForExperiments_EPM_MC ('EPM_10h_behav_dreadd_exci_saline');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1449,1450,1451,1452,1453]);
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_ctrl_EV');


% % Comparing time of the day but also room in ctrl condition + after saline injection
% Dir_EPM_1 = PathForExperiments_EPM_MC ('EPM_10h_behav_dreadd_exci_saline');
% 
% Dir_EPM_sal_inhibPFC = PathForExperiments_EPM_MC('EPM_behav_woCable_saline');
% Dir_EPM_sal_inhibPFCVLPO = PathForExperiments_EPM_MC('EPM_behav_retro_cre_saline');
% Dir_EPM_sal_inhib = MergePathForExperiment(Dir_EPM_sal_inhibPFC,Dir_EPM_sal_inhibPFCVLPO);
% 
% Dir_EPM_sal_exciPFCVLPO = PathForExperiments_EPM_MC('EPM_behav_dreadd_exci_saline');
% Dir_EPM_sal = MergePathForExperiment(Dir_EPM_sal_inhib,Dir_EPM_sal_exciPFCVLPO);
% 
% Dir_EPM_ctrl = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_ctrl = RestrictPathForExperiment(Dir_EPM_ctrl,'nMice',[1449,1450,1451,1452,1453]);
% Dir_EPM_2 = MergePathForExperiment(Dir_EPM_sal,Dir_EPM_ctrl);
% 
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_ctrl_EV');

% %Comparing plugged/unplugged
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_behav_wiCable_saline');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_behav_woCable_saline');

% %Comparing room after SDsafe
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_1 = RestrictPathForExperiment(Dir_EPM_1,'nMice',[1454,1455,1456,1457]);
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1466,1467,1468,1469,1470]);

% %Comparing ctrl, SDsafe and SDdanger
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SD');

% %Comparing ctrl and SDsafe
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');

% %Comparing ctrl and SDdanger
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SD');
% 
% %Comparing SDsafe and SDdanger
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SD');

% %Comparing SDsafe with different CD1
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_1 = RestrictPathForExperiment(Dir_EPM_1,'nMice',[1454,1456,1468,1469]);
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_2 = RestrictPathForExperiment(Dir_EPM_2,'nMice',[1466]);
% Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_3 = RestrictPathForExperiment(Dir_EPM_3,'nMice',[1453,1455,1457,1467,1470]);

% %Comparing different controls to pool them
% Dir_EPM_1 = PathForExperiments_EPM_MC ('EPM_ctrl')
% Dir_EPM_1 = RestrictPathForExperiment (Dir_EPM_1,'nMice',[1449,1450,1451,1452,1453])
% % Dir_EPM_2 = PathForExperiments_EPM_MC ('EPM_behav_woCable_saline')
% Dir_EPM_2 = PathForExperiments_EPM_MC ('EPM_ctrl_EV')
% Dir_EPM_3 = PathForExperiments_EPM_MC ('EPM_10h_behav_dreadd_exci_saline')

%Comparing ctrl and different SD
% Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
% Dir_EPM_2 = PathForExperiments_EPM_MC('EPM_Post_SDsafe');
% Dir_EPM_CD1_C57_1 = PathForExperiments_EPM_MC('EPM_Post_SD');
% Dir_EPM_CD1_C57_2 = PathForExperiments_EPM_MC('EPM_Post_SD_tetrodesPFC');
% Dir_EPM_3 = MergePathForExperiment(Dir_EPM_CD1_C57_1,Dir_EPM_CD1_C57_2);
% Dir_EPM_4 = PathForExperiments_EPM_MC('EPM_Post_SD_OneSensoryExposure');


%
%% 
% Dir_EPM_1 = PathForExperiments_EPM_alone_versus_group_MC('EPM_alone');
% Dir_EPM_3 = PathForExperiments_EPM_alone_versus_group_MC('EPM_group');

%%
% col_basal = [1 1 1];
% col_SDsafe = [1 0 0]; %rouge
% col_SDdanger = [1 .4 0]; %orange
% col_SDoneexpo = [1 .6 0]; %orange clair

% col_basal = [0 .8 .4]; %vert clair 
% col_SDsafe = [.2 .6 .2]; %vert foncé

col_basal = [.6 .6 .6]; %gris
col_SDsafe = [0 .8 .4]; %vert clair

%% Figure trajectories 
figure,
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    load ('behavResources.mat')
    subplot (2,4,i), title('Saline 13h'), axis square, xlim([-2 2]),ylim([-2 2]);
    for izone = 1:3
        hold on, plot (Data(Restrict(AlignedXtsd,ZoneEpoch{izone})),Data(Restrict(AlignedYtsd,ZoneEpoch{izone})), 'color',[.6 .6 .6]);
    end
end

for j = 1:length(Dir_EPM_2.path)
    cd(Dir_EPM_2.path{j}{1})
    load ('behavResources.mat')
    subplot (2,4,length(Dir_EPM_1.path)+j),title('CNO 13h'), axis square, xlim([-2 2]),ylim([-2 2]);
    for izone = 1:3
        hold on, 
        plot(Data(Restrict(AlignedXtsd,ZoneEpoch{izone})),Data(Restrict(AlignedYtsd,ZoneEpoch{izone})),'color',[0 .8 .4]);
%         plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[.31 .38 .61]);
    end
end
% 
% for k = 1:length(Dir_EPM_3.path)
%     cd(Dir_EPM_3.path{k}{1})
%     load ('behavResources.mat')
%     subplot (3,7,length(Dir_EPM_1.path)+j+k),title('CNO exci CRH'), axis square, xlim([-2 2]),ylim([-2 2]);
%     for izone = 1:3
%         hold on, 
%         plot(Data(Restrict(AlignedXtsd,ZoneEpoch{izone})),Data(Restrict(AlignedYtsd,ZoneEpoch{izone})),'color',[1 .4 0]);
% %         plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[.91 .53 .17]);
%     end
% end
% 
% for l = 1:length(Dir_EPM_4.path)
%     cd(Dir_EPM_4.path{l}{1})
%     load ('behavResources.mat')
%     subplot (5,9,length(Dir_EPM_1.path)+j+k+l),title('CD1'), axis square, xlim([0 100]),ylim([0 100]);
%     for izone = 1:3
%         hold on, 
%         plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[1 .6 0]);
% %         plot(Data(Restrict(Xtsd,ZoneEpoch{izone})),Data(Restrict(Ytsd,ZoneEpoch{izone})),'color',[.91 .53 .17]);
%     end
% end

%% Figure trajectories one color/zone redefined
% 
% col_open = [1 0 0];
% col_close = [.6 .6 .6];
% col_center = [0 0 1];
% 
% figure,
% for i = 1:length(Dir_EPM_1.path)
%     cd(Dir_EPM_1.path{i}{1})
%     load ('behavResources.mat')
%     subplot (4,8,i), title('Control'), axis square, xlim([0 100]),ylim([0 100]);
%     for izone = 1:3
%         hold on, plot (Data(Restrict(Xtsd,ZoneEpoch_redefined{izone})),Data(Restrict(Ytsd,ZoneEpoch_redefined{izone}))),'.','color',{col_open, col_close,col_center};
%     end
% end
% 
% for j = 1:length(Dir_EPM_2.path)
%     cd(Dir_EPM_2.path{j}{1})
%     load ('behavResources.mat')
%     subplot (4,8,length(Dir_EPM_1.path)+j),title('Post SD safe'), axis square, xlim([0 100]),ylim([0 100]);
%     for izone = 1:3
%         hold on, plot(Data(Restrict(Xtsd,ZoneEpoch_redefined{izone})),Data(Restrict(Ytsd,ZoneEpoch_redefined{izone})));
%     end
% end
% 
% for k = 1:length(Dir_EPM_3.path)
%     cd(Dir_EPM_3.path{k}{1})
%     load ('behavResources.mat')
%     subplot (4,8,length(Dir_EPM_1.path)+j+k),title('Post SD danger'), axis square, xlim([0 100]),ylim([0 100]);
%     for izone = 1:3
%         hold on, plot(Data(Restrict(Xtsd,ZoneEpoch_redefined{izone})),Data(Restrict(Ytsd,ZoneEpoch_redefined{izone})));
%     end
% end
%% EPM Baseline
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    behav_basal{i} = load ('behavResources.mat');
    
    %proportion (occupancy)
    occup_open_basal(i) = behav_basal{i}.Occup_redefined(1);
    occup_close_basal(i) = behav_basal{i}.Occup_redefined(2);
    occup_center_basal(i) = behav_basal{i}.Occup_redefined(3);
    
%     %total time
%     time_open_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{1}) - Start(behav_sal{i}.ZoneEpoch{1})]);
%     time_close_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{2}) - Start(behav_sal{i}.ZoneEpoch{2})]);
%     time_center_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{3}) - Start(behav_sal{i}.ZoneEpoch{3})]);
    
    %mean time
    dur_open_basal(i) = nanmean([End(behav_basal{i}.ZoneEpoch_redefined{1}) - Start(behav_basal{i}.ZoneEpoch_redefined{1})]);
    dur_close_basal(i) = nanmean([End(behav_basal{i}.ZoneEpoch_redefined{2}) - Start(behav_basal{i}.ZoneEpoch_redefined{2})]);
    dur_center_basal(i) = nanmean([End(behav_basal{i}.ZoneEpoch_redefined{3}) - Start(behav_basal{i}.ZoneEpoch_redefined{3})]);
    
%     %number of risk assessment
%     num_risk_basal(i) = behav_basal{i}.num_riskassessment;
    
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

%     %distance bis
%     for izone = 1:length(behav_sal{i}.ZoneIndices)
%         dist_sal_bis {i}{izone} = nansum(sqrt(diff(Data(Restrict(behav_sal{i}.Xtsd, behav_sal{i}.ZoneEpoch{izone}))).^2 +...
%             diff(Data(Restrict (behav_sal{i}.Ytsd, behav_sal{i}.ZoneEpoch{izone}))).^2));
%     end
%     dist_open_sal_bis(i)= dist_sal_bis{i}(1);
%     dist_close_sal_bis(i)= dist_sal_bis{i}(2);
%     dist_center_sal_bis(i)= dist_sal_bis{i}(3);

% num_risk_norm_basal(i) = num_risk_basal(i) / num_entries_center_basal(i);
    
end

%% Mean computation baseline
for i=1:length(Dir_EPM_1.path)
    mean_speed_open_basal(i) = nanmean(speed_open_basal{i});
    mean_speed_close_basal(i) = nanmean(speed_close_basal{i});
    mean_speed_center_basal(i) = nanmean(speed_center_basal{i});
    
    mean_entries_open_basal(i) = nanmean(num_entries_open_basal(i));
    mean_entries_close_basal(i) = nanmean(num_entries_close_basal(i));
    mean_entries_center_basal(i) = nanmean(num_entries_center_basal(i));
    
    mean_distance_open_basal(i) = nanmean(nanmean(dist_open_basal{i}));
    mean_distance_close_basal(i) = nanmean(nanmean(dist_close_basal{i}));
    mean_distance_center_basal(i) = nanmean(nanmean(dist_center_basal{i}));
    
%     mean_distance_open_sal_bis(i) = nanmean(nanmean(dist_open_sal_bis{i}));
%     mean_distance_close_sal_bis(i) = nanmean(nanmean(dist_close_sal_bis{i}));
%     mean_distance_center_sal_bis(i) = nanmean(nanmean(dist_center_sal_bis{i}));
end

%% EPM post Social Defeat safe
for i = 1:length(Dir_EPM_2.path)
    cd(Dir_EPM_2.path{i}{1})
    behav_SDsafe{i} = load ('behavResources.mat');
    
    %proportion (occupancy)
    occup_open_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(1);
    occup_close_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(2);
    occup_center_SDsafe(i) = behav_SDsafe{i}.Occup_redefined(3);
    
%     %total time
%     time_open_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{1}) - Start(behav_sal{i}.ZoneEpoch{1})]);
%     time_close_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{2}) - Start(behav_sal{i}.ZoneEpoch{2})]);
%     time_center_sal(i) = sum([End(behav_sal{i}.ZoneEpoch{3}) - Start(behav_sal{i}.ZoneEpoch{3})]);
    
    %mean time
    dur_open_SDsafe(i) = nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{1}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{1})]);
    dur_close_SDsafe(i) = nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{2}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{2})]);
    dur_center_SDsafe(i) = nanmean([End(behav_SDsafe{i}.ZoneEpoch_redefined{3}) - Start(behav_SDsafe{i}.ZoneEpoch_redefined{3})]);
    
%     %number of risk assessment
%     num_risk_SDsafe(i) = behav_SDsafe{i}.num_riskassessment;
    
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

%     %distance bis
%     for izone = 1:length(behav_sal{i}.ZoneIndices)
%         dist_sal_bis {i}{izone} = nansum(sqrt(diff(Data(Restrict(behav_sal{i}.Xtsd, behav_sal{i}.ZoneEpoch{izone}))).^2 +...
%             diff(Data(Restrict (behav_sal{i}.Ytsd, behav_sal{i}.ZoneEpoch{izone}))).^2));
%     end
%     dist_open_sal_bis(i)= dist_sal_bis{i}(1);
%     dist_close_sal_bis(i)= dist_sal_bis{i}(2);
%     dist_center_sal_bis(i)= dist_sal_bis{i}(3);

% num_risk_norm_SDsafe(i) = num_risk_SDsafe(i) / num_entries_center_SDsafe(i);
    
end

%% Mean computation SD safe
for i=1:length(Dir_EPM_2.path)
    mean_speed_open_SDsafe(i) = nanmean(speed_open_SDsafe{i});
    mean_speed_close_SDsafe(i) = nanmean(speed_close_SDsafe{i});
    mean_speed_center_SDsafe(i) = nanmean(speed_center_SDsafe{i});
    
    mean_entries_open_SDsafe(i) = nanmean(num_entries_open_SDsafe(i));
    mean_entries_close_SDsafe(i) = nanmean(num_entries_close_SDsafe(i));
    mean_entries_center_SDsafe(i) = nanmean(num_entries_center_SDsafe(i));
    
    mean_distance_open_SDsafe(i) = nanmean(nanmean(dist_open_SDsafe{i}));
    mean_distance_close_SDsafe(i) = nanmean(nanmean(dist_close_SDsafe{i}));
    mean_distance_center_SDsafe(i) = nanmean(nanmean(dist_center_SDsafe{i}));
    
%     mean_distance_open_sal_bis(i) = nanmean(nanmean(dist_open_sal_bis{i}));
%     mean_distance_close_sal_bis(i) = nanmean(nanmean(dist_close_sal_bis{i}));
%     mean_distance_center_sal_bis(i) = nanmean(nanmean(dist_center_sal_bis{i}));
end

%% EPM post Social Defeat dangerous
% for j = 1:length(Dir_EPM_3.path)
%     cd(Dir_EPM_3.path{j}{1})
%     behav_SD{j} = load ('behavResources.mat');
%     
%     %proportion (occupancy)
%     occup_open_SD(j) = behav_SD{j}.Occup_redefined(1);
%     occup_close_SD(j) = behav_SD{j}.Occup_redefined(2);
%     occup_center_SD(j) = behav_SD{j}.Occup_redefined(3);
%     
% %     %total time
% %     time_open_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{1}) - Start(behav_cno{j}.ZoneEpoch{1})]);
% %     time_close_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{2}) - Start(behav_cno{j}.ZoneEpoch{2})]);
% %     time_center_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{3}) - Start(behav_cno{j}.ZoneEpoch{3})]);
%     
%     %mean time
%     dur_open_SD(j) = nanmean([End(behav_SD{j}.ZoneEpoch_redefined{1}) - Start(behav_SD{j}.ZoneEpoch_redefined{1})]);
%     dur_close_SD(j) = nanmean([End(behav_SD{j}.ZoneEpoch_redefined{2}) - Start(behav_SD{j}.ZoneEpoch_redefined{2})]);
%     dur_center_SD(j) = nanmean([End(behav_SD{j}.ZoneEpoch_redefined{3}) - Start(behav_SD{j}.ZoneEpoch_redefined{3})]);
%     
% %     %number of risk assessment
% %     num_risk_SD(j) = behav_SD{j}.num_riskassessment;
%     
%     %speed
%     speed_open_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{1}));
%     speed_close_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{2}));
%     speed_center_SD{j} = Data(Restrict(behav_SD{j}.Vtsd, behav_SD{j}.ZoneEpoch_redefined{3}));
%     
%     %entries
%     for izone = 1:length(behav_SD{j}.ZoneIndices_redefined)
%         if isempty(behav_SD{j}.ZoneIndices_redefined{izone})
%             num_entries_SD{j}(izone) = 0;
%         else
%             num_entries_SD{j}(izone)=length(find(diff(behav_SD{j}.ZoneIndices_redefined{izone})>1))+1;
%         end
%     end
%     num_entries_open_SD(j) = num_entries_SD{j}(1);
%     num_entries_close_SD(j) = num_entries_SD{j}(2);
%     num_entries_center_SD(j) = num_entries_SD{j}(3);
%     
%     %distance
%     for izone = 1:length(behav_SD{j}.ZoneIndices_redefined)
%         dist_SD {j}{izone} =  Data (Restrict (behav_SD{j}.Vtsd , behav_SD{j}.ZoneEpoch_redefined{izone}))*(behav_SD{j}.Occup_redefined(izone)*300);
%     end
%     dist_open_SD(j)= dist_SD{j}(1);
%     dist_close_SD(j)= dist_SD{j}(2);
%     dist_center_SD(j)= dist_SD{j}(3);
%     
% end
% 
% %% Mean computation SD dangerous
% for j=1:length(Dir_EPM_3.path)
%     mean_speed_open_SD(j) = nanmean(speed_open_SD{j});
%     mean_speed_close_SD(j) = nanmean(speed_close_SD{j});
%     mean_speed_center_SD(j) = nanmean(speed_center_SD{j});
%     
%     mean_entries_open_SD(j) = nanmean(num_entries_open_SD(j));
%     mean_entries_close_SD(j) = nanmean(num_entries_close_SD(j));
%     mean_entries_center_SD(j) = nanmean(num_entries_center_SD(j));
%     
%     mean_distance_open_SD(j) = nanmean(nanmean(dist_open_SD{j})); mean_distance_open_SD(isnan(mean_distance_open_SD)==1)=0;
%     mean_distance_close_SD(j) = nanmean(nanmean(dist_close_SD{j})); mean_distance_close_SD(isnan(mean_distance_close_SD)==1)=0;
%     mean_distance_center_SD(j) = nanmean(nanmean(dist_center_SD{j})); mean_distance_center_SD(isnan(mean_distance_center_SD)==1)=0;
% end

%% EPM post Social Defeat One sensory exposure
% for j = 1:length(Dir_EPM_4.path)
%     cd(Dir_EPM_4.path{j}{1})
%     behav_SD_oneexpo{j} = load ('behavResources.mat');
%     
%     %proportion (occupancy)
%     occup_open_SD_oneexpo(j) = behav_SD_oneexpo{j}.Occup_redefined(1);
%     occup_close_SD_oneexpo(j) = behav_SD_oneexpo{j}.Occup_redefined(2);
%     occup_center_SD_oneexpo(j) = behav_SD_oneexpo{j}.Occup_redefined(3);
%     
% %     %total time
% %     time_open_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{1}) - Start(behav_cno{j}.ZoneEpoch{1})]);
% %     time_close_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{2}) - Start(behav_cno{j}.ZoneEpoch{2})]);
% %     time_center_cno(j) = sum([End(behav_cno{j}.ZoneEpoch{3}) - Start(behav_cno{j}.ZoneEpoch{3})]);
%     
%     %mean time
%     dur_open_SD_oneexpo(j) = nanmean([End(behav_SD_oneexpo{j}.ZoneEpoch_redefined{1}) - Start(behav_SD_oneexpo{j}.ZoneEpoch_redefined{1})]);
%     dur_close_SD_oneexpo(j) = nanmean([End(behav_SD_oneexpo{j}.ZoneEpoch_redefined{2}) - Start(behav_SD_oneexpo{j}.ZoneEpoch_redefined{2})]);
%     dur_center_SD_oneexpo(j) = nanmean([End(behav_SD_oneexpo{j}.ZoneEpoch_redefined{3}) - Start(behav_SD_oneexpo{j}.ZoneEpoch_redefined{3})]);
%     
% %     %number of risk assessment
% %     num_risk_SD_oneexpo(j) = behav_SD_oneexpo{j}.num_riskassessment;
%     
%     %speed
%     speed_open_SD_oneexpo{j} = Data(Restrict(behav_SD_oneexpo{j}.Vtsd, behav_SD_oneexpo{j}.ZoneEpoch_redefined{1}));
%     speed_close_SD_oneexpo{j} = Data(Restrict(behav_SD_oneexpo{j}.Vtsd, behav_SD_oneexpo{j}.ZoneEpoch_redefined{2}));
%     speed_center_SD_oneexpo{j} = Data(Restrict(behav_SD_oneexpo{j}.Vtsd, behav_SD_oneexpo{j}.ZoneEpoch_redefined{3}));
%     
%     %entries
%     for izone = 1:length(behav_SD_oneexpo{j}.ZoneIndices_redefined)
%         if isempty(behav_SD_oneexpo{j}.ZoneIndices_redefined{izone})
%             num_entries_SD_oneexpo{j}(izone) = 0;
%         else
%             num_entries_SD_oneexpo{j}(izone)=length(find(diff(behav_SD_oneexpo{j}.ZoneIndices_redefined{izone})>1))+1;
%         end
%     end
%     num_entries_open_SD_oneexpo(j) = num_entries_SD_oneexpo{j}(1);
%     num_entries_close_SD_oneexpo(j) = num_entries_SD_oneexpo{j}(2);
%     num_entries_center_SD_oneexpo(j) = num_entries_SD_oneexpo{j}(3);
%     
%     %distance
%     for izone = 1:length(behav_SD_oneexpo{j}.ZoneIndices_redefined)
%         dist_SD_oneexpo {j}{izone} =  Data (Restrict (behav_SD_oneexpo{j}.Vtsd , behav_SD_oneexpo{j}.ZoneEpoch_redefined{izone}))*(behav_SD_oneexpo{j}.Occup_redefined(izone)*300);
%     end
%     dist_open_SD_oneexpo(j)= dist_SD_oneexpo{j}(1);
%     dist_close_SD_oneexpo(j)= dist_SD_oneexpo{j}(2);
%     dist_center_SD_oneexpo(j)= dist_SD_oneexpo{j}(3);
%     
% end
% 
% %% Mean computation SD dangerous
% for j=1:length(Dir_EPM_4.path)
%     mean_speed_open_SD_oneexpo(j) = nanmean(speed_open_SD{j});
%     mean_speed_close_SD_oneexpo(j) = nanmean(speed_close_SD{j});
%     mean_speed_center_SD_oneexpo(j) = nanmean(speed_center_SD{j});
%     
%     mean_entries_open_SD_oneexpo(j) = nanmean(num_entries_open_SD_oneexpo(j));
%     mean_entries_close_SD_oneexpo(j) = nanmean(num_entries_close_SD_oneexpo(j));
%     mean_entries_center_SD_oneexpo(j) = nanmean(num_entries_center_SD_oneexpo(j));
%     
%     mean_distance_open_SD_oneexpo(j) = nanmean(nanmean(dist_open_SD_oneexpo{j})); mean_distance_open_SD_oneexpo(isnan(mean_distance_open_SD_oneexpo)==1)=0;
%     mean_distance_close_SD_oneexpo(j) = nanmean(nanmean(dist_close_SD_oneexpo{j})); mean_distance_close_SD_oneexpo(isnan(mean_distance_close_SD_oneexpo)==1)=0;
%     mean_distance_center_SD_oneexpo(j) = nanmean(nanmean(dist_center_SD_oneexpo{j})); mean_distance_center_SD_oneexpo(isnan(mean_distance_center_SD_oneexpo)==1)=0;
% end
%% Figures

% 2 GROUPS
% col_basal = [1 1 1];
% col_SDsafe = [.91 .53 .17]; %orange

col_basal = [0 .8 .4]; %vert clair 
col_SDsafe = [.2 .6 .2]; %vert foncé


% 3 GROUPS
% col_basal = [1 1 1];
% col_SDsafe = [.31 .38 .61]; %bleu
% col_SDdanger = [.91 .53 .17]; %orange


% col_SDsafe = [1 .6 .4]; %beige
% col_SDdanger = [1 .2 .2]; %rose

% 4 GROUPS
% col_basal = [1 1 1];
% col_SDsafe = [1 0 0]; %rouge
% col_SDdanger = [1 .4 0]; %orange
% col_SDoneexpo = [1 .6 0]; %orange clair

%% Figure Compared 2groups Baseline/SD danger

figure,
%proportion (occupancy)
subplot (231),
PlotErrorBarN_MC({occup_open_basal,occup_open_SDsafe,occup_close_basal,occup_close_SDsafe,occup_center_basal,occup_center_SDsafe},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDsafe,col_basal, col_SDsafe,col_basal, col_SDsafe});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Occupancy');
makepretty

[p_sal_cno_open,h]=signrank(occup_open_basal,occup_open_SDsafe);
% [p_sal_cno_open,h]=ranksum(occup_open_basal,occup_open_SDsafe);
% [h,p_sal_cno_open]=ttest2(occup_open_basal,occup_open_SDsafe);
% [h,p_sal_cno_open]=ttest(occup_open_basal,occup_open_SDsafe);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_close,h]=signrank(occup_close_basal,occup_close_SDsafe);
% [p_sal_cno_close,h]=ranksum(occup_close_basal,occup_close_SDsafe);
% [h,p_sal_cno_close]=ttest2(occup_close_basal, occup_close_SDsafe);
% [h,p_sal_cno_close]=ttest(occup_close_basal, occup_close_SDsafe);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_center,h]=signrank(occup_center_basal,occup_center_SDsafe);
% [p_sal_cno_center,h]=ranksum(occup_center_basal,occup_center_SDsafe);
% [h,p_sal_cno_center]=ttest2(occup_center_basal, occup_center_SDsafe);
% [h,p_sal_cno_center]=ttest(occup_center_basal, occup_center_SDsafe);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%entries
subplot (232),
PlotErrorBarN_MC({mean_entries_open_basal,mean_entries_open_SDsafe,mean_entries_close_basal,mean_entries_close_SDsafe,mean_entries_center_basal,mean_entries_center_SDsafe},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDsafe,col_basal, col_SDsafe,col_basal, col_SDsafe});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Number of entries');
makepretty

[p_sal_cno_open,h]=signrank(mean_entries_open_basal,mean_entries_open_SDsafe);
% [p_sal_cno_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SDsafe);
% [h,p_sal_cno_open]=ttest2(mean_entries_open_basal,mean_entries_open_SDsafe);
% [h,p_sal_cno_open]=ttest(mean_entries_open_basal,mean_entries_open_SDsafe);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_close,h]=signrank(mean_entries_close_basal,mean_entries_close_SDsafe);
% [p_sal_cno_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SDsafe);
% [h,p_sal_cno_close]=ttest2(mean_entries_close_basal,mean_entries_close_SDsafe);
% [h,p_sal_cno_close]=ttest(mean_entries_close_basal,mean_entries_close_SDsafe);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_center,h]=signrank(mean_entries_center_basal,mean_entries_center_SDsafe);
% [p_sal_cno_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SDsafe);
% [h,p_sal_cno_center]=ttest2(mean_entries_center_basal,mean_entries_center_SDsafe);
% [h,p_sal_cno_center]=ttest(mean_entries_center_basal,mean_entries_center_SDsafe);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end

% 
% %risk assessment
% subplot (233),
% PlotErrorBarN_MC({num_risk_basal,num_risk_SDsafe,NaN,NaN,NaN,NaN},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_sal, col_cno,col_sal, col_cno,col_sal, col_cno});
% xticks([1.5 4.5 7.5]); xticklabels ({'Center', '', ''});
% title('Number of risk assessments');
% % makepretty
% 
% % [p_sal_cno_center,h]=ranksum(num_risk_basal,num_risk_SDsafe);
% [h,p_sal_cno_center]=ttest2(num_risk_basal,num_risk_SDsafe);
% if p_sal_cno_center<0.05; sigstar_DB({[1 2]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end

%mean time
subplot (234),
PlotErrorBarN_MC({dur_open_basal,dur_open_SDsafe,dur_close_basal,dur_close_SDsafe,dur_center_basal,dur_center_SDsafe},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDsafe,col_basal, col_SDsafe,col_basal, col_SDsafe});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Mean time');
makepretty

[p_sal_cno_open,h]=signrank(dur_open_basal,dur_open_SDsafe);
% [p_sal_cno_open,h]=ranksum(dur_open_basal,dur_open_SDsafe);
% [h,p_sal_cno_open]=ttest2(dur_open_basal,dur_open_SDsafe);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_close,h]=signrank(dur_close_basal,dur_close_SDsafe);
% [p_sal_cno_close,h]=ranksum(dur_close_basal,dur_close_SDsafe);
% [h,p_sal_cno_close]=ttest2(dur_close_basal,dur_close_SDsafe);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_center,h]=signrank(dur_center_basal,dur_center_SDsafe);
% [p_sal_cno_center,h]=ranksum(dur_center_basal,dur_center_SDsafe);
% [h,p_sal_cno_center]=ttest2(dur_center_basal,dur_center_SDsafe);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%speed
subplot (235),
PlotErrorBarN_MC({mean_speed_open_basal,mean_speed_open_SDsafe,mean_speed_close_basal,mean_speed_close_SDsafe,mean_speed_center_basal,mean_speed_center_SDsafe},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDsafe,col_basal, col_SDsafe,col_basal, col_SDsafe});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Speed');
makepretty

[p_sal_cno_open,h]=signrank(mean_speed_open_basal,mean_speed_open_SDsafe);
% [p_sal_cno_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SDsafe);
% [h,p_sal_cno_open]=ttest2(mean_speed_open_basal,mean_speed_open_SDsafe);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_close,h]=signrank(mean_speed_close_basal,mean_speed_close_SDsafe);
% [p_sal_cno_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SDsafe);
% [h,p_sal_cno_close]=ttest2(mean_speed_close_basal,mean_speed_close_SDsafe);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_center,h]=signrank(mean_speed_center_basal,mean_speed_center_SDsafe);
% [p_sal_cno_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SDsafe);
% [p_sal_cno_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SDsafe);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end


%distance
subplot (236),
PlotErrorBarN_MC({mean_distance_open_basal,mean_distance_open_SDsafe,mean_distance_close_basal,mean_distance_close_SDsafe,mean_distance_center_basal,mean_distance_center_SDsafe},...
    'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_basal, col_SDsafe,col_basal, col_SDsafe,col_basal, col_SDsafe});
xticks([1.5 4.5 7.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
title('Distance');
makepretty

[p_sal_cno_open,h]=signrank(mean_distance_open_basal,mean_distance_open_SDsafe);
% [p_sal_cno_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SDsafe);
% [h,p_sal_cno_open]=ttest2(mean_distance_open_basal,mean_distance_open_SDsafe);
if p_sal_cno_open<0.05; sigstar_DB({[1 2]},p_sal_cno_open,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_close,h]=signrank(mean_distance_close_basal,mean_distance_close_SDsafe);
% [p_sal_cno_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SDsafe);
% [h,p_sal_cno_close]=ttest2(mean_distance_close_basal,mean_distance_close_SDsafe);
if p_sal_cno_close<0.05; sigstar_DB({[4 5]},p_sal_cno_close,0,'LineWigth',16,'StarSize',24);end

[p_sal_cno_center,h]=signrank(mean_distance_center_basal,mean_distance_center_SDsafe);
% [p_sal_cno_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SDsafe);
% [h,p_sal_cno_center]=ttest2(mean_distance_center_basal,mean_distance_center_SDsafe);
if p_sal_cno_center<0.05; sigstar_DB({[7 8]},p_sal_cno_center,0,'LineWigth',16,'StarSize',24);end

% 
%% Compared 3 groups Baseline/SD safe /SD danger
% 
% figure,
% %proportion (occupancy)
% subplot (231),
% PlotErrorBarN_MC({occup_open_basal, occup_open_SDsafe, occup_open_SD,occup_close_basal ,occup_close_SDsafe,occup_close_SD,occup_center_basal ,occup_center_SDsafe,occup_center_SD},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
% xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Occupancy');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(occup_open_basal,occup_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(occup_open_basal, occup_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(occup_open_basal,occup_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(occup_open_basal, occup_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_open,h]=ranksum(occup_open_SDsafe,occup_open_SD);
% % [h,p_SDdanger_SDsafe_open]=ttest2(occup_open_SDsafe, occup_open_SD);
% if p_SDdanger_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SDdanger_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(occup_close_basal,occup_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(occup_close_basal, occup_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(occup_close_basal,occup_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(occup_close_basal, occup_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_close,h]=ranksum(occup_close_SDsafe,occup_close_SD);
% % [h,p_SDdanger_SDsafe_close]=ttest2(occup_close_SDsafe, occup_close_SD);
% if p_SDdanger_SDsafe_close<0.05; sigstar_DB({[6 7]},p_SDdanger_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(occup_center_basal,occup_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(occup_center_basal, occup_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(occup_center_basal,occup_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(occup_center_basal, occup_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_center,h]=ranksum(occup_center_SDsafe,occup_center_SD);
% % [h,p_SDdanger_SDsafe_center]=ttest2(occup_center_SDsafe, occup_center_SD);
% if p_SDdanger_SDsafe_center<0.05; sigstar_DB({[10 11]},p_SDdanger_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% 
% 
% %entries
% subplot (232),
% PlotErrorBarN_MC({mean_entries_open_basal,mean_entries_open_SDsafe,mean_entries_open_SD,mean_entries_close_basal,mean_entries_close_SDsafe,mean_entries_close_SD,mean_entries_center_basal,mean_entries_center_SDsafe,mean_entries_center_SD},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
% xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Number of entries');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_entries_open_basal,mean_entries_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_entries_open_SDsafe,mean_entries_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_entries_open_SDsafe,mean_entries_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_entries_close_basal,mean_entries_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_entries_close_SDsafe,mean_entries_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_entries_close_SDsafe,mean_entries_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[6 7]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(mean_entries_center_basal,mean_entries_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_entries_center_SDsafe,mean_entries_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(mean_entries_center_SDsafe,mean_entries_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[10 11]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 
% % %risk assessment
% % subplot (233),
% % PlotErrorBarN_MC({num_risk_sal,num_risk_cno,NaN,NaN,NaN,NaN},...
% %     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_sal, col_cno,col_sal, col_cno,col_sal, col_cno});
% % xticks([1.5 4.5 7.5]); xticklabels ({'Center', '', ''});
% % title('Number of risk assessments');
% % makepretty
% % 
% % % [p_basal_SDdanger_center,h]=ranksum(num_risk_sal,num_risk_cno);
% % [h,p_basal_SDdanger_center]=ttest2(num_risk_sal,num_risk_cno);
% % if p_basal_SDdanger_center<0.05; sigstar_DB({[1 2]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 
% %mean time
% subplot (234),
% PlotErrorBarN_MC({dur_open_basal,dur_open_SDsafe,dur_open_SD,dur_close_basal,dur_close_SDsafe,dur_close_SD,dur_center_basal,dur_center_SDsafe,dur_center_SD},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
% xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Mean time');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(dur_open_basal,dur_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(dur_open_basal,dur_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(dur_open_basal,dur_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(dur_open_basal,dur_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(dur_open_SDsafe,dur_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(dur_open_SDsafe,dur_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(dur_close_basal,dur_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(dur_close_basal,dur_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(dur_close_basal,dur_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(dur_close_basal,dur_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(dur_close_SDsafe,dur_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(dur_close_SDsafe,dur_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[6 7]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(dur_center_basal,dur_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(dur_center_basal,dur_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(dur_center_basal,dur_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(dur_center_basal,dur_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(dur_center_SDsafe,dur_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(dur_center_SDsafe,dur_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[10 11]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 
% 
% %speed
% subplot (235),
% PlotErrorBarN_MC({mean_speed_open_basal,mean_speed_open_SDsafe,mean_speed_open_SD,mean_speed_close_basal,mean_speed_close_SDsafe,mean_speed_close_SD,mean_speed_center_basal,mean_speed_center_SDsafe,mean_speed_center_SD},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
% xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Speed');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_speed_open_basal,mean_speed_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_speed_open_basal,mean_speed_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_speed_open_SDsafe,mean_speed_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_speed_open_SDsafe,mean_speed_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_speed_close_basal,mean_speed_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_speed_close_basal,mean_speed_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_speed_close_SDsafe,mean_speed_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_speed_close_SDsafe,mean_speed_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[6 7]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SD);
% % [p_basal_SDdanger_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SDsafe);
% % [p_basal_SDsafe_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_speed_center_SDsafe,mean_speed_center_SD);
% % [p_SDsafe_SDdanger_center,h]=ttest2(mean_speed_center_SDsafe,mean_speed_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[10 11]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 
% 
% %distance
% subplot (236),
% PlotErrorBarN_MC({mean_distance_open_basal,mean_distance_open_SDsafe,mean_distance_open_SD,mean_distance_close_basal,mean_distance_close_SDsafe,mean_distance_close_SD,mean_distance_center_basal,mean_distance_center_SDsafe,mean_distance_center_SD},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:3,5:7,9:11],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_basal,col_SDsafe, col_SDdanger,col_basal, col_SDsafe,col_SDdanger});
% xticks([2 6 10]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Distance (cm)');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_distance_open_basal,mean_distance_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_distance_open_basal,mean_distance_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_distance_open_SDsafe,mean_distance_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_distance_open_SDsafe,mean_distance_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_distance_close_basal,mean_distance_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[5 7]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_distance_close_basal,mean_distance_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[5 6]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_distance_close_SDsafe,mean_distance_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_distance_close_SDsafe,mean_distance_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[6 7]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(mean_distance_center_basal,mean_distance_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[9 11]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(mean_distance_center_basal,mean_distance_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[9 10]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_distance_center_SDsafe,mean_distance_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(mean_distance_center_SDsafe,mean_distance_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[10 11]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 


%% Compared 4 groups Baseline/SD safe /SD danger /SD one expo
% 
% figure,
% %proportion (occupancy)
% subplot (231),
% PlotErrorBarN_MC({occup_open_basal, occup_open_SDsafe, occup_open_SD, occup_open_SD_oneexpo, occup_close_basal ,occup_close_SDsafe,occup_close_SD,occup_close_SD_oneexpo, occup_center_basal ,occup_center_SDsafe,occup_center_SD,occup_center_SD_oneexpo},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo, col_basal,col_SDsafe, col_SDdanger,col_SDoneexpo,col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo});
% xticks([2.5 7.5 12.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Occupancy');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(occup_open_basal,occup_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(occup_open_basal, occup_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(occup_open_basal,occup_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(occup_open_basal, occup_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_open,h]=ranksum(occup_open_SDsafe,occup_open_SD);
% % [h,p_SDdanger_SDsafe_open]=ttest2(occup_open_SDsafe, occup_open_SD);
% if p_SDdanger_SDsafe_open<0.05; sigstar_DB({[2 3]},p_SDdanger_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(occup_open_basal,occup_open_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(occup_open_basal, occup_open_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[1 4]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(occup_open_SDsafe,occup_open_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(occup_open_SDsafe,occup_open_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[2 4]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(occup_open_SD,occup_open_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(occup_open_SD,occup_open_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[3 4]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% [p_basal_SDdanger_close,h]=ranksum(occup_close_basal,occup_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(occup_close_basal, occup_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[6 8]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(occup_close_basal,occup_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(occup_close_basal, occup_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[6 7]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_close,h]=ranksum(occup_close_SDsafe,occup_close_SD);
% % [h,p_SDdanger_SDsafe_close]=ttest2(occup_close_SDsafe, occup_close_SD);
% if p_SDdanger_SDsafe_close<0.05; sigstar_DB({[7 8]},p_SDdanger_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(occup_close_basal,occup_close_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(occup_close_basal, occup_close_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[6 9]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(occup_close_SDsafe,occup_close_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(occup_close_SDsafe,occup_close_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[7 9]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(occup_close_SD,occup_close_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(occup_close_SD,occup_close_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[8 9]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(occup_center_basal,occup_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(occup_center_basal, occup_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[11 13]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(occup_center_basal,occup_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(occup_center_basal, occup_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[11 12]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDsafe_center,h]=ranksum(occup_center_SDsafe,occup_center_SD);
% % [h,p_SDdanger_SDsafe_center]=ttest2(occup_center_SDsafe, occup_center_SD);
% if p_SDdanger_SDsafe_center<0.05; sigstar_DB({[12 13]},p_SDdanger_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(occup_center_basal,occup_center_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(occup_center_basal, occup_center_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[11 14]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(occup_center_SDsafe,occup_center_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(occup_center_SDsafe,occup_center_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[12 14]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(occup_center_SD,occup_center_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(occup_center_SD,occup_center_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[13 14]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% %entries
% subplot (232),
% PlotErrorBarN_MC({mean_entries_open_basal,mean_entries_open_SDsafe,mean_entries_open_SD,mean_entries_open_SD_oneexpo,mean_entries_close_basal,mean_entries_close_SDsafe,mean_entries_close_SD,mean_entries_close_SD_oneexpo,mean_entries_center_basal,mean_entries_center_SDsafe,mean_entries_center_SD,mean_entries_center_SD_oneexpo},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo, col_basal,col_SDsafe, col_SDdanger,col_SDoneexpo,col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo});
% xticks([2.5 7.5 12.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Number of entries');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_entries_open_basal,mean_entries_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_entries_open_basal,mean_entries_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_entries_open_basal,mean_entries_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_entries_open_SDsafe,mean_entries_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_entries_open_SDsafe,mean_entries_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_entries_open_basal,mean_entries_open_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_entries_open_basal,mean_entries_open_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[1 4]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_entries_open_SDsafe,mean_entries_open_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_entries_open_SDsafe,mean_entries_open_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[2 4]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_entries_open_SD,mean_entries_open_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_entries_open_SD,mean_entries_open_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[3 4]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_entries_close_basal,mean_entries_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[6 8]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_entries_close_basal,mean_entries_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_entries_close_basal,mean_entries_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[6 7]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_entries_close_SDsafe,mean_entries_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_entries_close_SDsafe,mean_entries_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[7 8]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_entries_close_basal,mean_entries_close_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_entries_close_basal,mean_entries_close_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[6 9]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_entries_close_SDsafe,mean_entries_close_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_entries_close_SDsafe,mean_entries_close_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[7 9]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_entries_close_SD,mean_entries_close_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_entries_close_SD,mean_entries_close_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[8 9]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(mean_entries_center_basal,mean_entries_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[11 13]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_entries_center_basal,mean_entries_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(mean_entries_center_basal,mean_entries_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[11 12]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_entries_center_SDsafe,mean_entries_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(mean_entries_center_SDsafe,mean_entries_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[12 13]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_entries_center_basal,mean_entries_center_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_entries_center_basal,mean_entries_center_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[11 14]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_entries_center_SDsafe,mean_entries_center_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_entries_center_SDsafe,mean_entries_center_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[12 14]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_entries_center_SD,mean_entries_center_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_entries_center_SD,mean_entries_center_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[13 14]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% % %risk assessment
% % subplot (233),
% % PlotErrorBarN_MC({num_risk_sal,num_risk_cno,NaN,NaN,NaN,NaN},...
% %     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:2,4:5,7:8],'barcolors',{col_sal, col_cno,col_sal, col_cno,col_sal, col_cno});
% % xticks([1.5 4.5 7.5]); xticklabels ({'Center', '', ''});
% % title('Number of risk assessments');
% % makepretty
% % 
% % % [p_basal_SDdanger_center,h]=ranksum(num_risk_sal,num_risk_cno);
% % [h,p_basal_SDdanger_center]=ttest2(num_risk_sal,num_risk_cno);
% % if p_basal_SDdanger_center<0.05; sigstar_DB({[1 2]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% 
% %mean time
% subplot (234),
% PlotErrorBarN_MC({dur_open_basal,dur_open_SDsafe,dur_open_SD,dur_open_SD_oneexpo,dur_close_basal,dur_close_SDsafe,dur_close_SD,dur_close_SD_oneexpo,dur_center_basal,dur_center_SDsafe,dur_center_SD,dur_center_SD_oneexpo},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo, col_basal,col_SDsafe, col_SDdanger,col_SDoneexpo,col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo});
% xticks([2.5 7.5 12.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Mean time');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(dur_open_basal,dur_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(dur_open_basal,dur_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(dur_open_basal,dur_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(dur_open_basal,dur_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(dur_open_SDsafe,dur_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(dur_open_SDsafe,dur_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(dur_open_basal,dur_open_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(dur_open_basal,dur_open_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[1 4]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(dur_open_SDsafe,dur_open_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(dur_open_SDsafe,dur_open_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[2 4]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(dur_open_SD,dur_open_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(dur_open_SD,dur_open_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[3 4]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(dur_close_basal,dur_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(dur_close_basal,dur_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[6 8]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(dur_close_basal,dur_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(dur_close_basal,dur_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[6 7]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(dur_close_SDsafe,dur_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(dur_close_SDsafe,dur_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[7 8]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(dur_close_basal,dur_close_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(dur_close_basal,dur_close_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[6 9]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(dur_close_SDsafe,dur_close_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(dur_close_SDsafe,dur_close_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[7 9]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(dur_close_SD,dur_close_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(dur_close_SD,dur_close_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[8 9]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(dur_center_basal,dur_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(dur_center_basal,dur_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[11 13]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(dur_center_basal,dur_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(dur_center_basal,dur_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[11 12]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(dur_center_SDsafe,dur_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(dur_center_SDsafe,dur_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[12 13]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(dur_center_basal,dur_center_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(dur_center_basal,dur_center_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[11 14]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(dur_center_SDsafe,dur_center_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(dur_center_SDsafe,dur_center_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[12 14]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(dur_center_SD,dur_center_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(dur_center_SD,dur_center_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[13 14]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% %speed
% subplot (235),
% PlotErrorBarN_MC({mean_speed_open_basal,mean_speed_open_SDsafe,mean_speed_open_SD,mean_speed_open_SD_oneexpo,mean_speed_close_basal,mean_speed_close_SDsafe,mean_speed_close_SD,mean_speed_close_SD_oneexpo,mean_speed_center_basal,mean_speed_center_SDsafe,mean_speed_center_SD,mean_speed_center_SD_oneexpo},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo, col_basal,col_SDsafe, col_SDdanger,col_SDoneexpo,col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo});
% xticks([2.5 7.5 12.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Speed');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_speed_open_basal,mean_speed_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_speed_open_basal,mean_speed_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_speed_open_basal,mean_speed_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_speed_open_SDsafe,mean_speed_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_speed_open_SDsafe,mean_speed_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_speed_open_basal,mean_speed_open_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_speed_open_basal,mean_speed_open_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[1 4]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_speed_open_SDsafe,mean_speed_open_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_speed_open_SDsafe,mean_speed_open_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[2 4]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_speed_open_SD,mean_speed_open_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_speed_open_SD,mean_speed_open_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[3 4]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_speed_close_basal,mean_speed_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[6 8]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_speed_close_basal,mean_speed_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_speed_close_basal,mean_speed_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[6 7]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_speed_close_SDsafe,mean_speed_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_speed_close_SDsafe,mean_speed_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[7 8]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_speed_close_basal,mean_speed_close_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_speed_close_basal,mean_speed_close_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[6 9]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_speed_close_SDsafe,mean_speed_close_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_speed_close_SDsafe,mean_speed_close_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[7 9]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_speed_close_SD,mean_speed_close_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_speed_close_SD,mean_speed_close_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[8 9]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SD);
% % [p_basal_SDdanger_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[11 13]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_speed_center_basal,mean_speed_center_SDsafe);
% % [p_basal_SDsafe_center,h]=ttest2(mean_speed_center_basal,mean_speed_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[11 12]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_speed_center_SDsafe,mean_speed_center_SD);
% % [p_SDsafe_SDdanger_center,h]=ttest2(mean_speed_center_SDsafe,mean_speed_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[12 13]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_speed_center_basal,mean_speed_center_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_speed_center_basal,mean_speed_center_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[11 14]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_speed_center_SDsafe,mean_speed_center_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_speed_center_SDsafe,mean_speed_center_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[12 14]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_speed_center_SD,mean_speed_center_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_speed_center_SD,mean_speed_center_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[13 14]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% 
% 
% %distance
% subplot (236),
% PlotErrorBarN_MC({mean_distance_open_basal,mean_distance_open_SDsafe,mean_distance_open_SD,mean_distance_open_SD_oneexpo,mean_distance_close_basal,mean_distance_close_SDsafe,mean_distance_close_SD,mean_distance_close_SD_oneexpo,mean_distance_center_basal,mean_distance_center_SDsafe,mean_distance_center_SD,mean_distance_center_SD_oneexpo},...
%     'newfig',0,'paired',0,'ShowSigstar','none','x_data',[1:4,6:9,11:14],'barcolors',{col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo, col_basal,col_SDsafe, col_SDdanger,col_SDoneexpo,col_basal, col_SDsafe,col_SDdanger,col_SDoneexpo});
% xticks([2.5 7.5 12.5]); xticklabels ({'Open arm', 'Close arm', 'Center'});
% title('Distance (cm)');
% makepretty
% 
% [p_basal_SDdanger_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SD);
% % [h,p_basal_SDdanger_open]=ttest2(mean_distance_open_basal,mean_distance_open_SD);
% if p_basal_SDdanger_open<0.05; sigstar_DB({[1 3]},p_basal_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_open,h]=ranksum(mean_distance_open_basal,mean_distance_open_SDsafe);
% % [h,p_basal_SDsafe_open]=ttest2(mean_distance_open_basal,mean_distance_open_SDsafe);
% if p_basal_SDsafe_open<0.05; sigstar_DB({[1 2]},p_basal_SDsafe_open,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_open,h]=ranksum(mean_distance_open_SDsafe,mean_distance_open_SD);
% % [h,p_SDsafe_SDdanger_open]=ttest2(mean_distance_open_SDsafe,mean_distance_open_SD);
% if p_SDsafe_SDdanger_open<0.05; sigstar_DB({[2 3]},p_SDsafe_SDdanger_open,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_distance_open_basal,mean_distance_open_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_distance_open_basal,mean_distance_open_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[1 4]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_distance_open_SDsafe,mean_distance_open_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_distance_open_SDsafe,mean_distance_open_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[2 4]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_distance_open_SD,mean_distance_open_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_distance_open_SD,mean_distance_open_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[3 4]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SD);
% % [h,p_basal_SDdanger_close]=ttest2(mean_distance_close_basal,mean_distance_close_SD);
% if p_basal_SDdanger_close<0.05; sigstar_DB({[6 8]},p_basal_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_close,h]=ranksum(mean_distance_close_basal,mean_distance_close_SDsafe);
% % [h,p_basal_SDsafe_close]=ttest2(mean_distance_close_basal,mean_distance_close_SDsafe);
% if p_basal_SDsafe_close<0.05; sigstar_DB({[6 7]},p_basal_SDsafe_close,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_close,h]=ranksum(mean_distance_close_SDsafe,mean_distance_close_SD);
% % [h,p_SDsafe_SDdanger_close]=ttest2(mean_distance_close_SDsafe,mean_distance_close_SD);
% if p_SDsafe_SDdanger_close<0.05; sigstar_DB({[7 8]},p_SDsafe_SDdanger_close,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_distance_close_basal,mean_distance_close_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_distance_close_basal,mean_distance_close_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[6 9]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_distance_close_SDsafe,mean_distance_close_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_distance_close_SDsafe,mean_distance_close_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[7 9]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_distance_close_SD,mean_distance_close_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_distance_close_SD,mean_distance_close_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[8 9]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% 
% [p_basal_SDdanger_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SD);
% % [h,p_basal_SDdanger_center]=ttest2(mean_distance_center_basal,mean_distance_center_SD);
% if p_basal_SDdanger_center<0.05; sigstar_DB({[11 13]},p_basal_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDsafe_center,h]=ranksum(mean_distance_center_basal,mean_distance_center_SDsafe);
% % [h,p_basal_SDsafe_center]=ttest2(mean_distance_center_basal,mean_distance_center_SDsafe);
% if p_basal_SDsafe_center<0.05; sigstar_DB({[11 12]},p_basal_SDsafe_center,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDdanger_center,h]=ranksum(mean_distance_center_SDsafe,mean_distance_center_SD);
% % [h,p_SDsafe_SDdanger_center]=ttest2(mean_distance_center_SDsafe,mean_distance_center_SD);
% if p_SDsafe_SDdanger_center<0.05; sigstar_DB({[12 13]},p_SDsafe_SDdanger_center,0,'LineWigth',16,'StarSize',24);end
% [p_basal_SDoneexpo,h]=ranksum(mean_distance_center_basal,mean_distance_center_SD_oneexpo);
% % [h,p_basal_SDoneexpo]=ttest2(mean_distance_center_basal,mean_distance_center_SD_oneexpo);
% if p_basal_SDoneexpo<0.05; sigstar_DB({[11 14]},p_basal_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDsafe_SDoneexpo,h]=ranksum(mean_distance_center_SDsafe,mean_distance_center_SD_oneexpo);
% % [h,p_SDsafe_SDoneexpo]=ttest2(mean_distance_center_SDsafe,mean_distance_center_SD_oneexpo);
% if p_SDsafe_SDoneexpo<0.05; sigstar_DB({[12 14]},p_SDsafe_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
% [p_SDdanger_SDoneexpo,h]=ranksum(mean_distance_center_SD,mean_distance_center_SD_oneexpo);
% % [h,p_SDdanger_SDoneexpo]=ttest2(mean_distance_center_SD,mean_distance_center_SD_oneexpo);
% if p_SDdanger_SDoneexpo<0.05; sigstar_DB({[13 14]},p_SDdanger_SDoneexpo,0,'LineWigth',16,'StarSize',24);end
