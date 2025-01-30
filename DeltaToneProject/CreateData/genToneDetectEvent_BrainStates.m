
load StateEpochSB SWSEpoch
TONEtime1_SWS=Range(Restrict(ts(sort([TONEtime1])),SWSEpoch));
TONEtime2_SWS=Range(Restrict(ts(sort([TONEtime2])),SWSEpoch));
DeltaDetect_SWS=Range(Restrict(ts(sort([DeltaDetect])),SWSEpoch));
length(TONEtime1_SWS)
length(TONEtime2_SWS)
length(DeltaDetect_SWS)

load StateEpochSB REMEpoch
TONEtime1_REM=Range(Restrict(ts(sort([TONEtime1])),REMEpoch));
TONEtime2_REM=Range(Restrict(ts(sort([TONEtime2])),REMEpoch));
DeltaDetect_REM=Range(Restrict(ts(sort([DeltaDetect])),REMEpoch));
length(TONEtime1_REM)
length(TONEtime2_REM)
length(DeltaDetect_REM)

load StateEpochSB Wake
TONEtime1_Wake=Range(Restrict(ts(sort([TONEtime1])),Wake));
TONEtime2_Wake=Range(Restrict(ts(sort([TONEtime2])),Wake));
DeltaDetect_Wake=Range(Restrict(ts(sort([DeltaDetect])),Wake));
length(TONEtime1_Wake)
length(TONEtime2_Wake)
length(DeltaDetect_Wake)

save DeltaSleepEvent -append  TONEtime1_SWS TONEtime2_SWS DeltaDetect_SWS 
save DeltaSleepEvent -append  TONEtime1_REM TONEtime2_REM DeltaDetect_REM 
save DeltaSleepEvent -append  TONEtime1_Wake TONEtime2_Wake DeltaDetect_Wake 