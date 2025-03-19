%% Parameters
Mice_to_analyze = [797 798 828 861 882 905 906 911 912];
% Mice_to_analyze = [797 798 828 861 882 905 912];
average = 1;   % Show one mouse (0) ot the average (1)
sav=1;

dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';

% Get directories
Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', Mice_to_analyze);

%% Prepare arrays
% Latency
PreWakeLatency = zeros(1,length(Dir.path));
PreSWSLatency = zeros(1,length(Dir.path));
PreREMLatency = zeros(1,length(Dir.path));
PreSleepLatency = zeros(1,length(Dir.path));

PostWakeLatency = zeros(1,length(Dir.path));
PostSWSLatency = zeros(1,length(Dir.path));
PostREMLatency = zeros(1,length(Dir.path));
PostSleepLatency = zeros(1,length(Dir.path));

% Number of bouts
PreWakeNBouts = zeros(1,length(Dir.path));
PreSWSNBouts = zeros(1,length(Dir.path));
PreREMNBouts = zeros(1,length(Dir.path));
PreSleepNBouts = zeros(1,length(Dir.path));

PostWakeNBouts = zeros(1,length(Dir.path));
PostSWSNBouts = zeros(1,length(Dir.path));
PostREMNBouts = zeros(1,length(Dir.path));
PostSleepNBouts = zeros(1,length(Dir.path));

%% Load data
for i=1:length(Dir.path)
    a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources', 'SessionEpoch');
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    else
        sleepscored{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'REMEpoch', 'SWSEpoch', 'Wake', 'Sleep');
    end
end

%% Restrict to sleeps
for i=1:length(a)
    PreSleepWake{i} = and(sleepscored{i}.Wake,a{i}.SessionEpoch.PreSleep);
    PreSleepSWS{i} = and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PreSleep);
    PreSleepREM{i} = and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PreSleep);
    PreSleepSleep{i} = and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PreSleep);
    
    PostSleepWake{i} = and(sleepscored{i}.Wake,a{i}.SessionEpoch.PostSleep);
    PostSleepSWS{i} = and(sleepscored{i}.SWSEpoch,a{i}.SessionEpoch.PostSleep);
    PostSleepREM{i} = and(sleepscored{i}.REMEpoch,a{i}.SessionEpoch.PostSleep);
    PostSleepSleep{i} = and(sleepscored{i}.Sleep,a{i}.SessionEpoch.PostSleep);
end


%% Find start times of sleep

PreStartTime = cell(1,length(a));
PostStartTime = cell(1,length(a));
for i = 1:length(a)
    PreStartTime{i} = Start(PreSleepSleep{i});
    PostStartTime{i} = Start(PostSleepSleep{i});
end

%% Find latencies

for i=1:length(a)
    % PreWake
    temp = Start(PreSleepWake{i});
    PreWakeLatency(i) = (temp(1)-PreStartTime{i}(1))/1e4;
    % PreSWS
    temp = Start(PreSleepSWS{i});
    PreSWSLatency(i) = (temp(1)-PreStartTime{i}(1))/1e4;
    % PreREM
    temp = Start(PreSleepREM{i});
    PreREMLatency(i) = (temp(1)-PreStartTime{i}(1))/1e4;
    % PreSleep
    temp = Start(PreSleepSleep{i});
    PreSleepLatency(i) = (temp(1)-PreStartTime{i}(1))/1e4;
    
    % PostWake
    temp = Start(PostSleepWake{i});
    PostWakeLatency(i) = (temp(1)-PostStartTime{i}(1))/1e4;
    % PostSWS
    temp = Start(PostSleepSWS{i});
    PostSWSLatency(i) = (temp(1)-PostStartTime{i}(1))/1e4;
    % PostREM
    temp = Start(PostSleepREM{i});
    PostREMLatency(i) = (temp(1)-PostStartTime{i}(1))/1e4;
    % PostSleep
    temp = Start(PostSleepSleep{i});
    PostSleepLatency(i) = (temp(1)-PostStartTime{i}(1))/1e4;
end

% Check if wake-rem
for i=1:length(a)
    if PreSleepLatency(i) ~= PreSWSLatency(i)
        PreSleepLatency(i) = PreSWSLatency(i);
    end
end

%% Find number of bouts

for i=1:length(a)
    % PreWake
    PreWakeNBouts(i) = length(Start(PreSleepWake{i}));
    % PreSWS
    PreSWSNBouts(i) = length(Start(PreSleepSWS{i}));
    % PreREM
    PreREMNBouts(i) = length(Start(PreSleepREM{i}));
    % PreSleep
    PreSleepNBouts(i) = length(Start(PreSleepSleep{i}));
    
    % PostWake
    PostWakeNBouts(i) = length(Start(PostSleepWake{i}));
    % PostSWS
    PostSWSNBouts(i) = length(Start(PostSleepSWS{i}));
    % PostREM
    PostREMNBouts(i) = length(Start(PostSleepREM{i}));
    % PostSleep
    PostSleepNBouts(i) = length(Start(PostSleepSleep{i}));
end

%% Plot

% Latencies
Pl = {PreSWSLatency; PostSWSLatency; PreREMLatency; PostREMLatency};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2,3,4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',16);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',16);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'NREM-Pre','NREM-Post','REM-Pre','REM-Post'})
ylabel('Latencies from start of recordings (s)')
title('NREM & REM: latency of the first bout')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh1,[dir_out 'LatenciesNREM_REM.fig']);
    saveFigure(fh1,'LatenciesNREM_REM',dir_out);
end


% Number of bouts
Pl = {PreSWSNBouts; PostSWSNBouts; PreREMNBouts; PostREMNBouts};

Cols = {[0.7 0.7 0.7], [0.2 0.2 0.2], [0.7 0.7 0.7], [0.2 0.2 0.2]};

addpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

fh1 = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.7]);
MakeSpreadAndBoxPlot_SB(Pl,Cols,[1,2,3,4]);
[p,h5,stats] = signrank(Pl{1},Pl{2});
if p < 0.05
    sigstar_DB({{1,2}},p,0, 'StarSize',16);
end
[p,h5,stats] = signrank(Pl{3},Pl{4});
if p < 0.05
    sigstar_DB({{3,4}},p,0, 'StarSize',16);
end
set(gca,'LineWidth',3,'FontWeight','bold','FontSize',16,'XTick',1:4,...
    'XTickLabel',{'NREM-Pre','NREM-Post','REM-Pre','REM-Post'})
ylabel('Number of bouts')
title('NREM & REM: number of bouts')

rmpath(genpath('/home/mobsrick/Dima/MatlabToolbox-master/'));

if sav
    saveas(fh1,[dir_out 'NBoutsNREM_REM.fig']);
    saveFigure(fh1,'NBoutsNREM_REM',dir_out);
end
