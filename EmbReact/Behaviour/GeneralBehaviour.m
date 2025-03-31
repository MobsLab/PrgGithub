%% Overall behaviour from task

clear all
SpikeMice=[490,507,508,509,510,512,514];
% EPM
Files=PathForExperimentsEmbReactMontreal('EPM');
clear ZoneTime
for mm=1:length(Files.path)
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    Behav.ZoneEpoch{1}=Behav.ZoneEpoch{1}-Behav.ZoneEpoch{3};
    Behav.ZoneEpoch{2}=Behav.ZoneEpoch{2}-Behav.ZoneEpoch{3};
    Behav.ZoneEpoch{1}=dropShortIntervals(Behav.ZoneEpoch{1},1*1e4);
    Behav.ZoneEpoch{2}=dropShortIntervals(Behav.ZoneEpoch{2},1*1e4);
    TotTime(mm)=max(Range(Behav.Movtsd,'s'));
    for k=1:3
        ZoneTime(mm,k)=(sum(Stop(Behav.ZoneEpoch{k},'s')-Start(Behav.ZoneEpoch{k},'s')))./TotTime(mm);
        EntryTimes(mm,k)=length(Start(Behav.ZoneEpoch{k}));
    end
end
figure
subplot(211)
pval=PlotErrorBarNSB(ZoneTime(:,1:2),0,1,'ranksum',1,find(IsSpikeMouse));
ylabel('Time in zone (% tot)')
set(gca,'XTick',[1,2],'XTickLabel',{'Open','Closed'})
ylim([0 1])
subplot(212)
pval=PlotErrorBarNSB(EntryTimes(:,1:2),0,1,'ranksum',1,find(IsSpikeMouse));
ylabel('Number of entries')
set(gca,'XTick',[1,2],'XTickLabel',{'Open','Closed'})


%% Look at effect of conditionning

% Habituation
clear IsSpikeMouse
clear ZoneTimeH
Files=PathForExperimentsEmbReactMontreal('Habituation');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
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
Files=PathForExperimentsEmbReactMontreal('TestPre');
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
plotSpread([ModExplo.Hab(find(IsSpikeMouse)),ModExplo.TestPre(find(IsSpikeMouse),:)],'distributionColors',[1 0 0])
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
Files=PathForExperimentsEmbReactMontreal('Extinction');
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
Files=PathForExperimentsEmbReact('TestPost');
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
plotSpread([ModExplo.TestPost(find(IsSpikeMouse),:),ModExplo.Extinction(find(IsSpikeMouse),:)],'distributionColors',[1 0 0])
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

