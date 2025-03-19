function [mean_specgram, times, frequencies]=SyncSpecgram2_KJ(LFP,events,varargin)

% [mean_specgram, times, frequencies]=SyncSpecgram_KJ(LFP,events,varargin)
%
% INPUT
%   LFP                 tsd - LFP or EEG data
% 
%   events              Vector - list of timestamps/events to synchronized data on
%                       in seconds
%   durations           (optional) durations before and after the events (in seconds)
%                       (default 5s)
%   movingwin           (optional) Moving window for spectrogram (cf mtspecgramc.m)
%                       (default [3 0.2])
%   params              (optional) Parameters of the spectral analysis: tapers / pad (cf mtspecgramc.m)
%                       (default fpass = [0.1 20] / tapers = [1 2])
%
%
% OUTPUT
%   mean_specgram       mean spectrogram in form time x frequency
%   times               times
%   frequencies         frequencies
%
%
% SEE
%   PlotRipRaw SyncScalogram_KJ
%
%



%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'durations'
            durations = varargin{i+1};
            if ~isvector(durations) || (length(durations)~=1 && length(durations)~=2)
                error('Incorrect value for property ''durations''.');
            end
        case 'movingwin'
            movingwin = varargin{i+1};
            if ~isvector(movingwin) || length(movingwin)~=2
                error('Incorrect value for property ''movingwin''.');
            end
        case 'params'
            params = varargin{i+1};
            if ~isstruct(params)
                error('Incorrect value for property ''params''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('durations','var')
    durations=[-5 5];
elseif length(durations)==1
    durations = [-durations durations];
end
if ~exist('movingwin','var')
    movingwin=[3 0.2];
end
if ~exist('params','var')
    params.fpass=[0.1 20];
    params.tapers=[1 2];
end


%params
samplingRate = round(1/median(diff(Range(LFP,'s'))));
params.Fs=samplingRate;
nBins = floor(samplingRate*diff(durations)/2)*2+1;
rg2=Range(LFP,'s');
Signal=[rg2-rg2(1) Data(LFP)];


%% Sync data
[samples, sync] = Sync(Signal,events,'durations',durations);
T = SyncMap(samples,sync,'durations',durations,'nbins',nBins,'smooth',0);

% adjust bins
if size(T,2)>nBins
    nBins=nBins+1;
elseif size(T,2)<nBins
    nBins=nBins-1;
end


%% Specgram
for i=1:size(T,1)
    [all_specgram{i}, times, frequencies] = mtspecgramc(T(i,:),movingwin,params);
end

%% mean
mean_specgram = [];
for i=1:length(all_specgram)
    if isempty(mean_specgram)
        mean_specgram = all_specgram{i};
    else
        mean_specgram = mean_specgram + all_specgram{i};
    end
end
mean_specgram = mean_specgram / length(all_specgram);
    
end

