%PlotBurstDeltaObserver

%GUI that shows burst of delta and timestamps of tones

clear
%Load data
load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP
load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPsup=LFP;
clear LFP
clear channel
load StateEpochSB SWSEpoch
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
load DeltaSleepEvent TONEtime2
delay = 2000;
tones = ts(TONEtime2 + delay);  % real tones


%Args
binsize=10;
thresh0 = 0.7;
minDownDur = 75;
maxDownDur = 500;
mergeGap = 10; % duration max to allow a merge of silence period
predown_size = 50;
%Burst
isiBurst_limit = 500;  % in ms
mergeBurst_limit = 700;


%% Find Down
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10);
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
DownCenters = ts(Start(Down) + (End(Down) - Start(Down)) / 2);
down_intervals = [Start(Down) End(Down)];
down_durations = End(Down, 'ms') - Start(Down, 'ms');
down_start = Start(Down);
down_end = End(Down);
nb_down = length(down_durations);


%% ISI
down_isi = (down_intervals(2:end,1) - down_intervals(1:end-1,2)) / 10;
small_isi = down_isi < isiBurst_limit;
start_burst = down_start(diff([0; small_isi])==1);% todo
end_burst = down_end(diff([0; small_isi])==-1);
if length(start_burst)>length(end_burst)
    end_burst = [end_burst;down_end(end)];
end


%% Correction of burst
Bursts = intervalSet(start_burst,end_burst);
Bursts = mergeCloseIntervals(Bursts, mergeBurst_limit*10);
DeltaBurst=zeros(length(End(Bursts)), 2);
for k=1:length(Start(Bursts))  
    DeltaBurst(k,1)=length(Range(Restrict(DownCenters,subset(Bursts,k))));  % numbers of delta in the subset
    DeltaBurst(k,2)=End(subset(Bursts,k),'s')-Start(subset(Bursts,k),'s');  % burst size
end
burst_int = [Start(Bursts,'ms') End(Bursts,'ms')];

burst_ok = burst_int(DeltaBurst(:,1)>2,:); % only burst with more than 2 delta waves
DeltaBurst_ok = DeltaBurst(DeltaBurst(:,1)>2,:);


%% signals
MUA = Q;
LFPdiff = tsd(Range(LFPsup), Data(LFPdeep) - Data(LFPsup));
burst_start = burst_ok(:,1)/1000;
burst_duration = (burst_ok(:,2) - burst_ok(:,1))/1000;
tones_start = Range(tones,'ms') / 1000;

signals{1} = [Range(LFPsup,'ms')'/1000 ; Data(LFPsup)']; 
signals{2} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
signals{3} = [Range(LFPdiff','ms')'/1000 ; Data(LFPdiff)'];
signals{4} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];
signals{5} = [Range(MUA,'ms')'/1000 ; smooth(full(Data(MUA)),6)'];


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.add_rectangles(burst_start, burst_duration, ch);
    sog.add_verticals(tones_start, ch)
end
sog.set_time_events(burst_start);
sog.set_title('LFP sup', 1);
sog.set_title('LFP deep', 2);
sog.set_title(['LFP diff'], 3);
sog.set_title('MUA', 4);
sog.set_title('MUA smooth', 5);

sog.set_ymin(1, -2000); sog.set_ymax(1, 2000);
sog.set_ymin(2, -2000); sog.set_ymax(2, 2000);
sog.set_ymin(3, -2000); sog.set_ymax(3, 2000);
sog.set_ymin(4, 0); sog.set_ymax(4, 5);
sog.set_ymin(5, 0); sog.set_ymax(5, 5);

sog.run_window


















