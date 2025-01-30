%PlotGammaDownObserver

clear


%params
binsize_mua = 10;
minDuration = 50;
deltagamma.predect = 40;
deltagamma.merge = 5;
deltagamma.minduration = 75;
deltagamma.maxduration = 700;



%% load
load('SleepScoring_OBGamma.mat', 'SWSEpoch')

MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
down_PFCx = and(down_PFCx, SWSEpoch);


%% Load data

%Layer deep
load ChannelsToAnalyse/PFCx_deep
channel=0;
load('DeltaWavesChannels.mat', ['delta_ch_' num2str(channel)])
eval(['DeltaCh = delta_ch_' num2str(channel) ';'])
load(['LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP


%% Gamma

%filt
freqGamma = {[300 500],[300 550],[350 550],[350 500]};
smoothing = 0;

for i=1:length(freqGamma)
    FiltGamma{i} = FilterLFP(LFPdeep, freqGamma{i} , 1024);
    EnvGamma{i}  = tsd(Range(FiltGamma{i}), Smooth(envelope(Data(FiltGamma{i})),smoothing));
end

thresh = 1.5;

%gamma down
for i=1:length(freqGamma)
    filt_std = mean(abs(Data(Restrict(EnvGamma{i}, DeltaCh))));
    thD(i) = thresh * filt_std;
    
    cross_thresh = thresholdIntervals(EnvGamma{i}, thD(i), 'Direction', 'Below');
    cross_thresh = dropShortIntervals(cross_thresh, deltagamma.predect * 10); 
    cross_thresh = mergeCloseIntervals(cross_thresh, deltagamma.merge * 10); 
    cross_thresh = dropShortIntervals(cross_thresh, deltagamma.minduration * 10); 
    cross_thresh = dropLongIntervals(cross_thresh, deltagamma.maxduration * 10); 
    DeltaGamma{i} = and(cross_thresh, SWSEpoch);
end

for i=1:length(freqGamma)
    labels{i} = [num2str(freqGamma{i}(1)) ' - ' num2str(freqGamma{i}(2))];
end
labels{i+1} = 'MUA';


%% signals and detections
clear signals
for  i=1:length(freqGamma)
    signals{i} = [Range(EnvGamma{i},'ms')'/1000 ; Data(EnvGamma{i})'];
end
signals{i+1} = [Range(MUA,'ms')'/1000 ; Data(MUA)'];

%epochs
for  i=1:length(freqGamma)
    st_gamma{i} = Start(DeltaGamma{i},'ms')' / 1000;
    gammaDur{i} = (End(DeltaGamma{i},'ms') - Start(DeltaGamma{i},'ms'))' / 1000;
end

%down
start_down = Start(down_PFCx,'ms')' / 1000;
down_duration = (End(down_PFCx,'ms') - Start(down_PFCx,'ms'))' / 1000;


%% detection stat
for i=1:length(freqGamma)
    [recall(i), precision(i), distance_density(i), diff_slope(i), diff_duration(i), curves{i}] = CompareSleepEventDetections(down_PFCx,DeltaGamma{i}, 'margin', 50);
end

%% plot observer
sog = SignalObserverGUI(signals,'DisplayWindow',[3 3]);
for ch=1:sog.nb_channel
    sog.set_title(labels{ch}, ch);
end

%add events
for i=1:length(freqGamma)
    sog.add_rectangles(st_gamma{i}, gammaDur{i}, i);
end
sog.add_rectangles(start_down, down_duration, i+1);
sog.set_time_events(start_down);

%ylim
sog.set_ymin(1, 0); sog.set_ymax(1, 400);
sog.set_ymin(2, 0); sog.set_ymax(2, 300);
sog.set_ymin(3, 0); sog.set_ymax(3, 300);
sog.set_ymin(4, 0); sog.set_ymax(4, 300);
sog.set_ymin(5, 0); sog.set_ymax(5, 7);

sog.run_window




figure, hold on
for i=1:length(freqGamma)
    subplot(length(freqGamma), 1,i), hold on
    plot(curves{i}.x, curves{i}.y1, 'b', 'linewidth',2),
    plot(curves{i}.x, curves{i}.y2, 'r', 'linewidth',2),
end


a = [thD' recall' precision' distance_density' diff_slope' diff_duration'];


binsize_met  = 10; %for mETAverage  
nbBins_met   = 100; %for mETAverage
gamma_tmp = (Start(DeltaGamma{2}) + End(DeltaGamma{2}))/2;
delta_tmp = (Start(DeltaCh) + End(DeltaCh))/2;
figure, hold on
[m1,~,tps1] = mETAverage(gamma_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
[m2,~,tps2] = mETAverage(delta_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
plot(tps1,m1,'r'), hold on
plot(tps2,m2,'b'),


%% OLD


% %Layer sup
% load ChannelsToAnalyse/PFCx_sup
% eval(['load LFPData/LFP',num2str(channel)])
% LFPsup=LFP;
% clear LFP
% clear channel


% %sup gamma delta
% FiltGammaSup  = FilterLFP(LFPsup, freqGamma, 1024);
% 
% sup_cross_thresh = thresholdIntervals(FiltGammaSup, thresh, 'Direction', 'Below');
% DeltaGammaSup = dropShortIntervals(sup_cross_thresh, deltagamma.predect * 10); 
% DeltaGammaSup = mergeCloseIntervals(DeltaGammaSup, deltagamma.merge * 10); 
% DeltaGammaSup = dropShortIntervals(DeltaGammaSup, deltagamma.minduration * 10); 
% DeltaGammaSup = dropLongIntervals(DeltaGammaSup, deltagamma.maxduration * 10); 
% DeltaGammaSup = and(DeltaGammaSup, SWSEpoch);



% labels = {'LFPdeep', 'Gamma deep', 'Gamma sup', 'MUA'};
% signals{1} = [Range(LFPdeep,'ms')'/1000 ; Data(LFPdeep)'];
% signals{2} = [Range(FiltGammaDeep,'ms')'/1000 ; Data(FiltGammaDeep)'];
% signals{3} = [Range(FiltGammaSup,'ms')'/1000 ; Data(FiltGammaSup)'];
% signals{4} = [Range(MUA,'ms')'/1000 ; Data(MUA)'];

% %delta diff
% start_delta = Start(deltas_PFCx,'ms')' / 1000;
% delta_duration = (End(deltas_PFCx,'ms') - Start(deltas_PFCx,'ms'))' / 1000;
% 


% sog.add_rectangles(start_delta, delta_duration, 1);
% sog.add_rectangles(st_gamma_sup, gammasup_duration, 3);







