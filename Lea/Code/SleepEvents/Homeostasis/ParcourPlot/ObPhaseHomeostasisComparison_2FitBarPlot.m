
%% ObPhaseHomeostasisComparison_2FitBarPlot
%
% 01/06/2020  LP
%
% Script to plot bar plots with R2 and -Slope values, from event density
% for slow waves in phase or out of phase with OB. 
%
% -> Mean values across sessions.
% -> Values with Mice x SWtype for each quantification are stored in 'ForStats' structure

%% LOAD DATA  : 

clear 

mean_across_mice = true ; % if true, mean across mice. if false, across sessions.
firstfit_duration = 3 ; % duration of the first fit, in h 

% ----------------------------------------- LOAD DATA ----------------------------------------- :

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Data/Homeostasis/'])
end

eval(['load ParcourQuantif2FitHomeostasisDensity_AllSlowWaveTypes_ObPhase_first' num2str(firstfit_duration) 'h_.mat']) ; 

try cd('/Users/leaprunier/Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/ObPhase')
catch cd([FolderDropBox 'Dropbox/Mobs_member/LeaPrunier/SleepEvents/Results/Homeostasis/Density_2fit/ObPhase'])
end


% --------- Get mice info ---------- :

n_mice = length(unique(Homeo_res_all.name)) ;
[mice_list, ~, mice_ix] = unique(Homeo_res_all.name) ; 


% --------------- Data ---------------- :


all_data = {Homeo_res_all, Homeo_res_inphase, Homeo_res_outphase } ; 
phase_colors = {[0 0.2 0.4],[1 0.2 0.2],[1 0.6 0]} ; 

all_slowwaves_names = {'Slow Waves 1', 'Slow Waves 2', 'Slow Waves 3','Slow Waves 4', 'Slow Waves 5', 'Slow Waves 6','Slow Waves 7', 'Slow Waves 8'} ; 
subplots_order = [1 3 7 9 2 8 4 6] ; 
mean_across_mice = true ; 




%% ----------------------------------------- MEAN PLOT for all sessions : GLOBAL FIT ----------------------------------------- :

yl_R2 = [0 0.7] ; 
yl_Slope = [0 25] ; 


figure,

