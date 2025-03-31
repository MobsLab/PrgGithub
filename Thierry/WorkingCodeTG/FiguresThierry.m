%FiguresThierry


%%
%figure, moyenne difference stades
figure, 
subplot(2,1,1), hold on
plot(TimeWindow,nanmean(perc_eveil_opto'),'ko-')
plot(TimeWindow,nanmean(perc_SWS_opto'),'go-')
plot(TimeWindow,nanmean(perc_REM_opto'),'ro-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
subplot(2,1,2), hold on
plot(TimeWindow,nanmean(perc_eveil_ctrl'),'ko-')
plot(TimeWindow,nanmean(perc_SWS_ctrl'),'go-')
plot(TimeWindow,nanmean(perc_REM_ctrl'),'ro-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')


%%
%figure, moyenne ctrl vs opto
figure, 
subplot(3,1,1), hold on
plot(TimeWindow,nanmean(perc_REM_opto'),'r.-')
plot(TimeWindow,nanmean(perc_REM_ctrl'),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,2), hold on
plot(TimeWindow,nanmean(perc_SWS_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,nanmean(perc_SWS_opto'),'g.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,3), hold on
plot(TimeWindow,nanmean(perc_eveil_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,nanmean(perc_eveil_opto'),'k.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])

%%
%figure, all exp, ctrl vs opto

figure, 
subplot(3,1,1), hold on
plot(TimeWindow,(perc_REM_opto'),'r.-')
plot(TimeWindow,(perc_REM_ctrl'),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,2), hold on
plot(TimeWindow,(perc_SWS_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,(perc_SWS_opto'),'g.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,3), hold on
plot(TimeWindow,(perc_eveil_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,(perc_eveil_opto'),'k.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])

%%
%figure avec barres d'erreur

figure, 
subplot(3,1,1), hold on
errorbar(TimeWindow,nanmean(perc_REM_opto'),nanstd(perc_REM_opto'),'r.-')
plot(TimeWindow,nanmean(perc_REM_ctrl'),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,2), hold on
plot(TimeWindow,nanmean(perc_SWS_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,nanmean(perc_SWS_opto'),'g.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,3), hold on
plot(TimeWindow,nanmean(perc_eveil_ctrl'),'.-','color',[0.6 0.6 0.6])
plot(TimeWindow,nanmean(perc_eveil_opto'),'k.-')
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])



figure, 
subplot(3,1,1), hold on, 
errorbar(TimeWindow,nanmean(perc_REM_opto'),nanstd(perc_REM_opto')/sqrt(size(perc_REM_opto,2)),'g.-')
errorbar(TimeWindow,nanmean(perc_REM_ctrl'),nanstd(perc_REM_ctrl')/sqrt(size(perc_REM_ctrl,2)),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,2), hold on, 
errorbar(TimeWindow,nanmean(perc_SWS_opto'),nanstd(perc_SWS_opto')/sqrt(size(perc_SWS_opto,2)),'r.-')
errorbar(TimeWindow,nanmean(perc_SWS_ctrl'),nanstd(perc_SWS_ctrl')/sqrt(size(perc_SWS_ctrl,2)),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])
subplot(3,1,3), hold on, 
errorbar(TimeWindow,nanmean(perc_eveil_opto'),nanstd(perc_eveil_opto')/sqrt(size(perc_eveil_opto,2)),'b.-')
errorbar(TimeWindow,nanmean(perc_eveil_ctrl'),nanstd(perc_eveil_ctrl')/sqrt(size(perc_eveil_ctrl,2)),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')
xlim([-20 60])



figure, hold on, 
errorbar(TimeWindow,nanmean(perc_REM_opto'),nanstd(perc_REM_opto')/sqrt(length(perc_REM_opto)),'r.-')
errorbar(TimeWindow,nanmean(perc_REM_ctrl'),nanstd(perc_REM_ctrl')/sqrt(5),'.-','color',[0.6 0.6 0.6])
line([0 0],[0 100],'color',[0.6 0.6 0.6],'linestyle','--')

