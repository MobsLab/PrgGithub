%%ScriptLoadDeltaTonesOneNight
% 14.05.2019 KJ
%
%
%   see 
%       ScriptTonesInDeltaOneNight ScriptTonesInDeltaOneNight
 

% clear


%% params
freq_delta = [1 12];
thresh_std = 2;
thresh_std2 = 1;
min_duration = 40;


%% load

%sleep stage
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

%tones in deltas
load('behavResources.mat', 'ToneEvent')

%channels
%deep
load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
ch_deep = channel;
%sup
try
    load('ChannelsToAnalyse/PFCx_sup.mat', 'channel')
    ch_sup = channel;
catch
    load('ChannelsToAnalyse/PFCx_deltasup.mat', 'channel')
    ch_sup = channel;
end
%all location
load('ChannelsToAnalyse/PFCx_locations.mat', 'channels')

%LFP
PFC = cell(0);
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
end

%LFP deep and sup
PFCdeep = PFC{channels==ch_deep};
PFCsup = PFC{channels==ch_sup};
clear LFP


%% Detect delta waves
%normalize
clear distance
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(PFCdeep)-i*Data(PFCsup));
    k=k+1;
end
Factor = find(distance==min(distance))*0.1;

%resample & filter & positive value
EEGsleepDiff = ResampleTSD(tsd(Range(PFCdeep),Data(PFCdeep) - Factor*Data(PFCsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freq_delta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
%stdev
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

% deltas detection
thresh_delta = thresh_std * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
center_detections = (Start(all_cross_thresh)+End(all_cross_thresh))/2;

%thresholds start ends
thresh_delta2 = thresh_std2 * std_diff;
all_cross_thresh2 = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta2, 'Direction', 'Above');
%intervals with dections inside
[~,intervals,~] = InIntervals(center_detections, [Start(all_cross_thresh2), End(all_cross_thresh2)]);
intervals = unique(intervals); intervals(intervals==0)=[];
%selected intervals
all_cross_thresh = subset(all_cross_thresh2,intervals);

% crucial element for noise detection.
DeltaOffline = dropShortIntervals(all_cross_thresh, min_duration * 10);
all_deltas_PFCx = and(DeltaOffline, NREM);








