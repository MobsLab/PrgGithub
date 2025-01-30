%% test_kilosort_Mouse743

clear


data_filename = 'ERC-Mouse-743-01062018-Hab_SpikeRef.dat'; % Filename of .dat with the data
folder_data = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-743/test_tetrode/'; % Location of .dat folder

cd(folder_data);
folder_output = 'Spikes_DB_right'; % Name of the output folder (will be creaed inside folder_data)
mkdir(folder_output);

[nb_groups, name_map] = channelmap_Mouse743_right(folder_data); % which channel map?

%create config file
ops = MakeConfigKS_Mouse(data_filename, folder_data, 'Nfilt', 64, 'whiteningRange',Inf, 'ChanMapFile', name_map);

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
    

% % phy to neurosuite format
% for group_number=1:nb_groups
%     ProcessKSToNeursuite(folder_data,data_filename, group_number);
% end




