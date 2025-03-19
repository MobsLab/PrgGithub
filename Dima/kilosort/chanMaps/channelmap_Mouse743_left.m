%%channelmap_Mouse743
% 12.06.2018 KJ
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function [nb_groups, name_map] = channelmap_Mouse743_left(folder,toSave)

Nchannels = 71; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap_DB_left.mat'; % Name of the output channelmap file

groups{1} = [57 58 59 61 48 49 63]; % Channels in a group of electrodes (i.e. tetrodes, octrodes, etc.)
groups{2} = [54 55 51 53 56 52 60 50];
groups{3} = [35 45 39 43 43 42];
groups{4} = [32 46 33 47 34 38 36 37];


nb_groups = length(groups);

%return if no save
if exist('toSave','var')
    if toSave==0
        return
    end
end

%% init
chanMap     = 1:Nchannels;
chanMap0ind = chanMap - 1;

% coordinates
xcoords     = nan(Nchannels,1);
ycoords     = nan(Nchannels,1);
% connection and grouping of channels (i.e. tetrode groups)
connected   = false(Nchannels, 1);
kcoords     = nan(Nchannels,1); 

%%% maps
% Group 1
x0{1} = [50 50 60 50 60 58 56]; 
y0{1} = [200 160 140 120 100 80 60];
    
xcoords(groups{1}+1) = x0{1}; 
ycoords(groups{1}+1) = y0{1};

connected(groups{1}+1) = 1; %only tetrode channels are considered
kcoords(groups{1}+1) = 1;   %in the same group  

% Group 2
x0{2} = [50 60 50 60 50 60 58 56]; 
y0{2} = [200 180 160 140 120 100 80 60];
    
xcoords(groups{2}+1) = x0{2}; 
ycoords(groups{2}+1) = y0{2};

connected(groups{2}+1) = 1;
kcoords(groups{2}+1) = 2; 

% Group 3
x0{3} = [50 60 50 60 50 60]; 
y0{3} = [200 180 160 140 120 100];
    
xcoords(groups{3}+1) = x0{3}; 
ycoords(groups{3}+1) = y0{3};

connected(groups{3}+1) = 1;
kcoords(groups{3}+1) = 3; 

% Group 4
x0{4} = [50 60 50 60 50 60 58 56];
y0{4} = [200 180 160 140 120 100 80 60];
    
xcoords(groups{4}+1) = x0{4};
ycoords(groups{4}+1) = y0{4};

connected(groups{4}+1) = 1;
kcoords(groups{4}+1) = 4;   
    
%save
folder_map = fullfile(folder, name_map);
save(folder_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','groups');

end

