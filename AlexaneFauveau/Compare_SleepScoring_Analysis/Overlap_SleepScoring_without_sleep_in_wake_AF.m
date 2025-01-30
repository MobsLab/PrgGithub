%% 

clear all 


%% Apply correction 
load('PiezoData_SleepScoring.mat')

% Delate the short period of sleep within 2 big periods of wake
Short_sleep_during_wake = SandwichEpoch(SleepEpoch_Piezo, WakeEpoch_Piezo, 60*1e4, 30*1e4)
New_sleep = SleepEpoch_Piezo-Short_sleep_during_wake

TotalEpoch = intervalSet(0,max(Range(Piezo_Mouse_tsd)));
New_Wake = TotalEpoch - New_sleep;


%% Create the figure CompaSleepScoring
% Colors.Sleep = 'r';
% Colors.Wake = 'c';
% load('PiezoData_Corrected.mat');
% t = Range(Piezo_Mouse_tsd)/3600e4;
% begin = t(1);
% endin = t(end);
% 
% 
% figure
% subplot(4,1,1)
% ylim([0 2000]);
% yl=ylim;
% LineHeight = yl(2);
% load('SleepScoring_OBGamma.mat');
% plot(Range(SmoothGamma)/3600e4,Data(SmoothGamma),'color',[0.9290 0.6940 0.1250])
% hold on, plot(Range(Restrict(SmoothGamma,Wake))/3600e4,Data(Restrict(SmoothGamma,Wake)),'k')
% PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
% PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
% title('SleepScoring with Gamma')
% xlim([0 8.5]);
% ylim([0 2000]);
% xlabel('Time in hour')
% 
% subplot(4,1,2)
% ylim([2.8 4]);
% yl=ylim;
% LineHeight = yl(2);
% load('SleepScoring_Accelero.mat');
% plot(Range(tsdMovement)/3600e4,3+Data(tsdMovement)/1e9, 'g')
% hold on, plot(Range(Restrict(tsdMovement,Wake))/3600e4,3+Data(Restrict(tsdMovement,Wake))/1e9,'k')
% PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
% PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
% title('SleepScoring with movement')
% xlim([0 8.5]);
% ylim([2.8 4]);
% xlabel('Time in hour')
% 
% subplot(4,1,3)
% ylim([0 6]);
% yl=ylim;
% LineHeight = yl(2);
% load('PiezoData_SleepScoring.mat');
% plot(Range(Piezo_Mouse_tsd)/3600e4 , Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330])
% hold on, plot(Range(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo))/3600e4 , Data(Restrict(Piezo_Mouse_tsd,WakeEpoch_Piezo)),'k')
% PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
% PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
% title('SleepScoring with actimetry')
% xlim([0 8.5]);
% ylim([0 6]);
% xlabel('Time in s')
% 
% 
% subplot(4,1,4)
% ylim([0 6]);
% yl=ylim;
% LineHeight = yl(2);
% load('PiezoData_SleepScoring.mat');
% plot(Range(Piezo_Mouse_tsd)/3600e4 , Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330])
% hold on, plot(Range(Restrict(Piezo_Mouse_tsd,New_Wake))/3600e4 , Data(Restrict(Piezo_Mouse_tsd,New_Wake)),'k')
% PlotPerAsLine(New_sleep, LineHeight, Colors.Sleep, 'timescaling', 3600e4, 'linewidth',10);
% PlotPerAsLine(New_Wake, LineHeight, Colors.Wake, 'timescaling', 3600e4, 'linewidth',10);
% title('SleepScoring with actimetry corrected')
% xlim([0 8.5]);
% ylim([0 6]);
% xlabel('Time in s')




%% Do the Overlap figure
disp('Figure Overload Sleep Scoring loading ...')

%% Compare with OB scoring 
% load('SleepScoring_OBGamma.mat');
load('SleepScoring_OBGamma.mat');
load('PiezoData_SleepScoring.mat');

% Do the proba
durS_OB = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
durSS_Piez_OB = sum(Stop(and(New_sleep,Sleep),'s') - Start(and(New_sleep,Sleep),'s'));
proba_S_S_OB = (durSS_Piez_OB/durS_OB)*100;
durWS_Piez_OB = sum(Stop(and(New_Wake,Sleep),'s') - Start(and(New_Wake,Sleep),'s'));
proba_W_S_OB = (durWS_Piez_OB/durS_OB)*100;

durW_OB = sum(Stop(Wake,'s') - Start(Wake,'s'));
durWW_Piez_OB = sum(Stop(and(New_Wake,Wake),'s') - Start(and(New_Wake,Wake),'s'));
proba_W_W_OB = (durWW_Piez_OB/durW_OB)*100 ; 
durSW_Piez_OB = sum(Stop(and(New_sleep,Wake),'s') - Start(and(New_sleep,Wake),'s'));
proba_S_W_OB = (durSW_Piez_OB/durW_OB)*100 ; 

values = [proba_W_W_OB,proba_S_W_OB,proba_S_S_OB,proba_W_S_OB];
Values_name = {'WW_OB_corrected:','SW_OB_corrected:','SS_OB_corrected:','WS_OB_corrected:'};
disp([Values_name; num2cell(values)])

