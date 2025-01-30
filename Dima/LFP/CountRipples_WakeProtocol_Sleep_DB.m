%% Parameters
sav=0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912 977 994]);

%% Get Data
for i = 1:length(Dir.path)
    if strcmp(Dir.name{i},'Mouse861') || strcmp(Dir.name{i},'Mouse906') % bad scoring for 861 and no scoring for 906
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_Accelero.mat'], 'Sleep', 'SWSEpoch','REMEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'behavResources', 'SessionEpoch');
    else
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        Sleep{i} = load([Dir.path{i}{1} 'SleepScoring_OBGamma.mat'], 'Sleep', 'SWSEpoch','REMEpoch');
        Session{i} = load([Dir.path{i}{1} 'behavResources.mat'], 'behavResources', 'SessionEpoch');
    end
end

%% Sleep
PreREM = zeros(1,length(Dir.path));
PreSleep = zeros(1,length(Dir.path));
PostREM = zeros(1,length(Dir.path));
PostSleep = zeros(1,length(Dir.path));
PostSWSperc = zeros(1,length(Dir.path));
PostREMperc = zeros(1,length(Dir.path));

id_Pre = cell(1,length(Rip));
id_Post = cell(1,length(Rip));

for i=1:length(Rip)
    id_Pre{i} = zeros(1,length(Session{i}.behavResources));
    id_Post{i} = zeros(1,length(Session{i}.behavResources));
    for k=1:length(Session{i}.behavResources)
        if ~isempty(strfind(Session{i}.behavResources(k).SessionName,'PreSleep'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(Session{i}.behavResources(k).SessionName,'PostSleep'))
            id_Post{i}(k) = 1;
        end
    end
    id_Pre{i}=find(id_Pre{i});
    id_Post{i}=find(id_Post{i});
end

% Individually
for i=1:length(Rip)
    PreREM(i) = sum(End(and(Sleep{i}.REMEpoch,Session{i}.SessionEpoch.PreSleep))-...
        Start(and(Sleep{i}.REMEpoch,Session{i}.SessionEpoch.PreSleep)))/1e4;
    PreSleep(i) = sum(End(and(Sleep{i}.Sleep,Session{i}.SessionEpoch.PreSleep))-...
        Start(and(Sleep{i}.Sleep,Session{i}.SessionEpoch.PreSleep)))/1e4;
    
    PostREM(i) = sum(End(and(Sleep{i}.REMEpoch,Session{i}.SessionEpoch.PostSleep))-...
        Start(and(Sleep{i}.REMEpoch,Session{i}.SessionEpoch.PostSleep)))/1e4;
    PostSleep(i) = sum(End(and(Sleep{i}.Sleep,Session{i}.SessionEpoch.PostSleep))-...
        Start(and(Sleep{i}.Sleep,Session{i}.SessionEpoch.PostSleep)))/1e4;

    PreREMperc(i) = PreREM(i)/PreSleep(i)*100;
    PostREMperc(i) = PostREM(i)/PostSleep(i)*100;
    
    PrePostREMperc(i,1:2) = [PreREMperc(i) PostREMperc(i)];
    
end

% Average
PreREMperc_aver = mean(PreREMperc);
PreREMperc_std = std(PreREMperc);

PostREMperc_aver = mean(PostREMperc);
PostREMperc_std = std(PostREMperc);

%% Calculate number, duration, amplitude

% Restrict sleeps to first 30 min
for i = 1:length(Dir.path)
    Session{i}.SessionEpoch.PreSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
    Session{i}.SessionEpoch.PostSleep1_30 = RestrictToTime(and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch),...
        30*60*1e4);
end

% Split sleeps
for i = 1:length(Dir.path)
    Session{i}.SessionEpoch.PreSleep30 = SplitIntervals(and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch),...
        15*60*1e4);
    Session{i}.SessionEpoch.PostSleep30 = SplitIntervals(and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch),...
        15*60*1e4);
end

% Extract ripples for presleep and postsleep (during detected sleep only)
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    PreRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PreSleep, Sleep{i}.SWSEpoch));
    PostRipples{i}=Restrict(ripplesPeak{i},and(Session{i}.SessionEpoch.PostSleep, Sleep{i}.SWSEpoch));
    
    PreRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PreSleep1_30);
    PostRipples1_30{i}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PostSleep1_30);
    
    for j=1:4
        try
            PreRipples30{i}{j}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PreSleep30{j});
            PostRipples30{i}{j}=Restrict(ripplesPeak{i},Session{i}.SessionEpoch.PostSleep30{j});
        end
    end
    
end

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
    
    % 2 times 30 min
    for j=1:4
        Pre_N30{j}(i)=length(Range(PreRipples30{i}{j}));
        Post_N30{j}(i)=length(Range(PostRipples30{i}{j}));
        % Normalize to the duration of sleep
        TimePre30{i}{j} = Session{i}.SessionEpoch.PreSleep30{j};
        Pre_N30_norm_all{j}(i) = Pre_N30{j}(i)/((sum(End(TimePre30{i}{j})- Start(TimePre30{i}{j})))/1e4);
        TimePost30{i}{j} = Session{i}.SessionEpoch.PostSleep30{j};
        Post_N30_norm_all{j}(i) = Post_N30{j}(i)/((sum(End(TimePost30{i}{j})- Start(TimePost30{i}{j})))/1e4);
    end
    
end


%% Plot

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

