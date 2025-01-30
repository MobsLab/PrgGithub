%% QuantifInfo_AllSlowWaveTypes2
% 
% 25/05/2020  LP
%
% Script to plot event info nº2 for all 2-channel slow wave types, 
% for one session.
%
% -> LFP profiles
% -> Slow Waves x Down States : Co-occurrence + LFP
% -> Slow Waves x Diff Delta Waves States : Co-occurrence + LFP
%
% SEE : 
% ParcourMakeSlowWavesOn2Channels_LP() 
% PlotLFP_AllSlowWaveTypes


Dir = PathForExperimentsSlowWavesLP_HardDrive ;
% clearvars -except Dir

% Choose session : 
%cd(Dir.path{16})



%% ---------------------- Load Data ---------------------- : 

% LOAD LFP :

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



% LOAD SPIKE DATA :

load('SpikeData.mat')
num=GetSpikesFromStructure('PFCx');
S=S(num); % S tsdArray des spikes des neurones du PFC uniquement 



% LOAD SUBSTAGES : 
load('SleepSubstages.mat') ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;
    


% ---------------------- Data and Plotting Info ---------------------- : 
    
all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 

% LFP colors : 
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1],[0.8 0.5 0.1]} ;    



%% ---------------------- Plot LFP on Slow Waves ---------------------- : 

figure,
yl = [-2000 2000] ;

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    subplot(3,3,subplots_order(type)),
    plot_LFPprofile(all_slowwaves{type},all_LFP,'LFPlegend',all_LFP_legend,'LFPcolor',LFP_colors,'newfig',0,'LineWidth',{1.6,1.7,1,1}) ;
    xlabel('Time from slow wave peak (ms)') ; 
    ylim(yl) ; title(['Type ' num2str(type) sprintf('   (%.2e events)',length(Range(all_slowwaves{type})))]) ;
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
end


% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
text(0.5,0.6,'Mean LFP signals','FontSize',20,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off





%% ---------------------- Down State co-occurrence and associated LFP profiles ---------------------- : 

cooccur_window = 300 ; 

figure,
sgtitle(['Slow Waves x Down States Co-occurrence, co-occur delay = ' num2str(cooccur_window) ' ms']);

for type = 1:length(all_slowwaves) 
    
    slowwaves = all_slowwaves{type} ;
    all_subplots(type) = subplot(3,3,subplots_order(type)) ; 
     
    hold on,
    
    % Get cooccurrence with down states : 
    [co, cot] = EventsCooccurrence(slowwaves,ts((Start(alldown_PFCx)+End(alldown_PFCx))/2), [cooccur_window cooccur_window]) ; 
    prop_co_down = sum(co)/length(co) ; 
    all_slowwaves_times = Range(slowwaves) ; 
    
    % Plot LFP profiles for co-occurring and non co-occurring slow waves :
    % co-occurring : 
    [mdeep,s,t]=mETAverage(all_slowwaves_times(co),Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,s,t]=mETAverage(all_slowwaves_times(co),Range(LFPsup),Data(LFPsup),1,1000);
    plot(t,mdeep,'Color',LFP_colors{1},'LineWidth',2) ; 
    plot(t,msup,'Color',LFP_colors{2},'LineWidth',2) ; 
    % non co-occurring : 
    [mdeep,s,t]=mETAverage(all_slowwaves_times(~co),Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,s,t]=mETAverage(all_slowwaves_times(~co),Range(LFPsup),Data(LFPsup),1,1000);
    plot(t,mdeep,'--','Color',LFP_colors{1},'LineWidth',1.5) ; 
    plot(t,msup,'--','Color',LFP_colors{2},'LineWidth',1.5) ; 
    
    legend({'PFCdeep','PFCsup'},'Location','northeast') ; 
    title(['Type ' num2str(type) newline sprintf('Co-occur (line) : %.2g',prop_co_down*100) '% / ' sprintf('Non co-occur (dashed line) : %.2g',100-prop_co_down*100) '%']) ;
    
end

linkaxes(all_subplots) ; 

% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Co-occurrence with Down States' newline '(mid-time)'],'FontSize',20,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.2,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.05,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


    

%% ---------------------- Diff Delta Waves (KJ) co-occurrence and associated LFP profiles ---------------------- : 


cooccur_window = 300 ; 

figure,
sgtitle(['Slow Waves x (KJ Diff) Delta Waves Co-occurrence, co-occur delay = ' num2str(cooccur_window) ' ms']);

for type = 1:length(all_slowwaves) 
    
    slowwaves = all_slowwaves{type} ;
    all_subplots(type) = subplot(3,3,subplots_order(type)) ; 
     
    hold on,
    
    % Get cooccurrence with down states : 
    [co, cot] = EventsCooccurrence(slowwaves,ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2), [cooccur_window cooccur_window]) ; 
    prop_co_down = sum(co)/length(co) ; 
    all_slowwaves_times = Range(slowwaves) ; 
    
    % Plot LFP profiles for co-occurring and non co-occurring slow waves :
    % co-occurring : 
    [mdeep,s,t]=mETAverage(all_slowwaves_times(co),Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,s,t]=mETAverage(all_slowwaves_times(co),Range(LFPsup),Data(LFPsup),1,1000);
    plot(t,mdeep,'Color',LFP_colors{1},'LineWidth',2) ; 
    plot(t,msup,'Color',LFP_colors{2},'LineWidth',2) ; 
    % non co-occurring : 
    [mdeep,s,t]=mETAverage(all_slowwaves_times(~co),Range(LFPdeep),Data(LFPdeep),1,1000);
    [msup,s,t]=mETAverage(all_slowwaves_times(~co),Range(LFPsup),Data(LFPsup),1,1000);
    plot(t,mdeep,'--','Color',LFP_colors{1},'LineWidth',1.5) ; 
    plot(t,msup,'--','Color',LFP_colors{2},'LineWidth',1.5) ; 
    
    legend({'PFCdeep','PFCsup'},'Location','northeast') ; 
    title(['Type ' num2str(type) newline sprintf('Co-occur (line) : %.2g',prop_co_down*100) '% / ' sprintf('Non co-occur (dashed line) : %.2g',100-prop_co_down*100) '%']) ;
    
end

linkaxes(all_subplots) ; 

% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Co-occurrence with differential Delta Waves' newline '(mid-time)'],'FontSize',20,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.2,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.05,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off



