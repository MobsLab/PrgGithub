%%ComputeExampleOneNightLocalDown
% 25.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     PlotExampleOneNightLocalDown FigLocalDownOneNightExample PlotExampleLocalDownHomeostasis
%
%


%% init
% pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
% id_tetrodes = []; 
% hemisphere = [];
% 
% disp(' ')
% disp('****************************************************************')
% cd(pathexample)
% disp(pwd)


%params neurons & LFP
factorLFP = 0.195;
binsize_mua = 5*10; %5ms
minDurationDown = 75;
t_before = -0.4e4;
t_after = 0.7e4;
binsize_met = 5;
nbBins_met  = 300;
binsize_cc = 1;
nb_binscc = 500;

%params homeostasis
windowsize_density = 60e4; %60s
rescale = 0;
color_nrem = 'b';
color_rem  = [0 0.5 0];
color_wake = 'k';
color_curve = [0.5 0.5 0.5];
color_S = 'b';
color_peaks = 'r';
color_fit = 'k';



%% Load

%night duration and tsd zt
load('behavResources.mat', 'NewtsdZT')
load('IdFigureData2.mat', 'night_duration')

%NREM
[NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;
SleepStages = {REM,NREM,Wake};
for s=1:length(SleepStages)
    new_st  = Data(Restrict(NewtsdZT, ts(Start(SleepStages{s}))));
    new_end = Data(Restrict(NewtsdZT, ts(End(SleepStages{s}))));
    
    SleepStages{s} = intervalSet(new_st,new_end);
end


%PFC
load('ChannelsToAnalyse/PFCx_locations.mat')
channels_pfc = channels;

%Spikes
load('SpikeData.mat', 'S');
if ~isa(S,'tsdArray')
    S = tsdArray(S);
end
%Spike tetrode
load('SpikesToAnalyse/PFCx_tetrodes.mat')
nb_tetrodes = length(numbers);
NeuronTetrodes = numbers;
tetrodeChannelsCell = channels;
tetrodeChannels = [];
for tt=1:nb_tetrodes
    tetrodeChannels(tt) = channels_pfc(ismember(channels_pfc,tetrodeChannelsCell{tt}));
end
if ~isempty(id_tetrodes)
    NeuronTetrodes = NeuronTetrodes(id_tetrodes);
    tetrodeChannelsCell = tetrodeChannelsCell(id_tetrodes);
    tetrodeChannels = tetrodeChannels(id_tetrodes);
end
nb_tetrodes = length(NeuronTetrodes);


%all PFC neurons
if ~isempty(hemisphere)
    load(['SpikesToAnalyse/PFCx_' hemisphere '_Neurons.mat'])
else
    load('SpikesToAnalyse/PFCx_Neurons.mat')
end
all_neurons = number;

MUA = MakeQfromS(S(all_neurons), binsize_mua);
MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
%down
GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
GlobalDown = and(GlobalDown,NREM);
st_global = Start(GlobalDown);
center_global = (Start(GlobalDown) + End(GlobalDown)) /2;
global_duration = End(GlobalDown) - Start(GlobalDown);


%% find local down
for tt=1:nb_tetrodes
    local_neurons{tt} = NeuronTetrodes{tt};
    %MUA & down
    MUA_local{tt} = MakeQfromS(S(local_neurons{tt}), binsize_mua);
    MUA_local{tt} = tsd(Range(MUA_local{tt}), sum(full(Data(MUA_local{tt})),2));
    AllDown_local{tt} = FindDownKJ(MUA_local{tt}, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 0, 'predown_size', 40, 'method', 'mono');
    AllDown_local{tt} = and(AllDown_local{tt},NREM);
    
    %distinguish local and global
    [~, ~, ~, idAlocal, ~] = GetIntersectionsEpochs(AllDown_local{tt}, GlobalDown);
    LocalDown{tt} = subset(AllDown_local{tt}, setdiff(1:length(Start(AllDown_local{tt})), idAlocal)');
    st_localdown{tt} = Start(LocalDown{tt});
    center_localdown{tt} = (Start(LocalDown{tt}) + End(LocalDown{tt})) /2;
    local_duration{tt} = End(LocalDown{tt}) - Start(LocalDown{tt});
end
    
    
%% Down duration distributions
%params
thresh0 = 0.7;
maxDownDur = 1000;
mergeGap = 0; % merge
predown_size = 0;
duration_bins = 0:10:1500; %duration bins for downstates

%global
DownNrem = FindDownKJ(Restrict(MUA, NREM), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downSws_dur = (End(DownNrem) - Start(DownNrem)) / 10; %ms
DownWake = FindDownKJ(Restrict(MUA, Wake), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

nbDownGlob.nrem = zeros(1, length(duration_bins));
nbDownGlob.wake = zeros(1, length(duration_bins));
for j=1:length(duration_bins)
    binvalue = duration_bins(j);
    nbDownGlob.nrem(j) = sum(downSws_dur==binvalue);
    nbDownGlob.wake(j) = sum(downWake_dur==binvalue);
end


%local
for tt=1:nb_tetrodes
    DownNrem = FindDownKJ(Restrict(MUA_local{tt}, NREM), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downSws_dur = (End(DownNrem) - Start(DownNrem)) / 10; %ms
    DownWake = FindDownKJ(Restrict(MUA_local{tt}, Wake), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

    nbDownLoc.nrem{tt} = zeros(1, length(duration_bins));
    nbDownLoc.wake{tt} = zeros(1, length(duration_bins));
    for j=1:length(duration_bins)
        binvalue = duration_bins(j);
        nbDownLoc.nrem{tt}(j) = sum(downSws_dur==binvalue);
        nbDownLoc.wake{tt}(j) = sum(downWake_dur==binvalue);
    end
end


%% met/cross-corr on down
%global
for n=1:length(all_neurons)
    [Ccglobal.start.y{n}, Ccglobal.start.x{n}] = CrossCorr(st_global, Range(S{n}), binsize_cc, nb_binscc);
    [Ccglobal.center.y{n}, Ccglobal.center.x{n}] = CrossCorr(center_global, Range(S{n}), binsize_cc, nb_binscc);    
end

MatnGlobal.start = [];
MatnGlobal.center = [];
for n=1:length(all_neurons)
    MatnGlobal.start = [MatnGlobal.start ; Ccglobal.start.y{n}'];
    MatnGlobal.center = [MatnGlobal.center ; Ccglobal.center.y{n}'];
end
x_matG = Ccglobal.start.x{1};


%local
for tt=1:nb_tetrodes
    for n=1:length(all_neurons)
        [Cclocal.start.y{n,tt}, Cclocal.start.x{n,tt}] = CrossCorr(st_localdown{tt}, Range(S{n}), binsize_cc, nb_binscc);
        [Cclocal.center.y{n,tt}, Cclocal.center.x{n,tt}] = CrossCorr(center_localdown{tt}, Range(S{n}), binsize_cc, nb_binscc);
    end
    
    MatnLocal.start{tt} = [];
    MatnLocal.center{tt} = [];
    for n=1:length(all_neurons)
        MatnLocal.start{tt} = [MatnLocal.start{tt} ; Cclocal.start.y{n,tt}'];
        MatnLocal.center{tt} = [MatnLocal.center{tt} ; Cclocal.center.y{n,tt}'];
    end
end

%FR of each neurons
for n=1:length(all_neurons)
    firingrate.sws(n)  = length(Range(Restrict(S{n},NREM))) / tot_length(NREM);
    firingrate.wake(n) = length(Range(Restrict(S{n},Wake))) / tot_length(Wake);
end


%% raster
tRasterGlobal = RasterMatrixKJ(MUA, ts(st_global), t_before, t_after);
for tt=1:nb_tetrodes
    tRasterLocal{tt} = RasterMatrixKJ(MUA_local{tt}, ts(st_localdown{tt}), t_before, t_after);
end


%% Homeostasis

%Global
[~, ~, Global.Hstat] = DensityOccupation_KJ(GlobalDown, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
%Local
for tt=1:nb_tetrodes
    [~, ~, Local.Hstat{tt}] = DensityOccupation_KJ(LocalDown{tt}, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM,'rescale',rescale);
end

%x
x_intervals = Global.Hstat.x_intervals;

%Process S global
x_peaks = Global.Hstat.x_peaks;
y_peaks = Global.Hstat.y_peaks;
Sglobal.x = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
Sglobal.y = interp1(x_peaks, y_peaks, Sglobal.x, 'pchip'); 

%Process S local
for tt=1:nb_tetrodes
    Hstat = Local.Hstat{tt};
    x_peaks = Hstat.x_peaks;
    y_peaks = Hstat.y_peaks;
    Slocal.x{tt} = x_intervals(x_intervals>=x_peaks(1) & x_intervals<=x_peaks(end));
    Slocal.y{tt} = interp1(x_peaks, y_peaks, Slocal.x{tt}, 'pchip');
end


%% save data

try
    save ComputeExampleOneNightLocalDown.mat -append nb_tetrodes firingrate SleepStages
catch
    save ComputeExampleOneNightLocalDown.mat nb_tetrodes firingrate SleepStages
end

save ComputeExampleOneNightLocalDown.mat -append nbDownLoc nbDownGlob duration_bins
save ComputeExampleOneNightLocalDown.mat -append x_matG MatnGlobal MatnLocal
save ComputeExampleOneNightLocalDown.mat -append tRasterGlobal tRasterLocal global_duration local_duration
save ComputeExampleOneNightLocalDown.mat -append LocalDown GlobalDown id_tetrodes tetrodeChannels NeuronTetrodes
save ComputeExampleOneNightLocalDown.mat -append Slocal Sglobal Local Global







