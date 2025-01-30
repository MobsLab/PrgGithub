%% ParcourSlowwavesNoDownHomeostasisPlot
%
% 08/06/2020
%
% Script to plot event density homeostasis bar plots for slow waves
% 3/4/6 which are associated or not with down states
%
% -> global fit and 2 fits (first 3 hours vs. rest of the session)
%
%  SEE : run ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes first,
%  with the right subset of events (to be changed in the script parameters)
%

clear


% ----------------------------------------- LOAD DATA ----------------------------------------- :

firstfit_duration = 3 ; % duration of the first fit, in h 
description = {'downcooccur','notdowncooccur'} ; 
%description = {'nexttodown','notnexttodown'} ; 
saveplot = 1 ; 



try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end

eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_first' num2str(firstfit_duration) 'h_' description{1} '.mat']) ; 
H1 = Homeo_res ; % With down states

eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_first' num2str(firstfit_duration) 'h_' description{2} '.mat']) ; 
H2 = Homeo_res ; % With no down states

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WithoutDown')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WithoutDown'])
end


% CHOOSE EVENTS : 
events = {H1.SlowWaves3,H1.SlowWaves6,H1.SlowWaves4,H2.SlowWaves3,H2.SlowWaves6,H2.SlowWaves4} ; 
events_names = {'SW3 +down','SW6 +down','SW4 +down','SW3 no down','SW6 no down','SW4 no down'} ; 


%% PLOT MEAN HOMEOSTASIS PROFILES - GLOBAL FIT  : 

% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;


figure, 

for q = 1:length(events) 
    Homeo = events{q} ; 
    
    % -- Plot Event Density Homeostasis -- : 
    
    subplot(2,length(events)/2,q),
    
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
    
end

% Save Plot :   
% sgtitle(['Mean Global Fit Homeostasis on event density for slow waves 1/2/5' newline 'without rebounds from 3/4/6 (n = ' num2str(length(Homeo_res.path)) ')']);
if saveplot
    print(['ParcourSlowwavesNoDownPlot_HomeoDensityGlobalFit_' description{2}], '-dpng', '-r300') ; 
end

%% PLOT MEAN HOMEOSTASIS PROFILES - TWO FITS  : 

% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
yl = [30 400] ; 

figure, 

for q = 1:length(events) 
    
        Homeo = events{q} ;
        all_slopes_1 = [] ; % to store slope values for 1st fits
        all_slopes_2 = [] ; % to store slope values for 2nd fits
        all_R2_1 = [] ; % idem for R2
        all_R2_2 = [] ; % idem for R2

        % ------ Plot Event Occupancy Homeostasis (all) ------ :

        subplot(2,length(events)/2,q),
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
        ylim([yl]) ; 
    
end


% Save Plot :   
% sgtitle(['Mean 2Fit Homeostasis on event density for slow waves 1/2/5' newline 'without rebounds from 3/4/6 (n = ' num2str(length(Homeo_res.path)) ')']);
if saveplot
    print(['ParcourSlowwavesNoDownPlot_HomeoDensity2Fit_' description{2}], '-dpng', '-r300') ; 
end


%% HOMEOSTASIS BAR PLOT COMPARISON (with vs without rebounds) : 

quantif_list = events ; 
quantif_names = events_names ; 
quantif_colors = {[1 0 0.4],[0 0.6 0.4],[0.6 0.2 0.6],[1 0 0.4],[0 0.6 0.4],[0.6 0.2 0.6]} ; 
bar_opacity = 0.7 ;
plot_order = [1,4,2,5,3,6] ; 
ylim_r2 = [0 0.6] ;
ylim_slope = [-20 58] ;


% --------- Get average per mice ---------- :

n_mice = length(unique(Homeo_res.name)) ;
[mice_list, ~, mice_ix] = unique(Homeo_res.name) ; 


