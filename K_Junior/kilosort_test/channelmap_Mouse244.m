%%channelmap_Mouse244
% 15.01.2018 KJ
%
%  create a channel map file
%
%
%INPUTS
% folder:        mouse number
% toSave:        1 to save data, 0 otherwise
%


function nb_tetrodes = channelmap_Mouse244(folder,toSave)

Nchannels = 32;
fs = 20000; % sampling frequency

tetrodes{1} = [0 1 2 3];
tetrodes{2} = [4 5 6 7];
tetrodes{3} = [28 29 30 31];

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

x0 = [50 50 50 50];
y0 = [6 10 14 18]*10;

% maps
for t=1:length(tetrodes)
    xcoords(tetrodes{t}+1) = x0 + (t-1) * 200; 
    ycoords(tetrodes{t}+1) = y0;

    connected(tetrodes{t}+1) = 1; %only tetrode channels are considered
    kcoords(tetrodes{t}+1) = t;   %in the same group    
end

%save
name_map = fullfile(folder, 'chanMap.mat');
save(name_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','tetrodes');

end

