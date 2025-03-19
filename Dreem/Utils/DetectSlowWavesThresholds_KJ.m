function [SlowWaveEpochs, std_eeg, distrib_eeg] = DetectSlowWavesThresholds_KJ(EEG, threshold_list, varargin)
%
%   [SlowWaveEpochs, distrib_eeg] = DetectSlowWavesThresholds_KJ(EEG, threshold_list, varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%   threshold_list      list of thresholds in std
%
%   threshDuration      (optional) minimal duration during which the signal is crossing the threshold
%                       (default 30ms)
%   minDuration         (optional) minimal duration for a slow wave
%                       (default 100ms)
%   maxDuration         (optional) maximal duration for a slow wave
%                       (default 800ms)
%   noiseThreshold      (optional) Threshold to consider part of signals as noise
%                       (default 230µV)
%
% OUTPUT
%   SlowWaveEpochs      intervalSet - Epochs detected
%
% SEE
%    FindSlowWaves DetectSlowWaves_NGO2015 DetectSlowWaves_KJ
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
if ~exist('thresh_duration','var')
    thresh_duration = 20;
end
if ~exist('minDuration','var')
    minDuration = 100;
end
if ~exist('maxDuration','var')
    maxDuration = 800;
end
if ~exist('noiseThreshold','var')
    noiseThreshold = 230;
end


%params
thresh_duration = thresh_duration * 10; %in 1E-4s
minDuration = minDuration * 10; %in 1E-4s
maxDuration = maxDuration * 10; %in 1E-4s


%% filter and Predetect
%EEG_low = FilterLFPBut(EEG, freqSlowWave);
Predetect = thresholdIntervals(EEG,0,'Direction','Below');
Predetect = dropLongIntervals(Predetect, maxDuration);
Predetect = dropShortIntervals(Predetect, minDuration);

y_eeg = Data(EEG);
[distrib_eeg.y, distrib_eeg.x] = histcounts(log10(abs(y_eeg)));
std_eeg = std(y_eeg(abs(y_eeg)<noiseThreshold));
EEG_neg = Restrict(EEG, Predetect);


for t=1:length(threshold_list)
    
    threshold = -threshold_list(t) * std_eeg;
    
    %% Detection
    detection = thresholdIntervals(EEG_neg, threshold,'Direction','Below');
    detection = dropShortIntervals(detection, thresh_duration); %should be under threshold during more than (thresh_duration)ms
    detection = (Start(detection) + End(detection)) / 2;


    %% SW are between two zero crossings
    predetectect_intv = [Start(Predetect) End(Predetect)];
    [~,interval,~] = InIntervals(detection,predetectect_intv);
    sw_intv_idx = unique(interval);
    sw_intv_idx(sw_intv_idx==0)=[];

    DeflectionEpochs = intervalSet(predetectect_intv(sw_intv_idx,1),predetectect_intv(sw_intv_idx,2));


    %% Noise detection (exclude)
    Noise_neg = thresholdIntervals(Restrict(EEG,DeflectionEpochs), -noiseThreshold,'Direction','Below');
    Noise_pos = thresholdIntervals(Restrict(EEG,DeflectionEpochs), noiseThreshold,'Direction','Above');
    noise_points = sort([(Start(Noise_neg)+End(Noise_neg))/2 ; (Start(Noise_pos)+End(Noise_pos))/2]);

    DeflectionIntv = [Start(DeflectionEpochs) End(DeflectionEpochs)];
    [~,interval,~] = InIntervals(noise_points,DeflectionIntv);
    noise_sw_intv = unique(interval);
    noise_sw_intv(noise_sw_intv==0)=[]; 

    DeflectionIntv(noise_sw_intv,:)=[];


    %% Return
    SlowWaveEpochs{t} = intervalSet(DeflectionIntv(:,1),DeflectionIntv(:,2));

end


end










