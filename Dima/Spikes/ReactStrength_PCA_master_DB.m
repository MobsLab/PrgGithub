%%%% ReactStrength_PCA_master_DB
%
% This script calculates reactivation strength of neural ensembles
% derived from principal components calculated from correlation matrices
%
% References:
% - Peyrache et al., 2009, Nat Neuro
% - Peyrache et al., 2010, J Comput Neurosci
%
% Please go inside the script and check the parameters

%% Parameters
nmouse = 994;
Dir = PathForExperimentsERC_Dima('UMazePAG');
% Dir = PathForExperimentsERC_DimaMAC('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);

% Parameters of cross-correlograms
binsize = 0.1*1e4; % (measured in tsd units!!!);

% Do you want to save the figures?
sav = false; %%% Does not work now

%% Get Data

for j=1:length(Dir.path)
    cd(Dir.path{j}{1});
    load('SpikeData.mat','S','PlaceCells');
    % If there are less than 2 PCs - don't do
    if isfield(PlaceCells,'idx')
        if length(PlaceCells.idx)>2
            
            load('behavResources.mat','SessionEpoch', 'CleanVtsd', 'FreezeAccEpoch');
            load('Ripples.mat','ripples');
            if strcmp(Dir.name{j}, 'Mouse906') || strcmp(Dir.name{j}, 'Mouse977') % Mice with bad OB-based sleep scoring
                load('SleepScoring_Accelero.mat','SWSEpoch','REMEpoch','Sleep'); % Sleep is not used
            else
                load('SleepScoring_OBGamma.mat','SWSEpoch','REMEpoch','Sleep');  % Sleep is not used
            end
            
        end
    end
end


%% Create behavioral epochs

% Create ripples epochs
ripplesEpoch = intervalSet(ripples(:,2)*1e4-1e4,ripples(:,2)*1e4+1e4);
PreSleepRipplesEpoch = and(and(SessionEpoch.PreSleep,SWSEpoch),ripplesEpoch);
PostSleepRipplesEpoch = and(and(SessionEpoch.PostSleep,SWSEpoch),ripplesEpoch);

% BaselineExplo Epoch
UMazeEpoch = or(SessionEpoch.Hab,SessionEpoch.TestPre1);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre2);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre3);
UMazeEpoch = or(UMazeEpoch,SessionEpoch.TestPre4);

% Conditioning Epoch
CondEpoch = or(SessionEpoch.Cond1,SessionEpoch.Cond2);
CondEpoch = or(CondEpoch,SessionEpoch.Cond3);
CondEpoch = or(CondEpoch,SessionEpoch.Cond4);

% Whole task epoch
TaskEpoch = or(UMazeEpoch,CondEpoch);

% After Conditioning
AfterConditioningEpoch = or(SessionEpoch.TestPost1,SessionEpoch.TestPost2);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost3);
AfterConditioningEpoch = or(AfterConditioningEpoch,SessionEpoch.TestPost4);

% Locomotion threshold
VtsdSmoothed  = tsd(Range(CleanVtsd),movmedian(Data(CleanVtsd),5));
LocomotionEpoch = thresholdIntervals(VtsdSmoothed,3,'Direction','Above');

% Get resulting epochs
UMazeMovingEpoch = and(LocomotionEpoch, UMazeEpoch);
AfterConditioningMovingEpoch = and(LocomotionEpoch, AfterConditioningEpoch);
CondMovingEpoch = and(LocomotionEpoch,CondEpoch);
CondFreezeEpoch = and(LocomotionEpoch,FreezeAccEpoch);
TaskMovingEpoch = and(LocomotionEpoch,TaskEpoch);

%% Create ripples template epochs

ripSt = ts(ripples(:,1)*1e4);

% ripples epoch - [-850 -700] (ms) for pre, [0 150] (ms) for post
PreRipplesEpoch = mergeCloseIntervals(intervalSet(Range(ripSt)-0.85*1e4,Range(ripSt)-0.7*1e4),0.05*1e4);
% PostSleep
PostRipplesEpoch = mergeCloseIntervals(intervalSet(Range(ripSt),Range(ripSt)+0.15*1e4),0.05*1e4);

% Conditioning
template.Cond.PreRipples = and(CondEpoch,PreRipplesEpoch);
template.Cond.PostRipples = and(CondEpoch,PostRipplesEpoch);

% PreSleep
template.PreSleep.PreRipples = and(SessionEpoch.PreSleep,PreRipplesEpoch);
template.PreSleep.PostRipples = and(SessionEpoch.PreSleep,PostRipplesEpoch);

