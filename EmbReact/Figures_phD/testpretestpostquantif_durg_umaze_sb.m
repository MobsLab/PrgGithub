clear all
SessNames={'TestPre_PreDrug' 'TestPost_PostDrug'};
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};
Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [875,876,877,1001,1002];

CommonSessionNames = {'TestPre','TestPost'};


% Initialize
for drg = 1:length(MouseGroup)
    for SessID = 1 : length(CommonSessionNames)
        
        for testsession = 1:4
            
            OccupMap.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = zeros(101,101);
            
            FreezeTime.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];
            
            ZoneTimeTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];
            
            ZoneTimeTestTot.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];
            
            ZoneNumTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];
            
            FirstZoneTimeTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];
            
                    SpeedDistrib.(CommonSessionNames{SessID}).(MouseGroup{drg}){testsession} = [];

            
        end
    end
end

for ss = 1 : length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[560,117,431,795]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
    if not(isempty(strfind(SessNames{ss},'TestPre')))
        SessID = 1;
    elseif not(isempty(strfind(SessNames{ss},'TestPost')))
        SessID = 2;
    else
        keyboard
    end
    
    
    
    for mm = 1:length(Dir.path)
        for dd = 1:length(Dir.path{mm})
            
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat','Behav')
            load('ExpeInfo.mat')
            
            go=0;

            for grp = 1:length(MouseGroup)
                if not(isempty(find(Mice.(MouseGroup{grp}) == Dir.ExpeInfo{mm}{dd}.nmouse)))
                    group = MouseGroup{grp};
                    go=1;
                    miceid = find(Mice.(MouseGroup{grp}) == Dir.ExpeInfo{mm}{dd}.nmouse);
                end
            end
            
            if go
                if ExpeInfo.SessionNumber==0
                    ExpeInfo.SessionNumber = 1;
                end
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                if not(isempty(Behav.FreezeAccEpoch))
                    Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                end
                
                
                % occupation map
                [OccupMap_temp,xx,yy] = hist2d(Data(Behav.AlignedXtsd),Data(Behav.AlignedYtsd),[0:0.01:1],[0:0.01:1]);
                OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
                OccupMap.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    OccupMap.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} + OccupMap_temp;
                
                % speed
                [YSp,XSp] = hist(log(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeEpoch))),[-15:0.1:1]);
                YSp = YSp/sum(YSp);
                SpeedDistrib.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    [SpeedDistrib.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};YSp];
                
                
                % time in different zones
                for k=1:5
                    ZoneTime(k)=nanmean(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                    ZoneTimeTot(k)=nansum(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                    
                    RealVisit = dropShortIntervals(Behav.ZoneEpochAligned{k},1*1e4);
                    ZoneEntr(k)=length(Stop(RealVisit,'s')-Start(RealVisit,'s'));
                    
                    if not(isempty(Start(RealVisit)))
                        FirstZoneTime(k) =min(Start(RealVisit,'s'));
                    else
                        FirstZoneTime(k) =180;
                    end
                end
                
                ZoneTimeTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    [ZoneTimeTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};ZoneTime];
                ZoneTimeTestTot.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                        [ZoneTimeTestTot.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};ZoneTimeTot];
                ZoneNumTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    [ZoneNumTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};ZoneEntr];
                
                FirstZoneTimeTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    [FirstZoneTimeTest.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};FirstZoneTime];
                
                % freezing time in different zones
                for k=1:5
                    ZoneTime(k)=sum(Stop(and(Behav.FreezeEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeEpoch),'s'));
                end
                FreezeTime.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber} = ...
                    [FreezeTime.(CommonSessionNames{SessID}).(group){ExpeInfo.SessionNumber};ZoneTime];
                
            end
        end
    end
end




    
%% Time spent
clear MeanEntryTime FirstEntryTime MeanStayTime NumberEntries TotFreezeTime TotTime TimeToShockZone

