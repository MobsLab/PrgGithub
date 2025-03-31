function [N]=GetNumberStagesOvertime_MC(Wake,SWSEpoch,REMEpoch,stage,tempbin)

tempbin=tempbin*1E4;

SleepStage=PlotSleepStage(Wake,SWSEpoch,REMEpoch);close

tps=Range(SleepStage);


if strcmp(lower(stage),'wake')
    h=hist(Start(Wake),0:tempbin:tps(end));
    
elseif strcmp(lower(stage),'sws')
    h=hist(Start(SWSEpoch),0:tempbin:tps(end));
    
elseif strcmp(lower(stage),'rem')
    h=hist(Start(REMEpoch),0:tempbin:tps(end));
end

N=tsd(0:tempbin:tps(end),h');




%%




