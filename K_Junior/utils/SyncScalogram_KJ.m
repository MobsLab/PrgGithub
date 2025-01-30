function [mean_scalogram, times, frequencies]=SyncScalogram_KJ(LFP,events,varargin)

% [mean_scalogram, times, frequencies]=SyncScalogram_KJ(LFP,events,varargin)
%
% INPUT
%   LFP                 tsd - LFP or EEG data
% 
%   events              Vector - list of timestamps/events to synchronized data on
%                       in seconds
%   durations           (optional) durations before and after the events (in seconds)
%                       (default 5000 ms)movingwin
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
%   PlotRipRaw SyncSpecgram_KJ
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


%% Scalogram
for i=1:size(T,1)
    [all_scalogram{i}, times, frequencies] = mtspecgramc(T(i,:),movingwin,params);
end
[cfs,frequencies] = cwt(T(i,:),'bump',samplingRate);



%scalogram
[Wavelet.scalog, Wavelet.freq,Wavelet.coi, Wavelet.OutParams] = cwt_SB(Data(Signals{i}), OptionScalo.Fs, 'NumOctaves', OptionScalo.NumOctaves, 'VoicesPerOctave', OptionScalo.VoicesPerOctave);


%% mean
mean_scalogram = [];
for i=1:length(all_scalogram)
    if isempty(mean_scalogram)
        mean_scalogram = all_scalogram{i};
    else
        mean_scalogram = mean_scalogram + all_scalogram{i};
    end
end
mean_scalogram = mean_scalogram / length(all_scalogram);
    
end

