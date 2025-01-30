
%% AllHomeostasisComparison_2FitBarPlot
%
% 01/06/2020  LP
%
% Script to plot bar plots with R2 and -Slope values, from homeostasis
% quantifications (choose quantifications below : densities for all slow wave types,
% SWA and grouped slow waves, ...).
%
% -> Mean values across sessions.
% -> Values with Mice x SWtype for each quantification are stored in 'ForStats' structure

%% LOAD DATA  : 

clear 

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 
mean_across_mice = true ; % if true, mean across mice. if false, across sessions.

% --- CHOOSE QUANTIF --- : (% Cf. below)
quantif_choice = 4 ; 


% ----------------------------------------- LOAD EVENT DENSITY DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end


if afterREM1 % if only after 1st episode of REM
    eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_first' num2str(firstfit_duration) 'h_afterREM1.mat']) 
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/AfterREM1/Comparison')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/AfterREM1/Comparison'])
    end
    
else % if plot whole session
    eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_first' num2str(firstfit_duration) 'h.mat']) 
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM/Comparison')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM/Comparison'])
    end
end    
Homeo_res_density = Homeo_res ; 


% ----------------------------------------- LOAD SWA DATA ----------------------------------------- :

description = ['twofit_' num2str(firstfit_duration)] ; 
if afterREM1
    description = [description '_afterREM1'] ; 
end

% -- Load file -- :

try 
    eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisBandpower_' description '.mat']) % path if on lab computer
catch
    eval(['load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisBandpower_' description '.mat']) % if on personal computer   
end    

Homeo_res_SWA = Homeo_res ;

clearvars -except Homeo_res_SWA Homeo_res_density firstfit_duration afterREM1 mean_across_mice quantif_choice

% ----------------------------------------- PLOTTING PARAMETERS ----------------------------------------- :


