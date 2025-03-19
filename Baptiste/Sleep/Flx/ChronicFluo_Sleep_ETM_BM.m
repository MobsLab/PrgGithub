


GetSleepSessions_ChronicFluo_BM

for mouse=1:3
    for sess=1:length(SleepInfo.path{mouse})
        
        load([SleepInfo.path{mouse}{sess} '/SleepScoring_OBGamma.mat'],'REMEpoch','Sleep','Wake','SWSEpoch','Epoch')
        
        REM_prop(mouse,sess) = sum(DurationEpoch(REMEpoch))/sum(DurationEpoch(Sleep));
        Sleep_prop(mouse,sess) = sum(DurationEpoch(Sleep))/sum(DurationEpoch(Epoch));
        
    end
end






