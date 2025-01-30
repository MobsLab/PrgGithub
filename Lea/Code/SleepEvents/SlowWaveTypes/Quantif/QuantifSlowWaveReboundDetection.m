
%% QuantifSlowWaveReboundDetection
%
% 29/05/2020
%
% Script to quantify the proportion of NREM slow waves which are detected
% close to other slow waves, in order to detect slow waves which are
% only 'rebounds'of other slow waves. 

% ------------------- Parameters ----------------------- : 

cooccur_delay1 = 100 ; % in ms
cooccur_delay2 = 250 ; % in ms

% ------------------- Load Data ----------------------- : 

load('SlowWaves2Channels_LP.mat')
% LOAD SUBSTAGES : 
load('SleepSubstages.mat') ; 
REM = Epoch{strcmpi(NameEpoch,'REM')} ;
WAKE = Epoch{strcmpi(NameEpoch,'WAKE')} ;
SWS= Epoch{strcmpi(NameEpoch,'SWS')} ;



% ------------------- Plotting Info ----------------------- : 

% 'Reference' Slow Waves :
SW_ref_union = ts(sort([Range(slowwave_type3.deep_peaktimes)',Range(slowwave_type4.deep_peaktimes)',Range(slowwave_type6.deep_peaktimes)'])) ; % ts with all ref slow waves (deep positive)
SW_ref = {slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type6.deep_peaktimes,SW_ref_union} ;
SW_ref_names = {'SW3','SW4','SW6','SW3/4/6'} ; 
SW_ref_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4],[0 0 0.3]} ; 

% 'Observed'Slow Waves, suspected to be 'rebounds' of 'reference' slow waves :
SW_obs = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes} ;
SW_obs_names = {'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'} ; 



% ------------------- Plot Co-occurrence ----------------------- : 

% One subplot for each 'observed' SW type :

figure,

for obs_type = 1:length(SW_obs) 

    subplot(3,3,subplots_order(obs_type)),
    
    % Bar Plot : 
    for ref_type = 1:length(SW_ref)
        
        % Get info about cooccurrence proportion for the 2 time delays :
        [co1, cot1] = EventsCooccurrence(Restrict(SW_obs{obs_type},SWS),Restrict(SW_ref{ref_type},SWS), [cooccur_delay1 cooccur_delay1]) ;
        co_prop1 = sum(co1)/length(co1) * 100 ; 
        [co2, cot2] = EventsCooccurrence(Restrict(SW_obs{obs_type},SWS),Restrict(SW_ref{ref_type},SWS), [cooccur_delay2 cooccur_delay2]) ;
        co_prop2 = sum(co2)/length(co2) * 100 ; 
        
        % Barplot : 
        hold on,
        
        % 1st bar : 
        b = bar(ref_type - 0.2,co_prop1,'LineStyle','none') ;
        b.BarWidth = 0.3 ;
        b.FaceColor = SW_ref_colors{ref_type} ; 
        b.FaceAlpha = 0.7 ;
        text(ref_type - 0.2,co_prop1 + 10,[sprintf('%.2g',co_prop1) ' %'],'HorizontalAlignment','center','FontSize',11,'Color',SW_ref_colors{ref_type}) ; 
        
        % 2nd bar : 
        b = bar(ref_type + 0.2,co_prop2,'LineStyle','none') ;
        b.BarWidth = 0.3 ;
        b.FaceColor = SW_ref_colors{ref_type} ; 
        text(ref_type + 0.2,co_prop2 + 10,[sprintf('%.2g',co_prop2) ' %'],'HorizontalAlignment','center','FontSize',11,'Color',SW_ref_colors{ref_type}) ; 
         
        set(gca,'Xtick',1:length(SW_ref), 'XTickLabel',SW_ref_names,'FontSize',12) ; box on ;
        ylim([0 120]) ;
 
        
    end
    
    
    title(SW_obs_names{obs_type}) ;
    
end    

% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave Types Co-occurrence' newline 'coccurdelay1 = ' num2str(cooccur_delay1) 'ms, coccurdelay2 = '  num2str(cooccur_delay2) 'ms'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

 