if quantif_choice == 1 % All Slow Waves 
    
    quantif_list = {Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves1,Homeo_res_density.SlowWaves2,Homeo_res_density.SlowWaves3,Homeo_res_density.SlowWaves4,Homeo_res_density.SlowWaves5,Homeo_res_density.SlowWaves6,Homeo_res_density.SlowWaves7,Homeo_res_density.SlowWaves8} ;
    quantif_names = {'Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
    quantif_colors = {[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    bar_opacity = 0.8 ;
    plot_order = [1,2,3,4,5,6,7,8,9,10] ; 
    ylim_r2 = [0 0.6] ;
    ylim_slope = [-3 39] ; 
    
elseif quantif_choice == 2 % SWA, Down States, Delta Waves, Grouped Slow Waves
    
    quantif_list = {Homeo_res_SWA.PFCsup,Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves_group34,Homeo_res_density.SlowWaves_group5678} ;
    quantif_names = {'SWA','Down States', 'Delta Waves','Slow Waves 3/4', 'Slow Waves 5/6/7/8'} ; 
    quantif_colors = {[1 0.15 0],[0 0 0],[0.4 0.4 0.4],[0.8 0.2 0.4],[0 0.6 0.45]} ; 
    bar_opacity = 0.8 ;
    plot_order = [1,4,3,2,5] ; 
    ylim_r2 = [0 0.7] ;
    ylim_slope = [0 30] ; 
    
elseif quantif_choice == 3 % All Slow Waves + SWA pfc 
    
    quantif_list = {Homeo_res_SWA.PFCsup,Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves1,Homeo_res_density.SlowWaves2,Homeo_res_density.SlowWaves3,Homeo_res_density.SlowWaves4,Homeo_res_density.SlowWaves5,Homeo_res_density.SlowWaves6,Homeo_res_density.SlowWaves7,Homeo_res_density.SlowWaves8} ;
    quantif_names = {'SWA PFC','Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
    quantif_names = {'SWA PFC','Down States', 'Delta Waves','SW1', 'SW2', 'SW3','SW4', 'SW5', 'SW6','SW7', 'SW8'} ; 
    quantif_colors = {[1 0.15 0],[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    bar_opacity = 0.76 ;
    plot_order = [1,2,3,4,5,6,7,8,9,10,11] ; 
    ylim_r2 = [0 0.63] ;
    ylim_slope = [-3 42] ; 
    
    
    elseif quantif_choice == 4 % All Slow Waves + SWA pfc + SWA ob
    
    quantif_list = {Homeo_res_SWA.PFCsup,Homeo_res_SWA.OBdeep,Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves1,Homeo_res_density.SlowWaves2,Homeo_res_density.SlowWaves3,Homeo_res_density.SlowWaves4,Homeo_res_density.SlowWaves5,Homeo_res_density.SlowWaves6,Homeo_res_density.SlowWaves7,Homeo_res_density.SlowWaves8} ;
    quantif_names = {'SWA PFC','SWA OB','Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
    quantif_names = {'SWA PFC','SWA OB','Down States', 'Delta Waves','SW1', 'SW2', 'SW3','SW4', 'SW5', 'SW6','SW7', 'SW8'} ; 
    quantif_colors = {[1 0.15 0],[0.5 0.05 0],[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    bar_opacity = 0.76 ;
    plot_order = [1,2,3,4,5,6,7,8,9,10,11,12] ; 
    ylim_r2 = [0 0.63] ;
    ylim_slope = [-3 42] ; 
    
end



% --------- Get mice info ---------- :

n_mice = length(unique(Homeo_res_density.name)) ;
[mice_list, ~, mice_ix] = unique(Homeo_res_density.name) ; 


%% -------------------------------- GLOBAL FIT  -------------------------------- : 


% --------------------- Get mean and SEM of R2 and slope values, for each quantif --------------------- :

all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;
n_sessions = length(Homeo_res_SWA.path) ;

if mean_across_mice   % ----- Mean Data across mice (if mean_across_mice == true) ----- :

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
    
    
else    % ----- Data across all sessions (if mean_across_mice == false) ----- :
   
    for i = 1:length(quantif_list)

        % R2
        all_meanR2(i) = mean(cell2mat(quantif_list{i}.R2)) ;
        all_semR2(i) = std(cell2mat(quantif_list{i}.R2))/sqrt(n_sessions) ;
        % Slope
        meanregcoeff = mean(vertcat(quantif_list{i}.reg_coeff{1:n_sessions})) ;
        all_meanSlope(i) = meanregcoeff(1) ;
        semregcoeff = std(vertcat(quantif_list{i}.reg_coeff{1:n_sessions}))/sqrt(n_sessions) ;
        all_semSlope(i) = semregcoeff(1) ;

    end

end



% ------------------ Barplots ------------------ : 

figure,

% Title :
if mean_across_mice
    sgtitle(['Homeostasis Comparison, N = ' num2str(n_mice) ' mice']) ; 
else
    sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' sessions']) ; 
end
    

% R2 BARPLOT :
subplot(2,3,1),
hold on,
for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ; 
    b = bar(k,all_meanR2(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ; 
    b.FaceAlpha = bar_opacity ;
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
    b = bar(k,-all_meanSlope(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+2,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
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
n_sessions = length(Homeo_res_SWA.path) ;


if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

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
    
    
else   % ----- Data across all sessions (if mean_across_mice == false) ----- :
    
    for i = 1:length(quantif_list)
        
        quantif = quantif_list{i} ; 
        % R2
        twofitR2 = cat(1,quantif.twofitR2{:}) ;
        all_meanR2(i) = nanmean(cell2mat(twofitR2(:,1))) ;
        all_semR2(i) = nanstd(cell2mat(twofitR2(:,1)))/sqrt(n_sessions) ;
        % Slope
        twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,1)) ; % regression coeff with slope for the 1st fit only
        all_meanSlope(i) = nanmean(twofitreg_coeff_1(:,1));
        all_semSlope(i) = nanstd(twofitreg_coeff_1(:,1))/sqrt(n_sessions) ;
    end
    
end




% -------------- Barplots ------------- : 

% R2 BARPLOT :
subplot(2,3,2),
hold on,

for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ; 
    b = bar(k,all_meanR2(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
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
    b = bar(k,-all_meanSlope(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+2,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
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
n_sessions = length(Homeo_res_SWA.path) ;

if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

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
    
    
else   % ----- Data across all sessions (if mean_across_mice == false) ----- :
    
    for i = 1:length(quantif_list)
        
        quantif = quantif_list{i} ; 
        % R2
        twofitR2 = cat(1,quantif.twofitR2{:}) ;
        all_meanR2(i) = nanmean(cell2mat(twofitR2(:,2))) ;
        all_semR2(i) = nanstd(cell2mat(twofitR2(:,2)))/sqrt(n_sessions) ;
        % Slope
        twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,2)) ; % regression coeff with slope for the 2nd fit only
        all_meanSlope(i) = nanmean(twofitreg_coeff_1(:,1));
        all_semSlope(i) = nanstd(twofitreg_coeff_1(:,1))/sqrt(n_sessions) ;
    end
    
end



% -------------- Barplots ------------- : 



% R2 BARPLOT :

subplot(2,3,3),
hold on,

for k = 1:length(all_meanR2) % for each quantif
    q = plot_order(k) ; 
    b = bar(k,all_meanR2(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
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
    b = bar(k,-all_meanSlope(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
    errorbar(k,-all_meanSlope(q),all_semSlope(q),all_semSlope(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlope(q)+all_semSlope(q)+2,sprintf('%.2g',-all_meanSlope(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end
% legend & labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanSlope),'XtickLabels',quantif_names(plot_order));
xtickangle(30);
set(gca,'FontSize',12) ; 
title(['- Slope, Two Fit : '  num2str(firstfit_duration) 'h-end'],'Fontsize',15) ;


%% SAVE PLOT : 
% 
if mean_across_mice
    print(['BarPlots/AllHomeostasisComparison_2FitBarPlot' num2str(quantif_choice) '_MiceMean'], '-dpng', '-r300') ; 
    print(['epsFigures/AllHomeostasisComparison_BarPlot' num2str(quantif_choice) '_MiceMean'], '-depsc') ; 
else
    print(['BarPlots/AllHomeostasisComparison_2FitBarPlot' num2str(quantif_choice) '_SessionsMean'], '-dpng', '-r300') ; 
    print(['epsFigures/AllHomeostasisComparison_BarPlot' num2str(quantif_choice) '_SessionsMean'], '-depsc') ; 
end



%% STATS : 

% Repeated-Measures Anova for each bar plot :

rmanova_p = [] ; % p-values for all barplots
stat_data = {ForStats.GlobalFit.allR2,ForStats.TwoFit1.allR2,ForStats.TwoFit2.allR2,ForStats.GlobalFit.allSlopes,ForStats.TwoFit1.allSlopes,ForStats.TwoFit2.allSlopes} ;  % in order of subplots
for i=1:length(stat_data)
    res = anova_rm(stat_data{i},'off') ;
    p(i) = res(1) ; 
end


%Paired Wilcoxon Signed Rank Tests : 
stat_data = ForStats.TwoFit1.allSlopes ; % quantif (barplot) on which to perform the test
types = [7 4] ; % indices of slow wave types on the subplot to be compared
types_ix = plot_order(types) ; 
signrank_p = signrank(stat_data(:,types_ix(1)),stat_data(:,types_ix(2))) ;
% corrected_p = bonf_holm(p-list) ; 





