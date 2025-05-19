% function [RStrengthPost, RStrengthPost, states_sleep, states_wake] = ReactStrength_PCA_AG(nMice, experiment, varargin)
%% ReactStrength_PCA_AG
%
% CURRENTLY IRRELEVANT SCRIPT
%
%
% This script calculates reactivation strength of neural ensembles
% derived from principal components calculated from correlation matrices

% Epochs:

% PreSleepRipplesEpoch = PreSleep + SWS + ripples - ripples during slowwave pre sleep
% PostSleepRipplesEpoch = PostSleep + SWS + ripples - ripples during slowwave post sleep
% UMazeEpoch = Hab + TestPre
% CondEpoch = Conditioning
% TaskEpoch = Hab + TestPre + Conditioning
% AfterConditioningEpoch = TestPost

%
% References:
% - Peyrache et al., 2009, Nat Neuro
% - Peyrache et al., 2010, J Comput Neurosci
%
% By Arsenii Goriachenkov, MOBS team, Paris
% 30/05/2021
% github.com/arsgorv

%% Test-play param
AddMyPaths_Arsenii;

% nMice = [905 906 911 994 1161 1162 1168]; % ћыши в анализе
% nMice = [1162];

%% Parameters
% Parameters of cross-correlograms
binsize = 0.1*1e4; % (measured in tsd units!!!);

% Templates choice
list_epochs = {'PreSleep', 'Habituation', 'TestPre', 'Conditioning', 'PostSleep', 'TestPost', 'ExploAfter'};
[idx_template,~] = listdlg('PromptString', {'Choose epochs for templates'},'ListString',list_epochs);
[idx_matching,~] = listdlg('PromptString', {'Choose epochs for matching'},'ListString', list_epochs);

for epoch = 1:length(list_epochs)
    template_epoch = list_epochs{idx_template(epoch)};
    matching_epoch = list_epochs{idx_matching(epoch)};
end
% States
states_sleep = {'NREM', 'REM'};
if strcmp(experiment, 'PAG')
    states_wake = {'Explo', 'CondMov', 'CondFreeze', 'FullTask', 'PostTests'};
elseif strcmp(experiment, 'MFB')
    states_wake = {'Explo', 'CondMov', 'FullTask', 'PostTests'};
end

%% Manage experiment
experiment = 'PAG';
if strcmp(experiment, 'PAG')
    fetchpaths = 'UMazePAG';
elseif strcmp(experiment, 'MFB')
    fetchpaths = 'StimMFBWake';
end

%% Allocate memory
% Data
SpikeData = cell(length(nMice),1);
behav = cell(length(nMice),1);
Ripples = cell(length(nMice),1);
SleepScoring = cell(length(nMice),1);

% Epochs
SleepEpochs = cell(length(nMice), 1);
WakeEpochs = cell(length(nMice), 1);

% Firing histogram
QPreSleep = cell(length(nMice), 1);
QPostSleep = cell(length(nMice), 1);
QWake = cell(length(nMice), 1);

%% Load the data
% Get paths of each individual mouse
Dir = PathForExperimentsERC_Arsenii(fetchpaths);
Dir = RestrictPathForExperiment(Dir,'nMice',nMice);

for imouse = 1:length(Dir.path)
    SpikeData{imouse} = load([Dir.path{imouse}{1} '/SpikeData.mat'],'S','PlaceCells');
    % If there are less than 2 PCs - don't do
    if isfield(SpikeData{imouse}.PlaceCells,'idx')
        if length(SpikeData{imouse}.PlaceCells.idx) > 2
            behav{imouse} = load([Dir.path{imouse}{1} '/behavResources.mat'],'SessionEpoch', 'CleanVtsd', 'FreezeAccEpoch', 'PosMat');
            Ripples{imouse} = load([Dir.path{imouse}{1} '/Ripples.mat'],'ripples');
            try 
                SleepScoring{imouse} = load([Dir.path{imouse}{1} '/SleepScoring_Accelero.mat'],'SWSEpoch','REMEpoch','Sleep'); % Sleep is not used
            catch
                SleepScoring{imouse} = load([Dir.path{imouse}{1} '/SleepScoring_OBGamma.mat'],'SWSEpoch','REMEpoch','Sleep');  % Sleep is not used
            end
        end
    end
end

%% Create epoch
for imouse = 1:length(Dir.path)
    
    % Get epochs
