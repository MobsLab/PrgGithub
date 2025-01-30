-+%%FigLocalDownOneNightExample
% 18.09.2019 KJ
%
% Infos
%   Examples figures :
%       - tones in Up states > Down
%
% see
%     PlotExampleRealFakeSlow FigLocalDownOneNightExamplePlot
%
%


clear

%params
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
id_tetrodes = [1 2 3];
channel_middle = 25; channel_sup = 27; channel_deep = 26;
pathexample = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse509/20170130/ProjectEmbReact_M509_20170130_BaselineSleep';
id_tetrodes = [1 2 7];
channel_middle = 31; channel_sup = 36; channel_deep = 22;

pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse244';
id_tetrodes = [1 2 3];
channel_middle = 25; channel_sup = 27; channel_deep = 26;


%init
disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)

% %params
binsize_mua = 5*10; %5ms
minDurationDown = 75;
t_before = -0.4e4;
t_after = 0.7e4;
binsize_met = 5;
nbBins_met  = 300;
binsize_cc = 1;
nb_binscc = 500;


%% Load
%NREM
[NREM, ~, Wake, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

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
NeuronTetrodes = NeuronTetrodes(id_tetrodes);
tetrodeChannelsCell = tetrodeChannelsCell(id_tetrodes);
tetrodeChannels = tetrodeChannels(id_tetrodes);
nb_tetrodes = length(NeuronTetrodes);


%PFC LFP
for tt=1:nb_tetrodes
    load(['LFPData/LFP' num2str(tetrodeChannels(tt)) '.mat'])
    PFC{tt} = LFP;
end
load(['LFPData/LFP' num2str(channel_deep) '.mat'])
PFCdeep = LFP;
load(['LFPData/LFP' num2str(channel_sup) '.mat'])
PFCsup = LFP;
load(['LFPData/LFP' num2str(channel_middle) '.mat'])
PFCmid = LFP;
clear channel LFP


%all PFC neurons
load('SpikesToAnalyse/PFCx_Neurons.mat')
all_neurons = number;
MUA = MakeQfromS(S(all_neurons), binsize_mua);
MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));
%down
GlobalDown = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
GlobalDown = and(GlobalDown,NREM);
st_global = Start(GlobalDown);
center_global = (Start(GlobalDown) + End(GlobalDown)) /2;
global_duration = End(GlobalDown) - Start(GlobalDown);

%infos
fr.nrem.all = mean(Data(Restrict(MUA,NREM)))*(1e4/binsize_mua);
fr.wake.all = mean(Data(Restrict(MUA,Wake)))*(1e4/binsize_mua);
Qfr = MakeQfromS(S(all_neurons), 60e4);
Fr.all.t = Range(Qfr);
Fr.all.y = sum(full(Data(Qfr)),2)/60;

%raster global
tRasterGlobal = RasterMatrixKJ(MUA, ts(st_global), t_before, t_after);

%%met for each neurons
for n=1:length(all_neurons)
%     [Ccglobal.y{n}, Ccglobal.x{n}] = CrossCorr(st_global, Range(S{n}), binsize_cc, nb_binscc);
    [Ccglobal.start.y{n}, Ccglobal.start.x{n}] = JitterCrossCorr(ts(st_global), S{n}, 20,3, binsize_cc, nb_binscc); %33s of jitter
    [Ccglobal.center.y{n}, Ccglobal.center.x{n}] = JitterCrossCorr(ts(center_global), S{n}, 20,2, binsize_cc, nb_binscc);
end


