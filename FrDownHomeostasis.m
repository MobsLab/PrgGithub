%FrDownHomeostasis

% 
% limSizDown=70;
% [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,0,[0 limSizDown],1);
load DownSpk
load StateEpochSB SWSEpoch Wake REMEpoch

[M,T]=PlotRipRaw(Qt,Start(Down,'s'),800);close
[M2,T2]=PlotRipRaw(Qt,End(Down,'s'),800);close

nb=30;
FrAft=tsd(Start(Down),mean(T2(:,80:80+nb),2));
FrBef=tsd(Start(Down),mean(T(:,77-nb:77),2));


figure('color',[1 1 1]),
subplot(3,1,1), hold on, 
plot(Range(FrBef,'s'),Data(FrBef),'k')
plot(Range(Restrict(FrBef,SWSEpoch),'s'),Data(Restrict(FrBef,SWSEpoch)),'r')
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[median(Data(FrBef)) median(Data(FrBef))],'color',[0.7 0.7 0.7])
ylabel('FR before (Hz)')

subplot(3,1,2), hold on, 
plot(Range(FrAft,'s'),Data(FrAft),'k')
plot(Range(Restrict(FrAft,SWSEpoch),'s'),Data(Restrict(FrAft,SWSEpoch)),'r')
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[median(Data(FrAft)) median(Data(FrAft))],'color',[0.7 0.7 0.7])
ylabel('FR after (Hz)')

subplot(3,1,3), hold on, 
plot(Range(FrAft,'s'),Data(FrAft)-Data(FrBef),'k')
plot(Range(Restrict(FrAft,SWSEpoch),'s'),Data(Restrict(FrAft,SWSEpoch))-Data(Restrict(FrBef,SWSEpoch)),'r')
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
ylabel('Diff Fr (Hz)')



for i=1:length(Start(SWSEpoch))
    nbDown(i)=length(Start(and(Down,subset(SWSEpoch,i))));
    FrDown(i)=length(Start(and(Down,subset(SWSEpoch,i))))/(End(subset(SWSEpoch,i),'s')-Start(subset(SWSEpoch,i),'s'));    
    FrSWS(i)=mean(Data(Restrict(Qt,subset(SWSEpoch,i))));
    FrBefSWS(i)=mean(Data(Restrict(FrBef,subset(SWSEpoch,i))));
    FrAftSWS(i)=mean(Data(Restrict(FrAft,subset(SWSEpoch,i))));
end

for i=1:length(Start(REMEpoch))
    FrREM(i)=mean(Data(Restrict(Qt,subset(REMEpoch,i))));
    FrBefREM(i)=mean(Data(Restrict(FrBef,subset(REMEpoch,i))));
    FrAftREM(i)=mean(Data(Restrict(FrAft,subset(REMEpoch,i))));
end

for i=1:length(Start(Wake))
    FrWake(i)=mean(Data(Restrict(Qt,subset(Wake,i))));
    FrBefWake(i)=mean(Data(Restrict(FrBef,subset(Wake,i))));
    FrAftWake(i)=mean(Data(Restrict(FrAft,subset(Wake,i))));
end


figure('color',[1 1 1]), 
subplot(4,1,1), hold on
plot(Start(SWSEpoch,'s'),nbDown/max(nbDown)*max(FrDown),'co-','markerfacecolor','c','markersize',4)
plot(Start(SWSEpoch,'s'),FrDown,'ko-','markerfacecolor','k','markersize',4)
ylabel('Occ Down (per sec)')
subplot(4,1,2), hold on
plot(Start(SWSEpoch,'s'),FrSWS,'ko-','markerfacecolor','k','markersize',4)
plot(Start(SWSEpoch,'s'),FrBefSWS,'bo-','markerfacecolor','b','markersize',4)
plot(Start(SWSEpoch,'s'),FrAftSWS,'ro-','markerfacecolor','r','markersize',4)
ylabel('Fr SWS (Hz)')
subplot(4,1,3), hold on
plot(Start(REMEpoch,'s'),FrREM,'ko-','markerfacecolor','k','markersize',4)
plot(Start(REMEpoch,'s'),FrBefREM,'bo-','markerfacecolor','b','markersize',4)
plot(Start(REMEpoch,'s'),FrAftREM,'ro-','markerfacecolor','r','markersize',4)
ylabel('Fr REM (Hz)')
subplot(4,1,4), hold on
plot(Start(Wake,'s'),FrWake,'ko-','markerfacecolor','k','markersize',4)
plot(Start(Wake,'s'),FrBefWake,'bo-','markerfacecolor','b','markersize',4)
plot(Start(Wake,'s'),FrAftWake,'ro-','markerfacecolor','r','markersize',4)
ylabel('Fr Wake (Hz)')




figure('color',[1 1 1]), 
subplot(4,1,1), hold on
plot(Start(SWSEpoch,'s'),nbDown/max(nbDown)*max(FrDown),'co-','markerfacecolor','c','markersize',2)
plot(Start(SWSEpoch,'s'),FrDown,'ko-','markerfacecolor','k','markersize',2)
ylabel('Occ Down (per sec)')
subplot(4,1,2), hold on
plot(Start(SWSEpoch,'s'),FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',2)
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
ylabel('Diff Fr SWS (Hz)')
subplot(4,1,3), hold on
plot(Start(REMEpoch,'s'),FrAftREM-FrBefREM,'ko','markerfacecolor','k','markersize',2)
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])
ylabel('Diff Fr REM (Hz)')
subplot(4,1,4), hold on
plot(Start(Wake,'s'),FrAftWake-FrBefWake,'ko','markerfacecolor','k','markersize',2)
ylabel('Diff Fr Wake (Hz)')
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])





stt=Start(SWSEpoch,'s');
enn=End(SWSEpoch,'s');

figure('color',[1 1 1])
subplot(2,3,1), plot(diff(Start(SWSEpoch,'s')),nbDown(2:end),'k.')
set(gca,'xscale','log')
subplot(2,3,2), plot(diff(Start(SWSEpoch,'s')),nbDown(1:end-1),'k.')
set(gca,'xscale','log')
subplot(2,3,3), plot(stt(2:end)-enn(1:end-1),nbDown(1:end-1),'k.')
set(gca,'xscale','log')
subplot(2,3,4), plot(diff(Start(SWSEpoch,'s')),FrDown(2:end),'k.')
set(gca,'xscale','log')
subplot(2,3,5), plot(diff(Start(SWSEpoch,'s')),FrDown(1:end-1),'k.')
set(gca,'xscale','log')
subplot(2,3,6), plot(stt(2:end)-enn(1:end-1),FrDown(1:end-1),'k.')
set(gca,'xscale','log')


figure('color',[1 1 1]), 
subplot(1,2,1), hold on, plot(nbDown,FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',4)
set(gca,'xscale','log')
xl=xlim;
xlim([1 xl(2)])
line([1 xl(2)],[0 0],'color',[0.7 0.7 0.7])

subplot(1,2,2), hold on, plot(FrDown,FrAftSWS-FrBefSWS,'ko','markerfacecolor','k','markersize',4)
xl=xlim;
xlim([0 xl(2)])
line([0 xl(2)],[0 0],'color',[0.7 0.7 0.7])

