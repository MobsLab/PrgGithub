function FileNames=GetAllMouseTaskSessions_MFB(MouseNum)

SessNames={'Habituation' 'SleepPre_PreDrug' 'TestPre_PreDrug' 'UMazeCondExplo_PostDrug' 'TestPost_PostDrug' 'SleepPost_PostDrug'};

a=1;
for ss=1:length(SessNames)
    disp(SessNames{ss})
    Dir=PathForExperiments_MFB_Maze_BM(SessNames{ss});
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

