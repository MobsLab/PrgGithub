%% AllHomeostasisComparisonPlot
%
% 01/05/2020  LP
%
% Script to compare homeostasis results from different quantifications : 
% SWA (bandpower 0.5-4Hz), Event Occupancy, Event Density.
%
% -> from previous generated data files
% SEE :
% ParcourQuantifHomeostasisBandpower
% ParcourQuantifHomeostasisOccupancy
% ParcourQuantifHomeostasisDensity


%% ----------------------------------------- LOAD FILES ----------------------------------------- :

wake_thresh = 20 ;

% Bandpower :
try
eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisBandpower_multifit' num2str(wake_thresh) '_afterREM1.mat']) % path if on lab computer
catch
load(['/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisBandpower_multifit' num2str(wake_thresh) '_afterREM1.mat']) % if on personal computer
end
SWA_res = Homeo_res ;

% Occupancy :
try
eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisOccupancy_multifit' num2str(wake_thresh) '_afterREM1.mat']) % path if on lab computer
catch
load(['/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisOccupancy_multifit' num2str(wake_thresh) '_afterREM1.mat']) % if on personal computer
end
Occupancy_res = Homeo_res ;

% Density :
try
eval(['load ' FolderDataLP_DeltaSpectral 'Data/ParcourQuantifHomeostasisDensity_multifit' num2str(wake_thresh) '_afterREM1.mat']) % path if on lab computer
cd([FolderDataLP_DeltaSpectral 'Results/Homeostasis'])
catch
load(['/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Data/ParcourQuantifHomeostasisDensity_multifit' num2str(wake_thresh) '_afterREM1.mat']) % if on personal computer
cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis')
end
Density_res = Homeo_res ;

clearvars -except SWA_res Occupancy_res Density_res




%% ----------------------------------------- Compare homeostasis results of SWA & occupancy (all events) ----------------------------------------- :


% --------------- GLOBAL FITS -------------- :

% All quantif : 

quantif_list = {SWA_res.PFCsup, Occupancy_res.DeltaWaves, Occupancy_res.DownStates, Occupancy_res.SupSlowWaves, Occupancy_res.DeepSlowWaves } ;
quantif_names = {'SWA', ['Delta Waves'], 'Down States', 'Sup Slow Waves', 'Deep Slow Waves' } ;
quantif_colors = {[0.8 0.6 0.2],[0 0.4 0.6]} ; 
x_occup = 2:length(quantif_list) ; % indices of occupancy quantif (for barplot color separation)
ylim_slope = [-3,25] ; ylim_r2 = [0,0.6] ; 



% Get mean and SEM of R2 and slope values, for each quantif  :

all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;
n_sessions = length(SWA_res.path) ;

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


% --- Barplots --- : 

figure,
sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' mice']) ; 


% R2 BARPLOT :

