function [f1,f2] = EV_Behav_corr_ratios(nMice, varargin)
% This function calculates Pearson correlation between explained variance
% and a behavioral parameter, such as:
%
%     * PostSleep/PreSleep occupation ratio of shock or safe zones.
%     * PostSleep/PreSleep speed ratio of shock or safe zones.
%     * PostSleep/PreSleep ratio of the first entry to shock or safe zone time.
%     * PostSleep/PreSleep ratio of the number of entries to shock or safe zones.
% 
% And plots it as scatter plots with least-squares line.
%
% Coded by Arsenii Goriachenkov
% 29/03/2021
% github.com/Arsgorv

%% Parameters
nMice = [905 906 911 994 1161 1162 1168]; % Мыши в анализе

%% Load data
AddMyPaths_Arsenii;

Dir = PathForExperimentsERC_Arsenii('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice', nMice);

EV_Res = load('EV_res.mat');
Behav_ratios = load('Behav_ratios.mat');

%% Optional parameters
colors = linspace(1,length(EV_Res.EVSWS),length(EV_Res.EVSWS));
% colors = 'k';

%% Entries to shock and safe zones. EV correlation

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);
EV_Fentry_shock_axes = axes('position', [0.08 0.58 0.35 0.35]);
EV_Fentry_safe_axes = axes('position', [0.58 0.58 0.35 0.35]);
EV_Nentry_shock_axes = axes('position', [0.08 0.1 0.35 0.35]);
EV_Nentry_safe_axes = axes('position', [0.58 0.1 0.35 0.35]);

EV_Entry_axes = [EV_Fentry_shock_axes, EV_Fentry_safe_axes, EV_Nentry_shock_axes, EV_Nentry_safe_axes];

for j = 1:2
    for i = 1:2
        for k = 1:2
            [rho, p] = corrcoef(Behav_ratios.ratio_fentry(:, k, 2), EV_Res.EVSWS); %EV-ratio_fentry (ShockOrSafe_post/ShockOrSafe_pre)
            EV_CorrM_fentry_rho{k} = rho;
            EV_CorrM_fentry_p{k} = p;
            
            [rho, p] = corrcoef(Behav_ratios.ratio_nentries(:, k, 2), EV_Res.EVSWS); %EV-ratio_nentries (ShockOrSafe_post/ShockOrSafe_pre)
            EV_CorrM_nentries_rho{k} = rho;
            EV_CorrM_nentries_p{k} = p;            
        end
        if j == 1
            axes(EV_Entry_axes(i));
            scatter(EV_Res.EVSWS, Behav_ratios.ratio_fentry(:, i, 2), 75, colors, 'filled') %ShockOrSafe_post/ShockOrSafe_pre
            if i == 1
                title('Post/Pre ratios of the first entries to the shock zone time');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_fentry_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_fentry_p{i}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the first entries to the safe zone time');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_fentry_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_fentry_p{i}(2), 2))], 'sc');
            end
        elseif j == 2
            axes(EV_Entry_axes(i+2));
            scatter(EV_Res.EVSWS, Behav_ratios.ratio_nentries(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the number of entries to the shock zone');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_nentries_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_nentries_p{i}(2), 2))], 'sc');               
            elseif i == 2
                title('Post/Pre ratios of the number of entries to the safe zone');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_nentries_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_nentries_p{i}(2), 2))], 'sc');               
            end
        end
    l1 = lsline;
    l1.Color = 'k';
    l1.LineWidth = 1;
    xlabel('EV SWS');
    ylabel('Post/Pre ratios');
    set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    set(gca, 'LineWidth', 1);
    t1(i).FontSize = 13;
    t2(i).FontSize = 13;
    end
end
clear i j k

%% Entries to shock and safe zones. REV correlation

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);
REV_Fentry_shock_axes = axes('position', [0.08 0.58 0.35 0.35]);
REV_Fentry_safe_axes = axes('position', [0.58 0.58 0.35 0.35]);
REV_Nentry_shock_axes = axes('position', [0.08 0.1 0.35 0.35]);
REV_Nentry_safe_axes = axes('position', [0.58 0.1 0.35 0.35]);

REV_Entry_axes = [REV_Fentry_shock_axes, REV_Fentry_safe_axes, REV_Nentry_shock_axes, REV_Nentry_safe_axes];

for j = 1:2
    for i = 1:2
        for k = 1:2
            [rho, p] = corrcoef(Behav_ratios.ratio_fentry(:, k, 2), EV_Res.REVSWS); %EV-ratio_fentry (ShockOrSafe_post/ShockOrSafe_pre)
            REV_CorrM_fentry_rho{k} = rho;
            REV_CorrM_fentry_p{k} = p;
            
            [rho, p] = corrcoef(Behav_ratios.ratio_nentries(:, k, 2), EV_Res.REVSWS); %EV-ratio_nentries (ShockOrSafe_post/ShockOrSafe_pre)
            REV_CorrM_nentries_rho{k} = rho;
            REV_CorrM_nentries_p{k} = p;            
        end
        if j == 1
            axes(REV_Entry_axes(i));
            scatter(EV_Res.REVSWS, Behav_ratios.ratio_fentry(:, i, 2), 75, colors, 'filled') %ShockOrSafe_post/ShockOrSafe_pre
            if i == 1
                title('Post/Pre ratios of the first entries to the shock zone time');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_fentry_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_fentry_p{i}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the first entries to the safe zone time');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_fentry_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_fentry_p{i}(2), 2))], 'sc');
            end
        elseif j == 2
            axes(REV_Entry_axes(i+2));
            scatter(EV_Res.REVSWS, Behav_ratios.ratio_nentries(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the number of entries to the shock zone');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_nentries_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_nentries_p{i}(2), 2))], 'sc');               
            elseif i == 2
                title('Post/Pre ratios of the number of entries to the safe zone');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_nentries_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_nentries_p{i}(2), 2))], 'sc');               
            end
        end
    l1 = lsline;
    l1.Color = 'k';
    l1.LineWidth = 1;
    xlabel('REV SWS');
    ylabel('Post/Pre ratios');
    set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    set(gca, 'LineWidth', 1);
    t1(i).FontSize = 13;
    t2(i).FontSize = 13;
    end
