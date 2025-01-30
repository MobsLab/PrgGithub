%%FindSlowWavesMultiChan
%   [SlowWaveEpochs, SlowWaveChan] = FindSlowWavesMultiChan(Signals,varargin)
%
% INPUT
%   Signals             struct of tsd: EEG signal
%
%   noiseepoch          (optional) Noise Epoch, epoch of bad quality
%                       (default [])
%   nb_channel          (optional) number of channel on which a slow waves has to be detected
%                       (default 2)
%   params              (optional) struct - structure with the params used for Slow Waves detection
%                       (default {})
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%   SlowWaveChan        intervalSet - Epochs detected for each channel individualy
%
% SEE
%    DetectSlowWaves_KJ DetectSlowWaves_NGO2015 DetectSlowWaves_Std
%
%


function [SlowWaveEpochs, SlowWaveChan] = FindSlowWavesMultiChan(Signals,varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'noiseepoch'
            NoiseEpoch = varargin{i+1};
        case 'nb_channel'
            nb_channel = varargin{i+1};
            if nb_channel<1
                error('Incorrect value for property ''nb_channel''.');
            end
        case 'method'
            method = varargin{i+1};
            if ~isstring_FMAToolbox(method,'karimjr','predetect','ngo2015')
                error('Incorrect value for property ''method''.');
            end
        case 'params'
            params = varargin{i+1};
            if ~isstruct(params) && ~isempty(params)
                error('Incorrect value for property ''params''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('NoiseEpoch','var')
    NoiseEpoch = intervalSet([],[]);
end
if ~exist('nb_channel','var')
    nb_channel = 2;
end
if ~exist('method','var')
    method = 'karimjr';
end
if ~exist('params','var')
    params = cell(0);
end


%% Params
if ~isempty(params)
    all_fields = fieldnames(params);
    vararguments_func = {};
    for f=1:length(all_fields)
       vararguments_func{end+1} = all_fields{f};
       vararguments_func{end+1} = params.(all_fields{f});
    end
end


%% detect on each channel
if strcmpi(method,'karimjr')
    for ch=1:length(Signals)
        if isempty(params)
            SlowWaveChan{ch} = DetectSlowWaves_KJ(Signals{ch}) - NoiseEpoch{ch};
        else
            SlowWaveChan{ch} = DetectSlowWaves_KJ(Signals{ch}, vararguments_func{:}) - NoiseEpoch{ch};
        end
    end
    
elseif strcmpi(method,'karimstd')
    for ch=1:length(Signals)
        if isempty(params)
            SlowWaveChan{ch} = DetectSlowWaves_Std(Signals{ch}) - NoiseEpoch{ch};

        else
            SlowWaveChan{ch} = DetectSlowWaves_Std(Signals{ch}, vararguments_func{:}) - NoiseEpoch{ch};
        end
    end

end


%% Multi-channel
combinations = nchoosek(1:length(SlowWaveChan),nb_channel);

for i=1:size(combinations,1)
    
    ChannelSlowWaves{i} = SlowWaveChan{combinations(i,1)};
    for j=1:size(combinations,2)
        ChannelSlowWaves{i} = and(ChannelSlowWaves{i}, SlowWaveChan{combinations(i,j)});
    end
end

%% Gather
SlowWaveEpochs = intervalSet([],[]);
for i=1:length(ChannelSlowWaves)
    SlowWaveEpochs = or(SlowWaveEpochs, ChannelSlowWaves{i});
end

end

