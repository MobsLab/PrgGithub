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


function [nb_groups, name_map] = channelmap_Mouse081(folder,toSave)

Nchannels = 135; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap_M081.mat'; % Name of the output channelmap file

% 24/01/2020
groups{1} = [6 20 21 18 10];
groups{2} = [44 52 57 39 40];
groups{3} = [61 60 34 35 48 51];
groups{4} = [3 2 28 29 14];

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

