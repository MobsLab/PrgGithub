
%% ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypesPlot
%
% 30/05/2020 LP
%
% Plot homeostasis on event density for each session + mean of all sessions. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event density (delta, slow waves, down states). 
%
% -> global fit and 2 fits (first 3 hours vs. rest of the session) 
%


clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 

events_subset = 'notnexttodown' ; 
% 'all' (keep all events), 'downcooccur' (only events co-occuring with down states) or 'notdowncooccur' (only events NOT co-occuring with down states) 
% 'nexttodown' (only events co-occuring < 300ms from down state middle) or 'notnexttodown' (only events not co-occuring < 300ms from down state middle)


% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end


description  = events_subset ; 
if afterREM1
    description = [description '_afterREM1'] ; 
end


eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_first' num2str(firstfit_duration) 'h_' description '.mat']) ; 

if afterREM1
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/AfterREM1')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/AfterREM1'])
    end
else 
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeSession')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeSession'])
    end
end


%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;
Cooccur_colors = {[0 0.4 0.6],[0 0.5 0.5]} ; 


% -------------- All Events -------------- : 

% For 3 separate plots : 
events1 = {Homeo_res.SlowWaves3,Homeo_res.SlowWaves6,Homeo_res.SlowWaves4,Homeo_res.DownStates} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 

events2 = {Homeo_res.SlowWaves2,Homeo_res.SlowWaves5,Homeo_res.SlowWaves1,Homeo_res.DownStates} ;
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 

events3 = {Homeo_res.SlowWaves7,Homeo_res.SlowWaves8,Homeo_res.DiffDeltaWaves,Homeo_res.DownStates} ;
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 


%  -------------- Plot organization -------------- : 

allplots_data = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif



%  -------------------- PLOTS --------------------- : 

% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot


