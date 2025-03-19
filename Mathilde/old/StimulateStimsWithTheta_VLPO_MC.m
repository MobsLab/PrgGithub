function StimulateStimsWithTheta_VLPO_MC

load('SleepScoring_OBGamma.mat','Wake','SmoothTheta','Info','REMEpoch','SWSEpoch')

% threshold all data with the REM theta threhsold
HighThetaEpoch = thresholdIntervals(SmoothTheta,Info.theta_thresh,'Direction','Above');
% Define wake period with high theta power
HighThetaWake = and(Wake,HighThetaEpoch);
% get rid of events that are too short
HighThetaWake = dropShortIntervals(HighThetaWake,Info.theta_thresh*1e4);

save('SleepScoring_OBGamma.mat','HighThetaWake','-append')

% delay between stims
DeltaStim = 10; % 10 seconds between stims
StimDur = 30; % stim last 30s

REMEpoch_Long =  dropShortIntervals(REMEpoch,DeltaStim*1e4);
SWSEpoch_Long =  dropShortIntervals(SWSEpoch,DeltaStim*1e4);
HighThetaWake_Long =  dropShortIntervals(HighThetaWake,DeltaStim*1e4);

RemStim = [];
for k = 1 : length(Start(REMEpoch_Long))
    
    start_ep = Start(subset(REMEpoch_Long,k));
    stop_ep = Stop(subset(REMEpoch_Long,k));
    
    NumStims_ep = ceil(((stop_ep-start_ep)/1e4)/(DeltaStim+StimDur));
    
    for c = 1:NumStims_ep
        RemStim = [RemStim,start_ep+DeltaStim*1e4*c+StimDur*1e4*(c-1)];
    end
    
end

SwsStim = [];
for k = 1 : length(Start(SWSEpoch_Long))
    
    start_ep = Start(subset(SWSEpoch_Long,k));
    stop_ep = Stop(subset(SWSEpoch_Long,k));
    
    NumStims_ep = ceil(((stop_ep-start_ep)/1e4)/(DeltaStim+StimDur));
    
    for c = 1:NumStims_ep
        SwsStim = [SwsStim,start_ep+DeltaStim*1e4*c+StimDur*1e4*(c-1)];
    end
    
end

WakeStim = [];
for k = 1 : length(Start(HighThetaWake_Long))
    
    start_ep = Start(subset(HighThetaWake_Long,k));
    stop_ep = Stop(subset(HighThetaWake_Long,k));
    
    NumStims_ep = ceil(((stop_ep-start_ep)/1e4)/(DeltaStim+StimDur));
    
    for c = 1:NumStims_ep
        WakeStim = [WakeStim,start_ep+DeltaStim*1e4*c+StimDur*1e4*(c-1)];
    end
    
end

WakeStim = ts(WakeStim);
RemStim = ts(RemStim);
SwsStim = ts(SwsStim);

save('SimulatedStims.mat','WakeStim','RemStim','SwsStim')

end