%% ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypesPlotSupp
%
% 30/05/2020 LP
%
% Supplementary Mean Plots for homeostasis on event density. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event density (delta, slow waves, down states). 
%
% -> global fit and 2 fits (first 3 hours vs. rest of the session) 
%
%
% SEE : 
% QuantifHomeostasisDensity 
% ParcourQuantifHomeostasisDensity
% ParcourQuantif2FitHomeostasisDensityPlot_AllSlowWaveTypes

clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 

events_subset = 'all' ; 
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
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM'])
    end
end




%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 


% -------------------  For first plot : all slow wave types  -------------------  : 

all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
all_slowwaves_names = {'Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 

figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    Homeo = all_slowwaves{type} ; 

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

    xlabel('ZT Time (hours)'), ylabel('Normalized Event Density');
    title([all_slowwaves_names{type} sprintf('(mean nb events = %.2e)',nanmean(cell2mat(Homeo.nb_events)))],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l],{'Density Local Maxima (all)', 
        [sprintf('Linear Regression, mean R2 = %.2f', nanmean([Homeo.R2{ToPlot}])) newline sprintf('Mean Slope = %.3e', mean_reg_coeff(1))] },'FontSize',11)  % mean R2 value
    ylim([30 280]) 

end
 
    
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.8,'Event Density Homeostasis','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['Global Fits (n=' num2str(length(ToPlot)) ' sessions)'],'FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.35,['2-Channel Slow Waves'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.2,['Density Window : ' num2str(windowsize) 's'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.05,[events_subset ' slow waves'],'FontSize',18,'HorizontalALignment','center'), axis off

% Save plot :  
print(['2FitHomeostasisDensity_' description '_MeanPlot_Supp1'], '-dpng', '-r300') ; 
print(['epsFigures/2FitHomeostasisDensity_' description '_MeanPlot_Supp1'], '-depsc') ; 

% -------------------  For 2nd plot : down, delta, and grouped SW -------------------  : 


all_slowwaves = {Homeo_res.SlowWaves_group34,Homeo_res.SlowWaves_group5678,Homeo_res.DiffDeltaWaves,Homeo_res.DownStates} ;
all_slowwaves_names = {'Slow Waves 3/4', 'Slow Waves 5/6/7/8', 'Delta Waves', 'Down States'} ; 


for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(2,2,type);
    Homeo = all_slowwaves{type} ; 

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

    xlabel('ZT Time (hours)'), ylabel('Normalized Event Density');
    title([all_slowwaves_names{type} sprintf('(mean nb events = %.2e)',nanmean(cell2mat(Homeo.nb_events)))],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l],{'Density Local Maxima (all)', 
        [sprintf('Linear Regression, mean R2 = %.2f', nanmean([Homeo.R2{ToPlot}])) newline sprintf('Mean S = %.2e', mean_reg_coeff(1))] },'FontSize',11)  % mean R2 value
    ylim([30 240]) 

end

sgtitle(['Event Density Homeostasis, Global Fits (n=' num2str(length(ToPlot)) ' sessions)' description]) ;    

% Save plot :  
print(['2FitHomeostasisDensity_' description '_MeanPlot_Supp2'], '-dpng', '-r300') ; 
print(['epsFigures/2FitHomeostasisDensity_' description '_MeanPlot_Supp2'], '-depsc') ; 



%% ----------------------------------------- MEAN PLOT for all sessions : 2 FITS ----------------------------------------- :


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 


% -------------------  For first plot : all slow wave types  -------------------  : 

all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
all_slowwaves_names = {'Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 

figure,

% Plot All Types : 

for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(3,3,subplots_order(type));
    Homeo = all_slowwaves{type} ; 

    all_slopes_1 = [] ; % to store slope values for 1st fits
    all_slopes_2 = [] ; % to store slope values for 2nd fits
    all_R2_1 = [] ; % idem for R2
    all_R2_2 = [] ; % idem for R2

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

    xlabel('ZT Time (hours)'), ylabel('Normalized Event Density');
    title([all_slowwaves_names{type} sprintf(' (mean nb events = %.2e)',nanmean(cell2mat(Homeo.nb_events)))],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l1,l2],{'Density Local Maxima',[sprintf('0-3h : mean R2 = %.2f, Mean S = %.2e', nanmean(all_R2_1),nanmean(all_slopes_1))], [sprintf('End : mean R2 = %.2f, Mean S = %.2e', nanmean(all_R2_2),nanmean(all_slopes_2))]},'FontSize',11)  % mean R2diff value
    ylim([30 300]) ; 
    
end

    
% Title & Parameters 
subplot(3,3,5),
text(0.5,0.8,'Event Density Homeostasis','FontSize',24,'HorizontalAlignment','center'), axis off
text(0.5,0.6,['2 Fits (n=' num2str(length(ToPlot)) ' sessions)'],'FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.35,['2-Channel Slow Waves'],'FontSize',18,'HorizontalAlignment','center'), axis off
text(0.5,0.2,['Density Window : ' num2str(windowsize) 's'],'FontSize',18,'HorizontalALignment','center'), axis off
text(0.5,0.05,[events_subset ' slow waves'],'FontSize',18,'HorizontalALignment','center'), axis off


% Save plot :  
print(['2FitHomeostasisDensity_' description '_2FitMeanPlot_Supp1'], '-dpng', '-r300') ; 
print(['epsFigures/2FitHomeostasisDensity_' description '_2FitMeanPlot_Supp1'], '-depsc') ; 



% -------------------  For 2nd plot : down, delta, and grouped SW -------------------  : 


all_slowwaves = {Homeo_res.SlowWaves_group34,Homeo_res.SlowWaves_group5678,Homeo_res.DiffDeltaWaves,Homeo_res.DownStates} ;
all_slowwaves_names = {'Slow Waves 3/4', 'Slow Waves 5/6/7/8', 'Delta Waves', 'Down States'} ; 


for type = 1:length(all_slowwaves) 
    
    all_subplots(type) = subplot(2,2,type);
    Homeo = all_slowwaves{type} ; 

    all_slopes_1 = [] ; % to store slope values for 1st fits
    all_slopes_2 = [] ; % to store slope values for 2nd fits
    all_R2_1 = [] ; % idem for R2
    all_R2_2 = [] ; % idem for R2

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

    xlabel('ZT Time (hours)'), ylabel('Normalized Event Density');
    title([all_slowwaves_names{type} sprintf('(mean nb events = %.2e)',nanmean(cell2mat(Homeo.nb_events)))],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l1,l2],{'Density Local Maxima',[sprintf('0-3h : mean R2 = %.2f, Mean S = %.2e', nanmean(all_R2_1),nanmean(all_slopes_1))], [sprintf('End : mean R2 = %.2f, Mean S = %.2e', nanmean(all_R2_2),nanmean(all_slopes_2))]},'FontSize',11)  % mean R2diff value
    ylim([30 260]) ; 
    
end

sgtitle(['Event Density Homeostasis, 2 Fits (n=' num2str(length(ToPlot)) ' sessions)' description]) ;   

% Save plot :  

print(['2FitHomeostasisDensity_' description '_2FitMeanPlot_Supp2'], '-dpng', '-r300') ; 
print(['epsFigures/2FitHomeostasisDensity_' description '_2FitMeanPlot_Supp2'], '-depsc') ; 