for i = 1:length(quantif_list)

    % 1) Extract data :
    allR2 = cell2mat(quantif_list{i}.R2);
    allregcoeff = vertcat(quantif_list{i}.reg_coeff{:}) ;
    allSlope = allregcoeff(:,1)';
    allmiceR2 = [] ; 
    allmiceSlope = [] ;

    % 2) Average for each mice :
    for m = 1:length(mice_list) 
        allmiceR2(m) = nanmean(allR2(mice_ix==m));
        allmiceSlope(m) = nanmean(allSlope(mice_ix==m));
    end

    % 3) Data across mice :
        % Save R2 and Slope values of all mice and all SW types, for statistical analyses 
    ForStats.GlobalFit.allR2(:,i) = allmiceR2 ; 
    ForStats.GlobalFit.allSlopes(:,i) = allmiceSlope ;
        % R2
    all_meanR2(i) = nanmean(allmiceR2) ;
    all_semR2(i) = nanstd(allmiceR2)/sqrt(length(allmiceR2)) ;
        % Slope
    all_meanSlope(i) = nanmean(allmiceSlope) ;
    all_semSlope(i) = nanstd(allmiceSlope)/sqrt(length(allmiceSlope)) ;

end


% -------------- Barplots --------------- : 


figure,

sgtitle(['Homeostasis Comparison, N = ' num2str(n_mice) ' mice']) ; 


% R2 BARPLOT :
subplot(2,3,1),
hold on,
for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ;
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,all_meanR2(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,all_meanR2(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end
    errorbar(k,all_meanR2(q),all_semR2(q),all_semR2(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,all_meanR2(q)+all_semR2(q)+0.04,sprintf('%.2g',all_meanR2(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end

% legend & labels :
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['R2, Global Fit'],'Fontsize',15) ;


% SLOPE BARPLOT :
subplot(2,3,4),
hold on,
for k = 1:length(all_meanSlope) % for each quantif
    q = plot_order(k) ; 
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,-all_meanSlope(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,-all_meanSlope(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end

    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+5,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanSlope),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['- Slope, Global Fit'],'Fontsize',15) ;



%% -------------------------------- TWO FITS : first fit  -------------------------------- : 


% ------------- Get mean and SEM of R2 and slope values, for each quantif ------------ :

all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;


for i = 1:length(quantif_list)

    quantif = quantif_list{i} ; 

    % 1) Extract data :
    twofitR2 = cat(1,quantif.twofitR2{:}) ;
    allR2 = cell2mat(twofitR2(:,1)) ; % keep only R2 for the 1st fit
    twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
    twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,1)) ; % keep only regcoeff for the 1st fit
    allSlope = twofitreg_coeff_1(:,1)';
    allmiceR2 = [] ; 
    allmiceSlope = [] ;

    % 2) Average for each mice :
    for m = 1:length(mice_list) 
        allmiceR2(m) = nanmean(allR2(mice_ix==m));
        allmiceSlope(m) = nanmean(allSlope(mice_ix==m));
    end

    % 3) Data across mice :
        % Save R2 and Slope values of all mice and all SW types, for statistical analyses 
    ForStats.TwoFit1.allR2(:,i) = allmiceR2 ; 
    ForStats.TwoFit1.allSlopes(:,i) = allmiceSlope ;
        % R2
    all_meanR2(i) = nanmean(allmiceR2) ; % R2 nºi = mean R2 across mice for slow wave nºi
    all_semR2(i) = nanstd(allmiceR2)/sqrt(length(allmiceR2)) ;
        % Slope
    all_meanSlope(i) = nanmean(allmiceSlope) ;
    all_semSlope(i) = nanstd(allmiceSlope)/sqrt(length(allmiceSlope)) ;

end

    


% -------------- Barplots ------------- : 

% R2 BARPLOT :
subplot(2,3,2),
hold on,

