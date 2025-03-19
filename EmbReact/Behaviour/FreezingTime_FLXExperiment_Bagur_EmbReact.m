clear all, close all
MouseGroup = {'SAL','FLX','SAL','FLX','FLX-new'}
ZoneNames = {'Shock','Safe','Centre','ShockCentre','SafeCentre'};
SessionNames={'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' };
ClosedDoorEpoch = intervalSet(0,300*1e4);
figure(1);

for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1:2
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            MouseType.(SessionNames{ss}(mm) = strcmp(ExpeInfo.DrugInjected,'FLX');
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            for k=1:5
                Ep = and(and(FreezeEpoch,Behav.ZoneEpoch{k}),ClosedDoorEpoch);
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
        end
        for k=1:5
            FreezingTime.(SessionNames{ss}).(ZoneNames{k})(mm,:)=TempFreezingTime(:,k);
        end
    end
end

Inj = double(Inj);
Inj(2) = 4;

figure(1);
subplot(321)
bar(1,nanmean(nanmean(FreezingTime.UMazeCondBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.UMazeCondBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.UMazeCondBlockedSafe(Inj==0,2)');(FreezingTime.UMazeCondBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])

subplot(322)
bar(1,nanmean(nanmean(FreezingTime.UMazeCondBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.UMazeCondBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.UMazeCondBlockedSafe(Inj==1,2)');(FreezingTime.UMazeCondBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])

FreezingTimePreDrug = FreezingTime;
clear TempFreezingTime FreezingTime AllFz_Freq
SessionNames={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' };
ClosedDoorEpoch = intervalSet(0,300*1e4);
for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1:2
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            Inj(mm) = strcmp(ExpeInfo.DrugInjected,'FLX');
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            for k=1:5
                Ep = and(and(FreezeEpoch,Behav.ZoneEpoch{k}),ClosedDoorEpoch);
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
        end
        for k=1:5
            FreezingTime.(strtok(SessionNames{ss},'_'))(mm,k)=nanmean(TempFreezingTime(:,k));
        end
    end
end

Inj = double(Inj);
Inj(2) = 4;

figure(1);
subplot(323)
bar(1,nanmean(nanmean(FreezingTime.UMazeCondBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.UMazeCondBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.UMazeCondBlockedSafe(Inj==0,2)');(FreezingTime.UMazeCondBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])

subplot(324)
bar(1,nanmean(nanmean(FreezingTime.UMazeCondBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.UMazeCondBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.UMazeCondBlockedSafe(Inj==1,2)');(FreezingTime.UMazeCondBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])
FreezingTimePostDrug = FreezingTime;

clear TempFreezingTime FreezingTime AllFz_Freq
SessionNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
ClosedDoorEpoch = intervalSet(0,300*1e4);
for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1:2
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            Inj(mm) = strcmp(ExpeInfo.DrugInjected,'FLX');
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            for k=1:5
                Ep = and(and(FreezeEpoch,Behav.ZoneEpoch{k}),ClosedDoorEpoch);
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
        end
        for k=1:5
            FreezingTime.(strtok(SessionNames{ss},'_'))(mm,k)=nanmean(TempFreezingTime(1,k));
        end
    end
end

Inj = double(Inj);
Inj(2) = 4;

FreezingTimePostDrugExtPreRappel = FreezingTime;


clear TempFreezingTime FreezingTime AllFz_Freq
SessionNames={'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
ClosedDoorEpoch = intervalSet(0,300*1e4);
for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1:2
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            Inj(mm) = strcmp(ExpeInfo.DrugInjected,'FLX');
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            for k=1:5
                Ep = and(and(FreezeEpoch,Behav.ZoneEpoch{k}),ClosedDoorEpoch);
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
        end
        for k=1:5
            FreezingTime.(strtok(SessionNames{ss},'_'))(mm,k)=nanmean(TempFreezingTime(2,k));
        end
    end
end

Inj = double(Inj);
Inj(2) = 4;

FreezingTimePostDrugExtPostRappel = FreezingTime;

%%%%%%%%%

clear TempFreezingTime FreezingTime AllFz_Freq
SessionNames={'UMazeCondBlockedShock_EyeShock' 'UMazeCondBlockedSafe_EyeShock' };
for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1:2
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            for k=1:5
                Ep = and(FreezeEpoch,Behav.ZoneEpoch{k});
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
            
        end
        
        for k=1:5
            FreezingTime.(strtok(SessionNames{ss},'_'))(mm,k)=nanmean(TempFreezingTime(:,k));
        end
    end
end

figure(3)
subplot(211)
bar(1,nanmean(nanmean(FreezingTime.UMazeCondBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.UMazeCondBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.UMazeCondBlockedSafe(:,2)');(FreezingTime.UMazeCondBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])

FreezingTimeCond = FreezingTime;

clear TempFreezingTime FreezingTime AllFz_Freq
SessionNames={'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock' };
ClosedDoorEpoch = intervalSet(0,300*1e4);
for ss=1:length(SessionNames)
    Files=PathForExperimentsEmbReact(SessionNames{ss});
    
    for mm=1:length(Files.path)
        for c=1
            cd(Files.path{mm}{c})
            load('behavResources_SB.mat')
            
            if not(isempty(Behav.FreezeAccEpoch))
                FreezeEpoch=Behav.FreezeAccEpoch;
            else
                FreezeEpoch=Behav.FreezeEpoch;
            end
            
            FreezeEpoch = and(FreezeEpoch,ClosedDoorEpoch);

                        
            for k=1:5
                Ep = and(FreezeEpoch,Behav.ZoneEpoch{k});
                TempFreezingTime(c,k)=sum(Stop(Ep,'s')-Start(Ep,'s'));
            end
        end
        for k=1:5
            FreezingTime.(strtok(SessionNames{ss},'_'))(mm,k)=nanmean(TempFreezingTime(:,k));
        end
    end
end

figure(3)
subplot(212)
bar(1,nanmean(nanmean(FreezingTime.ExtinctionBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTime.ExtinctionBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTime.ExtinctionBlockedSafe(:,2)');(FreezingTime.ExtinctionBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])
set(gca,'XTick',[1,2],'XTickLabel',{'Safe','Shock'})
box off
ylim([0 250])
FreezingTimeExt = FreezingTime;


%%
figure
subplot(411)
bar(1,nanmean(nanmean(FreezingTimeCond.UMazeCondBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTimeCond.UMazeCondBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimeCond.UMazeCondBlockedSafe(:,2)');(FreezingTimeCond.UMazeCondBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])

bar(4,nanmean(nanmean(FreezingTimePreDrug.UMazeCondBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(5,nanmean(nanmean(FreezingTimePreDrug.UMazeCondBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePreDrug.UMazeCondBlockedSafe(Inj==0,2)');(FreezingTimePreDrug.UMazeCondBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[4,5])

bar(7,nanmean(nanmean(FreezingTimePreDrug.UMazeCondBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(8,nanmean(nanmean(FreezingTimePreDrug.UMazeCondBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePreDrug.UMazeCondBlockedSafe(Inj==1,2)');(FreezingTimePreDrug.UMazeCondBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[7,8])
set(gca,'XTick',[1,2,4,5,7,8],'XTickLabel',{'Safe','Shock'})
text(1.5,240,'1stExp'),text(4.5,240,'SAL'),text(7.5,240,'FLX')
box off
title('Cond - PreDrug')
ylabel('Time freezing (s)')
ylim([0 250])
xlim([0 9])

subplot(412)
bar(1,nanmean(nanmean(FreezingTimeCond.UMazeCondBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTimeCond.UMazeCondBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimeCond.UMazeCondBlockedSafe(:,2)');(FreezingTimeCond.UMazeCondBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])

bar(4,nanmean(nanmean(FreezingTimePostDrug.UMazeCondBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(5,nanmean(nanmean(FreezingTimePostDrug.UMazeCondBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrug.UMazeCondBlockedSafe(Inj==0,2)');(FreezingTimePostDrug.UMazeCondBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[4,5])

bar(7,nanmean(nanmean(FreezingTimePostDrug.UMazeCondBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(8,nanmean(nanmean(FreezingTimePostDrug.UMazeCondBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrug.UMazeCondBlockedSafe(Inj==1,2)');(FreezingTimePostDrug.UMazeCondBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[7,8])
set(gca,'XTick',[1,2,4,5,7,8],'XTickLabel',{'Safe','Shock'})
text(1.5,240,'1stExp'),text(4.5,240,'SAL'),text(7.5,240,'FLX')
box off
ylim([0 250])
xlim([0 9])
title('Cond - PostDrug')
ylabel('Time freezing (s)')

subplot(413)
bar(1,nanmean(nanmean(FreezingTimeExt.ExtinctionBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTimeExt.ExtinctionBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimeExt.ExtinctionBlockedSafe(:,2)');(FreezingTimeExt.ExtinctionBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])

bar(4,nanmean(nanmean(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(5,nanmean(nanmean(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedSafe(Inj==0,2)');(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[4,5])

bar(7,nanmean(nanmean(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(8,nanmean(nanmean(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedSafe(Inj==1,2)');(FreezingTimePostDrugExtPreRappel.ExtinctionBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[7,8])
set(gca,'XTick',[1,2,4,5,7,8],'XTickLabel',{'Safe','Shock'})
text(1.5,240,'1stExp'),text(4.5,240,'SAL'),text(7.5,240,'FLX')
box off
ylim([0 250])
xlim([0 9])
title('Test - PostDrug')
ylabel('Time freezing (s)')

subplot(414)
bar(1,nanmean(nanmean(FreezingTimeExt.ExtinctionBlockedSafe(:,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(2,nanmean(nanmean(FreezingTimeExt.ExtinctionBlockedShock(:,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimeExt.ExtinctionBlockedSafe(:,2)');(FreezingTimeExt.ExtinctionBlockedShock(:,1)')},'distributionColors',[ 0 0 0;0 0 0])

bar(4,nanmean(nanmean(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedSafe(Inj==0,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(5,nanmean(nanmean(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedShock(Inj==0,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedSafe(Inj==0,2)');(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedShock(Inj==0,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[4,5])

bar(7,nanmean(nanmean(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedSafe(Inj==1,2)')),'FaceColor',[0.6 0.6 1]), hold on
bar(8,nanmean(nanmean(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedShock(Inj==1,1)')),'FaceColor',[1 0.6 0.6]), hold on
plotSpread({(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedSafe(Inj==1,2)');(FreezingTimePostDrugExtPostRappel.ExtinctionBlockedShock(Inj==1,1)')},'distributionColors',[ 0 0 0;0 0 0],'xValues',[7,8])
set(gca,'XTick',[1,2,4,5,7,8],'XTickLabel',{'Safe','Shock'})
text(1.5,240,'1stExp'),text(4.5,240,'SAL'),text(7.5,240,'FLX')
box off
ylim([0 250])
xlim([0 9])
title('Test - PostDrug,Rappel')
ylabel('Time freezing (s)')
