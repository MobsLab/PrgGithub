function [SlowWaveEpochs, SlowWaveTimes] = DetectSlowWaves_NGO2015(EEG,varargin)
%
%   [SlowWaveEpochs, SlowWaveTimes] = DetectSlowWaves_NGO2015(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%   stdthreshold        (optional) Coefficient applied to the std of the signal to obtain threshold
%                       (default 1.25)
%   lowpass_freq        (optional) frequency applied for the low-pass filtering
%                       (default 3.5Hz)
%   minDuration         (optional) minimal duration for a slow wave
%                       (default 80ms)
%   maxDuration         (optional) maximal duration for a slow wave
%                       (default 2000ms)
%   noiseThreshold      (optional) Threshold to consider part of signals as noise
%                       (default 210mV)
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%   SlowWaveTimes       ts - Time of Slow Waves troughs
%
% SEE
%    FindSlowWaves DetectSlowWaves_KJ
%
%


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
        case 'stdthreshold'
            stdthreshold = varargin{i+1};
            if ~isvector(stdthreshold) || length(stdthreshold)~=1
                error('Incorrect value for property ''stdthreshold''.');
            end
        case 'lowpass_freq'
            lowpass_freq = varargin{i+1};
            if ~isvector(lowpass_freq) || length(lowpass_freq)~=1
                error('Incorrect value for property ''lowpass_freq''.');
            end
        case 'minduration'
            minDuration = varargin{i+1};
            if ~isvector(minDuration) || length(minDuration)~=1
                error('Incorrect value for property ''minDuration''.');
            end
        case 'maxduration'
            maxDuration = varargin{i+1};
            if ~isvector(maxDuration) || length(maxDuration)~=1
                error('Incorrect value for property ''maxDuration''.');
            end
        case 'noisethreshold'
            noiseThreshold = varargin{i+1};
            if ~isvector(noiseThreshold) || length(noiseThreshold)~=1
                error('Incorrect value for property ''noiseThreshold''.');
            end

        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('stdthreshold','var')
    stdthreshold = 1.25;
end
if ~exist('lowpass_freq','var')
    lowpass_freq = 3.5;
end
if ~exist('minDuration','var')
    minDuration = 80;
end
if ~exist('maxDuration','var')
    maxDuration = 2000;
end
if ~exist('noiseThreshold','var')
    noiseThreshold = 210;
end


%params
minDuration = minDuration * 10; %in 1E-4s
maxDuration = maxDuration * 10; %in 1E-4s


%% filter and Predetect
EEG_low = FilterLFP(EEG, [0.2 lowpass_freq]);

zero_crossings = Range(threshold(EEG_low, 0, 'Crossing', 'Rising', 'InitialPoint', 1));
Predetect = intervalSet(zero_crossings(1:end-1), zero_crossings(2:end));
Predetect = dropLongIntervals(Predetect, maxDuration);
Predetect = dropShortIntervals(Predetect, minDuration);

start_predetect = Start(Predetect);
end_predetect = End(Predetect);

%% Detection & thresholds
func_max = @(a) measureOnSignal(a,'maximum');
func_min = @(a) measureOnSignal(a,'minimum');

[peak_value, ~, ~] = functionOnEpochs(EEG, Predetect, func_max);
[troughs_value, troughs_tmp, ~] = functionOnEpochs(EEG, Predetect, func_min);
trough_to_peaks = peak_value-troughs_value;


%thresholds
negative_threshold = stdthreshold * nanmean(troughs_value);
amplitude_threshold = stdthreshold * nanmean(trough_to_peaks);

%index of interval crossing thresholds
idx_detections = troughs_value<negative_threshold & trough_to_peaks>amplitude_threshold;

% Detections
DetectedIntv = intervalSet(start_predetect(idx_detections), end_predetect(idx_detections));


%% Noise detection (exclude)
Noise_neg = thresholdIntervals(Restrict(EEG,DetectedIntv), -noiseThreshold,'Direction','Below');
Noise_pos = thresholdIntervals(Restrict(EEG,DetectedIntv), noiseThreshold,'Direction','Above');
noise_points = sort([(Start(Noise_neg)+End(Noise_neg))/2 ; (Start(Noise_pos)+End(Noise_pos))/2]);

DetectedSW = [Start(DetectedIntv) End(DetectedIntv)];
[~,interval,~] = InIntervals(noise_points,DetectedSW);
noise_sw_intv = unique(interval);
noise_sw_intv(noise_sw_intv==0)=[]; 

DetectedSW(noise_sw_intv,:)=[];
troughs_tmp(noise_sw_intv)=[];


%% Return
SlowWaveEpochs = intervalSet(DetectedSW(:,1),DetectedSW(:,2));
SlowWaveTimes = ts(troughs_tmp);

end

