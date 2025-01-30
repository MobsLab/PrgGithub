
function Figure_Compa_Features_SleepScoring_AF

disp('Figure Compa Features is loading...')

%% Compare features together : total time, % of time, nb of epidose, mean time of episode
load('SleepScoring_OBGamma.mat');
tot_duration_wake_OB = sum(Stop(Wake,'min')-Start(Wake,'min'));
tot_duration_sleep_OB = sum(Stop(Sleep,'min')-Start(Sleep,'min'));
percent_duration_wake_OB = sum(Stop(Wake,'min')-Start(Wake,'min'))/(sum(Stop(Wake,'min')-Start(Wake,'min'))+sum(Stop(Sleep,'min')-Start(Sleep,'min')));
percent_duration_sleep_OB = sum(Stop(Sleep,'min')-Start(Sleep,'min'))/(sum(Stop(Wake,'min')-Start(Wake,'min'))+sum(Stop(Sleep,'min')-Start(Sleep,'min')));
nb_period_wake_OB = length(Stop(Wake,'min'));
nb_period_sleep_OB = length(Stop(Wake,'min'));

mean_duration_wake_OB = mean(Stop(Wake,'min')-Start(Wake,'min'));
mean_duration_sleep_OB = mean(Stop(Sleep,'min')-Start(Sleep,'min'));
std_mean_duration_wake_OB = std(Stop(Wake,'min')-Start(Wake,'min'));
std_mean_duration_sleep_OB = std(Stop(Sleep,'min')-Start(Sleep,'min'));

load('SleepScoring_Accelero.mat');
tot_duration_wake_accelero = sum(Stop(Wake,'min')-Start(Wake,'min'));
tot_duration_sleep_accelero = sum(Stop(Sleep,'min')-Start(Sleep,'min'));
percent_duration_wake_accelero = sum(Stop(Wake,'min')-Start(Wake,'min'))/(sum(Stop(Wake,'min')-Start(Wake,'min'))+sum(Stop(Sleep,'min')-Start(Sleep,'min')));
percent_duration_sleep_accelero = sum(Stop(Sleep,'min')-Start(Sleep,'min'))/(sum(Stop(Wake,'min')-Start(Wake,'min'))+sum(Stop(Sleep,'min')-Start(Sleep,'min')));
nb_period_wake_accelero = length(Stop(Wake,'min'));
nb_period_sleep_accelero = length(Stop(Wake,'min'));

mean_duration_wake_accelero = mean(Stop(Wake,'min')-Start(Wake,'min'));
mean_duration_sleep_accelero = mean(Stop(Sleep,'min')-Start(Sleep,'min'));
std_mean_duration_wake_accelero = std(Stop(Wake,'min')-Start(Wake,'min'));
std_mean_duration_sleep_accelero = std(Stop(Sleep,'min')-Start(Sleep,'min'));

load('PiezoData_SleepScoring.mat');
tot_duration_wake_piezo = sum(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'));
tot_duration_sleep_piezo = sum(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min'));
Smooth_actimetry = tsd(Range(Piezo_Mouse_tsd), runmean(abs(zscore(Data(Piezo_Mouse_tsd))),300));
load('PiezoData_Corrected.mat');
percent_duration_wake_piezo = sum(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'))/(sum(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'))+sum(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min')));
percent_duration_sleep_piezo = sum(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min'))/(sum(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'))+sum(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min')));
nb_period_wake_piezo = length(Stop(WakeEpoch_Piezo,'min'));
nb_period_sleep_piezo = length(Stop(SleepEpoch_Piezo,'min'));

mean_duration_wake_piezo = mean(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'));
mean_duration_sleep_piezo = mean(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min'));
std_mean_duration_wake_piezo = std(Stop(WakeEpoch_Piezo,'min')-Start(WakeEpoch_Piezo,'min'));
std_mean_duration_sleep_piezo = std(Stop(SleepEpoch_Piezo,'min')-Start(SleepEpoch_Piezo,'min'));


%% Plot the figure for features: 
groups = {'OB', 'Movement', 'Actimetry'}
fig = figure; 
subplot(2,3,1);
b = bar([percent_duration_sleep_OB,percent_duration_sleep_accelero,percent_duration_sleep_piezo]);
xlabel('Groups')
ylabel('Proportion of Sleep Period')
title('Proportion of Sleep period')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]
hold on 

subplot(2,3,4);
b = bar([percent_duration_wake_OB,percent_duration_wake_accelero,percent_duration_wake_piezo]);
xlabel('Groups')
ylabel('Proportion of Wake Period')
title('Proportion of Wake period')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]
hold on 

subplot(2,3,2);
b = bar([nb_period_sleep_OB,nb_period_sleep_accelero,nb_period_sleep_piezo]);
xlabel('Groups')
ylabel('Number of Sleep Period')
title('Number of Sleep period')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]
hold on 

subplot(2,3,5);
b = bar([nb_period_wake_OB,nb_period_wake_accelero,nb_period_wake_piezo]);
xlabel('Groups')
ylabel('Number of Wake Period')
title('Number of Wake period')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]


subplot(2,3,3);
b = barwitherr([std_mean_duration_sleep_OB,std_mean_duration_sleep_accelero,std_mean_duration_sleep_piezo],[mean_duration_sleep_OB,mean_duration_sleep_accelero,mean_duration_sleep_piezo]);
xlabel('Groups')
ylabel('Mean Duration of Sleep Period')
title('Mean duration of sleep period between different sleep scorings')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]
hold on 

subplot(2,3,6);
b = barwitherr([std_mean_duration_wake_OB,std_mean_duration_wake_accelero,std_mean_duration_wake_piezo],[mean_duration_wake_OB,mean_duration_wake_accelero,mean_duration_wake_piezo]);
xlabel('Groups')
ylabel('Mean Duration of Wake Period')
title('Mean duration of wake period between different sleep scorings')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]

saveas(fig, 'Compa_Features_SleepScoring.png')

disp('Figure Compa Features done')

