%% MakeSlowWavesOn1Channel_LP()
% 
% 08/05/2020  LP
%
% Function to create or append 'SlowWavesChannels_LP.mat' file
% with slow waves (positive and negative) detected on one channel
%
% -> slow waves detected as high amplitude events (>2SD)
% in the filtered LFP. For each wave, the peak is the maxima in the 
% filtered LFP during the interval corresponding to this wave. 
%
% -> for each positive / negative slow waves, 1 structure with :
%                 - peaktimes :    ts of slow waves peak times
%                 - peakamp :      tsd of slow waves peak amplitudes
%                 - wave_interv :  intervalSet of slow waves (from 1SD start and end)
%
%
% ----------------- INPUTS ----------------- :
%
% - channel  :  nº of LFP channel used for the detection
%                           
%
% -- Optional Parameters -- : 
% (as pairs : 'arg_name', arg_value) 
%
%   - 'foldername' :       folder path for the detection of slow waves
%                                   (default = pwd)
%
%   - 'epoch' :            epoch to which the detection is retsricted
%                                   'all', 'sleep', 'SWS'
%                                   (default = 'all') 
%
%   - 'filterfreq' :       frequency range to filter the LFP signal
%                                   before extracting events
%                                   (default = [1 5])
%
%   - 'recompute' :        recompute event if file and variables already
%                                   exist
%                                   (default = 0)
%
%   - 'filename' :         name of .mat file with the events
%                                   (default = 'SlowWavesChannels_LP') 
%
% ----------------- OUTPUTS ----------------- :
%
%                                       none
%
%
% ----------------- Example ----------------- :
%
% Ex.  MakeSlowWavesOn1Channel_LP(ChannelSup, 'epoch', 'all','filterfreq', [1 5]);

function MakeSlowWavesOn1Channel_LP(channels, varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list :

for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    
    switch(lower(varargin{i}))
        case 'foldername'
            foldername = varargin{i+1};
        case 'filterfreq'
            filterfreq = varargin{i+1};
        case 'epoch'
            epochname = lower(varargin{i+1});
            if ~isstring_FMAToolbox(epochname, 'all' , 'sws', 'sleep')
                error('Incorrect value for property ''epoch''.');
            end
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        case 'filename'
            filename = varargin{i+1};    
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if optional parameters exist and assign default value if not :

if ~exist('foldername','var')
    foldername=pwd;
end
if ~exist('epochname','var')
    epochname='all';
end
if ~exist('filterfreq','var')
    filterfreq = [1 5];
end
if ~exist('filename','var')
    filename = 'SlowWavesChannels_LP' ;
end
%recompute?
if ~exist('recompute','var')
    recompute=0;
end


%% names & recompute

% Variable Names : 
name_var_pos = ['slowwave_ch_' num2str(channels(1)) '_pos']; % positive slow waves
name_var_neg = ['slowwave_ch_' num2str(channels(1)) '_neg']; % negative slow waves


%check if already exist
if ~recompute
    if exist('SlowWavesChannels_LP.mat','file')==2
        load('SlowWavesChannels_LP', name_var_pos, name_var_neg)
        if exist(name_var_pos,'var')
            disp(['Slow Waves already generated: ' name_var_pos ', ' name_var_neg])
            return
        end
    end
end


%% PARAMETERS : 

% STD thresholds 
thresh_std = 2; % for event detection
thresh_std2 = 1; % for start and end of detected events
min_duration = 75; % minimal duration of events to keep, in ms


%% SLOW WAVES DETECTION

% Load LFP : 
load(fullfile(foldername,'LFPData' ,['LFP' num2str(channels(1))]))
SignalResample = ResampleTSD(LFP,100); % sampling frequency 100Hz



% Epoch (without noise)

if strcmpi(epochname,'all') % whole session
    try
        load SleepScoring_OBGamma TotalNoiseEpoch
    catch
        load StateEpochSB TotalNoiseEpoch
    end
    l = Range(LFP) ; 
    Epoch = intervalSet([l(1)],[l(end)]) ; 
    Epoch=Epoch-TotalNoiseEpoch;
    
elseif strcmpi(epochname,'sleep') % sleep
    try
        load SleepScoring_OBGamma Sleep TotalNoiseEpoch
    catch
        load StateEpochSB Sleep TotalNoiseEpoch
    end
    Epoch=Sleep-TotalNoiseEpoch;    
    
elseif strcmpi(epochname,'sws') % SWS
    try
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    catch
        load StateEpochSB SWSEpoch TotalNoiseEpoch
    end
    Epoch=SWSEpoch-TotalNoiseEpoch;   
end





% Filtering : 
FiltLFP = FilterLFP(SignalResample, filterfreq, 1024);


% Sort signal to keep positive or negative deflections separately : 
positive_filtered = max(Data(FiltLFP),0); % positive signal only 
negative_filtered = -min(Data(FiltLFP),0); % negative signal only



% --------- Get POSITIVE Slow Waves --------- : 

% --- Slow wave intervals --- : 

    % threshold for slow wave detection : 
std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
thresh_slow = thresh_std * std_of_signal;
all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_slow, 'Direction', 'Above'); % intervals in which tsd is above threshold
center_detections = (Start(all_cross_thresh)+End(all_cross_thresh))/2; % center time of detection for each detected slow wave
    
    % threshold for start and end of intervals : 
