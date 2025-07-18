clear all
SessNames={'TestPre_PreDrug' 'TestPost_PostDrug' };
cols = summer(10);
cols2 = spring(10);
ReloadData = 1;
XLinPos = [0:0.05:1];

if ReloadData
    
    for ss = 1:2
        Dir=PathForExperimentsEmbReact(SessNames{ss});
        
        for testsession = 1:4
            OccupMap.(SessNames{ss}).Sal{testsession} = zeros(101,101);
            OccupMap.(SessNames{ss}).Flx{testsession} = zeros(101,101);
            
            FreezeTime.(SessNames{ss}).Sal{testsession} = [];
            FreezeTime.(SessNames{ss}).Flx{testsession} = [];
            
            LinPos.(SessNames{ss}).Sal{testsession} = [];
            LinPos.(SessNames{ss}).Flx{testsession} = [];
            
            ZoneTimeTest.(SessNames{ss}).Sal{testsession} = [];
            ZoneTimeTest.(SessNames{ss}).Flx{testsession} = [];
            
            ZoneTimeTestTot.(SessNames{ss}).Sal{testsession} = [];
            ZoneTimeTestTot.(SessNames{ss}).Flx{testsession} = [];
            
            SpeedDistrib.(SessNames{ss}).Sal{testsession} = [];
            SpeedDistrib.(SessNames{ss}).Flx{testsession} = [];
            
            ZoneNumTest.(SessNames{ss}).Sal{testsession} = [];
            ZoneNumTest.(SessNames{ss}).Flx{testsession} = [];
            
            FirstZoneTimeTest.(SessNames{ss}).Sal{testsession} = [];
            FirstZoneTimeTest.(SessNames{ss}).Flx{testsession} = [];
        end
        
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                cd(Dir.path{d}{dd})
                load('behavResources_SB.mat','Behav')
                load('ExpeInfo.mat')
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                
                GoodMouse = 0;
                % get whether its a saline or fluoxetine
                if (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==0
                    MouseGroup = 'Sal';
                    GoodMouse = 1;
                elseif (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==1
                    MouseGroup = 'Flx';
                    GoodMouse = 1;
                end
                
                if GoodMouse
                    % occupation map
                    [OccupMap_temp,xx,yy] = hist2d(Data(Behav.AlignedXtsd),Data(Behav.AlignedYtsd),[0:0.01:1],[0:0.01:1]);
                    OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
                    OccupMap.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        OccupMap.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} + OccupMap_temp;
                    
                    % speed
                    [YSp,XSp] = hist(log(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeAccEpoch))),[-15:0.1:1]);
                    YSp = YSp/sum(YSp);
                    SpeedDistrib.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [SpeedDistrib.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};YSp];
                    
                    
                    % time in different zones
                    for k=1:5
                        ZoneTime(k)=nanmean(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                        ZoneTimeTot(k)=nansum(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                        
                        RealVisit = dropShortIntervals(Behav.ZoneEpochAligned{k},1*1e4);
                        ZoneEntr(k)=length(Stop(RealVisit,'s')-Start(RealVisit,'s'));
                        
                        if not(isempty(Start(RealVisit)))
                            FirstZoneTime(k) =min(Start(RealVisit,'s'));
                        else
                            FirstZoneTime(k) =200;
                        end
                    end
                    ZoneTimeTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [ZoneTimeTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};ZoneTime];
                    ZoneTimeTestTot.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [ZoneTimeTestTot.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};ZoneTimeTot];
                    ZoneNumTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [ZoneNumTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};ZoneEntr];
                    
                    FirstZoneTimeTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [FirstZoneTimeTest.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};FirstZoneTime];
                    
                    % freezing time in different zones
                    for k=1:5
                        ZoneTime(k)=sum(Stop(and(Behav.FreezeAccEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeAccEpoch),'s'));
                    end
                    FreezeTime.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [FreezeTime.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};ZoneTime];
                    
                    
                    % Linear Position
                    [YPos,XPos] = hist(Data(Behav.LinearDist),XLinPos);
                    YPos = YPos/sum(YPos);
                    LinPos.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber} = ...
                        [LinPos.(SessNames{ss}).(MouseGroup){ExpeInfo.SessionNumber};YPos];
                    
                end
            end
        end
    end
    
else
    load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/FLX_TestPreTestPostEffetc.mat')
end

%% Occupation map

