function PercWake=FindPercWake(Wake,Epoch)

Wake=and(Wake,Epoch);
SWS=and(SWSEpoch,Epoch);
REM=and(REMEpoch,Epoch);

REMdur=sum(End(REM,'s')-Start(REM,'s'));
SWSdur=sum(End(SWS,'s')-Start(SWS,'s'));
Wakedur=sum(End(Wake,'s')-Start(Wake,'s'));

PercWake=Wakedur/(REMdur+SWSdur+Wakedur)*100;


 