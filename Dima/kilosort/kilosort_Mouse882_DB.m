%% test_kilosort_Mouse743

clear


data_filename = 'M882_20190409_Hab.dat'; % Filename of .dat with the data
folder_data = '/media/mobsrick/DataMOBS101/Mouse-882/20190409/Hab/_Concatenated/'; % Location of .dat folder

cd(folder_data);
basepath = cd;
[~,basename] = fileparts(basepath);
folder_output = 'Spikes_Kilosort'; % Name of the output folder (will be creaed inside folder_data)
savepath = folder_output;
mkdir(folder_output);

[nb_groups, name_map] = channelmap_Mouse828(folder_data); % which channel map?

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
    

% %phy to neurosuite format
% for group_number=1:nb_groups
%     ProcessKSToNeursuite(folder_data,data_filename, group_number);
% end


%% save and clean up
% save matlab results file for future use (although you should really only be using the manually validated spike_clusters.npy file)
rez.ops.basepath = basepath;
rez.ops.basename = basename;
rez.ops.savepath = savepath;rez.ops.root = pwd;
rez.ops.fbinary = fullfile(pwd, [basename,'.dat']);
save(fullfile(folder_output,  'rez.mat'), 'rez', '-v7.3');

% remove temporary file
delete(ops.fproc);


