

figure, 
subplot(2,1,1)
plot(Range(LinearPredTsd200),Data(LinearPredTsd200),'k.')
hold on
plot(Range(LinearTrueTsd200), Data(LinearTrueTsd200), 'r','linewidth',2)
subplot(2,1,2)
scatter(Range(LinearPredTsd200),Data(LinearPredTsd200),30,Data(LossPredTsd200),'filled')
hold on
plot(Range(LinearTrueTsd200), Data(LinearTrueTsd200), 'r','linewidth',2)

figure
plot(Data(LossPredTsd200),Data(LinearTrueTsd200)-Data(LinearPredTsd200), 'k.')

figure,
hold on,
subplot(1,3,1), 
hist(Data(LossPredTsd200),2000)
line([-4.5 -4.5],ylim,'color','r')
ylabel('Number of Predictions')
xlabel('Value of Predicted Loss')
xlim([-20 0])
subplot(1,3,2), 
ep = MovEpoch;
hold on;
tpos = Data(Restrict(LinearTrueTsd200,and(hab,ep)));
ppos = Data(Restrict(LinearPredTsd200,and(hab,ep)));
dLoss = Data(Restrict(LossPredTsd200,and(hab,ep)));
idBAD = find(dLoss>-4.5);
idGood = find(dLoss<-4.5);
plot(abs(tpos(idBAD)-ppos(idBAD)),dLoss(idBAD), '.', 'color', [0, 0.7, 0]);
plot(abs(tpos(idGood)-ppos(idGood)),dLoss(idGood), 'b.');
line(xlim,[-4.5 -4.5],'color','r');
ylabel('Value of the Predicted Loss');
xlabel('Value of the Error');
subplot(1,3,3), 
hold on;
plot(Range(Restrict(LinearTrueTsd200, hab),'s'), Data(Restrict(LinearTrueTsd200, hab)),'r','linewidth',2, 'DisplayName', 'True Position')
%     plot(Range(Restrict(LinearPredTsdtot, epoch),'s'), Data(Restrict(LinearPredTsdtot, epoch)),'k.','markersize',5)
plot(Range(Restrict(Restrict(LinearPredTsd200tot, hab), BadEpoch200),'s'), Data(Restrict(Restrict(LinearPredTsd200tot, hab), BadEpoch200)),'g.','markersize',15, 'DisplayName', 'Predictions with bad PL')
plot(Range(Restrict(Restrict(LinearPredTsd200tot, hab), EpochOK200),'s'), Data(Restrict(Restrict(LinearPredTsd200tot, hab), EpochOK200)),'b.','markersize',15, 'DisplayName', 'Predictions with good PL')
xlabel('Time(s)')
ylabel('Linearized Position')
legend('Location','best');



