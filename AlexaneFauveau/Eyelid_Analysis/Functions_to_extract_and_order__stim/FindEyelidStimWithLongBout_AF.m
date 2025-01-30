function StimWithLongBout = FindEyelidStimWithLongBout_AF(Wake,Sleep,state,BoutDurationBeforeStim,ValueStim,system)
Wake;
Sleep;
ValueStim;
% Code based on FindOptoStimWithLongBout_MC by Mathilde

% INPUT
% state : state during which stimulations occured ('sleep' or 'wake')
% BoutDurBeforeStim :(in seconde) minimal duration before stim onset / to select the
% stimulations that occured after a given duration after the bout onset

% OUTPUT
% times of the stims onset


SleepBegin = Start(Sleep);
WakeBegin = Start(Wake);

[Stim, StimSleep, StimWake, Stimts] = FindEyelidStim_AF(Wake,Sleep,ValueStim,system);
StimWithLongBout=[];
StimDur= [];
if strcmp(lower(state),'wake')
    ii=1;
    for i=1:length(StimWake)
        idx = find(WakeBegin<StimWake(i),1,'last');
        StimDur(i) = StimWake(i)-WakeBegin(idx);
    end
    StimWithLongBout = StimWake(StimDur>BoutDurationBeforeStim);
    
elseif strcmp(lower(state),'sleep')
    ii=1;
    for i=1:length(StimSleep)
        idx = find(SleepBegin<StimSleep(i),1,'last');
        StimDur(i) = StimSleep(i)-SleepBegin(idx);
    end
    StimWithLongBout = StimSleep(StimDur>BoutDurationBeforeStim);
end



