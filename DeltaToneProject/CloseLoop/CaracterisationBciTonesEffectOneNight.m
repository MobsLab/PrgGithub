%%CaracterisationBciTonesEffectOneNight
% 26.09.2019 KJ
%
% Infos
%   
%
% see
%     LocalDownOneNightCharacterisationPlot
%
%

clear

%% init
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150425/Breath-Mouse-243-25042015';
channels_pfc = [0 26 27];
delay = 0.49*1e4;

pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150426/Breath-Mouse-244-26042015';
channels_pfc = [0 28 27];
delay = 0.49*1e4;

disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%params neurons & LFP
effect_period = [50 200]*10;
binsize_mua = 5; %10ms
t_before = -1e4;
t_after = 1e4;
binsize_met = 5;
nbBins_met  = 300;




%% Load

%NREM
[NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
NREM = NREM - TotalNoiseEpoch;

%tones
load('behavResources.mat', 'ToneEvent')
ToneNREM = Restrict(ToneEvent, NREM);
nb_tones = length(ToneNREM);

%down PFCx
load('DownState.mat', 'down_PFCx')
st_down = Start(down_PFCx);

%Delta waves
delta_PFCx = GetDeltaWaves;
st_deltas = Start(delta_PFCx);

%LFP
for ch=1:length(channels_pfc)
    load(['LFPData/LFP' num2str(channels_pfc(ch)) '.mat'])
    PFC{ch} = LFP;
end
clear channel LFP

%MUA
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);



%% Select tones that are really triggered by delta and distinguish Success and failed
    
%triggered
pre_period = 1000; %100ms
TonesTriggeredIntv = [Range(ToneNREM) - (delay+pre_period),  Range(ToneNREM) - (delay-pre_period)];

delta_triggered = zeros(nb_tones, 1);
[~,interval,~] = InIntervals(st_deltas, TonesTriggeredIntv);
tone_trig = unique(interval);
tone_trig(tone_trig==0)=[];
delta_triggered(tone_trig) = 1;  %do not consider the first nul element


%induced
TonesSuccessIntv = [Range(ToneNREM) + effect_period(1), Range(ToneNREM) + effect_period(2)];

induce_delta = zeros(nb_tones, 1);
[~,interval,~] = InIntervals(st_deltas, TonesSuccessIntv);
tone_success = unique(interval);
tone_success(tone_success==0)=[];
induce_delta(tone_success) = 1;  %do not consider the first nul element


%selected tones
tones_tmp = Range(ToneNREM);

tones_success = tones_tmp(induce_delta==1 & delta_triggered==1);
tones_failed = tones_tmp(induce_delta==0 & delta_triggered==1);

rate_success = length(tones_success)/(length(tones_success)+length(tones_failed));




%% Mean curves
for ch=1:length(PFC)
    [m,~,tps] = mETAverage(tones_success, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_pfc.success{ch}(:,1) = tps; met_pfc.success{ch}(:,2) = m;
    
    [m,~,tps] = mETAverage(tones_failed, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_pfc.failed{ch}(:,1) = tps; met_pfc.failed{ch}(:,2) = m;
end


%% Raster
pfc_rasters.success = RasterMatrixKJ(MUA, ts(tones_success), t_before, t_after);
pfc_rasters.failed = RasterMatrixKJ(MUA, ts(tones_failed), t_before, t_after);


%% saving data
cd(FolderDeltaDataKJ)
save CaracterisationBciTonesEffectOneNight.mat rate_success channels_pfc
save CaracterisationBciTonesEffectOneNight.mat -append pfc_rasters met_pfc