%     [~, UMazeMovEpoch, CondMovEpoch, TaskMovEpoch, AfterConditioningMovEpoch] = ReturnMnemozyneEpochs(behavResources{imouse}.SessionEpoch,...
%         'Speed', behavResources{imouse}.CleanVtsd, 'SpeedThresh', speed_thresh);
    [~, UMazeMovEpoch, CondMovEpoch, TaskMovEpoch, AfterConditioningMovEpoch] = ReturnMnemozyneEpochs(behav{imouse}.SessionEpoch,...
        'Speed', behav{imouse}.CleanVtsd);
    if strcmp(experiment, 'PAG')
        [~, ~, CondEpoch, ~, ~] = ReturnMnemozyneEpochs(behav{imouse}.SessionEpoch);
        CondFreezeEpoch = and(CondEpoch, behav{imouse}.FreezeAccEpoch);
    end
    
%     % Create iterable epochs
%     SleepEpochs{imouse} = {sleep{imouse}.SWSEpoch, sleep{imouse}.REMEpoch};
%     if strcmp(experiment, 'PAG')
%         WakeEpochs{imouse} = {UMazeMovEpoch, CondMovEpoch, CondFreezeEpoch, TaskMovEpoch, AfterConditioningMovEpoch};
%     elseif strcmp(experiment, 'MFB')
%         WakeEpochs{imouse} = {UMazeMovEpoch, CondMovEpoch, TaskMovEpoch, AfterConditioningMovEpoch};
%     end
end


%% Create behavioral epochs OLD

% Create ripples epochs (SWS)

ripplesEpoch = intervalSet(Ripples{imouse}.ripples(:,2)*1e4-1e4, Ripples{imouse}.ripples(:,2)*1e4+1e4);
PreSleepRipplesEpoch = and(and(behav{imouse}.SessionEpoch.PreSleep, SleepScoring{imouse}.SWSEpoch),ripplesEpoch);
PostSleepRipplesEpoch = and(and(behav{imouse}.SessionEpoch.PostSleep, SleepScoring{imouse}.SWSEpoch),ripplesEpoch);

% BaselineExplo Epoch
UMazeEpoch = or(behav{imouse}.SessionEpoch.Hab, behav{imouse}.SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch, behav{imouse}.SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch, behav{imouse}.SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch, behav{imouse}.SessionEpoch.TestPre4);

% Conditioning Epoch
CondEpoch = or(behav{imouse}.SessionEpoch.Cond1, behav{imouse}.SessionEpoch.Cond2);
CondEpoch = or(CondEpoch, behav{imouse}.SessionEpoch.Cond3);
CondEpoch = or(CondEpoch, behav{imouse}.SessionEpoch.Cond4);

% Whole task epoch
TaskEpoch = or(UMazeEpoch,CondEpoch);

% After Conditioning
AfterConditioningEpoch = or( behav{imouse}.SessionEpoch.TestPost1, behav{imouse}.SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch, behav{imouse}.SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch, behav{imouse}.SessionEpoch.TestPost4);

% Locomotion threshold
VtsdSmoothed  = tsd(Range(behav{imouse}.CleanVtsd),movmedian(Data(behav{imouse}.CleanVtsd),5));
LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
CondMovingEpoch = and(LocomotionEpoch,CondEpoch);
% CondFreezeEpoch = and(LocomotionEpoch,FreezeAccEpoch);
TaskMovingEpoch = and(LocomotionEpoch,TaskEpoch);

%% Create ripples template epochs

ripSt = ts(Ripples{imouse}.ripples(:,1)*1e4);

% ripples epoch - [-850 -700] (ms) for pre, [0 150] (ms) for post
PreRipplesEpoch = mergeCloseIntervals(intervalSet(Range(ripSt)-0.85*1e4,Range(ripSt)-0.7*1e4),0.05*1e4);
% PostSleep
PostRipplesEpoch = mergeCloseIntervals(intervalSet(Range(ripSt),Range(ripSt)+0.15*1e4),0.05*1e4); %Ёот сами риплы.

% Conditioning
template.Cond.PreRipples = and(CondEpoch,PreRipplesEpoch); % Ёто конд эпоха где нет риплов
template.Cond.PostRipples = and(CondEpoch,PostRipplesEpoch); %Ёто конд эпоха где есть риплы

% PreSleep
template.PreSleep.PreRipples = and(behav{imouse}.SessionEpoch.PreSleep,PreRipplesEpoch); % Ёто пресон где нет риплов
template.PreSleep.PostRipples = and(behav{imouse}.SessionEpoch.PreSleep,PostRipplesEpoch); % Ёто пресон где есть риплы

