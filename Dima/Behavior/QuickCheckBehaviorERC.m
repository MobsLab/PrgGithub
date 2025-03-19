%%% QuickCheckBehaviorERC
% master script for all the behavior you can imagine

%% Parameters
dir_out = '/home/mobsrick/Dropbox/Mobs_member/Dima/5-Ongoing results/Behavior/Mouse797/';
fig_post = 'beh_pre_post';
fig_post24 = 'beh_pre_post24';
% Before Vtsd correction == 1
old = 0;

indir = '/media/mobsrick/DataMOBS87/Mouse-797/';
ntest = 4;
Day3 = '11112018';
Day4 = '12112018';

suf = {'TestPre'; 'TestPost'; 'TestPost'};

clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};

%% Get the data
for i = 1:1:ntest
    % PreTests
    a = load([indir Day3 '/' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'],...
        'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Pre_Xtsd{i} = a.Xtsd;
    Pre_Ytsd{i} = a.Ytsd;
    Pre_Vtsd{i} = a.Vtsd;
    PreTest_PosMat{i} = a.PosMat;
    PreTest_occup(i,1:7) = a.Occup;
    PreTest_ZoneIndices{i} = a.ZoneIndices;
    Pre_mask = a.mask;
    Pre_Zone = a.Zone;
    Pre_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    % PostTests
    b = load([indir Day3 '/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Post_Xtsd{i} = b.Xtsd;
    Post_Ytsd{i} = b.Ytsd;
    Post_Vtsd{i} = b.Vtsd;
    PostTest_PosMat{i} = b.PosMat;
    PostTest_occup(i,1:7) = b.Occup;
    PostTest_ZoneIndices{i} = b.ZoneIndices;
    Post_mask = b.mask;
    Post_Zone = b.Zone;
    Post_Ratio_IMAonREAL = b.Ratio_IMAonREAL;
    % PostTests24h
    c = load([indir Day4 '/' suf{3} '/' suf{3} num2str(i) '/behavResources.mat'],...
        'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Post24_Xtsd{i} = c.Xtsd;
    Post24_Ytsd{i} = c.Ytsd;
    Post24_Vtsd{i} = c.Vtsd;
    Post24_PosMat{i} = c.PosMat;
    Post24_occup(i,1:7) = c.Occup;
    Post24_ZoneIndices{i} = c.ZoneIndices;
    Day2_mask = c.mask;
    Post24_Zone = c.Zone;
    Post24_Ratio_IMAonREAL = c.Ratio_IMAonREAL;
end

load([indir '/ExpeInfo.mat']);

%% Calculate occupancy in the maze
% PreTests

% Find limits
Pre_limc = bwboundaries(Pre_mask);
c1 = min(Pre_limc{1}(:,1));
c2 = max(Pre_limc{1}(:,1));
r1 = min(Pre_limc{1}(:,2));
r2 = max(Pre_limc{1}(:,2));

for o=1:1:ntest
    [Oc,OcS_Pre(1:62, 1:62, o),OcR,OcRS]=OccupancyMapDB(Pre_Xtsd{o},Pre_Ytsd{o},...
        'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 0,...
        'histlimits', [floor(c1/Pre_Ratio_IMAonREAL) floor(c2/Pre_Ratio_IMAonREAL)...
        floor(r1/Pre_Ratio_IMAonREAL) floor(r2/Pre_Ratio_IMAonREAL)]);
end
OcS_Pre_mean=mean(OcS_Pre,3);

% PostTests

% Find limits
Post_limc = bwboundaries(Post_mask);
c1 = min(Post_limc{1}(:,1));
c2 = max(Post_limc{1}(:,1));
r1 = min(Post_limc{1}(:,2));
r2 = max(Post_limc{1}(:,2));

for q=1:1:ntest
    [Oc,OcS_Post(1:62, 1:62, q),OcR,OcRS]=OccupancyMapDB(Post_Xtsd{q},Post_Ytsd{q},...
        'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 0,...
        'histlimits', [floor(c1/Post_Ratio_IMAonREAL) floor(c2/Post_Ratio_IMAonREAL)...
        floor(r1/Post_Ratio_IMAonREAL) floor(r2/Post_Ratio_IMAonREAL)]);
end
OcS_Post_mean=mean(OcS_Post,3);

% PostTests24h

% Find limits
Post24_limc = bwboundaries(Day2_mask);
c1 = min(Post24_limc{1}(:,1));
c2 = max(Post24_limc{1}(:,1));
r1 = min(Post24_limc{1}(:,2));
r2 = max(Post24_limc{1}(:,2));

for q=1:1:ntest
    [Oc,OcS_Post24(1:62, 1:62, q),OcR,OcRS]=OccupancyMapDB(Post24_Xtsd{q},Post24_Ytsd{q},...
        'smoothing', 1.5, 'size', 50, 'video', 15, 'plotfig', 0,...
        'histlimits', [floor(c1/Post24_Ratio_IMAonREAL) floor(c2/Post24_Ratio_IMAonREAL)...
        floor(r1/Post24_Ratio_IMAonREAL) floor(r2/Post24_Ratio_IMAonREAL)]);
end
OcS_Post24_mean=mean(OcS_Post24,3);

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
Pre_Occup_mean = mean(PreTest_occup,1);
Pre_Occup_std = std(PreTest_occup,1);
Post_Occup_mean = mean(PostTest_occup,1);
Post_Occup_std = std(PostTest_occup,1);
Post24_Occup_mean = mean(Post24_occup,1);
Post24_Occup_std = std(Post24_occup,1);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(PreTest_occup(:,1),PostTest_occup(:,1));
% Wilcoxon signed rank task between Pre and PostTest24h
p_pre_post24 = signrank(PreTest_occup(:,1),Post24_occup(:,1));
% Prepare arrays for plotting
point_pre_post = [PreTest_occup(:,1) PostTest_occup(:,1)];
point_pre_post24 = [PreTest_occup(:,1) Post24_occup(:,1)];

%% Prepare the 'first enter to shock zone' array
for u = 1:ntest
    if isempty(PreTest_ZoneIndices{u}{1})
        Pre_FirstTime(u) = 240;
    else
        Pre_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
        Pre_FirstTime(u) = PreTest_PosMat{u}(Pre_FirstZoneIndices(u),1);
    end
    
    if isempty(PostTest_ZoneIndices{u}{1})
        Post_FirstTime(u) = 240;
    else
        Post_FirstZoneIndices(u) = PostTest_ZoneIndices{u}{1}(1);
        Post_FirstTime(u) = PostTest_PosMat{u}(Post_FirstZoneIndices(u),1);
    end
    
    if isempty(Post24_ZoneIndices{u}{1})
        Post24_FirstTime(u) = 240;
    else
        Post24_FirstZoneIndices(u) = Post24_ZoneIndices{u}{1}(1);
        Post24_FirstTime(u) = Post24_PosMat{u}(Post24_FirstZoneIndices(u),1);
    end
    
    Pre_Post_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post_FirstTime(u)];
    
    Pre_Post24_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post24_FirstTime(u)];
end
    
Pre_Post_FirstTime_mean = mean(Pre_Post_FirstTime,1);
Pre_Post_FirstTime_std = std(Pre_Post_FirstTime,1);
p_FirstTime_pre_post = signrank(Pre_Post_FirstTime(:,1),Pre_Post_FirstTime(:,2));


Pre_Post24_FirstTime_mean = mean(Pre_Post24_FirstTime,1);
Pre_Post24_FirstTime_std = std(Pre_Post24_FirstTime,1);
p_FirstTime_pre_post24 = signrank(Pre_Post_FirstTime(:,1),Pre_Post24_FirstTime(:,2));

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for m = 1:ntest
    if isempty(PreTest_ZoneIndices{m}{1})
        Pre_entnum(m) = 0;
    else
        Pre_entnum(m)=length(find(diff(PreTest_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PostTest_ZoneIndices{m}{1})
        Post_entnum(m)=0;
    else
        Post_entnum(m)=length(find(diff(PostTest_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(Post24_ZoneIndices{m}{1})
        Post24_entnum(m)=0;
    else
        Post24_entnum(m)=length(find(diff(Post24_ZoneIndices{m}{1})>1))+1;
    end
end
Pre_Post_entnum = [Pre_entnum; Post_entnum]';
Pre_Post_entnum_mean = mean(Pre_Post_entnum,1);
Pre_Post_entnum_std = std(Pre_Post_entnum,1);
p_entnum_pre_post = signrank(Pre_entnum, Post_entnum);

Pre_Post24_entnum = [Pre_entnum; Post24_entnum]';
Pre_Post24_entnum_mean = mean(Pre_Post24_entnum,1);
Pre_Post24_entnum_std = std(Pre_Post24_entnum,1);
p_entnum_pre_post24 = signrank(Pre_entnum, Post24_entnum);

%% Calculate speed in the shock zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
for r=1:ntest
        % PreTest ShockZone speed
        if isempty(PreTest_ZoneIndices{r}{1})
            VZmean_pre(r) = 0;
        else
            if old
                Vtemp_pre{r} = tsd(Range(Pre_Vtsd{r}),(Data(Pre_Vtsd{r})./(diff(Range(Pre_Xtsd{r}))/1E4)));
            end
            Vtemp_pre{r}=Data(Vtemp_pre{r});
            VZone_pre{r}=Vtemp_pre{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_pre(r)=mean(VZone_pre{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PostTest_ZoneIndices{r}{1})
            VZmean_post(r) = 0;
        else
            if old
                Vtemp_post{r} = tsd(Range(Post_Vtsd{r}),(Data(Post_Vtsd{r})./(diff(Range(Post_Xtsd{r}))/1E4)));
            end
           Vtemp_post{r}=Data(Vtemp_post{r});
           VZone_post{r}=Vtemp_post{r}(PostTest_ZoneIndices{r}{1}(1:end-1),1);
           VZmean_post(r)=mean(VZone_post{r},1);
        end
        
        % PostTest24h ShockZone speed
        if isempty(Post24_ZoneIndices{r}{1})
            VZmean_post24(r) = 0;
        else
            if old
                Vtemp_post24{r} = tsd(Range(Post24_Vtsd{r}),(Data(Post24_Vtsd{r})./(diff(Range(Post24_Xtsd{r}))/1E4)));
            end
            Vtemp_post24{r}=Data(Vtemp_post24{r});
            VZone_post24{r}=Vtemp_post24{r}(Post24_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_post24(r)=mean(VZone_post24{r},1);
        end
end

Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
Pre_Post_VZmean_mean = mean(Pre_Post_VZmean,1);
Pre_Post_VZmean_std = std(Pre_Post_VZmean,1);
p_VZmean_pre_post = signrank(VZmean_pre, VZmean_post);

Pre_Post24_VZmean = [VZmean_pre; VZmean_post24]';
Pre_Post24_VZmean_mean = mean(Pre_Post24_VZmean,1);
Pre_Post24_VZmean_std = std(Pre_Post24_VZmean,1);
p_VZmean_pre_post24 = signrank(VZmean_pre, VZmean_post24);

%% Plot the figure Pre/Post
figure('units', 'normalized', 'outerposition', [0 0 1 1],  'Color',[1 1 1])

% Trajectories in PreTests
subplot(4,2,1)
imagesc(Pre_mask);
colormap(gray)
hold on
imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(PreTest_PosMat{p}(:,2)*Pre_Ratio_IMAonREAL,PreTest_PosMat{p}(:,3)*Pre_Ratio_IMAonREAL,...
        clrs{2,p},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PreTests');

% Trajectories in PostTests
subplot(4,2,2)
imagesc(Post_mask);
colormap(gray)
hold on
imagesc(Post_Zone{1}, 'AlphaData', 0.3);
hold on
for l=1:1:ntest
    plot(PostTest_PosMat{l}(:,2)*Post_Ratio_IMAonREAL,PostTest_PosMat{l}(:,3)*Post_Ratio_IMAonREAL,...
        clrs{2,l},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PostTests');

% Occupancy in PreTests
subplot(4,2,3)
imagesc(OcS_Pre_mean), axis xy
caxis([0 0.4]);
title ('Occupancy map for PreTests');
% Occupancy in PostTests
subplot(4,2,4)
imagesc(OcS_Post_mean), axis xy
caxis([0 0.4]);
title ('Occupancy map for PostTests');

% Occupancy BarPlot
subplot(4,2,5)
bar([Pre_Occup_mean(1) Post_Occup_mean(1)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar([Pre_Occup_mean(1) Post_Occup_mean(1)], [Pre_Occup_std(1) Post_Occup_std(1)],'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],point_pre_post(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('% time spent')
xlim([0.5 2.5])
if p_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_pre_post);
end
hold off
box off
title ('Percentage of occupancy in Pre- and PostTests');

%Number of entries into the shock zone BarPlot
subplot(4,2,6)
bar([Pre_Post_entnum_mean(1) Pre_Post_entnum_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post_entnum_mean, Pre_Post_entnum_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('Number of entries')
xlim([0.5 2.5])
if p_entnum_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_entnum_pre_post);
end
box off
hold off
title ('Number of entries to the shockzone Pre- and PostTests');

% First time to enter the shock zone BarPlot
subplot(4,2,7)
bar([Pre_Post_FirstTime_mean(1) Pre_Post_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post_FirstTime_mean, Pre_Post_FirstTime_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('Time (s)')
xlim([0.5 2.5])
if p_FirstTime_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_FirstTime_pre_post);
end
box off
hold off
title ('First time to enter the shockzone Pre- and PostTests (s)');

% Average speed into the shock zone BarPlot
subplot(4,2,8)
bar([Pre_Post_VZmean_mean(1) Pre_Post_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post_VZmean_mean, Pre_Post_VZmean_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('Average speed (cm/s)')
xlim([0.5 2.5])
if p_VZmean_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_VZmean_pre_post);
end
box off
hold off
title ('Average speed in Pre- and PostTests');

%Save it
saveas(gcf, [dir_out 'M' num2str(ExpeInfo.nmouse) '_' fig_post '.fig']);
saveFigure(gcf,['M' num2str(ExpeInfo.nmouse) '_' fig_post],dir_out);


%% Plot the figure Pre/Post24
figure('units', 'normalized', 'outerposition', [0 0 1 1],  'Color',[1 1 1])

% Trajectories in PreTests
subplot(4,2,1)
imagesc(Pre_mask);
colormap(gray)
hold on
imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(PreTest_PosMat{p}(:,2)*Pre_Ratio_IMAonREAL,PreTest_PosMat{p}(:,3)*Pre_Ratio_IMAonREAL,...
        clrs{2,p},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PreTests');

% Trajectories in PostTests24h
subplot(4,2,2)
imagesc(Day2_mask);
colormap(gray)
hold on
imagesc(Post24_Zone{1}, 'AlphaData', 0.3);
hold on
for l=1:1:ntest
    plot(Post24_PosMat{l}(:,2)*Post24_Ratio_IMAonREAL,Post24_PosMat{l}(:,3)*Post24_Ratio_IMAonREAL,...
        clrs{2,l},'linewidth',1)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PostTests 24h later');

% Occupancy in PreTests
subplot(4,2,3)
imagesc(OcS_Pre_mean), axis xy
caxis([0 0.4]);
title ('Occupancy map for PreTests');
% Occupancy in PostTests
subplot(4,2,4)
imagesc(OcS_Post24_mean), axis xy
caxis([0 0.4]);
title ('Occupancy map for PostTests 24h later');

% Occupancy BarPlot
subplot(4,2,5)
bar([Pre_Occup_mean(1) Post24_Occup_mean(1)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar([Pre_Occup_mean(1) Post24_Occup_mean(1)], [Pre_Occup_std(1) Post24_Occup_std(1)],'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],point_pre_post24(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock24h'})
ylabel('% time spent')
xlim([0.5 2.5])
if p_pre_post24 < 0.05
    H = sigstar({{'PreShock', 'AfterShock24h'}}, p_pre_post24);
end
hold off
box off
title ('Percentage of occupancy in Pre- and PostTests24h');

%Number of entries into the shock zone BarPlot
subplot(4,2,6)
bar([Pre_Post24_entnum_mean(1) Pre_Post24_entnum_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post24_entnum_mean, Pre_Post24_entnum_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post24_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock24h'})
ylabel('Number of entries')
xlim([0.5 2.5])
if p_entnum_pre_post24 < 0.05
    H = sigstar({{'PreShock', 'AfterShock24h'}}, p_entnum_pre_post24);
end
box off
hold off
title ('Number of entries to the shockzone Pre- and PostTests24h');

% First time to enter the shock zone BarPlot
subplot(4,2,7)
bar([Pre_Post24_FirstTime_mean(1) Pre_Post24_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post24_FirstTime_mean, Pre_Post24_FirstTime_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post24_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock24h'})
ylabel('Time (s)')
xlim([0.5 2.5])
if p_FirstTime_pre_post24 < 0.05
    H = sigstar({{'PreShock', 'AfterShock24h'}}, p_FirstTime_pre_post24);
end
box off
hold off
title ('First time to enter the shockzone Pre- and PostTests24h (s)');

% Average speed into the shock zone BarPlot
subplot(4,2,8)
bar([Pre_Post24_VZmean_mean(1) Pre_Post24_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4])
hold on
errorbar(Pre_Post24_VZmean_mean, Pre_Post24_VZmean_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post24_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white');
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock24h'})
ylabel('Average speed (cm/s)')
xlim([0.5 2.5])
if p_VZmean_pre_post24 < 0.05
    H = sigstar({{'PreShock', 'AfterShock24h'}}, p_VZmean_pre_post24);
end
box off
hold off
title ('Average speed in Pre- and PostTests24h');

% %Save it
% saveas(gcf, [dir_out 'M' num2str(ExpeInfo.nmouse) '_'  fig_post24 '.fig']);
% saveFigure(gcf,['M' num2str(ExpeInfo.nmouse) '_' fig_post24],dir_out);

% %% Save the resulting .mat file
% save([dir_out 'BehResults.mat'], 'p_entnum_pre_post', 'p_entnum_pre_post24', 'p_FirstTime_pre_post', 'p_FirstTime_pre_post24', 'p_pre_post',...
%     'p_pre_post24', 'p_VZmean_pre_post', 'p_VZmean_pre_post24', 'point_pre_post', 'point_pre_post24',...
%     'Pre_Post_entnum', 'Pre_Post24_entnum', 'Pre_Post_FirstTime', 'Pre_Post24_FirstTime', 'Pre_Post_VZmean', 'Pre_Post24_VZmean');






