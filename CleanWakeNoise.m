function [WakeC,TotalNoiseEpochC,Dur]=CleanWakeNoise(SleepStages,Wake)

try
    Wake;
catch
  
try
    load StateEpochSBKB Wake
catch
    try
    load StateEpochSB Wake 
catch
    load SleepScoring_OBGamma Wake
end
end
 
end


try
    load SleepScoring_OBGamma TotalNoiseEpoch GndNoiseEpoch NoiseEpoch ThresholdedNoiseEpoch WeirdNoiseEpoch
catch
    try
        load StateEpochSB TotalNoiseEpoch GndNoiseEpoch NoiseEpoch ThresholdedNoiseEpoch WeirdNoiseEpoch
    end
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

try
    TotalNoiseEpoch=or(TotalNoiseEpoch,thresholdIntervals(SleepStages,-0.5,'Direction','Below'));
catch
    TotalNoiseEpoch=thresholdIntervals(SleepStages,-0.5,'Direction','Below');
end
TotalNoiseEpoch=mergeCloseIntervals(TotalNoiseEpoch,1);


for i=1:length(Start(TotalNoiseEpoch))
    testEpoch1=subset(TotalNoiseEpoch,i);
    testEpoch2=intervalSet(Start(testEpoch1)-1E4,Start(testEpoch1)-2);
    SleepStageTemp2=Data(Restrict(SleepStages,testEpoch2));
    testEpoch3=intervalSet(End(testEpoch1)+2,End(testEpoch1)+1E4);
    SleepStageTemp3=Data(Restrict(SleepStages,testEpoch3));   
    try
        if SleepStageTemp2(end-1)==4&SleepStageTemp3(1)==4
            idbad(i)=1;
        else
            idbad(i)=0;
        end 
    catch
        idbad(i)=0;
    end
end
try
TotalNoiseEpochC=subset(TotalNoiseEpoch,find(idbad==0));
WakeC=or(Wake,subset(TotalNoiseEpoch,find(idbad==1)));

Dur(1)=sum(End(subset(TotalNoiseEpoch,find(idbad==1)),'s')-Start(subset(TotalNoiseEpoch,find(idbad==1)),'s'));
Dur(2)=mean(End(subset(TotalNoiseEpoch,find(idbad==1)),'s')-Start(subset(TotalNoiseEpoch,find(idbad==1)),'s'));
catch
   TotalNoiseEpochC=TotalNoiseEpoch;
   WakeC=Wake;
    Dur=[];
end


try
disp('******************************')
disp(['Number of Bad Noise epochs: ',num2str(length(find(idbad==1)))])
disp('******************************')
end
