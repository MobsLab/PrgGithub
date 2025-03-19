%PlotDeltaDownObserver

clear

% params
frequency_sampling = 250;
freqDelta=[1 12];
thD = 1.8;
minDeltaDuration = 20;
minDeltaDurationDeep = 50;


mua_binsize=10;
thresh0 = 0.7;
minDownDur = 90;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;


%% Load data
load ChannelsToAnalyse/PFCx_deltadeep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_deltasup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

%Down states
try
    load newDownState Down
catch
    try
        load DownSpk Down
    catch
        Down = intervalSet([],[]);
    end
end    

%tones
try
    load('DeltaSleepEvent.mat', 'TONEtime1')
    delay = 2000;
    event_tmp = (TONEtime1 + delay) / 1E4;
catch
    load ShamSleepEvent SHAMtime
    event_tmp = Range(SHAMtime) / 1E4;
end


%% get lfp
EEGdeep = ResampleTSD(LFPdeep,frequency_sampling);
EEGsup = ResampleTSD(LFPsup,frequency_sampling);

%diff
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGdiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGdiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds
% deltas from diff
thresh_diff = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_diff, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.

%deep
EEGdeep=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_deep = FilterLFP(EEGdeep, freqDelta, 1024);
pos_filtdeep = max(Data(Filt_deep),0);
std_deep = std(pos_filtdeep(pos_filtdeep>0));  % std that determines thresholds
% deltas from deep
thresh_deep = thD * std_deep;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_deep), pos_filtdeep), thresh_deep, 'Direction', 'Above');
DeltaDeep = dropShortIntervals(all_cross_thresh, minDeltaDurationDeep * 10); % crucial element for noise detection.

%intersect diff and deep



%% get MUA and Down detections
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
MUA = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s

[Down, small_Down] = FindDown2_KJ(MUA, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');

%% signals and detections

labels = {'LFP deep(k) vs sup(b)', 'Diff', 'MUA'};
signals{1} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
signals{2} = [Range(LFPsup,'ms')'/1000 ; Data(LFPsup)'];
signals{3} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];

start_down = Start(Down,'ms')' / 1000;
down_duration = (End(Down,'ms') - Start(Down,'ms'))' / 1000;
% start_smalldown = Start(small_Down,'ms')' / 1000;
% smalldown_duration = (End(small_Down,'ms') - Start(small_Down,'ms'))' / 1000;

start_delta = Start(DeltaOffline,'ms')' / 1000;
delta_duration = (End(DeltaOffline,'ms') - Start(DeltaOffline,'ms'))' / 1000;

% start_deltadeep = Start(DeltaDeep,'ms')' / 1000;
% deltadeep_duration = (End(DeltaDeep,'ms') - Start(DeltaDeep,'ms'))' / 1000;


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.set_title(labels{ch}, ch);
    sog.add_verticals(event_tmp, ch);
end

%add events
sog.add_rectangles(start_deltadeep, deltadeep_duration, 1);
sog.add_rectangles(start_delta, delta_duration, 2);

sog.add_rectangles(start_down, down_duration, 3);
%sog.add_rectangles(start_smalldown, smalldown_duration, 3,'b');
sog.set_time_events(sort([start_down start_delta]));

%ylim
sog.set_ymin(1, -2600); sog.set_ymax(1, 2600);
sog.set_ymin(2, -2600); sog.set_ymax(2, 2600);
sog.set_ymin(3, 0); sog.set_ymax(3, 7);

sog.run_window





