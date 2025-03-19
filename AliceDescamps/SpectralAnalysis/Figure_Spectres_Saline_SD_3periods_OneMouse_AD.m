%% Get data
Get_Data_Spectres_Saline_SD_3periods_AD.m

%can do raw spectrum, 1/f and log
%make sure the name of mouse is good
%make sure the axis correspond between different time of the day

%% Figure comparing 1/2 during Wake/NREM/REM for 3 periods for one mouse
figure('color',[1 1 1]),

%colors
%saline
% col_1 = [.7 .7 .7];
% col_2 = [1 .4 0];
%cno
col_1 = [.2 .2 .2];
col_2 = [1 0 0];

% suptitle ('PFC low Sal/SD1+Sal for 1578 (OB scoring)')
% suptitle ('PFC low Sal/SD1+Sal for 1578')
% suptitle ('HPC low Sal/SD+Sal for 1578 (OB scoring)')
% suptitle ('HPC low Sal/SD+Sal for 1578')
% suptitle ('OB low Sal/SD+Sal for 1578 (OB scoring)')
% suptitle ('OB low Sal/SD+Sal for 1578')
% suptitle ('OB high Sal/SD+Sal for 1578 (OB scoring)')
suptitle ('OB high Sal/SD+Sal for 1578')
% suptitle ('PFC high Sal/SD+Sal for 1578 (OB scoring)')
% suptitle ('PFC high Sal/SD+Sal for 1578')
label = {'CNO','SD1 + CNO'}
% label = {'Sal','SD1 + Sal'}

subplot(3,6,1),
plot(freq_1{1},  Spectre_Wake_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_Wake_2_mean,'color',col_2);
ylabel('Power (a.u)')
title('All')
makepretty

subplot(3,6,7),
plot(freq_1{1},  Spectre_SWS_1_mean,'color',col_1); hold on
plot(freq_2{1}, Spectre_SWS_2_mean,'color',col_2);
ylabel('Power (a.u)')
makepretty

subplot(3,6,13),
plot(freq_1{1},  Spectre_REM_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_REM_2_mean,'color',col_2);
ylabel('Power (a.u)')
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,2), 
plot(freq_1{1},  Spectre_Wake_begin_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_Wake_begin_2_mean,'color',col_2);
title('0-1h30')
makepretty

subplot(3,6,8),
plot(freq_1{1},  Spectre_SWS_begin_1_mean,'color',col_1); hold on
plot(freq_2{1}, Spectre_SWS_begin_2_mean,'color',col_2);
makepretty

subplot(3,6,14),
plot(freq_1{1},  Spectre_REM_begin_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_REM_begin_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,3),
plot(freq_1{1},  Spectre_Wake_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_Wake_interPeriod_2_mean,'color',col_2);
title('1h30-3h30')
makepretty

subplot(3,6,9),
plot(freq_1{1},  Spectre_SWS_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1}, Spectre_SWS_interPeriod_2_mean,'color',col_2);
makepretty

subplot(3,6,15),
plot(freq_1{1},  Spectre_REM_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_REM_interPeriod_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,4),
plot(freq_1{1},  Spectre_Wake_end_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_Wake_end_2_mean,'color',col_2);
title('3h30-8h')
legend (label)
makepretty

subplot(3,6,10),
plot(freq_1{1},  Spectre_SWS_end_1_mean,'color',col_1); hold on
plot(freq_2{1}, Spectre_SWS_end_2_mean,'color',col_2);
makepretty

subplot(3,6,16),
plot(freq_1{1},  Spectre_REM_end_1_mean,'color',col_1); hold on
plot(freq_2{1},  Spectre_REM_end_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%% Figure normalized 1/f comparing 1/2 during Wake/NREM/REM for 3 periods for one mouse
figure('color',[1 1 1]),

%colors
%saline
% col_1 = [.7 .7 .7];
% col_2 = [1 .4 0];
%cno
col_1 = [.2 .2 .2];
col_2 = [1 0 0];

% suptitle ('PFC low Sal/SD1+Sal for 1578 (1/f) (OB scoring)')
% suptitle ('PFC low Sal/SD1+Sal for 1578 (1/f)')
% suptitle ('HPC low Sal/SD+Sal for 1578 (1/f) (OB scoring)')
% suptitle ('HPC low Sal/SD+Sal for 1578 (1/f)')
% suptitle ('OB low Sal/SD+Sal for 1578 (1/f) (OB scoring)')
% suptitle ('OB low Sal/SD+Sal for 1578 (1/f)')
% suptitle ('OB high Sal/SD+Sal for 1578 (1/f) (OB scoring)')
suptitle ('OB high Sal/SD+Sal for 1578 (1/f)')
% suptitle ('PFC high Sal/SD+Sal for 1578 (1/f) (OB scoring)')
% suptitle ('PFC high Sal/SD+Sal for 1578 (1/f)')
label = {'CNO','SD1 + CNO'}
% label = {'Sal','SD1 + Sal'}


subplot(3,6,1),
plot(freq_1{1}, freq_1{1}.* Spectre_Wake_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_Wake_2_mean,'color',col_2);
ylabel('Power (a.u)')
title('All')
makepretty


subplot(3,6,7),
plot(freq_1{1},  freq_1{1}.*Spectre_SWS_1_mean,'color',col_1); hold on
plot(freq_2{1}, freq_2{1}.*Spectre_SWS_2_mean,'color',col_2);
ylabel('Power (a.u)')
makepretty

subplot(3,6,13),
plot(freq_1{1},  freq_1{1}.*Spectre_REM_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_REM_2_mean,'color',col_2);
ylabel('Power (a.u)')
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,2), 
plot(freq_1{1},  freq_1{1}.*Spectre_Wake_begin_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_Wake_begin_2_mean,'color',col_2);
title('0-1h30')
makepretty

