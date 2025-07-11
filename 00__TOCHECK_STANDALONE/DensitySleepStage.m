function [D,tpsFirstSleep,tpsFirstREM,SleepStage]=DensitySleepStage(Wake,SWSEpoch,REMEpoch,stage,tempbin)


% -
% [D,tpsFirstSleep,tpsFirstREM,SleepStage]=DensitySleepStage(Wake,SWSEpoch,REMEpoch,stage,tempbin);
%------------------------------------------------------------------------------------------------
%
% INPUTS
% stage= 'wake', 'sws' ou 'rem'
% tempbin = temporal bin en secondes
%
% OUTPUTS
% D denisty of the sleep stage
% tpsFirstSleep: temps du premier epidode de NREM de plus de 300 sec
% tpsFirstREM: temps du premier epidode de REM de plus de 15 sec
% SleepStage: hypnogram en tsd


SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

tempbin=tempbin*1E4;

if strcmp(lower(stage),'wake')
slstg=4;
elseif strcmp(lower(stage),'sws')
  slstg=1;  
elseif strcmp(lower(stage),'rem')
  slstg=3;  
end
tps=Range(SleepStage);
val=Data(SleepStage);
idx=find(val==slstg);
h=hist(tps(idx),0:tempbin:tps(end));
h2=hist(tps,0:tempbin:tps(end));
D=tsd(0:tempbin:tps(end),h'./h2'*100);

[durSWS,durTSWS]=DurationEpoch(SWSEpoch);
idxSWS=find(durSWS/1E4>300);
st=Start(SWSEpoch);
tpsFirstSleep=st(idxSWS(1))/1E4;
[durREM,durTREM]=DurationEpoch(REMEpoch);
idxREM=find(durREM/1E4>15);
st=Start(REMEpoch);
tpsFirstREM=st(idxREM(1))/1E4;




