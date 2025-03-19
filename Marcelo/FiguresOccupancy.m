Maze1_1X = Data(Restrict(Xtsd,SessionEpoch.HabMaze1_1));
Maze1_1Y = Data(Restrict(Ytsd,SessionEpoch.HabMaze1_1));
Maze1_2X = Data(Restrict(Xtsd,SessionEpoch.HabMaze1_2));
Maze1_2Y = Data(Restrict(Ytsd,SessionEpoch.HabMaze1_2));
Maze2_1X = Data(Restrict(Xtsd,SessionEpoch.HabMaze2_1));
Maze2_1Y = Data(Restrict(Ytsd,SessionEpoch.HabMaze2_1));
Maze2_2X = Data(Restrict(Xtsd,SessionEpoch.HabMaze2_2));
Maze2_2Y = Data(Restrict(Ytsd,SessionEpoch.HabMaze2_2));

OccupLabels={'Left';'Right'};

figure
% Trajectories only
% subplot(2,2,1)
% plot(Maze1_1X,Maze1_1Y,'k');
% title('Maze 1');
% xlabel('Position X (cm)','fontweight','bold','fontsize',10);
% ylabel('Position Y (cm)','fontweight','bold','fontsize',10);
% set(gca,'FontWeight','bold')


% subplot(2,2,2)
% plot(Maze1_2X,Maze1_2Y,'k');
% title('Maze 1 - After 5 min of rest');
% xlabel('Position X (cm)','fontweight','bold','fontsize',10);
% ylabel('Position Y (cm)','fontweight','bold','fontsize',10);
% set(gca,'FontWeight','bold')

% Heat maps
subplot(2,2,1)

[occH, x1, x2] = hist2(Maze1_1X, Maze1_1Y, 240, 320);
occHS(1:320,1:240) = SmoothDec(occH/15,[2,2]);
x=x1;
y=x2;

imagesc(x1,x2,occHS)
caxis([0 .1]) % control color intensity here
colormap(hot)
hold on
% -- trajectories
p1 = plot(Maze1_1X,Maze1_1Y, 'w', 'linewidth',1.5);
p1.Color(4) = .3;    %control line color intensity here
hold on
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

title('Maze 1');

subplot(2,2,2)

[occH, x1, x2] = hist2(Maze1_2X, Maze1_2Y, 240, 320);
occHS(1:320,1:240) = SmoothDec(occH/15,[2,2]);
x=x1;
y=x2;

imagesc(x1,x2,occHS)
caxis([0 .1]) % control color intensity here
colormap(hot)
hold on
% -- trajectories
p1 = plot(Maze1_2X,Maze1_2Y, 'w', 'linewidth',1.5);
p1.Color(4) = .3;    %control line color intensity here
hold on
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

title('Maze 1 - After 5 min of rest');

subplot(2,2,3)
bar(100*OccupM11,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Zone occupancy - Maze 1');

subplot(2,2,4)
bar(100*OccupM12,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
ylim([0 60]);
title('Zone occupancy - Maze 1 after rest');

figure
% Trajectories only
% subplot(2,2,1)
% plot(Maze2_1X,Maze2_1Y,'k');
% title('Maze 2');
% xlabel('Position X (cm)','fontweight','bold','fontsize',10);
% ylabel('Position Y (cm)','fontweight','bold','fontsize',10);
% set(gca,'FontWeight','bold')
% 
% 
% subplot(2,2,2)
% plot(Maze2_2X,Maze2_2Y,'k');
% title('Maze 2 - After 1 hour of sleep');
% xlabel('Position X (cm)','fontweight','bold','fontsize',10);
% ylabel('Position Y (cm)','fontweight','bold','fontsize',10);
% set(gca,'FontWeight','bold')


% Heat maps
subplot(2,2,1)

[occH, x1, x2] = hist2(Maze2_1X, Maze2_1Y, 240, 320);
occHS(1:320,1:240) = SmoothDec(occH/15,[2,2]);
x=x1;
y=x2;

imagesc(x1,x2,occHS)
caxis([0 .1]) % control color intensity here
colormap(hot)
hold on
% -- trajectories
p1 = plot(Maze2_1X,Maze2_1Y, 'w', 'linewidth',1.5);
p1.Color(4) = .3;    %control line color intensity here
hold on
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

title('Maze 2');

subplot(2,2,2)

[occH, x1, x2] = hist2(Maze2_2X, Maze2_2Y, 240, 320);
occHS(1:320,1:240) = SmoothDec(occH/15,[2,2]);
x=x1;
y=x2;

imagesc(x1,x2,occHS)
caxis([0 .1]) % control color intensity here
colormap(hot)
hold on
% -- trajectories
p1 = plot(Maze2_2X,Maze2_2Y, 'w', 'linewidth',1.5);
p1.Color(4) = .5;    %control line color intensity here
hold on
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);

title('Maze 2 - After 1 hour of sleep');

subplot(2,2,3)
bar(100*OccupM21,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
ylim([0 50]);
title('Zone occupancy - Maze 2');

subplot(2,2,4)
bar(100*OccupM22,'k')
set(gca,'xticklabel',OccupLabels)
set(gca,'FontWeight','bold')
ylabel('Occupancy (%)','fontweight','bold','fontsize',10);
ylim([0 90]);
title('Zone occupancy - Maze 2 after sleep');