for ph = 1:length(all_data) % For each group of slow waves (all / in phase / out of phase...)

    Homeo_res = all_data{ph} ; 
    all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
    
    
    % ----------------------- Get mean and SEM of R2 and slope values, for each sw type ----------------------- :

    all_meanR2 = [] ;
    all_meanSlope = [] ;
    all_semR2 = [] ;
    all_semSlope = [] ;
    n_sessions = length(Homeo_res.path) ;
    
    
    if mean_across_mice   % ----- Mean Data across mice (if mean_across_mice == true) ----- :

        for i = 1:length(all_slowwaves)

            % 1) Extract data :
            allR2 = cell2mat(all_slowwaves{i}.R2);
            allregcoeff = vertcat(all_slowwaves{i}.reg_coeff{:}) ;
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

        for i = 1:length(all_slowwaves)

            % R2
            all_meanR2(i) = mean(cell2mat(all_slowwaves{i}.R2)) ;
            all_semR2(i) = std(cell2mat(all_slowwaves{i}.R2))/sqrt(n_sessions) ;
            % Slope
            meanregcoeff = mean(vertcat(all_slowwaves{i}.reg_coeff{1:n_sessions})) ;
            all_meanSlope(i) = meanregcoeff(1) ;
            semregcoeff = std(vertcat(all_slowwaves{i}.reg_coeff{1:n_sessions}))/sqrt(n_sessions) ;
            all_semSlope(i) = semregcoeff(1) ;

        end
    end
    
    
    
    
    % ------------------------- BARPLOTS -------------------------- : 
    

    for type = 1:length(all_slowwaves) % For each slow wave type

        subplot(3,3,subplots_order(type)),
        title(['Type ' num2str(type)]) 
        hold on,

        % R2 BARPLOT :
        hold on,
        yyaxis left ; 
        b = bar(ph,all_meanR2(type),'LineStyle','none','FaceColor',phase_colors{ph}); 
        errorbar(ph,all_meanR2(type),all_semR2(type),all_semR2(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(ph,all_meanR2(type)+all_semR2(type)+0.04,sprintf('%.2g',all_meanR2(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_R2) ; ylabel('Mean R2') ; 
        phase_handle{ph} = b ; 
        
        % Slope BARPLOT :
        hold on,
        yyaxis right ; 
        b = bar(4+ph,-all_meanSlope(type),'LineStyle','none','FaceColor',phase_colors{ph},'HandleVisibility','off'); 
        errorbar(4+ph,-all_meanSlope(type),all_semSlope(type),all_semSlope(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(4+ph,-all_meanSlope(type)+all_semSlope(type)+2,sprintf('%.2g',all_meanSlope(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_Slope) ; ylabel('Mean -Slope')
        
        ax = gca; ax.YAxis(1).Color = [0 0 0];
        ax = gca; ax.YAxis(2).Color = [0 0 0];
        
        set(gca,'Xtick',[2 6], 'XTickLabel',{'R2','Slope'},'FontSize',12) ; box on ;
        
        if ph == 3
            legend({'all SW','In Phase','Out of Phase'},'Location','northoutside','Orientation','horizontal') ; legend box off ; 
        end
    end
        
          
end

subplot(3,3,5),
text(0.5,0.7,'SW Density Homeostasis','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.5,'Mean Global Fit','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.3,'Slow Waves sorted by OB phase','FontSize',18,'HorizontalAlignment','center'), axis off

% Title :
if mean_across_mice
    sgtitle(['Homeostasis Comparison, N = ' num2str(n_mice) ' mice']) ; 
else
    sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' sessions']) ; 
end


% SAVE PLOT : 

if mean_across_mice
    print(['BarPlots/ObPhaseHomeostasisComparison_GlobalFitBarPlot_MiceMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_GlobalFitBarPlot_MiceMean'], '-depsc') ; 
else
    print(['BarPlots/ObPhaseHomeostasisComparison_GlobalFitBarPlot_SessionsMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_GlobalFitBarPlot_SessionsMean'], '-depsc') ; 
end




%% ----------------------------------------- MEAN PLOT for all sessions : 2 FIT 0-3H ----------------------------------------- :

yl_R2 = [0 0.7] ; 
yl_Slope = [0 50] ; 


figure,

for ph = 1:length(all_data) % For each group of slow waves (all / in phase / out of phase...)

    Homeo_res = all_data{ph} ; 
    all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
    
    
    % ----------------------- Get mean and SEM of R2 and slope values, for each sw type ----------------------- :

    all_meanR2 = [] ;
    all_meanSlope = [] ;
    all_semR2 = [] ;
    all_semSlope = [] ;
    n_sessions = length(Homeo_res.path) ;


    if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

        for i = 1:length(all_slowwaves)

            quantif = all_slowwaves{i} ; 

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
            all_meanR2(i) = nanmean(allmiceR2) ; % R2 n튷 = mean R2 across mice for slow wave n튷
            all_semR2(i) = nanstd(allmiceR2)/sqrt(length(allmiceR2)) ;
                % Slope
            all_meanSlope(i) = nanmean(allmiceSlope) ;
            all_semSlope(i) = nanstd(allmiceSlope)/sqrt(length(allmiceSlope)) ;

        end


    else   % ----- Data across all sessions (if mean_across_mice == false) ----- :

        for i = 1:length(all_slowwaves)

            quantif = all_slowwaves{i} ; 
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


    % ------------------------- BARPLOTS -------------------------- : 
    

    for type = 1:length(all_slowwaves) % For each slow wave type

        subplot(3,3,subplots_order(type)),
        title(['Type ' num2str(type)]) 
        hold on,

        % R2 BARPLOT :
        hold on,
        yyaxis left ; 
        b = bar(ph,all_meanR2(type),'LineStyle','none','FaceColor',phase_colors{ph}); 
        errorbar(ph,all_meanR2(type),all_semR2(type),all_semR2(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(ph,all_meanR2(type)+all_semR2(type)+0.04,sprintf('%.2g',all_meanR2(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_R2) ; ylabel('Mean R2') ; 
        phase_handle{ph} = b ; 
        
        % Slope BARPLOT :
        hold on,
        yyaxis right ; 
        b = bar(4+ph,-all_meanSlope(type),'LineStyle','none','FaceColor',phase_colors{ph},'HandleVisibility','off'); 
        errorbar(4+ph,-all_meanSlope(type),all_semSlope(type),all_semSlope(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(4+ph,-all_meanSlope(type)+all_semSlope(type)+5,sprintf('%.2g',all_meanSlope(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_Slope) ; ylabel('Mean -Slope')
        
        ax = gca; ax.YAxis(1).Color = [0 0 0];
        ax = gca; ax.YAxis(2).Color = [0 0 0];
        
        set(gca,'Xtick',[2 6], 'XTickLabel',{'R2','Slope'},'FontSize',12) ; box on ;
        
        if ph == 3
            legend({'all SW','In Phase','Out of Phase'},'Location','northoutside','Orientation','horizontal') ; legend box off ; 
        end
    end
        
          
end

subplot(3,3,5),
text(0.5,0.7,'SW Density Homeostasis','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.5,'Mean 2 Fit : 0-3h','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.3,'Slow Waves sorted by OB phase','FontSize',18,'HorizontalAlignment','center'), axis off

% Title :
if mean_across_mice
    sgtitle(['Homeostasis Comparison, N = ' num2str(n_mice) ' mice']) ; 
else
    sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' sessions']) ; 
end



% SAVE PLOT : 

if mean_across_mice
    print(['BarPlots/ObPhaseHomeostasisComparison_2FitBarPlot1_MiceMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_2FitBarPlot1_MiceMean'], '-depsc') ; 
else
    print(['BarPlots/ObPhaseHomeostasisComparison_2FitBarPlot1_SessionsMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_2FitBarPlot1_SessionsMean'], '-depsc') ; 
end



%% ----------------------------------------- MEAN PLOT for all sessions : 2 FIT 3H-END ----------------------------------------- :

yl_R2 = [0 0.7] ; 
yl_Slope = [0 50] ; 


figure,

for ph = 1:length(all_data) % For each group of slow waves (all / in phase / out of phase...)

    Homeo_res = all_data{ph} ; 
    all_slowwaves = {Homeo_res.SlowWaves1,Homeo_res.SlowWaves2,Homeo_res.SlowWaves3,Homeo_res.SlowWaves4,Homeo_res.SlowWaves5,Homeo_res.SlowWaves6,Homeo_res.SlowWaves7,Homeo_res.SlowWaves8} ;
    
    
    % ----------------------- Get mean and SEM of R2 and slope values, for each sw type ----------------------- :

    all_meanR2 = [] ;
    all_meanSlope = [] ;
    all_semR2 = [] ;
    all_semSlope = [] ;
    n_sessions = length(Homeo_res.path) ;


    if mean_across_mice % ----- Mean Data across mice (if mean_across_mice == true) ----- :

        for i = 1:length(all_slowwaves)

            quantif = all_slowwaves{i} ; 

            % 1) Extract data :
            twofitR2 = cat(1,quantif.twofitR2{:}) ;
            allR2 = cell2mat(twofitR2(:,2)) ; % keep only R2 for the 1st fit
            twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
            twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,2)) ; % keep only regcoeff for the 1st fit
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
            all_meanR2(i) = nanmean(allmiceR2) ; % R2 n튷 = mean R2 across mice for slow wave n튷
            all_semR2(i) = nanstd(allmiceR2)/sqrt(length(allmiceR2)) ;
                % Slope
            all_meanSlope(i) = nanmean(allmiceSlope) ;
            all_semSlope(i) = nanstd(allmiceSlope)/sqrt(length(allmiceSlope)) ;

        end


    else   % ----- Data across all sessions (if mean_across_mice == false) ----- :

        for i = 1:length(all_slowwaves)

            quantif = all_slowwaves{i} ; 
            % R2
            twofitR2 = cat(1,quantif.twofitR2{:}) ;
            all_meanR2(i) = nanmean(cell2mat(twofitR2(:,2))) ;
            all_semR2(i) = nanstd(cell2mat(twofitR2(:,2)))/sqrt(n_sessions) ;
            % Slope
            twofitreg_coeff = vertcat(quantif.twofitreg_coeff{:}) ; % regression coeff with slope for the 2 fits
            twofitreg_coeff_1 = cell2mat(twofitreg_coeff(:,2)) ; % regression coeff with slope for the 1st fit only
            all_meanSlope(i) = nanmean(twofitreg_coeff_1(:,1));
            all_semSlope(i) = nanstd(twofitreg_coeff_1(:,1))/sqrt(n_sessions) ;
        end

    end


    % ------------------------- BARPLOTS -------------------------- : 
    

    for type = 1:length(all_slowwaves) % For each slow wave type

        subplot(3,3,subplots_order(type)),
        title(['Type ' num2str(type)]) 
        hold on,

        % R2 BARPLOT :
        hold on,
        yyaxis left ; 
        b = bar(ph,all_meanR2(type),'LineStyle','none','FaceColor',phase_colors{ph}); 
        errorbar(ph,all_meanR2(type),all_semR2(type),all_semR2(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(ph,all_meanR2(type)+all_semR2(type)+0.04,sprintf('%.2g',all_meanR2(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_R2) ; ylabel('Mean R2') ; 
        phase_handle{ph} = b ; 
        
        % Slope BARPLOT :
        hold on,
        yyaxis right ; 
        b = bar(4+ph,-all_meanSlope(type),'LineStyle','none','FaceColor',phase_colors{ph},'HandleVisibility','off'); 
        errorbar(4+ph,-all_meanSlope(type),all_semSlope(type),all_semSlope(type),'Color',[0 0 0], 'LineStyle','none','HandleVisibility','off','Marker','none') ; 
        text(4+ph,-all_meanSlope(type)+all_semSlope(type)+5,sprintf('%.2g',all_meanSlope(type)),'HorizontalAlignment','center','Color',phase_colors{ph},'FontSize',12) ;  
        ylim(yl_Slope) ; ylabel('Mean -Slope')
        
        ax = gca; ax.YAxis(1).Color = [0 0 0];
        ax = gca; ax.YAxis(2).Color = [0 0 0];
        
        set(gca,'Xtick',[2 6], 'XTickLabel',{'R2','Slope'},'FontSize',12) ; box on ;
        
        if ph == 3
            legend({'all SW','In Phase','Out of Phase'},'Location','northoutside','Orientation','horizontal') ; legend box off ; 
        end
    end
        
          
end

subplot(3,3,5),
text(0.5,0.7,'SW Density Homeostasis','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.5,'Mean 2 Fit : 3h-end','FontSize',22,'HorizontalAlignment','center'), axis off
text(0.5,0.3,'Slow Waves sorted by OB phase','FontSize',18,'HorizontalAlignment','center'), axis off

% Title :
if mean_across_mice
    sgtitle(['Homeostasis Comparison, N = ' num2str(n_mice) ' mice']) ; 
else
    sgtitle(['Homeostasis Comparison, n = ' num2str(n_sessions) ' sessions']) ; 
end



% SAVE PLOT : 

if mean_across_mice
    print(['BarPlots/ObPhaseHomeostasisComparison_2FitBarPlot2_MiceMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_2FitBarPlot2_MiceMean'], '-depsc') ; 
else
    print(['BarPlots/ObPhaseHomeostasisComparison_2FitBarPlot2_SessionsMean'], '-dpng', '-r300') ; 
    print(['epsFigures/ObPhaseHomeostasisComparison_2FitBarPlot2_SessionsMean'], '-depsc') ; 
end

