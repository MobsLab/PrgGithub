%% Overall behaviour from task
clear all
% EPM
Files=PathForExperimentsEmbReact('EPM');
clear ZoneTime
for mm=[1:5,7]
    mm
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    ZoneEpoch{1}=ZoneEpoch{1}-ZoneEpoch{3};
    ZoneEpoch{2}=ZoneEpoch{2}-ZoneEpoch{3};
    ZoneEpoch{1}=dropShortIntervals(ZoneEpoch{1},1*1e4);
    ZoneEpoch{2}=dropShortIntervals(ZoneEpoch{2},1*1e4);
    
    for k=1:3
        ZoneTime(mm,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));
        EntryTimes(mm,k)=length(Start(ZoneEpoch{k}));
    end
end
ZoneTime(2:3,:)=ZoneTime(2:3,:)*2;
EntryTimes(2:3,:)=EntryTimes(2:3,:)*2;
ZoneTime(6,:)=[];
EntryTimes(6,:)=[];
figure
subplot(211)
PlotErrorBarN(ZoneTime(:,1:2),0,1)
ylabel('Time in zone (s)')
set(gca,'XTick',[1,2],'XTickLabel',{'Open','Closed'})
subplot(212)
PlotErrorBarN(EntryTimes(:,1:2),0,1)
ylabel('Number of entries')
set(gca,'XTick',[1,2],'XTickLabel',{'Open','Closed'})


