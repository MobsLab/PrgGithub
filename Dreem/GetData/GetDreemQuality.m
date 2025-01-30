%   [channel_quality, NoiseEpoch] = GetDreemQuality(filereference)
%
% INPUT:
% - filereference       Reference of the record
%
%
% OUTPUT:
% - channel_quality:   quality note for each channel
% - NoiseEpoch:        Epoch of Noise for each channel
% - TotalNoise:        Epoch where at least one channel is bad
%
%
% INFO
%   livio is synchronized on EEG data from h5 files
%
%       see 
%           GetRecordClinic
%

function [channel_quality, NoiseEpoch, TotalNoise] = GetDreemQuality(filereference,varargin)

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
        case 'folderdata'
            folderdata = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('folderdata','var')
    folderdata = FolderSlowDynRecords;
end

thresh = 0.7; %70%
fs_eeg    = 250; %250Hz
mergeTh   = 5e4; %5sec

%% load

filename = fullfile(folderdata,'quality',[num2str(filereference) '_quality.h5']);

if exist(filename, 'file') == 2
    try
        qualities = double(h5read(filename,['/quality/']));
    end
    
    for i=1:4
        channel_quality{i} = qualities(i,:)';
    end
else
    disp(['File ' filename ' does not exist'])
end


%% Epoch

%tsd
x_quality = (0:(length(channel_quality{1})-1))' / fs_eeg;
for ch=1:length(channel_quality)
    tquality{ch} = tsd(x_quality*1E4, channel_quality{ch});
end

%epochs
TotalNoise = intervalSet([],[]);
for ch=1:length(tquality)
    intv = thresholdIntervals(tquality{ch}, thresh,'Direction','Below');
    NoiseEpoch{ch} = mergeCloseIntervals(intv, mergeTh);
    
    TotalNoise = or(TotalNoise, NoiseEpoch{ch});
end






end













