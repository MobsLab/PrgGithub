%FiringRateRemapping

cd /Users/karimbenchenane/Documents/Data/DataEnCours/MiceSetUp/ICSS/ICSS-Mouse-29-03022012

load StabPHBefAftStim
load behavResources
load SpikeData S cellnames

PlaceCellList=[3 5 9 14 18 20 34 40]


EpochA=intervalSet(tpsdeb{9}*1E4,tpsfin{10}*1E4);
EpochB=intervalSet(tpsdeb{1}*1E4,tpsfin{2}*1E4);

for i=1:length(PlaceCellList)
Fr(i,1)=length(Range(Restrict(S{PlaceCellList(i)},EpochB)))/(End(EpochB,'s')-Start(EpochB,'s'));       
Fr(i,2)=length(Range(Restrict(S{PlaceCellList(i)},EpochA)))/(End(EpochA,'s')-Start(EpochA,'s'));
end


figure('color',[1 1 1]), plot(ones(length(Fr(:,1)),1),Fr(:,1),'ko','markerfacecolor','k')
hold on, plot(2*ones(length(Fr(:,2)),1),Fr(:,2),'ko','markerfacecolor','k')
line([ones(length(Fr(:,1)),1) 2*ones(length(Fr(:,2)),1)]',[Fr(:,1) Fr(:,2)]','color','k')

xlim([0 3])
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'before','after'})
ylabel('Firing rate (Hz)')


[h,p]=ttest(Fr(:,1),Fr(:,2))
title(['n=7, p=',num2str(floor(p*100)/100)])



PlotErrorBar2(Fr(:,1),Fr(:,2))
title(['n=7, p=',num2str(floor(p*100)/100)])
ylabel('Firing rate (Hz)')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'before','after'})
ylim([0 3])