for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ; 
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,all_meanR2(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,all_meanR2(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end
    
    errorbar(k,all_meanR2(q),all_semR2(q),all_semR2(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,all_meanR2(q)+all_semR2(q)+0.04,sprintf('%.2g',all_meanR2(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['R2, Two Fit : 0-' num2str(firstfit_duration) 'h'],'Fontsize',15) ;


% SLOPE BARPLOT :
subplot(2,3,5),
hold on,
for k = 1:length(all_meanSlope) % for each quantif
    q = plot_order(k) ; 
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,-all_meanSlope(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,-all_meanSlope(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end
    
    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+5,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanSlope),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['- Slope, Two Fit : 0-' num2str(firstfit_duration) 'h'],'Fontsize',15) ;



%% -------------------------------- TWO FITS : second fit  -------------------------------- : 


% ------ Get mean and SEM of R2 and slope values, for each quantif ------ :


all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;



for i = 1:length(quantif_list)

    quantif = quantif_list{i} ; 

    % 1) Extract data :
    twofitR2 = cat(1,quantif.twofitR2{:}) ;
    allR2 = cell2mat(twofitR2(:,2)) ; % keep only R2 for the 2nd fit
    twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
    twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,2)) ; % keep only regcoeff for the 2nd fit
    allSlope = twofitreg_coeff_1(:,1)';
    allmiceR2 = [] ; 
    allmiceSlope = [] ;

    % 2) Average for each mice :
    for m = 1:length(mice_list) 
        allmiceR2(m) = nanmean(allR2(mice_ix==m));
        allmiceSlope(m) = nanmean(allSlope(mice_ix==m));
    end

    % 3) Data across mice :
        % Save R2 and Slope values of all mice and all SW types, for statistical analyses 
    ForStats.TwoFit2.allR2(:,i) = allmiceR2 ; 
    ForStats.TwoFit2.allSlopes(:,i) = allmiceSlope ;
        % R2
    all_meanR2(i) = nanmean(allmiceR2) ;
    all_semR2(i) = nanstd(allmiceR2)/sqrt(length(allmiceR2)) ;
        % Slope
    all_meanSlope(i) = nanmean(allmiceSlope) ;
    all_semSlope(i) = nanstd(allmiceSlope)/sqrt(length(allmiceSlope)) ;

end



% -------------- Barplots ------------- : 



% R2 BARPLOT :

subplot(2,3,3),
hold on,

for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ; 
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,all_meanR2(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,all_meanR2(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end
    
    errorbar(k,all_meanR2(q),all_semR2(q),all_semR2(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,all_meanR2(q)+all_semR2(q)+0.04,sprintf('%.2g',all_meanR2(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['R2, Two Fit : '  num2str(firstfit_duration) 'h-end'],'Fontsize',15) ;


% SLOPE BARPLOT :
subplot(2,3,6),
hold on,
for k = 1:length(all_meanSlope) % for each quantif
    q = plot_order(k) ; 
    
    if mod(k,2)~=0 % plot in plain bar for all sw
        b = bar(k,-all_meanSlope(q),'LineStyle','none','FaceColor',quantif_colors{q},'FaceAlpha',bar_opacity) ; 
    else  % plot in white bar for no rebound sw
        b = bar(k,-all_meanSlope(q),'EdgeColor',quantif_colors{q},'LineWidth',2 ,'FaceAlpha',0) ; 
    end
    
    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+5,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanSlope),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['- Slope, Two Fit : '  num2str(firstfit_duration) 'h-end'],'Fontsize',15) ;


% Save Plot :  
if saveplot
    print(['ParcourSlowwavesNoDownHomeostasisPlot_Comparison_' description{2}], '-dpng', '-r300') ; 
end


% STATS : 

%Paired Wilcoxon Signed Rank Tests : 
stat_data = ForStats.TwoFit1.allSlopes ; % quantif (barplot) on which to perform the test
types = [3 4] ; % indices of slow wave types on the subplot to be compared
types_ix = plot_order(types) ; 
signrank_p = signrank(stat_data(:,types_ix(1)),stat_data(:,types_ix(2))) ;
% corrected_p = bonf_holm(p-list) ; 


stat_data = ForStats.TwoFit1.allR2 ; % quantif (barplot) on which to perform the test
types = [5 6] ; % indices of slow wave types on the subplot to be compared
types_ix = plot_order(types) ; 
signrank_p = signrank(stat_data(:,types_ix(1)),stat_data(:,types_ix(2))) ;
% corrected_p = bonf_holm(p-list) ; 


