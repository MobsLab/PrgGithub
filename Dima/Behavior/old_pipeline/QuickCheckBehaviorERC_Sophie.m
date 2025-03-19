%%% behavERC
% master script for all the behavior you can imagine

clear all

%% Parameters
dir_out = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/results/';
fig_post = 'beh_pre_post';

indir = '/media/DataMOBsRAIDN/ProjetERC2/Mouse-742/';
ntest = 4;
% project = 'ProjetERC2'; % Sophie's data
Day = '31052018';
% nmouse = '741';  % Sophie's data

suf = {'TestPre'; 'TestPost'};

clrs = {'ko', 'ro', 'go','co'; 'k','r', 'g', 'c'};

%% Get the data
for i = 1:1:ntest
    % PreTests
    a = load([indir Day '/' project '_M' nmouse '_' Day '_' suf{1} '/' suf{1} num2str(i) '/behavResources.mat'],...
        'Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Pre_Xtsd{i} = a.Xtsd;
    Pre_Ytsd{i} = a.Ytsd;
    Pre_Vtsd{i} = a.Vtsd;
    PreTest_ZoneIndices{i} = a.ZoneIndices;
    Pre_mask = a.mask;
    Pre_Zone = a.Zone;
    Pre_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    % PostTests
    b = load([indir Day '/' project '_M' nmouse '_' Day '_' suf{2} '/' suf{2} num2str(i) '/behavResources.mat'],...
    'Xtsd', 'Ytsd', 'Vtsd', 'mask', 'Zone', 'ZoneIndices', 'Ratio_IMAonREAL');
    Post_Xtsd{i} = b.Xtsd;
    Post_Ytsd{i} = b.Ytsd;
    Post_Vtsd{i} = b.Vtsd;
    PostTest_ZoneIndices{i} = b.ZoneIndices;
    Post_mask = b.mask;
    Post_Zone = b.Zone;
    Post_Ratio_IMAonREAL = b.Ratio_IMAonREAL;
end

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
        'histlimits', [floor(r1/Pre_Ratio_IMAonREAL) floor(r2/Pre_Ratio_IMAonREAL)...
        floor(c1/Pre_Ratio_IMAonREAL) floor(c2/Pre_Ratio_IMAonREAL)]);
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
        'histlimits', [floor(r1/Post_Ratio_IMAonREAL) floor(r2/Post_Ratio_IMAonREAL)...
        floor(c1/Post_Ratio_IMAonREAL) floor(c2/Post_Ratio_IMAonREAL)]);
end
OcS_Post_mean=mean(OcS_Post,3);

%% Calculate occupancy from Xtsd and Ytsd
% PreTest
for i = 1:ntest
    Xtemp=Data(Pre_Xtsd{i}); Ytemp=Data(Pre_Ytsd{i}); T1=Range(Pre_Ytsd{i});
    if not(isempty('Pre_Zone'))
        for t=1:length(Pre_Zone)
            PreTest_occup(i,t)=size(PreTest_ZoneIndices{i}{t},1)./size(Xtemp,1);
        end
    else
        for t=1:2
            ZoneIndices{t}=[];
            ZoneEpoch{t}=intervalSet(0,0);
            PreTest_occup(i,t)=0;
        end
    end
end

% PostTest
for i = 1:ntest
    Xtemp=Data(Post_Xtsd{i}); Ytemp=Data(Post_Ytsd{i}); T1=Range(Post_Ytsd{i});
    if not(isempty('Post_Zone'))
        for t=1:length(Post_Zone)
            PostTest_occup(i,t)=size(PostTest_ZoneIndices{i}{t},1)./size(Xtemp,1);
        end
    else
        for t=1:2
            ZoneIndices{t}=[];
            ZoneEpoch{t}=intervalSet(0,0);
            PostTest_occup(i,t)=0;
        end
    end
end

%% Calculate average occupancy
% Mean and STD across 4 Pre- and PostTests
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
    
    PreTime = Range(Pre_Xtsd{u});
    PostTime = Range(Post_Xtsd{u});
    
    if isempty(PreTest_ZoneIndices{u}{1})
        Pre_FirstTime(u) = 180;
    else
        Pre_FirstZoneIndices(u) = PreTest_ZoneIndices{u}{1}(1);
        Pre_FirstTime(u) = PreTime(Pre_FirstZoneIndices(u),1)/1E4;
    end
    
    if isempty(PostTest_ZoneIndices{u}{1})
        Post_FirstTime(u) = 180;
    else
        Post_FirstZoneIndices(u) = PostTest_ZoneIndices{u}{1}(1);
        Post_FirstTime(u) =PostTime(Post_FirstZoneIndices(u),1)/1E4;
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
            Vtemp_pre{r}=Data(Pre_Vtsd{r});
            VZone_pre{r}=Vtemp_pre{r}(PreTest_ZoneIndices{r}{1}(1:end-1),1);
            VZmean_pre(r)=mean(VZone_pre{r},1);
        end
        
        % PostTest ShockZone speed
        if isempty(PostTest_ZoneIndices{r}{1})
            VZmean_post(r) = 0;
        else
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
figure('units', 'normalized', 'outerposition', [0 0 1 1],  'Color',[1 1 1])

% Trajectories in PreTests
subplot(4,2,1)
imagesc(Pre_mask);
colormap(gray)
hold on
imagesc(Pre_Zone{1}, 'AlphaData', 0.3);
hold on
for p=1:1:ntest
    plot(Data(Pre_Xtsd{p})*Pre_Ratio_IMAonREAL,Data(Pre_Ytsd{p})*Pre_Ratio_IMAonREAL,clrs{2,p},'linewidth',1)
    hold on
end
axis xy
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthEast');
title ('Trajectories in PreTests');

% Trajectories in PostTests
subplot(4,2,2)
imagesc(Post_mask);
colormap(gray)
hold on
imagesc(Post_Zone{1}, 'AlphaData', 0.3);
hold on
for l=1:1:ntest
    plot(Data(Post_Xtsd{l})*Post_Ratio_IMAonREAL,Data(Post_Ytsd{l})*Post_Ratio_IMAonREAL,clrs{2,l},'linewidth',1)
    hold on
end
axis xy
legend ('Test1','Test2','Test3','Test4', 'Location', 'NorthEast');
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
ylabel('Average speed (a.u.)')
xlim([0.5 2.5])
if p_VZmean_pre_post < 0.05
    H = sigstar({{'PreShock', 'AfterShock'}}, p_VZmean_pre_post);
end
box off
hold off
title ('Average speed in Pre- and PostTests');

%Save it
saveas(gcf, [dir_out 'M' nmouse '_' fig_post '.fig']);
saveFigure(gcf,['M' nmouse '_' fig_post],dir_out);


%% Save the resulting .mat file
save([dir_out 'BehResults.mat'], 'p_entnum_pre_post', 'p_FirstTime_pre_post', 'p_pre_post','p_VZmean_pre_post', 'point_pre_post',...
    'Pre_Post_entnum','Pre_Post_FirstTime','Pre_Post_VZmean');
