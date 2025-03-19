%% Figure Sal/CNO during Wake/NREM/REM for pre/post/3h post periods
figure,
ax(10)=subplot(3,6,1), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'r',1);
title('pre saline')
makepretty

ax(11)=subplot(3,6,7), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'r',1);
title('post saline')
makepretty

ax(12)=subplot(3,6,13), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean_norm), SpectreSaline_Wake_AfterInj_3h_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean_norm), SpectreSaline_SWS_AfterInj_3h_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean_norm), SpectreSaline_REM_AfterInj_3h_SEM_norm,'r',1);
title('3h post saline')
makepretty

ax(13)=subplot(3,6,2), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'r',1);
title('pre CNO')
makepretty

ax(14)=subplot(3,6,8), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'r',1);
title('post CNO')
makepretty

ax(15)=subplot(3,6,14), shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean_norm), SpectreCNO_Wake_AfterInj_3h_SEM_norm,'k',1); hold on
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean_norm), SpectreCNO_SWS_AfterInj_3h_SEM_norm,'b',1);
shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean_norm), SpectreCNO_REM_AfterInj_3h_SEM_norm,'r',1);
title('3h post CNO')
makepretty


ax(1)=subplot(3,6,4), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);
ylabel('Power (a.u)')
title('WAKE pre')
makepretty
ax(2)=subplot(3,6,5), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'g',1);
title('NREM pre')
makepretty
ax(3)=subplot(3,6,6), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'g',1);
title('REM pre')
makepretty

ax(4)=subplot(3,6,10), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
title('WAKE post')
ylabel('Power (a.u)')
makepretty
ax(5)=subplot(3,6,11), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'g',1);
title('NREM post')
makepretty
ax(6)=subplot(3,6,12), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'g',1);
title('REM post')
makepretty

ax(7)=subplot(3,6,16), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean_norm), SpectreSaline_Wake_AfterInj_3h_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean_norm), SpectreCNO_Wake_AfterInj_3h_SEM_norm,'g',1);
title('WAKE 3h post')
xlabel('Frequency(Hz)')
ylabel('Power (a.u)')
makepretty
ax(8)=subplot(3,6,17), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean_norm), SpectreSaline_SWS_AfterInj_3h_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean_norm), SpectreCNO_SWS_AfterInj_3h_SEM_norm,'g',1);
xlabel('Frequency(Hz)')
title('NREM 3h post')
makepretty
ax(9)=subplot(3,6,18), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean_norm), SpectreSaline_REM_AfterInj_3h_SEM_norm,'k',1); hold on
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean_norm), SpectreCNO_REM_AfterInj_3h_SEM_norm,'g',1);
xlabel('Frequency(Hz)')
title('REM 3h post')
makepretty



suptitle ('HPC low normalized on mean sal/CNO for CRH DREADD inhib')

set(ax,'xlim',[0 15], 'ylim',[0 5])
%% Figure pre/post periods for Sal or CNO during Wake/NREM/REM
figure,
ax(16)=subplot(3,6,1),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k:',1);hold on
% shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1);
s1=shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_3h_mean_norm), SpectreSaline_Wake_AfterInj_3h_SEM_norm,'k',1);
title('WAKE - saline')
makepretty
%sws saline
ax(17)=subplot(3,6,2),shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'b:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'b',1);
 shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_3h_mean_norm), SpectreSaline_SWS_AfterInj_3h_SEM_norm,'b',1);
 title('NREM - saline')
makepretty
% rem saline
ax(18)=subplot(3,6,3), shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'r:',1);hold on
%  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'r',1);
  shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_3h_mean_norm), SpectreSaline_REM_AfterInj_3h_SEM_norm,'r',1);
  title('REM - saline')
makepretty
%wake cno
ax(19)=subplot(3,6,7),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'k:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'k',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_3h_mean_norm), SpectreCNO_Wake_AfterInj_3h_SEM_norm,'k',1);
title('WAKE - CNO')
makepretty
xlabel('Frequency (Hz)')
%sws cno
ax(20)=subplot(3,6,8),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'b:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj__all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'b',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_3h_mean_norm), SpectreCNO_SWS_AfterInj_3h_SEM_norm,'b',1);
title('NREM - CNO')
makepretty
xlabel('Frequency (Hz)')
%rem cno
ax(21)=subplot(3,6,9),shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'r:',1);hold on
% shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'r',1);
shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_3h_mean_norm), SpectreCNO_REM_AfterInj_3h_SEM_norm,'r',1);
makepretty
title('REM - CNO')
xlabel('Frequency (Hz)')


suptitle ('HPC low normalized on mean sal/CNO for CRH DREADD inhib')

set(ax,'xlim',[0 15], 'ylim',[0 5])
% set(ax,'xlim',[20 100], 'ylim',[0 1e5])


