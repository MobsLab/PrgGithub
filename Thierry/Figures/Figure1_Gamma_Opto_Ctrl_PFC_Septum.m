%%Figure Gamma Power during Optostimulation of fibers in VLPO coming from PFC vs Septum

                                %%%%OPTO%%%%%
%Spectro OB OptoREM
freq=[40:80];

figure('color',[1 1 1]), subplot(3,6,[1:2]), imagesc(temps,freq, avdataSpREMopto),axis xy, caxis([0 1.4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM opto')
set(gca,'FontSize', 12)

%Spectro OB OptoNREM
hold on
subplot(3,6,[7:8]), imagesc(temps,freq, avdataSpSWSopto),axis xy, caxis([0 1.4]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB NREM opto')
set(gca,'FontSize', 12)

%Spectro OB OptoWake
hold on
subplot(3,6,[13:14]), imagesc(temps,freq, avdataSpWakeOpto),caxis([0 1.4]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake opto')
set(gca,'FontSize', 12)

%Bar Plot OB OptoREM
subplot(3,6,3),PlotErrorBarN_KJ({AvThetaREMoptoBefore, AvThetaREMOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

%Bar Plot OB OptoNREM
subplot(3,6,9),PlotErrorBarN_KJ({AvThetaSWSoptoBefore, AvThetaSWSOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

%Bar Plot OB OptoWake
subplot(3,6,15),PlotErrorBarN_KJ({AvThetaWakeOptoBefore AvThetaWakeOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.2])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

                                %%%%Ctrl%%%%%

%Spectro OB CtrlREM
hold on
subplot(3,6,[4:5]), imagesc(temps,freq, avdataSpREM),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM control','FontSize',14,'fontWeight','bold')
set(gca,'FontSize', 12)

%Spectro OB CtrlNREM
hold on
subplot(3,6,[10:11]), imagesc(temps,freq, avdataSpSWS),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB NREM control')
set(gca,'FontSize', 12)

%Spectro OB CtrlWake
hold on
subplot(3,6,[16:17]), imagesc(temps,freq, avdataSpWake),caxis([0 2.5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-50 50])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake control')
set(gca,'FontSize', 12)

%Bar Plot OB CtrlREM
subplot(3,6,6),PlotErrorBarN_KJ({AvThetaREMBefore, AvThetaREMDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

%Bar Plot OB CtrlNREM
subplot(3,6,12),PlotErrorBarN_KJ({AvThetaSWSBefore, AvThetaSWSDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

%Bar Plot OB CtrlWake
subplot(3,6,18),PlotErrorBarN_KJ({AvThetaWakeBefore AvThetaWakeDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.2])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before  ','During'});
set(gca,'FontSize', 12)

