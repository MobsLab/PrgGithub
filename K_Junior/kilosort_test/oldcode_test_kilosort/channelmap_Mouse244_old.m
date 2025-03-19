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

%to be 
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

%init
chanMap     = 1:Nchannels;
chanMap0ind = chanMap - 1;

% maps
for t=1:length(tetrodes)
    
    % coordinates
    xcoords     = nan(Nchannels,1);
    ycoords     = nan(Nchannels,1);
    
    xcoords(tetrodes{t}+1) = [10 10 10 10]*5; 
    ycoords(tetrodes{t}+1) = [10 14 18 22]*5;
    
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

