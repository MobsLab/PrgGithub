%%ScriptTonesEffectMUAandLFP
% 18.06.2019 KJ
%
%
%   see 
%       FiguresTonesInDownPerRecord Fig1TonesInDownEffect


clear

%% params
binsize_mua = 2;
minDuration = 20;

t_start      =  -1e4; %1s
t_end        = 1e4; %1s

binsize_met = 10;
nbBins_met  = 80;

edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% load
%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS

%tones
load('behavResources.mat', 'ToneEvent')
tones_tmp = Range(ToneEvent);
nb_tones = length(tones_tmp);

%substages
load('SleepScoring_OBGamma.mat', 'REMEpoch', 'SWSEpoch','Wake')

%PFC
load('ChannelsToAnalyse/PFCx_deep.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
PFC_deep = LFP;
clear LFP

load('ChannelsToAnalyse/PFCx_sup.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
PFC_sup = LFP;
clear LFP


%% Tones
TonesNREM = Restrict(ToneEvent, SWSEpoch);
TonesREM  = Restrict(ToneEvent, REMEpoch);
TonesWake = Restrict(ToneEvent, Wake);


%% MUA response to the end of down states

% Tones
[m,~,tps] = mETAverage(Range(ToneEvent), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_tones(:,1) = tps; met_tones(:,2) = m;
[m,~,tps] = mETAverage(Range(TonesNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_nrem(:,1) = tps; met_nrem(:,2) = m;
[m,~,tps] = mETAverage(Range(TonesWake), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_wake(:,1) = tps; met_wake(:,2) = m;

% LFP deep
[m,~,tps] = mETAverage(Range(ToneEvent), Range(PFC_deep), Data(PFC_deep), binsize_met, nbBins_met);
deep_tones(:,1) = tps; deep_tones(:,2) = m; 
[m,~,tps] = mETAverage(Range(TonesNREM), Range(PFC_deep), Data(PFC_deep), binsize_met, nbBins_met);
deep_nrem(:,1) = tps; deep_nrem(:,2) = m; 
[m,~,tps] = mETAverage(Range(TonesWake), Range(PFC_deep), Data(PFC_deep), binsize_met, nbBins_met);
deep_wake(:,1) = tps; deep_wake(:,2) = m; 

% LFP sup
[m,~,tps] = mETAverage(Range(ToneEvent), Range(PFC_sup), Data(PFC_sup), binsize_met, nbBins_met);
sup_tones(:,1) = tps; sup_tones(:,2) = m; 
[m,~,tps] = mETAverage(Range(TonesNREM), Range(PFC_sup), Data(PFC_sup), binsize_met, nbBins_met);
sup_nrem(:,1) = tps; sup_nrem(:,2) = m; 
[m,~,tps] = mETAverage(Range(TonesWake), Range(PFC_sup), Data(PFC_sup), binsize_met, nbBins_met);
sup_wake(:,1) = tps; sup_wake(:,2) = m; 


%% PLOT
figure, hold on

%MUA
subplot(2,2,1), hold on
plot(met_tones(:,1), met_tones(:,2) , 'color', 'k'); hold on
plot(met_nrem(:,1), met_nrem(:,2) , 'color', 'b'); hold on
plot(met_wake(:,1), met_wake(:,2) , 'color', 'r'); hold on

xlabel('time from tones'), xlim([-400 400]), ylabel('MUA'),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on


%PFC deep
subplot(2,2,2), hold on
plot(deep_tones(:,1), deep_tones(:,2) , 'color', 'k'); hold on
plot(deep_nrem(:,1), deep_nrem(:,2) , 'color', 'b'); hold on
plot(deep_wake(:,1), deep_wake(:,2) , 'color', 'r'); hold on

xlabel('time from tones'), xlim([-400 400]), ylabel('LFP'),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on


%PFC sup
subplot(2,2,3), hold on
plot(sup_tones(:,1), sup_tones(:,2) , 'color', 'k'); hold on
plot(sup_nrem(:,1), sup_nrem(:,2) , 'color', 'b'); hold on
plot(sup_wake(:,1), sup_wake(:,2) , 'color', 'r'); hold on

xlabel('time from tones'), xlim([-400 400]), ylabel('LFP'),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on





