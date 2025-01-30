function [mean_specgram, times, frequencies]=SyncSpecgram_KJ(LFP,events,varargin)

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
        case 'nbins'
            nBins = varargin{i+1};
            if ~isivector(nBins,'>',0,'#',1)
                error('Incorrect value for property ''nBins''.');
            end
        case 'binsize'
            binsize = varargin{i+1};
            if ~isivector(binsize,'>',0,'#',1)
                error('Incorrect value for property ''binsize''.');
            end
        case 'movingwin'
            movingwin = varargin{i+1};
            if ~isdvector(movingwin, '#',2)
                error('Incorrect value for property ''movingwin''.');
            end
        case 'params'
            params = varargin{i+1};
            if ~isstruct(params)
                error('Incorrect value for property ''params''.');
            end
        case 'logplot'
            logplot = varargin{i+1};
            if logplot~=0 && logplot~=1
                error('Incorrect value for property ''logplot''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('nBins','var')
    nBins=1000;
end
if ~exist('binsize','var')
    binsize = 10;
end
if ~exist('movingwin','var')
    movingwin=[3 0.2];
end
if ~exist('params','var')
    params.fpass=[0.1 20];
    params.tapers=[1 2];
end
if ~exist('logplot','var')
    logplot=1;
end

%params
samplingRate = round(1/median(diff(Range(LFP,'s'))));
params.Fs    = samplingRate;


%% Spectrogram
[Specg, t_spg,frequencies] = mtspecgramc(Data(LFP), movingwin, params);
if logplot
    Specg=10*log10(Specg);   
end


%% Average
for i=1:length(frequencies)
    [mean_specgram(i,:), ~, times] = mETAverage(events, t_spg'*1e4, Specg(:,i), binsize, nBins);
end

    
end

