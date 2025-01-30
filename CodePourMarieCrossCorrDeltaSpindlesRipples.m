%CodePourMarieCrossCorrDeltaSpindlesRipples
try
    cd /media/mobssenior/Data2/Dropbox/MOBS_workingON/AnalyseMultivarieMarie/CrossCorrDeltaSpindlesRipples
catch
    cd /home/mobsyoda/Dropbox/MOBS_workingON/AnalyseMultivarieMarie/CrossCorrDeltaSpindlesRipples
end
load('AllCrossCorr.mat')

figure('color',[1 1 1])

subplot(3,3,1), hold on, plot(tps,CrossCorRipAtDelN1'), plot(tps,nanmean(CrossCorRipAtDelN1)','k','linewidth',2)
subplot(3,3,2), hold on, plot(tps,CrossCorRipAtDelN2'), plot(tps,nanmean(CrossCorRipAtDelN2)','k','linewidth',2)
subplot(3,3,3), hold on, plot(tps,CrossCorRipAtDelN3'), plot(tps,nanmean(CrossCorRipAtDelN3)','k','linewidth',2)
subplot(3,3,4), hold on, plot(tps,CrossCorRipAtSpiN1'), plot(tps,nanmean(CrossCorRipAtSpiN1)','k','linewidth',2)
subplot(3,3,5), hold on, plot(tps,CrossCorRipAtSpiN2'), plot(tps,nanmean(CrossCorRipAtSpiN2)','k','linewidth',2)
subplot(3,3,6), hold on, plot(tps,CrossCorRipAtSpiN3'), plot(tps,nanmean(CrossCorRipAtSpiN3)','k','linewidth',2)
subplot(3,3,7), hold on, plot(tps,CrossCorSpiAtDelN1'), plot(tps,nanmean(CrossCorSpiAtDelN1)','k','linewidth',2)
subplot(3,3,8), hold on, plot(tps,CrossCorSpiAtDelN2'), plot(tps,nanmean(CrossCorSpiAtDelN2)','k','linewidth',2)
subplot(3,3,9), hold on, plot(tps,CrossCorSpiAtDelN3'), plot(tps,nanmean(CrossCorSpiAtDelN3)','k','linewidth',2)



figure('color',[1 1 1])

subplot(3,3,1), hold on, plot(tps,nansum(CrossCorRipAtDelN1),'k','linewidth',2)
subplot(3,3,2), hold on, plot(tps,nansum(CrossCorRipAtDelN2),'k','linewidth',2)
subplot(3,3,3), hold on, plot(tps,nansum(CrossCorRipAtDelN3),'k','linewidth',2)
subplot(3,3,4), hold on, plot(tps,nansum(CrossCorRipAtSpiN1),'k','linewidth',2)
subplot(3,3,5), hold on, plot(tps,nansum(CrossCorRipAtSpiN2),'k','linewidth',2)
subplot(3,3,6), hold on, plot(tps,nansum(CrossCorRipAtSpiN3),'k','linewidth',2)
subplot(3,3,7), hold on, plot(tps,nansum(CrossCorSpiAtDelN1),'k','linewidth',2)
subplot(3,3,8), hold on, plot(tps,nansum(CrossCorSpiAtDelN2),'k','linewidth',2)
subplot(3,3,9), hold on, plot(tps,nansum(CrossCorSpiAtDelN3),'k','linewidth',2)




figure, 
subplot(3,2,1), imagesc(CrossCorRipAtDelN2)
subplot(3,2,2), imagesc(CrossCorRipAtDelN3)
subplot(3,2,3), imagesc(CrossCorSpiAtDelN2)
subplot(3,2,4), imagesc(CrossCorSpiAtDelN3)
subplot(3,2,5), plot(CrossCorRipAtDelN2,CrossCorSpiAtDelN2,'k.')
subplot(3,2,6), plot(CrossCorRipAtDelN3,CrossCorSpiAtDelN3,'k.')


figure, 
subplot(2,3,1), imagesc(CrossCorRipAtDelN2)
subplot(2,3,2), imagesc(CrossCorSpiAtDelN2)
subplot(2,3,3), plot(CrossCorRipAtDelN2,CrossCorSpiAtDelN2,'ko')
subplot(2,3,4), imagesc(CrossCorRipAtDelN3)
subplot(2,3,5), imagesc(CrossCorSpiAtDelN3)
subplot(2,3,6), plot(CrossCorRipAtDelN3,CrossCorSpiAtDelN3,'ko')



figure
subplot(3,2,1), plot(nanmean(CrossCorRipAtDelN2(:,14:19)'),nanmean(CrossCorSpiAtDelN2(:,27:31)'),'ko','markerfacecolor','k')
subplot(3,2,2), plot(nanmean(CrossCorRipAtDelN3(:,14:19)'),nanmean(CrossCorSpiAtDelN3(:,27:31)'),'ko','markerfacecolor','k')
subplot(3,2,3), plot(nanmean(CrossCorRipAtDelN2(:,14:19)'),nanmean(CrossCorSpiAtDelN2(:,14:19)'),'ko','markerfacecolor','k')
subplot(3,2,4), plot(nanmean(CrossCorRipAtDelN3(:,14:19)'),nanmean(CrossCorSpiAtDelN3(:,14:19)'),'ko','markerfacecolor','k')
subplot(3,2,5), hold on, plot(tps,nanmean(CrossCorRipAtDelN2),'k','linewidth',2), hold on, plot(tps,nanmean(CrossCorSpiAtDelN2),'r','linewidth',2)
hold on, line([tps(14) tps(14)],[0 0.4])
hold on, line([tps(19) tps(19)],[0 0.4])
hold on, line([tps(27) tps(27)],[0 0.4])
hold on, line([tps(31) tps(31)],[0 0.4])
subplot(3,2,6), hold on, plot(tps,nanmean(CrossCorRipAtDelN3),'k','linewidth',2), hold on, plot(tps,nanmean(CrossCorSpiAtDelN3),'r','linewidth',2)
hold on, line([tps(14) tps(14)],[0 0.4])
hold on, line([tps(19) tps(19)],[0 0.4])
hold on, line([tps(27) tps(27)],[0 0.4])
hold on, line([tps(31) tps(31)],[0 0.4])

