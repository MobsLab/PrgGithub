clear all
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_JumpEffect.mat')
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/TimeSpentFreezing_FLX_Sal.mat')


WithDrug = 1;
Withoutdrug = 1;

figure
clf
subplot(241),hold on
if Withoutdrug
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Sal(:),TimeSpentFz.UMazeCondBlockedShock_PreDrug.Sal(:),'b.','MarkerSize',10)
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Flx(:),TimeSpentFz.UMazeCondBlockedShock_PreDrug.Flx(:),'r.','MarkerSize',10)
legend('SAL','FLX')
end
xlabel('Jump Freq')
ylabel('Time spent freezing (s)')
subplot(245),hold on
if WithDrug
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal(:),TimeSpentFz.UMazeCondBlockedShock_PostDrug.Sal(:),'b.','MarkerSize',10)
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx(:),TimeSpentFz.UMazeCondBlockedShock_PostDrug.Flx(:),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent freezing (s)')

subplot(242),hold on
if Withoutdrug
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Sal(:),TimeSpentHiFz.UMazeCondBlockedShock_PreDrug.Sal(:),'b.','MarkerSize',10)
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Flx(:),TimeSpentHiFz.UMazeCondBlockedShock_PreDrug.Flx(:),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent HI freezing (s)')
subplot(246),hold on
if WithDrug
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal(:),TimeSpentHiFz.UMazeCondBlockedShock_PostDrug.Sal(:),'b.','MarkerSize',10)
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx(:),TimeSpentHiFz.UMazeCondBlockedShock_PostDrug.Flx(:),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent HI freezing (s)')


subplot(243),hold on
if Withoutdrug
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Sal(:),TimeSpentLoFz.UMazeCondBlockedShock_PreDrug.Sal(:),'b.','MarkerSize',10)
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Flx(:),TimeSpentLoFz.UMazeCondBlockedShock_PreDrug.Flx(:),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent LO freezing (s)')
subplot(247),hold on
if WithDrug
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal(:),TimeSpentLoFz.UMazeCondBlockedShock_PostDrug.Sal(:),'b.','MarkerSize',10)
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx(:),TimeSpentLoFz.UMazeCondBlockedShock_PostDrug.Flx(:),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent LO freezing (s)')

subplot(244),hold on
if Withoutdrug
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Sal(:),(TimeSpentHiFz.UMazeCondBlockedShock_PreDrug.Sal(:)./TimeSpentFz.UMazeCondBlockedShock_PreDrug.Sal(:)),'b.','MarkerSize',10)
plot(JumpNumber.UMazeCondBlockedShock_PreDrug.Flx(:),(TimeSpentHiFz.UMazeCondBlockedShock_PreDrug.Flx(:)./TimeSpentFz.UMazeCondBlockedShock_PreDrug.Flx(:)),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Prop HI freezing  ')

subplot(248),hold on
if WithDrug
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal(:),(TimeSpentHiFz.UMazeCondBlockedShock_PostDrug.Sal(:)./TimeSpentFz.UMazeCondBlockedShock_PostDrug.Sal(:)),'b.','MarkerSize',10)
    plot(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx(:),(TimeSpentHiFz.UMazeCondBlockedShock_PostDrug.Flx(:)./TimeSpentFz.UMazeCondBlockedShock_PostDrug.Flx(:)),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Prop HI freezing  ')

%% Link jump effect with extinction behaviour
figure
clf
WithDrug=1;

subplot(141),hold on
if WithDrug
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal,2),nanmean(TimeSpentFz.ExtinctionBlockedShock_PostDrug.Sal,2),'b.','MarkerSize',10)
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx,2),nanmean(TimeSpentFz.ExtinctionBlockedShock_PostDrug.Flx,2),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent freezing (s)')

subplot(142),hold on
if WithDrug
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal,2),nanmean(TimeSpentHiFz.ExtinctionBlockedShock_PostDrug.Sal,2),'b.','MarkerSize',10)
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx,2),nanmean(TimeSpentHiFz.ExtinctionBlockedShock_PostDrug.Flx,2),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent HI freezing (s)')


subplot(143),hold on
if WithDrug
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal,2),nanmean(TimeSpentLoFz.ExtinctionBlockedShock_PostDrug.Sal,2),'b.','MarkerSize',10)
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx,2),nanmean(TimeSpentLoFz.ExtinctionBlockedShock_PostDrug.Flx,2),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Time spent LO freezing (s)')

subplot(144),hold on
if WithDrug
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Sal,2),nanmean(TimeSpentHiFz.ExtinctionBlockedShock_PostDrug.Sal./TimeSpentFz.ExtinctionBlockedShock_PostDrug.Sal,2),'b.','MarkerSize',10)
    plot(nanmean(JumpNumber.UMazeCondBlockedShock_PostDrug.Flx,2),nanmean(TimeSpentHiFz.ExtinctionBlockedShock_PostDrug.Flx./TimeSpentFz.ExtinctionBlockedShock_PostDrug.Flx,2),'r.','MarkerSize',10)
end
xlabel('Jump Freq')
ylabel('Prop HI freezing / Tot freezing')

