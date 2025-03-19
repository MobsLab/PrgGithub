clear all
%% Look at effect of conditionning
% Habituation
IsSpikeMouse=[];
clear ZoneTimeH
Files=PathForExperimentsEmbReact('HabituationNight');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    load('behavResources.mat')
    for k=1:5
        Behav.ZoneEpoch{k}=Behav.ZoneEpoch{k};
        ZoneTimeH(mm,k)=sum(Stop(Behav.ZoneEpoch{k},'s')-Start(Behav.ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
    end
end
ShckSide.Hab=ZoneTimeH(:,1:5:end)+ZoneTimeH(:,4:5:end);
NoShckSide.Hab=ZoneTimeH(:,2:5:end)+ZoneTimeH(:,5:5:end);
ModExplo.Hab=[[(ShckSide.Hab-NoShckSide.Hab)./(ShckSide.Hab+NoShckSide.Hab)]];

% Test Pre
clear ZoneTime
Files=PathForExperimentsEmbReact('TestPreNight');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:length(Files.path)
    for c=1:4
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        for k=1:5
            Behav.ZoneEpoch{k}=Behav.ZoneEpoch{k};
            ZoneTime{c}(mm,k)=sum(Stop(Behav.ZoneEpoch{k},'s')-Start(Behav.ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
        end
    end
end
AllDat=[];
for c=1:4
    AllDat=[AllDat;(ZoneTime{c}(:,1:5)')];
end
ShckSide.TestPre=AllDat(1:5:end,:)+AllDat(4:5:end,:);
NoShckSide.TestPre=AllDat(2:5:end,:)+AllDat(5:5:end,:);
ModExplo.TestPre=[(ShckSide.TestPre-NoShckSide.TestPre)./(ShckSide.TestPre+NoShckSide.TestPre)]';
figure
subplot(221)
pval=PlotErrorBarNSB([mean(ShckSide.TestPre);mean(NoShckSide.TestPre)]',0,1,'ranksum',1,find(IsSpikeMouse));
title('TestPre'), ylabel('time spent (s)')
set(gca,'XTick',[1:2],'XTickLabel',{'Shk','NoShk'})
ylim([0 200])

subplot(223)
bar([1,2,3,4,5],ones(1,5)*1.3,'FaceColor','w','EdgeColor','w'), hold on
plotSpread([ModExplo.Hab,ModExplo.TestPre],'distributionColors',[0.6 0.6 0.6])
ToTest=[ModExplo.Hab,ModExplo.TestPre];
clear h p
for k=1:5
[p(k),h(k)]=signrank(ToTest(:,k),0,'alpha',0.05/5);
end
line([[1:5]-0.5;[2:6]-0.5],[nanmean(ToTest);nanmean(ToTest)],'color','k','linewidth',2)
p(h==0)=NaN;
sigstar({{1,1.1},{2,2.1},{3,3.1},{4,4.1},{5,5.1}},p)
% [i1,j1] = ndgrid(1:size(ModExplo,1),1:size(ModExplo,2));
% [i2,j2] = ndgrid(1:size(ModExploH,1),(1:size(ModExploH,2))+size(ModExplo,2));
% z = accumarray([i1(:),j1(:);i2(:),j2(:)],[ModExploH(:);ModExplo(:)]);
% z(z==0)=NaN;
% boxplot(z), hold on
set(gca,'XTick',[1:5],'XTickLabel',{'Hab','T1','T2','T3','T4'})
ylabel('ModInd'),line(xlim,[0 0],'color','k')
title('TestPre')
ylim([-1.7 1.7])

% Extinction
clear ZoneTimeH
Files=PathForExperimentsEmbReact('ExtinctionNight');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:length(Files.path)
        MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
cd(Files.path{mm}{1})
    load('behavResources.mat')
    for k=1:5
        Behav.ZoneEpoch{k}=Behav.ZoneEpoch{k};
        ZoneTimeH(mm,k)=sum(Stop(Behav.ZoneEpoch{k},'s')-Start(Behav.ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
    end
end
ShckSide.Extinction=ZoneTimeH(:,1:5:end)+ZoneTimeH(:,4:5:end);
NoShckSide.Extinction=ZoneTimeH(:,2:5:end)+ZoneTimeH(:,5:5:end);
ModExplo.Extinction=[[(ShckSide.Extinction-NoShckSide.Extinction)./(ShckSide.Extinction+NoShckSide.Extinction)]];

clear ZoneTime
Files=PathForExperimentsEmbReact('TestPostNight');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:length(Files.path)
    MouseName{mm}=num2str(Files.ExpeInfo{mm}{1}.nmouse);
    for c=1:4
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        for k=1:5
            Behav.ZoneEpoch{k}=Behav.ZoneEpoch{k};
            ZoneTime{c}(mm,k)=sum(Stop(Behav.ZoneEpoch{k},'s')-Start(Behav.ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
        end
    end
end
AllDat=[];
for c=1:4
    AllDat=[AllDat;(ZoneTime{c}(:,1:5)')];
end
ShckSide.TestPost=AllDat(1:5:end,:)+AllDat(4:5:end,:);
NoShckSide.TestPost=AllDat(2:5:end,:)+AllDat(5:5:end,:);
ModExplo.TestPost=[(ShckSide.TestPost-NoShckSide.TestPost)./(ShckSide.TestPost+NoShckSide.TestPost)]';

subplot(222)
pval=PlotErrorBarNSB([mean(ShckSide.TestPost);mean(NoShckSide.TestPost)]',0,1,'ranksum',1,find(IsSpikeMouse));
title('TestPost')
set(gca,'XTick',[1:2],'XTickLabel',{'Shk','NoShk'})
ylabel('time spent (s)')
ylim([0 200])

subplot(224)
bar([1,2,3,4,5],ones(1,5)*1.3,'FaceColor','w','EdgeColor','w'), hold on
plotSpread([ModExplo.TestPost,ModExplo.Extinction],'distributionColors',[0.6 0.6 0.6])
ToTest=[ModExplo.TestPost,ModExplo.Extinction];
clear h p
for k=1:5
[p(k),h(k)]=signrank(ToTest(:,k),0,'alpha',0.05/5);
end
p(h==0)=NaN;
line([[1:5]-0.5;[2:6]-0.5],[nanmean(ToTest);nanmean(ToTest)],'color','k','linewidth',2)
sigstar({{1,1.1},{2,2.1},{3,3.1},{4,4.1},{5,5.1}},p)
% [i1,j1] = ndgrid(1:size(ModExplo,1),1:size(ModExplo,2));
% [i2,j2] = ndgrid(1:size(ModExploH,1),(1:size(ModExploH,2))+size(ModExplo,2));
% z = accumarray([i1(:),j1(:);i2(:),j2(:)],[ModExplo(:);ModExploH(:)]);
% z(z==0)=NaN;
% boxplot(z), hold on
set(gca,'XTick',[1:5],'XTickLabel',{'T1','T2','T3','T4','Ext'})
,ylabel('ModInd'),line(xlim,[0 0],'color','k')
ylim([-1.7 1.7])
title('TestPost')