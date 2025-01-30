% GetDifferentLocationStructure
% 08.01.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   GetSpikesFromStructure
%
%


function channels = GetDifferentLocationStructure(structure,varargin)


%% CHECK INPUTS
if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'hemisphere'
            hemisphere = lower(varargin{i+1});
        case 'foldername'
            foldername = lower(varargin{i+1});
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('foldername','var')
    foldername = pwd;
end
if ~exist('hemisphere','var')
    hemisphere = '';
end

%% Structures
load(fullfile(foldername, 'LFPData','InfoLFP.mat'));
if exist('SpikeData.mat')>0
load(fullfile(foldername,'SpikeData.mat'),'tetrodeChannels');
else
    tetrodeChannels = [];
end

%noisy channels eventually
if exist('ChannelsToAnalyse/Noisy.mat','file')==2
    load('ChannelsToAnalyse/Noisy.mat','channels')
    noisy_channels = channels;
else
    noisy_channels = [];
end

%hemisphere
for i=1:length(InfoLFP.hemisphere)
    if strcmpi(InfoLFP.hemisphere{i},'right') || strcmpi(InfoLFP.hemisphere{i},'left')
        InfoLFP.hemisphere{i} = InfoLFP.hemisphere{i}(1);
    end
end

%all channels from structures
if ~isempty(hemisphere)
    idx_channel = strcmpi(structure,InfoLFP.structure) & strcmpi(hemisphere,InfoLFP.hemisphere);
else
    idx_channel = strcmpi(structure,InfoLFP.structure);
end
all_channels = InfoLFP.channel(idx_channel);


%all but one (the first) channel from tetrodes
notused_channels = [];
for t=1:length(tetrodeChannels)
    notused = setdiff(1:length(tetrodeChannels{t}), find(~ismember(tetrodeChannels{t},noisy_channels),1)); %remove the first non noisy channels
    notused_channels = [notused_channels tetrodeChannels{t}(notused)];

end
%remove channels from same tetrodes
channels = setdiff(all_channels, notused_channels);
%remove noisy channels
channels = setdiff(channels, noisy_channels);


end




