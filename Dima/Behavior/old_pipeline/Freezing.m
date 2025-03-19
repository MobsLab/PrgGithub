%Freezing - Plot freezing details (overall and mean duration, number of freezing epizodes)
%in each zone of the UMaze in PreTests vs PostTests
%
% 
%  OUTPUT
%
%    Figure
% 
%       2018 by Dmitri Bryzgalov

%% Parameters
Mice_to_analyze = 798;
average = 0;   % Show one mouse (0) ot the average (1)

% Get directories
Dir_Pre = PathForExperimentsERC_Dima('TestPrePooled');
Dir_Pre = RestrictPathForExperiment(Dir_Pre,'nMice', Mice_to_analyze);
Dir_Post = PathForExperimentsERC_Dima('TestPostPooled');
Dir_Post = RestrictPathForExperiment(Dir_Post,'nMice', Mice_to_analyze);

% Output - CHANGE!!!
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse753/';
fig_out = 'FreezingProperties';

%% Allocation of memory
Pre = cell(1,length(Dir_Pre.path));
Post = cell(1,length(Dir_Post.path));

PreSInd = zeros(1,length(Dir_Pre.path));
PostSInd = zeros(1,length(Dir_Post.path));

PreMInd = zeros(1,length(Dir_Pre.path));
PostMInd = zeros(1,length(Dir_Post.path));

PreNInd = zeros(1,length(Dir_Pre.path));
PostNInd = zeros(1,length(Dir_Post.path));

