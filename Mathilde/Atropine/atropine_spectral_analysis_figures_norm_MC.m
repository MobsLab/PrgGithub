%%
figure, hold on,
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'r',1);
title('saline')
makepretty



figure, hold on,
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'r',1);
title('atropine')
makepretty





%% pre vs post
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'k',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(234)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'k:',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


%% sal vs atropine
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty


subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty





subplot(234)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(235)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty

subplot(236)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty



%% sal vs atropine 3H post
figure
subplot(231)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('WAKE - pre')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')

subplot(232)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('NREM - pre')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')

subplot(233)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('REM - pre')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')




subplot(234)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean_norm), SpectreSaline_Wake_AfterInj_3h_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean_norm), SpectreCNO_Wake_AfterInj_3h_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('WAKE - 2h post')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')

subplot(235)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean_norm), SpectreSaline_SWS_AfterInj_3h_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean_norm), SpectreCNO_SWS_AfterInj_3h_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('NREM - 2h post')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')

subplot(236)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean_norm), SpectreSaline_REM_AfterInj_3h_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean_norm), SpectreCNO_REM_AfterInj_3h_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
title('REM - 2h post')
xlabel('Frequency (Hz)')
ylabel('Normalized power (a.u)')





%% wake high/low movement
figure
subplot(2,6,[1,2,7,8])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake pre')

subplot(2,6,3)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_Before_mean_norm), SpectreSaline_WakeLowMov_Before_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_Before_mean_norm), SpectreCNO_WakeLowMov_Before_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake Low mov')

subplot(2,6,9)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_Before_mean_norm), SpectreSaline_WakeHighMov_Before_SEM_norm,'k',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_Before_mean_norm), SpectreCNO_WakeHighMov_Before_SEM_norm,'g',1);hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake High mov')

subplot(2,6,[4,5,10,11])
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake')

subplot(2,6,6)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_After_mean_norm), SpectreSaline_WakeLowMov_After_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_After_mean_norm), SpectreCNO_WakeLowMov_After_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake Low mov')

subplot(2,6,12)
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_After_mean_norm), SpectreSaline_WakeHighMov_After_SEM_norm,'k',1); hold on
set(s.edge, 'linewidth', 0.1, 'color', 'none');
s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_After_mean_norm), SpectreCNO_WakeHighMov_After_SEM_norm,'g',1);
set(s.edge, 'linewidth', 0.1, 'color', 'none');
makepretty
xlim([20 100])
title('Wake High mov')
