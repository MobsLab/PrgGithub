%DatasetForNN1

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
start_down = Start(Down);


%% Tones that induces a down or not
effect_period = 2000; %200ms
tone_intv = intervalSet(Range(ToneEvent), Range(ToneEvent) + effect_period);  % Tone and its window where an effect could be observed
induce_down = zeros(nb_tones, 1);

[status,interval,~] = InIntervals(start_down, [Start(tone_intv) End(tone_intv)]);
tone_success = unique(interval);
induce_down(tone_success(2:end)) = 1;  %do not consider the first nul element


%% Dataset

frequency_sampling = 1250;
tone_tmp = Range(ToneEvent);
window_length = 20; %in s

training = zeros(nb_tones, 2 * frequency_sampling * window_length);
for i=1:nb_tones
    if mod(i,200)==0
        disp(i)
    end
    subEpoch = intervalSet(tone_tmp(i) - window_length * 1E4, tone_tmp(i));
    
    sub_deep = Restrict(LFPdeep, subEpoch);
    sub_sup = Restrict(LFPsup, subEpoch);
    training(i,:) = [Data(sub_sup)' Data(sub_deep)'];

end


%Write
hdf5write('mouse244_17042015.h5', '/training', training);
hdf5write('mouse244_17042015.h5', '/induce_down', induce_down, 'WriteMode', 'append');

















