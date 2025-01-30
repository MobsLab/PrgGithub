%% QuantifLFP_AllSlowWaveTypes
% 
% 15/05/2020  LP
%
% Script to plot LFP signals on all 2-channel slow wave types, 
% for one session.
%
% SEE : ParcourMakeSlowWavesOn2Channels_LP() 


Dir = PathForExperimentsBasalSleepSpike2_HardDrive ;
clearvars -except Dir

% Choose session : 
cd(Dir.path{1})

% LFP colors : 
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1],[0.8 0.5 0.1]} ;

% ---------------------- Load Data ---------------------- : 

% 2-Channel Slow Waves : 
load('SlowWaves2Channels_LP.mat')

% LFP :

% PFCx deep :
load('ChannelsToAnalyse/PFCx_deep')
load(['LFPData/LFP',num2str(channel)])
LFPdeep = LFP;
ChannelDeep = channel ;
% PFCx sup :
load('ChannelsToAnalyse/PFCx_sup')
load(['LFPData/LFP',num2str(channel)])
LFPsup = LFP;
ChannelSup = channel ;
% OB deep :
load('ChannelsToAnalyse/Bulb_deep')
load(['LFPData/LFP',num2str(channel)])
LFPobdeep = LFP;
ChannelOBdeep = channel ;

% List with all LFP
all_LFP = {LFPdeep,LFPsup,LFPobdeep} ; 
all_LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;

% OB sup (if exist) 
try 
    load('ChannelsToAnalyse/Bulb_sup')
    load(['LFPData/LFP',num2str(channel)])
    LFPobsup = LFP;
    ChannelOBsup = channel ;
    
    % add to the list :
    all_LFP{end+1} = LFPobsup ;
    all_LFP_legend{end+1} = 'OB sup' ;
    
end    
clear LFP channel


%% ---------------------- Plot LFP on Slow Waves ---------------------- : 

figure,
yl = [-2000 2000] ;

all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    subplot(3,3,subplots_order(type)),
    plot_LFPprofile(all_slowwaves{type},all_LFP,'LFPlegend',all_LFP_legend,'LFPcolor',LFP_colors,'newfig',0,'LineWidth',{1.6,1.7,1,1}) ;
    ylim(yl) ; title(['Type ' num2str(type)]) ; 
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
end


% Title & Parameters 
subplot(3,3,5),
text(0.5,0.7,'2-Channel Slow Waves','FontSize',30,'HorizontalALignment','center'), axis off
text(0.5,0.5,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.35,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.2,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off






