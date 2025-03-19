function Figure_Corrplot_SleepScoring_AF

disp('Figure CorrPlot loading ...')

%% OB / Actimetry
load('SleepScoring_OBGamma.mat', 'SmoothGamma') 
load('PiezoData_SleepScoring.mat', 'Smooth_actimetry') 
Actimetry_corr =  Restrict(Smooth_actimetry , SmoothGamma);

X = log10(Data(SmoothGamma));
Y = log10(Data(Actimetry_corr));

load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')
 
fig = figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)'); xlim([1.8 3.1])

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(SmoothGamma)); Y = log10(Data(Actimetry_corr)); 
plot(X(1:2000:end) , Y(1:2000:end) , '.k')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([1.8 3.1])




saveas(fig, 'CorrPlotSleepScoringOB.png')

%% Movement / Actimetry
load('SleepScoring_Accelero.mat', 'tsdMovement') 
load('SleepScoring_OBGamma.mat', 'SmoothGamma')
load('PiezoData_SleepScoring.mat', 'Smooth_actimetry') 
Mov_corr = Restrict(tsdMovement , SmoothGamma);
Actimetry_corr =  Restrict(Smooth_actimetry , SmoothGamma);

X = log10(Data(Mov_corr));
Y = log10(Data(Actimetry_corr));

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')

fig = figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(Mov_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); xlim([5 9])

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
 
subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Mov_corr)); Y = log10(Data(Actimetry_corr)); 
plot(X(1:2000:end) , Y(1:2000:end) , '.k')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([5 9])


saveas(fig, 'CorrPlotSleepScoringAccelero.png')

disp('Figure CorrPlot done')

