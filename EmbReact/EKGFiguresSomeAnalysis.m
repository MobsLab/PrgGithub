load('/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/LFPData/LFP14.mat')
FilLFP14=FilterLFP(LFP,[20 200],1024);

litEpoch=intervalSet(9400*1e4, 9500*1e4);
FilLFP14temp=Restrict(FilLFP14,litEpoch);
Ep=thresholdIntervals(FilLFP14temp,-400,'Direction','Below');
for k=1:length(Start(Ep))
    Dat=Data(Restrict(FilLFP14temp,subset(Ep,k)));
    Tps=Range(Restrict(FilLFP14temp,subset(Ep,k)));
    [val,ind]=min(Dat);
    ValR(k)= Tps(ind);
end
subplot(211)
plot(Range((FilLFP14temp),'s'),Data((FilLFP14temp)))
hold on
plot(ValR/1e4,500,'*')
xlim([9408 9410])
[MR,TR]=PlotRipRaw(FilLFP14,ValR'/1e4,8);
Template=MR(:,2);
Tps=Range(Restrict(FilLFP14,litEpoch),'s');
Sig=Data(Restrict(FilLFP14,litEpoch));
subplot(212)
ConvSig=conv(Sig,Template,'same').*conv(Sig,Template,'same');
plot(Tps,ConvSig)
xlim([9408 9410])
line([9400 9500],[0.5*1e12 0.5*1e12])
ConvSigtsd=tsd(Tps*1e4,ConvSig);
Ep=thresholdIntervals(ConvSigtsd,0.4*1e12,'Direction','Above');
Ep=mergeCloseIntervals(Ep,0.03*1e4);
clear ValR2
for k=1:length(Start(Ep))
    Dat=Data(Restrict(ConvSigtsd,subset(Ep,k)));
    Tps=Range(Restrict(ConvSigtsd,subset(Ep,k)));
    [val,ind]=min(Dat);
    ValR2(k)= Tps(ind);
end
plot(ValR2/1e4,500,'*')

i=1;
i=i+2;
subplot(211)
xlim([9408 9410]+i)
subplot(212)
xlim([9408 9410]+i)


figure
Ep=intervalSet(9400*1e4,9430*1e4);
plot(Range(Restrict(FilLFP14temp,Ep),'s'),Data(Restrict(FilLFP14temp,Ep))/2,'k')
hold on
load('/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/LFPData/LFP1.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/7.5-1000,'r')
load('/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/LFPData/LFP6.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/7.5-1200,'r')
load('/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/LFPData/LFP9.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/7.5-2000,'c')
load('/media/DataMOBsRAID/ProjectEmbReact/Mouse445/20160823/LFPData/LFP2.mat')
plot(Range(Restrict(LFP,Ep),'s'),Data(Restrict(LFP,Ep))/7.5-2800,'b')



load('StateEpochSB.mat')
SWSEpoch=dropShortIntervals(SWSEpoch,20*1e4);
clear HeartBeatTimesSWS
for k=1:10
    litEpoch=subset(SWSEpoch,k);
    Time=Range(Restrict(FilLFP14,litEpoch),'s');
    Sig=Data(Restrict(FilLFP14,litEpoch));
    ConvSig=conv(Sig,Template,'same').*conv(Sig,Template,'same');
    ConvSigtsd=tsd(Time*1e4,ConvSig);
    
    Ep=thresholdIntervals(ConvSigtsd,0.4*1e12,'Direction','Above');
    Ep=mergeCloseIntervals(Ep,0.03*1e4);
    for kk=1:length(Start(Ep))
        Dat=Data(Restrict(ConvSigtsd,subset(Ep,kk)));
        Tps=Range(Restrict(ConvSigtsd,subset(Ep,kk)));
        [val,ind]=max(Dat);
        HeartBeatTimesSWS{k}(kk)= Tps(ind);
    end
end

REMEpoch=dropShortIntervals(REMEpoch,5*1e4);
for k=1:20
    litEpoch=subset(REMEpoch,k);
    Time=Range(Restrict(FilLFP14,litEpoch),'s');
    Sig=Data(Restrict(FilLFP14,litEpoch));
    ConvSig=conv(Sig,Template,'same').*conv(Sig,Template,'same');
    ConvSigtsd=tsd(Time*1e4,ConvSig);
    
    Ep=thresholdIntervals(ConvSigtsd,0.4*1e12,'Direction','Above');
    Ep=mergeCloseIntervals(Ep,0.03*1e4);
    for kk=1:length(Start(Ep))
        Dat=Data(Restrict(ConvSigtsd,subset(Ep,kk)));
        Tps=Range(Restrict(ConvSigtsd,subset(Ep,kk)));
        [val,ind]=max(Dat);
        HeartBeatTimesREM{k}(kk)= Tps(ind);
    end
end

AllREM=[];
for k=1:20
AllREM=[AllREM,diff(HeartBeatTimesREM{k})/1e4];
end

AllSWS=[];
for k=1:10
AllSWS=[AllSWS,diff(HeartBeatTimesSWS{k})/1e4];
end
AllSWS(AllSWS>0.15)=[];
AllREM(AllREM>0.15)=[];

[Y,X]=hist(AllREM,50);
[Y2,X2]=hist(AllSWS,50);
clf
plot(X,Y/sum(Y))
hold on
plot(X2,Y2/sum(Y2))