% Wake_LongOnly = dropShortIntervals(Wake,30*1e4);
% durW_OB = sum(Stop(Wake_LongOnly,'s') - Start(Wake_LongOnly,'s'));
% durW_Piez_OB = sum(Stop(and(WakeEpoch_Piezo,Wake_LongOnly),'s') - Start(and(WakeEpoch_Piezo,Wake_LongOnly),'s'));
% durW_Piez_OB/durW_OB


%% Compare with Accelero scoring 
% load('SleepScoring_OBGamma.mat');
load('SleepScoring_Accelero.mat');
load('PiezoData_SleepScoring.mat');

% Do the proba
durS_accelero = sum(Stop(Sleep,'s') - Start(Sleep,'s'));
durSS_Piez_accelero = sum(Stop(and(New_sleep,Sleep),'s') - Start(and(New_sleep,Sleep),'s'));
proba_S_S_accelero = (durSS_Piez_accelero/durS_accelero)*100;
durWS_Piez_accelero = sum(Stop(and(New_Wake,Sleep),'s') - Start(and(New_Wake,Sleep),'s'));
proba_W_S_accelero = (durWS_Piez_accelero/durS_accelero)*100;

durW_accelero = sum(Stop(Wake,'s') - Start(Wake,'s'));
durWW_Piez_accelero = sum(Stop(and(New_Wake,Wake),'s') - Start(and(New_Wake,Wake),'s'));
proba_W_W_accelero = (durWW_Piez_accelero/durW_accelero)*100 ; 
durSW_Piez_accelero = sum(Stop(and(New_sleep,Wake),'s') - Start(and(New_sleep,Wake),'s'));
proba_S_W_accelero = (durSW_Piez_accelero/durW_accelero)*100 ; 

values = [proba_W_W_accelero,proba_S_W_accelero,proba_S_S_accelero,proba_W_S_accelero];
Values_name = {'WW_accelero_corrected:','SW_accelero_corrected:','SS_accelero_corrected:','WS_accelero_corrected:'};
disp([Values_name; num2cell(values)])


%% Make the figure
% labels= {'Sleep','Wake'};
% 
% fig = figure
% subplot(1,4,2)
% proba_sleep = [proba_S_S_OB,proba_W_S_OB]; 
% proba_wake = [proba_S_W_OB,proba_W_W_OB]; 
% proba_stacked = [proba_sleep;proba_wake];
% bar(proba_stacked, 'stacked');
% set(gca, 'xticklabel',labels);
% ylabel('Overlap(%)');
% xlabel('OB gamma');
% title('OB gamma / Actimetry Corrected');
% legend('Sleep','Wake');
% lgd = legend('Sleep','Wake','Location','southoutside');
% title(lgd,'Actimetry Scoring');
% ylim([0 100]);
% 
% subplot(1,4,4)
% proba_sleep = [proba_S_S_accelero,proba_W_S_accelero]; 
% proba_wake = [proba_S_W_accelero,proba_W_W_accelero]; 
% proba_stacked = [proba_sleep;proba_wake];
% bar(proba_stacked, 'stacked');
% set(gca, 'xticklabel',labels);
% ylabel('Overlap(%)');
% xlabel('Movement');
% title('Movement / Actimetry Corrected');
% legend('Sleep','Wake');
% lgd = legend('Sleep','Wake','Location','southoutside');
% title(lgd,'Actimetry Scoring');
% ylim([0 100]);
% 

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


values = [proba_W_W_OB,proba_S_W_OB,proba_S_S_OB,proba_W_S_OB];
Values_name = {'WW_OB:','SW_OB:','SS_OB:','WS_OB:'};
disp([Values_name; num2cell(values)])


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


values = [proba_W_W_accelero,proba_S_W_accelero,proba_S_S_accelero,proba_W_S_accelero];
Values_name = {'WW_accelero:','SW_accelero:','SS_accelero:','WS_accelero:'};
disp([Values_name; num2cell(values)])


% 
% subplot(1,4,1)
% proba_sleep = [proba_S_S_OB,proba_W_S_OB]; 
% proba_wake = [proba_S_W_OB,proba_W_W_OB]; 
% proba_stacked = [proba_sleep;proba_wake];
% bar(proba_stacked, 'stacked');
% set(gca, 'xticklabel',labels);
% ylabel('Overlap(%)');
% xlabel('OB gamma');
% title('OB gamma / Actimetry ');
% legend('Sleep','Wake');
% lgd = legend('Sleep','Wake','Location','southoutside');
% title(lgd,'Actimetry Scoring');
% ylim([0 100]);
% 
% subplot(1,4,3)
% proba_sleep = [proba_S_S_accelero,proba_W_S_accelero]; 
% proba_wake = [proba_S_W_accelero,proba_W_W_accelero]; 
% proba_stacked = [proba_sleep;proba_wake];
% bar(proba_stacked, 'stacked');
% set(gca, 'xticklabel',labels);
% ylabel('Overlap(%)');
% xlabel('Movement');
% title('Movement / Actimetry');
% legend('Sleep','Wake');
% lgd = legend('Sleep','Wake','Location','southoutside');
% title(lgd,'Actimetry Scoring');
% ylim([0 100]);












