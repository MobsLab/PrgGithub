% % Numbers of mice to run analysis on
% Mice_to_analyze = [797 798];
% 
% % Get directories
% Dir = PathForExperimentsERC_Dima('CondPooled');
% Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);

Dir = PathForExperimentsPAGTest_Dima('CondPooled');
Dir785 = RestrictPathForExperiment(Dir, 'Group', 'Posterior'); % Get rid of misses
Dir785 = RestrictPathForExperiment(Dir785, 'nMice', 785 ); % Get rid of misses
Dir = RestrictPathForExperiment(Dir, 'nMice', [786 787 788]); % Get rid of misses
Dir = MergePathForExperiment(Dir785, Dir);

%% Load data
for i=1:(length(Dir.path)-1)
    cd(Dir.path{i}{1});
    load('behavResources.mat', 'FreezeAccEpoch', 'ZoneEpoch');
    
    ShockZoneFreezing = and(FreezeAccEpoch,ZoneEpoch{1});
    SafeZoneFreezing = and(FreezeAccEpoch,ZoneEpoch{2});
    
    ShockFreezingDur(i) = sum(End(ShockZoneFreezing) - Start(ShockZoneFreezing))/1E4;
    SafeFreezingDur(i) = sum(End(SafeZoneFreezing) - Start(SafeZoneFreezing))/1E4;
end

figure('units', 'normalized', 'outerposition', [0 1 0.3 0.7])

[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([ShockFreezingDur' SafeFreezingDur'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h_occ.FaceColor = 'flat';
h_occ.CData(1,:) = [1 0 0];
h_occ.CData(2,:) = [0 0 1];
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
ylabel('Time (s)');
title('Freezing', 'FontSize', 14);