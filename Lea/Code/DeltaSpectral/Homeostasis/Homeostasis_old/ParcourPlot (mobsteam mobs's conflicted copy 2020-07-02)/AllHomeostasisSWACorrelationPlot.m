%% AllHomeostasisSWACorrelationPlot
%
% 04/05/2020  LP
%
% Script to plot correlation of the homeostasis slope for different 
% quantifications (ex. occupancy for different events) with homeostasis 
% slope for SWA. 
%
% -> Global Fit and Multiple Fits (separately)

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

clearvars -except SWA_res Occupancy_res
n_sessions = length(SWA_res.path) ;



%% ----------------------------------------- CORRELATION QUANTIF : Global Fit  ----------------------------------------- :

evt_names = {'Delta Waves', 'Sup Slow Waves', 'Down States', 'Deep Slow Waves'} ;
evt_colors = {[0.9 0.6 0.1],[0.25 0.7 0.9],[0.75 0.3 0.1],[0.1 0.5 0.7]} ; 
evt_subplot = {[1 2],[3 4],[6 7],[8 9]} ; 

% Get slope values for all homeostasis quantifications : 

swa_slopes = vertcat(SWA_res.PFCsup.reg_coeff{1:n_sessions}); swa_slopes = swa_slopes(:,1);
deltaoccup_slopes = vertcat(Occupancy_res.DeltaWaves.reg_coeff{1:n_sessions}); deltaoccup_slopes = deltaoccup_slopes(:,1) ; 
downoccup_slopes = vertcat(Occupancy_res.DownStates.reg_coeff{1:n_sessions}); downoccup_slopes = downoccup_slopes(:,1) ; 
supslowoccup_slopes = vertcat(Occupancy_res.SupSlowWaves.reg_coeff{1:n_sessions}); supslowoccup_slopes = supslowoccup_slopes(:,1) ; 
deepslowoccup_slopes = vertcat(Occupancy_res.DeepSlowWaves.reg_coeff{1:n_sessions}); deepslowoccup_slopes = deepslowoccup_slopes(:,1) ; 

evt_slopes = {deltaoccup_slopes,supslowoccup_slopes,downoccup_slopes,deepslowoccup_slopes} ; 
all_corrcoef = [] ;


% Plot correlation plots (slope value as a function of swa slope value), for each session : 

figure, 
sgtitle(['Homeostasis Comparison to SWA, n = ' num2str(n_sessions) ' mice' newline '(Global Fits)']) ; 
yl = [-30 15] ; 
hold on

for i = 1:length(evt_names) 

    subplot(2,5,evt_subplot{i}),
    hold on
    plot(swa_slopes,evt_slopes{i},'.','MarkerSize',11,'Color',evt_colors{i}) ;
    yline(0,'--','Color',[0.5 0.5 0.5]) ; 
    title(evt_names{i}) ;  ylim(yl) ;
    xlabel('SWA Slope') ; 
    if i == 1 | i == 3 
        ylabel('Event Occupancy Slope') ; 
    end
    p = plot(xlim,xlim,'Color',[0.5 0.5 0.5]) ; 
    legend(p,{'x = y'},'Location','southeast','TextColor',[0.5 0.5 0.5]); legend boxoff ;
    % Get Pearson Correlation Coeff + Plot : 
    all_corrcoef(i) = getfield(corrcoef(swa_slopes,evt_slopes{i}),{2}) ;
    subplot(2,5,[5 10]),
    hold on,
    plot(0.5,all_corrcoef(i),'*','MarkerSize',8,'MarkerEdgeColor',evt_colors{i})
    text(0.8,all_corrcoef(i),sprintf('r = %.3g',all_corrcoef(i)),'Color',evt_colors{i})
end

subplot(2,5,[5 10]),
xlim([0,2]) ; title(['Pearson Correlation' newline 'Coefficient' newline]) ; 
set(gca,'Xtick',[],'XtickLabel','');
legend(evt_names, 'Location','northoutside')


% SAVE PLOT : 
% cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/DeltaSpectral/Results/Homeostasis/QuantifComparison') ; 
% print('AllHomeostasisSWACorrelationPlot_afterREM1', '-dpng', '-r600');
