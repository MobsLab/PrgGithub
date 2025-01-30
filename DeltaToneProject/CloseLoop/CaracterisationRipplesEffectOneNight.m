%%CaracterisationRipplesEffectOneNight
% 06.12.2019 KJ
%
% Infos
%   
%
% see
%     LocalDownOneNightCharacterisationPlot CaracterisationBciTonesEffectOneNight
%
%

clear

%% init
pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243';
channels_pfc = [0 26 27];

pathexample = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244';
channels_pfc = [0 28 27];

disp(' ')
disp('****************************************************************')
cd(pathexample)
disp(pwd)


%params neurons & LFP
effect_period = [30 100]*10;
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
[tRipples, ~] = GetRipples;
tRipplesNREM = Restrict(tRipples, NREM);
nb_ripples = length(tRipplesNREM);

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
    
%induced
TonesSuccessIntv = [Range(tRipplesNREM) + effect_period(1), Range(tRipplesNREM) + effect_period(2)];

induce_delta = zeros(nb_ripples, 1);
[~,interval,~] = InIntervals(st_deltas, TonesSuccessIntv);
tone_success = unique(interval);
tone_success(tone_success==0)=[];
induce_delta(tone_success) = 1;  %do not consider the first nul element


%selected tones
ripples_tmp = Range(tRipplesNREM);

ripples_success = ripples_tmp(induce_delta==1);
ripples_failed = ripples_tmp(induce_delta==0);

rate_success = length(ripples_success)/(length(ripples_success)+length(ripples_failed));




%% Mean curves
for ch=1:length(PFC)
    [m,~,tps] = mETAverage(ripples_success, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_pfc.success{ch}(:,1) = tps; met_pfc.success{ch}(:,2) = m;
    
    [m,~,tps] = mETAverage(ripples_failed, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    met_pfc.failed{ch}(:,1) = tps; met_pfc.failed{ch}(:,2) = m;
end


%% Raster
pfc_rasters.success = RasterMatrixKJ(MUA, ts(ripples_success), t_before, t_after);
pfc_rasters.failed = RasterMatrixKJ(MUA, ts(ripples_failed), t_before, t_after);


%% saving data
cd(FolderDeltaDataKJ)
save CaracterisationRipplesEffectOneNight.mat rate_success channels_pfc
save CaracterisationRipplesEffectOneNight.mat -append pfc_rasters met_pfc













