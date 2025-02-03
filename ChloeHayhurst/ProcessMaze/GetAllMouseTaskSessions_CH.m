function FileNames=GetAllMouseTaskSessions_CH(MouseNum,MouseOnDrugs)

if ~exist('MouseOnDrugs')
    
    SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
        'TestPre_PreDrug' 'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' ...
        'SleepPost_PreDrug' 'TestPost_PreDrug' 'ExtinctionBlockedShock_PreDrug' 'ExtinctionBlockedSafe_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
        'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
    
elseif MouseOnDrugs==0
    SessNames={'EPM' 'Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' ...
        'TestPost' 'Extinction' 'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest',...
        'HabituationNight' 'SleepPreNight' 'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight',...
        'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'HabituationBlockedSafe_EyeShock' 'HabituationBlockedShock_EyeShock',...
        'SleepPre_EyeShock' 'TestPre_EyeShock' 'UMazeCond_EyeShock' 'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' 'SleepPost_EyeShock',...
        'TestPost_EyeShock' 'Extinction_EyeShock' 'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};
    
elseif MouseOnDrugs ==1
%     SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
%         'TestPre_PreDrug' 'UMazeCondExplo_PreDrug'  'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
%         'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
%         'SleepPost_PostDrug' 'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' 'Extinction_PostDrug'};
end
a=1;
for ss=1:length(SessNames)
    disp(SessNames{ss})
    if MouseNum >= 1685
    Dir=PathForExperimentsEmbReact_CH(SessNames{ss});
    else
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    end
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse==MouseNum
                FileNames{a}=Dir.path{d}{dd};
                a=a+1;
            end
        end
    end
end

end