for ss = 1:2
    figure
    MeanOcc.Sal{ss} = zeros(101,101);
    MeanOcc.Flx{ss} = zeros(101,101);

    for dd = 1:4
    subplot(2,4,dd)
    imagesc(xx,yy,log(OccupMap.(SessNames{ss}).Sal{dd}')),axis xy
    MeanOcc.Sal{ss} = MeanOcc.Sal{ss} + OccupMap.(SessNames{ss}).Sal{dd}./sum(sum(OccupMap.(SessNames{ss}).Sal{dd}));
    title(strtok(SessNames{ss},'_'))
    subplot(2,4,dd+4)
    imagesc(xx,yy,log(OccupMap.(SessNames{ss}).Flx{dd}')),axis xy
    MeanOcc.Flx{ss} = MeanOcc.Flx{ss} + OccupMap.(SessNames{ss}).Flx{dd}./sum(sum(OccupMap.(SessNames{ss}).Flx{dd}));
    end
end

figure
subplot(221)
imagesc(log(MeanOcc.Sal{1})'), axis xy
title('SALINE')
set(gca,'XTick',[],'YTick',[])
ylabel('Pre')
subplot(222)
imagesc(log(MeanOcc.Flx{1})'), axis xy
title('FLUOXETINE')
set(gca,'XTick',[],'YTick',[])
subplot(223)
imagesc(log(MeanOcc.Sal{2})'), axis xy
set(gca,'XTick',[],'YTick',[])
ylabel('Post')
subplot(224)
imagesc(log(MeanOcc.Flx{2})'), axis xy
set(gca,'XTick',[],'YTick',[])

%% Time spent
clear MeanEntryTime FirstEntryTime MeanStayTime NumberEntries TotFreezeTime TotTime
for ss = 1:2
    AllSalSp.(SessNames{ss}) = zeros(4,161);
    AllFlxSp.(SessNames{ss}) = zeros(4,161);
    for dd = 1:4
        MeanEntryTime.(SessNames{ss}).Sal(dd,:) = (FirstZoneTimeTest.(SessNames{ss}).Sal{dd}(:,1));
        MeanEntryTime.(SessNames{ss}).Flx(dd,:) = (FirstZoneTimeTest.(SessNames{ss}).Flx{dd}(:,1));
        
        MeanStayTime.(SessNames{ss}).Sal(dd,:) = (ZoneTimeTest.(SessNames{ss}).Sal{dd}(:,1));
        MeanStayTime.(SessNames{ss}).Flx(dd,:) = (ZoneTimeTest.(SessNames{ss}).Flx{dd}(:,1));
        
        NumberEntries.(SessNames{ss}).Sal(dd,:) = (ZoneNumTest.(SessNames{ss}).Sal{dd}(:,1));
        NumberEntries.(SessNames{ss}).Flx(dd,:) = (ZoneNumTest.(SessNames{ss}).Flx{dd}(:,1));
        
        TotFreezeTime.(SessNames{ss}).Sal(dd,:) = nansum(FreezeTime.(SessNames{ss}).Sal{dd}');
        TotFreezeTime.(SessNames{ss}).Flx(dd,:) =  nansum(FreezeTime.(SessNames{ss}).Flx{dd}');
        
        for k = 1:5
            TotTime.(SessNames{ss}).Sal(k,dd,:) = (ZoneTimeTestTot.(SessNames{ss}).Sal{dd}(:,k));
            TotTime.(SessNames{ss}).Flx(k,dd,:) = (ZoneTimeTestTot.(SessNames{ss}).Flx{dd}(:,k));
        end
        
        AllSalSp.(SessNames{ss}) = AllSalSp.(SessNames{ss})+SpeedDistrib.(SessNames{ss}).Sal{dd};
        AllFlxSp.(SessNames{ss}) = AllFlxSp.(SessNames{ss})+SpeedDistrib.(SessNames{ss}).Flx{dd};
        
    end
end

% Time spent zone per zone
for ss = 1:2
subplot(2,6,1+(ss-1)*6:3+(ss-1)*6)
SalTotTime = squeeze(nanmean(TotTime.(SessNames{ss}).Sal,2))/180;
SalTotTime = SalTotTime([1,4,3,5,2],:);
FlxTotTime = squeeze(nanmean(TotTime.(SessNames{ss}).Flx,2))/180;
FlxTotTime = FlxTotTime([1,4,3,5,2],:);
bar(-1,1,'Facecolor',[0.4 0.4 0.4]);hold on
bar(-1,2,'Facecolor',[0.6 0.6 0.6]);

for  k=1:5
    bar((k-1)*3+1,nanmean(SalTotTime(k,:)),'Facecolor',[0.4 0.4 0.4]),hold on
    plot((k-1)*3+1,SalTotTime(k,:),'.k','MarkerSize',10)
end

for  k=1:5
    bar((k-1)*3+2,nanmean(FlxTotTime(k,:)),'Facecolor',[0.6 0.6 0.6]),hold on
    plot((k-1)*3+2,FlxTotTime(k,:),'.k','MarkerSize',10)
end
set(gca,'XTick',[1:5]*3-1,'XTickLabel',{'Shock','ShockCentre','Centre','SafeCentre','Safe'})
ylabel('% time per zone')
ylim([0 1])
xlim([-0.2 15.2])
legend('Sal','Flx','Location','NorthWest')

% Mean EntryTime
subplot(2,6,4+(ss-1)*6)
SalEntryTime = squeeze(nanmean(MeanEntryTime.(SessNames{ss}).Sal,2));
FlxEntryTime = squeeze(nanmean(MeanEntryTime.(SessNames{ss}).Flx,2));

bar(1,nanmean(SalEntryTime),'Facecolor',[0.4 0.4 0.4]),hold on
plot(1,SalEntryTime,'.k','MarkerSize',10)

bar(2,nanmean(FlxEntryTime),'Facecolor',[0.6 0.6 0.6]),hold on
plot(2,FlxEntryTime,'.k','MarkerSize',10)

set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
ylabel('mean entry time')
ylim([0 210])

% Number of entries
subplot(2,6,5+(ss-1)*6)
bar(1,nanmean(NumberEntries.(SessNames{ss}).Sal(:)),'Facecolor',[0.4 0.4 0.4]),hold on
plot(1,nanmean(NumberEntries.(SessNames{ss}).Sal),'.k','MarkerSize',10)
bar(2,nanmean(NumberEntries.(SessNames{ss}).Flx(:)),'Facecolor',[0.6 0.6 0.6]),hold on
plot(2,nanmean(NumberEntries.(SessNames{ss}).Flx),'.k','MarkerSize',10)
set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
ylabel('number of entries')
ylim([0 6])

subplot(2,6,6+(ss-1)*6)
SalStayTime = squeeze(nanmean(MeanStayTime.(SessNames{ss}).Sal,2));
FlxStayTime = squeeze(nanmean(MeanStayTime.(SessNames{ss}).Flx,2));

bar(1,nanmean(SalStayTime),'Facecolor',[0.4 0.4 0.4]),hold on
plot(1,SalStayTime,'.k','MarkerSize',10)

bar(2,nanmean(FlxStayTime),'Facecolor',[0.6 0.6 0.6]),hold on
plot(2,FlxStayTime,'.k','MarkerSize',10)

set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
ylabel('mean stay time')
ylim([0 22])
end

for mm=1:4
    FirstEntrySession = find(MeanEntryTime.Sal(:,mm)<200,1,'first');
    if isempty(FirstEntrySession)
        FirstEntryTime.Sal(mm) = 180*4;
    else
        FirstEntryTime.Sal(mm) = MeanEntryTime.Sal(FirstEntrySession,mm)+180*(FirstEntrySession-1);
    end

    
    FirstEntrySession = find(MeanEntryTime.Flx(:,mm)<200,1,'first');
    if isempty(FirstEntrySession)
         FirstEntryTime.Flx(mm) = 180*4;
    else
    FirstEntryTime.Flx(mm) = MeanEntryTime.Flx(FirstEntrySession,mm)+180*(FirstEntrySession-1);
    end
end

%% Time spent freezing
figure
for ss = 1:2
    subplot(1,2,ss)
    
    
    bar(1,nanmean(TotFreezeTime.(SessNames{ss}).Sal(:)),'Facecolor',[0.4 0.4 0.4]),hold on
    plot(1,nanmean(TotFreezeTime.(SessNames{ss}).Sal,2),'.k','MarkerSize',10)
    
    bar(2,nanmean(TotFreezeTime.(SessNames{ss}).Flx(:)),'Facecolor',[0.6 0.6 0.6]),hold on
    plot(2,nanmean(TotFreezeTime.(SessNames{ss}).Flx,2),'.k','MarkerSize',10)
    
    title(strtok(SessNames{ss},'_'))
    ylabel('Shock-Safe')
    ylim([-1.1 1.1])
    ylabel('Total time spent freezing (s)')
    
    set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})
   ylim([0 20]) 
end

%% Shock vs Safe Ratio
figure
for ss = 1:2
    SalTime = squeeze(nanmean(TotTime.(SessNames{ss}).Sal(1:2,:,:),2))';
    FlxTime = squeeze(nanmean(TotTime.(SessNames{ss}).Flx(1:2,:,:),2))';
    AvSal = (SalTime(:,1)-SalTime(:,2))./(SalTime(:,1)+SalTime(:,2));
    AvFlx = (FlxTime(:,1)-FlxTime(:,2))./(FlxTime(:,1)+FlxTime(:,2));
    subplot(1,2,ss)
    bar(1,nanmean(AvSal),'Facecolor',[0.4 0.4 0.4]),hold on
plot(1,AvSal,'.k','MarkerSize',10)
bar(2,nanmean(AvFlx),'Facecolor',[0.6 0.6 0.6]),hold on
plot(2,AvFlx,'.k','MarkerSize',10)

    title(strtok(SessNames{ss},'_'))
    ylabel('Shock-Safe')
    ylim([-1.1 1.1])
    set(gca,'XTick',[1:2],'XTickLabel',{'SAL','FLX'})

end

