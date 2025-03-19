%% test_phy_Mouse244

clear


data_filename = 'Breath-Mouse-244-31032015.dat';
folder_data = '/home/mobsjunior/Documents/MATLAB/kilosort/M244_long_sleep/';

cd(folder_data);
nb_tetrodes = channelmap_Mouse244(folder_data,0);

S=cell(0); tetrodeChannels=cell(0); TT=cell(0); cellnames=cell(0); W=cell(0);
for tet_number=1:2
    %extract NPY info and data
    [t_S, t_tetrodeChannels, t_TT, t_cellnames, t_W] = ProcessPhyNpyDataTetrode(folder_data,data_filename, tet_number);

    S               = [S t_S];
    tetrodeChannels = [tetrodeChannels t_tetrodeChannels];
    TT              = [TT t_TT];
    cellnames       = [cellnames t_cellnames];
    W               = [W t_W];
    
end