% PostSleep
template.PostSleep.PreRipples = and(behav{imouse}.SessionEpoch.PostSleep,PreRipplesEpoch); % Ёто постсон где нет риплов
template.PostSleep.PostRipples = and(behav{imouse}.SessionEpoch.PostSleep,PostRipplesEpoch); % Ёто постсон где есть риплы

% Hab
template.Hab = behav{imouse}.SessionEpoch.Hab;
clear ripSt

%% Create epochs to match (those that do not exist yet)
%Ёпохи дл€ матчинга
match.Cond = template.Cond.PostRipples; 
match.Hab = behav{imouse}.SessionEpoch.Hab;
% Freezing
% match.Cond.Freezing = and(CondEpoch,FreezeAccEpoch); %фризинг во врем€ конд

% PreSleep SWS
match.PreSleep.NREM = and(behav{imouse}.SessionEpoch.PreSleep, SleepScoring{imouse}.SWSEpoch); %нонрем во врем€ пресна

% PostSleep SWS
match.PostSleep.NREM = and(behav{imouse}.SessionEpoch.PostSleep, SleepScoring{imouse}.SWSEpoch); %нонрем во врем€ послесна

% PreSleep REM
match.PreSleep.REM = and(behav{imouse}.SessionEpoch.PreSleep, SleepScoring{imouse}.REMEpoch); %нонрем во врем€ пресна

% PostSleep REM
match.PostSleep.REM = and(behav{imouse}.SessionEpoch.PostSleep, SleepScoring{imouse}.REMEpoch); %нонрем во врем€ послесна

%% Create epochs to average

% % PreSleep
% average.PreSleep = and(match.PreSleep.NREM,PostRipplesEpoch);
% 
% % PostSleep
% average.PostSleep = and(match.PostSleep.NREM,PostRipplesEpoch);

%% Make Q

Q = MakeQfromS(SpikeData{imouse}.S,binsize);

% Templates
QTemplate = Restrict(Q,template.Hab);
DatTemplate = full(Data(QTemplate));
idx_zero_template = find(sum(DatTemplate)==0);

% Matching epochs
QMatch_Hab = Restrict(Q, match.Hab);
Dat_Match.hab = full(Data(QMatch_Hab));
idx_zero_hab = find(sum(Dat_Match.hab)==0);

QMatch_Cond = Restrict(Q, CondEpoch);
Dat_Match.cond = full(Data(QMatch_Cond));
idx_zero_cond = find(sum(Dat_Match.cond)==0);

QMatch_post = Restrict(Q,match.PostSleep.NREM);
Dat_Match.post = full(Data(QMatch_post));
QMatch_pre = Restrict(Q,match.PreSleep.NREM);
Dat_Match.pre = full(Data(QMatch_pre));
idx_zero_pre = find(sum(Dat_Match.pre)==0);
idx_zero_post = find(sum(Dat_Match.post)==0);
idx_zero = unique([idx_zero_pre idx_zero_post idx_zero_template]);

Dat_Match.pre(:,idx_zero) = [];
Dat_Match.post(:,idx_zero) = [];
Dat_Match.hab(:,idx_zero) = [];
Dat_Match.cond(:,idx_zero) = [];

DatTemplate(:,idx_zero) = [];

%% Create templates

[templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(DatTemplate,0);

%% Do matching
%‘ункци€ матчит темплейты на эпохи типа сна, на которых мы хотим посмотреть
%реплеи
RStrengthPre = ReactivationStrength_SB(Dat_Match.pre,templates);
RStrengthPost = ReactivationStrength_SB(Dat_Match.post,templates);
RStrengthHabCond = ReactivationStrength_SB(Dat_Match.cond,templates);

%% Plots Hab on Cond
f1 = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);


% for icomp = 1:size(RStrengthHabCond,2)
    plot((1:size(RStrengthHabCond,1))/10, RStrengthHabCond(:,1:9));
% end
xlabel('Bins');

ylabel('Reactivation strength');
title('Match Habituation on Conditioning', 'FontSize', 14);
set(get(gca, 'XLabel'), 'FontSize', 17);
set(get(gca, 'YLabel'), 'FontSize', 17);
set(gca, 'FontSize', 13);
xlim([0, length(RStrengthHabCond(:, 1))/10]);
yl = [-30 150];
ylim(yl);

% plot lines where we stimulate mouse
% 1 бин = 100 мс => 10 бинов = 1 секунда.
id_stim = Start(StimEpoch, 's') - Start(behav{1}.SessionEpoch.Cond1, 's');

for i = 1:length(id_stim)
    line([id_stim(i) id_stim(i)], ylim, 'Color', [1 0 0], 'LineWidth', 2);
