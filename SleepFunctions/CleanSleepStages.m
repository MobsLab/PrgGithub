function [SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=CleanSleepStages(lim)

%
%[SleepStagesC, SWSEpochC, REMEpochC, WakeC, NoiseC, TotalNoiseEpoch]=CleanSleepStages(lim)
%

try
    lim;
catch
    lim=15;
end

try
    load StateEpochSB Wake SWSEpoch REMEpoch
catch
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
end




try
    load SleepScoring_OBGamma TotalNoiseEpoch GndNoiseEpoch NoiseEpoch ThresholdedNoiseEpoch WeirdNoiseEpoch
catch
    load StateEpochSB TotalNoiseEpoch GndNoiseEpoch NoiseEpoch ThresholdedNoiseEpoch WeirdNoiseEpoch
end


try
    TotalNoiseEpoch;
catch
    try
    TotalNoiseEpoch=or(GndNoiseEpoch,NoiseEpoch);
    end
    try
        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),ThresholdedNoiseEpoch);
    end
    try
        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
    end
    try
        TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),or(ThresholdedNoiseEpoch,WeirdNoiseEpoch));
    end
end

SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);

TotalNoiseEpoch=or(TotalNoiseEpoch,thresholdIntervals(SleepStages,-0.5,'Direction','Below'));
TotalNoiseEpoch=mergeCloseIntervals(TotalNoiseEpoch,1);







[REMEpochC,WakeC,idbad]=CleanREMEpoch(SleepStages);
SleepStagesC=PlotSleepStage(WakeC,SWSEpoch,REMEpochC);close

[WakeC2,TotalNoiseEpochC,Dur]=CleanWakeNoise(SleepStagesC);
SleepStagesC2=PlotSleepStage(WakeC2,SWSEpoch,REMEpochC);close

[SWSEpochC3,REMEpochC3,WakeC3]=CleanSWSREM(SleepStagesC2,SWSEpoch,REMEpochC,WakeC2,lim);

SleepStagesC3=PlotSleepStage(WakeC3,SWSEpochC3,REMEpochC3,0);



NoiseC=TotalNoiseEpochC;

SleepStagesC=SleepStagesC3;
SWSEpochC=SWSEpochC3;
REMEpochC=REMEpochC3;
WakeC=WakeC3;

