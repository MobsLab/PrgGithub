% DeltaDownISI

clear
%load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch Wake
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number

freqDelta = [1 6];
thD = 2;
thDeep = 2.4;
minDeltaDuration = 50;
binsize=10;
thresh0 = 0.7;
minDownDur = 100;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;


%% Deltas
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
pos_filtdiff = max(Data(Filt_diff),0);
std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
start_deltas = Start(DeltaOffline);


%% Multi-Unit activity and down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
Q = Restrict(Q, SWSEpoch);
%Down
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
DownCenters = ts(Start(Down) + (End(Down) - Start(Down)) / 2);
down_intervals = [Start(Down) End(Down)];
down_durations = End(Down) - Start(Down);
start_down = Start(Down);
nb_down = length(down_durations);


%% Intervals
intv_down = diff(start_down);
intv_delta = diff(start_deltas);

%% Distribution plot
edges = 0:50:2500;
figure, hold on
subplot(1,2,1),histogram(intv_down/10,edges), title('down ISI - No tone'),hold on,
subplot(1,2,2),histogram(intv_delta/10,edges), title('delta ISI - No tone')













