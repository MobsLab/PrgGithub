clear all
FolderName = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks/';
Binsize = 1*1e4;
SpeedLim = 3;

Titles = {'EPM','UMazeFz','UMazeMv','UMazeAll'};

MiceNumber=[490,507,508,509,510,512,514];
figure(1)
figure(2)

for mm = 1 : length(MiceNumber)
    
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    SessNames = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','sessiontype');
    ZoneEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','zoneepoch');
    Postsd = ConcatenateDataFromFolders_SB(Dir,'position');
    
    OpenEPMEpoch = and(SessNames.EPM{1},ZoneEpoch{1});
    ClosedEPMEpoch = and(SessNames.EPM{1},ZoneEpoch{2});
    
    % open arm - closed arm entries
    NumOpenEntry(mm) = length(Start(OpenEPMEpoch));
    NumCloseEntry(mm) = length(Start(ClosedEPMEpoch));
    
    % open arm - closed arm time
    DurOpen(mm) = sum(Stop(OpenEPMEpoch)-Start(OpenEPMEpoch));
    DurClose(mm) = sum(Stop(ClosedEPMEpoch)-Start(ClosedEPMEpoch));
    
    
    BeginSess = intervalSet(min([Start(OpenEPMEpoch);Start(ClosedEPMEpoch)]),min([Start(OpenEPMEpoch);Start(ClosedEPMEpoch)])+180*1e4);
    OpenEPMEpoch = and(OpenEPMEpoch,BeginSess);
    ClosedEPMEpoch = and(ClosedEPMEpoch,BeginSess);
    
    % open arm - closed arm entries
    NumOpenEntryBegin(mm) = length(Start(OpenEPMEpoch));
    NumCloseEntryBegin(mm) = length(Start(ClosedEPMEpoch));
    
    % open arm - closed arm time
    DurOpenBegin(mm) = sum(Stop(OpenEPMEpoch)-Start(OpenEPMEpoch));
    DurCloseBegin(mm) = sum(Stop(ClosedEPMEpoch)-Start(ClosedEPMEpoch));
    
    % shock vs safe arm cond
    clear DurShockTemp DurSafeTemp
    for ss = 1:length(SessNames.UMazeCond)
        ShockEpoch =  and(SessNames.UMazeCond{ss},ZoneEpoch{1});
        SafeEpoch =  and(SessNames.UMazeCond{ss},ZoneEpoch{2});
        DurShockTemp(ss) =  sum(Stop(ShockEpoch)-Start(ShockEpoch));
        DurSafeTemp(ss) =  sum(Stop(SafeEpoch)-Start(SafeEpoch));
    end
    DurShockCond(mm) = sum(DurShockTemp);
    DurSafeCond(mm) = sum(DurSafeTemp);
    
    % shock vs safe are test
    clear DurShockTemp DurSafeTemp
    for ss = 1:length(SessNames.TestPost)
        ShockEpoch =  and(SessNames.TestPost{ss},ZoneEpoch{1});
        SafeEpoch =  and(SessNames.TestPost{ss},ZoneEpoch{2});
        DurShockTemp(ss) =  sum(Stop(ShockEpoch)-Start(ShockEpoch));
        DurSafeTemp(ss) =  sum(Stop(SafeEpoch)-Start(SafeEpoch));
    end
    DurShockTest(mm) = sum(DurShockTemp);
    DurSafeTest(mm) = sum(DurSafeTemp);
    
    % shock vs safe are test
    clear DurShockTemp DurSafeTemp
    for ss = 1:length(SessNames.TestPre)
        ShockEpoch =  and(SessNames.TestPre{ss},ZoneEpoch{1});
        SafeEpoch =  and(SessNames.TestPre{ss},ZoneEpoch{2});
        DurShockTemp(ss) =  sum(Stop(ShockEpoch)-Start(ShockEpoch));
        DurSafeTemp(ss) =  sum(Stop(SafeEpoch)-Start(SafeEpoch));
    end
    DurShockTestPre(mm) = sum(DurShockTemp);
    DurSafeTestPre(mm) = sum(DurSafeTemp);
    
end

load('AllMiceEPMUmaze.mat')
for k  = 1:4
    
    %     Vals{k} = AllMice.(Titles{k}).CorrEPMTrain(:,1);
    Vals{1}{k} = -AllMice.(Titles{k}).CorrEPMAll(:,1);
    
    %     Vals{k} = AllMice.(Titles{k}).CorrEPMTest(:,1);
    Vals{2}{k} = AllMice.(Titles{k}).MeanEPMTrain(:,1)-AllMice.(Titles{k}).MeanEPMTrain(:,2);
    Vals{3}{k} = AllMice.(Titles{k}).CorrUMazeAll(:,1);
    %     Vals{k} = AllMice.(Titles{k}).CorrUMazeFz(:,1);
    Vals{4}{k} = AllMice.(Titles{k}).MeanUMazeValAll(:,1)-AllMice.(Titles{k}).MeanUMazeValAll(:,2);
    