%%
% 
% %% pre vs post
% figure
% subplot(231)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(232)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'k',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(233)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'k',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(234)
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(235)
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(236)
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'k:',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% 
% 
% %% sal vs atropine
% figure
% subplot(231)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(232)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_BeforeInj_mean_norm), SpectreSaline_SWS_BeforeInj_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_BeforeInj_mean_norm), SpectreCNO_SWS_BeforeInj_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% 
% subplot(233)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_BeforeInj_mean_norm), SpectreSaline_REM_BeforeInj_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_BeforeInj_mean_norm), SpectreCNO_REM_BeforeInj_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% 
% subplot(234)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(235)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_SWS_AfterInj_all_mean_norm), SpectreSaline_SWS_AfterInj_all_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_SWS_AfterInj_all_mean_norm), SpectreCNO_SWS_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% subplot(236)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_REM_AfterInj_all_mean_norm), SpectreSaline_REM_AfterInj_all_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_REM_AfterInj_all_mean_norm), SpectreCNO_REM_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% 
% 
% 
% 
% %% wake high/low movement
% figure
% subplot(2,6,[1,2,7,8])
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_BeforeInj_mean_norm), SpectreSaline_Wake_BeforeInj_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_BeforeInj_mean_norm), SpectreCNO_Wake_BeforeInj_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 100])
% title('Wake pre')
% 
% subplot(2,6,3)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_Before_mean_norm), SpectreSaline_WakeLowMov_Before_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_Before_mean_norm), SpectreCNO_WakeLowMov_Before_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 99])
% title('Wake Low mov')
% 
% subplot(2,6,9)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_Before_mean_norm), SpectreSaline_WakeHighMov_Before_SEM_norm,'k',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_Before_mean_norm), SpectreCNO_WakeHighMov_Before_SEM_norm,'g',1);hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 100])
% title('Wake High mov')
% 
% subplot(2,6,[4,5,10,11])
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_Wake_AfterInj_all_mean_norm), SpectreSaline_Wake_AfterInj_all_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_cno{1},  nanmean(SpectreCNO_Wake_AfterInj_all_mean_norm), SpectreCNO_Wake_AfterInj_all_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 100])
% title('Wake')
% 
% subplot(2,6,6)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeLowMov_After_mean_norm), SpectreSaline_WakeLowMov_After_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeLowMov_After_mean_norm), SpectreCNO_WakeLowMov_After_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 100])
% title('Wake Low mov')
% 
% subplot(2,6,12)
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreSaline_WakeHighMov_After_mean_norm), SpectreSaline_WakeHighMov_After_SEM_norm,'k',1); hold on
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% s = shadedErrorBar(frq_sal{1},  nanmean(SpectreCNO_WakeHighMov_After_mean_norm), SpectreCNO_WakeHighMov_After_SEM_norm,'g',1);
% set(s.edge, 'linewidth', 0.1, 'color', 'none');
% makepretty
% % xlim([20 100])
% title('Wake High mov')
% 
% 
% %% individual trace
% 
% figure
% subplot(2,6,[1,2,7,8])
% s = plot(frq_sal{1},  (SpectreSaline_Wake_BeforeInj_mean_norm),'k');hold on
% s = plot(frq_cno{1},  (SpectreCNO_Wake_BeforeInj_mean_norm),'g');hold on
% makepretty
% xlim([20 100])
% title('Wake pre')
% 
% subplot(2,6,3)
% s = plot(frq_sal{1},  (SpectreSaline_WakeLowMov_Before_mean_norm),'k');hold on
% s = plot(frq_sal{1},  (SpectreCNO_WakeLowMov_Before_mean_norm),'g');hold on
% makepretty
% xlim([20 100])
% title('Wake Low mov')
% 
% subplot(2,6,9)
% s = plot(frq_sal{1},  (SpectreSaline_WakeHighMov_Before_mean_norm),'k');hold on
% s = plot(frq_sal{1},  (SpectreCNO_WakeHighMov_Before_mean_norm),'g');hold on
% makepretty
% xlim([20 100])
% title('Wake High mov')
% 
% subplot(2,6,[4,5,10,11])
% s = plot(frq_sal{1},  (SpectreSaline_Wake_AfterInj_all_mean_norm),'k'); hold on
% s = plot(frq_cno{1},  (SpectreCNO_Wake_AfterInj_all_mean_norm),'g');
% makepretty
% xlim([20 100])
% title('Wake')
% 
% subplot(2,6,6)
% s = plot(frq_sal{1},  (SpectreSaline_WakeLowMov_After_mean_norm),'k'); hold on
% s = plot(frq_sal{1},  (SpectreCNO_WakeLowMov_After_mean_norm),'g');
% makepretty
% xlim([20 100])
% title('Wake Low mov')
% 
% subplot(2,6,12)
% s = plot(frq_sal{1},  (SpectreSaline_WakeHighMov_After_mean_norm),'k'); hold on
% s = plot(frq_sal{1},  (SpectreCNO_WakeHighMov_After_mean_norm),'g');
% makepretty
% xlim([20 100])
% title('Wake High mov')
% 
