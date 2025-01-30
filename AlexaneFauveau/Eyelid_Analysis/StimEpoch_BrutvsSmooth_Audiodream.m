%% Plot data without transformation : 

% Do the stim
load('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];
Sync_Event_Start = [Start(TTLInfo.Sync)];

duration_stim = 4e4 ; % e4 -> en secondes
Stim_Epoch_Start = Stim_Event_Start+duration_stim;

duration = 10e4 ;  % 
Stim_Epoch_End = Stim_Epoch_Start + duration;

Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);

Event_Stim = intervalSet(Stim_Event_Start, Stim_Event_Start+0.2e4);
 
% Plot Gamma Brut
load('SleepScoring_OBGamma.mat')
% Recalculate gamm no smoothing
load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);


% Plot it
Colors.Sleep = 'r';
Colors.Wake = 'c';
Colors.Stim1 = 'y';
Colors.Stim15 = 'g';
Colors.Stim2 = 'k';
t = Range(SmoothGamma);
begin = t(1);
endin = t(end);

figure
subplot(131)
plot(Range(tot_ghi, 's'),Data(tot_ghi),'color',[0.9290 0.6940 0.1250]);
hold on
plot(Range(Restrict(tot_ghi,Event_Stim),'s'),Data(Restrict(tot_ghi,Event_Stim)),'b--')
hold on,
plot(Range(SmoothGamma, 's'),Data(SmoothGamma),'k');
hold on
ylim([0 7000]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes filtrées dans la fréquence du Gamma','Moment de la stimulation','Données filtrées et smoothées dans la fréquence du Gamma','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('OB Gamma')

% For accelero : 
% brut : MovAcctsd
% resample : tsdMovement
load('SleepScoring_Accelero.mat')

subplot(132)
plot(Range(MovAcctsd, 's'),Data(MovAcctsd),'g');
hold on
plot(Range(Restrict(MovAcctsd,Event_Stim),'s'),Data(Restrict(MovAcctsd,Event_Stim)),'b--')
hold on 
plot(Range(tsdMovement, 's'),Data(tsdMovement),'k');
hold on
ylim([0 0.75e8]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes','Moment de la stimulation','Données smoothées','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('Accéléromètre')



% For Piezo : 
load('PiezoData_SleepScoring.mat')
Piezo_Mouse_tsd = tsd(Range(Piezo_Mouse_tsd), abs(zscore(Data(Piezo_Mouse_tsd))));

subplot(133)
plot(Range(Piezo_Mouse_tsd, 's'),Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330]);
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,Event_Stim),'s'),Data(Restrict(Piezo_Mouse_tsd,Event_Stim)),'b--')
hold on 
plot(Range(Smooth_actimetry, 's'),Data(Smooth_actimetry),'k');
hold on
ylim([0 2]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes','Moment de la stimulation','Données smoothées','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('Piézo')


subplot(131)
xl = xlim
subplot(132)
xlim(xl)
subplot(133)
xlim(xl)
















%% Plot data without transformation : 

% Do the stim
load('behavResources.mat')
Stim_Event_Start = [Start(TTLInfo.StimEpoch)];
Sync_Event_Start = [Start(TTLInfo.Sync)];

duration_stim = 4e4 ; % e4 -> en secondes
Stim_Epoch_Start = Stim_Event_Start+duration_stim;

duration = 10e4 ;  % 
Stim_Epoch_End = Stim_Epoch_Start + duration;

Epoch_Stim = intervalSet(Stim_Epoch_Start, Stim_Epoch_End);

Event_Stim = intervalSet(Stim_Event_Start, Stim_Event_Start+0.2e4);
 
% Plot Gamma Brut
load('SleepScoring_OBGamma_Audiodream.mat')
% Recalculate gamm no smoothing
load('ChannelsToAnalyse/Bulb_deep.mat','channel')
load([cd,'/LFPData/LFP',num2str(channel)],'LFP');
FilGamma=FilterLFP(LFP,[50 70],1024);
HilGamma=hilbert(Data(FilGamma));
H=abs(HilGamma);
tot_ghi=tsd(Range(LFP),H);


% Plot it
Colors.Sleep = 'r';
Colors.Wake = 'c';
Colors.Stim1 = 'y';
Colors.Stim15 = 'g';
Colors.Stim2 = 'k';
t = Range(SmoothGamma);
begin = t(1);
endin = t(end);

figure
subplot(131)
plot(Range(tot_ghi, 's'),Data(tot_ghi),'color',[0.9290 0.6940 0.1250]);
hold on
plot(Range(Restrict(tot_ghi,Event_Stim),'s'),Data(Restrict(tot_ghi,Event_Stim)),'b--')
hold on,
plot(Range(SmoothGamma, 's'),Data(SmoothGamma),'k');
hold on
ylim([0 1000]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes filtrées dans la fréquence du Gamma','Moment de la stimulation','Données filtrées et smoothées dans la fréquence du Gamma','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('OB Gamma')

% For accelero : 
% brut : MovAcctsd
% resample : tsdMovement
load('SleepScoring_Accelero.mat')

subplot(132)
plot(Range(MovAcctsd, 's'),Data(MovAcctsd),'g');
hold on
plot(Range(Restrict(MovAcctsd,Event_Stim),'s'),Data(Restrict(MovAcctsd,Event_Stim)),'b--')
hold on 
plot(Range(tsdMovement, 's'),Data(tsdMovement),'k');
hold on
ylim([0 0.75e8]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(Sleep, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(Wake, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes','Moment de la stimulation','Données smoothées','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('Accéléromètre')



% For Piezo : 
load('PiezoData_SleepScoring.mat')
Piezo_Mouse_tsd = tsd(Range(Piezo_Mouse_tsd), abs(zscore(Data(Piezo_Mouse_tsd))));

subplot(133)
plot(Range(Piezo_Mouse_tsd, 's'),Data(Piezo_Mouse_tsd),'color',[0.3010 0.7450 0.9330]);
hold on
plot(Range(Restrict(Piezo_Mouse_tsd,Event_Stim),'s'),Data(Restrict(Piezo_Mouse_tsd,Event_Stim)),'b--')
hold on 
plot(Range(Smooth_actimetry, 's'),Data(Smooth_actimetry),'k');
hold on
ylim([0 2]);
yl=ylim;
LineHeight = yl(2);
PlotPerAsLine(SleepEpoch_Piezo, LineHeight, Colors.Sleep, 'timescaling', 1e4, 'linewidth',10);
PlotPerAsLine(WakeEpoch_Piezo, LineHeight, Colors.Wake, 'timescaling', 1e4, 'linewidth',10);
xlabel('Temps en s')
legend('Données brutes','Moment de la stimulation','Données smoothées','Location','southoutside')
xlim([0 max(Range(SmoothGamma, 's'))])
title('Piézo')


subplot(131)
xl = xlim
subplot(132)
xlim(xl)
subplot(133)
xlim(xl)
















