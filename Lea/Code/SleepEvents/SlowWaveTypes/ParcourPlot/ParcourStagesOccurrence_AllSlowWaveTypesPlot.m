%% ParcourStagesOccurrence_AllSlowWaveTypesPlot
% 
% 27/05/2020  LP
%
% Script to plot stage occurence + associated LFP profiles and down states crosscorr/co-occurrence, 
% for all slow wave types.
% -> from structures extracted by :
% 'ParcourStagesOccurrence_AllSlowWaveTypes'
%
% -> All plots + Mean Plot across sessions + Mean Plot across mice


clear


% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/SlowWaveTypes/'])
end

load('ParcourStagesOccurrence_AllSlowWaveTypes.mat')  ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourStagesOccurrence_AllSlowWaveTypesPlots')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/SlowWaveTypes/ParcourStagesOccurrence_AllSlowWaveTypesPlots'])
end


% ----------------------------------------- PLOTTING INFO ----------------------------------------- :

% For 3 separate plots : 
events1 = {SlowWaves3,SlowWaves6,SlowWaves4,DownStates} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 
events2 = {SlowWaves2,SlowWaves5,SlowWaves1,DownStates} ; 
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 
events3 = {SlowWaves7,SlowWaves8,DiffDelta,DownStates} ; 
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 

% Plot organization & info : 
allplots_data = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;
stages_names = {'Wake', 'NREM', 'REM'} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;


%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :


%  -------------------- PLOTS --------------------- : 

% Choose sessions to be plotted :
ToPlot = 1:length(Info_res.path) ; % Plot all sessions
% ToPlot = [1] ; % Choose sessions to plot


