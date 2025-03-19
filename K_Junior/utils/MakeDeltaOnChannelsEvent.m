%%MakeDeltaOnChannelsEvent
% 12.03.2018 KJ
%
% create delta waves with one or two channels, for a record, and create .evt.
%
% function 
%
% INPUT:
% - channels                    channels to use for the dectection
%                           
%
% - foldername (optional)       = folder path for the detection of delta waves
%                               (default pwd)
% - threshold (optional)        = threshold for the detection of delta
% - positive  (optional)        = 1 to detect positive deflection, 0 otherwise 
%                               (default 1)
% - scoring (optional):         = method used to distinguish sleep from wake 
%                               'accelero' or 'OB' or 'none'; 
%                               (default 'none')
%
%
% OUTPUT:
% - deltaPFCx_ch    = matrix (n_curves x n_pt) containing all curves 
%
%
%   see 
%       CreateDeltaWavesSleep
%


function DeltaOffline = MakeDeltaOnChannelsEvent(channels, varargin)


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
        case 'foldername'
            foldername = varargin{i+1};
        case 'positive'
            positive_bump = lower(varargin{i+1});
            if positive_bump~=0 && positive_bump~=1
                error('Incorrect value for property ''positive''.');
            end
        case 'threshold'
            threshold = varargin{i+1};
            if threshold<=0
                error('Incorrect value for property ''threshold''.');
            end
        case 'scoring'
            scoring = lower(varargin{i+1});
            if ~isstring_FMAToolbox(scoring, 'accelero' , 'ob', 'none')
                error('Incorrect value for property ''scoring''.');
            end
        case 'recompute'
            recompute = varargin{i+1};
            if recompute~=0 && recompute ~=1
                error('Incorrect value for property ''recompute''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('foldername','var')
    foldername=pwd;
end
if ~exist('positive_bump','var')
    positive_bump=1;
end
if ~exist('scoring','var')
    scoring='ob';
end
%recompute?
if ~exist('recompute','var')
    recompute=0;
end


%% names & recompute

if length(channels)==1
    multichan = 0;
    name_var = ['delta_ch_' num2str(channels(1))];
    EventFileName = fullfile(foldername, ['delta_ch_' num2str(channels(1)) ]);
    extens = 'sng';
    description= ['delta_waves_' num2str(channels(1))];
else
    multichan = 1;
    name_var = ['delta_ch_' num2str(channels(1)) '_' num2str(channels(2))];
    EventFileName = fullfile(foldername, ['delta_ch_' num2str(channels(1)) '_' num2str(channels(2))]);
    extens = 'mlt';
    description= ['delta_waves_' num2str(channels(1)) '_' num2str(channels(2))];
end


%check if already exist
if ~recompute
    if exist('DeltaWavesChannels.mat','file')==2
        load('DeltaWavesChannels', name_var)
        if exist(name_var,'var')
            disp(['Delta Waves already generated: ' name_var])
            return
        end
    end
end


%% params
freq_delta = [1 6];
thresh_std = 2;
thresh_std2 = 1; %for start and end
min_duration = 75;


% Epoch
if strcmpi(scoring,'accelero')
    try
        load SleepScoring_Accelero SWSEpoch TotalNoiseEpoch
    catch
        load StateEpoch SWSEpoch TotalNoiseEpoch
    end
    Epoch=SWSEpoch-TotalNoiseEpoch;
elseif strcmpi(scoring,'ob')
    try
        load SleepScoring_OBGamma SWSEpoch TotalNoiseEpoch
    catch
        load StateEpochSB SWSEpoch TotalNoiseEpoch
    end
    Epoch=SWSEpoch-TotalNoiseEpoch;
    
else
    Epoch = [];
end


%% Delta waves detection 

%two channels
if multichan
    load(fullfile(foldername,'LFPData' ,['LFP' num2str(channels(1))]))
    LFPdeep=LFP;
    load(fullfile(foldername,'LFPData' ,['LFP' num2str(channels(2))]))
    LFPsup=LFP;
    
    %normalize
    clear distance
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor = find(distance==min(distance))*0.1;
    %resample & filter & positive value
    SignalResample = ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    
%single channel
else
    load(fullfile(foldername,'LFPData' ,['LFP' num2str(channels(1))]))
    SignalResample = ResampleTSD(LFP,100);
end

%filtering
FiltLFP = FilterLFP(SignalResample, freq_delta, 1024);

%signal thresholded and thresholds
if positive_bump
    positive_filtered = max(Data(FiltLFP),0);
else
    positive_filtered = -min(Data(FiltLFP),0);
end
std_of_signal = std(positive_filtered(positive_filtered>0));  % std that determines thresholds
thresh_delta = thresh_std * std_of_signal;
all_cross_thresh = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_delta, 'Direction', 'Above');
center_detections = (Start(all_cross_thresh)+End(all_cross_thresh))/2;
    
%thresholds start ends
thresh_delta2 = thresh_std2 * std_of_signal;
all_cross_thresh2 = thresholdIntervals(tsd(Range(FiltLFP), positive_filtered), thresh_delta2, 'Direction', 'Above');
%intervals with detections inside
[~,intervals,~] = InIntervals(center_detections, [Start(all_cross_thresh2), End(all_cross_thresh2)]);
intervals = unique(intervals); intervals(intervals==0)=[];
%selected intervals
all_cross_thresh = subset(all_cross_thresh2,intervals);

%deltas
DeltaOffline = dropShortIntervals(all_cross_thresh, min_duration * 10); % crucial element for noise detection.
%Restrict
if ~isempty(Epoch)
    DeltaOffline = and(DeltaOffline, Epoch);
end

eval([name_var ' = DeltaOffline;'])


%% save
if exist(fullfile(foldername,'DeltaWavesChannels.mat'), 'file') == 2
    save(fullfile(foldername,'DeltaWavesChannels.mat'), name_var,'-append')
else
    save(fullfile(foldername,'DeltaWavesChannels.mat'), name_var)
end

%evt
evt.time = (Start(DeltaOffline) + End(DeltaOffline)) / 2E4;
for i=1:length(evt.time)
    evt.description{i}= description;
end

delete([EventFileName '.evt.' extens]);
CreateEvent(evt, EventFileName, extens);





end



