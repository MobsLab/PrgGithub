%% script_phyTomatlab_Mouse000.m

clear


data_filename = 'Experiment-Mouse000.dat';
folder_data = '/media/DataMOBsRAID/project/Mouse/day';

cd(folder_data);
nb_tetrodes = channelmap_Mouse000(folder_data,0);

S=cell(0); tetrodeChannels=cell(0); TT=cell(0); cellnames=cell(0); W=cell(0);
for tet_number=1:nb_tetrodes
    %extract NPY info and data
    [t_S, t_tetrodeChannels, t_TT, t_cellnames, t_W] = ProcessPhyNpyDataTetrode(folder_data,data_filename, tet_number);

    S               = [S t_S];
    tetrodeChannels = [tetrodeChannels t_tetrodeChannels];
    TT              = [TT t_TT];
    cellnames       = [cellnames t_cellnames];
    W               = [W t_W];
    
end

save SpikeData S tetrodeChannels TT cellnames
save MeanWaveform W

