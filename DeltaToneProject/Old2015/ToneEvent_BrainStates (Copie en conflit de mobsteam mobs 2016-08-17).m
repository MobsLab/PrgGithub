
load StateEpochSB SWSEpoch
ToneSWS=Range(Restrict(ts(sort([Tone])),SWSEpoch));
length(ToneSWS)

load StateEpochSB REMEpoch
ToneREM=Range(Restrict(ts(sort([Tone])),REMEpoch));
length(ToneREM)

load StateEpochSB Wake
ToneWake=Range(Restrict(ts(sort([Tone])),Wake));
length(ToneWake)

save ToneEvent -append  ToneWake ToneREM ToneSWS