thresh_slow2 = thresh_std2 * std_of_signal;
all_cross_thresh2 = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_slow2, 'Direction', 'Above');
    %keep only intervals with detections inside : 
[~,intervals,~] = InIntervals(center_detections, [Start(all_cross_thresh2), End(all_cross_thresh2)]); 
intervals = unique(intervals); intervals(intervals==0)=[];
all_cross_thresh = subset(all_cross_thresh2,intervals);

    % Drop intervals shorter than min_duration : 
SlowWave_is = dropShortIntervals(all_cross_thresh, min_duration * 10); % crucial for noise detection.

    %Restrict intervals to Epoch : 
if ~isempty(Epoch)
    SlowWave_is = and(SlowWave_is, Epoch);
end

% --- Detect Slow Wave Peaks --- : 

positive_filtered_tsd = tsd(Range(FiltLFP),positive_filtered) ; 
SlowWave_peaks = max_tsd(positive_filtered_tsd,SlowWave_is) ; % find peak (max amplitude) in the filtered signal for each slow wave 

% Save positive slow waves (structure) : 
eval([name_var_pos '.peaktimes = ts(Range(SlowWave_peaks));']) % peak times 
eval([name_var_pos '.peakamp = SlowWave_peaks ;']) % peak amplitudes
eval([name_var_pos '.wave_interv = SlowWave_is ;']) % slow wave intervals


% --------- Get NEGATIVE Slow Waves --------- : 

% --- Slow wave intervals --- : 

    % threshold for slow wave detection : 
std_of_signal = std(negative_filtered(negative_filtered>0));  % std that determines thresholds
thresh_slow = thresh_std * std_of_signal;
all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), negative_filtered), thresh_slow, 'Direction', 'Above'); % intervals in which tsd is above threshold
center_detections = (Start(all_cross_thresh)+End(all_cross_thresh))/2; % center time of detection for each detected slow wave
    
    % threshold for start and end of intervals : 
thresh_slow2 = thresh_std2 * std_of_signal;
all_cross_thresh2 = thresholdIntervals(tsd(Range(FiltLFP), negative_filtered), thresh_slow2, 'Direction', 'Above');
    %keep only intervals with detections inside : 
[~,intervals,~] = InIntervals(center_detections, [Start(all_cross_thresh2), End(all_cross_thresh2)]); 
intervals = unique(intervals); intervals(intervals==0)=[];
all_cross_thresh = subset(all_cross_thresh2,intervals);

    %Restrict to Epoch : 
if ~isempty(Epoch)
    SlowWave_is = and(all_cross_thresh, Epoch);
end

    % Drop intervals shorter than min_duration : 
SlowWave_is = dropShortIntervals(SlowWave_is, min_duration * 10); % crucial for noise detection.


% --- Detect Slow Wave Peaks --- : 

negative_filtered_tsd = tsd(Range(FiltLFP),negative_filtered) ; 
SlowWave_peaks = max_tsd(negative_filtered_tsd,SlowWave_is) ; % find peak (max amplitude) in the filtered signal for each slow wave 

%Save negative slow waves  (structure) : 
eval([name_var_neg '.peaktimes = ts(Range(SlowWave_peaks));']) % peak times 
eval([name_var_neg '.peakamp = SlowWave_peaks ;']) % peak amplitudes
eval([name_var_neg '.wave_interv = SlowWave_is ;']) % slow wave intervals




%% SAVE SLOW WAVES

% Parameters :
detection_parameters.detectionthresh = [num2str(thresh_std) ' SD'] ; 
detection_parameters.intervalthresh = [num2str(thresh_std2) ' SD'] ; 
detection_parameters.min_duration = min_duration ; 
detection_parameters.filterfreq = filterfreq ;
detection_parameters.epoch = epochname ; 

% Save : 
if exist(fullfile(foldername,[filename '.mat']), 'file') == 2 % check file (with extension -> ==2)
    save(fullfile(foldername,[filename '.mat']), name_var_neg, name_var_pos, 'detection_parameters', '-append')
else
    save(fullfile(foldername,[filename '.mat']), name_var_neg, name_var_pos, 'detection_parameters')
end




end



