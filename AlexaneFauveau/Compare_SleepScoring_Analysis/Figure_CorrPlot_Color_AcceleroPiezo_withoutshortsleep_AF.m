%% Code to do the Color Corrplot for all the recording and the "Période sommeil"

clear all 

%% Create the FolderName

i=0;
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ5_240411/1563_BaselineSleep5_240411/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1562_BaselineSleep6_240412/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1563_BaselineSleep6_240412/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ8_240416_104716/1562_BaselineSleep8_240416/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ8_240416_104716/1563_BaselineSleep8_240416/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ9_240417_111622/1562_BaselineSleep9_240417/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ9_240417_111622/1563_BaselineSleep9_240417/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ10_240418_094639/1562_BaselineSleep10_240418/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ10_240418_094639/1563_BaselineSleep10_240418/1563_BaselineSleep10/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1566_1569_1568_1562_HabJ11 _240422_103619/1562_BaselineSleep11_240422/1562_BaselineSleep11/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1563_BaselineSleep12_240423/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1566_BaselineSleep12_240423/1566_BaselineSleep12/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1568_BaselineSleep12_240423/';
% i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/Piezo/1563_1569_1568_1566_HabJ12_240423_095451/1569_BaselineSleep12_240423/';


% Choose the folder name: 
i = 4 ;
    cd(FolderName{i});

    
    
% Give the files to save the figures : 
SaveFolderName = '/home/gruffalo/Dropbox/Mobs_member/AlexaneFauveau/Figures_Présentation/Figures_CorrPlotColor/';
    
%% Create the "Periode sommeil" for each SleepScoring
    % Create the Sleep without microwake    load('SleepScoring_OBGamma.mat','Sleep');
% % % %     load('SleepScoring_Accelero.mat','Sleep');
% % % %     load('SleepScoring_Accelero.mat','Wake');
% % % %     load('SleepScoring_Accelero.mat','tsdMovement');
% % % %     Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
% % % %     Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
% % % %     Sleep_LongOnly_accelero = and(Sleep, Periode_sommeil_accelero);
% % % %     Wake_modified_accelero = and(Wake, Periode_sommeil_accelero);
% % % % 
% % % %     
% % % %     load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
% % % %     load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
% % % %     load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
% % % %     load('PiezoData_SleepScoring.mat','Smooth_actimetry');
% % % %     Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
% % % %     Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
% % % %     Sleep_LongOnly_piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
% % % %     Wake_modified_piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);
    

    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    load('SleepScoring_Accelero.mat','tsdMovement');
%     Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
%     Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
Periode_sommeil_accelero = intervalSet(0,max(Range(tsdMovement)));
    Sleep_LongOnly_accelero = and(Sleep, Periode_sommeil_accelero);
    Sleep_LongOnly_accelero = dropShortIntervals(Sleep_LongOnly_accelero,10*1e4);
    Wake_modified_accelero = Periode_sommeil_accelero - Sleep_LongOnly_accelero;

    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    load('PiezoData_SleepScoring.mat','Smooth_actimetry');
%     Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
%     Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
Periode_sommeil_piezo = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
    Sleep_LongOnly_piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    Sleep_LongOnly_piezo = dropShortIntervals(Sleep_LongOnly_piezo,10*1e4);
    Wake_modified_piezo = Periode_sommeil_piezo-Sleep_LongOnly_piezo;
    
    
    
%% Movement / Actimetry
% Load the data smooth 
load('PiezoData_SleepScoring.mat') 
Actimetry_corr =  Restrict(Smooth_actimetry , tsdMovement);
temp=Data(tsdMovement);
temp(temp<0)=0;
temptsd=tsd(Range(tsdMovement),temp);

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')


fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(temptsd)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); 
xlim([6 max(log10(Data(temptsd)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
xlim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr)))]);


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd,(and(Sleep,SleepEpoch_Piezo))); Y_period = Restrict(Actimetry_corr,(and(Sleep,SleepEpoch_Piezo)));
X_period = Restrict(temptsd,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd,(and(WakeEpoch_Piezo,Wake))); Y_period = Restrict(Actimetry_corr,(and(WakeEpoch_Piezo,Wake)));
X_period = Restrict(temptsd,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd,(and(SleepEpoch_Piezo,Wake))); Y_period = Restrict(Actimetry_corr,(and(SleepEpoch_Piezo,Wake)));
X_period = Restrict(temptsd,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd,(and(WakeEpoch_Piezo,Sleep))); Y_period = Restrict(Actimetry_corr,(and(WakeEpoch_Piezo,Sleep)));
X_period = Restrict(temptsd,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))]);
ylim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr)))]);


