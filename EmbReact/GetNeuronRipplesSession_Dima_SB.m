clear all

% Mice with neurons and ripples
DimaMice = [490,507,508,509,514];

% PreSleep
Dir_temp = PathForExperimentsEmbReact('SleepPreUMaze');
n=1;
for mm = 1:length(Dir_temp.ExpeInfo)
    if ismember(Dir_temp.ExpeInfo{mm}{1}.nmouse,DimaMice)
        Dir_SleepPre.path{n} = Dir_temp.path{mm};
        Dir_SleepPre.ExpeInfo{n} = Dir_temp.ExpeInfo{mm};
        n=n+1;
    end
end


% Cond
Dir_temp = PathForExperimentsEmbReact('UMazeCond');
n=1;
for mm = 1:length(Dir_temp.ExpeInfo)
    if ismember(Dir_temp.ExpeInfo{mm}{1}.nmouse,DimaMice)
        Dir_Cond.path{n} = Dir_temp.path{mm};
        Dir_Cond.ExpeInfo{n} = Dir_temp.ExpeInfo{mm};
        n=n+1;
    end
end


% PreSleep
Dir_temp = PathForExperimentsEmbReact('SleepPostUMaze');
n=1;
for mm = 1:length(Dir_temp.ExpeInfo)
    if ismember(Dir_temp.ExpeInfo{mm}{1}.nmouse,DimaMice)
        Dir_SleepPost.path{n} = Dir_temp.path{mm};
        Dir_SleepPost.ExpeInfo{n} = Dir_temp.ExpeInfo{mm};
        n=n+1;
    end
end
