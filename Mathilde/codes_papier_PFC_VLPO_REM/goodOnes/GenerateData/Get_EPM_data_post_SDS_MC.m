%% input dir
Dir_EPM_1 = PathForExperiments_EPM_MC('EPM_ctrl');
Dir_EPM_3 = PathForExperiments_EPM_MC('EPM_Post_SD');

%% EPM control
for i = 1:length(Dir_EPM_1.path)
    cd(Dir_EPM_1.path{i}{1})
    behav_basal{i} = load ('behavResources.mat');
    %proportion (occupancy)
    occup_open_basal(i) = behav_basal{i}.Occup_redefined(1);
end

%% EPM post Social Defeat
for j = 1:length(Dir_EPM_3.path)
    cd(Dir_EPM_3.path{j}{1})
    behav_SD{j} = load ('behavResources.mat');
    %proportion (occupancy)
    occup_open_SD(j) = behav_SD{j}.Occup_redefined(1);
end