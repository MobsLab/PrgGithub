function Figure_Overlap_SleepScoring_AF
%% Load and prepare the data : 

disp('Figure Overload Sleep Scoring loading ...')

%% Compare with OB scoring 
% load('SleepScoring_OBGamma.mat');
load('SleepScoring_OBGamma.mat')
load('PiezoData_SleepScoring.mat')

% Do the proba
durS_OB = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
durSS_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
durWS_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

durW_OB = sum(Stop(Wake,'s') - Start(Wake,'s'));
durWW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
durSW_Piez_OB = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ; 

% Wake_LongOnly = dropShortIntervals(Wake,30*1e4);
% durW_OB = sum(Stop(Wake_LongOnly,'s') - Start(Wake_LongOnly,'s'));
% durW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake_LongOnly),'s') - Start(and(WakeEpoch_Piezo,Wake_LongOnly),'s'));
% durW_Piez_OB/durW_OB


%% Compare with Accelero scoring 
% load('SleepScoring_OBGamma.mat');
load('SleepScoring_Accelero.mat')
load('PiezoData_SleepScoring.mat')

% Do the proba
durS_accelero = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
durSS_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Sleep),'s') - Start(and(SleepEpoch_Piezo,Sleep),'s'));
proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
durWS_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Sleep),'s') - Start(and(WakeEpoch_Piezo,Sleep),'s'));
proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

durW_accelero = sum(Stop(Wake,'s') - Start(Wake,'s'));
durWW_Piez_accelero = sum(Stop(and(WakeEpoch_Piezo,Wake),'s') - Start(and(WakeEpoch_Piezo,Wake),'s'));
proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
durSW_Piez_accelero = sum(Stop(and(SleepEpoch_Piezo,Wake),'s') - Start(and(SleepEpoch_Piezo,Wake),'s'));
proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 


%% Make the figure
labels= {'Sleep','Wake'};

fig = figure
subplot(1,2,1)
proba_sleep = [proba_S_S_OB,proba_W_S_OB]; 
proba_wake = [proba_S_W_OB,proba_W_W_OB]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('OB gamma');
title('OB gamma / Actimetry ');
legend('Sleep','Wake');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

subplot(1,2,2)
proba_sleep = [proba_S_S_accelero,proba_W_S_accelero]; 
proba_wake = [proba_S_W_accelero,proba_W_W_accelero]; 
proba_stacked = [proba_sleep;proba_wake];
bar(proba_stacked, 'stacked');
set(gca, 'xticklabel',labels);
ylabel('Overlap(%)');
xlabel('Movement');
title('Movement / Actimetry');
legend('Sleep','Wake');
lgd = legend('Sleep','Wake','Location','southoutside');
title(lgd,'Actimetry Scoring');
ylim([0 100]);

saveas(fig, 'OverlapSleepScoring.png')

disp('Figure Overload Sleep Scoring done')