subplot(2,2,1),
% swa :
b_swa = bar(1,all_meanR2(1),'LineStyle','none') ; 
b_swa.FaceColor = quantif_colors{1} ;
hold on, errorbar(1,all_meanR2(1),all_semR2(1),all_semR2(1),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
% occupancy : 
b_occup = bar(x_occup,all_meanR2(x_occup),'LineStyle','none') ;
b_occup.FaceColor = quantif_colors{2} ;
errorbar(x_occup,all_meanR2(x_occup),all_semR2(x_occup),all_semR2(x_occup),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% legend & labels :
legend([b_swa,b_occup],{'SWA','Event Occupancy'});
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['R2, Global Fit'],'Fontsize',15) ;


% SLOPE BARPLOT :

subplot(2,2,3),
% swa :
b_swa = bar(1,-all_meanSlope(1),'LineStyle','none') ; 
b_swa.FaceColor = quantif_colors{1} ;
hold on, errorbar(1,-all_meanSlope(1),all_semSlope(1),all_semSlope(1),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
% occupancy :
b_occup = bar(x_occup,-all_meanSlope(x_occup),'LineStyle','none') ;
b_occup.FaceColor = quantif_colors{2} ;
errorbar(x_occup,-all_meanSlope(x_occup),all_semSlope(x_occup),all_semSlope(x_occup),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  

% legend & labels :
legend([b_swa,b_occup],{'SWA','Event Occupancy'});
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['- Slope, Global Fit'],'Fontsize',15) ;



% --------------- MULTIPLE FITS -------------- :



% Get mean and SEM of R2 and slope values, for each quantif  :

all_meanR2 = [] ;
all_meanR2diff = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semR2diff = [] ; 
all_semSlope = [] ;

n_sessions = length(SWA_res.path) ;

for i = 1:length(quantif_list)
    
    % store mean values of each session, for this quantif
    allsession_meanR2 = [] ; 
    allsession_meanR2diff = [] ; 
    allsession_meanSlope = [] ; 
    
    % Get mean values for each session : 
    for p=1:n_sessions
        
        % R2
        allsession_meanR2(p)=mean(cell2mat(quantif_list{i}.multiR2{p})) ; 

        % R2 diff :
        R2_diff = cell2mat(quantif_list{i}.multiR2{p})-cell2mat(quantif_list{i}.multiR2global{p}) ;
        allsession_meanR2diff(p) = mean(R2_diff) ;
        
        % Slope
        multicoeff = quantif_list{i}.multireg_coeff{p} ; 
        mean_multicoeff = mean(vertcat(multicoeff{1:length(multicoeff)}),1) ; 
        allsession_meanSlope(p) = mean_multicoeff(1) ; 
      
    end
    
    % R2
    all_meanR2(i) = mean(allsession_meanR2) ;
    all_semR2(i) = std(allsession_meanR2)/sqrt(n_sessions) ;
    % R2diff 
    all_meanR2diff(i) = mean(allsession_meanR2diff) ;
    all_semR2diff(i) = std(allsession_meanR2diff)/sqrt(n_sessions) ;
    % Slope
    all_meanSlope(i) = mean(allsession_meanSlope) ;
    all_semSlope(i) = std(allsession_meanSlope)/sqrt(n_sessions) ;
    
end




% ----- Barplots ----- : 


% R2 BARPLOT :

subplot(2,2,2),
% swa :
b_swa = bar(1,all_meanR2(1),'LineStyle','none') ; 
b_swa.FaceColor = quantif_colors{1} ;
hold on, errorbar(1,all_meanR2(1),all_semR2(1),all_semR2(1),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
% occupancy : 
b_occup = bar(x_occup,all_meanR2(x_occup),'LineStyle','none') ;
b_occup.FaceColor = quantif_colors{2} ;
errorbar(x_occup,all_meanR2(x_occup),all_semR2(x_occup),all_semR2(x_occup),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% legend & labels :
legend([b_swa,b_occup],{'SWA','Event Occupancy'});
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['R2, Multiple Fits'],'Fontsize',15) ;


% SLOPE BARPLOT :

subplot(2,2,4),
% swa :
b_swa = bar(1,-all_meanSlope(1),'LineStyle','none') ; 
b_swa.FaceColor = quantif_colors{1} ;
hold on, errorbar(1,-all_meanSlope(1),all_semSlope(1),all_semSlope(1),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  
% occupancy :
b_occup = bar(x_occup,-all_meanSlope(x_occup),'LineStyle','none') ;
b_occup.FaceColor = quantif_colors{2} ;
errorbar(x_occup,-all_meanSlope(x_occup),all_semSlope(x_occup),all_semSlope(x_occup),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ;  

% legend & labels :
legend([b_swa,b_occup],{'SWA','Event Occupancy'});
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['- Slope, Multiple Fits'],'Fontsize',15) ;



%cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis/QuantifComparison') ; print('AllHomeostasisComparisonPlot1_multifit20_afterREM1', '-dpng', '-r600');




%% ----------------------------------------- Compare homeostasis results of SWA & event occupancy or density (delta waves and down states) ----------------------------------------- :


% --------------- GLOBAL FITS -------------- :

% All quantif : 

quantif_list = {SWA_res.PFCsup, Occupancy_res.DeltaWaves, Density_res.DeltaWaves, Occupancy_res.DownStates, Density_res.DownStates} ;
quantif_names = {'SWA', 'Delta Waves', 'Delta Waves', 'Down States', 'Down States' } ;
quantif_colors = {[0.8 0.6 0.2],[0 0.4 0.6],[0.2 0.6 0.6]} ; 
x_occup = [2 4] ; % indices of occupancy quantif (for barplot color separation)
x_dens = [3 5] ; % indices of density quantif (for barplot color separation)
ylim_slope = [-3,25] ; ylim_r2 = [0,0.6] ; 



% Get mean and SEM of R2 and slope values, for each quantif  :

all_meanR2 = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semSlope = [] ;
n_sessions = length(SWA_res.path) ;

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


% --- Barplots --- : 

figure,
sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' mice']) ; 


% R2 BARPLOT :

% Barplot
subplot(2,2,1),
b = bar(1:5,all_meanR2,'LineStyle','none') ; 
hold on, errorbar(1:5,all_meanR2,all_semR2,all_semR2,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% Set colors
b.FaceColor = 'flat';
b.CData(1,:) = quantif_colors{1} ;
b.CData(2,:) = quantif_colors{2} ; b.CData(4,:) = quantif_colors{2} ;
b.CData(3,:) = quantif_colors{3} ; b.CData(5,:) = quantif_colors{3} ;
% Set legend (invisible fake plots to get handles)
b1 = bar(1,0,'LineStyle','none'); b1.FaceColor = quantif_colors{1} ;
b2 = bar(2,0,'LineStyle','none'); b2.FaceColor = quantif_colors{2} ;
b3 = bar(3,0,'LineStyle','none'); b3.FaceColor = quantif_colors{3} ;
legend([b1,b2,b3],{'SWA','Event Occupancy','Event Density'});
% Labels :
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['R2, Global Fit'],'Fontsize',15) ;


% SLOPE BARPLOT :

% Barplot
subplot(2,2,3),
b = bar(1:5,-all_meanSlope,'LineStyle','none') ; 
hold on, errorbar(1:5,-all_meanSlope,all_semSlope,all_semSlope,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% Set colors
b.FaceColor = 'flat';
b.CData(1,:) = quantif_colors{1} ;
b.CData(2,:) = quantif_colors{2} ; b.CData(4,:) = quantif_colors{2} ;
b.CData(3,:) = quantif_colors{3} ; b.CData(5,:) = quantif_colors{3} ;
% Set legend (invisible fake plots to get handles)
b1 = bar(1,0,'LineStyle','none'); b1.FaceColor = quantif_colors{1} ;
b2 = bar(2,0,'LineStyle','none'); b2.FaceColor = quantif_colors{2} ;
b3 = bar(3,0,'LineStyle','none'); b3.FaceColor = quantif_colors{3} ;
legend([b1,b2,b3],{'SWA','Event Occupancy','Event Density'});
% Labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['- Slope, Global Fit'],'Fontsize',15) ;




% --------------- MULTIPLE FITS -------------- :



% Get mean and SEM of R2 and slope values, for each quantif  :

all_meanR2 = [] ;
all_meanR2diff = [] ;
all_meanSlope = [] ;
all_semR2 = [] ;
all_semR2diff = [] ; 
all_semSlope = [] ;

n_sessions = length(SWA_res.path) ;

for i = 1:length(quantif_list)
    
    % store mean values of each session, for this quantif
    allsession_meanR2 = [] ; 
    allsession_meanR2diff = [] ; 
    allsession_meanSlope = [] ; 
    
    % Get mean values for each session : 
    for p=1:n_sessions
        
        % R2
        allsession_meanR2(p)=mean(cell2mat(quantif_list{i}.multiR2{p})) ; 

        % R2 diff :
        R2_diff = cell2mat(quantif_list{i}.multiR2{p})-cell2mat(quantif_list{i}.multiR2global{p}) ;
        allsession_meanR2diff(p) = mean(R2_diff) ;
        
        % Slope
        multicoeff = quantif_list{i}.multireg_coeff{p} ; 
        mean_multicoeff = mean(vertcat(multicoeff{1:length(multicoeff)}),1) ; 
        allsession_meanSlope(p) = mean_multicoeff(1) ; 
      
    end
    
    % R2
    all_meanR2(i) = mean(allsession_meanR2) ;
    all_semR2(i) = std(allsession_meanR2)/sqrt(n_sessions) ;
    % R2diff 
    all_meanR2diff(i) = mean(allsession_meanR2diff) ;
    all_semR2diff(i) = std(allsession_meanR2diff)/sqrt(n_sessions) ;
    % Slope
    all_meanSlope(i) = mean(allsession_meanSlope) ;
    all_semSlope(i) = std(allsession_meanSlope)/sqrt(n_sessions) ;
    
end




% ----- Barplots ----- : 



% R2 BARPLOT :

% Barplot
subplot(2,2,2),
b = bar(1:5,all_meanR2,'LineStyle','none') ; 
hold on, errorbar(1:5,all_meanR2,all_semR2,all_semR2,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% Set colors
b.FaceColor = 'flat';
b.CData(1,:) = quantif_colors{1} ;
b.CData(2,:) = quantif_colors{2} ; b.CData(4,:) = quantif_colors{2} ;
b.CData(3,:) = quantif_colors{3} ; b.CData(5,:) = quantif_colors{3} ;
% Set legend (invisible fake plots to get handles)
b1 = bar(1,0,'LineStyle','none'); b1.FaceColor = quantif_colors{1} ;
b2 = bar(2,0,'LineStyle','none'); b2.FaceColor = quantif_colors{2} ;
b3 = bar(3,0,'LineStyle','none'); b3.FaceColor = quantif_colors{3} ;
legend([b1,b2,b3],{'SWA','Event Occupancy','Event Density'});
% Labels :
ylabel('R2 (linear regression)') ; ylim(ylim_r2) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);
title(['R2, Multiple Fits'],'Fontsize',15) ;


% SLOPE BARPLOT :

% Barplot
subplot(2,2,4),
b = bar(1:5,-all_meanSlope,'LineStyle','none') ; 
hold on, errorbar(1:5,-all_meanSlope,all_semSlope,all_semSlope,'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off') ; 
% Set colors
b.FaceColor = 'flat';
b.CData(1,:) = quantif_colors{1} ;
b.CData(2,:) = quantif_colors{2} ; b.CData(4,:) = quantif_colors{2} ;
b.CData(3,:) = quantif_colors{3} ; b.CData(5,:) = quantif_colors{3} ;
% Set legend (invisible fake plots to get handles)
b1 = bar(1,0,'LineStyle','none'); b1.FaceColor = quantif_colors{1} ;
b2 = bar(2,0,'LineStyle','none'); b2.FaceColor = quantif_colors{2} ;
b3 = bar(3,0,'LineStyle','none'); b3.FaceColor = quantif_colors{3} ;
legend([b1,b2,b3],{'SWA','Event Occupancy','Event Density'});
% Labels :
ylabel('- Slope (linear regression)') ; ylim(ylim_slope) ; 
set(gca,'XTick',1:length(all_meanR2),'XtickLabels',quantif_names);
xtickangle(30);

title(['- Slope, Multiple Fits'],'Fontsize',15) ;



%cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis/QuantifComparison') ; print('AllHomeostasisComparisonPlot2_multifit20_afterREM1', '-dpng', '-r600');


