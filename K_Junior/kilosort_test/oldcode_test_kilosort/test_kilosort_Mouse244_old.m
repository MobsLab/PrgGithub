%% test_kilosort_Mouse244

clear


data_filename = 'Breath-Mouse-244-31032015.dat';
folder_data = '/home/mobsjunior/Documents/MATLAB/M244_long_sleep/';

cd(folder_data);
mkdir('Spikes');
mkdir('chanMaps');

nb_tetrodes = channelmap_Mouse244(folder_data,0);

for tet_number=3
    
    clear ops rez DATA uproj
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



