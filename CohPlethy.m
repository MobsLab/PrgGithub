function [C,t,f,cS12,cS34,cREM,cWake,cWakeTheta,cWakeNonTheta,cSWS]=CohPlethy(LFP1,LFP2,S12,S34,REMEpoch,WakeEpoch,SleepStages,params,movingwin)

load StateEpoch ThetaEpoch SWSEpoch
rg=Range(LFP1);
Epoch=intervalSet(rg(1),rg(end));
LFP1=ResampleTSD(LFP1,250);
LFP2=ResampleTSD(LFP2,250);
params.Fs=250;
%params.fpass=[0 90];

[C,phi,S12c,S1,S2,t,f,confC,phistd]=cohgramc(Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Restrict(LFP1,Epoch))),movingwin,params);

%C(C<confC)=0;
figure('color',[1 1 1]), 
subplot(1,3,1:2),imagesc(t,f,SmoothDec(C,[2 1])'), axis xy, %xl=xlim; xlim([xl(1)+5 xl(2)-5]),colorbar%, ca=caxis; caxis([confC/2 ca(2)])
hold on, plot(Range(SleepStages,'s'),20+3*Data(SleepStages),'k')
hold on, plot(Range(SleepStages,'s'),20+3*Data(SleepStages),'k.')
hold on, plot(Range(Restrict(SleepStages,REMEpoch),'s'),20+3*Data(Restrict(SleepStages,REMEpoch)),'ro','markerfacecolor','r')
hold on, plot(Range(Restrict(SleepStages,S12),'s'),20+3*Data(Restrict(SleepStages,S12)),'bo','markerfacecolor','b')
hold on, plot(Range(Restrict(SleepStages,S34),'s'),20+3*Data(Restrict(SleepStages,S34)),'o','color',[0 0.4 0],'markerfacecolor','g')



Ctsd=tsd(t*1E4,C);
subplot(1,3,3), plot(f,mean(Data(Restrict(Ctsd,S12))),'linewidth',2)
hold on, plot(f,mean(Data(Restrict(Ctsd,S34))),'color',[0 0.4 0],'linewidth',2)
if sum(End(REMEpoch,'s')-Start(REMEpoch,'s'))<30
hold on, plot(f,mean(Data(Restrict(Ctsd,REMEpoch))),'r','linewidth',1)
else
hold on, plot(f,mean(Data(Restrict(Ctsd,REMEpoch))),'r','linewidth',2)
end
hold on, plot(f,mean(Data(Restrict(Ctsd,WakeEpoch))),'k','linewidth',2)
hold on,line([params.fpass(1) params.fpass(2)],[confC confC],'color',[0.5 0.5 0.5],'linestyle','--')


cS12=mean(Data(Restrict(Ctsd,S12)));
cS34=mean(Data(Restrict(Ctsd,S34)));
cREM=mean(Data(Restrict(Ctsd,REMEpoch)));
cWake=mean(Data(Restrict(Ctsd,WakeEpoch)));
cWakeTheta=mean(Data(Restrict(Ctsd,and(WakeEpoch,ThetaEpoch))));
cWakeNonTheta=mean(Data(Restrict(Ctsd,mergeCloseIntervals(WakeEpoch-ThetaEpoch,1))));
cSWS=mean(Data(Restrict(Ctsd,SWSEpoch)));

freq=[params.fpass(1):0.1:params.fpass(2)];

cS12=tsd(f,cS12');
cS12=Data(Restrict(cS12,freq));
cS34=tsd(f,cS34');
cS34=Data(Restrict(cS34,freq));
cREM=tsd(f,cREM');
cREM=Data(Restrict(cREM,freq));
cSWS=tsd(f,cSWS');
cSWS=Data(Restrict(cSWS,freq));

cWake=tsd(f,cWake');
cWake=Data(Restrict(cWake,freq));
cWakeTheta=tsd(f,cWakeTheta');
cWakeTheta=Data(Restrict(cWakeTheta,freq));
cWakeNonTheta=tsd(f,cWakeNonTheta');
cWakeNonTheta=Data(Restrict(cWakeNonTheta,freq));

