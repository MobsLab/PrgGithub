% FirstDeltaAfterTone

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

tones = Range(ToneEvent);
good_tones = tones(induce_down==1);
bad_tones = tones(induce_down==0);

intv_good_tones = zeros(length(good_tones),1);
for i=1:length(good_tones)
    next_down = start_down(find(start_down>good_tones(i), 2));
    prev_down = start_down(find(start_down<good_tones(i), 1, 'last'));
    try
        intv_good_tones(i) = next_down(end) - prev_down;
    catch
        intv_good_tones(i) = 0;
    end
end

intv_bad_tones = zeros(length(bad_tones),1);
for i=1:length(bad_tones)
    next_down = start_down(find(start_down>bad_tones(i),1));
    prev_down = start_down(find(start_down<bad_tones(i), 1, 'last'));
    try
        intv_bad_tones(i) = next_down - prev_down;
    catch
        intv_bad_tones(i) = 0;
    end
end

%% Same thing with delta
induce_delta = zeros(nb_tones, 1);

[status,interval,~] = InIntervals(start_deltas, [Start(tone_intv) End(tone_intv)]);
tone_success = unique(interval);
induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element

tones = Range(ToneEvent);
good_tones = tones(induce_delta==1);
bad_tones = tones(induce_delta==0);

intv_good_tones_delta = zeros(length(good_tones),1);
intv
for i=1:length(good_tones)
    next_delta = start_deltas(find(start_deltas>good_tones(i), 2));
    prev_delta = start_deltas(find(start_deltas<good_tones(i), 1, 'last'));
    try
        intv_good_tones_delta(i) = next_delta(end) - prev_delta;
    catch
        intv_good_tones_delta(i) = 0;
    end
end

intv_bad_tones_delta = zeros(length(bad_tones),1);
for i=1:length(bad_tones)
    next_delta = start_deltas(find(start_deltas>bad_tones(i),1));
    prev_delta = start_deltas(find(start_deltas<bad_tones(i), 1, 'last'));
    try
        intv_bad_tones_delta(i) = next_delta - prev_delta;
    catch
        intv_bad_tones_delta(i) = 0;
    end
end

% Remove bad values from ISI
intv_good_tones(intv_good_tones==0)=[];
intv_bad_tones(intv_bad_tones==0)=[];
intv_good_tones_delta(intv_good_tones_delta==0)=[];
intv_bad_tones_delta(intv_bad_tones_delta==0)=[];


%% Distribution plot
step = 50;
edges = 0:step:2500;

h1 = histogram(intv_good_tones/10,edges,'Normalization','probability');
x_h1 = h1.BinEdges(2:end) - step/2;
y_h1 = h1.Values;
h2 = histogram(intv_bad_tones/10,edges,'Normalization','probability');
x_h2 = h2.BinEdges(2:end) - step/2;
y_h2 = h2.Values;
h3 = histogram(intv_good_tones_delta/10,edges,'Normalization','probability');
x_h3 = h3.BinEdges(2:end) - step/2;
y_h3 = h3.Values;
h4 = histogram(intv_bad_tones_delta/10,edges,'Normalization','probability');
x_h4 = h4.BinEdges(2:end) - step/2;
y_h4 = h4.Values;

figure, hold on
subplot(1,2,1), plot(x_h1, y_h1, 'color', 'b'), hold on, plot(x_h2, y_h2, 'color', 'r'),
legend('Effective tones','Not effective tones'), title('down ISI'),hold on,
subplot(1,2,2), plot(x_h3, y_h3, 'color', 'b'), hold on, plot(x_h4, y_h4, 'color', 'r'),
legend('Effective tones','Not effective tones'), title('delta ISI')
suplabel('Mouse243-16042015','t');