for p = ToPlot
    
    
    % FOR EACH FIGURE : 

    for f = 1:length(allplots_data) 
    
        events_data = allplots_data{f} ; 
        events_names = allplots_names{f} ; 


        figure,

        % ------------------ One subplot for each quantif ------------------ :   

        for q = 1:length(events_names) 

            % Extract variables
            Homeo = events_data{q} ;
            all_fields = fieldnames(Homeo) ;
            for i = 1:length(all_fields)
                field = all_fields{i} ;
                eval([field '= Homeo.' field '{p} ;'])
            end


             % ------ Plot Event Occupancy & Homeostasis ------ :             

            subplot(4,6,events_subplot_start{q}+[1 2 7 8]),

            hold on,
            plot(time,data)

            % Plot local maxima :
            t_max = time(idx_localmax); d_max = data(idx_localmax) ;
            plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2}),
            % Plot global fit : 
            y_fit = polyval(reg_coeff, t_max) ; 
            l = plot(t_max,y_fit,'-','Color', fit_colors{1}) ;


            % 2 FITS :

            % to store all fit plot handles and legends :
            fitplots = [l] ;
            fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,reg_coeff(1)])};
            all_slope = [reg_coeff(1)] ;

           % for each fit :
            for i=1:length(twofitR2) 
                reg_coeff_fit = twofitreg_coeff{i} ;
                idx_fit = twofitidx_localmax{i} ;
                if ~isempty(idx_fit)
                    y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                    l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;

                    % Save regression info :
                    all_slope(end+1) = reg_coeff_fit(1) ; 
                    fitplots(end+1) = l ; % save fit plot handle for legend
                    fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e', [i,twofitR2{i},reg_coeff_fit(1)]) ;
                end
            end

            % Legend :
            title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's, ' sprintf('%.3e',nb_events) ' events)'],'FontSize',12) ;
            xlabel('ZT Time (hours)') ; ylabel('Normalized Event Density') ;
            legend(fitplots,fitlegend,'FontSize',11) ; 
            ylim([0 320]) ; 


        % ------ Plot LFP around Events ------ : 

            subplot(4,6,events_subplot_start{q}+3)

            % time 0 = start of events 
            hold on, plot(LFPt,meanLFPsup,'Color',LFP_colors{1}), plot(LFPt,meanLFPdeep,'Color',LFP_colors{2}), plot(LFPt,meanLFPOB,'Color',LFP_colors{3}) ;
            legend({'Sup PFC','Deep PFC','OB'},'Orientation','vertical','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;
            ylim([-2200 2200]) ; 
            xline(0,'--','Color',[0.4 0.4 0.4],'HandleVisibility','off') ; 

        % ------ Plot Co-occurence with down states ------ : 
            subplot(4,6,events_subplot_start{q}+9),
            hold on,
            bar(1,DownCooccurProp,'LineStyle','none','FaceColor',Cooccur_colors{1});
            ylim([0 115]), ylabel('% of events');
            text(1, 7 + DownCooccurProp, [sprintf('%.3g',DownCooccurProp) '%'],'HorizontalAlignment','center')
            set(gca,'XtickLabels',''); xlabel('Down State Co-occurrence') ; 

        end     

        % Save Plot :  
%         sgtitle(['Plot ' num2str(p) ' - ' Homeo_res.name{p} ]);
%         print(['AllSessions/ParcourQuantif2FitHomeostasisDensityPlot' num2str(p) '_' Homeo_res.name{p} '_' num2str(f)], '-dpng', '-r300') ; 
%         print(['epsFigures/ParcourQuantif2FitHomeostasisDensityPlot' num2str(p) '_' Homeo_res.name{p} '_' num2str(f)], '-depsc') ; 
%         close(gcf)
        
    end        

end

  
%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;
Cooccur_colors = {[0 0.4 0.6],[0 0.5 0.5]} ; 


% -------------- All Events -------------- : 

% For 3 separate plots : 
events1 = {Homeo_res.SlowWaves3,Homeo_res.SlowWaves6,Homeo_res.SlowWaves4,Homeo_res.DownStates} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 

events2 = {Homeo_res.SlowWaves2,Homeo_res.SlowWaves5,Homeo_res.SlowWaves1,Homeo_res.DownStates} ;
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 

events3 = {Homeo_res.SlowWaves7,Homeo_res.SlowWaves8,Homeo_res.DiffDeltaWaves,Homeo_res.DownStates} ;
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 


%  -------------- Plot organization -------------- : 

allplots_data = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif



% FOR EACH FIGURE : 

for f = 1:length(allplots_data) 

    events_data = allplots_data{f} ; 
    events_names = allplots_names{f} ; 


    figure,

        % ------------------ One subplot for each quantif ------------------ :   


    for q = 1:length(events_names) 

        Homeo = events_data{q} ;

        % ------ Plot Event Density Homeostasis (all) ------ :

        subplot(4,6,events_subplot_start{q}+[1 2 7 8]),
        hold on,

        for p=ToPlot

            % Extract variables
            time = Homeo.time{p} ;
            data = Homeo.data{p} ;
            idx_localmax = Homeo.idx_localmax{p} ;
            reg_coeff = Homeo.reg_coeff{p} ;

            t_max = time(idx_localmax); d_max = data(idx_localmax) ;
            y_fit = polyval(reg_coeff, t_max) ;
            d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); % grey dots for all local maxima from all sessions
            l = plot(t_max,y_fit,'-','Color', fit_colors{2},'LineWidth',2) ; % lines for global fits from all sessions
            uistack(d,'bottom'); % put dots in bakground
        end

        xlabel('Time (hours)'), ylabel('Normalized Event Density');
        title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's)'],'FontSize',12) ;
        mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
        legend([d,l],{'Density Local Maxima (all)', 
            [sprintf('Linear Regression, mean R2 = %.2f', nanmean([Homeo.R2{ToPlot}])) newline sprintf('Mean Slope = %.3e', mean_reg_coeff(1))] },'FontSize',11)  % mean R2 value
        ylim([30 280]) 


        % ------ Plot mean LFP around Events ------ : 

        subplot(4,6,events_subplot_start{q}+3)

        allmean_LFPdeep = mean([Homeo.meanLFPdeep{ToPlot}],2) ;    
        allmean_LFPsup = mean([Homeo.meanLFPsup{ToPlot}],2) ;  
        allmean_LFPOB = mean([Homeo.meanLFPOB{ToPlot}],2) ;  
        hold on, plot(Homeo.LFPt{1},allmean_LFPsup,'Color',LFP_colors{1}), plot(Homeo.LFPt{1},allmean_LFPdeep,'Color',LFP_colors{2}), plot(Homeo.LFPt{1},allmean_LFPOB,'Color',LFP_colors{3})
        xline(0,'--','Color',[0.3,0.3,0.3],'HandleVisibility','off') ;
        legend({'Sup PFC','Deep PFC','OB'},'Orientation','vertical','Location','northoutside'); legend boxoff; xlabel('Time around event (ms)'); ylabel('Mean LFP signal') ;
        ylim([-2200 2200]) ; 

        % ------ Get Co-occurence with down states ------ : 

        subplot(4,6,events_subplot_start{q}+9)

        all_DownCooccurProp = [Homeo.DownCooccurProp{ToPlot}] ;
        sem = std(all_DownCooccurProp)/sqrt(length(all_DownCooccurProp));
        
        hold on,
        bar(1,mean(all_DownCooccurProp),'LineStyle','none','FaceColor',Cooccur_colors{1});
        errorbar(1,mean(all_DownCooccurProp),sem,sem,'Color',[0 0 0], 'LineStyle','none') ;  

        ylim([0 120]), xlim([0 2]), ylabel('Proportion of events');
        text(1, 10 + mean(all_DownCooccurProp) + sem , [sprintf('%.3d',mean(all_DownCooccurProp)) '%'],'HorizontalAlignment','center')
        set(gca,'XtickLabels',''); xlabel('Down State Co-occurrence') ; 


    end         


    % Save Plot : 

