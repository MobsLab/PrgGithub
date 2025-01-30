
%% ParcourDeltaCooccur_AllSlowWaveTypesPlot
% 
% 29/05/2020  LP
%
% Script to plot delta wave co-occurrence for all slow wave types, all sessions. 
% -> Cooccurrence Detection = when slow wave peak falls in delta wave interval ! 
% -> Plot all sessions + Mean plot across mice 


clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourDeltaCooccur_AllSlowWaveTypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDeltaCooccur_AllSlowWaveTypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourDeltaCooccur_AllSlowWaveTypesPlots'])
end


% PLOT INFO :
subplots_order = [1 3 7 9 2 8 4 6] ; 
bar_colors = {[0 0.35 0.65],[0.9 0.6 0]} ; 



%% ----------------------------------------- MEAN PLOT for all sessions : across mice ----------------------------------------- :

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


% ------------------------------- Mean Plots ------------------------------- :


% --- WHOLE SESSION --- :


figure,

% Plot All Types : 

for type = 1:length(struct_names) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    hold on,
    
    eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
    
    % Get mean values of co-occurrence : 
    sw_codelta_prop = mean(cell2mat(struct.allsw_codelta_prop)) ; 
    delta_cosw_prop = mean(cell2mat(struct.alldelta_cosw_prop)) ;
    
    % Get sem : 
    sw_codelta_propsem = std(cell2mat(struct.allsw_codelta_prop))/sqrt(n_mice) ;
    delta_cosw_propsem = std(cell2mat(struct.alldelta_cosw_prop))/sqrt(n_mice) ;
    
    % --- Bar plots --- :
    
    % Proportion of SW :
    bar(1,sw_codelta_prop,'LineStyle','none','FaceColor',bar_colors{1}) ;
    errorbar(1,sw_codelta_prop,sw_codelta_propsem,sw_codelta_propsem,'Color',[0 0 0], 'LineStyle','none') ;
    text(1,sw_codelta_prop + sw_codelta_propsem + 10,[sprintf(' %.3g',sw_codelta_prop) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Proportion of Down States :
    bar(2,delta_cosw_prop,'LineStyle','none','FaceColor',bar_colors{2}) ;
    errorbar(2,delta_cosw_prop,delta_cosw_propsem,delta_cosw_propsem,'Color',[0 0 0], 'LineStyle','none') ;
    text(2,delta_cosw_prop + delta_cosw_propsem + 10 ,[sprintf(' %.3g',delta_cosw_prop) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Labels and appearance
    ylim([0 110]) ; 
    set(gca,'Xtick',1:2, 'XTickLabel',{'% of SW','% of DW'},'FontSize',12) ; box on ; 
    ylabel(['% of each co-occurring' newline ' with the other one']) ;  
    title(['Slow Waves Type ' num2str(type)]) ; 
   
end
   
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Mean Slow Wave - Delta Wave' newline 'Co-occurrence' newline '(N = ' num2str(n_mice) ' mice)'],'FontSize',14,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.28,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.21,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',10,'HorizontalALignment','center'), axis off

% Save : 
print(['ParcourDeltaCooccur_AllSlowWaveTypesPlot_MiceMeanPlot'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourDeltaCooccur_AllSlowWaveTypesPlot_MiceMeanPlot'], '-depsc') ; 





% --- NREM ONLY --- :

figure,

for type = 1:length(struct_names) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    hold on,
    
    eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
    
    % Get mean values of co-occurrence : 
    sw_codelta_prop = mean(cell2mat(struct.NREMsw_codelta_prop)) ; 
    delta_cosw_prop = mean(cell2mat(struct.NREMdelta_cosw_prop)) ;
    
    % Get sem : 
    sw_codelta_propsem = std(cell2mat(struct.NREMsw_codelta_prop))/sqrt(n_mice) ;
    delta_cosw_propsem = std(cell2mat(struct.NREMdelta_cosw_prop))/sqrt(n_mice) ;
    
    % --- Bar plots --- :
    
    % Proportion of SW :
    bar(1,sw_codelta_prop,'LineStyle','none','FaceColor',bar_colors{1}) ;
    errorbar(1,sw_codelta_prop,sw_codelta_propsem,sw_codelta_propsem,'Color',[0 0 0], 'LineStyle','none') ;
    text(1,sw_codelta_prop + sw_codelta_propsem + 10,[sprintf(' %.3g',sw_codelta_prop) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Proportion of Down States :
    bar(2,delta_cosw_prop,'LineStyle','none','FaceColor',bar_colors{2}) ;
    errorbar(2,delta_cosw_prop,delta_cosw_propsem,delta_cosw_propsem,'Color',[0 0 0], 'LineStyle','none') ;
    text(2,delta_cosw_prop + delta_cosw_propsem + 10 ,[sprintf(' %.3g',delta_cosw_prop) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Labels and appearance
    ylim([0 110]) ; 
    set(gca,'Xtick',1:2, 'XTickLabel',{'% of SW','% of DW'},'FontSize',12) ; box on ; 
    ylabel(['% of each co-occurring' newline ' with the other one']) ;  
    title(['Slow Waves Type ' num2str(type)]) ; 
   
end
   
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.85,'2-Channel Slow Waves','FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Mean Slow Wave - Delta Wave' newline 'Co-occurrence, NREM only' newline '(N = ' num2str(n_mice) ' mice)'],'FontSize',14,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.28,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.21,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',10,'HorizontalALignment','center'), axis off

% Save : 
print(['ParcourDeltaCooccur_AllSlowWaveTypesPlot_MiceMeanPlot_NREM'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourDeltaCooccur_AllSlowWaveTypesPlot_MiceMeanPlot_NREM'], '-depsc') ; 


    



%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :

% Code to write
% See : QuantifDeltaCooccur_AllSlowWaveTypes