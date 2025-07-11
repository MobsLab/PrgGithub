%DoAllMiceBasile

% load('~/Dropbox/Mobs_member/Theotime De Charrin/data/nnAllParams.mat')

%%
for i =1:length(Dir.results)
    saveResults(Dir.results{i}{1}, Dir.results{i}{1})
end
%%

%%

for i=1:9
    RP36(i,:)=occupationVSdecoding(Dir.results{i}{1},36);
end
for i=1:9
    RP200(i,:)=occupationVSdecoding(DirAnalyse{i},200);
end
for i=1:9
    RP504(i,:)=occupationVSdecoding(DirAnalyse{i},504);
end

PlotErrorBarN_KJ([RP200(:,1),RP200(:,3)]);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'hab','cond'})

figure('color',[1 1 1]), 
subplot(1,3,1), PlotErrorBarN_KJ([RP36(:,1),RP36(:,3)],'newfig',0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'hab','cond', 'testPost'})
subplot(1,3,2), PlotErrorBarN_KJ([RP200(:,1),RP200(:,3)],'newfig',0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'hab','cond', 'testPost'})
subplot(1,3,3), PlotErrorBarN_KJ([RP504(:,1),RP504(:,3)],'newfig',0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'hab','cond', 'testPost'})
%%
plotErrorByPosMovImm(DirAnalyse{7})
%%

for i=1:9
   R36(i,:)=DoAnalysisFor1mouse(DirAnalyse{i},DirAnalyse2{i},36,0,1);
end

for i=1:9
   R200(i,:)=DoAnalysisFor1mouse(DirAnalyse{i},DirAnalyse2{i},200, 0,1);
end

for i=1:9
   R504(i,:)=DoAnalysisFor1mouse(DirAnalyse{i},DirAnalyse2{i},504,0,1);
end

figure('color',[1 1 1]), 
% subplot(1,3,1), pval36=PlotErrorBarN(R36,0,'ColumnTest',8);ylim([0 1]);
C{1}=[0 0 0.5];
C{3}=[0 0 0.5];
C{5}=[0 0 0.5];
C{7}=[0 0 0.5];
C{2}=[0.8 0 0];
C{4}=[0.8 0 0];
C{6}=[0.8 0 0];
C{8}=[0.8 0 0];
PlotErrorBarN_KJ(R200,'barcolors',C);ylim([0 0.6]);
epoch={'HabituationGoodPL','HabituationBadPL','TestPreGoodPL','TestPreBadPL','ConditionningGoodPL','ConditionningBadPL','TestPostGoodPL','TestPostBadPL'};
% epoch=categorical(epoch, epoch);
set(gca,'xtick',[1:8])
set(gca,'xticklabels',epoch)
% subplot(1,3,3), pval504=PlotErrorBarN(R504,0,'ColumnTest',8);ylim([0 1])


figure('color',[1 1 1]), 
subplot(1,3,1), PlotErrorBarN([R36(:,1),R36(:,2)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})
subplot(1,3,2), PlotErrorBarN([R200(:,1),R200(:,2)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})
subplot(1,3,3), PlotErrorBarN([R504(:,1),R504(:,2)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})


figure('color',[1 1 1]), 
subplot(1,3,1), PlotErrorBarN([R36(:,3),R36(:,4)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})
subplot(1,3,2), PlotErrorBarN([R200(:,3),R200(:,4)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})
subplot(1,3,3), PlotErrorBarN([R504(:,3),R504(:,4)],0);ylim([0 1])
set(gca,'xtick',[1:2])
set(gca,'xticklabels',{'good','bad'})

C{1}=[0 0 0.5];
C{3}=[0 0 0.5];
C{2}=[0 0 0.5];
C{4}=[0 0 0.5];


PlotErrorBarN_KJ([R36(:,1),R36(:,3),R36(:,5),R36(:,7)],'barcolors',C);ylim([0 0.4])
set(gca,'xtick',[1:4])
set(gca,'xticklabels',{'hab','testPre','cond','testPost'})
title('36 ms')
PlotErrorBarN_KJ([R200(:,1),R200(:,3),R200(:,5),R200(:,7)],'barcolors',C);ylim([0 0.4])
set(gca,'xtick',[1:4])
set(gca,'xticklabels',{'hab','testPre','cond','testPost'})
title('200 ms')
PlotErrorBarN_KJ([R504(:,1),R504(:,3),R504(:,5),R504(:,7)],'barcolors',C);ylim([0 0.4])
set(gca,'xtick',[1:4])
set(gca,'xticklabels',{'hab','testPre','cond','testPost'})
title('504 ms')

figure('color',[1 1 1]), 
for k=1:8
    subplot(1,8,k), PlotErrorBarN([R36(:,k),R200(:,k),R504(:,k)],0);ylim([0 0.5])
    set(gca,'xtick',[1:3])
set(gca,'xticklabels',{'36','200','504'})
line(xlim,[0.2 0.2])
end

%% Reactivations of the shock zone
for i = 1:9
    [N1(i,:), N2(i,:), idx, reactShock(i,:), reactSafe(i,:)] = ReactivationsShockZone(DirAnalyse{i}, 200,0.3,0.2,0.2);
end
% reactShock
% reactSafe
comp = (reactShock ./ reactSafe);
figure,
hold on;
barplot(comp(1,:))



%%
nbbin = 20;
h =  cell(1,9);
for i = 1:9
    h2 = plotErrorByPosMovImm(DirAnalyse{i}, nbbin, 200,'testPre');
    h{i} = h2;
end 
mean_h=zeros(size(h{1}));
for i =1:9
    mean_h = mean_h + h{i};
end
mean_h = mean_h / 9;
    
figure, 
imagesc([0.025:0.05:0.975],[1:nbbin]/nbbin,zscore(mean_h))
xlabel('True Linearized Position')
ylabel('Decoded Linearized Position')
xlim([0 0.85])
ylim([0.025 0.85])

