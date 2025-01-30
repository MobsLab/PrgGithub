
%% HomeostasisComparison_SlopeR2_EventCorrelationPlot
%
% 30/05/2020 LP
%
% Plot Correlation between Delta/Down Co-occurrence and Slope or R2 on 
% mean event density homeostasis for all slow wave types. 
% -> "Homeostasis" computed here through linear regression of local maxima 
% on event density (delta, slow waves, down states). 
%
% -> global fit
%
% SEE : 
% ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypesPlot.m (need
% to run first to extract homeostasis info and create the .mat file)

clear

% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 

% ----------------------------------------- LOAD DATA ----------------------------------------- :

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


% ----------------------------------------- PLOTTING PARAMETERS ----------------------------------------- :

quantif_data = {Homeo_res.DownStates,Homeo_res.DiffDeltaWaves,Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
quantif_names = {'Down States', 'Delta Waves','Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
quantif_colors = {[0 0 0],[0.4 0.4 0.4],[1 0.6 0],[1 0.4 0],[1 0 0.4],[0.6 0.2 0.6],[0.2 0.4 0.6],[0 0.6 0.4],[0.2 0.4 0],[0 0.2 0]} ; 


%% ----------------------------------------- GLOBAL FIT & DELTA WAVES ----------------------------------------- :

figure,


% SLOPE AND DELTA PROP :

subplot(2,1,1),
hold on,

% For each quantif :
for q = 1:length(quantif_data) 
    
    data = quantif_data{q} ;
    reg_coeff = vertcat(data.reg_coeff{:}) ; % regression coeff with slope
    R2 = cell2mat(data.R2) ; % R2 values 
    deltaprop = cell2mat(data.NextToDeltaProp) ; 
    
    % Plot all sessions as crosses : 
    c = plot(deltaprop,-reg_coeff(:,1)','x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
    uistack(c,'bottom'); % put crosses in bakground
    
    % Plot mean of all sessions as dots : 
    plot(mean(deltaprop),mean(-reg_coeff(:,1)'),'.','Color',quantif_colors{q},'MarkerSize',45);
    x_sem = nanstd(deltaprop)/ sqrt(length(deltaprop)) ; 
    y_sem = nanstd(reg_coeff(:,1)')/ sqrt(length(reg_coeff(:,1)')) ; 
    if q ~= 2
        errorbarxy(mean(deltaprop),mean(-reg_coeff(:,1)'),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) %arg = x,y,xerr,yerr,xerr,yerr
    end
end 
    
xlim([-5,105]) ; 
xlabel('mean proportion next to delta waves (<250ms)') ; ylabel('mean (- Slope)') ;   
legend(quantif_names,'Location','eastoutside') ; 
set(gca,'FontSize',16)    

title(['-Slope & Delta Prop Correlation' newline 'Global Fit (n=' num2str(length(R2)) ' sessions)'],'FontSize',20) ;



% R2 AND DELTA PROP :

subplot(2,1,2),
hold on,

% For each quantif :
for q = 1:length(quantif_data) 
    
    data = quantif_data{q} ;
    reg_coeff = vertcat(data.reg_coeff{:}) ; % regression coeff with slope
    R2 = cell2mat(data.R2) ; % R2 values 
    deltaprop = cell2mat(data.NextToDeltaProp) ; 
    
    % Plot all sessions as crosses : 
    c = plot(deltaprop,R2,'x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
    uistack(c,'bottom'); % put crosses in bakground
    
    % Plot mean of all sessions as dots : 
    plot(mean(deltaprop),mean(R2),'.','Color',quantif_colors{q},'MarkerSize',45);
    x_sem = nanstd(deltaprop)/ sqrt(length(deltaprop)) ; 
    y_sem = nanstd(R2)/ sqrt(length(R2)) ; 
    if q ~= 2
        errorbarxy(mean(deltaprop),mean(R2),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr
    end
end 
    
xlim([-5,105]) ; 
xlabel('mean proportion next to delta waves (<250ms)') ; ylabel('mean R2') ;   
legend(quantif_names,'Location','eastoutside') ; 
set(gca,'FontSize',16)    

title(['R2 & Delta Prop Correlation' newline 'Global Fit (n=' num2str(length(R2)) ' sessions)'],'FontSize',20) ;

%Save Plot : 
print('HomeostasisComparison_SlopeR2_DeltaCorrelationPlot', '-dpng', '-r300') ; 
print(['epsFigures/HomeostasisComparison_SlopeR2_DeltaCorrelationPlot'], '-depsc') ; 


%% ----------------------------------------- GLOBAL FIT & DOWN STATES ----------------------------------------- :

figure,


% SLOPE AND DOWN PROP :

subplot(2,1,1),
hold on,

% For each quantif :
for q = 1:length(quantif_data) 
    
    data = quantif_data{q} ;
    reg_coeff = vertcat(data.reg_coeff{:}) ; % regression coeff with slope
    R2 = cell2mat(data.R2) ; % R2 values 
    downprop = cell2mat(data.DownCooccurProp) ; 
    
    % Plot all sessions as crosses : 
    c = plot(downprop,-reg_coeff(:,1)','x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
    uistack(c,'bottom'); % put crosses in bakground
    
    % Plot mean of all sessions as dots : 
    plot(mean(downprop),mean(-reg_coeff(:,1)'),'.','Color',quantif_colors{q},'MarkerSize',45);
    x_sem = nanstd(downprop)/ sqrt(length(downprop)) ; 
    y_sem = nanstd(reg_coeff(:,1)')/ sqrt(length(reg_coeff(:,1)')) ; 
    if q ~= 1
        errorbarxy(mean(downprop),mean(-reg_coeff(:,1)'),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) %arg = x,y,xerr,yerr,xerr,yerr
    end
end 
    
xlim([-5,105]) ; 
xlabel('mean proportion co-occurring with down states') ; ylabel('mean (- Slope)') ;   
legend(quantif_names,'Location','eastoutside') ; 
set(gca,'FontSize',16)    

title(['-Slope & Down Prop Correlation' newline 'Global Fit (n=' num2str(length(R2)) ' sessions)'],'FontSize',20) ;


% R2 AND DOWN PROP :

subplot(2,1,2),
hold on,

% For each quantif :
for q = 1:length(quantif_data) 
    
    data = quantif_data{q} ;
    reg_coeff = vertcat(data.reg_coeff{:}) ; % regression coeff with slope
    R2 = cell2mat(data.R2) ; % R2 values 
    downprop = cell2mat(data.DownCooccurProp) ; 
    
    % Plot all sessions as crosses : 
    c = plot(downprop,R2,'x','Color',quantif_colors{q},'MarkerSize',20,'HandleVisibility','off');
    uistack(c,'bottom'); % put crosses in bakground
    
    % Plot mean of all sessions as dots : 
    plot(mean(downprop),mean(R2),'.','Color',quantif_colors{q},'MarkerSize',45);
    x_sem = nanstd(downprop)/ sqrt(length(downprop)) ; 
    y_sem = nanstd(R2)/ sqrt(length(R2)) ; 
    if q ~= 1
        errorbarxy(mean(downprop),mean(R2),x_sem,y_sem,x_sem,y_sem,'Color',quantif_colors{q},'LineWidth',2) ; %arg = x,y,xerr,yerr,xerr,yerr
    end
end 
    
xlim([-5,105]) ; 
xlabel('mean proportion co-occurring with down states') ; ylabel('mean R2') ;   
legend(quantif_names,'Location','eastoutside') ; 
set(gca,'FontSize',16)    

title(['R2 & Down Prop Correlation' newline 'Global Fit (n=' num2str(length(R2)) ' sessions)'],'FontSize',20) ;


%Save Plot : 
print('HomeostasisComparison_SlopeR2_DownCorrelationPlot', '-dpng', '-r300') ; 
print(['epsFigures/HomeostasisComparison_SlopeR2_DownCorrelationPlot'], '-depsc') ; 
