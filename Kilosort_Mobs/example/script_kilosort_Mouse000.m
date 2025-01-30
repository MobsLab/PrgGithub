%% script_kilosort_Mouse000

clear


data_filename = 'Experiment-Mouse000.dat';
folder_data = '/media/DataMOBsRAID/project/Mouse/day';

cd(folder_data);
folder_output = 'Spikes';
mkdir(folder_output);

[nb_groups, name_map] = channelmap_Mouse244(folder_data);

%create config file
ops = MakeConfigKS_Mouse(data_filename, folder_data, 'Nfilt', 64, 'whiteningRange',12, 'ChanMapFile', name_map);

% KiloSort
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

% save python results file for Phy
folder_results = fullfile(folder_data, folder_output);
mkdir(folder_results);
rezToPhy(rez, folder_results);
fprintf('Kilosort took %2.2f seconds \n', toc)

EditParamsKiloSort(folder_results,folder_data)
    

% phy to neurosuite format
for group_number=1:nb_groups
    ProcessKSToNeursuite(folder_data,data_filename, group_number);
end