% % % Save the figure : 
% % cd(SaveFolderName);
% % saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_withoutshortsleep.eps');
% % saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_withoutshortsleep.jpg');

cd(FolderName{i});



%% Période Sommeil
aligned_intervals = and(Periode_sommeil_accelero,Periode_sommeil_piezo);
Actimetry_corr_restrict =  Restrict(Actimetry_corr , aligned_intervals);
temptsd_restrict =  Restrict(temptsd , aligned_intervals);
temptsd_restrict = Restrict(temptsd_restrict,ts(Range(Actimetry_corr_restrict)));
Actimetry_corr_restrict = Restrict(Actimetry_corr_restrict,ts(Range(temptsd_restrict)));

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')


fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(temptsd_restrict)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); 
xlim([6 max(log10(Data(temptsd)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr_restrict)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlabel('Actimetry power (log scale)');
xlim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr_restrict)))]);


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd_restrict,(and(Sleep_LongOnly_accelero,Sleep_LongOnly_piezo))); Y_period = Restrict(Actimetry_corr_restrict,(and(Sleep_LongOnly_accelero,Sleep_LongOnly_piezo)));
X_period = Restrict(temptsd_restrict,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr_restrict,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd_restrict,(and(Wake_modified_piezo,Wake_modified_accelero))); Y_period = Restrict(Actimetry_corr_restrict,(and(Wake_modified_piezo,Wake_modified_accelero)));
X_period = Restrict(temptsd_restrict,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr_restrict,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd_restrict,(and(Sleep_LongOnly_piezo,Wake_modified_accelero))); Y_period = Restrict(Actimetry_corr_restrict,(and(Sleep_LongOnly_piezo,Wake_modified_accelero)));
X_period = Restrict(temptsd_restrict,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr_restrict,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(temptsd_restrict,(and(Wake_modified_piezo,Sleep_LongOnly_accelero))); Y_period = Restrict(Actimetry_corr_restrict,(and(Wake_modified_piezo,Sleep_LongOnly_accelero)));
X_period = Restrict(temptsd_restrict,ts(Range(Y_period))); Y_period = Restrict(Actimetry_corr_restrict,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))]);
ylim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr)))]);


% Save the figure : 
cd(SaveFolderName);
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_PeriodeSommeil_withoutshortsleep.eps');
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_PeriodeSommeil_withoutshortsleep.jpg');

cd(FolderName{i});

























fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(Restrict(temptsd,Periode_sommeil_accelero))),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
xlabel('Movement power (log scale)'); 
xlim([6 max(log10(Data(temptsd)))]);

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(Actimetry_corr_restrict)),1000);
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
X = log10(Data(Restrict(temptsd_restrict,(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero))))); Y = log10(Data(Restrict(Actimetry_corr_restrict,Restrict(temptsd,(and(Sleep_LongOnly_piezo,Sleep_LongOnly_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd_restrict,(and(Wake_modified_piezo,Wake_modified_accelero))))); Y = log10(Data(Restrict(Actimetry_corr_restrict,Restrict(temptsd,(and(Wake_modified_piezo,Wake_modified_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd_restrict,(and(Sleep_LongOnly_piezo,Wake_modified_accelero))))); Y = log10(Data(Restrict(Actimetry_corr_restrict,Restrict(temptsd,(and(Sleep_LongOnly_piezo,Wake_modified_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(Restrict(temptsd_restrict,(and(Wake_modified_piezo,Sleep_LongOnly_accelero))))); Y = log10(Data(Restrict(Actimetry_corr_restrict,Restrict(temptsd,(and(Wake_modified_piezo,Sleep_LongOnly_accelero)))))); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(actimetry_thresh),'-r'); v2.LineWidth=5;
xlim([6 max(log10(Data(temptsd)))])
ylim([-1.75 0.5])





    % Save the figure : 
cd(SaveFolderName);
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_PeriodeSommeil.eps');
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo_PeriodeSommeil.jpg');

cd(FolderName{i});



