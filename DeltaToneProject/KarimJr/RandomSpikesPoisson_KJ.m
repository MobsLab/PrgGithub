%% Generate Poisson process spikes

%Load data
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
load StateEpochSB SWSEpoch Wake

% Total durations of Epochs
DurationSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurationWake=sum(End((Wake),'s')-Start((Wake),'s'));

%params
delta = 10; %simulation step size in ms
minDurBins = 0:10:1500; %minimum duration bins for downstates
thresh0 = 0.7;


%% Mean firing rates
bin_size = 10; %10ms
nb_neuron = length(NumNeurons);
if isa(S,'tsdArray')
    MUA = MakeQfromS(S(NumNeurons), bin_size*10);
else
    MUA = MakeQfromS(tsdArray(S(NumNeurons)),bin_size*10);
end
firingRates_sws = mean(full(Data(Restrict(MUA, SWSEpoch))), 1); % firing rate for a bin of 10ms
firingRates_wake = mean(full(Data(Restrict(MUA, Wake))), 1);


%% generation of random spikes: poisson process
Nsws = floor(DurationSWS * 1E3 / delta); % number of steps
Nwake = floor(DurationWake * 1E3 / delta);
% SWS and Wake
spikes_sws = zeros(Nsws, nb_neuron);
spikes_wake = zeros(Nwake, nb_neuron);
for i=1:nb_neuron
    lambda = firingRates_sws(i); % firing rate for a bin of 10ms
    spikes_sws(:,i) = poissrnd(lambda,Nsws,1);
    lambda = firingRates_wake(i);
    spikes_wake(:,i) = poissrnd(lambda,Nwake,1);
end

mua_sws = sum(spikes_sws, 2);
mua_wake = sum(spikes_wake, 2);

tmp_tsd = (1:length(mua_sws)) * 100;  % E-4s
QswsRd = tsd(tmp_tsd,mua_sws);
tmp_tsd = (1:length(mua_wake)) * 100;  % E-4s
QwakeRd = tsd(tmp_tsd,mua_wake);


%% Get real spikes
binsize=100; %binsize in E-4s, for MUA
merge_thresh = 200; %20ms
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
MUA=MakeQfromS(ST,binsize);
Qsws = Restrict(MUA, SWSEpoch);
Qwake = Restrict(MUA, Wake);


%% Number of down
binsiz = 10; % in ms
minDownDur = 0;
maxDownDur = 1000; %in ms
mergeGap = 20;
predown_size = 0;

% Simulated data
DownSwsS = FindDownKJ(QswsRd, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downSwsS_dur = (End(DownSwsS) - Start(DownSwsS)) / 10; %in ms
DownWakeS = FindDownKJ(QwakeRd, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downWakeS_dur = (End(DownWakeS) - Start(DownWakeS)) / 10; %in ms

nbDownSWS_sim = zeros(1, length(minDurBins));
nbDownWake_sim = zeros(1, length(minDurBins));
for j=1:length(minDurBins)
    bmin = minDurBins(j);
    nbDownSWS_sim(j) = sum(downSwsS_dur>bmin);
    nbDownWake_sim(j) = sum(downWakeS_dur>bmin);
end


% Real data
DownSws = FindDownKJ(Qsws, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downSws_dur = (End(DownSws) - Start(DownSws)) / 10;
DownWake = FindDownKJ(Qwake, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downWake_dur = (End(DownWake) - Start(DownWake)) / 10;

nbDownSWS_data = zeros(1, length(minDurBins));
nbDownWake_data = zeros(1, length(minDurBins));
for j=1:length(minDurBins)
    bmin = minDurBins(j);
    nbDownSWS_data(j) = sum(downSws_dur>bmin);
    nbDownWake_data(j) = sum(downWake_dur>bmin);
end


%% plot

hourSws = DurationSWS / 3600;
hourWake = DurationWake / 3600;

figure, hold on
plot(minDurBins, nbDownSWS_sim / hourSws,'b')
plot(minDurBins, nbDownWake_sim / hourWake,'y')
plot(minDurBins, nbDownSWS_data / hourSws,'r')
plot(minDurBins, nbDownWake_data / hourWake,'k')
set(gca,'xscale','log')
set(gca,'yscale','log')
set(gca,'xtick',[10 50 100 200 500 1500])
legend('SIM sws','SIM wake','SWS','Wake')



