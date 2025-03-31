%%channelmap_Mouse508
% 12.01.2018 KJ
%
%  create a channel map file
%
%
%INPUTS
% mouse:        mouse number
%
%


function nb_tetrodes = channelmap_Mouse508(folder,toSave)

%to be 
Nchannels = 71;
fs = 20000; % sampling frequency

tetrodes{1} = [0 1 2 3];
tetrodes{2} = [4 5 6 7];
tetrodes{3} = [20 21 22 23];
tetrodes{4} = [24 25 26 27];
tetrodes{5} = [28 29 30 31];
tetrodes{6} = [32 33 34 35];
% tetrodes{7} = [36 37 38 39];
% tetrodes{8} = [40 41 42 43];
% tetrodes{9} = [56 57 58 59];
% tetrodes{10} = [60 61 62 63];

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
    tet = tetrodes{t};
    
    xcoords(tet+1) = x0(1:length(tet)) + mod(t-1,3) * 200; 
    ycoords(tet+1) = y0(1:length(tet)) + (t>3) * 200;

    connected(tet+1) = 1; %only tetrode channels are considered
    kcoords(tet+1) = t;   %in the same group    
end

%save
name_map = fullfile(folder, 'chanMap.mat');
save(name_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs','tetrodes');




end

