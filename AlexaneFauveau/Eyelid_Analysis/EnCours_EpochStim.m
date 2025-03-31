clear all
%% Create the FolderName

i=0;
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';
i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240516_160804/';

% i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_111240/';
% i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_145901/';
% i=i+1;FolderName{i} = '/media/gruffalo/DataMOBS198/2_PiezoEyelidStim/1597_Eyelid_240517_171645/';



for i = 1:length(FolderName)
    % Load
    cd(FolderName{i});
try
%% Get stim events intan
load('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];
Sync_Event_Start = [Start(TTLInfo.Sync)];
duration_stim = 1e4 % 200ms
Stim_Epoch_Start = Stim_Event_Start+duration_stim

duration = 10e4 % 30 secondes
Stim_Epoch_End = Stim_Epoch_Start + duration

%% Create the Stim Epoch
load('SleepScoring_OBGamma.mat','SmoothGamma')
load('SleepScoring_OBGamma.mat','Wake')
load('SleepScoring_OBGamma.mat','Sleep')

Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End)
DurationEpoch(Epoch_Stim)

Event_Stim = intervalSet(Stim_Event_Start, Stim_Event_Start+2e4)

% Plot it
Colors.Sleep = 'r';
Colors.Wake = 'c';
ylim([0 1600]);
yl=ylim;
LineHeight = yl(2);
t = Range(SmoothGamma);
begin = t(1);
endin = t(end);

figure
plot(Range(SmoothGamma,'s'),Data(SmoothGamma))
hold on
plot(Range(Restrict(SmoothGamma,Wake),'s'),Data(Restrict(SmoothGamma,Wake)),'k')
plot(Range(Restrict(SmoothGamma,Epoch_Stim),'s'),Data(Restrict(SmoothGamma,Epoch_Stim)),'g')
hold on 
plot(Range(Restrict(SmoothGamma,Event_Stim),'s'),Data(Restrict(SmoothGamma,Event_Stim)),'r')
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
yyaxis right
load('PiezoData_SleepScoring.mat')
plot(Range(Piezo_Mouse_tsd,'s') , Data(Piezo_Mouse_tsd))
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo),'s') , Data(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo)),'y--')
hold on


%% Quantify Sleep and Wake for each
load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo')
load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo')

load('SleepScoring_OBGamma.mat','Sleep')
load('SleepScoring_OBGamma.mat','Wake')
Sleep_OB = Sleep
Wake_OB = Wake

load('SleepScoring_Accelero.mat','Sleep')
load('SleepScoring_Accelero.mat','Wake')
Sleep_Accelero = Sleep
Wake_Accelero = Wake

% wake
Wake_Stim_OB = and(Wake_OB, Epoch_Stim);
tot_duration_wake_OB(i,1) = sum(Stop(Wake_Stim_OB,'s')-Start(Wake_Stim_OB,'s'));
mean_duration_wake_OB(i,1) = mean(Stop(Wake_Stim_OB,'s')-Start(Wake_Stim_OB,'s'));

Wake_Stim_Accelero = and(Wake_Accelero, Epoch_Stim);
tot_duration_wake_Accelero(i,1) = sum(Stop(Wake_Stim_Accelero,'s')-Start(Wake_Stim_Accelero,'s'));
mean_duration_wake_Accelero(i,1) = mean(Stop(Wake_Stim_Accelero,'s')-Start(Wake_Stim_Accelero,'s'));

Wake_Stim_Piezo = and(WakeEpoch_Piezo, Epoch_Stim);
tot_duration_wake_Piezo(i,1) = sum(Stop(Wake_Stim_Piezo,'s')-Start(Wake_Stim_Piezo,'s'));
mean_duration_wake_Piezo(i,1) = mean(Stop(Wake_Stim_Piezo,'s')-Start(Wake_Stim_Piezo,'s'));


% Sleep
Sleep_Stim_OB = and(Sleep_OB, Epoch_Stim);
tot_duration_sleep_OB(i,1) = sum(Stop(Sleep_Stim_OB,'s')-Start(Sleep_Stim_OB,'s'));
mean_duration_sleep_OB(i,1) = mean(Stop(Sleep_Stim_OB,'s')-Start(Sleep_Stim_OB,'s'));

Sleep_Stim_Accelero = and(Sleep_Accelero, Epoch_Stim);
tot_duration_sleep_Accelero(i,1) = sum(Stop(Sleep_Stim_Accelero,'s')-Start(Sleep_Stim_Accelero,'s'));
mean_duration_sleep_Accelero(i,1) = mean(Stop(Sleep_Stim_Accelero,'s')-Start(Sleep_Stim_Accelero,'s'));

Sleep_Stim_Piezo = and(SleepEpoch_Piezo, Epoch_Stim);
tot_duration_sleep_Piezo(i,1) = sum(Stop(Sleep_Stim_Piezo,'s')-Start(Sleep_Stim_Piezo,'s'));
mean_duration_sleep_Piezo(i,1) = mean(Stop(Sleep_Stim_Piezo,'s')-Start(Sleep_Stim_Piezo,'s'));

end
end


groups = {'OB','Movement','Actimetry'};
fig = figure; 
subplot(2,2,1);
A = {tot_duration_wake_OB,tot_duration_wake_Accelero,tot_duration_wake_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Durée d éveil en s')
title('Durée d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,2);
A = {mean_duration_wake_OB,mean_duration_wake_Accelero,mean_duration_wake_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Moyenne d éveil en s')
title('Moyenne d éveil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,3);
A = {tot_duration_sleep_OB,tot_duration_sleep_Accelero,tot_duration_sleep_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Durée de sommeil en s')
title('Durée de sommeil')
set(gca, 'XTickLabel',groups);
hold on 

subplot(2,2,4);
A = {mean_duration_sleep_OB,mean_duration_sleep_Accelero,mean_duration_sleep_Piezo};
Cols = {[0.9290 0.6940 0.1250],[0 1 0],[0.3010 0.7450 0.9330]};
X = [1,2,3];
Legends = {'OB','Movement','Actimetry'};
ShowPoints = 1;
[boxhandle, pointshandle] = MakeBoxPlot_DB(A,Cols,X,Legends,ShowPoints,'connectdots',1)
xlabel('Groups')
ylabel('Moyenne de sommeil en s')
title('Moyenne de sommeil')
set(gca, 'XTickLabel',groups);
hold on 



