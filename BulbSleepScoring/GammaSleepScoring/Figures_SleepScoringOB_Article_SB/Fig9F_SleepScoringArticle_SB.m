cd /media/DataMOBsRAIDN/ProjetSlSc/IsofluoraneExp/Isoflurane_M668/Isoflurane_WakeUP
figure
set(gcf,'defaultAxesColorOrder',[0 0 0;0 0 0])
load('B_High_Spectrum.mat')
subplot(311)
yyaxis left
imagesc(Spectro{2}/3600,Spectro{3},log(Spectro{1})')
axis xy
clim([-7 14])
load('behavResources.mat')
St= Start(StimEpoch,'s');
St=St(StimVolt ==2);
[M,T] = PlotRipRaw(MovAcctsd,St,3000,0,0);
Resp = nanmean(T(:,155:165)');
ylabel('Frequency (Hz)')
set(gca,'color','k')

yyaxis right
plot(St/3600,Resp,'color','k','linewidth',3)
set(gca,'LineWidth',2,'FontSize',15,'XTick',[])
box off
ylim([-1 15]*1e7)
ylabel('Stim Response')

subplot(312)
load('StateEpochSB.mat')
hold on
plot(Range(smooth_ghi,'h'),Data(smooth_ghi),'color','k','linewidth',1)
box off
ylabel('OB gamma power'),xlabel('')
set(gca,'LineWidth',2,'FontSize',15,'XTick',[],'YTick',[0:300:600])
xlim([0 11660]/3600)
ylim([0 800])

subplot(313)
load('HeartBeatInfo.mat')
plot(Range(EKG.HBRate,'h'),runmean(Data(EKG.HBRate),20),'color','k','linewidth',1)
box off
xlabel('Time (h)'), ylabel('Heart Rate (Hz)')
set(gca,'LineWidth',2,'FontSize',15,'XTick',[0:1:3])
xlim([0 11660]/3600)
colormap jet
