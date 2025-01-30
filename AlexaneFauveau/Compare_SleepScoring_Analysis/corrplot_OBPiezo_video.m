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

    
    load('PiezoData_SleepScoring.mat','SleepEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','WakeEpoch_Piezo');
    load('PiezoData_SleepScoring.mat','Piezo_Mouse_tsd');
    load('PiezoData_SleepScoring.mat','Smooth_actimetry');
    Periode_sommeil_piezo = mergeCloseIntervals(SleepEpoch_Piezo, 60*1e4);
    Periode_sommeil_piezo = dropShortIntervals(Periode_sommeil_piezo,120*1e4);
    Sleep_LongOnly_piezo = and(SleepEpoch_Piezo, Periode_sommeil_piezo);
    Wake_modified_piezo = and(WakeEpoch_Piezo, Periode_sommeil_piezo);
    
    
%% OB/Piezo:
% Load the data smooth 
load('SleepScoring_OBGamma.mat','SmoothGamma');
    load('SleepScoring_OBGamma.mat','Sleep');
    load('SleepScoring_OBGamma.mat','Wake');
load('PiezoData_SleepScoring.mat', 'Smooth_actimetry') ;

Actimetry_corr =  Restrict(Smooth_actimetry , SmoothGamma);


% load the thresholds:
load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh;
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')

%%
video_filename = 'plot_animation.avi';
video = VideoWriter(video_filename);
video.FrameRate = 30; % Set the frame rate


open(video);

% Create the figure window
fig = figure('Position',[600 100 800 780])
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('Puissance du OB Gamma (échelle logarithmique)'); 
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);

subplot(6,6,[25 19 13 7 1]);
[Y, X] = hist(log10(Data(Actimetry_corr)), 1000);
a = area(X , runmean(Y,3)); 
a.FaceColor = [.8 .8 .8]; 
a.LineWidth = 3; 
a.EdgeColor = [0 0 0];
set(gca, 'XDir', 'reverse');
camroll(270);
box off;
v2 = vline(log10(actimetry_thresh), '-r'); 
v2.LineWidth = 5;
xlabel('Puissance du Piézo (échelle logarithmique)');
xlim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr)))]);

% Combine data for Sleep and Wake epochs
sleep_X_period = Restrict(SmoothGamma, (and(Sleep, SleepEpoch_Piezo)));
sleep_Y_period = Restrict(Actimetry_corr, (and(Sleep, SleepEpoch_Piezo)));
sleep_X_period = Restrict(SmoothGamma, ts(Range(sleep_Y_period)));
sleep_Y_period = Restrict(Actimetry_corr, ts(Range(sleep_X_period)));
sleep_X = log10(Data(sleep_X_period)); 
sleep_Y = log10(Data(sleep_Y_period));
sleep_time = Range(sleep_X_period); % Extract timestamps

wake_X_period = Restrict(SmoothGamma, (and(WakeEpoch_Piezo, Wake)));
wake_Y_period = Restrict(Actimetry_corr, (and(WakeEpoch_Piezo, Wake)));
wake_X_period = Restrict(SmoothGamma, ts(Range(wake_Y_period)));
wake_Y_period = Restrict(Actimetry_corr, ts(Range(wake_X_period)));
wake_X = log10(Data(wake_X_period)); 
wake_Y = log10(Data(wake_Y_period));
wake_time = Range(wake_X_period); % Extract timestamps

sleep_wake_X_period = Restrict(SmoothGamma, (and(SleepEpoch_Piezo, Wake)));
sleep_wake_Y_period = Restrict(Actimetry_corr, (and(SleepEpoch_Piezo, Wake)));
sleep_wake_X_period = Restrict(SmoothGamma, ts(Range(sleep_wake_Y_period)));
sleep_wake_Y_period = Restrict(Actimetry_corr, ts(Range(sleep_wake_X_period)));
sleep_wake_X = log10(Data(sleep_wake_X_period)); 
sleep_wake_Y = log10(Data(sleep_wake_Y_period));
sleep_wake_time = Range(sleep_wake_X_period); % Extract timestamps

wake_sleep_X_period = Restrict(SmoothGamma, (and(Sleep, WakeEpoch_Piezo)));
wake_sleep_Y_period = Restrict(Actimetry_corr, (and(Sleep, WakeEpoch_Piezo)));
wake_sleep_X_period = Restrict(SmoothGamma, ts(Range(wake_sleep_Y_period)));
wake_sleep_Y_period = Restrict(Actimetry_corr, ts(Range(wake_sleep_X_period)));
wake_sleep_X = log10(Data(wake_sleep_X_period)); 
wake_sleep_Y = log10(Data(wake_sleep_Y_period));
wake_sleep_time = Range(wake_sleep_X_period); % Extract timestamps


% Combine all data points
all_X = [sleep_X; wake_X; sleep_wake_X; wake_sleep_X];
all_Y = [sleep_Y; wake_Y; sleep_wake_Y; wake_sleep_Y];
all_time = [sleep_time; wake_time; sleep_wake_time; wake_sleep_time];
all_colors = [repmat('r', length(sleep_X), 1); repmat('c', length(wake_X), 1); repmat('g', length(sleep_wake_X), 1); repmat('b', length(wake_sleep_X), 1)]; % 'r' for sleep, 'c' for wake, 'g' for sleep-wake

% Sort combined data by timestamps
[sorted_time, sort_idx] = sort(all_time);
sorted_X = all_X(sort_idx);
sorted_Y = all_Y(sort_idx);
sorted_colors = all_colors(sort_idx);

% Second subplot
subplot(6,6,[2:6 8:12 14:18 20:24 26:30]);
hold on;
ylim([min(log10(Data(Actimetry_corr))) max(log10(Data(Actimetry_corr)))]);
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);
axis square;
v1 = vline(log10(gamma_thresh), '-r'); 
v1.LineWidth = 5;
v2 = hline(log10(actimetry_thresh), '-r'); 
v2.LineWidth = 5;
xlim([min(log10(Data(SmoothGamma))) max(log10(Data(SmoothGamma)))]);
stepsize = 4000;


for i = 1:stepsize:length(sorted_X)
    plot(sorted_X(i), sorted_Y(i), ['.' sorted_colors(i)]);

    pause(0.00001); % Pause to simulate video effect
    
    frame = getframe(fig); % Capture the frame
    writeVideo(video, frame); % Write the frame to the video    
end

hold off;

% Close the video writer
close(video);