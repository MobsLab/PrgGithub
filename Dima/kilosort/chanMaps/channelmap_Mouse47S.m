%%channelmap_Mouse994
% 24.01.2020 DB
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function [nb_groups, name_map] = channelmap_Mouse47S(folder,toSave)

Nchannels = 135; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap_M47S.mat'; % Name of the output channelmap file

groups{1} = [0 1 31 15 49];
groups{2} = [7 25 22 23 11];
groups{3} = [103 104 105 117];
groups{4} = [115 126 127 97 94 96];
groups{5} = [65 95 79 113];

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
    if t < 6
        x0 = 50*ones(1,length(groups{t}));
        y0 = 1:length(groups{t});
        y0 = (y0*40)+20;
        
        
        xcoords(groups{t}+1) = x0 + (t-1) * 200;
        xtrack = x0 + (t-1) * 200;
        ycoords(groups{t}+1) = y0;
        
        connected(groups{t}+1) = 1; % set the channels active
        kcoords(groups{t}+1) = t;   % create spike group
    else
        y0 = 1:length(groups{t});
        y0 = (y0*40)+20;
        xcoords(groups{t}+1) = xtrack(1) + 500 + (t-1) * 200;
        ycoords(groups{t}+1) = y0;
        
        connected(groups{t}+1) = 1; % set the channels active
        kcoords(groups{t}+1) = t;   % create spike group
    end
end



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

