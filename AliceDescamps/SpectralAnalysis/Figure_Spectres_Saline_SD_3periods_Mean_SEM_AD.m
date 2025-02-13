%% Get data
Get_Data_Spectres_CNOine_SD_3periods_AD.m

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

% suptitle ('PFC low CNO/SD1+CNO (OB scoring)')
suptitle ('PFC low CNO/SD1+CNO')
% suptitle ('HPC low CNO/SD+CNO (OB scoring)')
% suptitle ('HPC low CNO/SD+CNO')
% suptitle ('OB low CNO/SD+CNO (OB scoring)')
% suptitle ('OB low CNO/SD+CNO')
% suptitle ('OB high CNO/SD+CNO (OB scoring)')
% suptitle ('OB high CNO/SD+CNO')
% suptitle ('PFC high CNO/SD+CNO (OB scoring)')
% suptitle ('PFC high CNO/SD+CNO')

% label = {'CNO','SD1 + CNO'}

subplot(3,6,1),
shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_1_mean), Spectre_Wake_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_2_mean), Spectre_Wake_2_SEM,{'color',col_2},1);
ylabel('Power (a.u)')
title('All')
makepretty

subplot(3,6,7),
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_1_mean), Spectre_SWS_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_2_mean), Spectre_SWS_2_SEM,{'color',col_2},1);
ylabel('Power (a.u)')
makepretty

subplot(3,6,13),
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_1_mean), Spectre_REM_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_2_mean), Spectre_REM_2_SEM,{'color',col_2},1);
ylabel('Power (a.u)')
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,2), 
shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_begin_1_mean), Spectre_Wake_begin_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_begin_2_mean), Spectre_Wake_begin_2_SEM,{'color',col_2},1);
title('0-1h30')
makepretty

subplot(3,6,8),
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_begin_1_mean), Spectre_SWS_begin_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_begin_2_mean), Spectre_SWS_begin_2_SEM,{'color',col_2},1);
makepretty

subplot(3,6,14),
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_begin_1_mean), Spectre_REM_begin_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_begin_2_mean), Spectre_REM_begin_2_SEM,{'color',col_2},1);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,3),
shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_interPeriod_1_mean), Spectre_Wake_interPeriod_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_interPeriod_2_mean), Spectre_Wake_interPeriod_2_SEM,{'color',col_2},1);
title('1h30-3h30')
makepretty

subplot(3,6,9),
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_interPeriod_1_mean), Spectre_SWS_interPeriod_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_interPeriod_2_mean), Spectre_SWS_interPeriod_2_SEM,{'color',col_2},1);
makepretty

subplot(3,6,15),
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_interPeriod_1_mean), Spectre_REM_interPeriod_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_interPeriod_2_mean), Spectre_REM_interPeriod_2_SEM,{'color',col_2},1);
xlabel('Frequency(Hz)')
makepretty

%
subplot(3,6,4),
shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_end_1_mean), Spectre_Wake_end_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_end_2_mean), Spectre_Wake_end_2_SEM,{'color',col_2},1);
title('3h30-8h')
makepretty

subplot(3,6,10),
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_end_1_mean), Spectre_SWS_end_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_end_2_mean), Spectre_SWS_end_2_SEM,{'color',col_2},1);
makepretty

subplot(3,6,16),
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_end_1_mean), Spectre_REM_end_1_SEM,{'color',col_1},1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_end_2_mean), Spectre_REM_end_2_SEM,{'color',col_2},1);
xlabel('Frequency(Hz)')
makepretty

%% Figure normalized 1/f comparing 1/2 during Wake/NREM/REM for 3 periods for one mouse
figure('color',[1 1 1]),

%colors
col_1 = [.7 .7 .7];
col_2 = [1 .4 0];

% suptitle ('PFC low CNO/SD1 for 1566 (OB scoring) (1/f)')
% suptitle ('PFC low CNO/SD1 for 1566 (1/f)')
% suptitle ('HPC low CNO/SD+CNO for 1566 (OB scoring) (1/f)')
suptitle ('HPC low CNO/SD+CNO for 1566 (1/f)')
% suptitle ('OB low CNO/SD+CNO for 1566 (OB scoring) (1/f)')
% suptitle ('OB low CNO/SD+CNO for 1566 (1/f)')
% suptitle ('OB high CNO/SD+CNO for 1566 (OB scoring) (1/f)')
% suptitle ('OB high CNO/SD+CNO for 1566 (1/f)')
% suptitle ('PFC high CNO/SD+CNO for 1566 (OB scoring) (1/f)')
% suptitle ('PFC high CNO/SD+CNO for 1566 (1/f)')
label = {'CNO','SD1 + CNOine'}

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
col_1 = [.7 .7 .7];
col_2 = [1 .4 0];

% suptitle ('PFC low CNO/SD1 for 1566 (OB scoring) (log)')
% suptitle ('PFC low CNO/SD1 for 1566 (log)')
% suptitle ('HPC low CNO/SD+CNO for 1566 (OB scoring) (log)')
suptitle ('HPC low CNO/SD+CNO for 1566 (log)')
% suptitle ('OB low CNO/SD+CNO for 1566 (OB scoring) (log)')
% suptitle ('OB low CNO/SD+CNO for 1566 (log)')
% suptitle ('OB high CNO/SD+CNO for 1566 (OB scoring) (log)')
% suptitle ('OB high CNO/SD+CNO for 1566 (log)')
% suptitle ('PFC high CNO/SD+CNO for 1566 (OB scoring) (log)')
% suptitle ('PFC high CNO/SD+CNO for 1566 (log)')
label = {'CNO','SD1 + CNOine'}

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
