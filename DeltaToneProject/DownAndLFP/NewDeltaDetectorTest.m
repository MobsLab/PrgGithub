% NewDeltaDetectorTest
% 23.10.2017 KJ
%
% New detector with 3 layer
%
%
%


clear

%params
freqDelta = [1 40];
thD = 1.4;
minPosCrossingDuration = 50;
minNegCrossingDuration = 50;


%channels = [32 34 36 38 58 59 60 61 62 63]; %244
channels = [0 3 5 7 25 26 27 29 31]; %243


channel_deep = 3;
channel_mid = 7;
channel_sup = 27;


%% Load data
%PFC deep
eval(['load LFPData/LFP',num2str(channel_deep)])
PFC_deep = LFP;
clear LFP
%PFC middle
eval(['load LFPData/LFP',num2str(channel_mid)])
PFC_mid = LFP;
clear LFP
%PFC sup
eval(['load LFPData/LFP',num2str(channel_sup)])
PFC_sup = LFP;
clear LFP


%Stages
load StateEpochSB SWSEpoch

%MUA
mua_binsize = 10;
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
MUA = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s


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
Down = and(Down,SWSEpoch);
center_down = (Start(Down) + End(Down)) / 2;

%classic Delta
load DeltaPFCx DeltaOffline


%% deepmid difference
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(PFC_deep)-i*Data(PFC_mid));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
Diff_deepmid=ResampleTSD(tsd(Range(PFC_deep),Data(PFC_deep) - Factor*Data(PFC_mid)),250);
Filt_deepmid = FilterLFP(Diff_deepmid, freqDelta, 1024);
pos_deepmid = max(Data(Filt_deepmid),0);
neg_deepmid = abs(min(Data(Filt_deepmid),0));

% std that determines thresholds
std_pos = std(pos_deepmid(pos_deepmid>0));  
std_neg = std(neg_deepmid(neg_deepmid>0));
thresh_pos = thD * std_pos;
thresh_neg = thD * std_neg;

%thresh crossings
all_cross_pos = thresholdIntervals(tsd(Range(Filt_deepmid), pos_deepmid), thresh_pos, 'Direction', 'Above');
PosCrossings_deepmid = dropShortIntervals(all_cross_pos, minPosCrossingDuration * 10); % crucial element for noise detection.
all_cross_neg = thresholdIntervals(tsd(Range(Filt_deepmid), neg_deepmid), thresh_neg, 'Direction', 'Above');
NegCrossings_deepmid = dropShortIntervals(all_cross_neg, minNegCrossingDuration * 10); 


