clear all
SessNames={'SleepPreSound' 'SleepPreUMaze' 'SleepPostUMaze' 'SleepPostSound' 'SleepPreNight','SleepPostNight'};

close all
a=1;
MiceNumber=[404,425,431,436,437,438,439,445,470,471,483,484,485,490,507,508,509,510,512,514];
MiceNumber=438
for mm=1:length(MiceNumber)
    for ss=1:length(SessNames)
        Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
        disp(SessNames{ss})
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                if Dir.ExpeInfo{d}{dd}.nmouse==MiceNumber(mm)
                    FileNames{a}=Dir.path{d}{dd};
                    a=a+1;
                end
            end
        end
    end
    FileNames'
    keyboard
    MultiSessionSleecpScoringEmbReact(FileNames)
    clear FileNames
    a=1;
end