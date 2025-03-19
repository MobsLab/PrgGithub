%% Get data
Get_Data_Spectres_Saline_SD_3periods_AD.m

%% Figure comparing 1/2 during Wake/NREM/REM for 3 periods
figure('color',[1 1 1]),

ax(10)=subplot(3,6,1), shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_1_mean), Spectre_Wake_1_SEM,'k',1); hold on
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_1_mean), Spectre_SWS_1_SEM,'b',1);
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_1_mean), Spectre_REM_1_SEM,'r',1);
title('All session')
makepretty

ax(11)=subplot(3,6,4), shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_begin_1_mean), Spectre_Wake_begin_1_SEM,'k',1); hold on
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_begin_1_mean), Spectre_SWS_begin_1_SEM,'b',1);
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_begin_1_mean), Spectre_REM_begin_1_SEM,'r',1);
title('1st period')
makepretty

ax(12)=subplot(3,6,5), shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_interPeriod_1_mean), Spectre_Wake_interPeriod_1_SEM,'k',1); hold on
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_interPeriod_1_mean), Spectre_SWS_interPeriod_1_SEM,'b',1);
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_interPeriod_1_mean), Spectre_REM_interPeriod_1_SEM,'r',1);
title('Interperiod')
makepretty

ax(12)=subplot(3,6,6), shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_end_1_mean), Spectre_Wake_end_1_SEM,'k',1); hold on
shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_end_1_mean), Spectre_SWS_end_1_SEM,'b',1);
shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_end_1_mean), Spectre_REM_end_1_SEM,'r',1);
title('End')
makepretty


ax(13)=subplot(3,6,7), shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_2_mean), Spectre_Wake_2_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_2_mean), Spectre_SWS_2_SEM,'b',1);
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_2_mean), Spectre_REM_2_SEM,'r',1);
title('All session')
makepretty

ax(14)=subplot(3,6,10), shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_begin_2_mean), Spectre_Wake_begin_2_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_begin_2_mean), Spectre_SWS_begin_2_SEM,'b',1);
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_begin_2_mean), Spectre_REM_begin_2_SEM,'r',1);
title('1st period')
makepretty

ax(15)=subplot(3,6,11), shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_interPeriod_2_mean), Spectre_Wake_interPeriod_2_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_interPeriod_2_mean), Spectre_SWS_interPeriod_2_SEM,'b',1);
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_interPeriod_2_mean), Spectre_REM_interPeriod_2_SEM,'r',1);
title('Interperiod')
makepretty

ax(15)=subplot(3,6,12), shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_end_2_mean), Spectre_Wake_end_2_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_end_2_mean), Spectre_SWS_end_2_SEM,'b',1);
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_end_2_mean), Spectre_REM_end_2_SEM,'r',1);
title('End')
makepretty

%
ax(1)=subplot(3,6,13), shadedErrorBar(freq_1{1},  nanmean(Spectre_Wake_1_mean), Spectre_Wake_1_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_Wake_2_mean), Spectre_Wake_2_SEM,'r',1);
ylabel('Power (a.u)')
title('WAKE all')
xlabel('Frequency(Hz)')
makepretty
ax(2)=subplot(3,6,14), shadedErrorBar(freq_1{1},  nanmean(Spectre_SWS_1_mean), Spectre_SWS_1_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_SWS_2_mean), Spectre_SWS_2_SEM,'r',1);
title('NREM all')
xlabel('Frequency(Hz)')
makepretty
ax(3)=subplot(3,6,15), shadedErrorBar(freq_1{1},  nanmean(Spectre_REM_1_mean), Spectre_REM_1_SEM,'k',1); hold on
shadedErrorBar(freq_2{1},  nanmean(Spectre_REM_2_mean), Spectre_REM_2_SEM,'r',1);
title('REM all')
xlabel('Frequency(Hz)')
makepretty

%
% suptitle ('HPC low Sal/SD+Sal for mCherry')
% suptitle ('OB low Sal/SD+Sal for mCherry')
suptitle ('PFC low Sal/SD+Sal for mCherry')

xlim([0 20])
ylim([0 3e6])