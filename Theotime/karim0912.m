

load('behavResources.mat')
%load('behavResources.mat', 'StimEpoch')

figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'ko')
figure, plot(Data(AlignedXtsd), Data(AlignedYtsd),'k.-')

figure, plot(Data(Restrict(AlignedXtsd,Cond1)), Data(Restrict(AlignedXtsd,Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)),'k.-')
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')

stim=ts(Start(StimEpoch));
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')

figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')

% hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond1)),'ro','markerfacecolor','r')

%Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(or(SessionEpoch.Cond3,SessionEpoch.Cond4)));

stim=ts(Start(StimEpoch));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
%figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
%hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')

Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
close all

figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1])
ylim([0 1])

figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));

figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(AlignedXtsd,Restrict(stim,Cond)),'s'),Data(Restrict(AlignedXtsd,Restrict(stim,Cond))),'k.-'),
figure, plot(Range(Restrict(AlignedXtsd,Cond),'s'), Data(Restrict(AlignedYtsd,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r')
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, hold on, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'), scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
caxis
caxis([0 30])
caxis([0 15])
caxis([5 15])
caxis([5 6])

figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)


figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)


figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
caxis([0 30])

figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure,
subplot(2,2,1),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond1)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond1)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond1))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond1))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,2),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond2)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond2)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond2))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond2))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,3),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond3)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond3)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond3))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond3))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
subplot(2,2,4),
plot(Data(Restrict(AlignedXtsd,SessionEpoch.Cond4)), Data(Restrict(AlignedYtsd,SessionEpoch.Cond4)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,SessionEpoch.Cond4))), Data(Restrict(AlignedYtsd,Restrict(stim,SessionEpoch.Cond4))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
Cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, hold on,
plot(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),'k.-'),
scatter(Range(Restrict(LinearDist,Cond),'s'), Data(Restrict(LinearDist,Cond)),30,Data(Restrict(Vtsd,Restrict(LinearDist,Cond))),'filled')
hold on, plot(Range(Restrict(LinearDist,Restrict(stim,Cond)),'s'), Data(Restrict(LinearDist,Restrict(stim,Cond))),'ro','markerfacecolor','r','markersize',10)
figure, plot(Data(Restrict(AlignedXtsd,Cond)), Data(Restrict(AlignedYtsd,Cond)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])

TestPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
figure, plot(Data(Restrict(AlignedXtsd,TestPost)), Data(Restrict(AlignedYtsd,TestPost)),'k.-')
hold on, plot(Data(Restrict(AlignedXtsd,Restrict(stim,Cond))), Data(Restrict(AlignedYtsd,Restrict(stim,Cond))),'ro','markerfacecolor','r')
xlim([0 1]), ylim([0 1])
figure, plot(Data(Restrict(AlignedXtsd,SessionEpoch.Hab)), Data(Restrict(AlignedYtsd,SessionEpoch.Hab)),'k.-')