%% QuantifCrossCorr_AllSlowWaveTypes
% 
% 25/05/2020  LP
%
% Script to plot cross-correlograms between all slow wave types.
%

%Dir = PathForExperimentsSlowWavesLP_HardDrive ;
% clearvars -except Dir
%cd(Dir.path{16})


%% ---------------------- Load Data ---------------------- : 


% LOAD EVENTS : 
% 2-Channel Slow Waves : 
load('SlowWaves2Channels_LP.mat')
% Delta KJ & Down States : 
load('DownState.mat','alldown_PFCx')
load('DeltaWaves.mat','alldeltas_PFCx')
alldelta_ts = ts((Start(alldeltas_PFCx)+End(alldeltas_PFCx))/2) ; 
alldown_ts = ts((Start(alldown_PFCx)+End(alldown_PFCx))/2) ; 


all_slowwaves = {slowwave_type1.deep_peaktimes,slowwave_type2.deep_peaktimes,slowwave_type3.deep_peaktimes,slowwave_type4.deep_peaktimes,slowwave_type5.deep_peaktimes,slowwave_type6.deep_peaktimes,slowwave_type7.sup_peaktimes,slowwave_type8.sup_peaktimes,alldelta_ts,alldown_ts} ;
slowwaves_names = {'SW1', 'SW2', 'SW3','SW4', 'SW5', 'SW6','SW7', 'SW8', 'Delta', 'Down'} ; 

%% ---------------------- Plot Cross-Correlograms between all  ---------------------- : 

figure,
yl = [-1 10] ;
label_colors = {[0 0.3 0],[0.4 0.8 0.2],[1 0.6 0],[1 0 0.2]} ; 

for type = 1:length(all_slowwaves) % each row of all cross-correlograms
    
    for type2 = 1:type % each corresponding column
        
    all_subplots(type) = subplot(10,10,(type-1)*length(all_slowwaves)+type2) ; % subplot at location with row nºtype, column nºtype2    
    [C,B]=CrossCorr(Range(all_slowwaves{type2}),Range(all_slowwaves{type}),10,120); % reference = row
    
    % Auto-Correlograms : 
    if type2==type
        C(B==0) = 0 ;
    end 
    
    % Color depending on max values : 
    if any (C>10)
        plot_color = label_colors{4} ;
    elseif any (C>5)
        plot_color = label_colors{3} ;
    elseif any (C>2.5)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    hold on, 
    area(B,C,'FaceColor',plot_color,'LineStyle','none') 
    xline(0,'--','Color',[0.2 0.2 0.2]) ; 
    xline(150,'--','Color',[0.4 0.4 0.4]) ; xline(-150,'--','Color',[0.4 0.4 0.4]) ; 
    xline(300,'--','Color',[0.4 0.4 0.4]) ; xline(-300,'--','Color',[0.4 0.4 0.4]) ; 
    xlim([-600,600]) ; 
    
    % Legends : 
        if type2 == 1
            ylabel([slowwaves_names{type} '                     '],'FontSize',12,'FontWeight','bold','Rotation',0) ;
        end
        if type == length(all_slowwaves)
            xlabel(['ref ' slowwaves_names{type2}],'FontSize',12,'FontWeight','bold','Rotation',0) ;
        end
        
    end
end
        
% Title & Parameters 

subplot(3,3,3),
text(0.5,0.5,['Auto/Cross-correlograms' newline 'between all slow wave (SW) types'],'FontSize',25,'HorizontalALignment','center'), axis off

subplot(3,3,6),
text(0.5,1.45,'2-Channel Slow Waves','FontSize',20,'HorizontalALignment','center'), axis off
text(0.5,1.25,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,1.1,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.95,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.25,0.8,'> 10','FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
text(0.4,0.8,'> 5','FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
text(0.55,0.8,'> 2.5','FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
text(0.7,0.8,'< 2.5','FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off


