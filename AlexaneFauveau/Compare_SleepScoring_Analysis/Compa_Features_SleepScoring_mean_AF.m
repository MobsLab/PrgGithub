%% Code to do the compare feature figure for the mean of all mice

clear all 

%%

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


for i = 1:length(FolderName)
    

    % Load the good file
    cd(FolderName{i});
    
    % Compare features together : total time, % of time, nb of epidose, mean time of episode
    % OB
    load SleepScoring_OBGamma Wake Sleep
    tot_duration_wake_OB(i,1) = sum(Stop(Wake,'s')-Start(Wake,'s'));
    tot_duration_sleep_OB(i,1) = sum(Stop(Sleep,'s')-Start(Sleep,'s'));
    percent_duration_wake_OB(i,1) = sum(Stop(Wake,'s')-Start(Wake,'s'))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')));
    percent_duration_sleep_OB(i,1) = sum(Stop(Sleep,'s')-Start(Sleep,'s'))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')));
    nb_period_wake_OB(i,1) = length(Start(Wake,'s'));
    nb_period_sleep_OB(i,1) = length(Start(Sleep,'s'));
    
    mean_duration_wake_OB(i,1) = mean(Stop(Wake,'s')-Start(Wake,'s'));
    mean_duration_sleep_OB(i,1) = mean(Stop(Sleep,'s')-Start(Sleep,'s'));
    
    median_duration_wake_OB(i,1) = median(Stop(Wake,'s')-Start(Wake,'s'));
    median_duration_sleep_OB(i,1) = median(Stop(Sleep,'s')-Start(Sleep,'s'));
    

    % Accelero
    load SleepScoring_Accelero Wake Sleep
    tot_duration_wake_accelero(i,1) = sum(Stop(Wake,'s')-Start(Wake,'s'));
    tot_duration_sleep_accelero(i,1) = sum(Stop(Sleep,'s')-Start(Sleep,'s'));
    percent_duration_wake_accelero(i,1) = sum(Stop(Wake,'s')-Start(Wake,'s'))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')));
    percent_duration_sleep_accelero(i,1) = sum(Stop(Sleep,'s')-Start(Sleep,'s'))/(sum(Stop(Wake,'s')-Start(Wake,'s'))+sum(Stop(Sleep,'s')-Start(Sleep,'s')));
    nb_period_wake_accelero(i,1) = length(Start(Wake,'s'));
    nb_period_sleep_accelero(i,1) = length(Start(Sleep,'s'));

    mean_duration_wake_accelero(i,1) = mean(Stop(Wake,'s')-Start(Wake,'s'));
    mean_duration_sleep_accelero(i,1) = mean(Stop(Sleep,'s')-Start(Sleep,'s'));
    
    median_duration_wake_accelero(i,1) = median(Stop(Wake,'s')-Start(Wake,'s'));
    median_duration_sleep_accelero(i,1) = median(Stop(Sleep,'s')-Start(Sleep,'s'));

    % Piezo
    load PiezoData_SleepScoring WakeEpoch_Piezo SleepEpoch_Piezo
    tot_duration_wake_piezo(i,1) = sum(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'));
    tot_duration_sleep_piezo(i,1) = sum(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s'));
    percent_duration_wake_piezo(i,1) = sum(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'))/(sum(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'))+sum(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s')));
    percent_duration_sleep_piezo(i,1) = sum(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s'))/(sum(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'))+sum(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s')));
    nb_period_wake_piezo(i,1) = length(Start(WakeEpoch_Piezo,'s'));
    nb_period_sleep_piezo(i,1) = length(Start(SleepEpoch_Piezo,'s'));

    mean_duration_wake_piezo(i,1) = mean(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'));
    mean_duration_sleep_piezo(i,1) = mean(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s'));
 
    median_duration_wake_piezo(i,1) = median(Stop(WakeEpoch_Piezo,'s')-Start(WakeEpoch_Piezo,'s'));
    median_duration_sleep_piezo(i,1) = median(Stop(SleepEpoch_Piezo,'s')-Start(SleepEpoch_Piezo,'s'));
    
    
    % Compa pour Période sommeil 
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
    
        % OB
    periodesommeil_tot_duration_wake_OB(i,1) = sum(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'));
    periodesommeil_tot_duration_sleep_OB(i,1) = sum(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s'));
    periodesommeil_percent_duration_wake_OB(i,1) = sum(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'))/(sum(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'))+sum(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s')));
    periodesommeil_percent_duration_sleep_OB(i,1) = sum(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s'))/(sum(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'))+sum(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s')));
    periodesommeil_nb_period_wake_OB(i,1) = length(Start(Wake_modified_OB,'s'));
    periodesommeil_nb_period_sleep_OB(i,1) = length(Start(Sleep_LongOnly_OB,'s'));
    
    periodesommeil_mean_duration_wake_OB(i,1) = mean(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'));
    periodesommeil_mean_duration_sleep_OB(i,1) = mean(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s'));
    
    periodesommeil_median_duration_wake_OB(i,1) = median(Stop(Wake_modified_OB,'s')-Start(Wake_modified_OB,'s'));
    periodesommeil_median_duration_sleep_OB(i,1) = median(Stop(Sleep_LongOnly_OB,'s')-Start(Sleep_LongOnly_OB,'s'));
    

    % Accelero
    periodesommeil_tot_duration_wake_accelero(i,1) = sum(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'));
    periodesommeil_tot_duration_sleep_accelero(i,1) = sum(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s'));
    periodesommeil_percent_duration_wake_accelero(i,1) = sum(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'))/(sum(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'))+sum(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s')));
    periodesommeil_percent_duration_sleep_accelero(i,1) = sum(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s'))/(sum(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'))+sum(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s')));
    periodesommeil_nb_period_wake_accelero(i,1) = length(Start(Wake_modified_accelero,'s'));
    periodesommeil_nb_period_sleep_accelero(i,1) = length(Start(Sleep_LongOnly_accelero,'s'));

    periodesommeil_mean_duration_wake_accelero(i,1) = mean(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'));
    periodesommeil_mean_duration_sleep_accelero(i,1) = mean(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s'));
    
    periodesommeil_median_duration_wake_accelero(i,1) = median(Stop(Wake_modified_accelero,'s')-Start(Wake_modified_accelero,'s'));
    periodesommeil_median_duration_sleep_accelero(i,1) = median(Stop(Sleep_LongOnly_accelero,'s')-Start(Sleep_LongOnly_accelero,'s'));

    % Piezo
    periodesommeil_tot_duration_wake_piezo(i,1) = sum(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'));
    periodesommeil_tot_duration_sleep_piezo(i,1) = sum(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s'));
    periodesommeil_percent_duration_wake_piezo(i,1) = sum(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'))/(sum(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'))+sum(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s')));
    periodesommeil_percent_duration_sleep_piezo(i,1) = sum(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s'))/(sum(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'))+sum(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s')));
    periodesommeil_nb_period_wake_piezo(i,1) = length(Start(Wake_modified_piezo,'s'));
    periodesommeil_nb_period_sleep_piezo(i,1) = length(Start(Sleep_LongOnly_piezo,'s'));

    periodesommeil_mean_duration_wake_piezo(i,1) = mean(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'));
    periodesommeil_mean_duration_sleep_piezo(i,1) = mean(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s'));
 
    periodesommeil_median_duration_wake_piezo(i,1) = median(Stop(Wake_modified_piezo,'s')-Start(Wake_modified_piezo,'s'));
    periodesommeil_median_duration_sleep_piezo(i,1) = median(Stop(Sleep_LongOnly_piezo,'s')-Start(Sleep_LongOnly_piezo,'s'));
    
end


%% Do the figure
groups = {'OB','Movement','Actimetry'};

fig = figure;
suptitle('Caractéristiques')
subplot(2,4,1);
A = {percent_duration_wake_OB,percent_duration_wake_accelero,percent_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Proportion d éveil')
title('Proportion d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,4,5);
A = {percent_duration_sleep_OB,percent_duration_sleep_accelero,percent_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Proportion de sommeil')
title('Proportion de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
hold on

subplot(2,4,2);
A = {nb_period_wake_OB,nb_period_wake_accelero,nb_period_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Nombre de période d éveil')
title('Nombre de période d évéil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,6);
A = {nb_period_sleep_OB,nb_period_sleep_accelero,nb_period_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Nombre de période de sommeil')
title('Nombre de période de sommmeil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,4,3)
A = {mean_duration_wake_OB,mean_duration_wake_accelero,mean_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée moyenne des épisodes d éveil en seconde')
title('Durée moyenne des épisodes d éveil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,7)
A = {mean_duration_sleep_OB,mean_duration_sleep_accelero,mean_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée moyenne des épisodes de sommeil en seconde')
title('Durée moyenne des épisodes de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,4)
A = {median_duration_wake_OB,median_duration_wake_accelero,median_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée médiane des épisodes d éveil en seconde')
title('Durée médiane des épisodes d éveil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,8)
A = {median_duration_sleep_OB,median_duration_sleep_accelero,median_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée médiane des épisodes de sommeil en seconde')
title('Durée médiane des épisodes de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];





%% Periode sommeil 
groups = {'OB','Movement','Actimetry'};

fig = figure; 
suptitle('                     Période de Sommeil Consolidé: Caractéristiques                             ')
subplot(2,4,1);
A = {periodesommeil_percent_duration_wake_OB,periodesommeil_percent_duration_wake_accelero,periodesommeil_percent_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Proportion d éveil')
title('Proportion d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,4,5);
A = {periodesommeil_percent_duration_sleep_OB,periodesommeil_percent_duration_sleep_accelero,periodesommeil_percent_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Proportion de sommeil')
title('Proportion de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];
hold on

subplot(2,4,6);
A = {periodesommeil_nb_period_sleep_OB,periodesommeil_nb_period_sleep_accelero,periodesommeil_nb_period_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
ylabel('Nombre de période de sommeil')
title('Nombre de période de sommmeil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,4,2);
A = {periodesommeil_nb_period_wake_OB,periodesommeil_nb_period_wake_accelero,periodesommeil_nb_period_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Nombre de période d éveil')
title('Nombre de période d évéil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];


subplot(2,4,3)
A = {periodesommeil_mean_duration_wake_OB,periodesommeil_mean_duration_wake_accelero,periodesommeil_mean_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée moyenne des épisodes d éveil en seconde')
title('Durée moyenne des épisodes d éveil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,7)
A = {periodesommeil_mean_duration_sleep_OB,periodesommeil_mean_duration_sleep_accelero,periodesommeil_mean_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée moyenne des épisodes de sommeil en seconde')
title('Durée moyenne des épisodes de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,4)
A = {periodesommeil_median_duration_wake_OB,periodesommeil_median_duration_wake_accelero,periodesommeil_median_duration_wake_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée médiane des épisodes d éveil en seconde')
title('Durée médiane des épisodes d éveil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];

subplot(2,4,8)
A = {periodesommeil_median_duration_sleep_OB,periodesommeil_median_duration_sleep_accelero,periodesommeil_median_duration_sleep_piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1);
xlabel('Groups')
ylabel('Durée médiane des épisodes de sommeil en seconde')
title('Durée médiane des épisodes de sommeil')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250];
b.CData(2,:) = [0 1 0];
b.CData(3,:) = [0.3010 0.7450 0.9330];