% PostSleep
template.PostSleep.PreRipples = and(SessionEpoch.PostSleep,PreRipplesEpoch);
template.PostSleep.PostRipples = and(SessionEpoch.PostSleep,PostRipplesEpoch);

clear ripSt

%% Create epochs to match (those that do not exist yet)

% Freezing
match.Cond.Freezing = and(CondEpoch,FreezeAccEpoch);

% PreSleep
match.PreSleep.NREM = and(SessionEpoch.PreSleep,SWSEpoch);

% PostSleep
match.PostSleep.NREM = and(SessionEpoch.PostSleep,SWSEpoch);

%% Create epochs to average

% PreSleep
average.PreSleep = and(match.PreSleep.NREM,PostRipplesEpoch);

% PostSleep
average.PostSleep = and(match.PostSleep.NREM,PostRipplesEpoch);

%% Make Q

Q = MakeQfromS(S,binsize);

% Templates
QTemplate = Restrict(Q,TaskEpoch);
DatTemplate = full(Data(QTemplate));
idx_zero_template = find(sum(DatTemplate)==0);

% Matching epochs
QMatch_post = Restrict(Q,match.PostSleep.NREM);
Dat_Match.post = full(Data(QMatch_post));
QMatch_pre = Restrict(Q,match.PreSleep.NREM);
Dat_Match.pre = full(Data(QMatch_pre));
idx_zero_pre = find(sum(Dat_Match.pre)==0);
idx_zero_post = find(sum(Dat_Match.post)==0);
idx_zero = unique([idx_zero_pre idx_zero_post idx_zero_template]);


Dat_Match.pre(:,idx_zero) = [];
Dat_Match.post(:,idx_zero) = [];
DatTemplate(:,idx_zero) = [];

%% Create templates

[templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(DatTemplate,0);

%% Do matching

RStrengthPre = ReactivationStrength_SB(Dat_Match.pre,templates);
RStrengthPost = ReactivationStrength_SB(Dat_Match.post,templates);

%% See the result

for i=1:size(RStrengthPost,2)
    ToAvPost{i} = tsd(Range(QMatch_post),RStrengthPost(:,i));
end
for i=1:size(RStrengthPre,2)
    ToAvPre{i} = tsd(Range(QMatch_pre),RStrengthPre(:,i));
end

%
% for i=1:size(RStrength,2)
%     ToAv{i} = tsd(Range(QMatch),RStrength(:,i));
% end

% %
for i=1:size(RStrengthPost,2)
    [MPost{i},TPost{i}] = PlotRipRaw(ToAvPost{i},Start(and(PostRipplesEpoch,SessionEpoch.PostSleep),'s'),[-3000 3000]);
end
for i=1:size(RStrengthPre,2)
    [MPre{i},TPre{i}] = PlotRipRaw(ToAvPre{i},Start(and(PostRipplesEpoch,SessionEpoch.PreSleep),'s'),[-3000 3000]);
end
close all


% for i=1:size(RStrength,2)
%     [M{i},T{i}] = PlotRipRaw(ToAv{i},Start(CondPostRipplesEpoch,'s'),[-3000 3000]);
% end
% close all

%%%%%
for i=1:size(RStrengthPost,2)
    MPost_Av(1:length(MPost{1}),i) = MPost{i}(:,2);
end
for i=1:size(RStrengthPre,2)
    MPre_Av(1:length(MPre{1}),i) = MPre{i}(:,2);
end

% for i=1:size(RStrength,2)
%     M_Av(1:length(M{1}),i) = M{i}(:,2);
% end
%
MPost_Av_Mean = mean(MPost_Av,2);
MPost_Av_std = std(MPost_Av,0,2);
MPre_Av_Mean = mean(MPre_Av,2);
MPre_Av_std = std(MPre_Av,0,2);

% M_Av_Mean = mean(M_Av,2);
% M_Av_std = std(M_Av,0,2);


%% Plot
% % Prepare x-axis
% for i=1:5:size(MPost{1},1)
%     XTicks{i} = num2str(round(MPost{1}(i,1),2));
% end
% XTicks = XTicks(~cellfun('isempty',XTicks));

figure

errorbar(MPost{1}(:,1),MPost_Av_Mean,MPost_Av_std);
hold on
errorbar(MPre{1}(:,1),MPre_Av_Mean,MPre_Av_std);
hold off
%     ylim([0 150])
set(gca,'XTick',[1:5:61],'XTickLabels',XTicks);

% errorbar(M{1}(:,1),M_Av_Mean,M_Av_std);
% %     ylim([0 150])
% set(gca,'XTick',[1:5:61],'XTickLabels',XTicks);
