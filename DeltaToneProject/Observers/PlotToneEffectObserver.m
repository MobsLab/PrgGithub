%PlotToneEffectObserver

%GUI that shows tones and their effect on delta
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
down_durations = End(Down) - Start(Down);
down_start = Start(Down);
down_end = End(Down);
nb_down = length(down_durations);


%% signals
MUA = Q;
LFPdiff = tsd(Range(LFPsup), Data(LFPdeep) - Data(LFPsup));
tones_start = Range(tones,'ms') / 1000;

signals{1} = [Range(LFPsup,'ms')'/1000 ; Data(LFPsup)']; 
signals{2} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
signals{3} = [Range(LFPdiff','ms')'/1000 ; Data(LFPdiff)'];
signals{4} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];
%signals{5} = [Range(MUA,'ms')'/1000 ; smooth(full(Data(MUA)),6)'];


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.add_rectangles(down_start/1E4, down_durations/1E4, ch);
    sog.add_verticals(tones_start, ch)
end
sog.set_time_events(tones_start);
sog.set_title('LFP sup', 1);
sog.set_title('LFP deep', 2);
sog.set_title(['LFP diff'], 3);
sog.set_title('MUA', 4);
%sog.set_title('MUA smooth', 5);

sog.set_ymin(1, -2000); sog.set_ymax(1, 2000);
sog.set_ymin(2, -2000); sog.set_ymax(2, 2000);
sog.set_ymin(3, -2000); sog.set_ymax(3, 2000);
sog.set_ymin(4, 0); sog.set_ymax(4, 5);
%sog.set_ymin(5, 0); sog.set_ymax(5, 5);

sog.run_window

