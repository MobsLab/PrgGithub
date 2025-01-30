%% test_kilosort_Mouse508

clear


data_filename = 'ProjectEmbReact_M508_20170203_TestPre_TestPre1.dat';
folder_data = '/home/mobsjunior/Documents/MATLAB/kilosort/M508_short_sleep/';

cd(folder_data);
mkdir('Spikes');

nb_tetrodes = channelmap_Mouse508(folder_data);

%create config file
ops = MakeConfigKS_Mouse(data_filename, folder_data, 'Nfilt', 128, 'whiteningRange',12);

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

