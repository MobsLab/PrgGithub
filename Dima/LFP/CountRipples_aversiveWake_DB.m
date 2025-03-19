%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912]);

%% Get Data
for i = 1:length(Dir.path)
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'Sleep', 'SWSEpoch','Wake');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'SessionEpoch');
        LFP{i} = load([Dir.path{i}{1} '/LFPData/LFP1.mat']);
    else
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'SWSEpoch','Wake');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'SessionEpoch');
        LFP{i} = load([Dir.path{i}{1} '/LFPData/LFP1.mat']);
    end
end

%% Calculate number, duration, amplitude

% Extract ripples for wake
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    WakeRipples{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.Wake);
end

for i=1:length(Dir.path)
    % Number overall
    N_tot(i)=length(Range(ripplesPeak{i}));
    % Normalize to the duration of experiment
    TimePre{i} = Range(LFP{i});
    N_tot_norm(i) = N_tot(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    
    % Number in wake
    N_wake(i)=length(Range(WakeRipples{i}));
    % Normalize to the duration of experiment
    TimePre{i} = Session{i}.SessionEpoch.Wake;
    N_wake_norm(i) = N_wake(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    
end


%% Plot

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

% Absolute number
b = bar([N_tot_norm' N_wake_norm']);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 0];
b.CData(2,:) = [0 0 1];
a = 1:size()


% [p,h, her] = PlotErrorBarN_DB([N_tot_norm' N_wake_norm'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0);
% ylim([0 1]);
% set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% h.FaceColor = 'flat';
% h.CData(1,:) = [0 0 0];
% h.CData(2,:) = [0 0 1];
% set(h, 'LineWidth', 3);
% set(her, 'LineWidth', 3);
% ylabel('Ripples/s');
% title('Ripples occurence in SWS Sleep', 'FontSize', 14);

AddScriptName

%% Save figure
if sav
    saveas(f1, [dir_out 'RipplesPrePostSleep.fig']);
    saveFigure(f1,'RipplesPrePostSleep',dir_out);
end

