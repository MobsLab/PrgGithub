%% AllFreqbandHomeostasisBandpowerComparisonBarplot.m

% 28/06/2020  LP

% Script to plot mean comparison barplot between SWA homeostasis of different freqency bands 
% -> across sessions or across mice 


%% LOAD DATA  : 

clear 

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

multifit_thresh = 'none' ; % wake duration (in minutes) between separate sleep episodes if multifit. 'none' for 1 or 2 fits.
twofit_duration = 3 ; % duration of the 1st of two fits, in hours. / 'none' for 1 fit. 
afterREM1 = false ; 

mean_across_mice = true ; % if true, mean across mice. if false, across sessions.


% ----------------------------------------- LOAD DATA ----------------------------------------- :


% -- Define description for filename, based on parameters -- :

if multifit_thresh == 'none' % if one or two fits : 
    if twofit_duration == 'none' % 1 fit
        description = 'globalfit' ; 
    else % 2 fits
        description = ['twofit_' num2str(twofit_duration)] ; 
    end
else % multifit
    description = ['multifit_' num2str(multifit_thresh)] ; 
end 

if afterREM1 
    description = [description '_afterREM1']
end



% -- Load files -- :

for freqband_choice = 1:3 % choose frequency bands to be plotted (Cf. freqband_choice in Parcour script)
    
    try 
        eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisBandpower_' description '_freqband' num2str(freqband_choice) '.mat']) % path if on lab computer
        dir_path = [FolderDataLP_DeltaSpectral 'Results/Homeostasis/Bandpower/Bandpower_' description '_comparison'] ; 
        if ~exist(dirpath,'dir'); mkdir(dir_path); end
        cd(dir_path)  

    catch
        eval(['load /Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisBandpower_' description '_freqband' num2str(freqband_choice) '.mat']) % if on personal computer   
        dir_path = ['/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis/Bandpower/Bandpower_' description '_comparison'] ;
        if ~exist(dir_path,'dir'); mkdir(dir_path); end
        cd(dir_path)

    end    

    all_homeo_res{freqband_choice} = Homeo_res.PFCsup ; % store results for each freqband
    all_freqbands{freqband_choice} = freqband ; % store freqband value
    
end



% --------- Plotting Parameters ---------- :

plot_order = [1,2,3] ; 
quantif_colors = {[0.6 0.6 0.6],[0 0.25 0.5],[1 0.55 0]} ; 
ylim_r2 = [0 0.65] ; 
ylim_slope = [0 35] ;
bar_opacity = 0.9 ;


% Get frequency band legend : 
for i=1:length(all_freqbands)
    freq = all_freqbands{i} ; 
    quantif_names{i} = [num2str(freq(1)) '-' num2str(freq(2)) 'Hz'] ; 
end

% --------- Get mice info ---------- :

n_mice = length(unique(Homeo_res.name)) ;
[mice_list, ~, mice_ix] = unique(Homeo_res.name) ; 


%% PLOT FIGURE 

figure, 

% -------------------------------------- FIRST FIT -------------------------------------- : 

% ------------- Get mean and SEM of R2 and slope values, for each quantif ------------ :

all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;

if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

    for i = 1:length(all_homeo_res)

        quantif = all_homeo_res{i} ; 
        
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
    
    for i = 1:length(all_homeo_res)
        
        quantif = all_homeo_res{i} ; 
        n_sessions = length(quantif.time) ; 
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
subplot(2,2,1),
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
title(['R2, Two Fit : 0-' num2str(twofit_duration) 'h'],'Fontsize',15) ;


% SLOPE BARPLOT :
subplot(2,2,3),
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
title(['- Slope, Two Fit : 0-' num2str(twofit_duration) 'h'],'Fontsize',15) ;




%% -------------------------------- TWO FITS : second fit  -------------------------------- : 


% ------ Get mean and SEM of R2 and slope values, for each quantif ------ :


all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;

if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

    for i = 1:length(all_homeo_res) % For each frequency band 

        quantif = all_homeo_res{i} ; 
        
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
    
    for i = 1:length(all_homeo_res)
        
        quantif = all_homeo_res{i} ; 
        n_sessions = length(quantif.time) ; 
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

subplot(2,2,2),
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
title(['R2, Two Fit : '  num2str(twofit_duration) 'h-end'],'Fontsize',15) ;


% SLOPE BARPLOT :
subplot(2,2,4),
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
title(['- Slope, Two Fit : '  num2str(twofit_duration) 'h-end'],'Fontsize',15) ;




% SAVE PLOT : 