for p = ToPlot
 
    % FOR EACH FIGURE : 

    for f = 1:length(allplots_data) % for each group of events (1 figure)
    
        events_data = allplots_data{f} ; 
        events_names = allplots_names{f} ; 


        figure,
        sgtitle(['Slow Wave Types : Stages Occurrence ' num2str(f) ', Plot ' num2str(p) ' - ' Info_res.name{p}])

        for q = 1:length(events_data) % for each event type 
        
            addlegend = [] ; 
            
            % --- Plots --- : 
            
            event_struct_allstages = events_data{q} ; % structure with data for this type of events (all stages)
            
            for k = 1:length(stages_names) % for each stage 
            
                eval(['event_struct = event_struct_allstages.' stages_names{k} ';']) % structure with data for this type of events & this stage
                
                % Stage Occurrence - barplot : 
                subplot(5,4,q),
                title(events_names{q},'FontSize',12)
                hold on,
                bar(k,event_struct.stage_prop{p},'LineStyle','none','FaceColor',stages_colors{k}) ;
                text(k,event_struct.stage_prop{p} + 8,[sprintf(' %.3g',event_struct.stage_prop{p}) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ;
                ylim([0 120]) ; set(gca,'XTick',[1 2 3],'XTickLabel',stages_names) ; 

                % LFP profile : 
                subplot(5,4,4*k + q),
                hold on,
                plot(event_struct.LFP_t{p},event_struct.LFPdeep{p},'Color',LFP_colors{1},'LineWidth',2) ; 
                plot(event_struct.LFP_t{p},event_struct.LFPsup{p},'Color',LFP_colors{2},'LineWidth',2) ;
                xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
                ylim([-2200 2200]) ; title([stages_names{k} sprintf('  (%.2g events)',event_struct.nb_events{p})],'Color',stages_colors{k}) ; 
                xlabel(['time from event peak (ms)' newline '']) ; ylabel('mean LFP') ; 
                legend({'PFCdeep','PFCsup'},'Location','northeast') ;
            
                % Down State CrossCorr (only if enough events, >50) :
                if event_struct.nb_events{p} > 50 
                    subplot(5,4,4*4 + q),
                    hold on, 
                    h(k) = area(event_struct.DownCrossCorr_t{p},event_struct.DownCrossCorr{p},'FaceColor',stages_colors{k},'EdgeColor',stages_colors{k},'FaceAlpha',0.4) ;
                    text(-450,15-2*k,[sprintf('%.2g',event_struct.DownCooccurProp{p}*100) '%'],'Color',stages_colors{k}) ; 
                    
                    xlabel(['time from event peak (ms)']) ; ylabel('Correlation index') ;
                    title(['Cross-Correlogram with Down States']) ; 
                    addlegend = [addlegend k] ;
                    legend({stages_names{addlegend}}) ; legend boxoff ; 
                    ylim([0 18]) ;
                end
                
            end
            
            subplot(5,4,4*4 + q),
            hold on, 
            text(-450,15,['% of cooc. SW : ' sprintf('%.2g',event_struct_allstages.all.DownCooccurProp{p}*100) '%']) ; % add cooccurrence with events of this type for all stages
            try uistack(h(1),'top'); end
            
        end
         
        print(['AllSessions/ParcourStagesOccurrence_AllSlowWaveTypesPlot' num2str(p) '_' Info_res.name{p} '_' num2str(f)], '-dpng', '-r300') ; 
        print(['epsFigures/ParcourStagesOccurrence_AllSlowWaveTypesPlot' num2str(p) '_' Info_res.name{p} '_' num2str(f)], '-depsc') ; 
        close(gcf)
        
    end
    
    
end


  
%% ----------------------------------------- MEAN PLOT for all sessions : across mice ----------------------------------------- :

% ie. after averaging across sessions for a same mice
n_mice = length(unique(Info_res.name)) ; 

% ------------------------------- Get mice-averaged structures ------------------------------- :

[mice_list, ~, ix] = unique(Info_res.name) ; 
 
all_struct_names = {'SlowWaves1','SlowWaves2','SlowWaves3','SlowWaves4','SlowWaves5','SlowWaves6','SlowWaves7','SlowWaves8','DiffDelta','DownStates'} ; 

% For each structure : 

for type = 1:length(all_struct_names) 
    
    eval(['struct = ' all_struct_names{type} ';']) ; 
    fieldnames = fields(struct) ;
    
    for field = 1:length(fieldnames)
        eval(['struct2 = struct.' fieldnames{field} ';'])
        fieldnames2 = fields(struct2) ;
        
        for field2 = 1:length(fieldnames2)
            eval(['data = cell2mat(struct2.' fieldnames2{field2} ') ;'])
            
            for m = 1:length(mice_list) 
                mice_data{m} = nanmean(data(:,ix==m),2) ; 
            end 

            eval(['Mice' all_struct_names{type} '.' fieldnames{field} '.' fieldnames2{field2} ' = mice_data;']) 
            
        end
    end
end

% ----------------------------------------- PLOTTING INFO ----------------------------------------- :

% For 3 separate plots : 
events1 = {MiceSlowWaves3,MiceSlowWaves6,MiceSlowWaves4,MiceDownStates} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 
events2 = {MiceSlowWaves2,MiceSlowWaves5,MiceSlowWaves1,MiceDownStates} ; 
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 
events3 = {MiceSlowWaves7,MiceSlowWaves8,MiceDiffDelta,MiceDownStates} ; 
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 

% Plot organization & info : 
allplots_data = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;
LFP_colors = {[0 0.25 0.65],[0.25 0.7 0.9],[1 0.7 0.1]} ; 
LFP_legend = {'PFCx deep','PFCx sup','OB deep'} ;
stages_names = {'Wake', 'NREM', 'REM'} ;
stages_colors = {[0.4 0.7 0.15],[0.1 0.5 0.7],[0.6 0.2 0.6]} ;



% ------------------------------- Mean Plots ------------------------------- :

% FOR EACH FIGURE : 


for f = 1:length(allplots_data) % for each group of events (1 figure)

    events_data = allplots_data{f} ; 
    events_names = allplots_names{f} ; 


    figure,
    sgtitle(['Slow Wave Types : Stages Occurrence ' num2str(f) ', Mean Plot across mice (N = ' num2str(n_mice) ')'])

    for q = 1:length(events_data) % for each event type 

        addlegend = [] ; 

        % --- Plots --- : 

        event_struct_allstages = events_data{q} ; % structure with data for this type of events (all stages)

        for k = 1:length(stages_names) % for each stage 

            eval(['event_struct = event_struct_allstages.' stages_names{k} ';']) % structure with data for this type of events & this stage

            % Stage Occurrence - barplot : 
            subplot(5,4,q),
            title(events_names{q},'FontSize',12)
            hold on,
            mean_prop = mean(cell2mat(event_struct.stage_prop)) ; 
            sem = std(cell2mat(event_struct.stage_prop)) / sqrt(n_mice) ; 
            bar(k,mean_prop,'LineStyle','none','FaceColor',stages_colors{k}) ;
            errorbar(k,mean_prop,sem,sem,'Color',[0 0 0], 'LineStyle','none') ;
            text(k,mean_prop + sem + 8,[sprintf(' %.3g',mean_prop) ' %'],'Color',stages_colors{k},'HorizontalAlignment','center','FontSize',11) ;
            ylim([0 120]) ; set(gca,'XTick',[1 2 3],'XTickLabel',stages_names) ; 

            % LFP profile : 
            subplot(5,4,4*k + q),
            hold on,
            mean_PFCdeep = mean(cell2mat(event_struct.LFPdeep),2);
            mean_PFCsup = mean(cell2mat(event_struct.LFPsup),2);
            mean_ob = mean(cell2mat(event_struct.LFPob),2);
            plot(event_struct.LFP_t{1},mean_PFCdeep,'Color',LFP_colors{1},'LineWidth',2) ; 
            plot(event_struct.LFP_t{1},mean_PFCsup,'Color',LFP_colors{2},'LineWidth',2) ; 
            plot(event_struct.LFP_t{1},mean_ob,'Color',LFP_colors{3},'LineWidth',1.2) ;
            xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
            xticks([-500 -250 0 250 500]) ; 
            ylim([-2200 2400]) ; title([stages_names{k} sprintf('  (%.2g events)',mean(cell2mat(event_struct.nb_events)))],'Color',stages_colors{k}) ; 
            xlabel(['time from event peak (ms)' newline '']) ; ylabel('mean LFP') ; 
            legend({'PFCdeep','PFCsup','OB'},'Location','northeast') ;

            % Down State CrossCorr (only if enough events, >10) :
            if mean(cell2mat(event_struct.nb_events)) > 10 
                subplot(5,4,4*4 + q),
                hold on, 
                mean_crosscorr = mean(cell2mat(event_struct.DownCrossCorr),2);
                sem_crosscorr = std(cell2mat(event_struct.DownCrossCorr)')/sqrt(n_mice) ; 
                mean_cooccur_prop = mean(cell2mat(event_struct.DownCooccurProp)) ; 
                
                h(k) = area(event_struct.DownCrossCorr_t{1},mean_crosscorr,'FaceColor',stages_colors{k},'EdgeColor',stages_colors{k},'FaceAlpha',0.4) ;
                plot(event_struct.DownCrossCorr_t{1},mean_crosscorr'+sem_crosscorr,'--','Color',stages_colors{k},'LineWidth',0.5,'HandleVisibility','off') ;
                text(-450,15-2*k,[sprintf('%.2g',mean_cooccur_prop*100) '%'],'Color',stages_colors{k}) ; 
                xline(0,'--','Color',[0.3 0.3 0.3],'HandleVisibility','off') ;
                
                xticks([-500 -250 0 250 500]) ; 
                xlabel(['time from event peak (ms)']) ; ylabel('Correlation index') ;
                title(['Cross-Correlogram with Down States']) ; 
                addlegend = [addlegend k] ;
                legend({stages_names{addlegend}}) ; legend boxoff ; 
                ylim([0 18]) ;
            end

        end

        subplot(5,4,4*4 + q),
        hold on, 
        mean_cooccur_prop = mean(cell2mat(event_struct_allstages.all.DownCooccurProp)) ;
        text(-450,15,['% of cooc. SW : ' sprintf('%.2g',mean_cooccur_prop*100) '%']) ; % add cooccurrence with events of this type for all stages
        try uistack(h(1),'top'); end

    end

    print(['ParcourStagesOccurrence_AllSlowWaveTypesPlot_MiceMeanPlot_' num2str(f)], '-dpng', '-r300') ; 
    print(['epsFigures/ParcourStagesOccurrence_AllSlowWaveTypesPlot_MiceMeanPlot_' num2str(f)], '-depsc') ; 
    %close(gcf)

end





