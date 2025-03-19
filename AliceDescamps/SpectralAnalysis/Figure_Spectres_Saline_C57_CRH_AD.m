%% Figure Sal/CNO during Wake/NREM/REM for all day

col_sal_C57 = [.7 .7 .7];
col_sal_CRH = [1 .4 0];

figure ('color',[1 1 1]),

ax(10)=subplot(3,6,1), shadedErrorBar(freq_sal_C57{1}, nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'r',1);
title('C57')
xlim([0 15])
% xlim([20 100])
% ylim([0 10e5])
ylim([0 5e6])
makepretty

ax(13)=subplot(3,6,2), shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'r',1);
title('CRH')
xlim([0 15])
% xlim([20 100])
% ylim([0 10e5])
ylim([0 5e6])
makepretty

ax(1) = subplot(3,6,4), a1= shadedErrorBar(freq_sal_C57{1}, nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
b1 = shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'g',1);
ylabel('Power (a.u)')
title('WAKE')
xlim([0 15])
% xlim([20 100])
% ylim([0 10e5])
ylim([0 5e6])
makepretty

ax(2)=subplot(3,6,5), a2= shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'k',1); hold on
b2= shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'g',1);
title('NREM')
xlim([0 15])
% xlim([20 100])
% ylim([0 10e5])
ylim([0 5e6])
makepretty

ax(3)=subplot(3,6,6), a3= shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'k', 1); hold on
b3= shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'g',1);
title('REM')
xlim([0 15])
% xlim([20 100])
% ylim([0 10e5])
ylim([0 5e6])
makepretty

a1.mainLine.Color = col_sal_C57
a1.patch.FaceColor = col_sal_C57
a1.edge(1,1).Color = col_sal_C57
a1.edge(1,2).Color = col_sal_C57
b1.mainLine.Color = col_sal_CRH
b1.edge(1,1).Color = col_sal_CRH
b1.edge(1,2).Color = col_sal_CRH
b1.patch.FaceColor = col_sal_CRH

a2.mainLine.Color = col_sal_C57
a2.edge(1,1).Color = col_sal_C57
a2.edge(1,2).Color = col_sal_C57
a2.patch.FaceColor = col_sal_C57
b2.mainLine.Color = col_sal_CRH
b2.edge(1,1).Color = col_sal_CRH
b2.edge(1,2).Color = col_sal_CRH
b2.patch.FaceColor = col_sal_CRH

a3.mainLine.Color = col_sal_C57
a3.edge(1,1).Color = col_sal_C57
a3.edge(1,2).Color = col_sal_C57
a3.patch.FaceColor = col_sal_C57
b3.mainLine.Color = col_sal_CRH
b3.edge(1,1).Color = col_sal_CRH
b3.edge(1,2).Color = col_sal_CRH
b3.patch.FaceColor = col_sal_CRH

ax(10)=subplot(3,6,7), shadedErrorBar(freq_sal_C57{1}, nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'r',1);
title('C57')
xlim([0 15])
% xlim([20 100])
set(gca, 'yscale','log')
ylim([0 1e10])
makepretty

ax(13)=subplot(3,6,8), shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'r',1);
title('CRH')
xlim([0 15])
% xlim([20 100])
set(gca, 'yscale','log')
ylim([0 1e10])
makepretty

ax(1) = subplot(3,6,10), a1= shadedErrorBar(freq_sal_C57{1}, nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
b1 = shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'g',1);
ylabel('Power (a.u)')
title('WAKE')
xlim([0 15])
% xlim([20 100])
set(gca, 'yscale','log')
ylim([0 1e10])
makepretty

ax(2)=subplot(3,6,11), a2= shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'k',1); hold on
b2= shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'g',1);
title('NREM')
xlim([0 15])
% xlim([20 100])
set(gca, 'yscale','log')
ylim([0 1e10])
makepretty

ax(3)=subplot(3,6,12), a3= shadedErrorBar(freq_sal_C57{1},  nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'k', 1); hold on
b3= shadedErrorBar(freq_sal_CRH{1},  nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'g',1);
title('REM')
xlim([0 15])
% xlim([20 100])
set(gca, 'yscale','log')
ylim([0 1e10])
makepretty

a1.mainLine.Color = col_sal_C57
a1.patch.FaceColor = col_sal_C57
a1.edge(1,1).Color = col_sal_C57
a1.edge(1,2).Color = col_sal_C57
b1.mainLine.Color = col_sal_CRH
b1.edge(1,1).Color = col_sal_CRH
b1.edge(1,2).Color = col_sal_CRH
b1.patch.FaceColor = col_sal_CRH

a2.mainLine.Color = col_sal_C57
a2.edge(1,1).Color = col_sal_C57
a2.edge(1,2).Color = col_sal_C57
a2.patch.FaceColor = col_sal_C57
b2.mainLine.Color = col_sal_CRH
b2.edge(1,1).Color = col_sal_CRH
b2.edge(1,2).Color = col_sal_CRH
b2.patch.FaceColor = col_sal_CRH

