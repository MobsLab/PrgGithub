%% Code to plot the figure of SleepScoring Comparaison

function Figure_CompaSleepScoring_AF

disp('Load Figure Compa Sleep Scoring ...')

Colors.Sleep = 'r';
Colors.Wake = 'c';
% yl=ylim;
% LineHeight = yl(2);
load PiezoData_SleepScoring Smooth_actimetry;
t = Range(Smooth_actimetry);
begin = t(1);
endin = t(end);

fig_compa = figure ; 
subplot(3,1,1)
ylim([0 2000]);
yl=ylim;
LineHeight = yl(2);
load('SleepScoring_OBGamma.mat');
plot(Range(SmoothGamma)/3600e4,Data(SmoothGamma),'color',[0.9290 0.6940 0.1250])
hold on, plot(Range(Restrict(SmoothGamma,Wake))/3600e4,Data(Restrict(SmoothGamma,Wake)),'k')
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
title('OB Gamma','FontSize',15)
xlim([0 max(Range(Smooth_actimetry)/3600e4)]);
ylim([0 2000]);
xlabel('Temps (h)')
ylabel('Puissance du Gamma (UA)')

subplot(3,1,2)
ylim([2.8 4]);
yl=ylim;
LineHeight = yl(2);
load('SleepScoring_Accelero.mat');
plot(Range(tsdMovement)/3600e4,3+Data(tsdMovement)/1e9, 'g')
hold on, plot(Range(Restrict(tsdMovement,Wake))/3600e4,3+Data(Restrict(tsdMovement,Wake))/1e9,'k')
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
title('Accéléromètre','FontSize',15)
xlim([0 max(Range(Smooth_actimetry)/3600e4)]);
ylim([2.8 4]);
xlabel('Temps (h)')
ylabel('Accélération (UA)')

subplot(3,1,3)
ylim([-1 5]);
yl=ylim;
LineHeight = yl(2);
load('PiezoData_SleepScoring.mat');
plot(Range(Smooth_actimetry)/3600e4 , Data(Smooth_actimetry),'color',[0.3010 0.7450 0.9330])
hold on, plot(Range(Restrict(Smooth_actimetry,WakeEpoch_Piezo))/3600e4 , Data(Restrict(Smooth_actimetry,WakeEpoch_Piezo)),'k')
PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
title('Piézo','FontSize',15)
xlim([0 max(Range(Smooth_actimetry)/3600e4)]);
ylim([-1 5]);
xlabel('Temps (h)')
ylabel('Mesure du piézo (UA)')

suplabel('Comparaison of Sleep scorings methods (Wake=cyan, Sleep=red)','t');

saveas(fig_compa, 'Figure_ComparaisonSleepScoring.png')

disp('Figure Compa Sleep Scoring done')