end




figure
subplot(2,4,1)
v = Vals{1};
b = bar([1,2],nanmean([v{1},v{3}])); hold on
set(b,'FaceColor',[0.6 0.6 0.6])
scatter(ones(1,7),v{1},40,[1:7,],'filled')
scatter(2*ones(1,7),v{3},40,[1:7],'filled')
box off
set(gca,'linewidth',2,'FontSize',12,'XTick',[1,2],'XTickLabel',{'EPM train','UMaze train'})
xtickangle(45)
ylabel('R')
title('EPM corr wi distance')

subplot(2,4,2)
v = Vals{3};
b = bar([1,2],nanmean([v{1},v{3}])); hold on
set(b,'FaceColor',[0.6 0.6 0.6])
scatter(ones(1,7),v{1},40,[1:7,],'filled')
scatter(2*ones(1,7),v{3},40,[1:7],'filled')
box off
set(gca,'linewidth',2,'FontSize',12,'XTick',[1,2],'XTickLabel',{'EPM train','UMaze train'})
xtickangle(45)
ylabel('R')
title('UMaze corr wi distance')

subplot(2,4,3)
XX = 100*((DurOpen./(DurClose+DurOpen)));
b = bar([1],nanmean(XX)); hold on
set(b,'FaceColor',[0.6 0.6 0.6])
scatter(ones(1,7),XX,40,[1:7],'filled')
box off
set(gca,'linewidth',2,'FontSize',12,'XTick',[])
ylabel('% Open time')
title('EPM behavior')

subplot(2,4,4)
XX = 100*((DurShockTest./(DurSafeTest+DurShockTest)));
b = bar([1],nanmean(XX)); hold on
set(b,'FaceColor',[0.6 0.6 0.6])
scatter(ones(1,7),XX,40,[1:7],'filled')
box off
set(gca,'linewidth',2,'FontSize',12,'XTick',[])
ylabel('% Shock time')
title('UMaze behavior')


subplot(2,3,4)
XX = 100*((DurShockTest./(DurSafeTest+DurShockTest)) +(DurOpen./(DurClose+DurOpen)))/2;
vEPM = Vals{1}{3};
vUMaze = Vals{3}{1};
YY = nanmean([vEPM,vUMaze]');
scatter(XX,YY,40,[1:7],'filled')
[R,P] = corr(XX',YY','Type','Spearman')
xlabel('Av. % Open time and % shock time')
ylabel('Av EPM/UMaze corr trained other task')
xlim([0 100])
ylim([-0.2 0.9])
box off
set(gca,'linewidth',2,'FontSize',12)

subplot(2,3,5)
XX = 100*(DurOpen./(DurClose+DurOpen));
YY = Vals{1}{1}';
scatter(XX,YY,40,[1:7],'filled')
[R,P] = corr(XX',YY','Type','Spearman')
xlabel('% Open time')
ylabel('EPM corr - trained EPM')
xlim([0 100])
ylim([-0.2 0.9])
box off
set(gca,'linewidth',2,'FontSize',12)

subplot(2,3,6)
XX = 100*(DurShockTest./(DurSafeTest+DurShockTest));
YY = Vals{3}{3}';
scatter(XX,YY,40,[1:7],'filled')
[R,P] = corr(XX',YY','Type','Spearman')
xlabel('% shock time')
ylabel('UMaze corr - trained UMaze')
xlim([0 100])
ylim([-0.2 0.9])
box off
set(gca,'linewidth',2,'FontSize',12)





figure
v = Vals{1};
b = bar([1,2,3],nanmean([v{2},v{3},v{4}])); hold on
set(b,'FaceColor',[0.6 0.6 0.6])
scatter(ones(1,7),v{2},40,[1:7,],'filled')
scatter(2*ones(1,7),v{3},40,[1:7],'filled')
scatter(3*ones(1,7),v{4},40,[1:7],'filled')
box off
set(gca,'linewidth',2,'FontSize',12,'XTick',[1,2,3],'XTickLabel',{'UMaze Fz','UMazeMov','UMazeAll'})
xtickangle(45)
ylabel('R')
title('EPM corr wi distance')
