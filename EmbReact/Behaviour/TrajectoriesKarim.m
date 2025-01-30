clear all
DirSB_Hab=PathForExperimentsEmbReact('Habituation');
DirSB_TestPre=PathForExperimentsEmbReact('TestPre');
DirSB_Cond=PathForExperimentsEmbReact('UMazeCond');
DirSB_TestPost=PathForExperimentsEmbReact('TestPost');

GoodMice = [439,490,507,508,509,510,512,514];

for k = 1:length(DirSB_Hab.path)
    HabNmouse(k) = DirSB_Hab.ExpeInfo{k}{1}.nmouse;
end
for k = 1:length(DirSB_TestPre.path)
    TestPreNmouse(k) = DirSB_TestPre.ExpeInfo{k}{1}.nmouse;
end
for k = 1:length(DirSB_Cond.path)
    CondNmouse(k) = DirSB_Cond.ExpeInfo{k}{1}.nmouse;
end
for k = 1:length(DirSB_TestPost.path)
    TestPostNmouse(k) = DirSB_TestPost.ExpeInfo{k}{1}.nmouse;
end

clear Dir
for g = 1:length(GoodMice)
    
    Dir.MouseNum{g} =GoodMice(g);
    Dir.Hab{g} = DirSB_Hab.path{find(HabNmouse==GoodMice(g))};
    Dir.TestPre{g} = DirSB_TestPre.path{find(TestPreNmouse==GoodMice(g))};
    Dir.Cond{g} = DirSB_Cond.path{find(CondNmouse==GoodMice(g))};
    Dir.TestPost{g} = DirSB_TestPost.path{find(TestPostNmouse==GoodMice(g))};
    
end


for i = 1:length(Dir.Hab)
    for k = 1
    A = load([Dir.Hab{i}{k} 'behavResources_SB.mat'],'Behav');
    X.Hab{i}{k} = Data(A.Behav.AlignedXtsd);
    Y.Hab{i}{k} = Data(A.Behav.AlignedYtsd);
    T.Hab{i}{k} = Range(A.Behav.AlignedYtsd,'s');
    end
end

for i = 1:length(Dir.TestPre)
    for k = 1:4
    A = load([Dir.TestPre{i}{k} 'behavResources_SB.mat'],'Behav');
    X.Pre{i}{k} = Data(A.Behav.AlignedXtsd);
    Y.Pre{i}{k} = Data(A.Behav.AlignedYtsd);
    T.Pre{i}{k} = Range(A.Behav.AlignedYtsd,'s');
    end
end

for i = 1:length(Dir.TestPost)
    for k = 1:4
    A = load([Dir.TestPost{i}{k} 'behavResources_SB.mat'],'Behav');
    X.Post{i}{k} = Data(A.Behav.AlignedXtsd);
    Y.Post{i}{k} = Data(A.Behav.AlignedYtsd);
    T.Post{i}{k} = Range(A.Behav.AlignedYtsd,'s');
    end
end


for i = 1:length(Dir.Cond)
    for k = 1:4
    A = load([Dir.Cond{i}{k} 'behavResources_SB.mat'],'Behav','TTLInfo');
    X.Cond{i}{k} = Data(A.Behav.AlignedXtsd);
    Y.Cond{i}{k} = Data(A.Behav.AlignedYtsd);
    T.Cond{i}{k} = Range(A.Behav.AlignedYtsd,'s');
    Stim.Cond{i}{k} = Start(A.TTLInfo.StimEpoch,'s');
    end
end

save('TrajectoryData.mat','X','Y','T','Stim')


figure(3)
for i = 1:length(GoodMice)
    subplot(141)
    plot((X.Hab{i}{1}),(Y.Hab{i}{1})), hold on
    title('Hab')
    xlim([0 1]), ylim([0 1])
    
    subplot(142)
    for k = 1:4
        plot((X.Pre{i}{k}),(Y.Pre{i}{k})), hold on
    end
    title('4 TestPre')
    xlim([0 1]), ylim([0 1])
    
    
    subplot(143)
    for k = 1:4
        plot((X.Cond{i}{k}),(Y.Cond{i}{k})), hold on
    end
    title('4 Cond')
    xlim([0 1]), ylim([0 1])
    
    subplot(144)
    for k = 1:4
        plot((X.Post{i}{k}),(Y.Post{i}{k})), hold on
    end
    title('4 TestPost')
    xlim([0 1]), ylim([0 1])
    saveas(3,['TrajMouseNum' num2str(i) '.png'])
    
    clf
end


