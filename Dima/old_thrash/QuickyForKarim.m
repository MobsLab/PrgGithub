%%% QuickyForKarim

DirPAGHab = PathForExperimentsPAGTest_Dima('Hab');
DirPAGHab = RestrictPathForExperiment(DirPAGHab,'nMice', [787 788]);
DirPAGPre = PathForExperimentsPAGTest_Dima('TestPre');
DirPAGPre = RestrictPathForExperiment(DirPAGPre,'nMice', [787 788]);
DirPAGCond = PathForExperimentsPAGTest_Dima('Cond');
DirPAGCond = RestrictPathForExperiment(DirPAGCond,'nMice', [787 788]);
DirPAGPost = PathForExperimentsPAGTest_Dima('TestPost');
DirPAGPost = RestrictPathForExperiment(DirPAGPost,'nMice', [787 788]);

for i=1:length(DirPAGHab.path)
    A = load([DirPAGHab.path{i}{1} 'behavResources.mat'],'PosMat', 'ZoneEpoch', 'ZoneLabels');
    PosMatHab{i} = A.PosMat;
    Start = Start(A.ZoneEpoch)/1e4;
    End = End(A.ZoneEpoch)/1e4;
    ZoneEpochHab{i} = [Start End];
    ZoneEpochHab = A.ZoneLabels;
end

for i=1:length(DirPAGPre.path)
    for j=1:length(DirPAGPre.path{i})
        A = load([DirPAGPre.path{i}{j} 'behavResources.mat'],'PosMat', 'ZoneEpoch', 'ZoneLabels');
        PosMatPre{i}{j} = A.PosMat;
        Start = Start(A.ZoneEpoch)/1e4;
        End = End(A.ZoneEpoch)/1e4;
        ZoneEpochPre{i} = [Start End];
        ZoneEpochPre = A.ZoneLabels;
    end
end

for i=1:length(DirPAGCond.path)
    for j=1:length(DirPAGCond.path{i})
        A = load([DirPAGCond.path{i}{j} 'behavResources.mat'],'PosMat', 'ZoneEpoch', 'ZoneLabels');
        PosMatCond{i}{j} = A.PosMat;
        Start = Start(A.ZoneEpoch)/1e4;
        End = End(A.ZoneEpoch)/1e4;
        ZoneEpochCond{i} = [Start End];
        ZoneEpochHab = A.ZoneLabels;
    end
end

for i=1:length(DirPAGPost.path)
    for j=1:length(DirPAGPost.path{i})
        A = load([DirPAGPost.path{i}{j} 'behavResources.mat'],'PosMat', 'ZoneEpoch', 'ZoneLabels');
        PosMatPost{i}{j} = A.PosMat;
        Start = Start(A.ZoneEpoch)/1e4;
        End = End(A.ZoneEpoch)/1e4;
        ZoneEpochCond{i} = [Start End];
        ZoneEpochHab = A.ZoneLabels;
    end
end