for drg = 1:length(MouseGroup)
    for SessID = 1:length(CommonSessionNames)
        
        for dd = 1:length(OccupMap.(CommonSessionNames{SessID}).(MouseGroup{drg}))
            
            MeanStayTime.(CommonSessionNames{SessID}).(MouseGroup{drg})(dd,:) = (ZoneTimeTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){dd}(:,1));
            
            NumberEntries.(CommonSessionNames{SessID}).(MouseGroup{drg})(dd,:) = (ZoneNumTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){dd}(:,1));
            
            TimeToShockZone.(CommonSessionNames{SessID}).(MouseGroup{drg})(dd,:) = FirstZoneTimeTest.(CommonSessionNames{SessID}).(MouseGroup{drg}){dd}(:,1);
            
            for k = 1:5
                TotTime.(CommonSessionNames{SessID}).(MouseGroup{drg})(k,dd,:) = (ZoneTimeTestTot.(CommonSessionNames{SessID}).(MouseGroup{drg}){dd}(:,k));
                
                TotFreezeTime.(CommonSessionNames{SessID}).(MouseGroup{drg})(k,dd,:) = (FreezeTime.(CommonSessionNames{SessID}).(MouseGroup{drg}){dd}(:,k));
            end
            
        end
    end
end

figure
subplot(121)
A = {nanmean(TimeToShockZone.TestPre.Sal),nanmean(TimeToShockZone.TestPre.Mdz),nanmean(TimeToShockZone.TestPre.Flx),nanmean(TimeToShockZone.TestPre.FlxChr)};
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4],[],1)
set(gca,'xticklabel',{'Sal','Mdz','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('Time to shock zone (s)')
subplot(122)
A = {nanmean(TimeToShockZone.TestPost.Sal),nanmean(TimeToShockZone.TestPost.Mdz),nanmean(TimeToShockZone.TestPost.Flx),nanmean(TimeToShockZone.TestPost.FlxChr)};
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4],[],1)
set(gca,'xticklabel',{'Sal','Mdz','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('Time to shock zone (s)')



% Time spent in each zone
for drg = 1:length(MouseGroup)

TestPreTime.Shock = (squeeze((TotTime.(CommonSessionNames{1}).(MouseGroup{drg})(1,:,:)))+squeeze((TotTime.(CommonSessionNames{1}).(MouseGroup{drg})(4,:,:))))/180;
TestPostTime.Shock = (squeeze((TotTime.(CommonSessionNames{2}).(MouseGroup{drg})(1,:,:)))+squeeze((TotTime.(CommonSessionNames{2}).(MouseGroup{drg})(4,:,:))))/180;

TestPreTime.Safe = (squeeze((TotTime.(CommonSessionNames{1}).(MouseGroup{drg})(2,:,:)))+squeeze((TotTime.(CommonSessionNames{1}).(MouseGroup{drg})(5,:,:))))/180;
TestPostTime.Safe = (squeeze((TotTime.(CommonSessionNames{2}).(MouseGroup{drg})(2,:,:)))+squeeze((TotTime.(CommonSessionNames{2}).(MouseGroup{drg})(5,:,:))))/180;

RatioPre.(MouseGroup{drg})  = (TestPreTime.Shock-TestPreTime.Safe)./(TestPreTime.Shock+TestPreTime.Safe);
RatioPost.(MouseGroup{drg})  = (TestPostTime.Shock-TestPostTime.Safe)./(TestPostTime.Shock+TestPostTime.Safe);

end


figure
subplot(121)
A = {nanmean(RatioPre.Sal),nanmean(RatioPre.Mdz),nanmean(RatioPre.Flx),nanmean(RatioPre.FlxChr)};
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4],[],1)
set(gca,'xticklabel',{'Sal','Mdz','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('Time to shock zone (s)')
figure
subplot(121)
A = {nanmean(TimeToShockZone.TestPost.Sal),nanmean(TimeToShockZone.TestPost.Mdz),nanmean(TimeToShockZone.TestPost.Flx),nanmean(TimeToShockZone.TestPost.FlxChr)};
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4],[],1)
set(gca,'xticklabel',{'Sal','Mdz','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('Time to shock zone (s)')
subplot(122)
A = {nanmean(RatioPost.Sal),nanmean(RatioPost.Mdz),nanmean(RatioPost.Flx),nanmean(RatioPost.FlxChr)};
Cols2 = {[0.6 0.6 0.6],[0.6 1 0.6],[1 0.8 1],[0.6 0.4 0.6]};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2,3,4],[],1)
set(gca,'xticklabel',{'Sal','Mdz','Flx-Ac','Flx-Ch'},'xtick',1:4);
set(gca,'LineWidth',2,'FontSize',15), box off
ylabel('Mod index shock vs safe occupation')
ylim([-1 0.2])
line(xlim,[0 0],'linestyle',':','color','k')