%% for each tetrodes
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

    %FR
    fr.nrem.local{tt} = mean(Data(Restrict(MUA_local{tt},NREM)))*(1e4/binsize_mua);
    fr.wake.local{tt} = mean(Data(Restrict(MUA_local{tt},Wake)))*(1e4/binsize_mua);
    Qfr = MakeQfromS(S(local_neurons{tt}), 60e4);
    Fr.local.t{tt} = Range(Qfr);
    Fr.local.y{tt} = sum(full(Data(Qfr)),2)/60;
    
    
    %% down distrib
    thresh0 = 0.7;
    maxDownDur = 1000;
    mergeGap = 0; % merge
    predown_size = 0;
    duration_bins = 0:10:1500; %duration bins for downstates

    DownNrem = FindDownKJ(Restrict(MUA_local{tt}, NREM), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downSws_dur = (End(DownNrem) - Start(DownNrem)) / 10; %ms
    DownWake = FindDownKJ(Restrict(MUA_local{tt}, Wake), 'low_thresh', thresh0, 'minDuration', 0,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size);
    downWake_dur = (End(DownWake) - Start(DownWake)) / 10; %ms

    nbDown.nrem{tt} = zeros(1, length(duration_bins));
    nbDown.wake{tt} = zeros(1, length(duration_bins));
    for j=1:length(duration_bins)
        binvalue = duration_bins(j);
        nbDown.nrem{tt}(j) = sum(downSws_dur==binvalue);
        nbDown.wake{tt}(j) = sum(downWake_dur==binvalue);
    end
    
    
    %%met for each neurons
    for n=1:length(all_neurons)
%         [Cclocal.y{n,tt}, Cclocal.x{n,tt}] = CrossCorr(center_localdown{tt}+, Range(S{n}), binsize_cc, nb_binscc);
        [Cclocal.start.y{n,tt}, Cclocal.start.x{n,tt}] = JitterCrossCorr(ts(st_localdown{tt}), S{n}, 20,3, binsize_cc, nb_binscc);
        [Cclocal.center.y{n,tt}, Cclocal.center.x{n,tt}] = JitterCrossCorr(ts(center_localdown{tt}), S{n}, 20,3, binsize_cc, nb_binscc);
    end
    
    %raster
    tRasterLocal{tt} = RasterMatrixKJ(MUA_local{tt}, ts(st_localdown{tt}), t_before, t_after);
    
end


%% Meancurves LFP

%PFC mean curves
for i=1:nb_tetrodes
    [m,~,tps] = mETAverage(st_global, Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
    met_global{i}(:,1) = tps; met_global{i}(:,2) = m;
    
    for j=1:nb_tetrodes
        [m,~,tps] = mETAverage(st_localdown{j}, Range(PFC{i}), Data(PFC{i}), binsize_met, nbBins_met);
        met_local{i,j}(:,1) = tps; met_local{i,j}(:,2) = m;
    end
end
    

%PFC deep
[m,~,tps] = mETAverage(st_global, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
metdeep_global(:,1) = tps; metdeep_global(:,2) = m;
for tt=1:nb_tetrodes
    [m,~,tps] = mETAverage(st_localdown{tt}, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    metdeep_local{tt}(:,1) = tps; metdeep_local{tt}(:,2) = m;
end

%PFC sup
[m,~,tps] = mETAverage(st_global, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
metsup_global(:,1) = tps; metsup_global(:,2) = m;
for tt=1:nb_tetrodes
    [m,~,tps] = mETAverage(st_localdown{tt}, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    metsup_local{tt}(:,1) = tps; metsup_local{tt}(:,2) = m;
end

%PFC middle
[m,~,tps] = mETAverage(st_global, Range(PFCmid), Data(PFCmid), binsize_met, nbBins_met);
metmid_global(:,1) = tps; metmid_global(:,2) = m;
for tt=1:nb_tetrodes
    [m,~,tps] = mETAverage(st_localdown{tt}, Range(PFCmid), Data(PFCmid), binsize_met, nbBins_met);
    metmid_local{tt}(:,1) = tps; metmid_local{tt}(:,2) = m;
end


%% MAT neurons
MatnGlobal.start = [];
MatnGlobal.center = [];
for n=1:length(all_neurons)
    MatnGlobal.start = [MatnGlobal.start ; Ccglobal.start.y{n}'];
    MatnGlobal.center = [MatnGlobal.center ; Ccglobal.center.y{n}'];
end
x_matG = Ccglobal.start.x{1};

for tt=1:nb_tetrodes
    MatnLocal.start{tt} = [];
    MatnLocal.center{tt} = [];
    for n=1:length(all_neurons)
        MatnLocal.start{tt} = [MatnLocal.start{tt} ; Cclocal.start.y{n,tt}'];
        MatnLocal.center{tt} = [MatnLocal.center{tt} ; Cclocal.center.y{n,tt}'];
    end
end


%% save data

try
    save FigLocalDownOneNightExample.mat -append nb_tetrodes
catch
    save FigLocalDownOneNightExample.mat nb_tetrodes
end

save FigLocalDownOneNightExample.mat -append x_matG MatnGlobal MatnLocal met_global met_local metsup_global metsup_local metmid_global metmid_local metdeep_local metdeep_global
save FigLocalDownOneNightExample.mat -append tRasterGlobal tRasterLocal global_duration local_duration
save FigLocalDownOneNightExample.mat -append LocalDown GlobalDown id_tetrodes channel_middle channel_sup channel_deep tetrodeChannels(tt)



