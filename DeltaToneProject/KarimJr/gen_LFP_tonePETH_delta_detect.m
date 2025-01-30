%gen_LFP_tonePETH_delta_detect

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
load('DeltaSleepEvent.mat', 'TONEtime2_SWS')

nb_tones = length(TONEtime2_SWS);
delay = 2000; %in 1E-4s
ToneEvent = Restrict(ts(TONEtime2_SWS + delay),SWSEpoch);

%params
freqDelta = [1 6];
thD = 2;
thDeep = 2.4;
minDeltaDuration = 50;


t_before = -30000; %in 1E-4s
t_after = 20000; %in 1E-4s

%% Multi-Unit activity
binsize=10;
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s


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

EEGsleepDeep=ResampleTSD(LFPdeep,100);
Filt_deep = FilterLFP(EEGsleepDeep, freqDelta, 1024);
pos_filtdeep = max(Data(Filt_deep),0);
std_deep = std(pos_filtdeep(pos_filtdeep>0));  % std that determines thresholds


%% deltas

%diff
thresh_delta = thD * std_diff;
all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
deltas_tmp = Start(DeltaOffline) + (End(DeltaOffline)-Start(DeltaOffline)) / 2;

%deep
thresh_delta_deep = thDeep * std_deep;
all_cross_thresh2 = thresholdIntervals(tsd(Range(Filt_deep), pos_filtdeep), thresh_delta_deep, 'Direction', 'Above');
DeltaOfflineDeep = dropShortIntervals(all_cross_thresh2, minDeltaDuration * 10); % crucial element for noise detection.
deltas_tmp_deep = Start(DeltaOfflineDeep) + (End(DeltaOfflineDeep)-Start(DeltaOfflineDeep)) / 2;

% fake delta: deep and not diff
deltas_intervals = [Start(DeltaOffline)-1000 End(DeltaOffline)+1000];
[status,interval,index] = InIntervals(deltas_tmp_deep, deltas_intervals);
fake_deltas = deltas_tmp_deep(status==0);


%% ordered data
tones_tmp = Range(ToneEvent);
last_delta_tone = zeros(nb_tones, 1);
last_fake_tone = zeros(nb_tones, 1);
last_event_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_delta_before = find(deltas_tmp < tones_tmp(i), 1, 'last');
    last_delta_tone(i) = tones_tmp(i) - deltas_tmp(idx_delta_before);
    
    idx_fake_before = find(fake_deltas < tones_tmp(i), 1, 'last');
    last_fake_tone(i) = tones_tmp(i) - fake_deltas(idx_fake_before);
    
    last_event_tone(i) = (last_delta_tone(i) > last_fake_tone(i)); % equals 1 if a fake appeared between sound and deltas
    
end
[delay_delta_sort, idx_delta_sort] = sort(last_delta_tone, 'ascend');
[delay_fake_sort, idx_fake_sort] = sort(last_fake_tone, 'ascend');

ToneAlone = ts(tones_tmp(last_event_tone == 0));
[delta_alone, idx_delta_alone] = sort(last_delta_tone(last_event_tone == 0),'ascend');
ToneWithFake = ts(tones_tmp(last_event_tone == 1));
[delta_with_fake, idx_delta_withfake] = sort(last_delta_tone(last_event_tone==1),'ascend');


%% PETH
figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(Q, ToneEvent, idx_delta_sort, t_before, t_after);
hold on, title('MUA diff tone SWS')

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(EEGsleepDiff, ToneEvent, idx_delta_sort, t_before, t_after);
hold on, title('LFP diff tone SWS')

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(Q, ToneEvent, idx_fake_sort, t_before, t_after);
hold on, title('MUA fake tone SWS')   

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(EEGsleepDiff, ToneEvent, idx_fake_sort, t_before, t_after);
hold on, title('LFP fake tone SWS')   



figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(Q, ToneAlone, idx_delta_alone, t_before, t_after);
hold on, title('MUA delta alone SWS')   

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(EEGsleepDiff, ToneAlone, idx_delta_alone, t_before, t_after);
hold on, title('LFP delta alone SWS')

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(Q, ToneWithFake, idx_delta_withfake, t_before, t_after);
hold on, title('MUA delta with fake SWS')   

figure, [fh, rasterAx, histAx, LFP_SingleTone(i)] = ImagePETHOrdered(EEGsleepDiff, ToneWithFake, idx_delta_withfake, t_before, t_after);
hold on, title('LFP delta with fake SWS')