figure
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe')};
subplot(121)
A = {100*nanmean(TestPreTime.Shock),100*nanmean(TestPreTime.Safe)};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2],[],1)
line([A{1}*0+1;A{2}*0+2],[A{1};A{2}],'color',[0.8 0.8 0.8])
ylim([0 100])
[p,h,stats] = signrank(A{1},A{2});
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:2],'XTickLabel',{'Shock','Safe'})
ylim([0 110])
subplot(122)
A = {100*nanmean(TestPostTime.Shock),100*nanmean(TestPostTime.Safe)};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2],[],1)
ylim([0 100])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:2],'XTickLabel',{'Shock','Safe'})
[p,h,stats] = signrank(A{1},A{2});
sigstar({{1,2}},p)
line([A{1}*0+1;A{2}*0+2],[A{1};A{2}],'color',[0.8 0.8 0.8])
ylim([0 110])


figure
clf
Cols2 = {[0.8 0.8 0.8],[0.8 0.8 0.8]};
A = {nanmean(TimeToShockZone.(CommonSessionNames{1})),nanmean(TimeToShockZone.(CommonSessionNames{2}))};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2],[],1)
line([A{1}*0+1;A{2}*0+2],[A{1};A{2}],'color',[0.8 0.8 0.8])
ylim([0 220])
[p,h,stats] = signrank(A{1},A{2});
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:2],'XTickLabel',{'Pre','Post'},'YTick',[0:60:180])
ylabel('Time to shock zone entry (s)')

end
clear all
SessNames={'UMazeCond'};

ReloadData = 1;
XLinPos = [0:0.05:1];

for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[560,117,431,795]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
       
    for mm = 1:length(Dir.path)
        for dd = 1:length(Dir.path{mm})
            
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat','Behav')
            load('ExpeInfo.mat')
            if ExpeInfo.SessionNumber==0
                ExpeInfo.SessionNumber = 1;
            end
            TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch = Behav.FreezeAccEpoch;
            end
            
            % freezing time in different zones
            for k=1:5
                ZoneTime(k)=sum(Stop(and(Behav.FreezeEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeEpoch),'s'))./max(Range(Behav.Vtsd,'s'));
            end
            FreezeTime.(SessNames{ss}){mm}(dd,:) = ZoneTime;
            
                        
        end
    end
end

for mm = 1:length(FreezeTime.UMazeCond)
ZoneFreezing(mm,:) = 100*nanmean(FreezeTime.UMazeCond{mm});
end
A = {(ZoneFreezing(:,1)),(ZoneFreezing(:,4)),(ZoneFreezing(:,3)),(ZoneFreezing(:,5)),(ZoneFreezing(:,2))};
Cols2 = {UMazeColors('shock'),UMazeColors('centershock'),UMazeColors('center'),UMazeColors('centersafe'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1:5],[],1)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:5],'XTickLabel',{'Shock','CenterShock','Center','CenterSafe','Safe'},'YTick',[0:20:60])
ylabel('% time freezing')


