function DurBetweenRemEnd = GetIntervalDurBetweenRem_MC

load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEpoch =  mergeCloseIntervals(WakeWiNoise,1E4);

REMend=Stop(REMEpoch);

DurBetweenRemEnd = [];
for i=2:length(REMend)
    DurBetweenRemEnd=[DurBetweenRemEnd;REMend(i)-REMend(i-1)];
end

DurBetweenRemEnd = DurBetweenRemEnd(find(DurBetweenRemEnd>0));

end