%% Look at effect of conditionning
figure
clear ZoneTimeH
Files=PathForExperimentsEmbReact('Habituation');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    for k=1:5
        ZoneEpoch{k}=ZoneEpoch{k}-SleepyEpoch;
        ZoneTimeH(mm,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
    end
end
ShckSide=ZoneTimeH(:,1:5:end)+ZoneTimeH(:,4:5:end);
NoShckSide=ZoneTimeH(:,2:5:end)+ZoneTimeH(:,5:5:end);
ModExploH=[[(ShckSide-NoShckSide)./(ShckSide+NoShckSide)]];


clear ZoneTime
Files=PathForExperimentsEmbReact('TestPre');
for mm=2:length(Files.path)
    for c=1:4
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        for k=1:5
            ZoneEpoch{k}=ZoneEpoch{k}-SleepyEpoch;
            ZoneTime{c}(mm,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
        end
    end
end

AllDat=[];
for c=1:4
    AllDat=[AllDat;(ZoneTime{c}(:,1:5)')];
end
AllDat(:,1)=[];
subplot(221)
PlotErrorBarN([mean(AllDat(1:5:end,:)+AllDat(4:5:end,:));mean(AllDat(2:5:end,:)+AllDat(5:5:end,:))]',0,1)
ShckSide=AllDat(1:5:end,:)+AllDat(4:5:end,:);
NoShckSide=AllDat(2:5:end,:)+AllDat(5:5:end,:);
ModExplo=[(ShckSide-NoShckSide)./(ShckSide+NoShckSide)]';
title('TestPre'), ylabel('time spent (s)')
set(gca,'XTick',[1:2],'XTickLabel',{'Shk','NoShk'})

subplot(223)
[i1,j1] = ndgrid(1:size(ModExplo,1),1:size(ModExplo,2));
[i2,j2] = ndgrid(1:size(ModExploH,1),(1:size(ModExploH,2))+size(ModExplo,2));
z = accumarray([i1(:),j1(:);i2(:),j2(:)],[ModExploH(:);ModExplo(:)]);
z(z==0)=NaN;
boxplot(z), hold on
set(gca,'XTick',[1:5],'XTickLabel',{'Hab','T1','T2','T3','T4'})
,ylabel('ModInd'),line(xlim,[0 0],'color','k')
title('TestPre')
ylim([-1.5 1.5])


clear ZoneTimeH
Files=PathForExperimentsEmbReact('Extinction');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    for k=1:5
        ZoneEpoch{k}=ZoneEpoch{k}-SleepyEpoch;
        ZoneTimeH(mm,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
    end
end
ShckSide=ZoneTimeH(:,1:5:end)+ZoneTimeH(:,4:5:end);
NoShckSide=ZoneTimeH(:,2:5:end)+ZoneTimeH(:,5:5:end);

clear ZoneTime
Files=PathForExperimentsEmbReact('TestPost');
for mm=1:length(Files.path)
    for c=1:4
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        for k=1:5
            ZoneEpoch{k}=ZoneEpoch{k}-SleepyEpoch;
            ZoneTime{c}(mm,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));%./sum(sum(Zone{k}));
        end
    end
end
AllDat=[];
for c=1:4
    AllDat=[AllDat;(ZoneTime{c}(:,1:5)')];
end
subplot(222)
PlotErrorBarN([mean(AllDat(1:5:end,:)+AllDat(4:5:end,:));mean(AllDat(2:5:end,:)+AllDat(5:5:end,:))]',0,1)
title('TestPost')
set(gca,'XTick',[1:2],'XTickLabel',{'Shk','NoShk'})
ylabel('time spent (s)')
ylim([0 180])

ShckSide=AllDat(1:5:end,:)+AllDat(4:5:end,:);
NoShckSide=AllDat(2:5:end,:)+AllDat(5:5:end,:);
ModExplo=[(ShckSide-NoShckSide)./(ShckSide+NoShckSide)]';
subplot(224)
[i1,j1] = ndgrid(1:size(ModExplo,1),1:size(ModExplo,2));
[i2,j2] = ndgrid(1:size(ModExploH,1),(1:size(ModExploH,2))+size(ModExplo,2));
z = accumarray([i1(:),j1(:);i2(:),j2(:)],[ModExplo(:);ModExploH(:)]);
z(z==0)=NaN;

boxplot(z), hold on
set(gca,'XTick',[1:5],'XTickLabel',{'T1','T2','T3','T4','Ext'})
,ylabel('ModInd'),line(xlim,[0 0],'color','k')
ylim([-1.5 1.5])
title('TestPost')

%% Look at effect of sound conditionning
figure
Files=PathForExperimentsEmbReact('SoundHab');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    CSPlus=Start(SoundEpoch);CSPlus=CSPlus(5:8);CSPlusEp=intervalSet(CSPlus,CSPlus+30*1e4);
    CSMoins=Start(SoundEpoch);CSMoins=CSMoins(1:4);CSMoinsEp=intervalSet(CSMoins,CSMoins+30*1e4);
    FreezeEpoch=FreezeEpoch-SleepyEpoch;    CSMoinsEp=CSMoinsEp-SleepyEpoch; CSPlusEp=CSPlusEp-SleepyEpoch;
    HabFz(mm,1)=length(Data(Restrict(Movtsd,and(CSMoinsEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,CSMoinsEp)));
    HabFz(mm,2)=length(Data(Restrict(Movtsd,and(CSPlusEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,CSPlusEp)));
end
subplot(131)
PlotErrorBarN(HabFz,0,1)
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1])
title('Pre Cond')

Files=PathForExperimentsEmbReact('SoundCond');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    CSPlus=Start(SoundEpoch);CSPlus=CSPlus(1:2:16);CSPlusEp=intervalSet(CSPlus,CSPlus+30*1e4);
    CSMoins=Start(SoundEpoch);CSMoins=CSMoins(2:2:16);CSMoinsEp=intervalSet(CSMoins,CSMoins+30*1e4);
    CSMoins=Start(SoundEpoch);CSMoins=CSMoins(1:4);CSMoinsEp=intervalSet(CSMoins,CSMoins+30*1e4);
    FreezeEpoch=FreezeEpoch-SleepyEpoch;    CSMoinsEp=CSMoinsEp-SleepyEpoch; CSPlusEp=CSPlusEp-SleepyEpoch;
    CondFz(mm,1)=length(Data(Restrict(Movtsd,and(CSMoinsEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,CSMoinsEp)));
    CondFz(mm,2)=length(Data(Restrict(Movtsd,and(CSPlusEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,CSPlusEp)));
end
subplot(132)
PlotErrorBarN(CondFz,0,1)
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1])
title('Cond')

Files=PathForExperimentsEmbReact('SoundTest');
for mm=1:length(Files.path)
    cd(Files.path{mm}{1})
    load('behavResources.mat')
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    CSPlus=Start(SoundEpoch);CSPlus=CSPlus(5:8);CSPlusEp=intervalSet(CSPlus,CSPlus+30*1e4);
    CSMoins=Start(SoundEpoch);CSMoins=CSMoins(1:4);CSMoinsEp=intervalSet(CSMoins,CSMoins+30*1e4);
    CSMoins=Start(SoundEpoch);CSMoins=CSMoins(1:4);CSMoinsEp=intervalSet(CSMoins,CSMoins+30*1e4);
    FreezeEpoch=FreezeEpoch-SleepyEpoch;    CSMoinsEp=CSMoinsEp-SleepyEpoch; CSPlusEp=CSPlusEp-SleepyEpoch;
    TestFz(mm,1)=length(Data(Restrict(Movtsd,and(CSMoinsEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,and(CSMoinsEp,TotEpoch))));
    TestFz(mm,2)=length(Data(Restrict(Movtsd,and(CSPlusEp,FreezeEpoch))))./length(Data(Restrict(Movtsd,and(CSPlusEp,TotEpoch))));
end
subplot(133)
PlotErrorBarN(TestFz,0,1)
set(gca,'XTick',[1,2],'XTickLabel',{'CS-','CS+'})
ylim([0 1])
title('Post Cond')


%% Look at sleeping problem
clear Sleep
SessTypes={'EPM','Habituation', 'TestPre', 'UMazeCond','TestPost' 'Extinction',...
    'SoundHab', 'SoundCond', 'SoundTest'};

for ss=1:length(SessTypes)
    Files=PathForExperimentsEmbReact(SessTypes{ss});
    m=1;
    for mm=1:length(Files.path)
        try
            temp=[];
            for c=1:length(Files.path{mm})
                cd(Files.path{mm}{c})
                load('behavResources.mat')
                TotEpoch=intervalSet(0,max(Range(Movtsd)));
                temp=[temp,length(Data(Restrict(Movtsd,and(TotEpoch,SleepyEpoch))))./length(Data(Restrict(Movtsd,TotEpoch)))];
            end
            Sleep{ss}(m)=mean(temp);
            m=m+1;
        end
    end
end

figure
clf
h=plotSpread(Sleep,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1)
for ss=1:length(SessTypes)
    hold on
    set(h{1}(ss),'MarkerSize',15)
    line([ss-0.2 ss+0.2],[1 1 ]*mean(Sleep{ss}),'linewidth',2)
end
set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
ylabel('% time sleeping')
ylim([-0.1 1])
Vals=[2.5,4.5,7.5,8.5];
for v=1:length(Vals)
    line([-0.05 -0.05]+Vals(v),ylim,'color','r')
    line([0.05 0.05]+Vals(v),ylim,'color','r')
end
line([1 1]*6.5,ylim,'color','r')

C=[]; grp=[];
for ss=1:length(SessTypes)
    C=[C,Sleep{ss}];
    grp = [grp,ones(1,length(Sleep{ss}))*ss];
end
figure
boxplot(C',grp)
set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
xlabel('% time sleeping')

%% Do they sleep when they're allowed?

clear Sleep
SessTypes={'SleepPreUMaze','SleepPostUMaze', 'SleepPreSound', 'SleepPostSound'};

for ss=1:length(SessTypes)
    Files=PathForExperimentsEmbReact(SessTypes{ss});
    for mm=1:length(Files.path)
        cd(Files.path{mm}{1})
        clear SWSEpoch REMEpoch
        load('StateEpochSB.mat','Epoch','SWSEpoch','REMEpoch','smooth_ghi')
        Sleep{ss}(mm)=length(Data(Restrict(smooth_ghi,and(Epoch,or(SWSEpoch,REMEpoch)))))./length(Data(Restrict(smooth_ghi,Epoch)));
    end
end
figure
clf
h=plotSpread(Sleep,'distributionColors',[0.6 0.6 0.6],'spreadWidth',1)
for ss=1:length(SessTypes)
    hold on
    set(h{1}(ss),'MarkerSize',15)
    line([ss-0.2 ss+0.2],[1 1 ]*mean(Sleep{ss}),'linewidth',2)
    set(gca,'XTick',[1:ss],'XTickLabel',SessTypes)
    ylabel('% time sleeping')
    ylim([-0.1 1])
end


% During conditionning left/right occupation and freezing
clear ZoneTime ZoneSleep ZoneFreeze
Files=PathForExperimentsEmbReact('UMazeCond');
for mm=1:length(Files.path)
    for c=1:length(Files.path{mm})
        cd(Files.path{mm}{c})
        load('behavResources.mat')
        for k=1:5
            ZoneSleep{mm}(c,k)=length(Data(Restrict(Movtsd,and(ZoneEpoch{k},SleepyEpoch))));
            ZoneTotSl{mm}(c,k)=length(Data(Restrict(Movtsd,ZoneEpoch{k})));
            ZoneEpoch{k}=ZoneEpoch{k}-SleepyEpoch;
            ZoneTime{mm}(c,k)=sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s'));
            ZoneFreeze{mm}(c,k)=length(Data(Restrict(Movtsd,and(ZoneEpoch{k},FreezeEpoch))));
            ZoneTotFz{mm}(c,k)=length(Data(Restrict(Movtsd,ZoneEpoch{k})));
        end
    end
end

AllDatS=[];AllDatNoS=[];AllDat=[];
for mm=1:length(Files.path)
    AllDat=[AllDat;[nanmean(nansum([ZoneSleep{mm}(:,1),ZoneSleep{mm}(:,4)])./nansum([ZoneTotSl{mm}(:,1),ZoneTotSl{mm}(:,4)])),...
        [nanmean(nansum([ZoneSleep{mm}(:,2),ZoneSleep{mm}(:,5)])./nansum([ZoneTotSl{mm}(:,2),ZoneTotSl{mm}(:,5)]))]]];
    AllDatS=[AllDatS,(nansum([ZoneSleep{mm}(:,1),ZoneSleep{mm}(:,4)])./nansum([ZoneTotSl{mm}(:,1),ZoneTotSl{mm}(:,4)]))];
    AllDatNoS=[AllDatNoS,nansum([ZoneSleep{mm}(:,2),ZoneSleep{mm}(:,5)])./nansum([ZoneTotSl{mm}(:,2),ZoneTotSl{mm}(:,5)])];
end
figure
subplot(121)
PlotErrorBarN({AllDatS,AllDatNoS},0,0)
set(gca,'XTick',[1,2],'XTickLabel',{'Shck','NoShck'})
ylabel('% sleep (sess by sess)')
subplot(122)
PlotErrorBarN(AllDat,0,1)
set(gca,'XTick',[1,2],'XTickLabel',{'Shck','NoShck'})
ylabel('% sleep (mouse by mouse)')

AllDatS=[];AllDatNoS=[];AllDat=[];
for mm=1:length(Files.path)
    AllDat=[AllDat;[nanmean(nansum([ZoneFreeze{mm}(:,1),ZoneFreeze{mm}(:,4)])./nansum([ZoneTotSl{mm}(:,1),ZoneTotSl{mm}(:,4)])),...
        [nanmean(nansum([ZoneFreeze{mm}(:,2),ZoneFreeze{mm}(:,5)])./nansum([ZoneTotSl{mm}(:,2),ZoneTotSl{mm}(:,5)]))]]];
    AllDatS=[AllDatS,(nansum([ZoneFreeze{mm}(:,1),ZoneFreeze{mm}(:,4)])./nansum([ZoneTotSl{mm}(:,1),ZoneTotSl{mm}(:,4)]))];
    AllDatNoS=[AllDatNoS,nansum([ZoneFreeze{mm}(:,2),ZoneFreeze{mm}(:,5)])./nansum([ZoneTotSl{mm}(:,2),ZoneTotSl{mm}(:,5)])];
end
figure
subplot(121)+

PlotErrorBarN({AllDatS,AllDatNoS},0,0)
set(gca,'XTick',[1,2],'XTickLabel',{'Shck','NoShck'})
ylabel('% fz (sess by sess)')
subplot(122)
PlotErrorBarN(AllDat,0,1)
set(gca,'XTick',[1,2],'XTickLabel',{'Shck','NoShck'})
ylabel('% fz (mouse by mouse)')