subplot(3,6,8),
plot(freq_1{1},  freq_1{1}.*Spectre_SWS_begin_1_mean,'color',col_1); hold on
plot(freq_2{1}, freq_2{1}.*Spectre_SWS_begin_2_mean,'color',col_2);
makepretty

subplot(3,6,14),
plot(freq_1{1},  freq_1{1}.*Spectre_REM_begin_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_REM_begin_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,3),
plot(freq_1{1},  freq_1{1}.*Spectre_Wake_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_Wake_interPeriod_2_mean,'color',col_2);
title('1h30-3h30')
makepretty

subplot(3,6,9),
plot(freq_1{1},  freq_1{1}.*Spectre_SWS_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1}, freq_2{1}.*Spectre_SWS_interPeriod_2_mean,'color',col_2);
makepretty

subplot(3,6,15),
plot(freq_1{1},  freq_1{1}.*Spectre_REM_interPeriod_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_REM_interPeriod_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,4),
plot(freq_1{1},  freq_1{1}.*Spectre_Wake_end_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_Wake_end_2_mean,'color',col_2);
title('3h30-8h')
legend (label)
makepretty

subplot(3,6,10),
plot(freq_1{1},  freq_1{1}.*Spectre_SWS_end_1_mean,'color',col_1); hold on
plot(freq_2{1}, freq_2{1}.*Spectre_SWS_end_2_mean,'color',col_2);
makepretty

subplot(3,6,16),
plot(freq_1{1},  freq_1{1}.*Spectre_REM_end_1_mean,'color',col_1); hold on
plot(freq_2{1},  freq_2{1}.*Spectre_REM_end_2_mean,'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%% Figure in log comparing 1/2 during Wake/NREM/REM for 3 periods for one mouse
figure('color',[1 1 1]),

%colors
%saline
% col_1 = [.7 .7 .7];
% col_2 = [1 .4 0];
%cno
col_1 = [.2 .2 .2];
col_2 = [1 0 0];

% suptitle ('PFC low Sal/SD1+Sal for 1578 (log) (OB scoring)')
% suptitle ('PFC low Sal/SD1+Sal for 1578 (log)')
% suptitle ('HPC low Sal/SD+Sal for 1578 (log) (OB scoring)')
% suptitle ('HPC low Sal/SD+Sal for 1578 (log)')
% suptitle ('OB low Sal/SD+Sal for 1578 (log) (OB scoring)')
% suptitle ('OB low Sal/SD+Sal for 1578 (log)')
% suptitle ('OB high Sal/SD+Sal for 1578 (log) (OB scoring)')
suptitle ('OB high Sal/SD+Sal for 1578 (log)')
% suptitle ('PFC high Sal/SD+Sal for 1578 (log) (OB scoring)')
% suptitle ('PFC high Sal/SD+Sal for 1578 (log)')
label = {'CNO','SD1 + CNO'}
% label = {'Sal','SD1 + Sal'}



subplot(3,6,1),
plot(freq_1{1}, log10(Spectre_Wake_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_Wake_2_mean),'color',col_2);
ylabel('Power (a.u)')
title('All')
makepretty

subplot(3,6,7),
plot(freq_1{1},  log10(Spectre_SWS_1_mean),'color',col_1); hold on
plot(freq_2{1}, log10(Spectre_SWS_2_mean),'color',col_2);
ylabel('Power (a.u)')
makepretty

subplot(3,6,13),
plot(freq_1{1},  log10(Spectre_REM_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_REM_2_mean),'color',col_2);
ylabel('Power (a.u)')
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,2), 
plot(freq_1{1},  log10(Spectre_Wake_begin_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_Wake_begin_2_mean),'color',col_2);
title('0-1h30')
makepretty

subplot(3,6,8),
plot(freq_1{1},  log10(Spectre_SWS_begin_1_mean),'color',col_1); hold on
plot(freq_2{1}, log10(Spectre_SWS_begin_2_mean),'color',col_2);
makepretty

subplot(3,6,14),
plot(freq_1{1},  log10(Spectre_REM_begin_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_REM_begin_2_mean),'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,3),
plot(freq_1{1},  log10(Spectre_Wake_interPeriod_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_Wake_interPeriod_2_mean),'color',col_2);
title('1h30-3h30')
makepretty

subplot(3,6,9),
plot(freq_1{1},  log10(Spectre_SWS_interPeriod_1_mean),'color',col_1); hold on
plot(freq_2{1}, log10(Spectre_SWS_interPeriod_2_mean),'color',col_2);
makepretty

subplot(3,6,15),
plot(freq_1{1},  log10(Spectre_REM_interPeriod_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_REM_interPeriod_2_mean),'color',col_2);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,4),
plot(freq_1{1},  log10(Spectre_Wake_end_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_Wake_end_2_mean),'color',col_2);
title('3h30-8h')
legend (label)
makepretty

subplot(3,6,10),
plot(freq_1{1},  log10(Spectre_SWS_end_1_mean),'color',col_1); hold on
plot(freq_2{1}, log10(Spectre_SWS_end_2_mean),'color',col_2);
makepretty

subplot(3,6,16),
plot(freq_1{1},  log10(Spectre_REM_end_1_mean),'color',col_1); hold on
plot(freq_2{1},  log10(Spectre_REM_end_2_mean),'color',col_2);
xlabel('Frequency(Hz)')
makepretty
