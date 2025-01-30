function FileNames=GetBaselineSleepSessions_BM(MouseNum)

SessNames={'BaselineSleep'};

a=1;
for ss=1:length(SessNames)
    disp(SessNames{ss})
    Dir=PathForExperimentsEmbReact(SessNames{ss});
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

