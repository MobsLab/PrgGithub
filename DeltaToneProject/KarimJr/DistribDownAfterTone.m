% DistribDownAfterTone

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

%params
freqDelta = [1 6];
thD = 2;
minDeltaDuration = 50;
binsize=10;
thresh0 = 0.7;
minDownDur = 100;
maxDownDur = 500;
mergeGap = 10; % merge
predown_size = 50;

%tones
delay = 2000; %in 1E-4s
ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
nb_tones = length(ToneEvent); 


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
down_tmp = Start(Down) + (End(Down)-Start(Down)) / 2;
down_start = Start(Down);
    
    
%% Signals
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


%% deltas
%diff
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
start_deltas = Start(DeltaOffline);


%% Sound and delay
tones_tmp = Range(ToneEvent);

%delta
delay_delta_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_delta_before = find(start_deltas > tones_tmp(i), 1);
    delay_delta_tone(i) = start_deltas(idx_delta_before) - tones_tmp(i);    
end

%down states
delay_down_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_down_before = find(down_start > tones_tmp(i), 1);
    delay_down_tone(i) = down_start(idx_down_before) - tones_tmp(i);
end


%% Distribution plot
edges = 0:50:1000;
figure, hold on
subplot(1,2,1),histogram(delay_delta_tone/10,edges), title('delta waves'),hold on,
subplot(1,2,2),histogram(delay_down_tone/10,edges), title('down states')











