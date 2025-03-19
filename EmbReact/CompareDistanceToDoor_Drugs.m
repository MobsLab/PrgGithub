clear all
Freez = 1;
Dir=PathForExperimentsEmbReact('UMazeCondBlockedShock_PostDrug');

for mm = 1:length(Dir.path)-2
    try
        VarCond.DrugType{mm} = Dir.ExpeInfo{mm}{1}.DrugInjected;
        VarCond.MouseID(mm) = Dir.ExpeInfo{mm}{1}.nmouse;
        
        
        for dd = 1:length(Dir.path{mm})
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            go=0;
            
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.05:1]);
            
            Dist.Cond.Shock{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Cond.Shock(mm,dd)=nanmean(abs(Data(Behav.LinearDist)-Params.DoorPos(1)));
        end
    catch
        keyboard
    end
end

Dir=PathForExperimentsEmbReact('UMazeCondBlockedSafe_PostDrug');

for mm = 1:length(Dir.path)-2
    try
        VarCond.DrugType{mm} = Dir.ExpeInfo{mm}{1}.DrugInjected;
        VarCond.MouseID(mm) = Dir.ExpeInfo{mm}{1}.nmouse;
        
        
        for dd = 1:length(Dir.path{mm})
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            go=0;
            
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.05:1]);
            
            Dist.Cond.Safe{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Cond.Safe(mm,dd)=nanmean(abs(Data(Behav.LinearDist)-Params.DoorPos(2)));
        end
    catch
        keyboard
    end
end

Dir=PathForExperimentsEmbReact('ExtinctionBlockedSafe_PostDrug');

for mm = 1:length(Dir.path)-2
    try
        VarCond.DrugType{mm} = Dir.ExpeInfo{mm}{1}.DrugInjected;
        VarCond.MouseID(mm) = Dir.ExpeInfo{mm}{1}.nmouse;
        
        
        for dd = 1:length(Dir.path{mm})
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            go=0;
            
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.05:1]);
            
            Dist.Ext.Safe{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Ext.Safe(mm,dd)=nanmean(abs(Data(Behav.LinearDist)-Params.DoorPos(2)));
        end
    catch
        keyboard
    end
end

Dir=PathForExperimentsEmbReact('ExtinctionBlockedShock_PostDrug');

for mm = 1:length(Dir.path)-2
    try
        VarCond.DrugType{mm} = Dir.ExpeInfo{mm}{1}.DrugInjected;
        VarCond.MouseID(mm) = Dir.ExpeInfo{mm}{1}.nmouse;
        
        
        for dd = 1:length(Dir.path{mm})
            cd(Dir.path{mm}{dd})
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            go=0;
            
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            
            if Freez
                Behav.LinearDist = Restrict(Behav.LinearDist,and(intervalSet(0,280*1e4),Behav.FreezeEpoch));
            else
                Behav.LinearDist = Restrict(Behav.LinearDist,intervalSet(0,280*1e4));
            end
            [Y,X]=hist(Data(Behav.LinearDist),[0:0.05:1]);
            
            Dist.Ext.Shock{mm}(dd,:)=Y/sum(Y);
            
            MeanDist.Ext.Shock(mm,dd)=nanmean(abs(Data(Behav.LinearDist)-Params.DoorPos(1)));
        end
    catch
        keyboard
    end
end

VarCond.DrugType{find(VarCond.MouseID ==11184)} = 'DIAZEPAM';
MiceID.DZP = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarCond.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarCond.DrugType,'FLX'))));
MiceID.FlxAc(ismember(MiceID.FlxAc,MiceID.FlxCh)) = [];
MiceID.SALEarly = MiceID.SAL(1:7);
MiceID.SALLate= MiceID.SAL(8:end);
DrugTypes = {'SALEarly','SALLate','FlxCh','FlxAc','DZP'};

figure
% MeanDist.Ext.Safe(MeanDist.Ext.Safe==0)=NaN
% MeanDist.Ext.Shock(MeanDist.Ext.Shock==0)=NaN
for dd = 1:length(DrugTypes)
    
    Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
    subplot(5,2,(dd-1)*2+1)
    A = {nanmean(MeanDist.Cond.Shock(MiceID.(DrugTypes{dd}),:),2),nanmean(MeanDist.Cond.Safe(MiceID.(DrugTypes{dd}),:),2)};
    MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},0)
    ylim([0 0.2])
    line([A{1}'*0+1;A{2}'*0+2],[A{1}';A{2}'],'color',[0.8 0.8 0.8])
    % [p,h,stats] = signrank(A{1},A{2})
    % sigstar({{1,2}},p)
    set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
    title('Cond')
    
    subplot(5,2,(dd-1)*2+2)
    A = {nanmean(MeanDist.Ext.Shock(MiceID.(DrugTypes{dd}),:),2),nanmean(MeanDist.Ext.Safe(MiceID.(DrugTypes{dd}),:),2)};
    MakeSpreadAndBoxPlot_SB(A,Cols,1:2,{},0)
    ylim([0 0.2])
    line([A{1}'*0+1;A{2}'*0+2],[A{1}';A{2}'],'color',[0.8 0.8 0.8])
    % [p,h,stats] = signrank(A{1},A{2})
    % sigstar({{1,2}},p)
    set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
    title('Ext')
end

figure
for dd = 1:length(DrugTypes)
    
    subplot(5,2,(dd-1)*2+1)
    All = [];
    for mm = 1:length(MiceID.(DrugTypes{dd}))
        All = [All;100*Dist.Cond.Safe{MiceID.(DrugTypes{dd})(mm)}];
    end
    
    stairs([0:0.05:1],nanmean(All)','color',UMazeColors('Safe'),'linewidth',3), hold on
    ylim([0 20])
    All = [];
    for mm = 1:length(MiceID.(DrugTypes{dd}))
        All = [All;100*Dist.Cond.Shock{MiceID.(DrugTypes{dd})(mm)}];
    end
    stairs([0:0.05:1],nanmean(All)','color',UMazeColors('Shock'),'linewidth',3), hold on
    ylim([0 20])
    
    
    subplot(5,2,(dd-1)*2+2)
    All = [];
    for mm = 1:length(MiceID.(DrugTypes{dd}))
        All = [All;100*Dist.Ext.Safe{MiceID.(DrugTypes{dd})(mm)}];
    end
    
    stairs([0:0.05:1],nanmean(All)','color',UMazeColors('Safe'),'linewidth',3), hold on
    ylim([0 20])
    
    All = [];
    for mm = 1:length(MiceID.(DrugTypes{dd}))
        All = [All;100*Dist.Ext.Shock{MiceID.(DrugTypes{dd})(mm)}];
    end
    stairs([0:0.05:1],nanmean(All)','color',UMazeColors('Shock'),'linewidth',3), hold on
    ylim([0 20])
    
end


figure
% MeanDist.Ext.Safe(MeanDist.Ext.Safe==0)=NaN
% MeanDist.Ext.Shock(MeanDist.Ext.Shock==0)=NaN
for dd = 1:length(DrugTypes)
    Cols = {UMazeColors('Shock'),UMazeColors('Safe')}
    A{dd} = nanmean(MeanDist.Ext.Safe(MiceID.(DrugTypes{dd}),:),2);
end