%% Load data
for k = 1:length(Dir_Pre.path)
	Pre{k} = load([Dir_Pre.path{k}{1} 'behavResources.mat'],'FreezeAccEpoch', 'ZoneEpoch');
	Post{k} = load([Dir_Post.path{k}{1} 'behavResources.mat'],'FreezeAccEpoch', 'ZoneEpoch');
    
	%% Calculate
	% Overall length everywhere
	PreSInd(k) = sum(End(Pre{k}.FreezeAccEpoch) - Start (Pre{k}.FreezeAccEpoch))/1E4;
	PostSInd(k) = sum(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;

	% Mean length everywhere
	PreMInd(k) = nanmean(End(Pre{k}.FreezeAccEpoch) - Start (Pre{k}.FreezeAccEpoch))/1E4;
    PreMstdInd(k) = nanstd(End(Pre{k}.FreezeAccEpoch) - Start (Pre{k}.FreezeAccEpoch))/1E4;
	PostMInd(k) = nanmean(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;
    PostMstdInd(k) = nanstd(End(Post{k}.FreezeAccEpoch) - Start (Post{k}.FreezeAccEpoch))/1E4;

	% Number everywhere
	PreNInd(k) = length(Start(Pre{k}.FreezeAccEpoch));
	PostNInd(k) = length(Start(Post{k}.FreezeAccEpoch));

	% Get FreezeEpoch for each zone
	for i = 1:5
        PreFreezeZone{k}{i} = and(Pre{k}.FreezeAccEpoch,Pre{k}.ZoneEpoch{i});
        PreFreezeZone{k}{i}=mergeCloseIntervals(PreFreezeZone{k}{i},0.5*1E4);
        PostFreezeZone{k}{i} = and(Post{k}.FreezeAccEpoch,Post{k}.ZoneEpoch{i});
        PostFreezeZone{k}{i}=mergeCloseIntervals(PostFreezeZone{k}{i},0.5*1E4);
    end

	% Overall length in the zones
	for i = 1:5
        PreSZInd{i}(k) = sum(End(PreFreezeZone{k}{i}) - Start(PreFreezeZone{k}{i}))/1E4;
        PostSZInd{i}(k) = sum(End(PostFreezeZone{k}{i}) - Start(PostFreezeZone{k}{i}))/1E4;
    end

	% Mean length in the zones
	for i = 1:5
        PreMZInd{i}(k) = nanmean(End(PreFreezeZone{k}{i}) - Start(PreFreezeZone{k}{i}))/1E4;
        PreMZstdInd{i}(k) = nanstd(End(PreFreezeZone{k}{i}) - Start(PreFreezeZone{k}{i}))/1E4;
        if isnan(PreMZInd{i}(k))
            PreMZInd{i}(k) = 0;
            PreMZstdInd{i}(k) = 0;
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
        PreNZInd{i}(k) = length(Start(PreFreezeZone{k}{i}));
        PostNZInd{i}(k) = length(Start(PostFreezeZone{k}{i}));
    end
end

%% If you want to average across mice
if average == 1
    
    % Overall length everywhere
    PreS = mean(PreSInd);
    PreSstd = std(PreSInd);
    PostS = mean(PostSInd);
    PostSstd = std(PostSInd);
    
    % Mean length everywhere
    for i = 1:length(PreMInd)
        if isnan(PreMInd(i))
            PreMInd(i)=0;
        end
    end
    PreM = mean(PreMInd);
    PreMstd = std(PreMInd);
    for i = 1:length(PostMInd)
        if isnan(PostMInd(i))
            PostMInd(i)=0;
        end
    end
    PostM = mean(PostMInd);
    PostMstd = std(PostMInd);
    
    % Number everywhere
    PreN = mean(PreNInd);
    PreNstd = std(PreNInd);
    PostN = mean(PostNInd);
    PostNstd = std(PostNInd);
    
    % Overall length in the zones
    for i = 1:5
        PreSZ(i) = mean(PreSZInd{i});
        PreSZstd(i) = std(PreSZInd{i});
        PostSZ(i) = mean(PostSZInd{i});
        PostSZstd(i) = std(PostSZInd{i});
    end
    
    % Mean length in the zones
	for i = 1:5
        PreMZ(i) = mean(PreMZInd{i});
        PreMZstd(i) = std(PreMZInd{i});
        PostMZ(i) = mean(PostMZInd{i});
        PostMZstd(i) = std(PostMZInd{i});
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        PreNZ(i) = mean(PreNZInd{i});
        PreNZstd(i) = std(PreNZInd{i});
        PostNZ(i) = mean(PostNZInd{i});
        PostNZstd(i) = std(PostNZInd{i});
    end
    
elseif average ==  0
    
    % Overall length everywhere
    PreS = PreSInd;
    PreSstd = 0;
    PostS = PostSInd;
    PostSstd = 0;
    
    % Mean length everywhere
    PreM =PreMInd;
    PreMstd = PreMstdInd;
    PostM = PostMInd;
    PostMstd = PreMstdInd;
    
    % Number everywhere
    PreN = PreNInd;
    PreNstd = 0;
    PostN = PostNInd;
    PostNstd = 0;
    
    % Overall length in the zones
    for i = 1:5
        PreSZ(i) = PreSZInd{i};
        PreSZstd(i) = 0;
        PostSZ(i) = PostSZInd{i};
        PostSZstd(i) = 0;
    end
    
    % Mean length in the zones
	for i = 1:5
        PreMZ(i) = PreMZInd{i};
        PreMZstd(i) = PreMZstdInd{i};
        PostMZ(i) = PostMZInd{i};
        PostMZstd(i) = PostMZstdInd{i};
    end
    
    % Number in the zonesfor i = 1:5
    for i = 1:5
        PreNZ(i) = PreNZInd{i};
        PreNZstd(i) = 0;
        PostNZ(i) = PostNZInd{i};
        PostNZstd(i) = 0;
    end
    
end

%% Plot
fbilan = figure('units', 'normalized', 'outerposition', [0 0 1 1]);

% Plot overall duration
subplot(3,4,1)
b = bar([PreS PostS]);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([PreS PostS], [PreSstd PostSstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Pre.path)
        plot([1 2],[PreSInd(:,k) PostSInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot mean duration
subplot(3,4,5)
b = bar([PreM PostM],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([PreM PostM], [PreMstd PostMstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Pre.path)
        plot([1 2],[PreMInd(:,k) PostMInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
ylabel('Duration (s)')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);

% Plot number of freezing episodes
subplot(3,4,9)
b = bar([PreN PostN],'FaceColor', 'k');
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];
hold on
errorbar([PreN PostN], [PreNstd PostNstd],'.', 'Color', 'k');
if average == 1
    for k = 1:length(Dir_Pre.path)
        plot([1 2],[PreNInd(:,k) PostNInd(:,k)], '-ko', 'MarkerFaceColor','white');
    end
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'Pre', 'Post'})
ylabel('Number')
xlim([0.5 2.5])
hold off
box off
title ('In entire maze', 'fontsize', 10);


% Plot overall duration in zones
subplot(3,4,2:4)
b = barwitherr([PreSZstd;PostSZstd]', [PreSZ;PostSZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Pre.path)
            plot(x(:,k),[PreSZInd{k}(s) PostSZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Overall duration of freezing episodes in Pre- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);
lg = legend('Pre', 'Post');
lg.FontSize = 16;

% Plot mean duration in zones
subplot(3,4,6:8)
b = barwitherr([PreMZstd;PostMZstd]', [PreMZ;PostMZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Pre.path)
            plot(x(:,k),[PreMZInd{k}(s) PostMZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Mean duration of freezing episodes in Pre- and PostTests}'; '';...
    '{\fontsize{10}                                                                                                                                         In different zones}'},...
    'units','normalized', 'position', [0.2 1 0]);

% Plot number of episodes in zones
subplot(3,4,10:12)
b = barwitherr([PreNZstd;PostNZstd]', [PreNZ;PostNZ]');
b(1).BarWidth = 1;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
x = [b(1).XData + [b(1).XOffset]; b(1).XData - [b(1).XOffset]];
hold on
if average == 1
    for k = 1:5
        for s = 1:length(Dir_Pre.path)
            plot(x(:,k),[PreNZInd{k}(s) PostNZInd{k}(s)], '-ko', 'MarkerFaceColor','white');
        end
    end
end
hold on
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'Safe', 'Center', 'ShockCenter', 'SafeCenter'})
ylabel('Duration (s)')
hold off
box off
title ({' {\bf\fontsize{14} Number of freezing episodes in Pre- and PostTests}'; '';...
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