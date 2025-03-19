
disp('Figure CorrPlot loading ...')

%% OB / Actimetry
load('SleepScoring_OBGamma.mat') 
load('PiezoData_SleepScoring.mat') 
Actimetry_corr =  Restrict(Smooth_actimetry , SmoothGamma);

X = log10(Data(SmoothGamma));
Y = log10(Data(Actimetry_corr));

load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')
 
fig = figure
subplot(6,6,32.5:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)'); 
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
 
% subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
% X = log10(Data(SmoothGamma)); Y = log10(Data(Actimetry_corr)); 
% plot(X(1:2000:end) , Y(1:2000:end) , '.k')
% axis square
% v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
% v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
% xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothGamma,(and(Sleep,SleepEpoch_Piezo))))); Y = log10(Data(Restrict(Actimetry_corr,(and(Sleep,SleepEpoch_Piezo))))); 
hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.r')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothGamma,(and(WakeEpoch_Piezo,Wake))))); Y = log10(Data(Restrict(Actimetry_corr,(and(WakeEpoch_Piezo,Wake))))); 
hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.c')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothGamma,(and(SleepEpoch_Piezo,Wake))))); Y = log10(Data(Restrict(Actimetry_corr,(and(SleepEpoch_Piezo,Wake))))); 
hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.g')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(SmoothGamma,(and(WakeEpoch_Piezo,Sleep))))); Y = log10(Data(Restrict(Actimetry_corr,(and(WakeEpoch_Piezo,Sleep))))); 
hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.b')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])




% saveas(fig, 'CorrPlotSleepScoringOB.png')

%% Movement / Actimetry
clear all
load('SleepScoring_Accelero.mat') 
load('SleepScoring_OBGamma.mat', 'SmoothGamma')
load('PiezoData_SleepScoring.mat') 
Actimetry_corr =  Restrict(Smooth_actimetry , tsdMovement);
temp=Data(tsdMovement);
temp(temp<0)=0;
temptsd=tsd(Range(tsdMovement),temp);

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')

fig = figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(temptsd)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); 
xlim([6 max(log10(Data(temptsd)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
xlim([-1.75 0.5])
 
% subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
% X = log10(Data(temptsd)); Y = log10(Data(Actimetry_corr)); 
% plot(X(1:2000:end) , Y(1:2000:end) , '.k')
% axis square
% v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
% v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
% xlim([min(log10(Data(temptsd))) max(log10(Data(temptsd)))]);

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd,(and(SleepEpoch_Piezo,Sleep))))); Y = log10(Data(Restrict(Actimetry_corr,Restrict(temptsd,(and(SleepEpoch_Piezo,Sleep)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd,(and(WakeEpoch_Piezo,Wake))))); Y = log10(Data(Restrict(Actimetry_corr,Restrict(temptsd,(and(WakeEpoch_Piezo,Wake)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd,(and(SleepEpoch_Piezo,Wake))))); Y = log10(Data(Restrict(Actimetry_corr,Restrict(temptsd,(and(SleepEpoch_Piezo,Wake)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd,(and(WakeEpoch_Piezo,Sleep))))); Y = log10(Data(Restrict(Actimetry_corr,Restrict(temptsd,(and(WakeEpoch_Piezo,Sleep)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])
ylim([-1.75 0.5])





% saveas(fig, 'CorrPlotSleepScoringAccelero.png')

disp('Figure CorrPlot done')