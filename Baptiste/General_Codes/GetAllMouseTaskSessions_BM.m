function FileNames=GetAllMouseTaskSessions(MouseNum)

SessNames={'Habituation24HPre_PreDrug' 'Habituation_PreDrug' 'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'SleepPre_PreDrug',...
    'TestPre_PreDrug' 'SleepPost_PreDrug' 'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug',...
     'TestPost_PostDrug'  'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

a=1;
for ss=1:length(SessNames)
    disp(SessNames{ss})
    Dir=PathForExperimentsEmbReact_BM(SessNames{ss});
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

