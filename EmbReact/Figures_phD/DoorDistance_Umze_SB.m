clear all
Freez = 0;
figure
Files1=PathForExperimentsEmbReact('HabituationBlockedShock_PreDrug');
Files2=PathForExperimentsEmbReact('HabituationBlockedShock_EyeShock');

Dir = MergePathForExperiment_SB(Files1,Files2);

for mm=1:length(Dir.path)
    
    for dd = 1:length(Dir.path{mm})
        cd(Dir.path{mm}{dd})
        
        
        load('behavResources_SB.mat')
        load('ExpeInfo.mat')
        
        go=0;
        if isfield(Dir.ExpeInfo{mm}{dd},'DrugInjected')
            if strcmp(Dir.ExpeInfo{mm}{dd}.DrugInjected,'SAL')
                go=1;
            end
        else
            go=1;
        end
        
        if go
            
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.01:1]);
            
            Dist.Hab.Shock{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Hab.Shock(mm,dd)=nanmean(Data(Behav.LinearDist)-Params.DoorPos(1)).^2;
            
            
        else
            MeanDist.Hab.Shock(mm,dd) = NaN;
        end
    end
end

Files1=PathForExperimentsEmbReact('HabituationBlockedSafe_PreDrug');
Files2=PathForExperimentsEmbReact('HabituationBlockedSafe_EyeShock');
Dir = MergePathForExperiment_SB(Files1,Files2);

for mm=1:length(Dir.path)
    for dd = 1:length(Dir.path{mm})
        cd(Dir.path{mm}{dd})
        load('behavResources_SB.mat')
        load('ExpeInfo.mat')
        go=0;
        if isfield(Dir.ExpeInfo{mm}{dd},'DrugInjected')
            if strcmp(Dir.ExpeInfo{mm}{dd}.DrugInjected,'SAL')
                go=1;
            end
        else
            go=1;
        end
        
        if go
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.01:1]);
            
            Dist.Hab.Safe{mm}(dd,:)=Y/sum(Y);
            MeanDist.Hab.Safe(mm,dd)=nanmean(Data(Behav.LinearDist)-Params.DoorPos(2)).^2;
            
            
        else
            MeanDist.Hab.Safe(mm,dd) = NaN;
        end
    end
end


Files1=PathForExperimentsEmbReact('ExtinctionBlockedShock_PostDrug');
Files2=PathForExperimentsEmbReact('ExtinctionBlockedShock_EyeShock');
Dir = MergePathForExperiment_SB(Files1,Files2);

for mm=1:length(Dir.path)
    
    for dd = 1:length(Dir.path{mm})
        cd(Dir.path{mm}{dd})
        load('behavResources_SB.mat')
        load('ExpeInfo.mat')
        go=0;
        if isfield(Dir.ExpeInfo{mm}{dd},'DrugInjected')
            if strcmp(Dir.ExpeInfo{mm}{dd}.DrugInjected,'SAL')
                go=1;
            end
        else
            go=1;
        end
        
        if go
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.01:1]);
            
            Dist.Ext.Shock{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Ext.Shock(mm,dd)=nanmean(Data(Behav.LinearDist)-Params.DoorPos(1)).^2;
        else
            MeanDist.Ext.Shock(mm,dd)=NaN;
        end
    end
end

Files1=PathForExperimentsEmbReact('ExtinctionBlockedSafe_PostDrug');
Files2=PathForExperimentsEmbReact('ExtinctionBlockedSafe_EyeShock');
Dir = MergePathForExperiment_SB(Files1,Files2);


for mm=1:length(Dir.path)
    for dd = 1:length(Dir.path{mm})
        
        cd(Dir.path{mm}{dd})
        load('behavResources_SB.mat')
        load('ExpeInfo.mat')
        go=0;
        if isfield(Dir.ExpeInfo{mm}{dd},'DrugInjected')
            if strcmp(Dir.ExpeInfo{mm}{dd}.DrugInjected,'SAL')
                go=1;
            end
        else
            go=1;
        end
        
        if go
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.01:1]);
            
            Dist.Ext.Safe{mm}(dd,:)=Y/sum(Y);
            MeanDist.Ext.Safe(mm,dd)=nanmean(Data(Behav.LinearDist)-Params.DoorPos(2)).^2;
        else
            MeanDist.Ext.Safe(mm,dd)=NaN;
            
        end
    end
end
MeanDist.Ext.Safe(MeanDist.Ext.Safe==0)=NaN
MeanDist.Ext.Shock(MeanDist.Ext.Shock==0)=NaN
figure
Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
subplot(121)
A = {MeanDist.Hab.Shock,MeanDist.Hab.Safe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
ylim([0 0.04])
line([A{1}'*0+1;A{2}'*0+2],[A{1}';A{2}'],'color',[0.8 0.8 0.8])
[p,h,stats] = signrank(A{1},A{2})
sigstar({{1,2}},p)
set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
title('Pre')
subplot(122)
A = {nanmean(MeanDist.Ext.Shock,2),nanmean(MeanDist.Ext.Safe,2)};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
ylim([0 0.04])
line([A{1}'*0+1;A{2}'*0+2],[A{1}';A{2}'],'color',[0.8 0.8 0.8])
[p,h,stats] = signrank(A{1},A{2})
sigstar({{1,2}},p)
set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
title('Post')

figure
subplot(211)
for mm = 1:length(Dist.Hab.Safe)
    try
    stairs([0:0.01:1],100*Dist.Hab.Safe{mm},'color',UMazeColors('Safe'),'linewidth',3), hold on
    
    stairs([0:0.01:1],100*Dist.Hab.Shock{mm},'color',UMazeColors('Shock'),'linewidth',3), hold on
    end
end
ylim([0 100])
line([0.75 0.75],ylim,'color','k')
line([0.25 0.25],ylim,'color','k')
xlabel('Linearized distance')
set(gca,'Linewidth',2,'FontSize',10)
box off
subplot(212)
for mm = 1:length(Dist.Hab.Safe)
    try
    stairs([0:0.01:1],100*nanmean(Dist.Ext.Safe{mm},1),'color',UMazeColors('Safe'),'linewidth',3), hold on
    
    stairs([0:0.01:1],100*nanmean(Dist.Ext.Shock{mm},1),'color',UMazeColors('Shock'),'linewidth',3), hold on
    end
end
ylim([0 100])
line([0.75 0.75],ylim,'color','k')
line([0.25 0.25],ylim,'color','k')
xlabel('Linearized distance')
set(gca,'Linewidth',2,'FontSize',10)
box off
