%%channelmap_Mouse911
% 12.06.2018 KJ
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function [nb_groups, name_map] = channelmap_Mouse977(folder,toSave)

Nchannels = 135; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap_M9941A.mat'; % Name of the output channelmap file


groups{1} = [59 45 46 47 55 56 42 43 44 52 57]; % Channels in a group of electrodes (i.e. tetrodes, octrodes, etc.)
groups{2} = [34 35 48 51 62 63 33 30 32];
groups{3} = [1 31 15 49];
groups{4} = [20 21 18 10 7 25 22 23 11];
groups{5} = [123 109 110 111 119 120 106];
groups{6} = [101 102 114 125 124 98 99 112];
groups{7} = [88 76 67 66 92 93 78 77 64 65 95];
groups{8} = [73 70 84 85 82 74 71 89 86 87];

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

% maps

for t=1:length(groups)
    x0 = 50*ones(1,length(groups{t}));
    y0 = 1:length(groups{t});
    y0 = (y0*40)+20;
    
    
    xcoords(groups{t}+1) = x0 + (t-1) * 200; 
    ycoords(groups{t}+1) = y0;

    connected(groups{t}+1) = 1; %only tetrode channels are considered
    kcoords(groups{t}+1) = t;   %in the same group    
end

%save
folder_map = fullfile(folder, name_map);
save(folder_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','groups');

end

