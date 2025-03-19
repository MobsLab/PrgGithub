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


function nb_tetrodes = channelmap_Mouse743(folder,toSave)

Nchannels = 71;
fs = 20000; % sampling frequency

tetrodes{1} = [1 2 3];
tetrodes{2} = [4 5 6 7];
tetrodes{3} = [8 9 10 11];
tetrodes{4} = [12 13 14 15];
tetrodes{5} = [57 58 59 61 48 49 63];
tetrodes{6} = [54 55 51 53 56 52 60 50];
tetrodes{7} = [42 44 43 39 45 35];
tetrodes{8} = [32 46 33 47 34 38 36 37];


nb_tetrodes = length(tetrodes);

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
for t=1:length(tetrodes)
    x0 = 50*ones(1,length(tetrodes{t}));
    y0 = 1:length(tetrodes{t});
    y0 = (y0*40)+20;
    
    
    xcoords(tetrodes{t}+1) = x0 + (t-1) * 200; 
    ycoords(tetrodes{t}+1) = y0;

    connected(tetrodes{t}+1) = 1; %only tetrode channels are considered
    kcoords(tetrodes{t}+1) = t;   %in the same group    
end

%save
name_map = fullfile(folder, 'chanMap.mat');
save(name_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','tetrodes');

end

