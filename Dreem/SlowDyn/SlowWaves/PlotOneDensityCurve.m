% PlotOneDensityCurve
% 03.10.2018 KJ
%
%       
%
% SEE 
%   PlotOneMotherCurve
%

clear
load(fullfile(FolderSlowDyn,'PathSlowDyn2.mat'))
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'),'quantif_res')

%rec
rec = 96579;
rec = 161924;
rec = 203752;
rec = 199984;


p = find(cell2mat(Dir.filereference)==rec);

%params
channel_frontal = [1 2 5 6];
binsize_met = 10;
nbBins_met  = 300;

%load signals and data
[signals, ~, stimulations, StageEpochs, labels_eeg] = GetRecordDreem(Dir.filename{p});
signals = signals(channel_frontal);
labels_eeg = labels_eeg(channel_frontal);

channel_sw = quantif_res.channel_sw{p};
        
%load slow waves
sw_file = fullfile(FolderSlowDynPreprocess, 'SlowWaves2', ['SlowWaves_' num2str(Dir.filereference{p}) '.mat']);
if exist(sw_file,'file')==2
    load(sw_file);
else
   [SlowWaveEpochs, ~] = MakeSlowWavesDreemRecord(p,Dir,'savefolder',fullfile(FolderSlowDynPreprocess, 'SlowWaves2'));
end

%% slow-waves
center_slowwaves = (Start(SlowWaveEpochs{channel_sw}) + End(SlowWaveEpochs{channel_sw})) / 2;


%% params
%params density
windowsize = 60e4; %60s
smoothing = 1;
%params isi
step=100;
edges=0:step:10000;

%% night duration and intervals
for st=1:length(StageEpochs)
    try
        endst(st) = max(End(StageEpochs{st})); 
    catch
        endst(st) = nan;
    end
end
night_duration = max(endst);

%intervals
intervals_start = 0:windowsize:night_duration;    
x_intervals = (intervals_start + windowsize/2)/(3600E4);


%% slow waves density
slowwaves_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    slowwaves_density(t) = length(Restrict(ts(center_slowwaves),intv)); %per min
end
x_density = x_intervals;
y_density = Smooth(slowwaves_density,smoothing);

%slope
[x_dens, y_dens] = AdaptDensityCurves(x_intervals, slowwaves_density, smoothing);
idx_density = y_dens > max(y_dens)/8;
p_density = polyfit(x_dens(idx_density), y_dens(idx_density)', 1);

yfit_slope = p_density(1)*x_density + p_density(2);


%% Plot
figure, hold on
plot(x_density, y_density,  'color','b', 'linewidth', 2), hold on,
plot(x_density, yfit_slope,  'color','k', 'linewidth', 1), hold on,
xlabel('time (h)'), ylabel('slow waves per min'),
set(gca, 'fontsize', 30);