%% midsup difference
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(PFC_mid)-i*Data(PFC_sup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
Diff_midsup = ResampleTSD(tsd(Range(PFC_mid),Data(PFC_mid) - Factor*Data(PFC_sup)),250);
Filt_midsup = FilterLFP(Diff_midsup, freqDelta, 1024);
pos_midsup = max(Data(Filt_midsup),0);
neg_midsup = abs(min(Data(Filt_midsup),0));

% std that determines thresholds
std_pos = std(pos_midsup(pos_midsup>0));  
std_neg = std(neg_midsup(neg_midsup>0));
thresh_pos = thD * std_pos;
thresh_neg = thD * std_neg;

%thresh crossings
all_cross_pos = thresholdIntervals(tsd(Range(Filt_midsup), pos_midsup), thresh_pos, 'Direction', 'Above');
PosCrossings_midsup = dropShortIntervals(all_cross_pos, minPosCrossingDuration * 10); % crucial element for noise detection.
all_cross_neg = thresholdIntervals(tsd(Range(Filt_midsup), neg_midsup), thresh_neg, 'Direction', 'Above');
NegCrossings_midsup = dropShortIntervals(all_cross_neg, minNegCrossingDuration * 10); 


%% new_signal
y_data = Data(Diff_deepmid) .* Data(Diff_midsup);
y_data = y_data / (std(Data(Diff_deepmid)) * std(Data(Diff_midsup)));
mult_signal = tsd(Range(Diff_deepmid), y_data);

%threshold
pos_multi = max(Data(mult_signal),0);
neg_multi = abs(min(Data(mult_signal),0));
std_pos = std(pos_multi(pos_multi>0));  
std_neg = std(neg_multi(neg_multi>0));
thresh_pos = thD * std_pos;
thresh_neg = thD * std_neg;

%thresh crossings
all_cross_pos = thresholdIntervals(tsd(Range(mult_signal), pos_multi), thresh_pos, 'Direction', 'Above');
PosCrossings_multi = dropShortIntervals(all_cross_pos, minPosCrossingDuration * 10); % crucial element for noise detection.
all_cross_neg = thresholdIntervals(tsd(Range(mult_signal), neg_multi), thresh_neg, 'Direction', 'Above');
NegCrossings_multi = dropShortIntervals(all_cross_neg, minNegCrossingDuration * 10); 


%% Crossings intersection and suite
PosCrossings = intersect(PosCrossings_deepmid, PosCrossings_midsup);
NegCrossings = intersect(NegCrossings_deepmid, NegCrossings_midsup);


binsize = 50;
nbins = 50;
[P, x1] = CrossCorr(center_down, Start(PosCrossings), binsize, nbins);
[N, x2] = CrossCorr(center_down, Start(NegCrossings), binsize, nbins);
figure, hold on, plot(x1/10,P); hold on, plot(x2/10,N);


[C, x3] = CrossCorr(Start(PosCrossings), Start(NegCrossings), binsize, nbins);
figure, hold on, plot(x3/10,C);



%% signals and detections

clear signals
labels = {'Deep (k) - Middle (b) - Sup (r)', 'Multi', 'MUA'};
signals{1} = [Range(PFC_deep,'ms')'/1000 ; Data(PFC_deep)'; Data(PFC_mid)'; Data(PFC_sup)'];
signals{2} = [Range(mult_signal,'ms')'/1000 ; Data(mult_signal)'];
signals{3} = [Range(MUA,'ms')'/1000 ; full(Data(MUA)')];

start_down = Start(Down,'ms')' / 1000;
down_duration = (End(Down,'ms') - Start(Down,'ms'))' / 1000;

start_delta = Start(DeltaOffline,'ms')' / 1000;
delta_duration = (End(DeltaOffline,'ms') - Start(DeltaOffline,'ms'))' / 1000;

% start_poscross_dm = Start(PosCrossings_deepmid,'ms')' / 1000;
% poscross_dm_duration = (End(PosCrossings_deepmid,'ms') - Start(PosCrossings_deepmid,'ms'))' / 1000;
% start_negcross_dm = Start(NegCrossings_deepmid,'ms')' / 1000;
% negcross_dm_duration = (End(NegCrossings_deepmid,'ms') - Start(NegCrossings_deepmid,'ms'))' / 1000;
% 
% start_poscross_ms = Start(PosCrossings_midsup,'ms')' / 1000;
% poscross_ms_duration = (End(PosCrossings_midsup,'ms') - Start(PosCrossings_midsup,'ms'))' / 1000;
% start_negcross_ms = Start(NegCrossings_midsup,'ms')' / 1000;
% negcross_ms_duration = (End(NegCrossings_midsup,'ms') - Start(NegCrossings_midsup,'ms'))' / 1000;

start_poscross_multi = Start(PosCrossings_multi,'ms')' / 1000;
poscross_multi_duration = (End(PosCrossings_multi,'ms') - Start(PosCrossings_multi,'ms'))' / 1000;
start_negcross_multi = Start(NegCrossings_multi,'ms')' / 1000;
negcross_multi_duration = (End(NegCrossings_multi,'ms') - Start(NegCrossings_multi,'ms'))' / 1000;


%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.set_title(labels{ch}, ch);
end

%add events
sog.add_rectangles(start_delta, delta_duration, 1);
sog.add_rectangles(start_poscross_multi, poscross_multi_duration, 2, 'b');
sog.add_rectangles(start_negcross_multi, negcross_multi_duration, 2);
sog.add_rectangles(start_down, down_duration, 3);
sog.set_time_events(start_down);

%ylim
sog.set_ymin(1, -2600); sog.set_ymax(1, 2600);
sog.set_ymin(2, -5); sog.set_ymax(2, 5);
sog.set_ymin(3, 0); sog.set_ymax(3, 7);

sog.run_window


