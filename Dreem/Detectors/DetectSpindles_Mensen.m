function SpindlesEpoch=DetectSpindles_Mensen(EEG,varargin)
%
%   SpindlesEpoch=DetectSpindles_Mensen(EEG,varargin)
%
% INPUT
%   EEG                 tsd: EEG signal
%
%   spindlesBand        (optional) spindles frequency band for detection
%                       (default [10 16] Hz)
%
% OUTPUT
%   SpindlesEpoch      intervalSet - Epochs detected
%
% SEE
%    FindSpindlesDreem DetectSlowWaves_KJ
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
        case 'spindlesband'
            spindlesBand = varargin{i+1};
            if ~isvector(spindlesBand) || length(spindlesBand)~=2
                error('Incorrect value for property ''spindlesBand''.');
            end
        case 'noise_epoch'
            noiseEpoch = varargin{i+1};

        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check if exist and assign default value if not
if ~exist('fs','var')
    fs = 250;
end
if ~exist('spindlesBand','var')
    spindlesBand = [10 16];
end
if ~exist('noiseEpoch','var')
    noiseEpoch = intervalSet([],[]);
end

if ~exist('filter_window','var')
    filter_window = 0.5;
end
if ~exist('relative_amplitude','var')
    relative_amplitude = [7 3];
end
if ~exist('wavelength_chan','var')
    wavelength_chan = [0.5 2.5];
end
if ~exist('noiseThreshold','var')
    noiseThreshold = 110;
end
    
% Wavelet Parameters
waveName = 'fbsp1-1-3';
wavelet_center = centfrq(waveName);
freqCent = spindlesBand(1):0.5:spindlesBand(2);
scales = wavelet_center./(freqCent./ fs);

Info=[];
Info = swa_getInfoDefaults(Info, 'SS');


%% Detection

y_data = Data(EEG)';
goodEpoch = CleanUpEpoch(intervalSet(0,max(Range(EEG))) - noiseEpoch);

% --Continuous Wavelet Transform -- %
cwtCoeffs = cwt(y_data, scales, waveName);
cwtCoeffs = abs(cwtCoeffs.^ 2);
cwtPower = nanmean(cwtCoeffs);

% smooth the wavelet power
window = ones(round(fs * filter_window), 1) / round(fs * filter_window);
y_cwt = filtfilt(window, 1, cwtPower);  

% -- Threshold crossings -- %
% if no soft threshold specified make 50% of first
if length(relative_amplitude) == 1
    relative_amplitude(2) = relative_amplitude(1) * 0.5;
end


%% Calculate power threshold criteria
% calculate the standard deviation from the mean
std_wavelet = mad(y_cwt, 1);

% calculate the absolute threshold for that canonical wave
threshold_hard = (std_wavelet * relative_amplitude(1)) + median(y_cwt);
% TODO: save soft thresholds for later standardisation of absolute thresholds
threshold_soft = (std_wavelet * relative_amplitude(2)) + median(y_cwt);


%% -- Get the times where power data is above high threshold --%
signData = sign(y_cwt - threshold_hard);
power_start = find(diff(signData) == 2);
power_end = find(diff(signData) == -2);

% Check for earlier start than end
if power_end(1) < power_start(1)
    power_end(1) = [];
end

% Check for end after start
if length(power_start) > length(power_end)
    power_start(end) = [];
end

% Check Soft Minimum Length (30% less than actual minimum) %
SS_lengths = power_end - power_start;
minimum_length = (wavelength_chan(1) / 1.3) * fs;

% remove all potentials under the soft minimum length
power_start(SS_lengths < minimum_length) = [];
power_end(SS_lengths < minimum_length) = [];

% check softer threshold for actual start of spindle
spindle_start = nan(length(power_start), 1);
spindle_end = nan(length(power_start), 1);
% above soft threshold points
signData = sign(y_cwt - threshold_soft);
soft_start = find(diff(signData) == 2);
soft_end = find(diff(signData) == -2);

% loop over each (potential) spindle and find "true" start
for n = 1 : length(power_start)
    % advance/delay each start/end based on soft threshold
    advance = min(power_start(n) - soft_start(soft_start < power_start(n)));

    % check for very early spindle with no soft start
    if isempty(advance)
        spindle_start(n) = 1;
    else
        spindle_start(n) = power_start(n) - advance;
    end

    % look for soft threshold cross after hard threshold
    delay = min(soft_end(soft_end > power_end(n)) - power_end(n));        
    % check that power crosses low threshold before recording end
    if isempty(delay)
        spindle_end(n) = length(signData);
    else
        spindle_end(n) = power_end(n) + delay;
    end
end

% make sure spindle starts are unique 
% NOTE: could have been double hard crossing without soft crossing
spindle_start = unique(spindle_start);
spindle_end = unique(spindle_end);

% re-check lengths
if length(spindle_end) > length(spindle_start)
    spindle_end(end) = [];
end

% Check Hard Minimum Length %
SS_lengths = spindle_end - spindle_start;
minimum_length = wavelength_chan(1) * fs;

spindle_start(SS_lengths < minimum_length) = [];
spindle_end(SS_lengths < minimum_length) = [];
SS_lengths(SS_lengths < minimum_length) = [];

% Check Maximum Length %
maximum_length = wavelength_chan(2) * fs;
spindle_start(SS_lengths > maximum_length) = [];
spindle_end(SS_lengths > maximum_length) = [];
% SS_lengths(SS_lengths > maximum_length) = []; 

PreSpindlesEpoch = intervalSet(spindle_start*1e4/fs, spindle_end*1e4/fs);


%% Noise detection (exclude)
Noise_neg = thresholdIntervals(Restrict(EEG,PreSpindlesEpoch), -noiseThreshold,'Direction','Below');
Noise_pos = thresholdIntervals(Restrict(EEG,PreSpindlesEpoch), noiseThreshold,'Direction','Above');
noise_points = sort([(Start(Noise_neg)+End(Noise_neg))/2 ; (Start(Noise_pos)+End(Noise_pos))/2]);

PreSpindlesIntv = [Start(PreSpindlesEpoch) End(PreSpindlesEpoch)];
[~,interval,~] = InIntervals(noise_points,PreSpindlesIntv);
noise_sw_intv = unique(interval);
noise_sw_intv(noise_sw_intv==0)=[]; 

PreSpindlesIntv(noise_sw_intv,:)=[];


%% Return
SpindlesEpoch = intervalSet(PreSpindlesIntv(:,1),PreSpindlesIntv(:,2));
SpindlesEpoch = and(SpindlesEpoch,goodEpoch);



end