nanmean([FreezeTime.TestPost{1}+FreezeTime.TestPost{2}+FreezeTime.TestPost{3}+FreezeTime.TestPost{4}]')

%% Occupation map 
for ss = 1:length(SessNames)
    MeanOcc{ss} = zeros(101,101);
    
    for dd = 1:length(OccupMap.(SessNames{ss}))
        MeanOcc{ss} = MeanOcc{ss} + OccupMap.(SessNames{ss}){dd}./sum(sum(OccupMap.(SessNames{ss}){dd}));
    end
end

figure
for ss = [1,3]
figure
imagesc(log(MeanOcc{ss})'), axis xy
    set(gca,'XTick',[],'YTick',[])
    title(SessNames{ss})
end


%%
clear all

SessNames={'UMazeCond'};

ReloadData = 1;
XLinPos = [0:0.05:1];

for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[560,117,431,795]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
       
    for mm = 1:length(Dir.path)
        for dd = 1:length(Dir.path{mm})
            
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat','Behav')
            load('ExpeInfo.mat')
            if ExpeInfo.SessionNumber==0
                ExpeInfo.SessionNumber = 1;
            end
            TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch = Behav.FreezeAccEpoch;
            end
            
            % freezing time in different zones
            for k=1:5
                ZoneTime(k)=sum(Stop(and(Behav.FreezeEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeEpoch),'s'))./max(Range(Behav.Vtsd,'s'));
            end
            FreezeTime.(SessNames{ss}){mm}(dd,:) = ZoneTime;
            
                        
        end
    end
end

for mm = 1:length(FreezeTime.UMazeCond)
ZoneFreezingPAG(mm,:) = 100*nanmean(FreezeTime.UMazeCond{mm});
end

SessNames={'UMazeCond_EyeShock'  'UMazeCondBlockedShock_EyeShock'  'UMazeCondBlockedSafe_EyeShock',...
     'UMazeCondExplo_PreDrug' 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug',...
     'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};

ReloadData = 1;
XLinPos = [0:0.05:1];

for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    MouseToAvoid=[560,117,431,795]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    
       
    for mm = 1:length(Dir.path)
        for dd = 1:length(Dir.path{mm})
            
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat','Behav')
            load('ExpeInfo.mat')
            if ExpeInfo.SessionNumber==0
                ExpeInfo.SessionNumber = 1;
            end
            go = 1;
            if isfield(ExpeInfo,'DrugInjected')
                if not(strcmp(ExpeInfo.DrugInjected,'SAL'))
                    go=0;
                end
            end
            
            TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch = Behav.FreezeAccEpoch;
            end
            
            % freezing time in different zones
            for k=1:5
                ZoneTime(k)=sum(Stop(and(Behav.FreezeEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeEpoch),'s'))./max(Range(Behav.Vtsd,'s'));
            end
            FreezeTime.(SessNames{ss}){mm}(dd,:) = ZoneTime;
            if go==0
            FreezeTime.(SessNames{ss}){mm}(dd,:) = ZoneTime*NaN;
            end    
        end
    end
end
clear ZoneFreezing ZoneFreezing2
for mm = 1:length(FreezeTime.UMazeCond_EyeShock)
ZoneFreezing(mm,:) = 100*nanmean(FreezeTime.UMazeCond_EyeShock{mm})+100*nanmean(FreezeTime.UMazeCondBlockedShock_EyeShock{mm})+100*nanmean(FreezeTime.UMazeCondBlockedSafe_EyeShock{mm});
end


for mm = 1:length(FreezeTime.UMazeCondExplo_PostDrug)
ZoneFreezing2(mm,:) = 100*nanmean(FreezeTime.UMazeCondExplo_PostDrug{mm})+100*nanmean(FreezeTime.UMazeCondBlockedShock_PostDrug{mm})+100*nanmean(FreezeTime.UMazeCondBlockedSafe_PostDrug{mm});
end
ZoneFreezing = [ZoneFreezing;ZoneFreezing2;ZoneFreezingPAG];

A = {(ZoneFreezing(:,1)),(ZoneFreezing(:,4)),(ZoneFreezing(:,3)),(ZoneFreezing(:,5)),(ZoneFreezing(:,2))};
Cols2 = {UMazeColors('shock'),UMazeColors('centershock'),UMazeColors('center'),UMazeColors('centersafe'),UMazeColors('safe')};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1:5],[],1)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1:5],'XTickLabel',{'Shock','CenterShock','Center','CenterSafe','Safe'},'YTick',[0:20:60])
ylabel('% time freezing')