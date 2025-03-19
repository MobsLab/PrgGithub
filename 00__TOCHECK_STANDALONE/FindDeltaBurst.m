function [BurstDeltaEpoch,NbD]=FindDeltaBurst(Epoch,limitTime)

try
    limitTime;
catch
    limitTime=0.6;
end

if 1
    try
        
        load newDeltaPaCx
        Dpac=ts(tDelta);
        clear tDelta
        load newDeltaPFCx
        Dpfc=ts(tDelta);
    catch
        [Dpfc,P,usedEpoch]=FindDeltaWavesChan('PFCx',Epoch,[],0,1.2);
        [Dpac,P,usedEpoch]=FindDeltaWavesChan('PaCx',Epoch,[],0,1.2);
    end
else
    load DeltaPFCx
    Dpfc=tDeltaT2;
    clear tDeltaT2
    load DeltaPaCx
    Dpac=tDeltaT2;
end

try
    Epoch;
    Dpfc=Restrict(Dpfc,Epoch);
    Dpac=Restrict(Dpac,Epoch);
end

rg=Range(Dpfc,'s');
rg2=Range(Dpac,'s');
rg=[rg;rg2];

rg=sort(rg); 

ISI=diff(rg);
idburst=find(ISI<limitTime);

k=1;
for i=idburst'
    deb(k)=rg(i);
    fin(k)=rg(i+1);
    k=k+1;
end
BurstDeltaEpoch=intervalSet((deb-0.1)*1E4,(fin+0.1)*1E4);
BurstDeltaEpoch=mergeCloseIntervals(BurstDeltaEpoch,1E4);


j=1;
for i=1:length(Start(BurstDeltaEpoch))
    NbD(i,1)=length(Range(Restrict(Dpfc,subset(BurstDeltaEpoch,i))));
    NbD(i,2)=length(Range(Restrict(Dpac,subset(BurstDeltaEpoch,i))));
    NbD(i,3)=NbD(i,1)+NbD(i,2);
    NbD(i,4)=max(NbD(i,1),NbD(i,2));
    NbD(i,5)=End(subset(BurstDeltaEpoch,i),'s')-Start(subset(BurstDeltaEpoch,i),'s');
    if NbD(i,1)>1|NbD(i,2)>1
        idOK(j)=i;
        j=j+1;
    end
end
BurstDeltaEpoch=subset(BurstDeltaEpoch,idOK);
NbD=NbD(idOK,:);
