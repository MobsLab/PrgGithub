function PercREM=FindPercREM(REMEpoch,SWSEpoch,Epoch)

REM=and(REMEpoch,Epoch);
SWS=and(SWSEpoch,Epoch);

REMdur=sum(End(REM,'s')-Start(REM,'s'));
SWSdur=sum(End(SWS,'s')-Start(SWS,'s'));

if (REMdur+SWSdur)>0
PercREM=REMdur/(REMdur+SWSdur)*100;
else
    PercREM = 0;
end


 