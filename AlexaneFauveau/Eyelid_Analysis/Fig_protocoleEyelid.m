

figure
ylim([-1 5]);
yl=ylim;
LineHeight = yl(2);
load('PiezoData_SleepScoring.mat');
plot(Range(Piezo_Mouse_tsd)/1e4 , Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330],'MarkerSize',50)
xlim([10 11])
ylim([-1 6])





figure
ylim([0 5]);
yl=ylim;
LineHeight = 0.5;
load('PiezoData_SleepScoring.mat');
Colors.Sleep = 'r';
Colors.Wake = 'c';
% yl=ylim;
% LineHeight = yl(2);
load PiezoData_SleepScoring Smooth_actimetry;
t = Range(Smooth_actimetry)/60e4;
begin = t(1);
endin = t(end);
PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 60e4, 'linewidth', 50);
PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 60e4, 'linewidth',50);
hold on
load('behavResources.mat', 'TTLInfo')
stimepoch = Start(TTLInfo.StimEpoch)/60e4
plot(stimepoch,0.5,'k*','MarkerSize',10)
xlim([0 max(t)])

xlim([120 220])