end

% plot freezing periods
id_freeze = Start(CondFreezeEpoch, 's') - Start(behav{1}.SessionEpoch.Cond1, 's');
CorrectedCondFreezeEpoch = intervalSet(Start(CondFreezeEpoch) - Start(behav{1}.SessionEpoch.Cond1),...
    End(CondFreezeEpoch) - Start(behav{1}.SessionEpoch.Cond1));
% 
% for i = 1:length(id_freeze)
%     line([id_freeze(i)*10 id_freeze(i)*10], ylim, 'Color', [0 0 1], 'LineWidth', 1);
% end
hold on
for k=1:length(Start(CorrectedCondFreezeEpoch))
    plot(Range(Restrict(Xtsd,subset(CorrectedCondFreezeEpoch,k)),'s'),Data(Restrict(Xtsd,subset(CorrectedCondFreezeEpoch,k)))*0+max(yl)*.8,'c','linewidth',2)
    hold on
end
%% Plots Cond ripples Pre Sleep NREM
f1 = figure('units', 'normalized', 'outerposition', [0 0 0.5 0.5]);

plot(RStrengthPre(:,1:2));
xlabel('Bins');

ylabel('Reactivation strength');
title('Match Conditioning (ripples) on PreSleep NREM', 'FontSize', 14);
set(get(gca, 'XLabel'), 'FontSize', 17);
set(get(gca, 'YLabel'), 'FontSize', 17);
set(gca, 'FontSize', 13);
xlim([0, length(RStrengthPre(:, 1))]);
ylim([-30, 150]);


%% See the result

% for i=1:size(RStrengthPost,2)
%     ToAvPost{i} = tsd(Range(QMatch_post),RStrengthPost(:,i));
% end
% for i=1:size(RStrengthPre,2)
%     ToAvPre{i} = tsd(Range(QMatch_pre),RStrengthPre(:,i));
% end

% for i=1:size(RStrength,2)
%     ToAv{i} = tsd(Range(QMatch),RStrength(:,i));
% end

% %
% for i=1:size(RStrengthPost,2)
%     [MPost{i},TPost{i}] = PlotRipRaw(ToAvPost{i},Start(and(PostRipplesEpoch,SessionEpoch.PostSleep),'s'),[-3000 3000]);
% end
% for i=1:size(RStrengthPre,2)
%     [MPre{i},TPre{i}] = PlotRipRaw(ToAvPre{i},Start(and(PreRipplesEpoch,SessionEpoch.PreSleep),'s'),[-3000 3000]); %»ли все же PostRipplesEpoch??
% end
% close all
% 

% for i=1:size(RStrength,2)
%     [M{i},T{i}] = PlotRipRaw(ToAv{i},Start(CondPostRipplesEpoch,'s'),[-3000 3000]);
% end
% close all

%%%%%
% for i=1:size(RStrengthPost,2)
%     MPost_Av(1:length(MPost{1}),i) = MPost{i}(:,2);
% end
% for i=1:size(RStrengthPre,2)
%     MPre_Av(1:length(MPre{1}),i) = MPre{i}(:,2);
% end

% for i=1:size(RStrength,2)
%     M_Av(1:length(M{1}),i) = M{i}(:,2);
% end
%
% MPost_Av_Mean = mean(MPost_Av,2);
% MPost_Av_std = std(MPost_Av,0,2);
% MPre_Av_Mean = mean(MPre_Av,2);
% MPre_Av_std = std(MPre_Av,0,2);

% M_Av_Mean = mean(M_Av,2);
% M_Av_std = std(M_Av,0,2);

%% Plot

% figure, plot(RStrengthPost(:, 1:2));
% xlabel('time, sec');
% ylabel('Reactivation strength');
% 
% % % Prepare x-axis
% for i=1:5:size(MPost{1},1)
%     XTicks{i} = num2str(round(MPost{1}(i,1),2));
% end
% XTicks = XTicks(~cellfun('isempty',XTicks));
% 
% f1 = figure;
% 
% errorbar(MPost{1}(:,1),MPost_Av_Mean,MPost_Av_std);
% hold on
% errorbar(MPre{1}(:,1),MPre_Av_Mean,MPre_Av_std);
% hold off

% ylim([-5 5])
% set(gca,'XTick',[1:61],'XTickLabels',XTicks);

% errorbar(M{1}(:,1),M_Av_Mean,M_Av_std);
% %     ylim([0 150])
% set(gca,'XTick',[1:5:61],'XTickLabels',XTicks);
% end