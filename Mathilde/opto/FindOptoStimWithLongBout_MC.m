function StimWithLongBout = FindOptoStimWithLongBout_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,state, BoutDurationBeforeStim)

% INPUT
% state : state during which stimulations occured ('rem', 'sws' or 'wake)
% BoutDurBeforeStim : minimal duration before stim onset / to select the
% stimulations that occured after a given duration after the bout onset

% OUTPUT
% times of the stims onset

REMBegin = Start(REMEpochWiNoise);
SWSBegin = Start(SWSEpochWiNoise);
WakeBegin = Start(WakeWiNoise);

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
StimWithLongBout=[];
StimDur= [];
if strcmp(lower(state),'wake')
    ii=1;
    for i=1:length(StimWake)
        idx = find(WakeBegin<StimWake(i),1,'last');
        StimDur(i) = StimWake(i)-WakeBegin(idx);
    end
    StimWithLongBout = StimWake(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'sws')
    ii=1;
    for i=1:length(StimSWS)
        idx = find(SWSBegin<StimSWS(i),1,'last');
        StimDur(i) = StimSWS(i)-SWSBegin(idx);
    end
    StimWithLongBout = StimSWS(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'rem')
    ii=1;
    for i=1:length(StimREM)
        idx = find(REMBegin<StimREM(i),1,'last');
        StimDur(i) = StimREM(i)-REMBegin(idx);
    end
    StimWithLongBout = StimREM(StimDur>BoutDurationBeforeStim*1E4);
    
    
end