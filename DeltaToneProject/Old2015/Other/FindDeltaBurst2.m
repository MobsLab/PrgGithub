function [BurstDeltaEpoch,NbD]=FindDeltaBurst2(Delta,limitTime,Correct)


NbD=[];
try
    Correct;
catch
    Correct=1;

end

try
    limitTime;
catch
    limitTime=0.6;
end


rg=Range(Delta,'s');

ISI=diff(rg);
idburst=find(ISI<limitTime);

deb=rg(idburst);
fin=rg(idburst+1);

BurstDeltaEpoch2=intervalSet((deb-0.2)*1E4,(fin+0.2)*1E4);
warning off
BurstDeltaEpoch=mergeCloseIntervals(BurstDeltaEpoch2,(limitTime+0.3)*1E4);
warning on
% BurstDeltaEpoch=and(BurstDeltaEpoch,BurstDeltaEpoch2);
% BurstDeltaEpoch=mergeCloseIntervals(BurstDeltaEpoch,(limitTime+0.1)*1E4);


if 1
    
    a=1;b=1;
    for k=1:length(Start(BurstDeltaEpoch))  
        NbD(a,1)=length(Range(Restrict(Delta,subset(BurstDeltaEpoch,k))));
        NbD(a,2)=End(subset(BurstDeltaEpoch,k),'s')-Start(subset(BurstDeltaEpoch,k),'s');
            a=a+1;

        NbD2(b,1)=length(Range(Restrict(Delta,subset(BurstDeltaEpoch,k))));
        NbD2(b,2)=End(subset(BurstDeltaEpoch,k),'s')-Start(subset(BurstDeltaEpoch,k),'s');
        if NbD2(b,1)>2
            idOK(b)=k;
            b=b+1;
        end
        
    end
    
end

if Correct
    
    BurstDeltaEpoch=subset(BurstDeltaEpoch,idOK);

end

