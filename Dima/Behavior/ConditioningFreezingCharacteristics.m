%%% ConditioningFreezingCharacterictics

%% Parameters
Mice_to_analyze = 798;
average = 0;   % Show one mouse (0) ot the average (1)

% Get directories
Dir_Cond = PathForExperimentsERC_Dima('CondPooled');
Dir_Cond = RestrictPathForExperiment(Dir_Cond,'nMice', Mice_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'FreezingProperties';

%% Allocation of memory
Cond = cell(1,length(Dir_Cond.path));

CondSInd = zeros(1,length(Dir_Cond.path));

CondMInd = zeros(1,length(Dir_Cond.path));

CondNInd = zeros(1,length(Dir_Cond.path));

%% Load data
for k = 1:length(Dir_Cond.path)
	Cond{k} = load([Dir_Cond.path{k}{1} 'behavResources.mat'],'FreezeAccEpoch', 'ZoneEpoch');
    
	%% Calculate
	% Overall length everywhere
	CondSInd(k) = sum(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;

	% Mean length everywhere
	CondMInd(k) = nanmean(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;
    CondMstdInd(k) = nanstd(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;

	% Number everywhere
	CondNInd(k) = length(Start(Cond{k}.FreezeAccEpoch));

	% Get FreezeEpoch for each zone
	for i = 1:5
        CondFreezeZone{k}{i} = and(Cond{k}.FreezeAccEpoch,Cond{k}.ZoneEpoch{i});
        CondFreezeZone{k}{i}=mergeCloseIntervals(CondFreezeZone{k}{i},0.5*1E4);
    end

	% Overall length in the zones
	for i = 1:5
        CondSZInd{i}(k) = sum(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
    end

	% Mean length in the zones
	for i = 1:5
        CondMZInd{i}(k) = nanmean(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
        CondMZstdInd{i}(k) = nanstd(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
        if isnan(CondMZInd{i}(k))
            CondMZInd{i}(k) = 0;
            CondMZstdInd{i}(k) = 0;
        end        
    end

	% Number in the zonesfor i = 1:5
	for i = 1:5
        CondNZInd{i}(k) = length(Start(CondFreezeZone{k}{i}));
    end
end

%% If you want to average across mice
if average == 1
    
    % Overall length everywhere
    CondS = mean(CondSInd);
    CondSstd = std(CondSInd);
    
    % Mean length everywhere
    for i = 1:length(CondMInd)
        if isnan(CondMInd(i))
            CondMInd(i)=0;
        end
    end
    CondM = mean(CondMInd);
    CondMstd = std(CondMInd);
    
    % Number everywhere
    CondN = mean(CondNInd);
    CondNstd = std(CondNInd);
    
    % Overall length in the zones
    for i = 1:5
        CondSZ(i) = mean(CondSZInd{i});
        CondSZstd(i) = std(CondSZInd{i});
    end
    
    % Mean length in the zones
	for i = 1:5
        CondMZ(i) = mean(CondMZInd{i});
        CondMZstd(i) = std(CondMZInd{i});
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        CondNZ(i) = mean(CondNZInd{i});
        CondNZstd(i) = std(CondNZInd{i});
    end
    
elseif average ==  0
    
    % Overall length everywhere
    CondS = CondSInd;
    CondSstd = 0;
    
    % Mean length everywhere
    CondM =CondMInd;
    CondMstd = CondMstdInd;
    
    % Number everywhere
    CondN = CondNInd;
    CondNstd = 0;
    
    % Overall length in the zones
    for i = 1:5
        CondSZ(i) = CondSZInd{i};
        CondSZstd(i) = 0;
    end
    
    % Mean length in the zones
	for i = 1:5
        CondMZ(i) = CondMZInd{i};
        CondMZstd(i) = CondMZstdInd{i};
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        CondNZ(i) = CondNZInd{i};
        CondNZstd(i) = 0;
    end
    
end

%% Plot
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% Plot overall duration
subplot(3,4,1)
b = bar([CondS PostS]);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondS PostS], [CondSstd PostSstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondSInd(:,k) PostSInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot mean duration
subplot(3,4,5)
b = bar([CondM PostM],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondM PostM], [CondMstd PostMstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondMInd(:,k) PostMInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot number of freezing episodes
subplot(3,4,9)
b = bar([CondN PostN],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondN PostN], [CondNstd PostNstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondNInd(:,k) PostNInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Number')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);


% Plot overall duration in zones
subplot(3,4,2:4)
b = barwitherr([CondSZstd;PostSZstd]', [CondSZ;PostSZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';%% Parameters
Mice_to_analyze = 798;
average = 0;   % Show one mouse (0) ot the average (1)

% Get directories
Dir_Cond = PathForExperimentsERC_Dima('TestCondPooled');
Dir_Cond = RestrictPathForExperiment(Dir_Cond,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'FreezingProperties';

%% Allocation of memory
Cond = cell(1,length(Dir_Cond.path));
Post = cell(1,length(Dir_Post.path));

CondSInd = zeros(1,length(Dir_Cond.path));
PostSInd = zeros(1,length(Dir_Post.path));

CondMInd = zeros(1,length(Dir_Cond.path));
PostMInd = zeros(1,length(Dir_Post.path));

CondNInd = zeros(1,length(Dir_Cond.path));
PostNInd = zeros(1,length(Dir_Post.path));

%% Load data
for k = 1:length(Dir_Cond.path)
	Cond{k} = load([Dir_Cond.path{k}{1} 'behavResources.mat'],'FreezeAccEpoch', 'ZoneEpoch');
	Post{k} = load([Dir_Post.path{k}{1} 'behavResources.mat'],'FreezeAccEpoch', 'ZoneEpoch');
    
	%% Calculate
	% Overall length everywhere
	CondSInd(k) = sum(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;
	PostSInd(k) = sum(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;

	% Mean length everywhere
	CondMInd(k) = nanmean(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;
    CondMstdInd(k) = nanstd(End(Cond{k}.FreezeAccEpoch) - Start (Cond{k}.FreezeAccEpoch))/1E4;
	PostMInd(k) = nanmean(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;
    PostMstdInd(k) = nanstd(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;

	% Number everywhere
	CondNInd(k) = length(Start(Cond{k}.FreezeAccEpoch));
	PostNInd(k) = length(Start(Post{k}.FreezeAccEpoch));

	% Get FreezeEpoch for each zone
	for i = 1:5
        CondFreezeZone{k}{i} = and(Cond{k}.FreezeAccEpoch,Cond{k}.ZoneEpoch{i});
        CondFreezeZone{k}{i}=mergeCloseIntervals(CondFreezeZone{k}{i},0.5*1E4);
        PostFreezeZone{k}{i} = and(Post{k}.FreezeAccEpoch,Post{k}.ZoneEpoch{i});
        PostFreezeZone{k}{i}=mergeCloseIntervals(PostFreezeZone{k}{i},0.5*1E4);
    end

	% Overall length in the zones
	for i = 1:5
        CondSZInd{i}(k) = sum(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
        PostSZInd{i}(k) = sum(End(PostFreezeZone{k}{i}) - Start(PostFreezeZone{k}{i}))/1E4;
    end

	% Mean length in the zones
	for i = 1:5
        CondMZInd{i}(k) = nanmean(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
        CondMZstdInd{i}(k) = nanstd(End(CondFreezeZone{k}{i}) - Start(CondFreezeZone{k}{i}))/1E4;
        if isnan(CondMZInd{i}(k))
            CondMZInd{i}(k) = 0;
            CondMZstdInd{i}(k) = 0;
        end
        PostMZInd{i}(k) = nanmean(End(PostFreezeZone{k}{i}) - Start(PostFreezeZone{k}{i}))/1E4;
        PostMZstdInd{i}(k) = nanstd(End(PostFreezeZone{k}{i}) - Start(PostFreezeZone{k}{i}))/1E4;
        if isnan(PostMZInd{i}(k))
            PostMZInd{i}(k) = 0;
            PostMZstdInd{i}(k) = 0;
        end
            
    end

	% Number in the zonesfor i = 1:5
	for i = 1:5
        CondNZInd{i}(k) = length(Start(CondFreezeZone{k}{i}));
        PostNZInd{i}(k) = length(Start(PostFreezeZone{k}{i}));
    end
end

%% If you want to average across mice
if average == 1
    
    % Overall length everywhere
    CondS = mean(CondSInd);
    CondSstd = std(CondSInd);
    PostS = mean(PostSInd);
    PostSstd = std(PostSInd);
    
    % Mean length everywhere
    for i = 1:length(CondMInd)
        if isnan(CondMInd(i))
            CondMInd(i)=0;
        end
    end
    CondM = mean(CondMInd);
    CondMstd = std(CondMInd);
    for i = 1:length(PostMInd)
        if isnan(PostMInd(i))
            PostMInd(i)=0;
        end
    end
    PostM = mean(PostMInd);
    PostMstd = std(PostMInd);
    
    % Number everywhere
    CondN = mean(CondNInd);
    CondNstd = std(CondNInd);
    PostN = mean(PostNInd);
    PostNstd = std(PostNInd);
    
    % Overall length in the zones
    for i = 1:5
        CondSZ(i) = mean(CondSZInd{i});
        CondSZstd(i) = std(CondSZInd{i});
        PostSZ(i) = mean(PostSZInd{i});
        PostSZstd(i) = std(PostSZInd{i});
    end
    
    % Mean length in the zones
	for i = 1:5
        CondMZ(i) = mean(CondMZInd{i});
        CondMZstd(i) = std(CondMZInd{i});
        PostMZ(i) = mean(PostMZInd{i});
        PostMZstd(i) = std(PostMZInd{i});
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        CondNZ(i) = mean(CondNZInd{i});
        CondNZstd(i) = std(CondNZInd{i});
        PostNZ(i) = mean(PostNZInd{i});
        PostNZstd(i) = std(PostNZInd{i});
    end
    
elseif average ==  0
    
    % Overall length everywhere
    CondS = CondSInd;
    CondSstd = 0;
    PostS = PostSInd;
    PostSstd = 0;
    
    % Mean length everywhere
    CondM =CondMInd;
    CondMstd = CondMstdInd;
    PostM = PostMInd;
    PostMstd = CondMstdInd;
    
    % Number everywhere
    CondN = CondNInd;
    CondNstd = 0;
    PostN = PostNInd;
    PostNstd = 0;
    
    % Overall length in the zones
    for i = 1:5
        CondSZ(i) = CondSZInd{i};
        CondSZstd(i) = 0;
        PostSZ(i) = PostSZInd{i};
        PostSZstd(i) = 0;
    end
    
    % Mean length in the zones
	for i = 1:5
        CondMZ(i) = CondMZInd{i};
        CondMZstd(i) = CondMZstdInd{i};
        PostMZ(i) = PostMZInd{i};
        PostMZstd(i) = PostMZstdInd{i};
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        CondNZ(i) = CondNZInd{i};
        CondNZstd(i) = 0;
        PostNZ(i) = PostNZInd{i};
        PostNZstd(i) = 0;
    end
    
end

%% Plot
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% Plot overall duration
subplot(3,4,1)
b = bar([CondS PostS]);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondS PostS], [CondSstd PostSstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondSInd(:,k) PostSInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot mean duration
subplot(3,4,5)
b = bar([CondM PostM],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondM PostM], [CondMstd PostMstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondMInd(:,k) PostMInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot number of freezing episodes
subplot(3,4,9)
b = bar([CondN PostN],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([CondN PostN], [CondNstd PostNstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Cond.path)
        plot([1 2],[CondNInd(:,k) PostNInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Cond', 'Post'})
ylabel('Number')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);


% Plot overall duration in zones
subplot(3,4,2:4)
b = barwitherr([CondSZstd;PostSZstd]', [CondSZ;PostSZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondSZInd{k}(s) PostSZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Overall duration of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);
lg = legend('Cond', 'Post');
lg.FontSize = 16;

% Plot mean duration in zones
subplot(3,4,6:8)
b = barwitherr([CondMZstd;PostMZstd]', [CondMZ;PostMZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondMZInd{k}(s) PostMZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Mean duration of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);

% Plot number of episodes in zones
subplot(3,4,10:12)
b = barwitherr([CondNZstd;PostNZstd]', [CondNZ;PostNZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondNZInd{k}(s) PostNZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Number of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);

if average == 0
    mtit(fbilan, ['Mouse ' num2str(Mice_to_analyze)],'zoff', 0.05, 'yoff', 0.45, 'fontsize',16);
end

%% Save Figure
% saveas(fbilan, [dir_out fig_out '.fig']);
% saveFigure(fbilan,fig_out,dir_out);

%% Clear all
clear
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondSZInd{k}(s) PostSZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Overall duration of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);
lg = legend('Cond', 'Post');
lg.FontSize = 16;

% Plot mean duration in zones
subplot(3,4,6:8)
b = barwitherr([CondMZstd;PostMZstd]', [CondMZ;PostMZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondMZInd{k}(s) PostMZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Mean duration of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);

% Plot number of episodes in zones
subplot(3,4,10:12)
b = barwitherr([CondNZstd;PostNZstd]', [CondNZ;PostNZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Cond.path)
            plot(x(:,k),[CondNZInd{k}(s) PostNZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Number of freezing episodes in Cond- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);

if average == 0
    mtit(fbilan, ['Mouse ' num2str(Mice_to_analyze)],'zoff', 0.05, 'yoff', 0.45, 'fontsize',16);
end

%% Save Figure
% saveas(fbilan, [dir_out fig_out '.fig']);
% saveFigure(fbilan,fig_out,dir_out);

%% Clear all
clear