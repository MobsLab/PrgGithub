esit%%channelmap_Mouse994A2
% 21.01.2020 DB
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function [nb_groups, name_map] = channelmap_Mouse994A2(folder,toSave)

Nchannels = 135; % Number of channels in the recording
fs = 20000; % sampling frequency
name_map = 'chanMap_M994A2.mat'; % Name of the output channelmap file


groups{1} = [59 45 46 47 55 56 42 43 44 52 57 39 40 53]; % Channels in a group of electrodes (i.e. tetrodes, octrodes, etc.)
groupsAct{1} = logical([1 1 1 1 1 1 1 1 1 0 0 0 0 0]); 
groups{2} = [37 38 61 50 60 34 35 48 51 62 63 33 30 32];
groupsAct{2} = logical([0 0 0 0 0 0 1 1 1 1 1 1 1 1]);
groups{3} = [26 27 24 12 3 2 28 29 14 13 0 1 31 15 49];
groupsAct{3} = logical([0 0 0 0 0 0 0 0 0 0 0 1 1 1 1]);
groups{4} = [5 19 16 17 9 6 20 21 18 10 7 25 22 23 11];
groupsAct{4} = logical([0 0 0 0 0 0 1 1 1 1 0 1 1 1 1]); 
groups{5} = [123 109 110 111 119 120 106 107 108 116 121 103 104 105 117];
groupsAct{5} = logical([1 1 1 1 1 1 1 1 0 0 0 0 0 0 0]);
groups{6} = [101 102 114 125 124 98 99 112 115 126 127 97 94 96];
groupsAct{6} = logical([1 1 1 1 1 1 1 1 0 0 0 0 0 0]); 
groups{7} = [90 91 88 76 67 66 92 93 78 77 64 65 95 79 113];
groupsAct{7} = logical([0 0 0 1 1 1 1 1 1 1 1 1 1 0 0]);
groups{8} = [69 83 80 81 73 70 84 85 82 74 71 89 86 87 75];
groupsAct{8} = logical([0 0 0 0 0 1 1 1 1 1 1 1 1 1 0]);

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
    if t < 5
        x0 = 50*ones(1,length(groups{t}));
        y0 = 1:length(groups{t});
        y0 = (y0*40)+20;
        
        
        xcoords(groups{t}+1) = x0 + (t-1) * 200;
        xtrack = x0 + (t-1) * 200;
        ycoords(groups{t}+1) = y0;
        
        connected(groups{t}+1) = 1; % set the channels active
        kcoords(groups{t}(groupsAct{t})+1) = t;   % create spike group
    else
        y0 = 1:length(groups{t});
        y0 = (y0*40)+20;
        xcoords(groups{t}+1) = xtrack(1) + 500 + (t-1) * 200;
        ycoords(groups{t}+1) = y0;
        
        connected(groups{t}+1) = 1; % set the channels active
        kcoords(groups{t}(groupsAct{t})+1) = t;   % create spike group
    end
end

%save
folder_map = fullfile(folder, name_map);
save(folder_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','groups');

end

