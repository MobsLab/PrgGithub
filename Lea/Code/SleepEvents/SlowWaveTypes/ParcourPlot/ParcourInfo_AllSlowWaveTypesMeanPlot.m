
%% ParcourInfo_AllSlowWaveTypesMeanPlot
% 
% 19/05/2020  LP
%
% Script to plot mean info for all 2-channel slow wave types
% -> All slow wave types on the same plot
% -> 2 plots for each quantif : mean across sessions and mean across mice 
%
% Plots for : 
% -> mean LFP around slow waves
% -> mean spiking rate around slow waves
% -> mean cross-correlogram with down states, with ripples
% -> mean Wake/NREM/REM repartition
%
% Output Structures :
%   - SlowWaves1, SlowWaves2, ..., SlowWaves8
%
% SEE : 
% ParcourMakeSlowWavesOn2Channels_LP() 
% PlotInfo_AllSlowWaveTypes
% ParcourInfo_AllSlowWaveTypes



% ------------------------------------------ Load Data ------------------------------------------ :

clear
load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes.mat
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourInfo_AllSlowWaveTypes_MeanPlot/' ; 



% Subplots organization : 
subplots_order = [1 3 7 9 2 8 4 6] ; 

% LFP colors : 

LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;

stages_names = {'Wake', 'NREM', 'REM'} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
% Label colors : 
label_colors = {[0 0.3 0],[0.4 0.8 0.2],[1 0.6 0],[1 0 0.2]} ; 



%% --------------------------------------------- MEAN PLOTS ACROSS SESSIONS ---------------------------------------------- :


% ------------------------------ Mean LFP Profiles ------------------------------ :

figure,
yl = [-2200 2200] ; 

for type = 1:8      %for each slow wave type
    
    subplot(3,3,subplots_order(type));
    hold on,
    
    % Get data : 
    eval(['Data = SlowWaves' num2str(type) '.LFPprofiles ;']) ; 
    
    % Plot all LFP :
    mean_PFCdeep = mean(cell2mat(Data.PFCdeep),2);
    plot(Data.t{1},mean_PFCdeep,'Color',LFP_colors{1},'LineWidth',2.1)
    mean_PFCsup = mean(cell2mat(Data.PFCsup),2);
    plot(Data.t{1},mean_PFCsup,'Color',LFP_colors{2},'LineWidth',2.2)
    mean_OBdeep = mean(cell2mat(Data.OBdeep),2);
    plot(Data.t{1},mean_OBdeep,'Color',LFP_colors{3},'LineWidth',1.4)
    
    % Legend & Labels : 
    xlabel('Time from slow wave peak (ms)') ; 
    xticks([-500 -250 0 250 500]);
    ylim(yl) ; title(['Type ' num2str(type)],'Fontsize',12) ;
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    legend(LFP_legend,'Orientation','vertical','Location','northeast') ; legend boxoff ; 
end


% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Mean LFP signals across sessions (n = ' num2str(length(Info_res.name)) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


% Save figure : 
print([PathToSave 'AllSlowWaveTypes_SessionsMeanLFPprofiles'], '-dpng', '-r250') ; 
% close(gcf)




% ------------------------------ Mean Spiking Rate ------------------------------ :

figure,
yl = [0 0.7] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = SlowWaves' num2str(type) '.SpikingRate ;']) ;
    y = cell2mat(Data.rate) ; 
    mean_rate = mean(y,2);
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    hold on, 
    area(t,mean(y,2),'LineStyle','none','HandleVisibility','off','FaceColor',[0.4 0.4 0.4]);
    stdshade(y',0.3,'k',t) ; % plot mean data +/- SEM (shaded area) 
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.1 0.1 0.1]) ;
    ylabel('Mean spiking rate') ; xlabel('Time from slow wave peak (ms)') ; 
    legend({'± SEM','Mean'}) ; legend boxoff ; 
    title(['Type ' num2str(type)]) ;
    
end

subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Mean PFCx Spiking Rate (n = ' num2str(length(Info_res.name)) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

% Save figure : 
print([PathToSave 'AllSlowWaveTypes_SessionsMeanSpikingRate'], '-dpng', '-r250') ; 
%close(gcf)


% ------------------------------ Mean CrossCorrelogram with Down States ------------------------------ :


figure,
yl = [0 16] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = SlowWaves' num2str(type) '.CrossCorrDown ;']) ;
    y = cell2mat(Data.crosscorr) ; 
    mean_crosscorr = mean(y,2);
    
    % Color depending on max values : 
    if any (mean_crosscorr>12)
        plot_color = label_colors{4} ;
    elseif any (mean_crosscorr>5)
        plot_color = label_colors{3} ;
    elseif any (mean_crosscorr>3)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    sem = std(y,0,2) / sqrt(size(y,2)) ; 
    hold on,
    area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.5);
    stdshade(y',0.7,plot_color,t) ; % plot mean data +/- SEM (shaded area) 
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.1 0.1 0.1]) ;
    ylabel('Mean correlation index') ; xlabel('Time from slow wave peak (ms)') ; 
    legend('± SEM','Mean') ; legend boxoff ; 
    title(['Type ' num2str(type) ' x Down States']) ;
    
end

subplot(3,3,5),
text(0.5,0.95,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.7,['Cross-corr. with Down States (mid-time)' newline 'Mean across sessions (n = ' num2str(length(Info_res.name)) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
% Color Legend : 
text(0.25,0,'> 12','FontSize',15,'HorizontalAlignment','center','Color',label_colors{4}), axis off
text(0.4,0,'> 5','FontSize',15,'HorizontalAlignment','center','Color',label_colors{3}), axis off
text(0.55,0,'> 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{2}), axis off
text(0.7,0,'< 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{1}), axis off



% Save figure : 
print([PathToSave 'AllSlowWaveTypes_SessionsMeanCrossCorrDown'], '-dpng', '-r250') ; 
%close(gcf)


% ------------------------------ Mean CrossCorrelogram with Ripples ------------------------------ :


figure,
yl = [0 1.2] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = SlowWaves' num2str(type) '.CrossCorrRipples ;']) ;
    y = cell2mat(Data.crosscorr) ; 
    mean_crosscorr = mean(y,2);
    
    % Color depending on max values : 
    if any (mean_crosscorr>2)
        plot_color = label_colors{4} ;
    elseif any (mean_crosscorr>0.8)
        plot_color = label_colors{3} ;
    elseif any (mean_crosscorr>0.5)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    sem = std(y,0,2) / sqrt(size(y,2)) ; 
    hold on,
    area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.5);
    stdshade(y',0.7,plot_color,t) ; % plot mean data +/- SEM (shaded area)
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
    ylabel('Mean correlation index') ; xlabel('Time from slow wave peak (ms)') ; 
    legend('± SEM','Mean') ; legend boxoff ; 
    title(['Type ' num2str(type) ' x Ripples']) ;
    
end

subplot(3,3,5),
text(0.5,0.95,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
text(0.5,0.7,['Cross-corr. with Ripples' newline 'Mean across sessions (n = ' num2str(length(Info_res.name)) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
% Color Legend : 
text(0.25,0,'> 12','FontSize',15,'HorizontalAlignment','center','Color',label_colors{4}), axis off
text(0.4,0,'> 5','FontSize',15,'HorizontalAlignment','center','Color',label_colors{3}), axis off
text(0.55,0,'> 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{2}), axis off
text(0.7,0,'< 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{1}), axis off

% Save figure : 
print([PathToSave 'AllSlowWaveTypes_SessionsMeanCrossCorrRipples'], '-dpng', '-r250') ; 
%close(gcf)

% ------------------------------ Mean Stage Occurrence : Wake / NREM / REM ------------------------------ :



figure,
yl = [0 120] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = SlowWaves' num2str(type) '.StageOccurrence ;']) ;
    stages_prop = {cell2mat(Data.propWake), cell2mat(Data.propNREM),cell2mat(Data.propREM)} ; 

    for k = 1:length(stages_prop) 
        hold on,
        bar(k,mean(stages_prop{k}),'LineStyle','none','FaceColor',stages_colors{k}) ;  
        text(k,mean(stages_prop{k}) + 12,[sprintf(' %.3g',mean(stages_prop{k})) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ; 
        sem = std(stages_prop{k}) / sqrt(length(stages_prop{k})) ; 
        errorbar(k,mean(stages_prop{k}),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
    end
   
    
    set(gca,'Xtick',1:length(stages_prop), 'XTickLabel',stages_names,'FontSize',12) ; box on ; 
    ylabel('% of events in each stage') ; title('Stage repartition') ;  
    ylim(yl) ; title(['Type ' num2str(type)]) ; 
    yline(100,'--','Color',[0.5 0.5 0.5]) ;

end



subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Mean Stage Occurrence across sessions (n = ' num2str(length(Info_res.name)) ')'],'FontSize',20,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


% Save figure : 
print([PathToSave 'AllSlowWaveTypes_SessionsMeanStageOccurrence'], '-dpng', '-r250') ; 
%close(gcf)





%% --------------------------------------------- MEAN PLOTS ACROSS MICE ---------------------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 

% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 


% For each structure : 

for type = 1:8
    
    eval(['struct = SlowWaves' num2str(type) ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
        eval(['struct2 = struct.' fieldnames{field} ';'])
        fieldnames2 = fields(struct2) ;
        
        for field2 = 1:length(fieldnames2)
            eval(['data = cell2mat(struct2.' fieldnames2{field2} ') ;'])
            
            for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
            end 

            eval(['MiceSlowWaves' num2str(type) '.' fieldnames{field} '.' fieldnames2{field2} ' = mice_data;']) 
            
        end
    end
end


% ------------------------------ Mean LFP Profiles ------------------------------ :

figure,
yl = [-2200 2200] ; 

for type = 1:8      %for each slow wave type
    
    subplot(3,3,subplots_order(type));
    hold on,
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.LFPprofiles ;']) ; 
    
    % Plot all LFP :
    mean_PFCdeep = mean(cell2mat(Data.PFCdeep),2);
    plot(Data.t{1},mean_PFCdeep,'Color',LFP_colors{1},'LineWidth',2.1)
    mean_PFCsup = mean(cell2mat(Data.PFCsup),2);
    plot(Data.t{1},mean_PFCsup,'Color',LFP_colors{2},'LineWidth',2.2)
    mean_OBdeep = mean(cell2mat(Data.OBdeep),2);
    plot(Data.t{1},mean_OBdeep,'Color',LFP_colors{3},'LineWidth',1.4)
    
    % Legend & Labels : 
    xlabel('Time from slow wave peak (ms)') ; 
    ylim(yl) ; title(['Type ' num2str(type)],'Fontsize',12) ;
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
    legend(LFP_legend,'Orientation','vertical','Location','northeast') ; legend boxoff ; 
end


% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Mean LFP signals across mice (N = ' num2str(n_mice) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanLFPprofiles'], '-dpng', '-r250') ; 
%close(gcf)




% ------------------------------ Mean Spiking Rate ------------------------------ :

figure,
yl = [0 0.7] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.SpikingRate ;']) ;
    y = cell2mat(Data.rate) ; 
    mean_rate = mean(y,2);
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    hold on, 
    area(t,mean(y,2),'LineStyle','none','HandleVisibility','off','FaceColor',[0.4 0.4 0.4]);
    stdshade(y',0.3,'k',t) ; % plot mean data +/- SEM (shaded area) 
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.1 0.1 0.1]) ;
    ylabel('Mean spiking rate') ; xlabel('Time from slow wave peak (ms)') ; 
    legend('± SEM','Mean') ; legend boxoff ; 
    title(['Type ' num2str(type)]) ;
    
end

subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Mean PFCx Spiking Rate across mice (N = ' num2str(n_mice) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off

% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanSpikingRate'], '-dpng', '-r250') ; 
%close(gcf)


% ------------------------------ Mean CrossCorrelogram with Down States ------------------------------ :


figure,
yl = [0 15] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.CrossCorrDown ;']) ;
    y = cell2mat(Data.crosscorr) ; 
    mean_crosscorr = mean(y,2);
    
    % Color depending on max values : 
    if any (mean_crosscorr>10)
        plot_color = label_colors{4} ;
    elseif any (mean_crosscorr>5)
        plot_color = label_colors{3} ;
    elseif any (mean_crosscorr>3)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    sem = std(y,0,2) / sqrt(size(y,2)) ; 
    hold on,
    area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.45);
    stdshade(y',0.7,plot_color,t) ; % plot mean data +/- SEM (shaded area)
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
    ylabel('Mean correlation index') ; xlabel('Time from slow wave peak (ms)') ; 
    legend('± SEM','Mean') ; legend boxoff ; 
    title(['Type ' num2str(type) ' x Down States']) ;
    
end

subplot(3,3,5),
text(0.5,0.95,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
text(0.5,0.7,['Cross-corr. with Down States (mid-time)' newline 'Mean across mice (N = ' num2str(n_mice) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
% Color Legend : 
text(0.25,0,'> 10','FontSize',15,'HorizontalAlignment','center','Color',label_colors{4}), axis off
text(0.4,0,'> 5','FontSize',15,'HorizontalAlignment','center','Color',label_colors{3}), axis off
text(0.55,0,'> 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{2}), axis off
text(0.7,0,'< 3','FontSize',15,'HorizontalAlignment','center','Color',label_colors{1}), axis off


% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanCrossCorrDown'], '-dpng', '-r250') ; 
%close(gcf)


% ------------------------------ Mean CrossCorrelogram with Ripples ------------------------------ :


figure,
yl = [0 1] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.CrossCorrRipples ;']) ;
    y = cell2mat(Data.crosscorr) ; 
    mean_crosscorr = mean(y,2);
    
    % Color depending on max values : 
    if any (mean_crosscorr>0.8)
        plot_color = label_colors{4} ;
    elseif any (mean_crosscorr>0.6)
        plot_color = label_colors{3} ;
    elseif any (mean_crosscorr>0.4)
        plot_color = label_colors{2} ; 
    else
        plot_color = label_colors{1} ; 
    end
    
    % Get and plot mean spiking rate : 
    t = Data.t{1} ; 
    sem = std(y,0,2) / sqrt(size(y,2)) ; 
    hold on,
    area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.5);
    stdshade(y',0.7,plot_color,t) ; % plot mean data +/- SEM (shaded area)
    
    % Legend / Labels : 
    ylim(yl) ; 
    xline(0,'--','Color',[0.3 0.3 0.3]) ;
    ylabel('Mean correlation index') ; xlabel('Time from slow wave peak (ms)') ; 
    legend('± SEM','Mean') ; legend boxoff ; 
    title(['Type ' num2str(type) ' x Ripples'],'FontSize',12) ;
    
end

subplot(3,3,5),
text(0.5,0.95,'2-Channel Slow Waves','FontSize',24,'HorizontalALignment','center'), axis off
text(0.5,0.7,['Cross-corr. with Ripples' newline 'Mean across mice (N = ' num2str(n_mice) ')'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.45,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.3,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.15,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
% Color Legend : 
text(0.25,0,'> 0.8','FontSize',15,'HorizontalAlignment','center','Color',label_colors{4}), axis off
text(0.4,0,'> 0.6','FontSize',15,'HorizontalAlignment','center','Color',label_colors{3}), axis off
text(0.55,0,'> 0.4','FontSize',15,'HorizontalAlignment','center','Color',label_colors{2}), axis off
text(0.7,0,'< 0.4','FontSize',15,'HorizontalAlignment','center','Color',label_colors{1}), axis off

% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanCrossCorrRipples'], '-dpng', '-r250') ; 
%close(gcf)



% ------------------------------ Mean Stage Occurrence : Wake / NREM / REM ------------------------------ :



figure,
yl = [0 120] ;

for type = 1:8      %for each slow wave type

    subplot(3,3,subplots_order(type)),
    
    % Get data : 
    eval(['Data = MiceSlowWaves' num2str(type) '.StageOccurrence ;']) ;
    stages_prop = {cell2mat(Data.propWake), cell2mat(Data.propNREM),cell2mat(Data.propREM)} ; 

    for k = 1:length(stages_prop) 
        hold on,
        bar(k,mean(stages_prop{k}),'LineStyle','none','FaceColor',stages_colors{k}) ;  
        text(k,mean(stages_prop{k}) + 12,[sprintf(' %.3g',mean(stages_prop{k})) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ; 
        sem = std(stages_prop{k}) / sqrt(length(stages_prop{k})) ; 
        errorbar(k,mean(stages_prop{k}),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
    end
   
    
    set(gca,'Xtick',1:length(stages_prop), 'XTickLabel',stages_names,'FontSize',12) ; box on ; 
    ylabel('% of events in each stage') ; title('Stage repartition') ;  
    ylim(yl) ; title(['Type ' num2str(type)]) ; 
    yline(100,'--','Color',[0.5 0.5 0.5]) ;

end



subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',25,'HorizontalALignment','center'), axis off
text(0.5,0.6,['Mean Stage Occurrence across mice (N = ' num2str(n_mice) ')'],'FontSize',20,'HorizontalALignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off


% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanStageOccurrence'], '-dpng', '-r250') ; 
%close(gcf)





% ------------------------------ Mean Stage Occurrence : Wake / NREM / REM ------------------------------ :



figure,
sgtitle(['Slow Waves x Down States Co-occurrence (N = ' num2str(n_mice) ' mice)' newline 'detection delay = ' num2str(MiceSlowWaves1.CrossCorrDown.cooccur_delay{1}) 'ms']); 

for type = 1:8      %for each slow wave type
    
    eval(['Data = MiceSlowWaves' num2str(type) '.CrossCorrDown ;']) ;
    alltypes_cooccurprop(type) = mean(cell2mat(Data.cooccurprop)) ; 
    alltypes_cooccurprop_sem(type) = std(cell2mat(Data.cooccurprop))/sqrt(length(Data.cooccurprop)) ; 
    
    down_cooccurprop(type) = mean(cell2mat(Data.downcooccurprop)) ; 
    down_cooccurprop_sem(type) = std(cell2mat(Data.downcooccurprop))/sqrt(length(Data.downcooccurprop)) ; 
end    

subplot(2,1,1),
hold on,
bar(1:length(alltypes_cooccurprop), alltypes_cooccurprop*100, 'LineStyle','none','FaceColor',[0 0.35 0.65]);
errorbar(1:length(alltypes_cooccurprop),alltypes_cooccurprop*100,alltypes_cooccurprop_sem*100,alltypes_cooccurprop_sem*100,'Color',[0 0 0], 'LineStyle','none') ; 
yline(100,'--','Color',[0.5 0.5 0.5]) ;
ylim([0 110]); xlim([0.2 8.8]) ; box on ; 
title('% of slow waves co-occurring with the down states, for each slow wave type') ; xlabel('slow wave type') ;

subplot(2,1,2),
hold on,
bar(1:length(down_cooccurprop), down_cooccurprop*100, 'LineStyle','none','FaceColor',[0.9 0.6 0]);
errorbar(1:length(down_cooccurprop),down_cooccurprop*100,down_cooccurprop_sem*100,down_cooccurprop_sem*100,'Color',[0 0 0], 'LineStyle','none') ; 
yline(100,'--','Color',[0.5 0.5 0.5]) ;
text(7,80,[sprintf('Total = %.3g',sum(down_cooccurprop)*100) ' % of down states'],'FontSize',11,'HorizontalAlignment','center')
ylim([0 110]); xlim([0.2 8.8]) ; box on ; 
title('% of down states co-occurring with the different slow waves') ; xlabel('slow wave type') ;

% Save figure : 
print([PathToSave 'AllSlowWaveTypes_MiceMeanDownCooccurrence'], '-dpng', '-r250') ; 
%close(gcf)
