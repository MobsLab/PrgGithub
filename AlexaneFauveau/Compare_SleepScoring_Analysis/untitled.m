%% Plot to illustrate SleepScoring



% Données presque brutes
figure,
subplot(311)
load('SleepScoring_OBGamma.mat')
load('/media/gruffalo/DataMOBS198/Piezo/1566_1569_1568_1562_HabJ11 _240422_103619/1566_BaselineSleep11_240422/LFPData/LFP27.mat')
plot(Range(LFP,'s'),Data(LFP),'color',[0.9290 0.6940 0.1250])
xlim([10 11])
xlabel('Temps (s)')
ylabel('UA')

subplot(312)
load('behavResources.mat')
plot(Range(MovAcctsd,'s'),Data(MovAcctsd),'g')
xlim([0 max(Range(SmoothGamma,'s'))])
xlabel('Temps (s)')
ylabel('UA')

subplot(313)
load('PiezoData_SleepScoring.mat')
plot(Range(Piezo_Mouse_tsd,'s'),Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330])
xlim([0 max(Range(SmoothGamma,'s'))])
xlabel('Temps (s)')
ylabel('UA')

subplot(311)
xl = xlim;
subplot(312)
xlim(xl);
subplot(313)
xlim(xl);



% Données utilisées pour le SleepScoring
figure,
subplot(311)
load('SleepScoring_OBGamma.mat')
plot(Range(SmoothGamma,'s'),Data(SmoothGamma),'color',[0.9290 0.6940 0.1250])
xlim([0 max(Range(SmoothGamma,'s'))])
xlabel('Temps (s)')
ylabel('UA')
title('OB Gamma')

subplot(312)
load('SleepScoring_Accelero.mat')
plot(Range(tsdMovement,'s'),Data(tsdMovement),'g')
xlim([0 max(Range(SmoothGamma,'s'))])
xlabel('Temps (s)')
ylabel('UA')
ylim([0 8e8])
title('Accéléromètre')

subplot(313)
load('PiezoData_SleepScoring.mat')
plot(Range(Smooth_actimetry,'s'),Data(Smooth_actimetry),'color',[0.3010 0.7450 0.9330])
xlim([0 max(Range(SmoothGamma,'s'))])
xlabel('Temps (s)')
ylabel('UA')
title('Piézo')

subplot(311)
xl = xlim;
subplot(312)
xlim(xl);
subplot(313)
xlim(xl);


