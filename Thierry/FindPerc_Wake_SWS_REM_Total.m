function [PercWake,PercSWS,PercREM]=FindPerc_Wake_SWS_REM_Total(WakeEpoch, SWSEpoch,REMEpoch,Epoch)

REM=and(REMEpoch,Epoch);
SWS=and(SWSEpoch,Epoch);
Wake=and(WakeEpoch,Epoch);

REMdur=sum(End(REM,'s')-Start(REM,'s'));
SWSdur=sum(End(SWS,'s')-Start(SWS,'s'));
Wakedur=sum(End(Wake,'s')-Start(Wake,'s'));

if (REMdur+SWSdur+Wakedur)>0
    PercWake=Wakedur/(REMdur+SWSdur+Wakedur)*100;
    PercREM=REMdur/(REMdur+SWSdur+Wakedur)*100;    
    PercSWS=SWSdur/(REMdur+SWSdur+Wakedur)*100;
else
    PercREM = 0;
    PercSWS = 0;
    PercWake = 0;
end