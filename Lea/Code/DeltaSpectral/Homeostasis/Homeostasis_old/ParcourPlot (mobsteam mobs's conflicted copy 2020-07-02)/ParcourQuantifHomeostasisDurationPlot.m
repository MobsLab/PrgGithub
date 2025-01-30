%% ParcourQuantifHomeostasisDurationPlot
%
% 23/04/2020 LP
%
% Plot homeostasis on event duration for each session + mean of all sessions. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event duration (delta, slow waves, down states). 
%
% -> Global fit on whole session or multiple fits on separate sleep episodes 
% (when wake duration > wake_thresh) 
%
% SEE : QuantifHomeostasisDuration ParcourQuantifHomeostasisDuration



clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

% Wake duration threshold for multifit (choose data file to be plotted) :
wake_thresh = 20 ;
afterREM1 = true ; 

% ----------------------------------------- LOAD DATA ----------------------------------------- :


try 
    if afterREM1
        eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisDuration_multifit' num2str(wake_thresh) '_afterREM1.mat']) % path if on lab computer
    else
        eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisDuration_multifit' num2str(wake_thresh) '.mat']) % path if on lab computer
    end    
    cd([FolderDataLP_DeltaSpectral 'Results/Homeostasis'])  
catch
    if afterREM1
        eval(['load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisDuration_multifit' num2str(wake_thresh) '_afterREM1.mat']) % if on personal computer
    else
        eval(['load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisDuration_multifit' num2str(wake_thresh) '.mat']) % if on personal computer
    end    
    cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis')
end   



  
%% ----------------------------------------- PLOT DATA separately for each session ----------------------------------------- :


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;

events_names = {'Delta Waves','Sup Slow Waves','Down States','Deep Slow Waves'} ;
events_data = {Homeo_res.DeltaWaves,Homeo_res.SupSlowWaves,Homeo_res.DownStates,Homeo_res.DeepSlowWaves} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

for p = ToPlot
    
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
        
        
         % ------ Plot Event Duration & Homeostasis ------ :             

        subplot(4,6,events_subplot_start{q}+[1 2 7 8]),

        hold on,
        plot(time,data)
        
        % Plot local maxima :
        t_max = time(idx_localmax); d_max = data(idx_localmax) ;
        plot(t_max,d_max,'.','MarkerSize',10,'Color', fit_colors{2}),
        % Plot global fit : 
        y_fit = polyval(reg_coeff, t_max) ; 
        l = plot(t_max,y_fit,'-','Color', fit_colors{1}) ;
        

        % MULTIPLE FITS :
        
        % to store all fit plot handles and legends :
        fitplots = [l] ;
        fitlegend = {sprintf('fit global, R2 = %.2f , S = %.2e ', [R2,reg_coeff(1)])};
        all_slope = [reg_coeff(1)] ;
        
       % for each fit :
        for i=1:length(multiR2) 
            reg_coeff_fit = multireg_coeff{i} ;
            idx_fit = multiidx_localmax{i} ;
            y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
            l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2}) ;

            % Save regression info :
            all_slope(end+1) = reg_coeff_fit(1) ; 
            fitplots(end+1) = l ; % save fit plot handle for legend
            fitlegend{end+1} = sprintf('fit %d, R2 = %.2f , S = %.2e, R2glob = %.2f', [i,multiR2{i},reg_coeff_fit(1),multiR2global{i}]) ;
        end
        
        % Legend :
        title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's, ' sprintf('%.3e',nb_events) ' events)'],'FontSize',12) ;
        xlabel('ZT Time (hours)') ; ylabel('Normalized Event Duration (% of mean NREM Duration)') ;
        legend(fitplots,fitlegend,'FontSize',11) ; 

        
        
    % ------ Plot LFP around Events ------ : 

        subplot(4,6,events_subplot_start{q}+3)

        % time 0 = start of events 
        hold on, plot(LFPt,meanLFPsup,'Color',LFP_colors{1}), plot(LFPt,meanLFPdeep,'Color',LFP_colors{2}), plot(LFPt,meanLFPOB,'Color',LFP_colors{3}) ;
        legend({'Sup PFC','Deep PFC','OB'},'Orientation','horizontal','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;

        
    % ------ Plot Co-occurence with down states ------ : 
        subplot(4,6,events_subplot_start{q}+9)
        bar(1,DownCooccurProp,'LineStyle','none'), ylim([0 1.15]), ylabel('Proportion of events'), text(1, 0.05 + DownCooccurProp, sprintf('%.3f',DownCooccurProp),'HorizontalAlignment','center')
        set(gca,'XtickLabels','Down State Co-occurrence'),legend(['Pre- & Post Timewindows = ',num2str(cooccur_delay),'ms'],'Orientation','horizontal','Location','northoutside')       
        
        
    end     
      
    % Save Plot :   
    saveas(gcf,['Duration/ParcourQuantifHomeostasisDurationPlot' num2str(p) '_' Homeo_res.name{p} '.png']) 
    saveas(gcf,['epsFigures/ParcourQuantifHomeostasisDurationPlot' num2str(p) '_' Homeo_res.name{p} '.eps'],'epsc')
    
end        
        


  
%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;

events_names = {'Delta Waves','Sup Slow Waves','Down States','Deep Slow Waves'} ;
events_data = {Homeo_res.DeltaWaves,Homeo_res.SupSlowWaves,Homeo_res.DownStates,Homeo_res.DeepSlowWaves} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot


figure,
    
    % ------------------ One subplot for each quantif ------------------ :   
  
    
for q = 1:length(events_names) 

    Homeo = events_data{q} ;

    % ------ Plot Event Duration Homeostasis (all) ------ :
    
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
    
    xlabel('Time (hours)'), ylabel('Normalized Event Duration (% of mean NREM Duration)');
    title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's)'],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l],{'Duration Local Maxima (all)', 
        [sprintf('Linear Regression, mean R2 = %.2f', nanmean([Homeo.R2{ToPlot}])) newline sprintf('Mean Slope = %.3e', mean_reg_coeff(1))] },'FontSize',11)  % mean R2 value
       
    
    
    % ------ Plot mean LFP around Events ------ : 

    subplot(4,6,events_subplot_start{q}+3)
    
    allmean_LFPdeep = mean([Homeo.meanLFPdeep{ToPlot}],2) ;    
    allmean_LFPsup = mean([Homeo.meanLFPsup{ToPlot}],2) ;  
    allmean_LFPOB = mean([Homeo.meanLFPOB{ToPlot}],2) ;  
    hold on, plot(Homeo.LFPt{1},allmean_LFPsup,'Color',LFP_colors{1}), plot(Homeo.LFPt{1},allmean_LFPdeep,'Color',LFP_colors{2}), plot(Homeo.LFPt{1},allmean_LFPOB,'Color',LFP_colors{3})
    legend({'Sup PFC','Deep PFC','OB'},'Orientation','horizontal','Location','northoutside'), xlabel('Time around event (ms)'), ylabel('Mean LFP signal') ;

    
    % ------ Get Co-occurence with down states ------ : 
    
    subplot(4,6,events_subplot_start{q}+9)
    
    all_DownCooccurProp = [Homeo.DownCooccurProp{ToPlot}] ;
    sem = std(all_DownCooccurProp)/sqrt(length(all_DownCooccurProp));
    b = bar(1,mean(all_DownCooccurProp),'LineStyle','none'), ylim([0 1.3]); ylabel('Proportion of events'), text(1, 0.1 + mean(all_DownCooccurProp) + sem , sprintf('%.3f',mean(all_DownCooccurProp)),'HorizontalAlignment','center')
    set(gca,'XtickLabels','Down State Co-occurrence');
    hold on, errorbar(1,mean(all_DownCooccurProp),sem,sem,'Color',[0 0 0], 'LineStyle','none') ;  
    legend(b,{['Pre- & Post Timewindows = ',num2str(cooccur_delay),'ms']},'Orientation','horizontal','Location','northoutside')       
    
