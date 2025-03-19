one = 34;
two = 53;


CPre1 = cell(1,1);
CTask1 = cell(1,1);
CPost1 = cell(1,1);
[CPre1,B] = CrossCorrDB(Data(Restrict(spikes{i}.S{one},PreSleepFinal{i})),...
    Data(Restrict(spikes{i}.S{two},PreSleepFinal{i})),4,200);
[CTask1,B] = CrossCorrDB(Data(Restrict(spikes{i}.S{one},UMazeMovingEpoch{i})),...
    Data(Restrict(spikes{i}.S{two},UMazeMovingEpoch{i})),4,200);
[CPost1,B] = CrossCorrDB(Data(Restrict(spikes{i}.S{one},PostSleepFinal{i})),...
    Data(Restrict(spikes{i}.S{two},PostSleepFinal{i})),4,200);


fff = figure('units', 'normalized', 'outerposition', [0 0.55 0.4 0.85]);
ax = arrayfun(@(i) subplot(3,1,i, 'NextPlot', 'add', 'Box', 'off'), [1:3]);
bar(ax(1), B, runmean(CPre1,3), 'k', 'LineWidth', 2);
ylim(ax(1), [0 5])
set(ax(1),'FontSize', 18, 'FontWeight', 'bold', 'XTick', B, 'XTickLabel',{[]}, 'YTick', [0 5], 'YTickLabel', {'0', '5'});
title(ax(1),'PreSleep');
hold on
line(ax(1), [0 0], [0 5], 'Color', 'r', 'LineWidth', 3);
hold off
bar(ax(2), B, runmean(CTask1,3), 'k', 'LineWidth', 2);
set(ax(2),'FontSize', 18, 'FontWeight', 'bold', 'XTick', B, 'XTickLabel',{[]}, 'YTick', [0 20], 'YTickLabel', {'0', '20'});
ylim(ax(2),[0 20])
title(ax(2),'NoStimTask')
hold on
line(ax(2), [0 0], [0 20], 'Color', 'r', 'LineWidth', 3);
hold off
bar(ax(3), B, runmean(CPost1,3), 'k', 'LineWidth', 2);
set(ax(3),'FontSize', 18, 'FontWeight', 'bold', 'YTick', [0 5], 'YTickLabel', {'0', '5'});
ylim(ax(3),[0 5])
hold on
line(ax(3), [0 0], [0 5], 'Color', 'r', 'LineWidth', 3);
hold off
title(ax(3),'PostSleep')
xlabel(ax(3), 'Time (ms)')


saveas(fff,[dropbox '/MOBS_workingON/Dima/Ongoing_results/React-Replay/Examples/M994_Cl34vsCl53.fig']);
saveFigure(fff,'M994_Cl34vsCl53',...
[dropbox '/MOBS_workingON/Dima/Ongoing_results/React-Replay/Examples/']);


fh = figure('units', 'normalized', 'outerposition', [0 1 0.4 0.6]);

imagesc(map53.rate);
axis xy
colormap jet
hold on
plot(mazeMap(:,1),mazeMap(:,2),'w','LineWidth',4)
plot(ShockZoneMap(:,1),ShockZoneMap(:,2),'r','LineWidth',4)
set(gca,'XTickLabel',{},'YTickLabel',{});


saveas(fh,[dropbox '/MOBS_workingON/Dima/Ongoing_results/React-Replay/Examples/M994_map53.fig']);
saveFigure(fh,'M994_map53',...
[dropbox '/MOBS_workingON/Dima/Ongoing_results/React-Replay/Examples/']);