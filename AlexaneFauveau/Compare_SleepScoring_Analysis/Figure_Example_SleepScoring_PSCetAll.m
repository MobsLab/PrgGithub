% Create the Sleep without microwake    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
    load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_LongOnly_OB = and(Sleep, Periode_sommeil_OB);
    Wake_modified_OB = and(Wake, Periode_sommeil_OB);
    clear Sleep
    clear Wake
    

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_LongOnly_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_modified_accelero = and(Wake, Periode_sommeil_accelero);

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    Sleep_LongOnly_piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    Wake_modified_piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);

    figure 
    subplot(311)
    plot(Range(SmoothGamma)/3600e4, Data(SmoothGamma),'color', [.5 .5 .5])
    hold on, plot(Range(Restrict(SmoothGamma,Periode_sommeil_OB))/3600e4, Data(Restrict(SmoothGamma,Periode_sommeil_OB)),'g');
    hold on, plot(Range(Restrict(SmoothGamma,Sleep_LongOnly_OB))/3600e4, Data(Restrict(SmoothGamma,Sleep_LongOnly_OB)),'r');
    hold on, plot(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4, Data(Restrict(SmoothGamma,Wake_modified_OB)),'c');
    xlabel('Temps en heure')
    xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
    title('OB Gamma')
    
    subplot(312)
    plot(Range(tsdMovement)/3600e4, Data(tsdMovement),'color', [.5 .5 .5])
    hold on, plot(Range(Restrict(tsdMovement,Periode_sommeil_accelero))/3600e4, Data(Restrict(tsdMovement,Periode_sommeil_accelero)),'g');
    hold on, plot(Range(Restrict(tsdMovement,Sleep_LongOnly_accelero))/3600e4, Data(Restrict(tsdMovement,Sleep_LongOnly_accelero)),'r');
    hold on, plot(Range(Restrict(tsdMovement,Wake_modified_accelero))/3600e4, Data(Restrict(tsdMovement,Wake_modified_accelero)),'c');
    xlabel('Temps en heure') 
    xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
    title('Mouvement')

    subplot(313)
    plot(Range(Smooth_actimetry)/3600e4, Data(Smooth_actimetry),'color', [.5 .5 .5])
    hold on, plot(Range(Restrict(Smooth_actimetry,Periode_sommeil_piezo))/3600e4, Data(Restrict(Smooth_actimetry,Periode_sommeil_piezo)),'g');
    hold on, plot(Range(Restrict(Smooth_actimetry,Sleep_LongOnly_piezo))/3600e4, Data(Restrict(Smooth_actimetry,Sleep_LongOnly_piezo)),'r');
    hold on, plot(Range(Restrict(Smooth_actimetry,Wake_modified_piezo))/3600e4, Data(Restrict(Smooth_actimetry,Wake_modified_piezo)),'c');
    xlabel('Temps en heure')
    xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
    title('Piézo')
      
      
%     subplot(311)
%     xl = xlim
%     subplot(312)
%     xlim(xl)
%     subplot(313)
%     xlim(xl)
%     


Colors.Sleep = 'r';
Colors.Wake = 'c';
% yl=ylim;
% LineHeight = yl(2);
load PiezoData_SleepScoring Smooth_actimetry;
t = Range(Smooth_actimetry);
begin = t(1);
endin = t(end);


figure 
subplot(311)
plot(Range(SmoothGamma)/3600e4, Data(SmoothGamma),'color', [.5 .5 .5])
hold on, plot(Range(Restrict(SmoothGamma,Periode_sommeil_OB))/3600e4, Data(Restrict(SmoothGamma,Periode_sommeil_OB)),'color',[0.9290 0.6940 0.1250]);
hold on, plot(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4, Data(Restrict(SmoothGamma,Wake_modified_OB)),'k');
ylim([0 2000]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep_LongOnly_OB, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake_modified_OB, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
title('OB Gamma')
xlabel('Temps (h)')
ylabel('Puissance du Gamma (UA)')

subplot(312)
plot(Range(tsdMovement)/3600e4, Data(tsdMovement),'color', [.5 .5 .5])
hold on, plot(Range(Restrict(tsdMovement,Periode_sommeil_accelero))/3600e4, Data(Restrict(tsdMovement,Periode_sommeil_accelero)),'g');
hold on, plot(Range(Restrict(tsdMovement,Wake_modified_accelero))/3600e4, Data(Restrict(tsdMovement,Wake_modified_accelero)),'k');
ylim([-0.5 6*10^(8)]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep_LongOnly_accelero, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake_modified_accelero, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
title('Accéléromètre')
xlabel('Temps (h)')
ylabel('Accélération (UA)')


subplot(313)
plot(Range(Smooth_actimetry)/3600e4, Data(Smooth_actimetry),'color',[.5 .5 .5])
hold on, plot(Range(Restrict(Smooth_actimetry,Periode_sommeil_piezo))/3600e4, Data(Restrict(Smooth_actimetry,Periode_sommeil_piezo)),'color',[0.3010 0.7450 0.9330]);
hold on, plot(Range(Restrict(Smooth_actimetry,Wake_modified_piezo))/3600e4, Data(Restrict(Smooth_actimetry,Wake_modified_piezo)),'k');
ylim([-1 5]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep_LongOnly_piezo, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake_modified_piezo, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
xlim([0 max(Range(Restrict(SmoothGamma,Wake_modified_OB))/3600e4)])
title('Piézo')
xlabel('Temps (h)')
ylabel('Mesure du piézo (UA)')



%% Toute la session

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
title('OB Gamma')
xlim([0 max(Range(Restrict(SmoothGamma,Wake))/3600e4)])
ylim([0 2000]);
xlabel('Temps en heure')
ylabel('UA')

subplot(3,1,2)
ylim([2.8 4]);
yl=ylim;
LineHeight = yl(2);
load('SleepScoring_Accelero.mat');
plot(Range(tsdMovement)/3600e4,3+Data(tsdMovement)/1e9, 'g')
hold on, plot(Range(Restrict(tsdMovement,Wake))/3600e4,3+Data(Restrict(tsdMovement,Wake))/1e9,'k')
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
title('Mouvement')
xlim([0 max(Range(Restrict(SmoothGamma,Wake))/3600e4)])
ylim([2.8 4]);
xlabel('Temps en heure')
ylabel('UA')


subplot(3,1,3)
ylim([-1 5]);
yl=ylim;
LineHeight = yl(2);
load('PiezoData_SleepScoring.mat');
plot(Range(Smooth_actimetry)/3600e4 , Data(Smooth_actimetry),'color',[0.3010 0.7450 0.9330])
hold on, plot(Range(Restrict(Smooth_actimetry,WakeEpoch_Piezo))/3600e4 , Data(Restrict(Smooth_actimetry,WakeEpoch_Piezo)),'k')
PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
title('Piézo')
xlim([0 max(Range(Restrict(SmoothGamma,Wake))/3600e4)])
ylim([-1 5]);
xlabel('Temps en heure')
ylabel('UA')








