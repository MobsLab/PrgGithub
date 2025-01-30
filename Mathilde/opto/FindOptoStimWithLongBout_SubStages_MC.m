function StimWithLongBout = FindOptoStimWithLongBout_SubStages_MC(N1,N2,N3,REMEpoch,Wake,state, BoutDurationBeforeStim)

% INPUT
% state : state during which stimulations occured ('rem', 'sws' or 'wake)
% BoutDurBeforeStim : minimal duration before stim onset / to select the
% stimulations that occured after a given duration after the bout onset

% OUTPUT
% times of the stims onset

REMBegin = Start(REMEpoch);
N1Begin = Start(N1);
N2Begin = Start(N2);
N3Begin = Start(N3);
WakeBegin = Start(Wake);

[Stim, StimREM, StimN1, StimN2, StimN3, StimWake, Stimts] = FindOptoStim_SubStages_MC(N1,N2,N3,REMEpoch,Wake);
StimWithLongBout=[];
StimDur= [];
if strcmp(lower(state),'wake')
    ii=1;
    for i=1:length(StimWake)
        idx = find(WakeBegin<StimWake(i),1,'last');
        StimDur(i) = StimWake(i)-WakeBegin(idx);
    end
    StimWithLongBout = StimWake(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'n1')
    ii=1;
    for i=1:length(StimN1)
        idx = find(N1Begin<StimN1(i),1,'last');
        StimDur(i) = StimN1(i)-N1Begin(idx);
    end
    StimWithLongBout = StimN1(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'n2')
    ii=1;
    for i=1:length(StimN2)
        idx = find(N2Begin<StimN2(i),1,'last');
        StimDur(i) = StimN2(i)-N2Begin(idx);
    end
    StimWithLongBout = StimN2(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'n3')
    ii=1;
    for i=1:length(StimN3)
        idx = find(N3Begin<StimN3(i),1,'last');
        StimDur(i) = StimN3(i)-N3Begin(idx);
    end
    StimWithLongBout = StimN3(StimDur>BoutDurationBeforeStim*1E4);
    
elseif strcmp(lower(state),'rem')
    ii=1;
    for i=1:length(StimREM)
        idx = find(REMBegin<StimREM(i),1,'last');
        StimDur(i) = StimREM(i)-REMBegin(idx);
    end
    StimWithLongBout = StimREM(StimDur>BoutDurationBeforeStim*1E4);
    
    
end