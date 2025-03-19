function [SpindlesEpoch, tSpindles]=DetectSpindles_KJ(EEG,varargin)
%
%   SpindlesEpoch=DetectSpindles_KJ(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%    <options>              optional list of property-value pairs (see table below)
%    =========================================================================
%     Properties            Values
%    -------------------------------------------------------------------------
%     'noise_epoch'         noise Epoch intervalSet (default = intervalSet([],[]))
%     'spindles_band'       frequency band of the spindles (default = [120 250])  
%     'threshold'           thresholds for spindles detection (default = [5 7])
%     'durations'           min and max ripple duration & min inter-spindles interval, in ms
%                           (default = [500 3000 500])
%     'mean_std_values'     mean and standard deviation to normalize signals
%                           (default: computed on signals)
%    =========================================================================
%
% OUTPUT
%   SpindlesEpoch      intervalSet - Epochs detected
%
% SEE
%    FindSpindlesDreem DetectSlowWaves_KJ DetectSpindles_Mensen
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
        case 'noise_epoch'
            noiseEpoch = varargin{i+1};
        case 'spindles_band'
            spindles_band = varargin{i+1};
            if ~isvector(spindles_band) || length(spindles_band)~=2
                error('Incorrect value for property ''spindles_band''.');
            end
        case 'durations'
            durations = varargin{i+1};
            if ~isvector(durations) || length(durations)~=2
                error('Incorrect value for property ''durations''.');
            end
        case 'mean_std_values'
            mean_std_values = varargin{i+1};
            if ~isvector(mean_std_values) || length(mean_std_values)~=2
                error('Incorrect value for property ''durations''.');
            end

        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('noiseEpoch','var')
    noiseEpoch = intervalSet([],[]);
end
if ~exist('spindles_band','var')
    spindles_band = [10 16];
end
if ~exist('threshold','var')
    threshold = [5 7];
end
if ~exist('durations','var')
    durations = [500 3000 500];
end

durations = durations*10; % in ts
minSpindleDuration = durations(1);
maxSpindleDuration = durations(2);
minInterSpindleInterval = durations(3);


%% 
goodEpoch = CleanUpEpoch(intervalSet(0,max(Range(EEG))) - noiseEpoch);

% Calculate overall SD
FiltEEG = FilterLFP(EEG, spindles_band, 1024); %filter
FiltEEG_Epoch = Restrict(FiltEEG, goodEpoch); %restrict to Epoch
signal_squared = abs(Data(FiltEEG_Epoch));
if exist('mean_std_values','var')
    meanVal = mean_std_values(1);
    stdVal = mean_std_values(2);
else
    meanVal = mean(signal_squared);
    stdVal = std(signal_squared);
end

signal_squared = abs(Data(FiltEEG));
SquaredFiltEEG = tsd(Range(FiltEEG),signal_squared-meanVal);

% Detect using low threshold
PotentialSpindleEpochs = thresholdIntervals(SquaredFiltEEG, threshold(1)*stdVal);

% Merge spindles that are very close together
PotentialSpindleEpochs = mergeCloseIntervals(PotentialSpindleEpochs, minInterSpindleInterval);

% Get rid of spindles that are too short
PotentialSpindleEpochs = dropShortIntervals(PotentialSpindleEpochs, minSpindleDuration);

% Get rid of spindles that are too long
PotentialSpindleEpochs = dropLongIntervals(PotentialSpindleEpochs, maxSpindleDuration);


%Epoch with maximum above threshold
func_max = @(a) measureOnSignal(a,'maximum');
if not(isempty(Start(PotentialSpindleEpochs)))
    [maxVal, ~, ~] = functionOnEpochs(SquaredFiltEEG, PotentialSpindleEpochs, func_max);
    spindles_interval = [Start(PotentialSpindleEpochs) End(PotentialSpindleEpochs)];
    idx_spindles =  (maxVal >= threshold(2) * stdVal);
    FinalSpindlesEpoch = intervalSet(spindles_interval(idx_spindles,1), spindles_interval(idx_spindles,2));
    
    %timestamps of the nadir
    if not(isempty(Start(FinalSpindlesEpoch,'ms')))
        func_min = @(a) measureOnSignal(a,'minimum');
        [~, nadir_tmp, ~] = functionOnEpochs(FiltEEG, FinalSpindlesEpoch, func_min);
    end
else
    FinalSpindlesEpoch = PotentialSpindleEpochs;
end


%% result
SpindlesEpoch = FinalSpindlesEpoch;
tSpindles = ts(nadir_tmp);


end