if mean_across_mice
    sgtitle(['Mean SWA Homeostasis (N = ' num2str(n_mice) ' mice)']) ; 
    print(['AllFreqbandHomeostasisBandpowerComparison_MiceMean'], '-dpng', '-r300') ; 
    %print(['epsFigures/AllFreqbandHomeostasisBandpowerComparison_MiceMean'], '-depsc') ; 
else
    sgtitle(['Mean SWA Homeostasis (n = ' num2str(n_sessions) ' sessions)']) ; 
    print(['AllFreqbandHomeostasisBandpowerComparison_SessionsMean'], '-dpng', '-r300') ; 
    %print(['epsFigures/AllFreqbandHomeostasisBandpowerComparison_SessionsMean'], '-depsc') ; 
end



%% -------------------------------- FIT DIFFERENCE : slope difference between first and second part of the session (Cf Hubbard 2020)  -------------------------------- : 





% ------------- Get mean and SEM of slope difference, for each freqband ------------ :

all_SlopeDiffmean = [] ; 
all_SlopeDiffsem = [] ; 


if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

    for i = 1:length(all_homeo_res)

        quantif = all_homeo_res{i} ; 
        
        % 1) Extract data :
        twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,1)) ; % keep only regcoeff for the 1st fit
        allSlope_1 = twofitreg_coeff_1(:,1)';
        twofitreg_coeff_2 = cell2mat(twofitreg_coeff(:,2)) ; % keep only regcoeff for the 1st fit
        allSlope_2 = twofitreg_coeff_2(:,1)';
        
        allSlope_diff = allSlope_1 - allSlope_2 ; 
        
        
        % 2) Average for each mice :
        for m = 1:length(mice_list) 
            allmiceSlopeDiff(m) = nanmean(allSlope_diff(mice_ix==m));
        end
        
        % 3) Data across mice :
            % Save for statistical analyses, for each freqband 
        ForStats.allSlopeDiff(:,i) = allmiceSlopeDiff ;
            % Slope Diff, for each freqband
        all_meanSlopeDiff(i) = nanmean(allmiceSlopeDiff) ;
        all_semSlopeDiff(i) = nanstd(allmiceSlopeDiff)/sqrt(length(allmiceSlopeDiff)) ;

    end
    
    
else   % ----- Data across all sessions (if mean_across_mice == false) ----- :
    
    for i = 1:length(all_homeo_res)
        
        quantif = all_homeo_res{i} ; 
        n_sessions = length(quantif.time) ; 
        
        % Get Slope Diff :
        twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,1)) ; % keep only regcoeff for the 1st fit
        allSlope_1 = twofitreg_coeff_1(:,1)';
        twofitreg_coeff_2 = cell2mat(twofitreg_coeff(:,2)) ; % keep only regcoeff for the 1st fit
        allSlope_2 = twofitreg_coeff_2(:,1)';
        
        allSlope_diff = allSlope_1 - allSlope_2 ; 
        
        % Slope Diff, for each freqband
        all_meanSlopeDiff(i) = nanmean(allSlopeDiff) ;
        all_semSlopeDiff(i) = nanstd(allSlopeDiff)/sqrt(length(allSlopeDiff)) ;
        
        
    end
    
end



% -------------- Barplot ------------- : 

figure,
hold on,

for k=1:length(all_meanSlopeDiff)
    
    q = plot_order(k) ; 
    b = bar(k,-all_meanSlopeDiff(q),'LineStyle','none') ; 
    b.FaceColor = quantif_colors{q} ;  
    b.FaceAlpha = bar_opacity ;
    errorbar(k,-all_meanSlopeDiff(q),all_semSlopeDiff(q),all_semSlopeDiff(q),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
    text(k,-all_meanSlopeDiff(q)+all_semSlopeDiff(q)+2,sprintf('%.2g',-all_meanSlopeDiff(q)),'HorizontalAlignment','center','Color',quantif_colors{q},'FontSize',12) ;  
end

% Legend and labels:
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names(plot_order));
xtickangle(30); ylim([0 27]);
ylabel('-Slope Difference (in percentage points)') ; 

if mean_across_mice
    title(['Slope Difference between' newline '1st and 2nd fit (N = ' num2str(n_mice) ' mice)']) ; 
%     print(['AllFreqbandHomeostasisBandpowerSlopeDiff_MiceMean'], '-dpng', '-r300') ; 
%     %print(['epsFigures/AllFreqbandHomeostasisBandpowerComparison_MiceMean'], '-depsc') ; 
else
    title(['Slope Difference between' newline '1st and 2nd fit (n = ' num2str(n_sessions) ' sessions)']) ; 
%     print(['AllFreqbandHomeostasisBandpowerComparison_SessionsMean'], '-dpng', '-r300') ; 
%     %print(['epsFigures/AllFreqbandHomeostasisBandpowerComparison_SessionsMean'], '-depsc') ; 
end