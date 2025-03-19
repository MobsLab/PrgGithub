%% test_kilosort_Mouse244

clear


data_filename = 'Breath-Mouse-244-31032015.dat';
folder_data = '/home/mobsjunior/Documents/MATLAB/kilosort/M244_long_sleep/';

cd(folder_data);
mkdir('Spikes');

nb_tetrodes = channelmap_Mouse244(folder_data);

%create config file
ops = MakeConfigKS_Mouse(data_filename, folder_data, 'Nfilt', 64, 'whiteningRange',12);

% KiloSort
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

% save python results file for Phy
folder_tetrode = fullfile(folder_data,'Spikes');
mkdir(folder_tetrode);
rezToPhy(rez, folder_tetrode);
fprintf('Kilosort took %2.2f seconds \n', toc)

EditParamsKiloSort(folder_tetrode,folder_data)
    

% phy to neurosuite format
for tet_number=1:nb_tetrodes
    ProcessKSToNeursuite(folder_data,data_filename, tet_number);
end




