%% test_kilosort_Mouse743

clear


data_filename = 'M711_20180317_UMaze.dat'; % Filename of .dat with the data
folder_data = '/media/mobsrick/DataMOBS82/Mouse-711/17032018/_Concatenated/'; % Location of .dat folder
nmouse = 711;

cd(folder_data);
folder_output = 'Spikes_Kilosort'; % Name of the output folder (will be creaed inside folder_data)
mkdir(folder_output);

[nb_groups, name_map] = channelmap_Mouse711(folder_data); % which channel map?

%create config file
ops = MakeConfigKS_Mouse(data_filename, folder_data, 'Nfilt', 32, 'whiteningRange',4, 'ChanMapFile', name_map);

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
    ProcessKSToNeursuite(folder_data,data_filename, group_number, nmouse);
end


%% save and clean up
% save matlab results file for future use (although you should really only be using the manually validated spike_clusters.npy file)
save(fullfile(fpath,  'rez.mat'), 'rez', '-v7.3');

% remove temporary file
delete(ops.fproc);