end         
  

    % Save Plot :   
saveas(gcf,['Duration/ParcourQuantifHomeostasisDurationPlot_GlobalMean.png']) 
saveas(gcf,['epsFigures/ParcourQuantifHomeostasisDurationPlot_GlobalMean.eps'],'epsc')




  
%% ----------------------------------------- MEAN PLOT for all sessions : MULTIPLE FITS ----------------------------------------- :


fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
LFP_colors = {[0.25 0.7 0.9],[0 0.25 0.65],[1 0.7 0.1]} ;

events_names = {'Delta Waves','Sup Slow Waves','Down States','Deep Slow Waves'} ;
events_data = {Homeo_res.DeltaWaves,Homeo_res.SupSlowWaves,Homeo_res.DownStates,Homeo_res.DeepSlowWaves} ;
events_subplot_start = {0,3,12,15} ; % (1st subplot index -1), for each event quantif


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot


figure,
    
    % ------------------ One subplot for each quantif ------------------ :   
  
    
for q = 1:length(events_names) 

    Homeo = events_data{q} ;
    all_slopes = [] ; % to store slope values
    all_R2diff = [] ; % to store R2diff values (difference between R2 and R2global on each of the multiple fits)

    % ------ Plot Event Duration Homeostasis (all) ------ :
    
    subplot(4,6,events_subplot_start{q}+[1 2 7 8]),
    hold on,
 
    for p=ToPlot
        
        % Extract variables
        time = Homeo.time{p} ;
        data = Homeo.data{p} ;
        idx_localmax = Homeo.idx_localmax{p} ;
        multireg_coeff = Homeo.multireg_coeff{p} ;
        multiidx_localmax = Homeo.multiidx_localmax{p} ;

        % grey dots for all local maxima from all sessions :
        t_max = time(idx_localmax); d_max = data(idx_localmax) ;
        d = plot(t_max,d_max,'.','MarkerSize',10,'Color', [0.77 0.77 0.77]); % grey dots for all local maxima from all sessions
        uistack(d,'bottom'); % put dots in bakground
        
         % line for each fit :
        for i=1:length(multireg_coeff)    
            reg_coeff_fit = multireg_coeff{i} ;
            idx_fit = multiidx_localmax{i} ;
            y_fit = polyval(reg_coeff_fit, t_max(idx_fit)) ;  
            l = plot(t_max(idx_fit),y_fit,'-','Color', fit_colors{2},'LineWidth',2) ;
            all_slopes(end+1) = reg_coeff_fit(1) ; % store slope value            
        end
        
        R2_diff = cell2mat(Homeo.multiR2{p})-cell2mat(Homeo.multiR2global{p}) ;
        all_R2diff = [all_R2diff, R2_diff] ;
        
    end
    
    xlabel('Time (hours)'), ylabel('Normalized Event Duration (% of mean NREM Duration)');
    title([events_names{q} ' (Windowsize: ' num2str(windowsize) 's)'],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l],{'Duration Local Maxima (all)',[sprintf('Linear Regression, mean R2diff = %.2f', nanmean(all_R2diff)) newline sprintf('Mean Slope = %.3e', nanmean(all_slopes))] },'FontSize',11)  % mean R2diff value
       
    
    
    % ------ Plot mean LFP around Events ------ : 

    subplot(4,6,events_subplot_start{q}+3)
    
    allmean_LFPdeep = mean([Homeo.meanLFPdeep{ToPlot}],2) ;    
    allmean_LFPsup = mean([Homeo.meanLFPsup{ToPlot}],2) ;  
    allmean_LFPOB = mean([Homeo.meanLFPOB{ToPlot}],2) ;  
    hold on, plot(Homeo.LFPt{1},allmean_LFPsup,'Color',LFP_colors{1}), plot(Homeo.LFPt{1},allmean_LFPdeep,'Color',LFP_colors{2}), plot(Homeo.LFPt{1},allmean_LFPOB,'Color',LFP_colors{3})
    legend({'Sup PFC','Deep PFC','OB'},'Orientation','horizontal','Location','northoutside'); xlabel('Time around event (ms)'); ylabel('Mean LFP signal') ;

    
    % ------ Get Co-occurence with down states ------ : 
    
    subplot(4,6,events_subplot_start{q}+9)
    
    all_DownCooccurProp = [Homeo.DownCooccurProp{ToPlot}] ;
    sem = std(all_DownCooccurProp)/sqrt(length(all_DownCooccurProp));
    b = bar(1,mean(all_DownCooccurProp),'LineStyle','none'); ylim([0 1.3]); ylabel('Proportion of events'), text(1, 0.1 + mean(all_DownCooccurProp) + sem , sprintf('%.3f',mean(all_DownCooccurProp)),'HorizontalAlignment','center')
    set(gca,'XtickLabels','Down State Co-occurrence');
    hold on, errorbar(1,mean(all_DownCooccurProp),sem,sem,'Color',[0 0 0], 'LineStyle','none') ;  
    legend(b,{['Pre- & Post Timewindows = ',num2str(cooccur_delay),'ms']},'Orientation','horizontal','Location','northoutside') ;      
    
end         
  

    % Save Plot :   
saveas(gcf,['Duration/ParcourQuantifHomeostasisDurationPlot_MultipleMean.png']) 
saveas(gcf,['epsFigures/ParcourQuantifHomeostasisDurationPlot_MultipleMean.eps'],'epsc')


