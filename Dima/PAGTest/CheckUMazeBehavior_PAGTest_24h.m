%%% CheckUMazeBehavior_PAGTest

clear all

%% Parameters
sav=1;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/PAGTest/Pre_Cond_Post_24h/';
fig_post = 'UMazeBehav';
% Before Vtsd correction == 1
old = 0;

indir = '/media/mobsrick/DataMOBS87/Mouse-788/';
ntest = 4;
Day3 = '10092018';
Day4 = '11092018';
nmouse = '788ant'; 

suf = {'TestPre'; 'Cond'; 'TestPost'};

clrs = {'ko', 'bo', 'ro','go'; 'k','b', 'r', 'g'; 'kp', 'bp', 'rp', 'gp'};

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
    % Cond
    b = load([indir Day3 '/' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Cond_Xtsd{i} = b.Xtsd;
    Cond_Ytsd{i} = b.Ytsd;
    Cond_Vtsd{i} = b.Vtsd;
    Cond_PosMat{i} = b.PosMat;
    Cond_occup(i,1:7) = b.Occup;
    Cond_ZoneIndices{i} = b.ZoneIndices;
    Cond_mask = b.mask;
    Cond_Zone = b.Zone;
    Cond_Ratio_IMAonREAL = b.Ratio_IMAonREAL;
    % PostTests
    c = load([indir Day4 '/' suf{3} '/' suf{3} num2str(i) '/behavResources.mat'],...
    'Occup', 'PosMat','Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Post_Xtsd{i} = c.Xtsd;
    Post_Ytsd{i} = c.Ytsd;
    Post_Vtsd{i} = c.Vtsd;
    PostTest_PosMat{i} = c.PosMat;
    PostTest_occup(i,1:7) = c.Occup;
    PostTest_ZoneIndices{i} = c.ZoneIndices;
    Post_mask = c.mask;
    Post_Zone = c.Zone;
    Post_Ratio_IMAonREAL = c.Ratio_IMAonREAL;
end

%% Get stimulation idxs for conditioning sessions

for i=1:ntest
    StimT_beh{i} = find(Cond_PosMat{i}(:,4)==1);
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
PreTest_occup = PreTest_occup*100;
PostTest_occup = PostTest_occup*100;

Pre_Occup_mean = mean(PreTest_occup,1);
Pre_Occup_std = std(PreTest_occup,1);
Post_Occup_mean = mean(PostTest_occup,1);
Post_Occup_std = std(PostTest_occup,1);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(PreTest_occup(:,1),PostTest_occup(:,1));
% Prepare arrays for plotting
point_pre_post = [PreTest_occup(:,1) PostTest_occup(:,1)];

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
    
    Pre_Post_FirstTime(u, 1:2) = [Pre_FirstTime(u) Post_FirstTime(u)];
    
end
    
Pre_Post_FirstTime_mean = mean(Pre_Post_FirstTime,1);
Pre_Post_FirstTime_std = std(Pre_Post_FirstTime,1);
p_FirstTime_pre_post = signrank(Pre_Post_FirstTime(:,1),Pre_Post_FirstTime(:,2));

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
    
end
Pre_Post_entnum = [Pre_entnum; Post_entnum]';
Pre_Post_entnum_mean = mean(Pre_Post_entnum,1);
Pre_Post_entnum_std = std(Pre_Post_entnum,1);
p_entnum_pre_post = signrank(Pre_entnum, Post_entnum);

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
            Vtemp_pre{r}=Data(Pre_Vtsd{r});
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
           Vtemp_post{r}=Data(Post_Vtsd{r});
           VZone_post{r}=Vtemp_post{r}(PostTest_ZoneIndices{r}{1}(1:end-1),1);
           VZmean_post(r)=mean(VZone_post{r},1);
        end

end

Pre_Post_VZmean = [VZmean_pre; VZmean_post]';
Pre_Post_VZmean_mean = mean(Pre_Post_VZmean,1);
Pre_Post_VZmean_std = std(Pre_Post_VZmean,1);
p_VZmean_pre_post = signrank(VZmean_pre, VZmean_post);

%% Plot the figure Pre/Post
figure('units', 'normalized', 'outerposition', [0 0 1 0.7],  'Color',[1 1 1])

% Trajectories in PreTests
subplot(5,9,[1:3 10:12 19:21])
imagesc(Pre_mask);
colormap(gray)
hold on
imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(PreTest_PosMat{p}(:,2)*Pre_Ratio_IMAonREAL,PreTest_PosMat{p}(:,3)*Pre_Ratio_IMAonREAL,...
        clrs{2,p},'linewidth',1.5)
    hold on
end
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthWest');
title ('Trajectories in PreTests');

% Trajectories in Cond
subplot(5,9,[4:6 13:15 22:24])
imagesc(Cond_mask);
colormap(gray)
hold on
imagesc(Cond_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(Cond_PosMat{p}(:,2)*Cond_Ratio_IMAonREAL,Cond_PosMat{p}(:,3)*Cond_Ratio_IMAonREAL,...
        clrs{2,p},'linewidth',1.5)
    hold on
end
for p=1:1:ntest
    for j = 1:length(StimT_beh{p})
        if p < 4
            h1 = plot(Cond_PosMat{p}(StimT_beh{p}(j),2)*Cond_Ratio_IMAonREAL, Cond_PosMat{p}(StimT_beh{p}(j),3)*Cond_Ratio_IMAonREAL,...
                clrs{3,p}, 'MarkerSize', 14, 'MarkerFaceColor', clrs{2,p});
            uistack(h1,'top');
        else
            h1 = plot(Cond_PosMat{p}(StimT_beh{p}(j),2)*Cond_Ratio_IMAonREAL, Cond_PosMat{p}(StimT_beh{p}(j),3)*Cond_Ratio_IMAonREAL,...
                clrs{3,p}, 'MarkerEdgeColor', [0.1 0.4 0.3], 'MarkerSize', 14, 'MarkerFaceColor', [0.1 0.4 0.3]);
        end
        z(p) = length(StimT_beh{p});
    end
end
title (['Trajectories in Cond: ' num2str(sum(z)) ' stims']);
clear z

% Trajectories in PostTests  24h later
subplot(5,9,[7:9 16:18 25:27])
imagesc(Post_mask);
colormap(gray)
hold on
imagesc(Post_Zone{1}, 'AlphaData', 0.3);
hold on
for l=1:1:ntest
    plot(PostTest_PosMat{l}(:,2)*Post_Ratio_IMAonREAL,PostTest_PosMat{l}(:,3)*Post_Ratio_IMAonREAL,...
        clrs{2,l},'linewidth',1.5)
    hold on
end
title ('Trajectories in PostTests 24h later');

% Occupancy BarPlot
subplot(5,9,[28:30 37:39])
bar([Pre_Occup_mean(1) Post_Occup_mean(1)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
hold on
errorbar([Pre_Occup_mean(1) Post_Occup_mean(1)], [Pre_Occup_std(1) Post_Occup_std(1)],'.', 'Color', 'r');
hold on
for k = 1:ntest
    plot([1 2],point_pre_post(k,:), ['-' clrs{1,k}], 'MarkerFaceColor','white', 'LineWidth',1.8);
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('% time spent')
xlim([0.5 2.5])
if p_pre_post < 0.05
    H = sigstar({{'PreShock', '24hAfterShock'}}, p_pre_post);
end
hold off
box off
title ('Percentage of occupancy', 'FontSize', 10);

%Number of entries into the shock zone BarPlot
subplot(5,9,[31:32 40:41])
bar([Pre_Post_entnum_mean(1) Pre_Post_entnum_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
hold on
errorbar(Pre_Post_entnum_mean, Pre_Post_entnum_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_entnum(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', 'AfterShock'})
ylabel('Number of entries')
xlim([0.5 2.5])
if p_entnum_pre_post < 0.05
    H = sigstar({{'PreShock', '24hAfterShock'}}, p_entnum_pre_post);
end
box off
hold off
title ('Number of entries to the shockzone', 'FontSize', 10);

% First time to enter the shock zone BarPlot
subplot(5,9,[33:34 42:43])
bar([Pre_Post_FirstTime_mean(1) Pre_Post_FirstTime_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
hold on
errorbar(Pre_Post_FirstTime_mean, Pre_Post_FirstTime_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_FirstTime(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', '24hAfterShock'})
ylabel('Time (s)')
xlim([0.5 2.5])
if p_FirstTime_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_FirstTime_pre_post);
end
box off
hold off
title ('First time to enter the shockzone', 'FontSize', 10);

% Average speed into the shock zone BarPlot
subplot(5,9,[35:36 44:45])
bar([Pre_Post_VZmean_mean(1) Pre_Post_VZmean_mean(2)], 'FaceColor', [0 0.4 0.4], 'LineWidth',3)
hold on
errorbar(Pre_Post_VZmean_mean, Pre_Post_VZmean_std,'.', 'Color', 'r');
hold on
for g = 1:ntest
    plot([1 2],Pre_Post_VZmean(g,:), ['-' clrs{1,g}], 'MarkerFaceColor','white', 'LineWidth',1.8);
end
hold on
set(gca,'Xtick',[1,2],'XtickLabel',{'PreShock', '24hAfterShock'})
ylabel('Average speed (cm/s)')
xlim([0.5 2.5])
if p_VZmean_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_VZmean_pre_post);
end
box off
hold off
title ('Average speed', 'FontSize', 10);

%% Save
if sav
    saveas(gcf, [dir_out 'M' nmouse '_' fig_post '.fig']);
    saveFigure(gcf,['M' nmouse '_' fig_post],dir_out);

    %% Save the resulting .mat file
%     save([dir_out 'BehResults.mat'], 'p_entnum_pre_post', 'p_FirstTime_pre_post', 'p_pre_post','p_VZmean_pre_post', 'point_pre_post',...
%     'Pre_Post_entnum','Pre_Post_FirstTime','Pre_Post_VZmean');
end

%% Clear
clear