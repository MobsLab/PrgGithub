%DeltaAndGammaDown_KJ
%25.04.2018
%
% Script to analyse delta waves and Gamma down together
%


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
%LFP
load(['LFPData/LFP',num2str(channel)])
LFPdeep=LFP;
clear LFP


%% Gamma

%filt
freqGamma = [300 550];
FiltGamma = FilterLFP(LFPdeep, freqGamma, 1024);

filt_std = mean(abs(Data(Restrict(FiltGamma, DeltaCh))));

thresh = 2*filt_std;








