
%TransitionSleepStageSpikeRipples


load SpikeData

[S2,numNeurons,numtt]=GetSpikesFromStructure('PFCx',S);
S2=poolNeurons(S,numNeurons);

load StateEpochSB Wake SWSEpoch REMEpoch MicroSleep MicroWake

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);

 rg=Range(SleepStages);
 stg=Data(SleepStages);


idx=find(abs(diff(stg))>0);
TrWakeSWS=[];
TrSWSWake=[];
TrSWSREM=[];  
TrREMWake=[];
for i=1:length(idx)
    try
    if stg(idx(i)-2)==4&stg(idx(i)+2)==1
    TrWakeSWS=[TrWakeSWS;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==4
    TrSWSWake=[TrSWSWake;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==3
    TrSWSREM=[TrSWSREM;rg(idx(i))];
    end
    if stg(idx(i)-2)==3&stg(idx(i)+2)==4
    TrREMWake=[TrREMWake;rg(idx(i))];
    end
    end
end



b1=200;b2=500;

[C1,B1]=CrossCorr(TrWakeSWS(2:end-1),Range(S2),b1,b2);
[C2,B2]=CrossCorr(TrSWSWake(2:end-1),Range(S2),b1,b2);
[C3,B3]=CrossCorr(TrSWSREM,Range(S2),b1,b2);
[C4,B4]=CrossCorr(TrREMWake,Range(S2),b1,b2);
 
[CmS,BmS]=CrossCorr(Start(MicroSleep),Range(S2),b1,b2);
[CmW,BmW]=CrossCorr(Start(MicroWake),Range(S2),b1,b2);

[CS,BS]=CrossCorr(Start(SWSEpoch),Range(S2),b1,b2);
[CW,BW]=CrossCorr(Start(Wake),Range(S2),b1,b2);

figure('color',[1 1 1]), 
subplot(2,1,1),hold on,
plot(BmS/1e3,CmS,'k','linewidth',2)
plot(BS/1e3,CS,'b','linewidth',2)
subplot(2,1,2),hold on,
plot(BmW/1e3,CmW,'k','linewidth',2)
plot(BW/1e3,CW,'R','linewidth',2)


smo=10;
figure('color',[1 1 1]), 
subplot(3,1,1),hold on,
plot(B1/1e3,smooth(C1,smo),'k','linewidth',2)
plot(B2/1e3,smooth(C2,smo),'b','linewidth',2)
plot(B3/1e3,smooth(C3,smo),'r','linewidth',2)
plot(B4/1e3,smooth(C4,smo),'m','linewidth',2)
yl=ylim;
line([0 0],yl,'color','k')

subplot(3,1,2),hold on,
plot(B2/1e3,smooth(C2,smo),'b','linewidth',2)
plot(B4/1e3,smooth(C4,smo),'m','linewidth',2)
yl=ylim;
line([0 0],yl,'color','k')

subplot(3,1,3),hold on,
plot(B2/1e3,smooth(C2,smo),'b','linewidth',2)
plot(B3/1e3,smooth(C3,smo),'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color','k')




Sa=tsdArray(S2);
Qs=MakeQfromS(Sa,1000);

figure, ImagePETH(Qs,ts(TrWakeSWS(2:end-1)),-500000,500000,'BinSize',2000); title('Wake -> SWS')
figure, ImagePETH(Qs,ts(TrSWSWake(2:end-1)),-500000,500000,'BinSize',2000); title('SWS -> Wake')
figure, ImagePETH(Qs,ts(TrSWSREM),-500000,500000,'BinSize',2000); title('SWS -> REM')
figure, ImagePETH(Qs,ts(TrREMWake),-500000,500000,'BinSize',2000); title('REM -> Wake')

figure, ImagePETH(Qs,ts(Start(MicroSleep)),-500000,500000,'BinSize',2000); title('MicroSleep')
figure, ImagePETH(Qs,ts(Start(MicroWake)),-500000,500000,'BinSize',2000); title('MicroWake')


load('RipplesdHPC25.mat')

Rip=tsdArray(ts(dHPCrip(:,2)*1E4));
Qrip=MakeQfromS(Rip,20000);

figure, ImagePETH(Qrip,ts(TrWakeSWS(2:end-1)),-500000,500000,'BinSize',2000); title('Wake -> SWS')
figure, ImagePETH(Qrip,ts(TrSWSWake(2:end-1)),-500000,500000,'BinSize',2000); title('SWS -> Wake')
figure, ImagePETH(Qrip,ts(TrSWSREM),-500000,500000,'BinSize',2000); title('SWS -> REM')
figure, ImagePETH(Qrip,ts(TrREMWake),-500000,500000,'BinSize',2000); title('REM -> Wake')

figure, ImagePETH(Qrip,ts(Start(MicroSleep)),-500000,500000,'BinSize',2000); title('MicroSleep')
figure, ImagePETH(Qrip,ts(Start(MicroWake)),-500000,500000,'BinSize',2000); title('MicroWake')



load Mov


figure, ImagePETH(Mov,ts(TrWakeSWS(2:end-1)),-500000,500000,'BinSize',2000); title('Wake -> SWS')
figure, ImagePETH(Mov,ts(TrSWSWake(2:end-1)),-500000,500000,'BinSize',2000); title('SWS -> Wake')
figure, ImagePETH(Mov,ts(TrSWSREM),-500000,500000,'BinSize',2000); title('SWS -> REM')
figure, ImagePETH(Mov,ts(TrREMWake),-500000,500000,'BinSize',2000); title('REM -> Wake')

figure, ImagePETH(Mov,ts(Start(MicroSleep)),-500000,500000,'BinSize',2000); title('MicroSleep')
figure, ImagePETH(Mov,ts(Start(MicroWake)),-500000,500000,'BinSize',2000); title('MicroWake')

