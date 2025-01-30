function [SleepCycle,SleepCycle2,SleepCycle3]=FindSleepCycles_KB(Wake,SWSEpoch,REMEpoch,durMinREM)

try
    durMinREM;
catch
durMinREM=15;
end

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
[REMEpochC,WakeC,idbad]=CleanREMEpoch(SleepStages,REMEpoch,Wake);
SleepStagesC=PlotSleepStage(WakeC,SWSEpoch,REMEpochC);close
    
EnRem=End(REMEpochC);
SleepCycle=intervalSet(EnRem(1:end-1),EnRem(2:end));

for i=1:length(Start(SleepCycle))
clear DurWAkeSleepCy
    WakeCsc=and(WakeC,subset(SleepCycle,i));
    for j=1:length(Start(WakeCsc))
                if length(Start(subset(WakeCsc,j)))>0
                        DurWAkeSleepCy(j)=(End(subset(WakeCsc,j),'s')-Start(subset(WakeCsc,j),'s'));     
                else
                        DurWAkeSleepCy(j)=0;       
                end
    end   
    try
    [BEw(i),idWake]=max(DurWAkeSleepCy);
    catch
      BEw(i)=0;  
    end
    if BEw(i)>120
    stSlCy(i)=End(subset(WakeC,idWake));        
    enSlCy(i)=End(subset(SleepCycle,i));    
    else
    stSlCy(i)=Start(subset(SleepCycle,i));
    enSlCy(i)=End(subset(SleepCycle,i));    
    end
end

  
for i=1:length(Start(REMEpochC))
dur2(i)=End(subset(REMEpochC,i),'s')-Start(subset(REMEpochC,i),'s');
end

idREMOK=find(dur2>durMinREM);
EnRem2=End(subset(REMEpochC,idREMOK));
SleepCycle2=intervalSet(EnRem2(1:end-1),EnRem2(2:end));
idREMOKb=find(dur2>durMinREM*2);
EnRem3=End(subset(REMEpochC,idREMOKb));
SleepCycle3=intervalSet(EnRem3(1:end-1),EnRem3(2:end));




