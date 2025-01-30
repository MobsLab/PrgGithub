
%% QuantifDownCooccur_AllSlowWaveTypes
% 
% 29/05/2020  LP
%
% Script to plot down state co-occurrence for all slow wave types. 
% -> Cooccurrence Detection = when slow wave peak falls in down state interval ! 
% -> for one session

clear

%% ---------------------- Load Data ---------------------- : 

% LOAD EVENTS : 
load('SlowWaves2Channels_LP.mat')
all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
load('DownState.mat','alldown_PFCx')
load('DeltaWaves.mat','alldeltas_PFCx')


% LOAD SUBSTAGES : 
load('SleepSubstages.mat') ; 
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
    SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;


% PLOT INFO :
subplots_order = [1 3 7 9 2 8 4 6] ; 
bar_colors = {[0 0.35 0.65],[0.9 0.6 0]} ; 



%% ---------------------- Get and Plot co-occurrence with down states ---------------------- : 


% ------------------- WHOLE SESSION ------------------- : 

figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    sw_ts = all_slowwaves{type} ; 
    
    % Proportion of slow waves co-occurring with down states :
    sw_codown_ts = Restrict(sw_ts,alldown_PFCx) ; 
    sw_codown_prop = length(Range(sw_codown_ts))/length(Range(sw_ts)) * 100 ; 
    
    % Proportion of down states wich cooccur with these slow waves : 
    down_cosw_tsd = intervalCount(sw_ts,alldown_PFCx);
    down_cosw_prop = sum(Data(down_cosw_tsd)>0) / length(Range(down_cosw_tsd)) * 100 ; 
    
    % Plots : 
    hold on, 
    bar(1,sw_codown_prop,'LineStyle','none','FaceColor',bar_colors{1}) ;
    text(1,sw_codown_prop + 10,[sprintf(' %.3g',sw_codown_prop) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    bar(2,down_cosw_prop,'LineStyle','none','FaceColor',bar_colors{2}) ;
    text(2,down_cosw_prop + 5,[sprintf(' %.3g',down_cosw_prop) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    ylim([0 100]) ; 
    set(gca,'Xtick',1:2, 'XTickLabel',{'slow waves','down states'},'FontSize',12) ; box on ; 
    ylabel(['% of each co-occurring' newline ' with the other one']) ;  
    title(['Slow Waves Type ' num2str(type)]) ; 
    
end    
    
    
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave - Down State Co-occurrence'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

 


% ------------------- NREM SLEEP only ------------------- : 




figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    sw_ts = all_slowwaves{type} ; 
    NREM_sw_ts = Restrict(sw_ts,SWS) ;
    NREM_down = intersect(alldown_PFCx,SWS) ;
    
    % Proportion of slow waves co-occurring with down states :
    sw_codown_ts = Restrict(NREM_sw_ts,NREM_down) ; 
    sw_codown_prop = length(Range(sw_codown_ts))/length(Range(NREM_sw_ts)) * 100 ; 
    
    % Proportion of down states wich cooccur with these slow waves : 
    down_cosw_tsd = intervalCount(NREM_sw_ts,NREM_down);
    down_cosw_prop = sum(Data(down_cosw_tsd)>0) / length(Range(down_cosw_tsd)) * 100 ; 
    
    % Plots : 
    hold on, 
    bar(1,sw_codown_prop,'LineStyle','none','FaceColor',bar_colors{1}) ;
    text(1,sw_codown_prop + 10,[sprintf(' %.3g',sw_codown_prop) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    bar(2,down_cosw_prop,'LineStyle','none','FaceColor',bar_colors{2}) ;
    text(2,down_cosw_prop + 5,[sprintf(' %.3g',down_cosw_prop) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    ylim([0 100]) ; 
    set(gca,'Xtick',1:2, 'XTickLabel',{'slow waves','down states'},'FontSize',12) ; box on ; 
    ylabel(['% of each co-occurring' newline ' with the other one']) ;  
    title(['Slow Waves Type ' num2str(type)]) ; 
    
end    
    
    
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave - Down State Co-occurrence' newline 'NREM only'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.2,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.05,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

 

