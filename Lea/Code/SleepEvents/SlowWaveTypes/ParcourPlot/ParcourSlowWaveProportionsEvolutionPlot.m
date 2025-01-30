%% ParcourSlowWaveProportionsEvolutionPlot
% 
% 23/06/2020  LP
%
% Script to plot proportions of SW types 3/4/6, for NREM,
% during begin / middle / end of each session (session divided in nb_periods = 3
% periods) + LFP begin vs end + MUA begin vs end
%
% -> mean across mice 
%
% SEE : 
% QuantifSlowWaveProportionsEvolution
% ParcourSlowWaveProportionsEvolution



clear
tosave = false ; % saves the plot if true

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourSlowWaveProportionsEvolution.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourSlowWaveProportionsEvolutionPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourSlowWaveProportionsEvolutionPlots'])
end

struct_names = {'SlowWaves3','SlowWaves4','SlowWaves6'} ;
all_names = {'SW3','SW4','SW6'} ; 
all_colors = {[1 0 0.4],[0.6 0.2 0.6],[0 0.6 0.4]} ; 

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


% --------------- Stacked Proportions Timecourse (areas) --------------- :

figure, 
subplot(3,2,1),

% Get event proportions :  
eval(['nb_periods = length(Mice' struct_names{1} '.prop_events{1});']) ; % nb of time points for timecourse
all_prop_events = repmat(NaN,nb_periods,length(struct_names)) ; % proportions for all types

for k = 1:length(struct_names) % get proportion for each type
    eval(['data = Mice' struct_names{k} '.prop_events ; ']) 
    mean_prop = nanmean(cell2mat(data),2) ; % mean proportion timecourse for this type
    all_prop_events(:,k) = mean_prop ; 
end

% Plot :
a = area(1:nb_periods, all_prop_events,'FaceAlpha',0.7,'EdgeColor',[1 1 1]) ; 
% change color
for k = 1:length(a)
    a(k).FaceColor = all_colors{k} ;
end 

legend(all_names,'Location','northoutside','Orientation','horizontal'); legend boxoff ; 
xlabel('Time period') ; ylabel('Stacked occurrence proportions') ; 
axis tight ; 
text(nb_periods*1/6,85,'BEGIN','HorizontalAlignment','center') ; 
text(nb_periods*5/6,85,'END','HorizontalAlignment','center') ; 

% Add dashed lines delimiting begin / middle / end
xline(nb_periods/3+0.5,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
xline(nb_periods*2/3+0.5,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;



% --------------- Barplot with variations of proportions between end and begin --------------- :

subplot(3,2,2),

% Barplot :
hold on,
for k = 1:length(struct_names) % for each type
    eval(['data = Mice' struct_names{k} '.prop_events_diff ; ']) 
    b=bar(k,nanmean(cell2mat(data)),'FaceColor',all_colors{k},'FaceAlpha',0.7,'LineStyle','none') ;
    sem = std(cell2mat(data)) / sqrt(length(data)) ; 
    errorbar(k,nanmean(cell2mat(data)),sem,sem,'Color',[0 0 0], 'LineStyle','none') ;
end 

% Legend and axes :
%ylim([-5,10]) ; 
xticks([]); box on ;
title('Proportion difference [end - begin]') 
ylabel('Proportion difference (% points)') 
set(b,'ShowBaseLine','off'); yline(0,'Color',[0.3 0.3 0.3],'HandleVisibility','off') ; % plot grey line at 0 instead of black line



% --------------- Overlayed LFP Profiles --------------- :

% One subplot for begin and end :
period_titles = {'begin period (1/3)','end period (3/3)'} ; 
per_name = {'begin', 'end'} ; 
% all_events_ts = cell with slowwaves ts for all periods, all sw types

for per = 1:2 % for begin and for end periods
    
    subplot(3,2,2+per),
    hold on,
    
    for k = 1:length(struct_names) % for each type
        
        eval(['LFPdeep = cell2mat(Mice' struct_names{k} '.LFPdeep_' per_name{per} ') ; '])
        eval(['LFPsup = cell2mat(Mice' struct_names{k} '.LFPsup_' per_name{per} ') ; '])
        eval(['LFPt = Mice' struct_names{k} '.LFPt{1} ; '])
        mean_LFPdeep = nanmean(LFPdeep,2);
        mean_LFPsup = nanmean(LFPsup,2);
        
        % Plot LFP profile :
        plot(LFPt,mean_LFPdeep/10,'Color',all_colors{k})
        plot(LFPt,mean_LFPsup/10,'--','Color',all_colors{k})
        xlabel('Time from slow wave peak (ms)'), ylabel('Mean LFP amplitude (microV)') ; 
        ylim([-160 230]) ; 
        
        title(['Mean LFP : ' period_titles{per}])
        
    end
    
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;

end
        
        
        

% --------------- Overlayed MUA Profiles --------------- :

% One subplot for begin and end :
period_titles = {'begin period (1/3)','end period (3/3)'} ; 
per_name = {'begin', 'end'} ; 
% all_events_ts = cell with slowwaves ts for all periods, all sw types

for per = 1:2 % for begin and for end periods
    
    subplot(3,2,4+per),
    hold on,
    
    for k = 1:length(struct_names) % for each type
        
        eval(['MUA = cell2mat(Mice' struct_names{k} '.MUA_' per_name{per} ') ; '])
        eval(['MUAt = Mice' struct_names{k} '.MUA_t{1} ; '])
        mean_MUA = nanmean(MUA,2);

        
        % Plot Firing Rate :
        %area(MUAt,mean_MUA,'FaceColor',all_colors{k},'LineStyle','-','FaceAlpha',0.3,'EdgeColor',all_colors{k})
        plot(MUAt,mean_MUA,'Color',all_colors{k},'LineWidth',1.5) ; 
        ylabel('Mean firing rate') ; xlabel('Time from slow wave peak (ms)') ;
        stdshade(MUA',0.2,all_colors{k},MUAt) ; % plot mean data +/- SEM (shaded area)
        
        title(['Mean MUA : ' period_titles{per}])
        
    end
    
    xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;

end
        
        

%Save : 
sgtitle(['Evolution of SW3/4/6, Mean across Mice (N =' num2str(n_mice) ')'])
if tosave
    print(['ParcourSlowWaveProportionsEvolutionPlot_MiceMeanPlot'], '-dpng', '-r300') ; 
    print(['epsFigures/ParcourSlowWaveProportionsEvolutionPlot_MiceMeanPlot'], '-depsc') ; 
end

        

