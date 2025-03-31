%% test_kilosort_Mouse508

clear


data_filename = 'ProjectEmbReact_M508_20170203_SleepPre.dat';
folder_data = '/home/mobsjunior/Documents/MATLAB/M508_long_sleep/';

cd(folder_data);
mkdir('Spikes');
mkdir('chanMaps');

nb_tetrodes = channelmap_Mouse508(folder_data);

for tet_number=1:2
    %create config file
    ops = MakeConfigKS_Mouse(data_filename, folder_data, tet_number);
    
    % KiloSort
    [rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
    rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
    rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

    % save python results file for Phy
    folder_tetrode = fullfile(folder_data,'Spikes',['tetrode' num2str(tet_number)]);
    mkdir(folder_tetrode);
    rezToPhy(rez, folder_tetrode);
    fprintf('Kilosort took %2.2f seconds vs 72.77 seconds on GTX 1080 + M2 SSD \n', toc)
    
    EditParamsKiloSort(folder_tetrode,folder_data)
    
end