%% Look at effect of sound conditionning
figure
Files=PathForExperimentsEmbReactMontreal('SoundHab');clear IsSpikeMouse
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
    load('behavResources.mat')
    if isempty(TTLInfo) % this is for mouse 436
        TTLInfo.CSPlusTimes=[5510312.27450545;6790944.33830228;7931112.39510167;8771056.43694489];
        TTLInfo.CSMoinsTimes=[2011352.10019888;3030352.15096207;3881096.19334332;4851480.24168463];
    end
    CSPlusEp=intervalSet(TTLInfo.CSPlusTimes,TTLInfo.CSPlusTimes+30*1e4);
    CSMoinsEp=intervalSet(TTLInfo.CSMoinsTimes,TTLInfo.CSMoinsTimes+30*1e4);
    HabFz(mm,1)=length(Data(Restrict(Behav.Movtsd,and(CSMoinsEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,CSMoinsEp)));
    HabFz(mm,2)=length(Data(Restrict(Behav.Movtsd,and(CSPlusEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,CSPlusEp)));
end
subplot(131)
pval=PlotErrorBarNSB(HabFz,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1.2])
title('Pre Cond')
ylabel('prop time freezing')

Files=PathForExperimentsEmbReactMontreal('SoundCond'); clear IsSpikeMouse
for mm=1:length(Files.path)
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    CSPlusEp=intervalSet(TTLInfo.CSPlusTimes,TTLInfo.CSPlusTimes+30*1e4);
    CSMoinsEp=intervalSet(TTLInfo.CSMoinsTimes,TTLInfo.CSMoinsTimes+30*1e4);
    CondFz(mm,1)=length(Data(Restrict(Behav.Movtsd,and(CSMoinsEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,CSMoinsEp)));
    CondFz(mm,2)=length(Data(Restrict(Behav.Movtsd,and(CSPlusEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,CSPlusEp)));
end
subplot(132)
pval=PlotErrorBarNSB(CondFz,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1.2])
title('Cond')

Files=PathForExperimentsEmbReactMontreal('SoundTest'); clear IsSpikeMouse
for mm=1:length(Files.path)
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    TotEpoch=intervalSet(0,max(Range(Behav.Movtsd)));
    CSPlusEp=intervalSet(TTLInfo.CSPlusTimes(1:4),TTLInfo.CSPlusTimes(1:4)+30*1e4);
    CSMoinsEp=intervalSet(TTLInfo.CSMoinsTimes,TTLInfo.CSMoinsTimes+30*1e4);
    TestFz(mm,1)=length(Data(Restrict(Behav.Movtsd,and(CSMoinsEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,and(CSMoinsEp,TotEpoch))));
    TestFz(mm,2)=length(Data(Restrict(Behav.Movtsd,and(CSPlusEp,Behav.FreezeEpoch))))./length(Data(Restrict(Behav.Movtsd,and(CSPlusEp,TotEpoch))));
end
subplot(133)
pval=PlotErrorBarNSB(TestFz,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1.2])
title('Post Cond')



%% Do they sleep when they're allowed?

clear Sleep IsSpikeMouse
SessTypes={'SleepPreUMaze','SleepPostUMaze', 'SleepPreSound', 'SleepPostSound'};

for ss=1:length(SessTypes)
    ss
    Files=PathForExperimentsEmbReact(SessTypes{ss});
    for mm=1:length(Files.path)
        MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
%         IsSpikeMouse{ss}(mm)=sum(SpikeMice==MouseName{mm});
        cd(Files.path{mm}{1})
        clear SWSEpoch REMEpoch
        load('StateEpochSB.mat','Epoch','SWSEpoch','REMEpoch','smooth_ghi')
        SleepPerc{ss}(mm)=length(Data(Restrict(smooth_ghi,and(Epoch,or(SWSEpoch,REMEpoch)))))./length(Data(Restrict(smooth_ghi,Epoch)));
        SleepTime{ss}(mm)=nansum(Stop(or(SWSEpoch,REMEpoch),'s')-Start(or(SWSEpoch,REMEpoch),'s'))/60;
        REMPers{ss}(mm)=length(Data(Restrict(smooth_ghi,and(Epoch,REMEpoch))))./length(Data(Restrict(smooth_ghi,and(Epoch,or(SWSEpoch,REMEpoch)))));

    end
end
figure
subplot(311)
h=plotSpread(SleepPerc,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1)
% for ss=1:length(SessTypes)
% SleepBis{ss}=SleepPerc{ss}(find(IsSpikeMouse{ss}));
% end
% h1=plotSpread(SleepBis,'distributionColors',[1 0 0],'spreadWidth',1)
for ss=1:length(SessTypes)
    hold on
    set(h{1}(ss),'MarkerSize',15)
%     set(h1{1}(ss),'MarkerSize',15)
    line([ss-0.2 ss+0.2],[1 1 ]*mean(SleepPerc{ss}),'linewidth',2)
    set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
end
    ylim([-0.1 1])
ylabel('% time sleeping')
subplot(312)
h=plotSpread(SleepTime,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1)
% for ss=1:length(SessTypes)
% SleepBis{ss}=SleepTime{ss}(find(IsSpikeMouse{ss}));
% end
% h1=plotSpread(SleepBis,'distributionColors',[1 0 0],'spreadWidth',1)
for ss=1:length(SessTypes)
    hold on
    set(h{1}(ss),'MarkerSize',15)
%     set(h1{1}(ss),'MarkerSize',15)
    line([ss-0.2 ss+0.2],[1 1 ]*mean(SleepTime{ss}),'linewidth',2)
    set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
end
ylabel('Tot time sleeping')
subplot(313)
h=plotSpread(REMPers,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1)
% for ss=1:length(SessTypes)
% SleepBis{ss}=REMPers{ss}(find(IsSpikeMouse{ss}));
% end
% h1=plotSpread(SleepBis,'distributionColors',[1 0 0],'spreadWidth',1)
for ss=1:length(SessTypes)
    hold on
    set(h{1}(ss),'MarkerSize',15)
%     set(h1{1}(ss),'MarkerSize',15)
    line([ss-0.2 ss+0.2],[1 1 ]*nanmean(REMPers{ss}),'linewidth',2)
    set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
end
ylabel('% REM')

%% During conditionning left/right occupation and freezing
fig=figure;
clear ZoneTime ZoneSleep ZoneFreeze IsSpikeMouse
Files=PathForExperimentsEmbReactMontreal('UMazeCond');
MouseToAvoid=[117,431]; % mice with noisy data to exclude
Files=RemoveElementsFromDir(Files,'nmouse',MouseToAvoid);
for mm=1:length(Files.path)
    MouseName{mm}=Files.ExpeInfo{mm}{1}.nmouse;
    IsSpikeMouse(mm)=sum(SpikeMice==MouseName{mm});
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        clear Behav SleepyEpoch
        load('behavResources.mat')
        load('StateEpochSB.mat','SleepyEpoch')
        SessDur=length(Data(Behav.Movtsd));
        Behav.FreezeEpoch=Behav.FreezeEpoch-SleepyEpoch;
        FreezeDur=length(Data(Restrict(Behav.Movtsd,Behav.FreezeEpoch)));
        for k=1:5
            tempSleep=length(Data(Restrict(Behav.Movtsd,and(Behav.ZoneEpoch{k},SleepyEpoch))));
            tempTot=length(Data(Restrict(Behav.Movtsd,Behav.ZoneEpoch{k})));
            TempPercSleep(c,k)=tempSleep./tempTot;
            Behav.ZoneEpoch{k}=Behav.ZoneEpoch{k}-SleepyEpoch;
            tempFreeze=length(Data(Restrict(Behav.Movtsd,and(Behav.ZoneEpoch{k},Behav.FreezeEpoch))));
            tempTot=length(Data(Restrict(Behav.Movtsd,Behav.ZoneEpoch{k})));
            TempPercFzTotLoc(c,k)=tempFreeze./tempTot;
            TempPercFzTotFz(c,k)=tempFreeze./FreezeDur;
            TempPerOccup(c,k)=tempTot./SessDur;
        end
    end
    for k=1:5
        PercSleep(mm,k)=nanmean(TempPercSleep(:,k));
        PercFzTotLoc(mm,k)=nanmean(TempPercFzTotLoc(:,k));
        PercFzTotFz(mm,k)=nanmean(TempPercFzTotFz(:,k));
        PerOccup(mm,k)=nanmean(TempPerOccup(:,k));
    end
end
subplot(221)
pval=PlotErrorBarNSB(PerOccup,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2,3,4,5],'XTickLabel',{'Shk','NoShk','cent','cent shk','cent no shk'})
ylabel('perc time')
xlim([0.5 5.5])
subplot(222)
pval=PlotErrorBarNSB(PercFzTotLoc,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2,3,4,5],'XTickLabel',{'Shk','NoShk','cent','cent shk','cent no shk'})
ylabel('perc time in zone \newline  spent freezing')
xlim([0.5 5.5])
subplot(223)
pval=PlotErrorBarNSB(PercFzTotFz,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2,3,4,5],'XTickLabel',{'Shk','NoShk','cent','cent shk','cent no shk'})
ylabel('perc time spent freezing \newline in each zone')
xlim([0.5 5.5])
subplot(224)
pval=PlotErrorBarNSB(PercSleep,0,1,'ranksum',1,find(IsSpikeMouse));
set(gca,'XTick',[1,2,3,4,5],'XTickLabel',{'Shk','NoShk','cent','cent shk','cent no shk'})
ylabel('perc time in zone \newline spent asleep')
xlim([0.5 5.5])