a3.mainLine.Color = col_sal_C57
a3.edge(1,1).Color = col_sal_C57
a3.edge(1,2).Color = col_sal_C57
a3.patch.FaceColor = col_sal_C57
b3.mainLine.Color = col_sal_CRH
b3.edge(1,1).Color = col_sal_CRH
b3.edge(1,2).Color = col_sal_CRH
b3.patch.FaceColor = col_sal_CRH


ax(10)=subplot(3,6,13), shadedErrorBar(freq_sal_C57{1}, freq_sal_C57{1}.*nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_C57{1},  freq_sal_C57{1}.*nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_C57{1},  freq_sal_C57{1}.*nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'r',1);
title('C57')
xlim([0 15])
% xlim([20 100])
ylim([0 10e6])
makepretty

ax(13)=subplot(3,6,14), shadedErrorBar(freq_sal_CRH{1},  freq_sal_CRH{1}.*nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'k',1); hold on
shadedErrorBar(freq_sal_CRH{1}, freq_sal_CRH{1}.* nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'b',1);
shadedErrorBar(freq_sal_CRH{1},  freq_sal_CRH{1}.*nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'r',1);
title('CRH')
xlim([0 15])
% xlim([20 100])
ylim([0 10e6])
makepretty

ax(1) = subplot(3,6,16), a1= shadedErrorBar(freq_sal_C57{1}, freq_sal_C57{1}.*nanmean(Spectre_C57_Wake_BeforeInj_mean), Spectre_C57_Wake_BeforeInj_SEM,'k',1); hold on
b1 = shadedErrorBar(freq_sal_CRH{1},  freq_sal_CRH{1}.*nanmean(Spectre_CRH_Wake_BeforeInj_mean), Spectre_CRH_Wake_BeforeInj_SEM,'g',1);
ylabel('Power (a.u)')
title('WAKE')
xlim([0 15])
% xlim([20 100])
ylim([0 10e6])
makepretty

ax(2)=subplot(3,6,17), a2= shadedErrorBar(freq_sal_C57{1},  freq_sal_C57{1}.*nanmean(Spectre_C57_SWS_BeforeInj_mean), Spectre_C57_SWS_BeforeInj_SEM,'k',1); hold on
b2= shadedErrorBar(freq_sal_CRH{1},  freq_sal_CRH{1}.*nanmean(Spectre_CRH_SWS_BeforeInj_mean), Spectre_CRH_SWS_BeforeInj_SEM,'g',1);
title('NREM')
xlim([0 15])
% xlim([20 100])
ylim([0 10e6])
makepretty

ax(3)=subplot(3,6,18), a3= shadedErrorBar(freq_sal_C57{1},  freq_sal_C57{1}.*nanmean(Spectre_C57_REM_BeforeInj_mean), Spectre_C57_REM_BeforeInj_SEM,'k', 1); hold on
b3= shadedErrorBar(freq_sal_CRH{1},  freq_sal_CRH{1}.*nanmean(Spectre_CRH_REM_BeforeInj_mean), Spectre_CRH_REM_BeforeInj_SEM,'g',1);
title('REM')
xlim([0 15])
% xlim([20 100])
ylim([0 10e6])
makepretty

a1.mainLine.Color = col_sal_C57
a1.patch.FaceColor = col_sal_C57
a1.edge(1,1).Color = col_sal_C57
a1.edge(1,2).Color = col_sal_C57
b1.mainLine.Color = col_sal_CRH
b1.edge(1,1).Color = col_sal_CRH
b1.edge(1,2).Color = col_sal_CRH
b1.patch.FaceColor = col_sal_CRH

a2.mainLine.Color = col_sal_C57
a2.edge(1,1).Color = col_sal_C57
a2.edge(1,2).Color = col_sal_C57
a2.patch.FaceColor = col_sal_C57
b2.mainLine.Color = col_sal_CRH
b2.edge(1,1).Color = col_sal_CRH
b2.edge(1,2).Color = col_sal_CRH
b2.patch.FaceColor = col_sal_CRH

a3.mainLine.Color = col_sal_C57
a3.edge(1,1).Color = col_sal_C57
a3.edge(1,2).Color = col_sal_C57
a3.patch.FaceColor = col_sal_C57
b3.mainLine.Color = col_sal_CRH
b3.edge(1,1).Color = col_sal_CRH
b3.edge(1,2).Color = col_sal_CRH
b3.patch.FaceColor = col_sal_CRH


suptitle ('OB high saline for C57 or CRH-Cre mice')

% set(ax,'xlim',[0 15], 'ylim',[0 10e5])
% set(ax,'xlim',[20 100], 'ylim',[0 1e5])