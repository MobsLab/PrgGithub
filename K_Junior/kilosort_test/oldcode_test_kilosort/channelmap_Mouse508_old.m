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
tetrodes{7} = [36 37 38 39];
tetrodes{8} = [40 41 42 43];
tetrodes{9} = [56 57 58 59];
tetrodes{10} = [60 61 62 63];

nb_tetrodes = length(tetrodes);

%return if no save
if exist('toSave','var')
    if toSave==0
        return
    end
end

%init
chanMap     = 1:Nchannels;
chanMap0ind = chanMap - 1;

% maps
for t=1:length(tetrodes)
    
    % coordinates
    xcoords     = nan(Nchannels,1);
    ycoords     = nan(Nchannels,1);
    
    xcoords(tetrodes{t}+1) = [10 10 10 10]*2; 
    ycoords(tetrodes{t}+1) = [10 20 30 40]*2;
    
    % connection and grouping of channels (i.e. tetrode groups)
    connected   = false(Nchannels, 1);
    kcoords     = nan(Nchannels,1); 
    
    connected(tetrodes{t}+1) = 1; %only tetrode channels are considered
    kcoords(tetrodes{t}+1) = 1;   %in the same group
    
    %save
    name_map = fullfile(folder, 'chanMaps', ['chanMap' num2str(t) '.mat']);
    save(name_map,'chanMap','connected', 'xcoords', 'ycoords', 'kcoords', 'chanMap0ind', 'fs');
    
end



end

