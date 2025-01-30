% ToneDelayBurstNoBurstEffect

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
load('DeltaSleepEvent.mat', 'TONEtime2')
allNightEpoch = intervalSet(min(Range(LFPsup)),max(Range(LFPsup)));

%params
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

%tones
delay = 2000; %in 1E-4s
ToneEvent = ts(TONEtime2 + delay);
nb_tones = length(ToneEvent);
%Burst
isiBurst_limit = 500;  % in ms
mergeBurst_limit = 700;


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
deltas_start = Start(DeltaOffline);


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
down_start = Start(Down);
down_end = End(Down);
nb_down = length(down_durations);
    
%% Bursts
%ISI
down_isi = (down_intervals(2:end,1) - down_intervals(1:end-1,2)) / 10;
small_isi = down_isi < isiBurst_limit;
start_burst = down_start(diff([0; small_isi])==1);% todo
end_burst = down_end(diff([0; small_isi])==-1);
if length(start_burst)>length(end_burst)
    end_burst = [end_burst;down_end(end)];
end

%Correction of burst
Bursts = intervalSet(start_burst,end_burst);
Bursts = mergeCloseIntervals(Bursts, mergeBurst_limit*10);
DeltaBurst=zeros(length(End(Bursts)), 2);
for k=1:length(Start(Bursts))  
    DeltaBurst(k,1)=length(Range(Restrict(DownCenters,subset(Bursts,k))));  % numbers of delta in the subset
    DeltaBurst(k,2)=End(subset(Bursts,k))-Start(subset(Bursts,k));  % burst size
end
burst_int = [Start(Bursts) End(Bursts)];

burst_ok = burst_int(DeltaBurst(:,1)>2,:); % only burst with more than 2 delta waves
DeltaBurst_ok = DeltaBurst(DeltaBurst(:,1)>2,:);


%% Tones in a burst vs tones out of bursts

good_bursts = intervalSet(burst_ok(:,1),burst_ok(:,2));
TonesBurst = Restrict(ToneEvent, good_bursts);
TonesNoburst = Restrict(ToneEvent, allNightEpoch-good_bursts);


%% Sound and delay

%Distribution
edges = 0:50:1000;
figure, hold on

%In burst
tones_burst_tmp = Range(TonesBurst);
%delta
delay_delta_tone = zeros(length(tones_burst_tmp), 1);
for i=1:length(tones_burst_tmp)
    idx_delta_before = find(deltas_start > tones_burst_tmp(i), 1);
    delay_delta_tone(i) = deltas_start(idx_delta_before) - tones_burst_tmp(i);    
end
%down states
delay_down_tone = zeros(length(tones_burst_tmp), 1);
for i=1:length(tones_burst_tmp)
    idx_down_before = find(down_start > tones_burst_tmp(i), 1);
    delay_down_tone(i) = down_start(idx_down_before) - tones_burst_tmp(i);
end

subplot(2,2,1),histogram(delay_delta_tone/10,edges), title('delta waves (burst)'),hold on,
subplot(2,2,2),histogram(delay_down_tone/10,edges), title('down states (burst)')


%Out of burst
tones_noburst_tmp = Range(TonesNoburst);
%delta
delay_delta_tone = zeros(length(tones_noburst_tmp), 1);
for i=1:length(tones_noburst_tmp)
    idx_delta_before = find(deltas_start > tones_noburst_tmp(i), 1);
    delay_delta_tone(i) = deltas_start(idx_delta_before) - tones_noburst_tmp(i);    
end
%down states
delay_down_tone = zeros(length(tones_noburst_tmp), 1);
for i=1:length(tones_noburst_tmp)
    idx_down_before = find(down_start > tones_noburst_tmp(i), 1);
    delay_down_tone(i) = down_start(idx_down_before) - tones_noburst_tmp(i);
end

subplot(2,2,3),histogram(delay_delta_tone/10,edges), title('delta waves (no burst)'),hold on,
subplot(2,2,4),histogram(delay_down_tone/10,edges), title('down states (no burst)')