end
clear i j k

%% Occupancy and speed in shock or safe zones. EV correlation

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);
EV_Occupancy_shock_axes = axes('position', [0.08 0.58 0.35 0.35]);
EV_Occupancy_safe_axes = axes('position', [0.58 0.58 0.35 0.35]);
EV_Speed_shock_axes = axes('position', [0.08 0.1 0.35 0.35]);
EV_Speed_safe_axes = axes('position', [0.58 0.1 0.35 0.35]);

EV_Speedupancy_axes = [EV_Occupancy_shock_axes, EV_Occupancy_safe_axes, EV_Speed_shock_axes, EV_Speed_safe_axes];

for j = 1:2
    for i = 1:2
        for k = 1:2
            [EV_rho, EV_p] = corrcoef(Behav_ratios.ratio_occup(:, k, 2), EV_Res.EVSWS); %EV-ratio_occup (ShockOrSafe_post/ShockOrSafe_pre)
            EV_CorrM_occup_rho{k} = EV_rho;
            EV_CorrM_occup_p{k} = EV_p;
            
            [EV_rho, EV_p] = corrcoef(Behav_ratios.ratio_speed(:, k, 2), EV_Res.EVSWS); %EV-ratio_speed (ShockOrSafe_post/ShockOrSafe_pre)
            EV_CorrM_speed_rho{k} = EV_rho;
            EV_CorrM_speed_p{k} = EV_p;
        end
        if j == 1
            axes(EV_Speedupancy_axes(i));
            scatter(EV_Res.EVSWS, Behav_ratios.ratio_occup(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the shock zone occupation');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_occup_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_occup_p{i}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the safe zone occupation');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_occup_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_occup_p{i}(2), 2))], 'sc');
            end
        elseif j == 2
            axes(EV_Speedupancy_axes(i+2));
            scatter(EV_Res.EVSWS, Behav_ratios.ratio_speed(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the shock zone speed');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_speed_rho{1}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_speed_p{1}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the safe zone speed');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(EV_CorrM_speed_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(EV_CorrM_speed_p{1}(2), 2))], 'sc');
            end
        end
    l1 = lsline;
    l1.Color = 'k';
    l1.LineWidth = 1;
    xlabel('EV SWS');
    ylabel('Post/Pre ratios');
    set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    set(gca, 'LineWidth', 1);
    t1(i).FontSize = 13;
    t2(i).FontSize = 13;
    end
end
clear i j k

%% Occupancy and speed in shock or safe zones. REV correlation

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.9 0.9]);
REV_Occupancy_shock_axes = axes('position', [0.08 0.58 0.35 0.35]);
REV_Occupancy_safe_axes = axes('position', [0.58 0.58 0.35 0.35]);
REV_Speed_shock_axes = axes('position', [0.08 0.1 0.35 0.35]);
REV_Speed_safe_axes = axes('position', [0.58 0.1 0.35 0.35]);

REV_Speedupancy_axes = [REV_Occupancy_shock_axes, REV_Occupancy_safe_axes, REV_Speed_shock_axes, REV_Speed_safe_axes];

for j = 1:2
    for i = 1:2
        for k = 1:2
            [REV_rho, REV_p] = corrcoef(Behav_ratios.ratio_occup(:, k, 2), EV_Res.REVSWS); %REV-ratio_occup (ShockOrSafe_post/ShockOrSafe_pre)
            REV_CorrM_occup_rho{k} = REV_rho;
            REV_CorrM_occup_p{k} = REV_p;
            
            [REV_rho, REV_p] = corrcoef(Behav_ratios.ratio_speed(:, k, 2), EV_Res.REVSWS); %REV-ratio_speed (ShockOrSafe_post/ShockOrSafe_pre)
            REV_CorrM_speed_rho{k} = REV_rho;
            REV_CorrM_speed_p{k} = REV_p;
        end
        if j == 1
            axes(REV_Speedupancy_axes(i));
            scatter(EV_Res.REVSWS, Behav_ratios.ratio_occup(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the shock zone occupation');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_occup_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_occup_p{i}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the safe zone occupation');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_occup_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_occup_p{i}(2), 2))], 'sc');
            end
        elseif j == 2
            axes(REV_Speedupancy_axes(i+2));
            scatter(EV_Res.REVSWS, Behav_ratios.ratio_speed(:, i, 2), 75, colors, 'filled') %Shock_post/Shock_pre
            if i == 1
                title('Post/Pre ratios of the shock zone speed');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_speed_rho{1}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_speed_p{1}(2), 2))], 'sc');
            elseif i == 2
                title('Post/Pre ratios of the safe zone speed');
                t1(i) = text(.4, .9, ['rho = ' num2str(round(REV_CorrM_speed_rho{i}(2), 2))], 'sc');
                t2(i) = text(.4, .8, ['p = ' num2str(round(REV_CorrM_speed_p{1}(2), 2))], 'sc');
            end
        end
    l1 = lsline;
    l1.Color = 'k';
    l1.LineWidth = 1;
    xlabel('REV SWS');
    ylabel('Post/Pre ratios');
    set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'FontName', 'Times New Roman');
    set(gca, 'LineWidth', 1);
    t1(i).FontSize = 13;
    t2(i).FontSize = 13;
    end
end
clear i j k

end