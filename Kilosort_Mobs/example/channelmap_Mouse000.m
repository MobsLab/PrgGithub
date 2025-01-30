%%channelmap_Mouse000
% 15.01.2018 KJ
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function [nb_groups, name_map] = channelmap_Mouse244(folder,toSave)

Nchannels = 32; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap.mat'; % Name of the output channelmap file

groups{1} = [0 1 2 3];  % Channels in a group of electrodes (i.e. tetrodes, octrodes, etc.)
groups{2} = [4 5 6 7];
groups{3} = [28 29 30 31];

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

x0 = [50 50 50 50];
y0 = [6 10 14 18]*10;

% maps
for t=1:length(groups)
    xcoords(groups{t}+1) = x0 + (t-1) * 200; 
    ycoords(groups{t}+1) = y0;

    connected(groups{t}+1) = 1; %only tetrode channels are considered
    kcoords(groups{t}+1) = t;   %in the same group    
end

%save
folder_map = fullfile(folder, name_map);
save(folder_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','groups');

end

