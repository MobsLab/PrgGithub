function PercSleep=FindPercSleep(WakeEpoch,REMEpoch,SWSEpoch,Epoch)

REM=and(REMEpoch,Epoch);
SWS=and(SWSEpoch,Epoch);
Wake=and(WakeEpoch,Epoch);

REMdur=sum(End(REM,'s')-Start(REM,'s'));
SWSdur=sum(End(SWS,'s')-Start(SWS,'s'));
Wakedur=sum(End(Wake,'s')-Start(Wake,'s'));

if (REMdur+SWSdur+Wakedur)>0
    PercSleep=(REMdur+SWSdur)/(REMdur+SWSdur+Wakedur)*100;
else
    PercSleep = 0;
end