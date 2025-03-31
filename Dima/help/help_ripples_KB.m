
cd /media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond3/
load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond3/LFPData/LFP29.mat')
LFPf=FilterLFP(LFP,[120 200],1048);
LFPr=LFP;
load('/media/DataMOBsRAIDN/ProjetERC2/Mouse-711/17032018/Cond/Cond3/LFPData/LFP13.mat')
LFPn=LFP;
LFPfn=FilterLFP(LFPn,[120 200],1048);


StimEpoch=thresholdIntervals(LFPr,5000,'Direction','Above');
Epoch=intervalSet(Start(StimEpoch)-1E4,End(StimEpoch)+2E4);
rg=Range(LFPr);
TotalEpoch=intervalSet(rg(1),rg(end));
Epoch=mergeCloseIntervals(Epoch,1);
stdev=std(Data(Restrict(LFPf,TotalEpoch-Epoch)));
stdev=stdev*stdev;

[ripples,stdev2,noise] = FindRipples([Range(LFPf,'s') Data(LFPf)],'thresholds',[2 7],'durations',[30 30 150],'stdev',stdev,'noise',[Range(LFPfn,'s') Data(LFPfn)]);
[maps,data,stats] = RippleStats([Range(LFPf,'s') Data(LFPf)],ripples);
PlotRippleStats(ripples,maps,data,stats)


figure, plot(Range(LFPr,'s'),Data(LFPr),'k'), hold on, plot(Range(LFPf,'s'),Data(LFPf)+2000,'r','linewidth',2)
hold on, plot(ripples(:,2),0,'bo','markerfacecolor','b')
hold on, plot(ripples(:,3),0,'ko','markerfacecolor','r')
hold on, plot(ripples(:,1),0,'ko','markerfacecolor','g')

hold on, line([rg(1),rg(end)]/1E4,[stdev stdev]*2+2000,'color','b')
hold on, line([rg(1),rg(end)]/1E4,[stdev stdev]*7+2000,'color','b')
%a=300;
%a=a+1; xlim([ a a+1]),ylim([-4000 5000])
i=1;
i=i+1; xlim([ripples(i,1)-0.5 ripples(i,3)+0.5]),ylim([-5000 5000])


figure, plot(ripples(:,2),ripples(:,4),'o-')
hold on, plot(Start(StimEpoch,'s'),10,'ro','markerfacecolor','r')
hold on, plot(ripples(:,2),[1:length(ripples)],'ko-')


PlotRipRaw(LFPr, ripples, [-60 60], 1, 1);
PlotRipRaw(LFPf, ripples, [-60 60], 1, 1);
PlotRipRaw(LFPn, ripples, [-60 60], 1, 1);
PlotRipRaw(LFPn, ripples, [-600 600], 1, 1);

