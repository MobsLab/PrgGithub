%% Plot the figure for correlation 

% OB / Actimetry
Mov_corr = Restrict(tsdMovement , SmoothGamma);
Actimetry_corr =  Restrict(Smooth_actimetry , SmoothGamma);

X = log10(Data(SmoothGamma));
Y = log10(Data(Actimetry_corr));
Z = log10(Data(Mov_corr));

load('SleepScoring_OBGamma.mat', 'Info')  
gamma_thresh = Info.gamma_thresh
load('PiezoData_SleepScoring.mat', 'actimetry_thresh')
 
figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,3)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
box off
v1=vline(log10(gamma_thresh),'-r'); v1.LineWidth=5;
xlabel('OB gamma power (log scale)'); xlim([2 3.1])

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
xlim([2 3.1])















%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Brouillon %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure; 
b = bar([tot_duration_sleep_OB,tot_duration_sleep_accelero,tot_duration_sleep_piezo])
xlabel('Groups')
ylabel('Total Duration of Sleep Period')
title('Total duration of sleep period between different sleep scorings')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]

figure; 
b = bar([tot_duration_wake_OB,tot_duration_wake_accelero,tot_duration_wake_piezo])
xlabel('Groups')
ylabel('Total Duration of Wake Period')
title('Total duration of wake period between different sleep scorings')
set(gca, 'XTickLabel',groups);
b.FaceColor = 'flat';
b.CData(1,:) = [0.9290 0.6940 0.1250]
b.CData(2,:) = [0 1 0]
b.CData(3,:) = [0.3010 0.7450 0.9330]








%% Create intervals 

load('SleepScoring_OBGamma.mat');
startWake_OB = Start(Wake,'s');
stopWake_OB = Stop(Wake,'s');
startSleep_OB = Start(Sleep,'s');
stopSleep_OB = Stop(Sleep,'s');

% startREM_OB = Start(REMEpoch);
% stopREM_OB = Stop(REMEpoch);
% startSWS_OB = Start(SWSEpoch);
% stopSWS_OB = Stop(SWSEpoch);

load('SleepScoring_Accelero.mat');
startWake_accelero = (Start(Wake));
stopWake_accelero = (Stop(Wake));
startSleep_accelero = (Start(Sleep));
stopSleep_accelero = (Start(Sleep));

% startREM_accelero = Start(REMEpoch);
% stopREM_accelero = Stop(REMEpoch);
% startSWS_accelero = Start(SWSEpoch);
% stopSWS_accelero = Stop(SWSEpoch);

load('PiezoData_SleepScoring.mat');
startWake_piezo = Start(WakeEpoch_Piezo);
stopWake_piezo = Stop(WakeEpoch_Piezo);
startSleep_piezo = Start(SleepEpoch_Piezo);
stopSleep_piezo = Stop(SleepEpoch_Piezo);

Wake_OB_Intervals = [startWake_OB ; stopWake_OB] ; 
Sleep_OB_Intervals = [startSleep_OB ; stopSleep_OB] ; 

Wake_accelero_Intervals = [startWake_accelero ; stopWake_accelero] ; 
Sleep_accelero_Intervals = [startSleep_accelero ; stopSleep_accelero] ;

Wake_piezo_Intervals = [startWake_piezo ; stopWake_piezo] ; 
Sleep_piezo_Intervals = [startSleep_piezo ; stopSleep_piezo] ;


load('PiezoData_Corrected.mat')
Piezo_corr = Restrict(Piezo_Mouse_tsd , SmoothGamma);
Mov_corr = Restrict(tsdMovement , SmoothGamma);
total_length = max(Range(Mov_corr));

length(Range(SmoothGamma))


%% Assign sleep Scoring values
OB_sleep_scores = zeros(1, length(Range(SmoothGamma))); 
fs = 1250;
for i = 1:length(startSleep_OB)

    OB_sleep_scores(start_idx:stop_idx) = 1;
end

accelero_sleep_scores = zeros(1, total_length) ; 
fs = 1250;
for i = 1:length(startSleep_accelero)
    start_idx = round(startSleep_accelero(i)*fs);
    stop_idx = round(stopSleep_accelero(i)*fs);
    accelero_sleep_scores(start_idx:stop_idx) = 1;
end

piezo_sleep_scores = zeros(1, total_length) ;
fs = 100;
for i = 1:length(startSleep_piezo)
    start_idx = round(startSleep_piezo(i)*fs);
    stop_idx = round(stopSleep_piezo(i)*fs);
    piezo_sleep_scores(start_idx:stop_idx) = 1;
end

% Check if there is a diff
meanp = mean(piezo_sleep_scores)
meana = mean(accelero_sleep_scores)
meanob = mean(OB_sleep_scores)

length(OB_sleep_scores)
length(accelero_sleep_scores)
length(piezo_sleep_scores)


%% Perform a Cochran's Q test : 
outcomes_matrix = [OB_sleep_scores', accelero_sleep_scores',piezo_sleep_scores']; 
% Compute the number of successes for each group
successes_per_group = sum(outcomes_matrix);
% Compute the number of successes for each observation across all groups
successes_per_observation = sum(outcomes_matrix, 2);
% Compute Cochran's Q statistic
Q = sum((successes_per_observation - mean(successes_per_observation)).^2) / (size(outcomes_matrix, 1) * (size(outcomes_matrix, 2) - 1));
% Compute the degrees of freedom
df = size(outcomes_matrix, 2) - 1;
% Compute the p-value using the chi-square distribution
p_value = 1 - chi2cdf(Q, df);
% Display test results
fprintf('Cochran''s Q test statistic (Q): %.4f\n', Q);
fprintf('p-value: %.4f\n', p_value);
fprintf('Degrees of freedom: %d\n', df);
% Check if the difference is significant
if p_value < 0.05
    disp('There is a statistically significant difference in proportions among at least two groups.');
else
    disp('There is no statistically significant difference in proportions among groups.');
end
