%% ReportFig_HomeostasisDensity2Fit_allSW
%
% 05/06/2020
%
% To plot mean Spiking Rate across mice for all slow wave types. 


clear
PathToSave = '/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/M2ReportFigures/' ; 
%set(gcf,'DefaultFigureWindowStyle','normal')
% ----------------------------------------- CHOOSE DATA ----------------------------------------- :

afterREM1 = false ; % if true, homeostasis fits only after 1st episode of REM
firstfit_duration = 3 ; % duration of the first fit, in h 

events_subset = 'downcooccur' ; 
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



%% ----------------------------------------- MEAN PLOT for all sessions : 2 FITS ----------------------------------------- :


% Choose sessions to be plotted :
ToPlot = 1:length(Homeo_res.path) ; % Plot all sessions
%ToPlot = [1 3] ; % Choose sessions to plot

fit_colors = {[0.8 0.6 0.2],[0.8 0.4 0.4]} ;
subplots_order = [1 3 7 9 2 8 4 6] ; 
yl = [20 400] ; 
%yl = [20 320] ; 

% -------------------  For first plot : all slow wave types  -------------------  : 

all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
all_slowwaves_names = {'Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 



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
        d = plot(t_max,d_max,'.','MarkerSize',7,'Color', [0.7 0.7 0.7]); % grey dots for all local maxima from all sessions
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

    xlabel('ZT Time (hours)'), ylabel('Normalized SW Density (%)');
    title(['Type ' num2str(type)],'FontSize',12) ;
    mean_reg_coeff = mean(vertcat(Homeo.reg_coeff{ToPlot})) ; % mean slope coeff (linear regression)
    legend([d,l1,l2],{'Local Maxima','1st fit : 0-3h','2nd fit : 3h-end'},'FontSize',11,'EdgeColor',[1 1 1])  % mean R2diff value
    ylim(yl) ; xlim([8.5 21]) ; yticks([100 200 300 400]);
    
end

set(gcf,'WindowStyle','normal')
set(gcf, 'Position',  [1, 1, 1060, 785])

% Save figure : 
set(gcf,'color','w'); % change figure background to white
set(gcf, 'InvertHardcopy', 'off') % to prevent the edges from going black again when saving figures
print([PathToSave 'HomeostasisDensity2Fit_allSW_' description], '-dpng', '-r300') ; 
