
%% ParcourDownCooccur_AllSlowWaveTypesPlot
% 
% 29/05/2020  LP
%
% Script to plot down state co-occurrence for all slow wave types, all sessions. 
% -> Cooccurrence Detection = when slow wave peak falls in down state interval ! 
% -> Plot all sessions + Mean plot across mice 


clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourObPhase_AllSlowWaveTypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourObPhase_AllSlowWaveTypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourObPhase_AllSlowWaveTypesPlots'])
end


% PLOT INFO :
subplots_order = [1 3 7 9 2 8 4 6] ; 
ToPlot = [1:4 9:15] ; % Sessions to keep for the plot -> removed 5 to 8 because mice 244 has bad OB signals (no real OBdeep)

%% ------------------------------- Mean OB Phase Histograms for all slow wave types : Across Sessions ------------------------------- :

figure,

for type = 1:length(struct_names) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    hold on,
    
    eval(['struct = SlowWaves' num2str(type) ';']) ; 
    
    % Convert Phase Pref values (stored as strings) to array with numerical values :
    phase_pref = [] ; 
    for i = ToPlot
        phase_pref(i) = str2num(struct.PhasePref{i}) ; 
    end
    
    % Plot all phase histogram curves overlayed : 
    yyaxis left
    for p = ToPlot
        plot(struct.hist_curve_x{p},struct.hist_curve_y{p},'-', 'LineWidth',1,'Color',[0 0 0]) ; 
    end
    ylim([0 8]); ylabel('OB Phase for each session (% of SW)') ;
    
    % Plot histogram of preferred phase values :
    yyaxis right
    histogram(phase_pref,15,'BinLimits',[0 4*pi]) ; 
    ylim([0 15]); ylabel(['Histogram of preferred phase' newline '(nb of sessions)']) ;

    xlabel('OB Phase (rad)') ;  xlim([0 4*pi])
    ax = gca; ax.YAxis(1).Color = [0 0 0];
    title(['Type ' num2str(type)])
end

 sgtitle(['OB Phase Preference for All Slow Waves' newline '(n = ' num2str(length(ToPlot)) ' sessions)']) ; 
 
     % Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['OB Phase Preference'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

   
        
 
% Save : 
print(['ParcourPhaseOb_AllSlowWaveTypesPlot_SessionsMeanPlot'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourPhaseOb_AllSlowWaveTypesPlot_SessionsMeanPlot'], '-depsc') ; 



%% ------------------------------- Mean OB Phase Histograms for all slow wave types 2 : Across Sessions ------------------------------- :

figure,

for type = 1:length(struct_names) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    hold on,
    
    eval(['struct = SlowWaves' num2str(type) ';']) ; 
    
    % Convert Phase Pref values (stored as strings) to array with numerical values :
    phase_pref = [] ; 
    for i = ToPlot
        phase_pref(i) = str2num(struct.PhasePref{i}) ; 
    end
    
    
    % Normalize data to area = 1 : 
    x = struct.hist_curve_x{1} ; 
    y = vertcat(struct.hist_curve_y{:});
    y = y(ToPlot,:); % keep only sessions to be plotted
    plotarea = trapz(x,mean(y)) ; y = y / plotarea ;
    
  % Plot all phase histogram curves overlayed : 
  l = [] ; 
    for p = 1:length(ToPlot)
        l(1) = plot(x,y(p,:),'-', 'LineWidth',1,'Color',[0.5 0.5 0.5]) ; 
    end
    
    
    sem = std(y) / sqrt(length(y)) ; 
    hold on,
    plot_color = [0.2 0.3 0.6] ; 
    area(x,mean(y)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.5);
    stdshade(y,0.8,plot_color,x) ; % plot mean data +/- SEM (shaded area)
    l(2) = plot(x,mean(y),'Color',[0.1 0 0.6]) ; 
    
    xline(2*pi,'--','Color',[0.2 0.2 0.2], 'HandleVisibility','off');
    xlabel('OB Phase (rad)') ;  xlim([0 4*pi]) ; 
    ylim([0 0.35]); ylabel('SW Proportion (density curve)') ;
    title(['Type ' num2str(type)])
    set(gca,'xtick',[0 pi 2*pi 3*pi 4*pi],'xticklabels',{'0','\pi','2\pi','3\pi','4\pi'}) ;
    set(gca,'ytick',[0 0.1 0.2 0.3]) ; 
    set(gca,'FontSize',12)
    legend(l,{'All Sessions','Mean'}) ; legend boxoff ;
end

 sgtitle(['OB Phase Preference for All Slow Waves' newline '(n = ' num2str(length(ToPlot)) ' sessions)']) ; 
 
     % Title & Parameters 
subplot(3,3,5),
text(0.5,0.9,'2-Channel Slow Waves','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.65,['OB Phase Preference' newline 'Density Curve'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

   
        
 
% Save : 
print(['ParcourPhaseOb_AllSlowWaveTypesPlot_SessionsMeanPlot2'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourPhaseOb_AllSlowWaveTypesPlot_SessionsMeanPlot2'], '-depsc') ; 




% %% ----------------------------------------- MEAN PLOT for all sessions : across mice ----------------------------------------- :
% 
% % ie. after averaging across sessions for a same mice
% n_mice = length(unique(Info_res.name)) ; 
% 
% % ------------------------------- Get mice-averaged structures ------------------------------- :
% 
% [mice_list, ~, ix] = unique(Info_res.name) ; 
%  
% % For each structure : 
% 
% for k = 1:length(struct_names) 
%     
%     eval(['struct = ' struct_names{k} ';']) ; 
%     fieldnames = fields(struct) ;
%     
%     for field = 1:length(fieldnames)
%             eval(['data = cell2mat(struct.' fieldnames{field} ') ;'])
%             
%         for m = 1:length(mice_list) 
%                 mice_data{m} = nanmean(data(:,ix==m),2) ; 
%         end 
% 
%         eval(['Mice' struct_names{k} '.' fieldnames{field} ' = mice_data;']) 
%             
%     end
% end
% 
% % ------------------------------- Mean OB Phase Histograms for all slow wave types : Across Mice ------------------------------- :
% 
% figure,
% 
% for type = 1:length(struct_names) 
%     
%     all_subplots(type) = subplot(3,3,subplots_order(type));
%     hold on,
%     
%     eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
%     
%     % Plot histogram of preferred phase values :
%     %hist(cell2mat(struct.PhasePref)) ; 
%     % Plot all phase histogram curves overlayed : 
%     for p = 1:length(struct.PhasePref)
%         plot(struct.hist_curve_x{p},struct.hist_curve_y{p},'LineWidth',1) ; 
%     end
%     xlabel('OB Phase') ; ylabel('% of Slow Waves') ;  title(['OB Phase Preference for All Slow Waves' newline '(N = ' num2str(length(struct.PhasePref)) ' mice)']) ; 
% end
% 
% % Save : 
% print(['ParcourPhaseOb_AllSlowWaveTypesPlot_MiceMeanPlot'], '-dpng', '-r300') ; 
% print(['epsFigures/ParcourPhaseOb_AllSlowWaveTypesPlot_MiceMeanPlot'], '-depsc') ; 
% 
% 
% 
