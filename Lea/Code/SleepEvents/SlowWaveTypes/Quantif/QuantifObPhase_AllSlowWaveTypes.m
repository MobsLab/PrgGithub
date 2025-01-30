%% QuantifObPhase_AllSlowWaveTypes
%
% 29/05/2020  LP
%
% Script to plot phase preference for all slow waves relatively to the LFP
% signal from the olfactory bulb.
% -> For one session


%% ---------------------- Load Data ---------------------- : 

% LOAD LFP :
    % OB deep :
load('ChannelsToAnalyse/Bulb_deep')
load(['LFPData/LFP',num2str(channel)])
LFPobdeep = LFP;
ChannelOBdeep = channel ;


% LOAD EVENTS : 
% 2-Channel Slow Waves : 
load('SlowWaves2Channels_LP.mat')
% Other events :
try 
    load('Ripples.mat','tRipples')
catch 
    load('Ripples.mat','Ripples')
    tRipples = ts(Ripples) ; 
end
load('DownState.mat')
load('DeltaWaves.mat','alldeltas_PFCx')

% For plotting functions :
addpath('/Users/leaprunier/Dropbox/Kteam/PrgMatlab/MatFilesMarie')

% ---------------------- Data and Plotting Info ---------------------- : 
    
all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 



%% ---------------------- Get OB-Phase Histogram of PFCx Slow Waves ---------------------- : 



figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    sw_ts = all_slowwaves{type} ; 
    
    Fil=FilterLFP(LFPobdeep,[3 5],1024);
    [Ph,phasesandtimes,powerTsd]=CalCulPrefPhase(sw_ts,Fil,'H');
    [mu, Kappa, pval]=JustPoltModKB(Data(Ph{1}),25);

end

linkaxes(all_subplots) ; 

% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['OB Phase histogram'],'FontSize',16,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

 
