

mm=2; neur=4;
subplot(131)
imagesc(map_mov{sess}{mm}{neur}.rate(8:56,8:56)), axis xy
title([num2str(round(stats{sess}{mm}{neur}.spatialInfo,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.sparsity,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.specificity,2)) ' / ' num2str(neur)])
sizeMap=50; Maze_Frame_BM, hold on
a=area([19 32],[37 37]);
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
hold on
plot(stats{sess}{mm}{neur}.x(1)-8,stats{sess}{mm}{neur}.y(1)-8,'.','MarkerSize',30)
axis off

mm=3; neur=78;% 4 43
subplot(132)
imagesc(map_mov{sess}{mm}{neur}.rate(8:56,8:56)), axis xy
title([num2str(round(stats{sess}{mm}{neur}.spatialInfo,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.sparsity,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.specificity,2)) ' / ' num2str(neur)])
sizeMap=50; Maze_Frame_BM, hold on
a=area([19 32],[37 37]);
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
hold on
plot(stats{sess}{mm}{neur}.x(1)-8,stats{sess}{mm}{neur}.y(1)-8,'.','MarkerSize',30)
axis off

mm=8; neur=42; % 9 2
subplot(133)
imagesc(map_mov{sess}{mm}{neur}.rate(8:56,8:56)), axis xy
title([num2str(round(stats{sess}{mm}{neur}.spatialInfo,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.sparsity,2)) ' / ' num2str(round(stats{sess}{mm}{neur}.specificity,2)) ' / ' num2str(neur)])
sizeMap=50; Maze_Frame_BM, hold on
a=area([19 32],[37 37]);
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;
hold on
plot(stats{sess}{mm}{neur}.x(1)-8,stats{sess}{mm}{neur}.y(1)-8,'.','MarkerSize',30)
axis off


