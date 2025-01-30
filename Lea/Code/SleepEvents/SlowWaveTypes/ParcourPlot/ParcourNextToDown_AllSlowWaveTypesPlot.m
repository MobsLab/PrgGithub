
%% ParcourNextToDown_AllSlowWaveTypesPlot
% 
% 06/06/2020  LP
%
% Script to plot proportion of slow waves next to a down state,  for all slow wave types. 
% -> Mean plot across mice 


clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourNextToDown_AllSlowWaveTypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourNextToDown_AllSlowWaveTypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourNextToDown_AllSlowWaveTypesPlots'])
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


% ------------------------------- Mean Plot ------------------------------- :


figure,

% Plot All Types : 

for type = 1:length(struct_names) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    hold on,
    
    eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
    
    % Get mean values of co-occurrence : 
    DownCooccurProp1 = mean(cell2mat(struct.DownCooccurProp1)) ; 
    DownCooccurProp2 = mean(cell2mat(struct.DownCooccurProp2)) ;
    
    % Get sem : 
    DownCooccurProp1sem = std(cell2mat(struct.DownCooccurProp1))/sqrt(n_mice) ;
    DownCooccurProp2sem = std(cell2mat(struct.DownCooccurProp2))/sqrt(n_mice) ;
    
    % --- Bar plots --- :
    
    % Proportion of SW :
    bar(1,DownCooccurProp1,'LineStyle','none','FaceColor',bar_colors{1}) ;
    errorbar(1,DownCooccurProp1,DownCooccurProp1sem,DownCooccurProp1sem,'Color',[0 0 0], 'LineStyle','none') ;
    text(1,DownCooccurProp1 + DownCooccurProp1sem + 10,[sprintf(' %.3g',DownCooccurProp1) ' %'],'Color',bar_colors{1},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Proportion of Down States :
    bar(2,DownCooccurProp2,'LineStyle','none','FaceColor',bar_colors{2}) ;
    errorbar(2,DownCooccurProp2,DownCooccurProp2sem,DownCooccurProp2sem,'Color',[0 0 0], 'LineStyle','none') ;
    text(2,DownCooccurProp2 + DownCooccurProp2sem + 10 ,[sprintf(' %.3g',DownCooccurProp2) ' %'],'Color',bar_colors{2},'HorizontalAlignment','center','FontSize',11) ; 
    
    % Labels and appearance
    ylim([0 110]) ; 
    cooccur_delay1 = struct.cooccur_delay1{1} ;
    cooccur_delay2 = struct.cooccur_delay2{1} ;
    set(gca,'Xtick',1:2, 'XTickLabel',{[num2str(cooccur_delay1)],[num2str(cooccur_delay2)]},'FontSize',12) ; box on ; 
    ylabel(['% of SW next to a down state']) ; xlabel('detection delay (ms)')
    title(['Slow Waves Type ' num2str(type)]) ; 
   
end
   
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.9,['2-Channel Slow Waves' newline 'NREM only'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Mean Slow Wave - Down State' newline 'Co-occurrence' newline '(N = ' num2str(n_mice) ' mice)'],'FontSize',14,'HorizontalAlignment','center'), axis off
text(0.5,0.35,sprintf('Filter Freq : %g - %g Hz',detection_parameters.filterfreq(1),detection_parameters.filterfreq(2)),'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.28,['Detection Threshold : ' detection_parameters.detectionthresh],'FontSize',10,'HorizontalALignment','center'), axis off
text(0.5,0.21,['Sup/Deep Co-occurrence Delay : ' num2str(detection_parameters.cooccur_delay) ' ms'],'FontSize',10,'HorizontalALignment','center'), axis off

%Save : 
print(['ParcourNextToDown_AllSlowWaveTypesPlot_MiceMeanPlot'], '-dpng', '-r300') ; 
print(['epsFigures/ParcourNextToDown_AllSlowWaveTypesPlot_MiceMeanPlot'], '-depsc') ; 


    


