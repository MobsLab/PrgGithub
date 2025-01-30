
clear

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourDownCooccur_AllSlowWaveTypes.mat')  ; 
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 



all_colors = {[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 



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






% --- NREM ONLY --- :

figure,

for type = 1:length(struct_names) 

    hold on,
    
    eval(['struct = MiceSlowWaves' num2str(type) ';']) ; 
    
    % Get mean values of co-occurrence : 
    sw_codown_prop = mean(cell2mat(struct.NREMsw_codown_prop)) ; 
    down_cosw_prop = mean(cell2mat(struct.NREMdown_cosw_prop)) ;
    
    % Get sem : 
    sw_codown_propsem = std(cell2mat(struct.NREMsw_codown_prop))/sqrt(n_mice) ;
    down_cosw_propsem = std(cell2mat(struct.NREMdown_cosw_prop))/sqrt(n_mice) ;
    
    
    % BARPLOT with % of SW: 
    
    bar(type,sw_codown_prop,'LineStyle','none','FaceColor',all_colors{type},'FaceAlpha',0.7) ;
    % bar(type,100,'EdgeColor',all_colors{type},'FaceAlpha',0) ;
    errorbar(type,sw_codown_prop,sw_codown_propsem,sw_codown_propsem,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;
    text(type,sw_codown_prop + sw_codown_propsem + 5,[sprintf(' %.3g',sw_codown_prop) ' %'],'Color',all_colors{type},'HorizontalAlignment','center','FontSize',12) ; 
    
        % Labels and appearance
    ylim([0 100]) ; yticks(0:25:100) ; 
    xticks(1:8);
    xlabel('Slow Wave Type') ; ylabel(['% of slow waves co-occurring' newline 'with a down state']) ; 
    set(gca,'FontSize',12) ; 
    legend({'SW1','SW2','SW3','SW4','SW5','SW6','SW7','SW8'},'Location','northeast') ; legend boxoff ;
     
    
    
end
  


% Save figure : 
set(gcf,'Position',[10 10 685 300])  
% print([PathToSave 'MiceMeanNREMDownCooccur'], '-dpng', '-r300') ;    
    
   
    