%     sgtitle(['Mean homeostasis plot across sessions (n = ' num2str(length(Homeo_res.path)) ')']);
%     print(['ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_MeanPlot_' num2str(f)], '-dpng', '-r300') ; 
%     print(['epsFigures/ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_MeanPlot_' num2str(f)], '-depsc') ; 
%     close(gcf)        
        
end


    %% ----------------------------------------- MEAN PLOT for all sessions : TWO FITS ----------------------------------------- :



% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;
Cooccur_colors = {[0 0.4 0.6],[0 0.5 0.5]} ; 


% -------------- All Events -------------- : 

% For 3 separate plots : 
events1 = {Homeo_res.SlowWaves3,Homeo_res.SlowWaves6,Homeo_res.SlowWaves4,Homeo_res.DownStates} ; 
events1_names = {'Slow Waves 3', 'Slow Waves 6', 'Slow Waves 4','Down States'} ; 

events2 = {Homeo_res.SlowWaves2,Homeo_res.SlowWaves5,Homeo_res.SlowWaves1,Homeo_res.DownStates} ;
events2_names = {'Slow Waves 2', 'Slow Waves 5', 'Slow Waves 1','Down States'} ; 

events3 = {Homeo_res.SlowWaves7,Homeo_res.SlowWaves8,Homeo_res.DiffDeltaWaves,Homeo_res.DownStates} ;
events3_names = {'Slow Waves 7', 'Slow Waves 8','Diff Delta Waves', 'Down States'} ; 


%  -------------- Plot organization -------------- : 

allplots_data = {events1,events2,events3} ;
allplots_names = {events1_names,events2_names,events3_names} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif



% FOR EACH FIGURE : 

