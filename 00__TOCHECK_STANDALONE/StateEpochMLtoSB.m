function [Wake,SWSEpoch,REMEpoch]=StateEpochMLtoSB;

load StateEpoch

st=Start(MovEpoch);
if length(st)<2
    rg=Range(ThetaRatioTSD);
    TotalEpoch=intervalSet(rg(1),rg(end));
    MovEpoch=TotalEpoch-ImmobEpoch;
end

try
SWSEpoch=SWSEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
REMEpoch=REMEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
Wake=MovEpoch-GndNoiseEpoch-WeirdNoiseEpoch-NoiseEpoch;
catch
 SWSEpoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
REMEpoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
Wake=MovEpoch-GndNoiseEpoch-NoiseEpoch;   
    
end
