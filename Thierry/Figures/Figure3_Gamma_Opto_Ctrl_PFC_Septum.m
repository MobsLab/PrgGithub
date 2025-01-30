%%Figure Gamma Power during Optostimulation of fibers in VLPO coming from PFC vs Septum

cd ('/media/nas5/Thierry_DATA/Figures/PFC-Opto/23avril2021/')
load('AvSeptumOpto.mat')


%% gamma power overtime (for REM SWS and wakefulness)

%gamma power in REM
subplot(1,3,1)
% shadedErrorBar(temps,AvThetaREMctrl,{@mean,@stdError},'k',1);
% hold on 
shadedErrorBar(temps,AvThetaREMopto,{@mean,@stdError},'-g',1);
hold on
shadedErrorBar(temps,AvGammaREMoptoSeptum,{@mean,@stdError},'-g',1);
xlim([-50 +50])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Opto in REM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)

%gamma power Opto in NREM
subplot(1,3,2)
% shadedErrorBar(temps,AvThetaSWSctrl,{@nanmean,@stdError},'-k',1);
% hold on
shadedErrorBar(temps,AvThetaSWSopto,{@nanmean,@stdError},'-r',1);
hold on
shadedErrorBar(temps,AvGammaNREMoptoSeptum,{@nanmean,@stdError},'-r',1);
xlim([-100 +100])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Opto in NREM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)

%gamma power Opto in Wake
subplot(1,3,3)
% shadedErrorBar(temps,AvThetaWakectrl,{@nanmean,@stdError},'-k',1);
% hold on
shadedErrorBar(temps,AvThetaWakeopto,{@nanmean,@stdError},'-b',1);
hold on
shadedErrorBar(temps,AvGammaWakeoptoSeptum,{@nanmean,@stdError},'-b',1);
xlim([-100 +100])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power in wake')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)