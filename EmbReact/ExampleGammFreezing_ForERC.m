clear ZoneEpoch
clf
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond2
Cond1 = load('behavResources_SB.mat');
CondSl1 = load('StateEpochSB.mat');
Speed = Cond1.Behav.MovAcctsd;
Gamma = CondSl1.smooth_ghi;
ZoneEpoch = Cond1.Behav.ZoneEpoch;
FreezeEpoch = Cond1.Behav.FreezeAccEpoch;
MaxTps = max(Range(Gamma));
StimEpoch = Cond1.TTLInfo.StimEpoch;

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond1
Cond1 = load('behavResources_SB.mat');
CondSl1 = load('StateEpochSB.mat');
Speed = tsd([Range(Speed);Range(Cond1.Behav.MovAcctsd)+MaxTps],[Data(Speed);Data(Cond1.Behav.MovAcctsd)]);
Gamma = tsd([Range(Gamma);Range(CondSl1.smooth_ghi)+MaxTps],[Data(Gamma);Data(CondSl1.smooth_ghi)]);
FreezeEpoch = intervalSet([Start(FreezeEpoch);Start(Cond1.Behav.FreezeAccEpoch)+MaxTps],...
    [Stop(FreezeEpoch);Stop(Cond1.Behav.FreezeAccEpoch)+MaxTps]);
for z = 1:5
ZoneEpoch{z} =intervalSet([Start(ZoneEpoch{z});Start(Cond1.Behav.ZoneEpoch{z})+MaxTps],...
    [Stop(ZoneEpoch{z});Stop(Cond1.Behav.ZoneEpoch{z})+MaxTps]);
end
FreezeEpoch = dropShortIntervals(FreezeEpoch,3*1E4);
StimEpoch = intervalSet([Start(StimEpoch);Start(Cond1.TTLInfo.StimEpoch)+MaxTps],...
    [Stop(StimEpoch);Stop(Cond1.TTLInfo.StimEpoch)+MaxTps]);

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170127/ProjectEmbReact_M508_20170127_BaselineSleep
load('StateEpochSB.mat');
figure
subplot(211)
plot(Range(Speed,'s'),runmean(Data(Speed),30),'k')
hold on
line([Start(FreezeEpoch,'s'),Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s'),Stop(FreezeEpoch,'s')]'*0 + 17E7,'color','g','linewidth',4)
Cols = {UMazeColors('Shock'),UMazeColors('Safe'),UMazeColors('Center'),UMazeColors('Safe'),UMazeColors('Safe')};
for z = 1:5
line([Start(ZoneEpoch{z},'s'),Stop(ZoneEpoch{z},'s')]',[Start(ZoneEpoch{z},'s'),Stop(ZoneEpoch{z},'s')]'*0 + 18E7,'color',Cols{z},'linewidth',4)
end
hold on
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+19E7,'r*')
ylim([0 2.3E8])
ylabel('Head Acceleration')
xlabel('Time(s)')
set(gca,'LineWidth',2,'FontSize',15)
box off
subplot(212)
plot(Range(Gamma,'s'),runmean(Data(Gamma),20),'k')
line([Start(FreezeEpoch,'s'),Stop(FreezeEpoch,'s')]',[Start(FreezeEpoch,'s'),Stop(FreezeEpoch,'s')]'*0 + 1000,'color','g','linewidth',4)
for z = 1:5
line([Start(ZoneEpoch{z},'s'),Stop(ZoneEpoch{z},'s')]',[Start(ZoneEpoch{z},'s'),Stop(ZoneEpoch{z},'s')]'*0 + 1050,'color',Cols{z},'linewidth',4)
end
hold on
plot(Start(StimEpoch,'s'),Start(StimEpoch,'s')*0+1080,'r*')
line(xlim,[1 1]*(240),'color','k')
ylabel('OB Gamma power')
xlabel('Time(s)')
set(gca,'LineWidth',2,'FontSize',15)
box off


clf
[Y,X] = hist(log(Data(smooth_ghi)),100);
bar(X,Y/sum(Y),'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
hold on
[Y,X] = hist(log(Data(Restrict(Gamma,FreezeEpoch))),100);
plot(X,0.3*Y/sum(Y),'b','linewidth',2)
TotEpoch = intervalSet(0,max(Range(Gamma)));
[Y,X] = hist(log(Data(Restrict(CondSl1.smooth_ghi,TotEpoch-FreezeEpoch))),100);
plot(X,0.3*Y/sum(Y),'R','linewidth',2)
line([1 1]*log(gamma_thresh),ylim,'color','k')
legend('Sleep/wake','Fz','Act')
box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('OB gamma power')
ylabel('Counts')



figure
clf
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond2
 load('behavResources_SB.mat');
 plot(Data(Behav.AlignedXtsd),Data(Behav.AlignedYtsd),'color',[0.6 0.6 0.6],'linewidth',2)
hold on
plot(Data(Restrict(Behav.AlignedXtsd,Behav.FreezeAccEpoch)),Data(Restrict(Behav.AlignedYtsd,Behav.FreezeAccEpoch)),'.g','MarkerSize',40)
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170203/ProjectEmbReact_M508_20170203_UMazeCond/Cond1
 load('behavResources_SB.mat');
 TotEpoch = intervalSet(0,350*1E4);
 Behav.AlignedXtsd = Restrict(Behav.AlignedXtsd,TotEpoch);
  Behav.AlignedYtsd = Restrict(Behav.AlignedYtsd,TotEpoch);

 plot(Data(Behav.AlignedXtsd),Data(Behav.AlignedYtsd),'color',[0.6 0.6 0.6],'linewidth',2)
hold on
plot(Data(Restrict(Behav.AlignedXtsd,Behav.FreezeAccEpoch)),Data(Restrict(Behav.AlignedYtsd,Behav.FreezeAccEpoch)),'.g','MarkerSize',30)

















