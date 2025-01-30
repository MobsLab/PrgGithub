%% This code allows to synchronize the data of the PiezoSleep System and INTAN (elecctrophysiology signals)
% The synchro was done using a pizoelectric which vibrates at 5Hz every hour
% on the piezo, and sends a signal on the DigitalIN 8 on Intan. 

% Project : Audiodream 
% By Sophie Bagur and Alexane Fauveau

% Code used inside of this code :
% - SleepScoring_Piezo_AF : allows to do the sleep_scoring on the
% piezo_data

% Code using this code : 


% To use this code : be in the folder with the Expe.info and
% SleepScoring_data of the mouse (which is the LFP_Folder path)
% Give the right path for LFP_Folder and Piezo_Folder


clear all
% LFP_Folder = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1563_BaselineSleep6_240412/';
% Piezo_Folder = '/media/gruffalo/DataMOBS198/Piezo/1563_1562_HabJ6_240412_240412_103129/1563_1562_HabJ6_Piezo/';
cd(LFP_Folder)

% Adapt those variables to your need ! 
LFP_Folder = '/media/greta/DataMOBS198/3_Sound/1615à1620_Sound19_240626_101108/';
Piezo_Folder = '/media/greta/DataMOBS198/3_Sound/1615à1620_Sound19_240626/';
MousePiezoNum = 5;


SynchroPiezoNum = 4;
Synchro_thresh = 1*1e-3;


%% Get Sync events from the piezo
allfiles = dir(Piezo_Folder);
name_file = [Piezo_Folder allfiles(5).name(1:8) sprintf('#%d.dat', SynchroPiezoNum)];    % You may have to change the name of files
% Load the .dat
data = load(name_file);
Piezo_tsd = tsd(data(:,1)*1e4,data(:,2));
Fil_Piezo_tsd = FilterLFP(Piezo_tsd,[3 7],256);
PiezoEvent = tsd(Range(Piezo_tsd),Data(Fil_Piezo_tsd).^2);

% figure
% hold on,plot(Range(Piezo_tsd,'h'),Data(PiezoEvent))
% disp('Look for synchro event : does it look good ? What about the first and last ones ?')

% plot to see if it's OK
figure
clf
hold on,plot(Range(Piezo_tsd,'s'),Data(PiezoEvent))
hold on,xlim([0 30*60])
title('When does session start?');
[t_start,y] = ginput(1);
xlim([max(Range(Piezo_tsd,'s'))-30*60 max(Range(Piezo_tsd,'s'))])
title('When does session end?');
[t_stop,y] = ginput(1);

Synchro_Epoch = thresholdIntervals(PiezoEvent,Synchro_thresh,'Direction','Above');
Synchro_Epoch = mergeCloseIntervals(Synchro_Epoch,1*1e4);
Synchro_Epoch = dropShortIntervals(Synchro_Epoch,0.8*1e4);
Synchro_Epoch = and(Synchro_Epoch,intervalSet(t_start*1e4,t_stop*1e4));
Synchro_Piezo_Start = Start(Synchro_Epoch);
NumPiezoSynch = length((Synchro_Piezo_Start));

hold on,plot(Range(Restrict(Piezo_tsd,Synchro_Epoch),'s'),Data(Restrict(PiezoEvent,Synchro_Epoch)),'.r')
plot(Synchro_Piezo_Start/1e4,Synchro_thresh,'k*')
xlim([0 max(Range(Piezo_tsd,'s'))])


%% Get sync events intan
load([LFP_Folder 'behavResources.mat'])
Synchro_Intan_Start = [TTLInfo.StartSession;Start(TTLInfo.Sync)];

%% A MODIF SINON !!!  (Pour ceux qui ont le premier TTL répeter ?)
% Synchro_Intan_Start = Synchro_Intan_Start([3:end]);
%% %%%%%%%%%%%%%%%%%%%%%

NumIntanSynch = length(Synchro_Intan_Start);

if NumPiezoSynch~=NumIntanSynch
   disp('Non matching sync events - do something!!') 
   keyboard % allows to block the code here 
end

%% Line everything up
Synchro_Piezo_Start = Synchro_Piezo_Start;
p = polyfit(Synchro_Piezo_Start,Synchro_Intan_Start,1);
new_piezo_time = p(1)*Range(Piezo_tsd) + p(2);
Piezo_corr_tsd = tsd(new_piezo_time,Data(Fil_Piezo_tsd));


%% Save data piezo
name_file = [Piezo_Folder allfiles(5).name(1:8) sprintf('#%d.dat', MousePiezoNum)];    % You may have to change the name of files
data = load(name_file);
Piezo_Mouse_tsd = tsd(new_piezo_time,data(:,2));
save([LFP_Folder 'PiezoData_Corrected.mat'],'Piezo_Mouse_tsd')


%% Do the SleepScoring of the piezo data

load('PiezoData_Corrected.mat')
[WakeEpoch_Piezo, SleepEpoch_Piezo] = SleepScoring_Piezo_AF(Piezo_Mouse_tsd, LFP_Folder)


load('SleepScoring_OBGamma.mat')
load('PiezoData_SleepScoring.mat')


Colors.Sleep = 'r';
Colors.Wake = 'c';
ylim([0 1600]);
yl=ylim;
LineHeight = yl(2);
t = Range(SmoothGamma);
begin = t(1);
endin = t(end);
% Plot the figure and save it
fig = figure;
plot(Range(Piezo_Mouse_tsd,'s')/60 , Data(Piezo_Mouse_tsd))
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo),'s')/60 , Data(Restrict(Piezo_Mouse_tsd,SleepEpoch_Piezo)))
hold on
plot(Range(MovAcctsd,'s')/60,3+Data(MovAcctsd)/1e9, 'g')
load('SleepScoring_Accelero.mat', 'Wake')
plot(Range(Restrict(MovAcctsd,Wake),'s')/60,3+Data(Restrict(MovAcctsd,Wake))/1e9,'k--')
hold on
yyaxis right
load('SleepScoring_OBGamma.mat', 'Wake')
load('SleepScoring_OBGamma.mat', 'SmoothGamma')
plot(Range(SmoothGamma,'s')/60,Data(SmoothGamma))
plot(Range(Restrict(SmoothGamma,Wake),'s')/60,Data(Restrict(SmoothGamma,Wake)),'k')
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 60e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 60e4, 'linewidth',10);

% Save the figure
%saveas(fig, 'piezoVSgammaVSacceleroScoring.fig')