% Absolute number
subplot(121)
[p_all,h, her] = PlotErrorBarN_DB([Pre_N_norm_all' Post_N_norm_all'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
ylim([0 1]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Ripples/s');
title('Ripples density in SWS Sleep', 'FontSize', 14);

subplot(122)
[p_30,h, her] = PlotErrorBarN_DB([Pre_N1_30_norm_all' Post_N1_30_norm_all'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
ylim([0 1]);
set(gca,'Xtick',[1:2],'XtickLabel',{'PreSleep', 'PostSleep'});
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
h.FaceColor = 'flat';
h.CData(1,:) = [0 0 0];
h.CData(2,:) = [1 1 1];
set(h, 'LineWidth', 3);
set(her, 'LineWidth', 3);
ylabel('Ripples/s');
title('Ripples density in first 30 min of SWS sleep', 'FontSize', 14);

%% Save figure
if sav
    saveas(f1, [dir_out 'RipplesPrePostSleep_without.fig']);
    saveFigure(f1,'RipplesPrePostSleep_without',dir_out);
end

%% Plot
% Prepare
for j=1:4
    Pre_N30_mean(j) = nanmean(Pre_N30_norm_all{j});
    Pre_N30_std(j) = nanstd(Pre_N30_norm_all{j});
    Post_N30_mean(j) = nanmean(Post_N30_norm_all{j});
    Post_N30_std(j) = nanstd(Post_N30_norm_all{j});
    
    p_pre_post(j) = signrank(Pre_N30_norm_all{j},Post_N30_norm_all{j});
end

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

[b,berr] = barwitherr([Pre_N30_std;Post_N30_std]', [Pre_N30_mean;Post_N30_mean]');
b(1).BarWidth = 0.8;
b(1).FaceColor = 'k';
b(2).FaceColor = 'w';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
for k = 1:4
    for s = 1:length(Dir.path)
        plot(x(:,k),[Pre_N30_norm_all{k}(s) Post_N30_norm_all{k}(s)], '-ko', 'MarkerFaceColor','white');
    end
    if p_pre_post(j) < 0.05
        H = sigstar({[2*k-1 2*k]}, p_pre_post(j));
    end
end
hold on
% set(gca,'Xtick',[1:3],'XtickLabel',{'0-30 min', '30-60 min', '60-90 min'})
set(gca,'Xtick',[1:4],'XtickLabel',{'0-15 min', '15-30 min', '30-45 min', '45-60 min'})
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('Ripples/s');
xlabel('Time after start of sleep session');
set(b, 'LineWidth', 3);
set(berr, 'LineWidth', 3);
hold off
box off
title('Dynamics of ripples occurence in SWS sleep', 'FontSize', 14);
legend('PreSleep', 'PostSleep')


if sav
    saveas(f2, [dir_out 'DynamicsRipplesPrePostSleep_15.fig']);
    saveFigure(f2,'DynamicsRipplesPrePostSleep_15',dir_out);
end

% %% Excel
% Pre_N_norm_all = Pre_N_norm_all';
% Post_N_norm_all = Post_N_norm_all'; 
% 
% for j=1:4
%     Pre_N30_norm_all{j} = Pre_N30_norm_all{j}';
%     Post_N30_norm_all{j} = Post_N30_norm_all{j}';
% end
% 
% T = table(Pre_N_norm_all, Post_N_norm_all, Pre_N30_norm_all{1}, Post_N30_norm_all{1}, Pre_N30_norm_all{2},...
%     Post_N30_norm_all{2}, Pre_N30_norm_all{3}, Post_N30_norm_all{3}, Pre_N30_norm_all{4}, Post_N30_norm_all{4});
% 
% filenme = [dir_out 'finalxls1.xlsx'];
% writetable(T, filenme, 'Sheet',1,'Range','A1');

%% Final figure
f5 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6])

subplot(121)
[p_sleep,h_sleep, her_sleep] = PlotErrorBarN_DB([PreREMperc' PostREMperc'],...
    'barcolors', [0 0 0], 'barwidth', 0.8, 'newfig', 0, 'showpoints',1);
ylim([0 10]);
set(gca,'Xtick',[1:2],'XtickLabel',{});
set(gca, 'FontSize', 18, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
% ax = gca;
% labels = string(ax.YAxis.TickLabels); % extract
% labels(2:2:end) = nan; % remove every other one
% ax.YAxis.TickLabels = labels; % set
h_sleep.FaceColor = 'flat';
h_sleep.CData(1,:) = [0 0 0];
h_sleep.CData(2,:) = [1 1 1];
set(h_sleep, 'LineWidth', 3);
set(her_sleep, 'LineWidth', 3);
ylabel('% sleep');
% title('Percentage of REM','FontSize', 14);

subplot(122)
[p_rip,h_rip, her_rip] = PlotErrorBarN_DB([Pre_N_norm_all' Post_N_norm_all'],...
    'barcolors', [0 0 0], 'barwidth', 0.8, 'newfig', 0, 'showpoints',1);
% ylim([0 0.4]);
ylim([0 0.7]);
set(gca,'Xtick',[1:2],'XtickLabel',{});
set(gca, 'FontSize', 18, 'FontWeight',  'bold');
set(gca, 'LineWidth', 3);
ax = gca;
labels = string(ax.YAxis.TickLabels); % extract
labels(2:2:end) = nan; % remove every other one
ax.YAxis.TickLabels = labels; % set
h_rip.FaceColor = 'flat';
h_rip.CData(1,:) = [0 0 0];
h_rip.CData(2,:) = [1 1 1];
set(h_rip, 'LineWidth', 3);
set(her_rip, 'LineWidth', 3);
ylabel('Ripples/s');
% title('Ripples density during sleep', 'FontSize', 14);

if sav
    saveas(f5, '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/REM&Ripples_SFN.fig');
    saveFigure(f5,'REM&Ripples_SFN','/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Sleep/');
end
