%%Figure Gamma Power during Optostimulation of fibers in VLPO coming from PFC vs Septum

freq=[40:80];
%Spectro OB OptoREM
figure('color',[1 1 1]), subplot(3,3,1), imagesc(temps,freq, avdataSpREMopto),axis xy, caxis([0 1.4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-100 100])
ylim([40 +80])
%xlabel('Time (s)')
ylabel('Frequency (Hz)')
%colorbar
title('OB REM opto')
set(gca,'FontSize', 12)

%Spectro OB OptoNREM
hold on
subplot(3,3,2), imagesc(temps,freq, avdataSpSWSopto),axis xy, caxis([0 1.4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-100 100])
ylim([40 +80])
%xlabel('Time (s)')
ylabel('Frequency (Hz)')
%colorbar
title('OB NREM opto')
set(gca,'FontSize', 12)

%Spectro OB OptoWake
hold on
subplot(3,3,3), imagesc(temps,freq, avdataSpWakeOpto),caxis([0 1.4]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-100 100])
ylim([40 +80])
%xlabel('Time (s)')
ylabel('Frequency (Hz)')
%colorbar
title('OB Wake opto')
set(gca,'FontSize', 12)

%% gamma power overtime (for REM SWS and wakefulness)

%gamma power Opto in REM
hold on,
subplot(3,3,4)
%shadedErrorBar(temps,AvThetaREMctrl,{@mean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaREMopto,{@mean,@stdError},'-g',1);
xlim([-50 +50])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Opto in REM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)

%gamma power Opto in NREM
hold on,
subplot(3,3,5)
%shadedErrorBar(temps,AvThetaSWSctrl,{@nanmean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaSWSopto,{@nanmean,@stdError},'-r',1);
xlim([-100 +100])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Opto in NREM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)

%gamma power Opto in Wake
hold on,
subplot(3,3,6)
%shadedErrorBar(temps,AvThetaWakectrl,{@nanmean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaWakeopto,{@nanmean,@stdError},'-b',1);
xlim([-100 +100])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Opto in wake')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)

%gamma power End REM
hold on,
subplot(3,3,7)
shadedErrorBar(temps,AvThetaREMopto,{@mean,@stdError},'-g',1);
xlim([-50 +50])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power end REM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)


%gamma power End NREM 
hold on,
subplot(3,3,8)
shadedErrorBar(temps,AvThetaSWSopto,{@nanmean,@stdError},'-r',1);
xlim([-100 +100])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power end NREM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)


%gamma power Start Wake 
hold on,
subplot(3,3,9)
shadedErrorBar(temps,AvThetaWakeopto,{@nanmean,@stdError},'-b',1);
xlim([-100 +100])
ylim([0 2.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power Start wake')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 12)
