
%% ParcourSlowWaveReboundDetectionPlot
% 
% 02/06/2020  LP
%
% Script to plot mean co-occurrence/proximity between all slow wave types. 
% -> Cooccurrence Detection = when slow wave < cooccur_delay (1 or 2)
% -> Mean plot across mice 


clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourSlowWaveReboundDetection.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourSlowWaveReboundDetectionPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourSlowWaveReboundDetectionPlots'])
end


% PLOT INFO :
subplots_order = [1 3 7 9 2 8 4 6] ; 
SW_ref_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4],[0 0 0.3]} ; 
plot_opacity = 0.7 ; 
SW_obs_names = {'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'} ; 
SW_ref_labels = strrep(SW_ref_names,'_','/') ; 

cooccur_delay1 = cooccur_delays(1) ; cooccur_delay2 = cooccur_delays(2) ; 

%% ----------------------------------------- MEAN PLOT for all sessions : across mice, 2 cooccurrence delays ----------------------------------------- :


% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 


% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 
 
% For each structure : 

for k = 1:length(struct_names) 
    
    eval(['struct = ' struct_names{k} ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
            eval(['data = cell2mat(struct.' fieldnames{field} ') ;'])
            
        for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
        end 

        eval(['Mice' struct_names{k} '.' fieldnames{field} ' = mice_data;']) 
            
    end
end


% ------------------------------- Mean Plot ------------------------------- :

% One subplot for each 'observed' SW type :

figure,

for obs_type = 1:length(struct_names) 

    subplot(3,3,subplots_order(obs_type)),
    eval(['struct = MiceSlowWaves' num2str(obs_type) ';']) ; 
    
    % Bar Plot : 
    for ref_type = 1:length(SW_ref_names)
        
    % Barplot : 
        hold on,
        
        eval(['co_prop1 = struct.CooccurProp1_' SW_ref_names{ref_type} ';']) ;
        eval(['co_prop2 = struct.CooccurProp2_' SW_ref_names{ref_type} ';']) ;
        
        % 1st bar : 
        b = bar(ref_type - 0.2,nanmean(cell2mat(co_prop1)),'LineStyle','none') ;
        b.BarWidth = 0.3 ;
        b.FaceColor = SW_ref_colors{ref_type} ; 
        b.FaceAlpha = plot_opacity - 0.2 ;
        text(ref_type - 0.2,nanmean(cell2mat(co_prop1)) + 10,[sprintf('%.2g',nanmean(cell2mat(co_prop1))) ' %'],'HorizontalAlignment','center','FontSize',11,'Color',SW_ref_colors{ref_type}) ; 
        sem = nanstd(cell2mat(co_prop1)) / length(cell2mat(co_prop1)) ; 
        errorbar(ref_type - 0.2,nanmean(cell2mat(co_prop1)),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
        
         % 2nd bar : 
        b = bar(ref_type + 0.2,nanmean(cell2mat(co_prop2)),'LineStyle','none') ;
        b.BarWidth = 0.3 ;
        b.FaceColor = SW_ref_colors{ref_type} ; 
        b.FaceAlpha = plot_opacity ;
        text(ref_type + 0.2,nanmean(cell2mat(co_prop2)) + 10,[sprintf('%.2g',nanmean(cell2mat(co_prop2))) ' %'],'HorizontalAlignment','center','FontSize',11,'Color',SW_ref_colors{ref_type}) ; 
        sem = nanstd(cell2mat(co_prop2)) / length(cell2mat(co_prop2)) ; 
        errorbar(ref_type + 0.2,nanmean(cell2mat(co_prop2)),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
        
        set(gca,'Xtick',1:length(SW_ref_names), 'XTickLabel',SW_ref_labels,'FontSize',12) ; box on ;
        ylim([-5 120]) ;
        title(['Type ' num2str(obs_type)]) ;
        
    end
    
end
        
        
      % Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves (NREM)','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave Types Co-occurrence' newline 'coccurdelay1 = ' num2str(cooccur_delay1) 'ms, coccurdelay2 = '  num2str(cooccur_delay2) 'ms'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
sgtitle(['Mean Rebound Detection (N = ' num2str(n_mice) ' mice)']) ; 

% % Save : 
% print(['ParcourSlowWaveReboundDetectionPlot_MiceMeanPlot2'], '-dpng', '-r300') ; 
% print(['epsFigures/ParcourSlowWaveReboundDetectionPlot_MiceMeanPlot2'], '-depsc') ; 




        
%% ----------------------------------------- MEAN PLOT for all sessions : across mice, 1 cooccurrence delay ----------------------------------------- :


% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 


% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 
 
% For each structure : 

for k = 1:length(struct_names) 
    
    eval(['struct = ' struct_names{k} ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
            eval(['data = cell2mat(struct.' fieldnames{field} ') ;'])
            
        for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
        end 

        eval(['Mice' struct_names{k} '.' fieldnames{field} ' = mice_data;']) 
            
    end
end


% ------------------------------- Mean Plot ------------------------------- :

% One subplot for each 'observed' SW type :

figure,

for obs_type = 1:length(struct_names) 

    subplot(3,3,subplots_order(obs_type)),
    eval(['struct = MiceSlowWaves' num2str(obs_type) ';']) ; 
    
    % Bar Plot : 
    for ref_type = 1:length(SW_ref_names)
        
    % Barplot : 
        hold on,

        eval(['co_prop2 = struct.CooccurProp2_' SW_ref_names{ref_type} ';']) ;

         % 2nd bar : 
        b = bar(ref_type,nanmean(cell2mat(co_prop2)),'LineStyle','none') ;
        b.BarWidth = 0.8 ;
        b.FaceColor = SW_ref_colors{ref_type} ; 
        b.FaceAlpha = plot_opacity ;
        text(ref_type,nanmean(cell2mat(co_prop2)) + 10,[sprintf('%.2g',nanmean(cell2mat(co_prop2))) ' %'],'HorizontalAlignment','center','FontSize',11,'Color',SW_ref_colors{ref_type}) ; 
        sem = nanstd(cell2mat(co_prop2)) / length(cell2mat(co_prop2)) ; 
        errorbar(ref_type,nanmean(cell2mat(co_prop2)),sem,sem,'Color',[0 0 0], 'LineStyle','none') ; 
        
        set(gca,'Xtick',1:length(SW_ref_names), 'XTickLabel',SW_ref_labels,'FontSize',12) ; box on ;
        ylim([-5 120]) ;
        title(['Type ' num2str(obs_type)]) ;
        
    end
    
end
        
        
      % Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves (NREM)','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Slow Wave Types Co-occurrence' newline 'coccur delay = '  num2str(cooccur_delay2) 'ms'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.4,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.25,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',15,'HorizontalALignment','center'), axis off
text(0.5,0.1,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',15,'HorizontalALignment','center'), axis off
sgtitle(['Mean Rebound Detection (N = ' num2str(n_mice) ' mice)']) ; 


% % Save : 
% print(['ParcourSlowWaveReboundDetectionPlot_MiceMeanPlot1'], '-dpng', '-r300') ; 
% print(['epsFigures/ParcourSlowWaveReboundDetectionPlot_MiceMeanPlot1'], '-depsc') ;    
        
                
