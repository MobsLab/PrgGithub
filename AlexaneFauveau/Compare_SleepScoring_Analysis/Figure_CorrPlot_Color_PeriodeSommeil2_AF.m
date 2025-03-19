
disp('Figure CorrPlot loading ...')

i = 1
FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ5_240411/1563_BaselineSleep5_240411/';
    cd(FolderName{i});

    
%% Create the "Periode sommeil"
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
for i = 1:2
    subplot(2,1,i)
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

    subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
    X = log10(Data(Restrict(SmoothGamma,(and(Sleep_LongOnly_OB,Sleep_LongOnly_piezo))))); Y = log10(Data(Restrict(Actimetry_corr,(and(Sleep_LongOnly_OB,Sleep_LongOnly_piezo))))); 
    hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.r')
    axis square
    v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
    v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
    xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])

    subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
    X = log10(Data(Restrict(SmoothGamma,(and(Wake_modified_piezo,Wake_modified_OB))))); Y = log10(Data(Restrict(Actimetry_corr,(and(Wake_modified_piezo,Wake_modified_OB))))); 
    hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.c')
    axis square
    v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
    v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
    xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])

    subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
    X = log10(Data(Restrict(SmoothGamma,(and(Sleep_LongOnly_piezo,Wake_modified_OB))))); Y = log10(Data(Restrict(Actimetry_corr,(and(Sleep_LongOnly_piezo,Wake_modified_OB))))); 
    hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.g')
    axis square
    v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
    v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
    xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])

    subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
    X = log10(Data(Restrict(SmoothGamma,(and(Wake_modified_piezo,Sleep_LongOnly_OB))))); Y = log10(Data(Restrict(Actimetry_corr,(and(Wake_modified_piezo,Sleep_LongOnly_OB))))); 
    hold on, plot(X(1:2000:end) , Y(1:2000:end) , '.b')
    axis square
    v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
    v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
    xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))])
    ylim([
        end
        


% saveas(fig, 'CorrPlotSleepScoringOB.png')

%% Movement / Actimetry
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


%
length(Periode_sommeil_piezo)
length(Periode_sommeil_accelero)




fig = figure

figure('Position',[600 100 800 750])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(Restrict(temptsd,Periode_sommeil_accelero))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); 
xlim([6 max(log10(Data(temptsd)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Restrict(Actimetry_corr,Periode_sommeil_piezo))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
xlim([-1.75 0.5])
 
% subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
% X = log10(Data(temptsd)); Y = log10(Data(Actimetry_corr)); 
% plot(X(1:20:end) , Y(1:20:end) , '.k')
% axis square
% v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
% v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
% xlim([min(log10(Data(temptsd))) max(log10(Data(temptsd)))]);

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict((Restrict(temptsd,Periode_sommeil_accelero)),(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero))))); Y = log10(Data(Restrict((Restrict(Actimetry_corr,Periode_sommeil_piezo)),Restrict(temptsd,(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict((Restrict(temptsd,Periode_sommeil_accelero)),(and(Wake_modified_piezo,Wake_modified_accelero))))); Y = log10(Data(Restrict((Restrict(Actimetry_corr,Periode_sommeil_piezo)),Restrict(temptsd,(and(Wake_modified_piezo,Wake_modified_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict((Restrict(temptsd,Periode_sommeil_accelero)),(and(Sleep_LongOnly_piezo,Wake_modified_accelero))))); Y = log10(Data(Restrict((Restrict(Actimetry_corr,Periode_sommeil_piezo)),Restrict(temptsd,(and(Sleep_LongOnly_piezo,Wake_modified_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict((Restrict(temptsd,Periode_sommeil_accelero)),(and(Wake_modified_piezo,Sleep_LongOnly_accelero))))); Y = log10(Data(Restrict((Restrict(Actimetry_corr,Periode_sommeil_piezo)),Restrict(temptsd,(and(Wake_modified_piezo,Sleep_LongOnly_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])
ylim([-1.75 0.5])



figure
subplot(6,12,[2:6 2:6 2:6  26:30])

figure('Position',[600 100 1500 1000])




% saveas(fig, 'CorrPlotSleepScoringAccelero.png')

disp('Figure CorrPlot done')