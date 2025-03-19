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
i = 3 ;
    cd(FolderName{i});

    
    
% Give the files to save the figures : 
SaveFolderName = '/home/gruffalo/Dropbox/Mobs_member/AlexaneFauveau/Figures_Présentation/Figures_CorrPlotColor/';
    
%% Create the "Periode sommeil" for each SleepScoring
    % Create the Sleep without microwake    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
    load('SleepScoring_OBGamma.mat','SmoothGamma');
    Periode_sommeil_OB = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_OB = dropShortIntervals(Periode_sommeil_OB,120*1e4);
    Sleep_LongOnly_OB = and(Sleep, Periode_sommeil_OB);
    Wake_modified_OB = and(Wake, Periode_sommeil_OB);
    Sleep_OB = Sleep;
    Wake_OB = Wake;
    
    
    load('SleepScoring_Accelero.mat','Sleep');
    load('SleepScoring_Accelero.mat','Wake');
    load('SleepScoring_Accelero.mat','tsdMovement');
    Periode_sommeil_accelero = mergeCloseIntervals(Sleep, 60*1e4);
    Periode_sommeil_accelero = dropShortIntervals(Periode_sommeil_accelero,120*1e4);
    Sleep_LongOnly_accelero = and(Sleep, Periode_sommeil_accelero);
    Wake_modified_accelero = and(Wake, Periode_sommeil_accelero);

    

    
    
    
%% Movement / Actimetry
temp=Data(tsdMovement);
temp(temp<0)=0;
temptsd=tsd(Range(tsdMovement),temp);

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh;


fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('Puissance du OB Gamma (échelle logarithmique'); 
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);


subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(temptsd)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(mov_thresh),'-r'); v2.LineWidth=5;
xlabel('Puissance de l accéléromètre (échelle logarithmique)');
xlim([6 max(log10(Data(temptsd)))]);


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma,(and(Sleep,Sleep_OB))); Y_period = Restrict(temptsd,(and(Sleep,Sleep_OB)));
X_period = Restrict(SmoothGamma,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma,(and(Wake_OB,Wake))); Y_period = Restrict(temptsd,(and(Wake_OB,Wake)));
X_period = Restrict(SmoothGamma,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma,(and(Sleep_OB,Wake))); Y_period = Restrict(temptsd,(and(Sleep_OB,Wake)));
X_period = Restrict(SmoothGamma,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma,(and(Wake_OB,Sleep))); Y_period = Restrict(temptsd,(and(Wake_OB,Sleep)));
X_period = Restrict(SmoothGamma,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(mov_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);
ylim([6 max(log10(Data(temptsd)))]);


% Save the figure : 
cd(SaveFolderName);
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo.eps');
saveas(fig,'1562_8_CorrplotColor_AcceleroPiezo.jpg');

cd(FolderName{i});



%% Période Sommeil
aligned_intervals = and(Periode_sommeil_accelero,Periode_sommeil_OB);
temptsd_restrict =  Restrict(temptsd , aligned_intervals);
temptsd_restrict = Restrict(temptsd_restrict,ts(Range(SmoothGamma)));
SmoothGamma_restrict = Restrict(SmoothGamma,ts(Range(temptsd_restrict)));

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('PiezoData_SleepScoring.mat', 'mov_thresh')



temp=Data(tsdMovement);
temp(temp<0)=0;
temptsd=tsd(Range(tsdMovement),temp);

load('SleepScoring_Accelero.mat', 'Info')  
mov_thresh = Info.mov_threshold;
load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh;


fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma_restrict)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('Puissance du OB Gamma (échelle logarithmique'); 
xlim([min(log10(Data(SmoothGamma_restrict))) max(log10(Data(SmoothGamma_restrict)))]);


subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(temptsd)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(log10(mov_thresh),'-r'); v2.LineWidth=5;
xlabel('Puissance de l accéléromètre (échelle logarithmique)');
xlim([6 max(log10(Data(temptsd)))]);


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma_restrict,(and(Sleep_LongOnly_accelero,Sleep_LongOnly_OB))); Y_period = Restrict(temptsd,(and(Sleep_LongOnly_accelero,Sleep_LongOnly_OB)));
X_period = Restrict(SmoothGamma_restrict,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.r')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma_restrict,(and(Wake_modified_OB,Wake_modified_accelero))); Y_period = Restrict(temptsd,(and(Wake_modified_OB,Wake_modified_accelero)));
X_period = Restrict(SmoothGamma_restrict,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.c')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma_restrict,(and(Sleep_LongOnly_OB,Wake_modified_accelero))); Y_period = Restrict(temptsd,(and(Sleep_LongOnly_OB,Wake_modified_accelero)));
X_period = Restrict(SmoothGamma_restrict,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.g')
axis square
v1=vline(log10(mov_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(gamma_thresh),'-r'); v2.LineWidth=5;


subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X_period = Restrict(SmoothGamma_restrict,(and(Wake_modified_OB,Sleep_LongOnly_accelero))); Y_period = Restrict(temptsd,(and(Wake_modified_OB,Sleep_LongOnly_accelero)));
X_period = Restrict(SmoothGamma_restrict,ts(Range(Y_period))); Y_period = Restrict(temptsd,ts(Range(X_period)));
X = log10(Data(X_period)); Y = log10(Data(Y_period)); 
hold on, plot(X(1:5:end) , Y(1:5:end) , '.b')
axis square
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
v2=hline(log10(mov_thresh),'-r'); v2.LineWidth=5;
xlim([min(log10(Data(SmoothGamma_restrict))) max(log10(Data(SmoothGamma_restrict)))]);
ylim([6 max(log10(Data(temptsd)))]);




