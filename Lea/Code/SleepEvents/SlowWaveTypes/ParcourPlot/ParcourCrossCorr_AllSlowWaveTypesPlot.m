%% ParcourCrossCorr_AllSlowWaveTypesPlot
% 
% 28/05/2020  LP
%
% Script to plot cross-correlograms between all slow wave types
% -> for all sessions.
% -> mean plot across mice

clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourCrossCorr_AllSlowWaveTypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourCrossCorr_AllSlowWaveTypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourCrossCorr_AllSlowWaveTypesPlots'])
end


%  -------------------- Plot Info --------------------- : 

label_colors = {[0 0.3 0],[0.4 0.8 0.2],[1 0.6 0],[1 0 0.2]} ; 
label_thresh = [2.5,5,10] ; 



%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :



%  -------------------- PLOTS --------------------- : 

% Choose sessions to be plotted :
ToPlot = 1:length(Info_res.path) ; % Plot all sessions
% ToPlot = [1] ; % Choose sessions to plot


for p = ToPlot
 
    % FOR EACH FIGURE : 

    figure,
    
    for type = 1:10 % each row of all cross-correlograms
    
        for type2 = 1:type % each corresponding column
    
            subplot(10,10,(type-1)*length(all_slowwaves_names)+type2) ; % subplot at location with row n演ype, column n演ype2    
            eval(['data = CrossCorr' num2str(type) '_' num2str(type2)]) ;  % structure with the corresponding correlogram
            C = data.crosscorr{p} ;
            B = data.crosscorr_t{p} ;
            
            % Color depending on max values : 
            if any (C>label_thresh(3))
                plot_color = label_colors{4} ;
            elseif any (C>label_thresh(2))
                plot_color = label_colors{3} ;
            elseif any (C>label_thresh(1))
                plot_color = label_colors{2} ; 
            else
                plot_color = label_colors{1} ; 
            end
    
            hold on, 
            area(B,C,'FaceColor',plot_color,'LineStyle','none')
            xline(0,'--','Color',[0.1 0.1 0.1]) ;
            xline(150,'--','Color',[0.5 0.5 0.5]) ; xline(-150,'--','Color',[0.5 0.5 0.5]) ; 
            xline(300,'--','Color',[0.5 0.5 0.5]) ; xline(-300,'--','Color',[0.5 0.5 0.5]) ; 
            xlim([-600,600]) ; 
            
            
            % Legends : 
            if type2 == 1
                ylabel(['ref ' all_slowwaves_names{type} '                     '],'FontSize',12,'FontWeight','bold','Rotation',0) ;
            end
            if type == 10
                xlabel(all_slowwaves_names{type2},'FontSize',12,'FontWeight','bold','Rotation',0) ;
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
    text(0.25,0.8,['> ' num2str(label_thresh(3))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
    text(0.4,0.8,['> ' num2str(label_thresh(2))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
    text(0.55,0.8,['> ' num2str(label_thresh(1))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
    text(0.7,0.8,['< ' num2str(label_thresh(1))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off

    % Save figure : 
    
    print(['AllSessions/ParcourCrossCorr_AllSlowWaveTypesPlot' num2str(p) '_' Info_res.name{p}], '-dpng', '-r300') ; 
    print(['epsFigures/ParcourCrossCorr_AllSlowWaveTypesPlot' num2str(p) '_' Info_res.name{p}], '-depsc') ; 
    close(gcf)
    
end



%% ----------------------------------------- MEAN PLOT for all sessions : across mice ----------------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 

% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 
 


% For each structure : 

for k = 1:length(crosscorr_names) 
    
    eval(['struct = ' crosscorr_names{k} ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
            eval(['data = cell2mat(struct.' fieldnames{field} ') ;'])
            
        for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
        end 

        eval(['Mice' crosscorr_names{k} '.' fieldnames{field} ' = mice_data;']) 
            
    end
end




% ------------------------------- Mean Plots ------------------------------- :

label_thresh = [1.5,3,5] ; 

figure,

for type = 1:10 % each row of all cross-correlograms = observed SW

    for type2 = 1:type % each corresponding column = ref SW

        subplot(10,10,(type-1)*10+type2) ; % subplot at location with row n演ype, column n演ype2    
        eval(['data = MiceCrossCorr' num2str(type) '_' num2str(type2) ';']) ;  % structure with the corresponding correlogram
        
        t = data.crosscorr_t{1} ;
        y = cell2mat(data.crosscorr) ; 
        mean_crosscorr = mean(y,2);
        sem = std(y,0,2) / sqrt(size(y,2)) ; 

        % Color depending on max values : 
        if any (mean_crosscorr>label_thresh(3))
            plot_color = label_colors{4} ;
        elseif any (mean_crosscorr>label_thresh(2))
            plot_color = label_colors{3} ;
        elseif any (mean_crosscorr>label_thresh(1))
            plot_color = label_colors{2} ; 
        else
            plot_color = label_colors{1} ; 
        end
        
        hold on,
        area(t,mean(y,2)-sem,'LineStyle','none','HandleVisibility','off','FaceColor',plot_color,'FaceAlpha',0.5);
        stdshade(y',0.7,plot_color,t) ; % plot mean data +/- SEM (shaded area)

        xline(0,'--','Color',[0.1 0.1 0.1]) ;
        xline(150,'--','Color',[0.5 0.5 0.5]) ; xline(-150,'--','Color',[0.5 0.5 0.5]) ; 
        xline(300,'--','Color',[0.5 0.5 0.5]) ; xline(-300,'--','Color',[0.5 0.5 0.5]) ; 
        xlim([-600,600]) ; 
         
        % Legends : 
        if type2 == 1
            ylabel([all_slowwaves_names{type} '                  '],'FontSize',12,'FontWeight','bold','Rotation',0) ;
        end
        if type == 10
            xlabel(['ref ' all_slowwaves_names{type2}],'FontSize',12,'FontWeight','bold','Rotation',0) ;
        end
    end
end


subplot(3,3,6),
text(0.3,1.55,['Auto- & Cross-Correlograms between all Slow Waves' newline 'Mean across mice (N = ' num2str(n_mice) ')'],'FontSize',20,'HorizontalALignment','center'), axis off
text(0.3,1.25,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.3,1.1,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.3,0.95,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.05,0.8,['> ' num2str(label_thresh(3))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{4}), axis off
text(0.2,0.8,['> ' num2str(label_thresh(2))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{3}), axis off
text(0.35,0.8,['> ' num2str(label_thresh(1))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{2}), axis off
text(0.5,0.8,['< ' num2str(label_thresh(1))],'FontSize',15,'HorizontalALignment','center','Color',label_colors{1}), axis off



print(['ParcourCrossCorr_AllSlowWaveTypesPlot_MiceMeanPlot'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourCrossCorr_AllSlowWaveTypesPlot_MiceMeanPlot'], '-depsc') ; 
