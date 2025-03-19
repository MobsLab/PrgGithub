%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 912]);

%% Get Data
for i = 1:length(Dir.path)
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'Sleep', 'SWSEpoch','REMEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'behavResources', 'SessionEpoch', 'FreezeAccEpoch');
    else
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'SWSEpoch','REMEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'behavResources', 'SessionEpoch', 'FreezeAccEpoch');
    end
end

%% Find indices of PreTests and PostTest session in the structure
id_Pre = cell(1,length(Session));
id_Post = cell(1,length(Session));
id_Cond = cell(1,length(Session));

for i=1:length(Session)
    id_Pre{i} = zeros(1,length(Session{i}.behavResources));
    id_Cond{i} = zeros(1,length(Session{i}.behavResources));
    id_Post{i} = zeros(1,length(Session{i}.behavResources));
    for k=1:length(Session{i}.behavResources)
        if ~isempty(strfind(Session{i}.behavResources(k).SessionName,'TestPre'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(Session{i}.behavResources(k).SessionName,'TestPost'))
            id_Post{i}(k) = 1;
        end
    end
    for k=1:length(Session{i}.behavResources)
        if ~isempty(strfind(Session{i}.behavResources(k).SessionName,'Cond'))
            id_Cond{i}(k) = 1;
        end
    end
    id_Cond{i}=find(id_Cond{i});
    id_Pre{i}=find(id_Pre{i});
    id_Post{i}=find(id_Post{i});
end

%% Prepare intervalSets for ripples
for i=1:1:length(Dir.path)
    IS_TestPre{i} = or(Session{i}.SessionEpoch.TestPre1,Session{i}.SessionEpoch.TestPre2);
    IS_TestPre{i} = or(IS_TestPre{i},Session{i}.SessionEpoch.TestPre3);
    IS_TestPre{i} = or(IS_TestPre{i},Session{i}.SessionEpoch.TestPre4);

    IS_TestPost{i} = or(Session{i}.SessionEpoch.TestPost1,Session{i}.SessionEpoch.TestPost2);
    IS_TestPost{i} = or(IS_TestPost{i},Session{i}.SessionEpoch.TestPost3);
    IS_TestPost{i} = or(IS_TestPost{i},Session{i}.SessionEpoch.TestPost4);
    
    IS_Cond{i} = or(Session{i}.SessionEpoch.Cond1,Session{i}.SessionEpoch.Cond2);
    IS_Cond{i} = or(IS_Cond{i},Session{i}.SessionEpoch.Cond3);
    IS_Cond{i} = or(IS_Cond{i},Session{i}.SessionEpoch.Cond4);
end


%% Calculate ripples density

% Restrict sleeps to first 30 min
for i = 1:length(Dir.path)
    Session{i}.SessionEpoch.PreSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
    Session{i}.SessionEpoch.PostSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
end

% Extract ripples for presleep and postsleep (during detected sleep only)
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    PreRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));
    
    PreRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PreSleep1_30);
    PostRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PostSleep1_30);
    
end

% Extract ripples for TestPre and -Post in the safe Zone
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    PreRipples{i}=Restrict(ripplesPeak{i},IS_TestPre{i});
    PostRipples{i}=Restrict(ripplesPeak{i},IS_TestPost{i});
    CondRipples{i}=Restrict(ripplesPeak{i},IS_Cond{i});
    
    CondRipplesFreeze{i} = Restrict(CondRipples{i},Session{i}.FreezeAccEpoch);
    
end

%%% Sleep
for i=1:length(Dir.path)
    % Number during sleep
    Pre_N(i)=length(Range(PreRipples{i}));
    Post_N(i)=length(Range(PostRipples{i}));
    % Normalize to the duration of SWSSleep
    TimePre{i} = and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch);
    Pre_N_norm_all(i) = Pre_N(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch);
    Post_N_norm_all(i) = Post_N(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    
    % First 30min
    % Number during sleep
    Pre_N1_30(i)=length(Range(PreRipples1_30{i}));
    Post_N1_30(i)=length(Range(PostRipples1_30{i}));
    % Normalize to the duration of sleep
    TimePre1_30{i} = Session{i}.SessionEpoch.PreSleep1_30;
    Pre_N1_30_norm_all(i) = Pre_N1_30(i)/((sum(End(TimePre1_30{i})- Start(TimePre1_30{i})))/1e4); 
    TimePost1_30{i} = Session{i}.SessionEpoch.PostSleep1_30;
    Post_N1_30_norm_all(i) = Post_N1_30(i)/((sum(End(TimePost1_30{i})- Start(TimePost1_30{i})))/1e4);
   
end

% Cond
for i=1:length(Dir.path)
    % Cond
    Cond_N_Freeze(i) = length(Range(CondRipplesFreeze{i}));

    % Normalize to the duration of sleep
    Time{i} = and(IS_Cond{i}, Session{i}.FreezeAccEpoch);
    Cond_N_norm_Freeze(i) = Cond_N_Freeze(i)/((sum(End(Time{i})- Start(Time{i})))/1e4); 
    
end

%% Plot

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

% Absolute number
[p_Con,h, her] = PlotErrorBarN_DB([Pre_N1_30_norm_all' Cond_N_norm_Freeze' Post_N1_30_norm_all'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',1);
% ylim([0 0.4]);
ylim([0 1]);
set(gca,'Xtick',[1:3],'XtickLabel',{'PreSleep', 'CondFreezing','PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 0 0];
h.CData(3,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Ripples/s');
title('Ripples density across the experiment', 'FontSize', 14);