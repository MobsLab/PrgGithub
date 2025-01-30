%% HomeostasisComparison_SlopeR2_Plot
%
% 30/05/2020 LP
%
% Plot Slope(R2) comparison on mean event density homeostasis for all slow
% wave types. 
% "Homeostasis" computed here through linear regression of local maxima 
% on event density (delta, slow waves, down states). 
%
% -> global fit and 2 fits (first 3 hours vs. rest of the session) 
%
% SEE : 
% ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypesPlot.m (need
% to run first to extract homeostasis info and create the .mat file)

clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 
mean_across_mice = true ; % if true, mean across mice. if false, across sessions.

% --- CHOOSE QUANTIF --- : (% Cf. below)
quantif_choice = 1 ; 


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
    try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM/Comparison/SlopeR2')
    catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/WholeNREM/Comparison/SlopeR2'])
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


% ----------------------------------------- PLOTTING PARAMETERS ----------------------------------------- :


if quantif_choice == 1 % All Slow Waves 
    
    quantif_list = {Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves1,Homeo_res_density.SlowWaves2,Homeo_res_density.SlowWaves3,Homeo_res_density.SlowWaves4,Homeo_res_density.SlowWaves5,Homeo_res_density.SlowWaves6,Homeo_res_density.SlowWaves7,Homeo_res_density.SlowWaves8} ;
    quantif_names = {'Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
    quantif_colors = {[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    bar_opacity = 0.8 ;
    plot_order = [1,2,3,4,5,6,7,8,9,10] ; 
    %xlim_r2 = [0 0.6] ;
    %ylim_slope = [-3 39] ; 
    
elseif quantif_choice == 2 % SWA, Down States, Delta Waves, Grouped Slow Waves
    
    quantif_list = {Homeo_res_SWA.PFCsup,Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves_group34,Homeo_res_density.SlowWaves_group5678} ;
    quantif_names = {'SWA','Down States', 'Delta Waves','Slow Waves 3/4', 'Slow Waves 5/6/7/8'} ; 
    quantif_colors = {[1 0.15 0],[0 0 0],[0.4 0.4 0.4],[0.8 0.2 0.4],[0 0.6 0.45]} ; 
    bar_opacity = 0.8 ;
    plot_order = [1,4,3,2,5] ; 
    %xlim_r2 = [0 0.7] ;
    %ylim_slope = [0 30] ; 
    
elseif quantif_choice == 3 % All Slow Waves + SWA pfc + SWA ob
    
    quantif_list = {Homeo_res_SWA.PFCsup,Homeo_res_SWA.OBdeep,Homeo_res_density.DownStates,Homeo_res_density.DiffDeltaWaves,Homeo_res_density.SlowWaves1,Homeo_res_density.SlowWaves2,Homeo_res_density.SlowWaves3,Homeo_res_density.SlowWaves4,Homeo_res_density.SlowWaves5,Homeo_res_density.SlowWaves6,Homeo_res_density.SlowWaves7,Homeo_res_density.SlowWaves8} ;
    quantif_names = {'SWA PFC','SWA OB','Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
    quantif_colors = {[1 0.15 0],[0.5 0.05 0],[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 
    bar_opacity = 0.8 ;
    plot_order = [1,2,3,4,5,6,7,8,9,10,11,12] ; 
    %xlim_r2 = [0 0.63] ;
    %ylim_slope = [-3 39] ; 
    
end


% --------- Get mice info ---------- :

n_mice = length(unique(Homeo_res_density.name)) ;
[mice_list, ~, mice_ix] = unique(Homeo_res_density.name) ; 




%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :

figure,
hold on, 


if mean_across_mice   % ----- Mean Data across mice (if mean_across_mice == true) ----- :
     
    for q = 1:length(quantif_list)

        % 1) Extract data :
        allR2 = cell2mat(quantif_list{q}.R2);
        allregcoeff = vertcat(quantif_list{q}.reg_coeff{:}) ;
        allSlope = allregcoeff(:,1)';
        allmiceR2 = [] ; 
        allmiceSlope = [] ;

        % 2) Average for each mice :
        for m = 1:length(mice_list) 
            allmiceR2(m) = nanmean(allR2(mice_ix==m));
            allmiceSlope(m) = nanmean(allSlope(mice_ix==m));
        end

        % 3) Plots :

        % Plot all sessions as crosses : 
        c = plot(allmiceR2,-allmiceSlope,'x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(nanmean(allmiceR2),nanmean(-allmiceSlope),'.','Color',quantif_colors{q},'MarkerSize',45,'MarkerFaceAlpha',0.7);
        x_sem = nanstd(allmiceR2)/ sqrt(length(allmiceR2)) ; 
        y_sem = nanstd(allmiceSlope)/ sqrt(length(allmiceSlope)) ; 
        errorbarxy(nanmean(allmiceR2),mean(-allmiceSlope),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr

        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)  
        title(['-Slope & R2 Comparison of between Event Densities' newline 'Global Fit (N=' num2str(length(allmiceR2)) ' mice)'],'FontSize',20) ;
    end

else    % ----- Data across all sessions (if mean_across_mice == false) ----- :

    for q = 1:length(quantif_list) 

        data = quantif_list{q} ;
        reg_coeff = vertcat(data.reg_coeff{:}) ; % regression coeff with slope

        % Plot all sessions as crosses : 
        c = plot(cell2mat(data.R2),-reg_coeff(:,1)','x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(mean(cell2mat(data.R2)),mean(-reg_coeff(:,1)'),'.','Color',quantif_colors{q},'MarkerSize',45);
        x_sem = std(cell2mat(data.R2))/ sqrt(length(cell2mat(data.R2))) ; 
        y_sem = std(reg_coeff(:,1)')/ sqrt(length(reg_coeff(:,1)')) ; 
        errorbarxy(mean(cell2mat(data.R2)),mean(-reg_coeff(:,1)'),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr
        
        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)  
        title(['-Slope & R2 Comparison of between Event Densities' newline 'Global Fit (n=' num2str(length(cell2mat(data.R2))) ' sessions)'],'FontSize',20) ;

    end
end
    
    

% ----------------- Save Plot -------------- :

if mean_across_mice
    suffix = 'MiceMean';
else
    suffix = 'SessionsMean';  
end 

% print(['HomeostasisComparison_SlopeR2_' suffix num2str(quantif_choice) ], '-dpng', '-r300') ; 
% print(['epsFigures/HomeostasisComparison_SlopeR2_' suffix num2str(quantif_choice) ], '-depsc') ; 
% % Save zoomed plot : 
% xlim([-0.04 0.55]) ; ylim([-8 25]) ; 
% print(['HomeostasisComparison_SlopeR2_' suffix '_zoom'], '-dpng', '-r300') ; 
% print(['epsFigures/HomeostasisComparison_SlopeR2_' suffix '_zoom'], '-depsc') ; 
% 
% 



%% ----------------------------------------- MEAN PLOT for all sessions : 2 FITS ----------------------------------------- :

figure,


% --------------------- First fit :  0 to 'firstfit_duration' h ------------------------ :

subplot(2,1,1),
hold on, 

% For each quantif :

if mean_across_mice   % ----- Mean Data across mice (if mean_across_mice == true) ----- :
     
    for q = 1:length(quantif_list)

        quantif = quantif_list{q} ; 
        
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

        % 3) Plots :

        % Plot all sessions as crosses : 
        c = plot(allmiceR2,-allmiceSlope,'x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(nanmean(allmiceR2),nanmean(-allmiceSlope),'.','Color',quantif_colors{q},'MarkerSize',45);
        x_sem = nanstd(allmiceR2)/ sqrt(length(allmiceR2)) ; 
        y_sem = nanstd(allmiceSlope)/ sqrt(length(allmiceSlope)) ; 
        errorbarxy(nanmean(allmiceR2),mean(-allmiceSlope),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr

        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)  
        title(['-Slope & R2 Comparison of between Event Densities' newline '0-' num2str(firstfit_duration) 'h Fit (2 Fits, N=' num2str(length(allmiceR2)) ' mice)'],'FontSize',20) ;
    end


else    % ----- Mean Data across all sessions (if mean_across_mice == false) ----- :

    for q = 1:length(quantif_list) 

        data = quantif_list{q} ;
        twofitreg_coeff = vertcat(data.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,1)) ; % regression coeff with slope for the 1st fit only

        % Plot all sessions as crosses : 
        twofitR2 = cat(1,data.twofitR2{:}) ; 
        twofitR2_1 = twofitR2(:,1) ; 
        c = plot(cell2mat(twofitR2_1),-twofitreg_coeff_1 (:,1)','x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(nanmean(cell2mat(twofitR2_1)),nanmean(-twofitreg_coeff_1 (:,1)'),'.','Color',quantif_colors{q},'MarkerSize',45);
        x_sem = nanstd(cell2mat(twofitR2_1))/ sqrt(length(cell2mat(twofitR2_1))) ; 
        y_sem = nanstd(twofitreg_coeff_1 (:,1)')/ sqrt(length(twofitreg_coeff_1 (:,1)')) ; 
        errorbarxy(nanmean(cell2mat(twofitR2_1)),nanmean(-twofitreg_coeff_1 (:,1)'),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr

        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)    

        title(['-Slope & R2 Comparison of between Event Densities' newline '0-' num2str(firstfit_duration) 'h Fit (2 Fits, n=' num2str(length(cell2mat(twofitR2_1))) ' sessions)'],'FontSize',20) ;

    end 
    
end    



% ---------------------- Second Fit : after 'firstfit_duration' -------------------------- :

subplot(2,1,2),
hold on, 


if mean_across_mice   % ----- Mean Data across mice (if mean_across_mice == true) ----- :
     
    for q = 1:length(quantif_list)

        % 1) Extract data :
        
        quantif = quantif_list{q} ; 
        
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

        % 3) Plots :

        % Plot all sessions as crosses : 
        hold on,
        c = plot(allmiceR2,-allmiceSlope,'x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(nanmean(allmiceR2),nanmean(-allmiceSlope),'.','Color',quantif_colors{q},'MarkerSize',45);
        x_sem = nanstd(allmiceR2)/ sqrt(length(allmiceR2)) ; 
        y_sem = nanstd(allmiceSlope)/ sqrt(length(allmiceSlope)) ; 
        errorbarxy(nanmean(allmiceR2),mean(-allmiceSlope),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr

        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)  
        title(['-Slope & R2 Comparison of between Event Densities' newline num2str(firstfit_duration) 'h-end Fit (2 Fits, N=' num2str(length(allmiceR2)) ' mice)'],'FontSize',20) ;
    end


else    % ----- Mean Data across all sessions (if mean_across_mice == false) ----- :

    for q = 1:length(quantif_list) 

        data = quantif_list{q} ;
        twofitreg_coeff = vertcat(data.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
        twofitreg_coeff_2 = cell2mat(twofitreg_coeff(:,2)) ; % regression coeff with slope for the 1st fit only

        % Plot all sessions as crosses : 
        twofitR2 = cat(1,data.twofitR2{:}) ; 
        twofitR2_2 = twofitR2(:,2) ; 
        c = plot(cell2mat(twofitR2_2),-twofitreg_coeff_2 (:,1)','x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
        uistack(c,'bottom'); % put crosses in bakground

        % Plot mean of all sessions as dots : 
        plot(nanmean(cell2mat(twofitR2_2)),nanmean(-twofitreg_coeff_2 (:,1)'),'.','Color',quantif_colors{q},'MarkerSize',45);
        x_sem = nanstd(cell2mat(twofitR2_2))/ sqrt(length(cell2mat(twofitR2_2))) ; 
        y_sem = nanstd(twofitreg_coeff_2 (:,1)')/ sqrt(length(twofitreg_coeff_2 (:,1)')) ; 
        errorbarxy(nanmean(cell2mat(twofitR2_2)),nanmean(-twofitreg_coeff_2 (:,1)'),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ;  %arg = x,y,xerr,yerr,xerr,yerr

        xlim([-0.05,0.8]) ; 
        xlabel('mean R2') ; ylabel('mean (- Slope)') ;   
        legend(quantif_names,'Location','eastoutside') ; 
        set(gca,'FontSize',16)    

        title(['-Slope & R2 Comparison of between Event Densities' newline num2str(firstfit_duration) 'h-end Fit (2 Fits, n=' num2str(length(cell2mat(twofitR2_2))) ' sessions)'],'FontSize',20) ;

    end 
    
end    



% ----------- Save Plot ------------ :



if mean_across_mice
    suffix = 'MiceMean';
else
    suffix = 'SessionsMean';  
end 

% print(['HomeostasisComparison_SlopeR2_2Fit'  suffix num2str(quantif_choice)], '-dpng', '-r300') ; 
% print(['epsFigures/HomeostasisComparison_SlopeR2_2Fit'  suffix num2str(quantif_choice)], '-depsc') ; 
% % % Save zoomed plot : 
%  subplot(2,1,1),
%  xlim([-0.04 0.6]) ; ylim([-11.5 45.21]);
% % subplot(2,1,2),
% xlim([-0.04 0.6]) ; ylim([-11.5 45.21]);
% print(['HomeostasisComparison_SlopeR2_2Fit'  suffix  num2str(quantif_choice) '_zoom'], '-dpng', '-r300') ; 
% print(['epsFigures/HomeostasisComparison_SlopeR2_2Fit' suffix num2str(quantif_choice) '_zoom'], '-depsc') ; 

