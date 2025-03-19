%%% ShowExampleTrajectory_ERC2

% Getting you clean and nice trajectories from aversive wakefulness 
% experiment of the mouse you choose

%% Parameters

nmouse = 912;
FracArea = 0.8;

%% Load Data
% PreTests
DirPre=PathForExperimentsERC_Dima('TestPre');
DirPre = RestrictPathForExperiment(DirPre,'nMice',nmouse);
for i=1:length(DirPre.path{1})
    a = load([DirPre.path{1}{i} '/behavResources.mat'], 'mask', 'PosMat', 'PosMatInit','Ratio_IMAonREAL');
    PreTest_PosMat{i} = a.PosMat;
    PreTest_PosMatInit{i} = a.PosMatInit;
    if i==1
        PreTest_mask = a.mask;
        PreTest_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    end
end

% Cond
DirCond=PathForExperimentsERC_Dima('Cond');
DirCond = RestrictPathForExperiment(DirCond,'nMice',nmouse);
for i=1:length(DirCond.path{1})
    a = load([DirCond.path{1}{i} '/behavResources.mat'], 'mask', 'PosMat', 'PosMatInit','Ratio_IMAonREAL');
    Cond_PosMat{i} = a.PosMat;
    Cond_PosMatInit{i} = a.PosMatInit;
    if i==1
        Cond_mask = a.mask;
        Cond_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    end
end

% PostTest
DirPost=PathForExperimentsERC_Dima('TestPost');
DirPost = RestrictPathForExperiment(DirPost,'nMice',nmouse);
for i=1:length(DirPost.path{1})
    a = load([DirPost.path{1}{i} '/behavResources.mat'], 'mask', 'PosMat', 'PosMatInit','Ratio_IMAonREAL');
    PostTest_PosMat{i} = a.PosMat;
    PostTest_PosMatInit{i} = a.PosMatInit;
    if i==1
        PostTest_mask = a.mask;
        PostTest_Ratio_IMAonREAL = a.Ratio_IMAonREAL;
    end
end
clear a

%% Plot Figure

ffh = figure('units', 'normalized', 'outerposition', [0 0 1 0.6]);

% PreTests
subplot(1,3,1)
hold on
for i=1:4
    plot(PreTest_PosMat{i}(:,3),PreTest_PosMat{i}(:,2),'LineWidth',3);
end
% Get Mask
stats = regionprops(PreTest_mask, 'Area');
tempmask=PreTest_mask;
AimArea=stats.Area*FracArea;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
new_mask=bwboundaries(tempmask);
NewMask=new_mask{1}./PreTest_Ratio_IMAonREAL;

[xmin,xmax] = bounds(NewMask(:,1));
[ymin,ymax] = bounds(NewMask(:,2));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

plot(NewMask(:,1),NewMask(:,2),'k','LineWidth',2)
% legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PreTest Trajectories');
set(gca,'FontWeight','bold','FontSize',14);
set(gca,'LineWidth',3);
xlim(x_range);
ylim(y_range);
hold off

% Cond
for i=1:4
    shockidx{i} = find(Cond_PosMatInit{i}(:,4)==1);
end

subplot(1,3,2)
hold on
for i=1:4
    plot(Cond_PosMat{i}(:,3),Cond_PosMat{i}(:,2),'LineWidth',3);
    for j=1:length(shockidx{i})
        plot(Cond_PosMat{i}(shockidx{i}(j),3),Cond_PosMat{i}(shockidx{i}(j),2),'ro','MarkerSize',14);
    end
end
% Get Mask
stats = regionprops(Cond_mask, 'Area');
tempmask=Cond_mask;
AimArea=stats.Area*FracArea;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
new_mask=bwboundaries(tempmask);
NewMask=new_mask{1}./Cond_Ratio_IMAonREAL;

[xmin,xmax] = bounds(NewMask(:,1));
[ymin,ymax] = bounds(NewMask(:,2));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

plot(NewMask(:,1),NewMask(:,2),'k','LineWidth',2)
% legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('Cond Trajectories');
set(gca,'FontWeight','bold','FontSize',14);
set(gca,'LineWidth',3);
xlim(x_range);
ylim(y_range);
hold off

% PostTests
subplot(1,3,3)
hold on
for i=1:4
    plot(PostTest_PosMat{i}(:,3),PostTest_PosMat{i}(:,2),'LineWidth',3);
end
% Get Mask
stats = regionprops(PostTest_mask, 'Area');
tempmask=PostTest_mask;
AimArea=stats.Area*FracArea;
ActArea=stats.Area;
while AimArea<ActArea
    tempmask=imerode(tempmask,strel('disk',1));
    stats = regionprops(tempmask, 'Area');
    ActArea=stats.Area;
end
new_mask=bwboundaries(tempmask);
NewMask=new_mask{1}./PostTest_Ratio_IMAonREAL;

[xmin,xmax] = bounds(NewMask(:,1));
[ymin,ymax] = bounds(NewMask(:,2));

y_range=[ymin-3 ymax+3];
x_range=[xmin-3 xmax+3];

plot(NewMask(:,1),NewMask(:,2),'k','LineWidth',2)
% legend('Trial 1','Trial 2','Trial 3','Trial 4');
title('PostTest Trajectories');
set(gca,'FontWeight','bold','FontSize',14);
set(gca,'LineWidth',3);
xlim(x_range);
ylim(y_range);
hold off

%%
clear all