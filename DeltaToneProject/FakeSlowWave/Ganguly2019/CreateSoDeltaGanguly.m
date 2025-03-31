% CreateSoDeltaGanguly
% 13.11.2019 KJ
%
% Detect SO and delta waves as in the paper Kim, Gulati et Ganguly 2019 (Cell)
%


clear
cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243

%% params
freq_so = [0.1 4];
minDuration = 150*10;
maxDuration = 500*10;
binsize_mua = 10;
binsize_met = 10;
nbBins_met  = 160;


%% load
%Epoch
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

%MUA
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

%delta waves
load('DeltaWaves.mat')


%LFP
load('ChannelsToAnalyse/PFCx_deep.mat', 'channel')
ch_deep = channel; clear channel
load(['LFPData/LFP' num2str(ch_deep)], 'LFP')
LFPdeep = LFP;
clear LFP


%% filtering
EEG_deep = ResampleTSD(LFPdeep,100);
FiltDeep = FilterLFP(EEG_deep, freq_so, 1024);
LFP_nrem = Restrict(FiltDeep, NREM);


%% peaks, troughs, threshold
tExtrema = peaks_tsd(LFP_nrem);
tExtrema = Restrict(LFP_nrem, tExtrema);
time_extrema = Range(tExtrema);
y_extrema = Data(tExtrema);

time_peaks = time_extrema(y_extrema>0);
y_peaks = y_extrema(y_extrema>0);
time_troughs = time_extrema(y_extrema<0);
y_troughs = y_extrema(y_extrema<0);

%Thresholds
Th_peaks = prctile(y_peaks,85);
Th_troughs = prctile(y_troughs,40);


%% predetection
zero_crossings = Range(threshold(LFP_nrem, 0, 'Crossing', 'Rising', 'InitialPoint', 1));
Predetections = intervalSet(zero_crossings(1:end-1), zero_crossings(2:end));
Predetections = dropShortIntervals(Predetections,300*10);
Predetections = dropLongIntervals(Predetections,1e4);


%% Detections of all waves with negative thresholding

%negative threshold
idx_troughs = y_troughs<Th_troughs;
time_troughs = time_troughs(idx_troughs);
y_troughs = y_troughs(idx_troughs);

%intervals with dections inside
st_predetect = Start(Predetections);
end_predetect = End(Predetections);
[~,intervals,index] = InIntervals(time_troughs, [st_predetect end_predetect]);
intervals = unique(intervals); intervals(intervals==0)=[];


twaves_troughs = time_troughs(index==1);
AllWaves = subset(Predetections,intervals);


%% look at peaks 
idwave_peaks = nan(1,length(twaves_troughs));
for i=1:length(twaves_troughs)    
    a = twaves_troughs(i) - time_peaks;
    try
        idwave_peaks(i) = find(a>minDuration & a<maxDuration & y_peaks>Th_peaks,1,'last');
    end
end

%SO
SlowOcsci = subset(AllWaves,find(~isnan(idwave_peaks)));

%delta waves
deltaDetect = subset(AllWaves,find(isnan(idwave_peaks)));




%% mean curves

%Diff
[m,~,tps] = mETAverage(Start(deltaDetect), Range(LFPdeep), Data(LFPdeep), binsize_met, nbBins_met);
lfp_delta(:,1) = tps; lfp_delta(:,2) = m;

[m,~,tps] = mETAverage(Start(SlowOcsci), Range(LFPdeep), Data(LFPdeep), binsize_met, nbBins_met);
lfp_so(:,1) = tps; lfp_so(:,2) = m;

[m,~,tps] = mETAverage(Start(deltas_PFCx), Range(LFPdeep), Data(LFPdeep), binsize_met, nbBins_met);
lfp_diff(:,1) = tps; lfp_diff(:,2) = m;


%MUA
[m,~,tps] = mETAverage(Start(deltaDetect), Range(MUA), Data(MUA), binsize_met, nbBins_met);
mua_delta(:,1) = tps; mua_delta(:,2) = m;

[m,~,tps] = mETAverage(Start(SlowOcsci), Range(MUA), Data(MUA), binsize_met, nbBins_met);
mua_so(:,1) = tps; mua_so(:,2) = m;

[m,~,tps] = mETAverage(Start(deltas_PFCx), Range(MUA), Data(MUA), binsize_met, nbBins_met);
mua_diff(:,1) = tps; mua_diff(:,2) = m;


%% Plot
figure, hold on

%LFP
subplot(1,2,1), hold on
h(1) = plot(lfp_so(:,1), lfp_so(:,2), 'color', [0.5 0.5 0.5], 'linewidth',2);
h(2) = plot(lfp_delta(:,1), lfp_delta(:,2), 'color', 'b', 'linewidth',2);
h(3) = plot(lfp_diff(:,1), lfp_diff(:,2), 'color', 'k', 'linewidth',2);

line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])

legend(h, 'SO','delta', 'diff')

%MUA
subplot(1,2,2), hold on
h(1) = plot(mua_so(:,1), mua_so(:,2), 'color', [0.5 0.5 0.5], 'linewidth',2);
h(2) = plot(mua_delta(:,1), mua_delta(:,2), 'color', 'b', 'linewidth',2);
h(3) = plot(mua_diff(:,1), mua_diff(:,2), 'color', 'k', 'linewidth',2);

line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])














