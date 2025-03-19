%SoundEffectClassifier2

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
load('DeltaSleepEvent.mat', 'TONEtime2_SWS')


% params
frequency_sampling = 1250;
mua_binsize=10;
thresh0 = 0.9;
thresh1 = 1.1;
minDownDur = 75;
maxDownDur = 1000;
mergeGap = 10; % merge
predown_size = 50;
window_eff = 200;
%features
nb_down_before = 4;


%% get downstate
T=PoolNeurons(S,NumNeurons);
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q = MakeQfromS(ST,mua_binsize*10); %binsize*10 to be in E-4s
%Down
Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');

%data for plot
down_start = Start(Down,'ms');
down_duration = (End(Down,'ms') - Start(Down,'ms'));

%% Sounds
nb_tones = length(TONEtime2_SWS);
ToneEvent = ts(TONEtime2_SWS);
tone_interval = [Range(ToneEvent, 'ms') Range(ToneEvent, 'ms')+window_eff];
tone_start = Range(ToneEvent,'ms');
[status,interval,index] = InIntervals(Start(Down,'ms'), tone_interval);
good_sounds = unique(interval);
good_sounds = good_sounds(2:end);
bad_sounds = setdiff(1:length(tone_interval), good_sounds);


%% Data set (features selection)
data_label = zeros(nb_tones, 1);
data_label(good_sounds) = 1;
nb_features = 2 * nb_down_before + 3;
data_tone = zeros(nb_tones, nb_features);

for i=1:length(tone_start)
    idx_down_before = find(down_start < tone_start(i), nb_down_before, 'last');
    befdown_delay = tone_start(i) - down_start(idx_down_before);
    befdown_durs = down_duration(idx_down_before);
    data_tone(i,:) = [tone_start(i);befdown_delay; befdown_durs; ]';
end


%Load
X = data_tone;
y = data_label;


%% Features importance with Treebagger
big_rf = TreeBagger(100,X,y,'Method','classification', 'OOBVarImp','On', 'MinLeafSize',5);
figure
plot(oobError(big_rf))
xlabel 'Number of Grown Trees'
ylabel 'Out-of-Bag Mean Squared Error'
figure
bar(big_rf.OOBPermutedVarDeltaError)
xlabel 'Feature Index'
ylabel 'Out-of-Bag Feature Importance'

%% Test
%Datasets and CV
cv = crossvalind('HoldOut', size(X,1), 0.7);
Xtrain = X(~cv,:);
Ytrain = y(~cv,:);
Xtest = X(cv,:);
Ytest = y(cv,:);

ntrees = 30;
rf_clf = TreeBagger(ntrees,Xtrain,Ytrain,'Method','classification', 'MinLeafSize',5);
Yfit = predict(rf_clf, Xtest);
Yfit = str2num(cell2mat(Yfit));
CP = classperf(Ytest, Yfit);

figure, hold on
scatter(Yfit,Ytest)

