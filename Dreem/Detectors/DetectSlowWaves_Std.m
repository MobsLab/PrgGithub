function [SlowWaveEpochs, SlowWaveTimes] = DetectSlowWaves_Std(EEG,varargin)
%
%   [SlowWaveEpochs, SlowWaveTimes] = DetectSlowWaves_Std(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%   stdthresh_neg       (optional) Coefficient applied to the std of the signal to obtain negative threshold
%                       (default 1.3)
%   stdthresh_pos       (optional) Coefficient applied to the std of the signal to obtain positive threshold
%                       (default 1.2)
%   threshDuration      (optional) minimal duration during which the signal is crossing the negative threshold
%                       (default 5ms)
%   minDuration         (optional) minimal duration for a slow wave
%                       (default 80ms)
%   maxDuration         (optional) maximal duration for a slow wave
%                       (default 2000ms)
%   noiseThreshold      (optional) Threshold to consider part of signals as noise
%                       (default 230mV)
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%   SlowWaveTimes       ts - Time of Slow Waves troughs
%
% SEE
%    FindSlowWaves DetectSlowWaves_KJ DetectSlowWaves_NGO2015
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
        case 'stdthresh_neg'
            stdthresh_neg = varargin{i+1};
            if ~isvector(stdthresh_neg) || length(stdthresh_neg)~=1
                error('Incorrect value for property ''stdthresh_neg''.');
            end
        case 'stdthresh_pos'
            stdthresh_pos = varargin{i+1};
            if ~isvector(stdthresh_pos) || length(stdthresh_pos)~=1
                error('Incorrect value for property ''stdthresh_pos''.');
            end
        case 'threshduration'
            thresh_duration = varargin{i+1};
            if ~isvector(thresh_duration) || length(thresh_duration)~=1
                error('Incorrect value for property ''threshDuration''.');
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
if ~exist('stdthresh_neg','var')
    stdthresh_neg = 1.4;
end
if ~exist('stdthresh_pos','var')
    stdthresh_pos = 1.1;
end
if ~exist('thresh_duration','var')
    thresh_duration = 10;
end
if ~exist('minDuration','var')
    minDuration = 300;
end
if ~exist('maxDuration','var')
    maxDuration = 1400;
end
if ~exist('noiseThreshold','var')
    noiseThreshold = 230;
end


%params
minDuration = minDuration * 10; %in 1E-4s
maxDuration = maxDuration * 10; %in 1E-4s
thresh_duration = thresh_duration * 10;

%% Create intervals between rising zero-crossings
zero_crossings = Range(threshold(EEG, 0, 'Crossing', 'Falling', 'InitialPoint', 1));
Predetect = intervalSet(zero_crossings(1:end-1), zero_crossings(2:end));
Predetect = dropLongIntervals(Predetect, maxDuration);
Predetect = dropShortIntervals(Predetect, minDuration);


%% Negative threshold detections
y_eeg = Data(EEG);
negative_threshold = -stdthresh_neg * std(y_eeg(abs(y_eeg)<noiseThreshold));
EEG_pred = Restrict(EEG, Predetect);

detection = thresholdIntervals(EEG_pred, negative_threshold,'Direction','Below');
detection = dropShortIntervals(detection, thresh_duration); %should be under threshold during more than (thresh_duration)ms
detection = (Start(detection) + End(detection)) / 2;


%% Restrict predetection to negative threshold detections
Predetect = [Start(Predetect) End(Predetect)];
[~,interval,~] = InIntervals(detection,Predetect);
sw_intv_idx = unique(interval);
sw_intv_idx(sw_intv_idx==0)=[];

DeflectionEpochs = intervalSet(Predetect(sw_intv_idx,1),Predetect(sw_intv_idx,2));


%% Noise detection (exclude)
Noise_neg = thresholdIntervals(Restrict(EEG,DeflectionEpochs), -noiseThreshold,'Direction','Below');
Noise_pos = thresholdIntervals(Restrict(EEG,DeflectionEpochs), noiseThreshold,'Direction','Above');
noise_points = sort([(Start(Noise_neg)+End(Noise_neg))/2 ; (Start(Noise_pos)+End(Noise_pos))/2]);

DeflectionIntv = [Start(DeflectionEpochs) End(DeflectionEpochs)];
[~,interval,~] = InIntervals(noise_points,DeflectionIntv);
noise_sw_intv = unique(interval);
noise_sw_intv(noise_sw_intv==0)=[]; 

DeflectionIntv(noise_sw_intv,:)=[];
DeflectionEpochs = intervalSet(DeflectionIntv(:,1), DeflectionIntv(:,2));


%% amplitude threshold
func_ampli = @(a) measureOnSignal(a,'amplitude_p2p');
[trough_to_peaks, troughs_tmp, ~] = functionOnEpochs(EEG, DeflectionEpochs, func_ampli);

amplitude_threshold = stdthresh_pos * nanmean(trough_to_peaks);
idx_detections = trough_to_peaks>amplitude_threshold;


%% Result
SlowWaveEpochs = subset(DeflectionEpochs, find(idx_detections));
SlowWaveTimes = ts(troughs_tmp(idx_detections));



end

