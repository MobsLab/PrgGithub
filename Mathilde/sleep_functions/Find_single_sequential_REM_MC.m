
function [Seq_REMEpoch,Single_REMEpoch] = Find_single_sequential_REM_MC(Wake,SWSEpoch,REMEpoch,param)

REMEpoch = mergeCloseIntervals(REMEpoch, 1E4);

if strcmp(lower(param),'after')
    [aft_cell, bef_cell] = transEpoch(or(Wake, SWSEpoch), REMEpoch);
    idx = ((Stop(aft_cell{1,2}) - Start(aft_cell{1,2}))/60e4)<2.5; % less than 3 minutes between REM episodes
    REM_Start_After_Other = Start(bef_cell{2,1});
    REM_Stop_After_Other = Stop(bef_cell{2,1});
    
    Seq_REMEpoch = intervalSet(REM_Start_After_Other(idx) , REM_Stop_After_Other(idx));
    Single_REMEpoch = intervalSet(REM_Start_After_Other(~idx) , REM_Stop_After_Other(~idx));
    
elseif strcmp(lower(param),'before')
    [aft_cell, bef_cell] = transEpoch(REMEpoch, or(Wake, SWSEpoch));
    idx = ((Stop(bef_cell{2,1}) - Start(bef_cell{2,1}))/60e4)<2.5; % less than 3 minutes between REM episodes
    REM_Start_Before_Other = Start(aft_cell{1,2});
    REM_Stop_Before_Other = Stop(aft_cell{1,2});
    
    Seq_REMEpoch = intervalSet(REM_Start_Before_Other(idx), REM_Stop_Before_Other(idx));
    Single_REMEpoch = intervalSet(REM_Start_Before_Other(~idx), REM_Stop_Before_Other(~idx));
end
end

