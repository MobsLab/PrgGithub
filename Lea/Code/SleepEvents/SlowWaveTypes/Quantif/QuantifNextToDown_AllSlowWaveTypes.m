
%% QuantifNextToDown_AllSlowWaveTypes
% 
% 06/06/2020  LP
%
% Script to plot proportion of slow waves next to a down state,  for all slow wave types. 
% -> choose cooccur_delay1 & cooccur_delay2 
% -> for one session

clear

%% ---------------------- Load Data ---------------------- : 

% LOAD EVENTS : 
load('SlowWaves2Channels_LP.mat')
all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
load('DownState.mat','alldown_PFCx')
load('DeltaWaves.mat','alldeltas_PFCx')
    downstates_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; % convert to ts with mid time
    diffdelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; % convert to ts with mid time (differential Delta = as computed by KJ)
    

% SUBSTAGES :
    % Clean SWS Epoch
    load('SleepSubstages.mat')
    SWS = Epoch{strcmpi(NameEpoch,'SWS')} ;
    load NoiseHomeostasisLP TotalNoiseEpoch % noise
    cleanSWS = diff(SWS,TotalNoiseEpoch) ; 
    % REM & Wake Epochs
    REM = Epoch{strcmpi(NameEpoch,'REM')} ;
    WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
epoch = cleanSWS ;

% PLOT INFO :
subplots_order = [1 3 7 9 2 8 4 6] ; 
bar_colors = {[0 0.35 0.65],[0.9 0.6 0]} ; 
cooccur_delay1 = 100 ; % in ms
cooccur_delay2 = 300 ; % in ms


%% ---------------------- Get and Plot co-occurrence with down states ---------------------- : 


% ------------------- clean NREM sleep only ------------------- : 

figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    sw_ts = all_slowwaves{type} ; 
    all_events_t = Range(sw_ts) ;
    epoch_events_t = all_events_t(logical(belong(epoch,all_events_t))) ;
    
    % Proportion of slow waves co-occurring with down states :
    
    [co1, cot1] = EventsCooccurrence(ts(epoch_events_t),downstates_ts, [cooccur_delay1 cooccur_delay1]) ;
        nb_events = length(co1) ;
        DownCooccurProp1 = sum(co1)/length(co1) *100 ;
        
    [co2, cot2] = EventsCooccurrence(ts(epoch_events_t),downstates_ts, [cooccur_delay2 cooccur_delay2]) ;
        DownCooccurProp2 = sum(co2)/length(co2) *100 ;

        
    % Plots : 
    hold on, 
    bar(1,DownCooccurProp1,'LineStyle','none','FaceColor',bar_colors{1}) ;
    text(1,DownCooccurProp1 + 10,[sprintf(' %.3g',DownCooccurProp1) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    bar(2,DownCooccurProp2,'LineStyle','none','FaceColor',bar_colors{2}) ;
    text(2,DownCooccurProp2 + 5,[sprintf(' %.3g',DownCooccurProp2) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    ylim([0 110]) ; 
    set(gca,'Xtick',1:2, 'XTickLabel',{[num2str(cooccur_delay1)],[num2str(cooccur_delay2)]},'FontSize',12) ; box on ; 
    ylabel(['% of SW next to a down state']) ; xlabel('detection delay (ms)')
    title(['Slow Waves Type ' num2str(type)]) ; 
    
end    
    
    
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave - Down State Co-occurrence'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

 
