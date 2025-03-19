% ParcoursPlotDownDistribution
% 28.09.2016 KJ
%
% Compute and plot Down states distribution (number in function of duration, log scale)
%   - Dir is the path list where you want to compute and plot the distributions 
%   - graphs are similar to Figure 7.2 a) in the phD of Gaetan Lavilleon
%   - Raster plot sync on down state start
%

Dir=PathForExperimentsDeltaIDfigures;


%% params
binsize=10;
thresh0 = 0.7;
minDownDur = 0;
maxDownDur = 1000;
mergeGap = 10; % merge
predown_size = 50;
minDurBins = 0:10:1500; %minimum duration bins for downstates


%% Load data
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
load StateEpochSB SWSEpoch Wake

% Total durations of Epochs
DurationSWS=sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
DurationWake=sum(End((Wake),'s')-Start((Wake),'s'));


%% Get real spikes
T=PoolNeurons(S,NumNeurons);
clear ST
ST{1}=T;
try
    ST=tsdArray(ST);
end
Q=MakeQfromS(ST,binsize*10);
Qsws = Restrict(Q, SWSEpoch);
Qwake = Restrict(Q, Wake);

% Mean firing rates
nb_neuron = length(NumNeurons);
firingRates_sws = mean(full(Data(Restrict(Q, SWSEpoch))), 1); % firing rate for a bin of 10ms

%% Number of down
DownSws = FindDown2_KJ(Qsws, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downSws_dur = (End(DownSws) - Start(DownSws)) / 10;
DownWake = FindDown2_KJ(Qwake, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downWake_dur = (End(DownWake) - Start(DownWake)) / 10;

nbDownSWS = zeros(1, length(minDurBins));
nbDownWake = zeros(1, length(minDurBins));
for j=1:length(minDurBins)
    bmin = minDurBins(j);
    nbDownSWS(j) = sum(downSws_dur>bmin);
    nbDownWake(j) = sum(downWake_dur>bmin);
end



%% Raster
[down_sorted, idx_down] = sort(downSws_dur,'descend');
t_before = -2000; %in 1E-4s
t_after = 6000; %in 1E-4s
%figure, [fh, rasterAx, histAx, matVal] = ImagePETHOrdered(Q, ts(Start(Down)), idx_down, t_before, t_after); close

raster_tsd = RasterMatrixKJ(Q, ts(Start(DownSws)), t_before, t_after, idx_down);
raster_matrix = Data(raster_tsd)';
raster_x = Range(raster_tsd);


%% plot

%hourSws = DurationSWS / 3600;
%hourWake = DurationWake / 3600;

figure('units','normalized','outerposition',[0 0 1 1]);
RasterAxes = axes('position', [0.05 0.05 0.4 0.75]);
DistribAxes = axes('position', [0.55 0.05 0.4 0.7]);

% Create textbox
textbox_str = {[num2str(nb_neuron) ' neurons'], ['FR = ' num2str(firingRates_sws*100) ' Hz'], ['FR = ' num2str(firingRates_sws*100/nb_neuron) ' Hz']};
annotation(gcf,'textbox',...
    [0.08 0.8 0.25 0.1],...
    'String',textbox_str,...
    'LineWidth',3,...
    'HorizontalAlignment','center',...
    'FontWeight','bold',...
    'FitBoxToText','off');

%raster
axes(RasterAxes);
imagesc(raster_x/1E4, 1:length(downSws_dur), raster_matrix), hold on
axis xy, colorbar, hold on

%distribution of down
axes(DistribAxes);
plot(minDurBins, nbDownSWS ,'r'), hold on
plot(minDurBins, nbDownWake ,'k'), hold on
set(gca,'xscale','log','yscale','log'), hold on
%ylim = get(gca,'ylim'); ylim(1) = 1; 
set(gca,'ylim',[1 1E6],'xlim',[10 1500]), hold on
set(gca,'xtick',[10 50 100 200 500 1500]), hold on
legend('SWS','Wake')