for f = 1:length(allplots_data) 

    events_data = allplots_data{f} ; 
    events_names = allplots_names{f} ; 


    figure,


        % ------------------ One subplot for each quantif ------------------ :   


    for q = 1:length(events_names) 

        Homeo = events_data{q} ;
        all_slopes_1 = [] ; % to store slope values for 1st fits
        all_slopes_2 = [] ; % to store slope values for 2nd fits
        all_R2_1 = [] ; % idem for R2
        all_R2_2 = [] ; % idem for R2

        % ------ Plot Event Occupancy Homeostasis (all) ------ :

        subplot(4,6,events_subplot_start{q}+[1 2 7 8]),
        hold on,

        for p=ToPlot

            % Extract variables
            time = Homeo.time{p} ;
            data = Homeo.data{p} ;
            idx_localmax = Homeo.idx_localmax{p} ;
            twofitreg_coeff = Homeo.twofitreg_coeff{p} ;
            twofitidx_localmax = Homeo.twofitidx_localmax{p} ;
            twofit_R2 = (Homeo.twofitR2{p}) ; 

            % grey dots for all local maxima from all sessions :
            t_max = time(idx_localmax); d_max = data(idx_localmax) ;
            d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); % grey dots for all local maxima from all sessions
            uistack(d,'bottom'); % put dots in bakground

             % line for each fit :
            for i=1:length(twofitreg_coeff)  
                reg_coeff_fit = twofitreg_coeff{i} ;
                idx_fit = twofitidx_localmax{i} ;
                y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
                eval(['l' num2str(i) '= plot(t_max(idx_fit),y_fit,"-","Color", fit_colors{3-i},"LineWidth",2) ;']) % plot and store handle for the legend 
                eval(['all_slopes_' num2str(i) '(end+1) = reg_coeff_fit(1);']); % store slope values for the corresponding fit   
                eval(['all_R2_' num2str(i) '(end+1) = twofit_R2{i};']) % store slope values for the corresponding fit     
            end
                
        end

        xlabel('Time (hours)'), ylabel('Normalized Event Density');
        title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's)'],'FontSize',12) ;
        mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
        legend([d,l1,l2],{'Density Local Maxima',[sprintf('1st Fit : mean R2 = %.2f, Mean Slope = %.3e', nanmean(all_R2_1),nanmean(all_slopes_1))], [sprintf('2nd Fit : mean R2 = %.2f, Mean Slope = %.3e', nanmean(all_R2_2),nanmean(all_slopes_2))]},'FontSize',11)  % mean R2diff value
        ylim([30 280]) ; 


        % ------ Plot mean LFP around Events ------ : 

        subplot(4,6,events_subplot_start{q}+3)

        allmean_LFPdeep = mean([Homeo.meanLFPdeep{ToPlot}],2) ;    
        allmean_LFPsup = mean([Homeo.meanLFPsup{ToPlot}],2) ;  
        allmean_LFPOB = mean([Homeo.meanLFPOB{ToPlot}],2) ;  
        xline(0,'--','Color',[0.3,0.3,0.3],'HandleVisibility','off') ;
        hold on, plot(Homeo.LFPt{1},allmean_LFPsup,'Color',LFP_colors{1}), plot(Homeo.LFPt{1},allmean_LFPdeep,'Color',LFP_colors{2}), plot(Homeo.LFPt{1},allmean_LFPOB,'Color',LFP_colors{3})
        legend({'Sup PFC','Deep PFC','OB'},'Orientation','vertical','Location','northoutside'); legend boxoff; xlabel('Time around event (ms)'); ylabel('Mean LFP signal') ;
        ylim([-1900 2200]) ; 

        % ------ Get Co-occurence with down states ------ : 

        subplot(4,6,events_subplot_start{q}+9)

        all_DownCooccurProp = [Homeo.DownCooccurProp{ToPlot}] ;
        sem = std(all_DownCooccurProp)/sqrt(length(all_DownCooccurProp));
        
        hold on,
        bar(1,mean(all_DownCooccurProp),'LineStyle','none','FaceColor',Cooccur_colors{1});
        errorbar(1,mean(all_DownCooccurProp),sem,sem,'Color',[0 0 0], 'LineStyle','none') ;  

        ylim([0 120]), xlim([0 2]), ylabel('Proportion of events');
        text(1, 10 + mean(all_DownCooccurProp) + sem , [sprintf('%.3d',mean(all_DownCooccurProp)) '%'],'HorizontalAlignment','center')
        set(gca,'XtickLabels',''); xlabel('Down State Co-occurrence') ; 

    end         


        % Save Plot :   
%     sgtitle(['Mean 2 fits homeostasis plot across sessions (n = ' num2str(length(Homeo_res.path)) ')']);
%     print(['ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_2fitMeanPlot_' num2str(f)], '-dpng', '-r300') ; 
%     print(['epsFigures/ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_2fitMeanPlot_' num2str(f)], '-depsc') ; 
%     close(gcf)  

end
