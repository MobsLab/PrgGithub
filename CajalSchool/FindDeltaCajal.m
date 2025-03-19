function [Delta,deltaEpoch]=FindDeltaCajal(channel_deep,channel_sup,Epoch,th,freq)

try
    freq;
    InputInfo.freq_delta = freq;
catch
    InputInfo.freq_delta = [1 12];
end
try
    th;
    InputInfo.thresh_std = th;
catch
InputInfo.thresh_std = 2;
end

InputInfo.Epoch=Epoch;

InputInfo.min_duration = 50;

try
eval(['load LFPData/LFP',num2str(channel_deep)])
LFPdeep=LFP;
end
try
eval(['load LFPData/LFP',num2str(channel_sup)])
LFPsup=LFP;
end
    


%resample & filter & positive value
if ~isempty(channel_deep)&~isempty(channel_sup)
     clear distance
    k=1;
    for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
    end
Factor = find(distance==min(distance))*0.1;
    EEGsleepDiff = ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
elseif ~isempty(channel_deep)&isempty(channel_sup)
    EEGsleepDiff = ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep)),100);
elseif isempty(channel_deep)&~isempty(channel_sup)
    EEGsleepDiff = ResampleTSD(tsd(Range(LFPsup),-Data(LFPsup)),100);
end
    
    

Filt_diff = FilterLFP(EEGsleepDiff, InputInfo.freq_delta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);

%stdev
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

% deltas
thresh_delta = InputInfo.thresh_std * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, InputInfo.min_duration * 10); % crucial element for noise detection.
%SWS
deltaEpoch = and(DeltaOffline, InputInfo.Epoch);

Delta=[Start(deltaEpoch,'s') Start(deltaEpoch,'s')+(End(deltaEpoch,'s')-Start(deltaEpoch,'s'))/2 End(deltaEpoch,'s')];

