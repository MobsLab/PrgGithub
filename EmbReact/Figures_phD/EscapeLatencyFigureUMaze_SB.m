clear all
SessNames = {'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};


for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    
    
    for k = 1:3
        EscapeLatency.Zone.(SessNames{ss}){k} = [];
        EscapeLatency.Zone.(SessNames{ss}){k}  = [];
        EscapeLatency.ZoneAligned.(SessNames{ss}){k} = [];
        EscapeLatency.ZoneAligned.(SessNames{ss}){k} = [];
    end
    
    for d=1:length(Dir.path)
        for dd=1:min([4,length(Dir.path{d})])
            
            go=0;
            if isfield(Dir.ExpeInfo{d}{dd},'DrugInjected')
                if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'SAL') | strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'FLX-Ineff') 
                    go=1;
                end
            else
                go=1;
            end
            
            if go ==1
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                clear Params Behav NoDoorEpoch
                load('behavResources_SB.mat','Params','Behav')
                load('ExpeInfo.mat')
                for k = 1:3
                    tempZone(dd,k) = Behav.EscapeLat.ZoneEpoch(k);
                    tempZoneA(dd,k) = Behav.EscapeLat.ZoneEpochAligned(k);
                end
                
                
            end
        end
                    if go ==1

            for k = 1:3
                EscapeLatency.Zone.(SessNames{ss}){k} = [ EscapeLatency.Zone.(SessNames{ss}){k},nanmean(tempZone(:,k))];
                EscapeLatency.ZoneAligned.(SessNames{ss}){k} = [ EscapeLatency.ZoneAligned.(SessNames{ss}){k},nanmean(tempZoneA(:,k))];
            end
            clear tempZone tempZoneA

                    end
        
        
        
    end
end

figure
k=2;
subplot(121)
A = {EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug{k},EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug{k}};
Cols2 = {UMazeColors('Shock'),UMazeColors('Safe')}
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2])
set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
ylim([0 20])
ylabel('Escape latency (s)')
try,[p,h,stats] = signrank(EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug{k},EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug{k});
    sigstar({{1,2}},p),end
ylim([0 200])

subplot(122)
A = {EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug{k},EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug{k}};
MakeSpreadAndBoxPlot_SB(A,Cols2,[1,2])
set(gca,'XTick',[1:2],'XTickLabel',{'Shock','Safe'},'Linewidth',2,'FontSize',10)
ylabel('Escape latency (s)')
ylim([0 210])
try,[p,h,stats] = signrank(EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug{k},EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug{k});
    sigstar({{1,2}},p),end


figure
close all
figure(1);
figure(2);
for ZoneType = 1:2
    
    SalSafe = [EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Sal{ZoneType}{2}];
    
    SalShock = [EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Sal{ZoneType}{2}];
    
    FlxSafe = [EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Flx{ZoneType}{2}];
    
    FlxShock = [EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Flx{ZoneType}{2}];
    
    figure(1)
    subplot(2,1,ZoneType)
    errorbar(1,mean(SalSafe(1,:)'),stdError(SalSafe(1,:)'),'b','linewidth',2)
    hold on
    errorbar(1,mean(SalShock(1,:)'),stdError(SalShock(1,:)'),'r','linewidth',2)
    errorbar(1,mean(FlxSafe(1,:)'),stdError(FlxSafe(1,:)'),'b','linewidth',2,'linestyle',':')
    hold on
    errorbar(1,mean(FlxShock(1,:)'),stdError(FlxShock(1,:)'),'r','linewidth',2,'linestyle',':')
    errorbar(2:7,mean(SalSafe(2:7,:)'),stdError(SalSafe(2:7,:)'),'b','linewidth',2)
    hold on
    errorbar(2:7,mean(SalShock(2:7,:)'),stdError(SalShock(2:7,:)'),'r','linewidth',2)
    errorbar(2:7,mean(FlxSafe(2:7,:)'),stdError(FlxSafe(2:7,:)'),'b','linewidth',2,'linestyle',':')
    hold on
    errorbar(2:7,mean(FlxShock(2:7,:)'),stdError(FlxShock(2:7,:)'),'r','linewidth',2,'linestyle',':')
    ylim([-10 230]),xlim([0 7.5])
    set(gca,'XTick',[1,2.5,4.5,6.5],'XTickLabel',{'Hab','CondPreDrug','CondPostDrug','ExtPostDrug'})
    line([3.5 3.5],ylim,'color','k','linewidth',3)
    text(3.7,210,'Injection')
    ylabel('Escape Latency (s)')
    if ZoneType ==1
        legend({'Safe-SAL','Shock-SAL','Safe-FLX','Shock-FLX'})
    end
    %     [p,Table,stats] = anova2([FlxShock(4:end,:)';SalShock(4:end,:)'],4);
    %     figure(1)
    %     if p(2)<0.05
    %         text(5.5,210,'*','color','r')
    %     end
    %     [p,Table,stats] = anova2([FlxSafe(4:end,:)';SalSafe(4:end,:)'],4);
    %     figure(1)
    %     if p(2)<0.05
    %         text(5,215,'*','color','b')
    %     end
    %
    figure(2)
    subplot(2,2,(ZoneType-1)*2+1)
    PlotErrorSpreadN_KJ([reshape(SalSafe(4:end,:),16,1),reshape(FlxSafe(4:end,:),16,1)],'newfig',0)
    ylabel('Escape Latency (s)')
    if ZoneType ==1
        title('Safe')
    end
    ylim([-10 230])
    set(gca,'XTick',[1,2],'XTickLabel',{'SAL','FLX'})
    
    subplot(2,2,(ZoneType-1)*2+2)
    PlotErrorSpreadN_KJ([reshape(SalShock(4:end,:),16,1),reshape(FlxShock(4:end,:),16,1)],'newfig',0)
    if ZoneType ==1
        title('Shock')
    end
    ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'SAL','FLX'})
    
    figure
    errorbar(1:7,mean(SalSafe'),stdError(SalSafe'),'b','linewidth',2)
    hold on
    errorbar(1:7,mean(SalShock'),stdError(SalShock'),'r','linewidth',2)
    set(gca,'XTick',[1,2.5,4.5,6.5],'XTickLabel',{'Hab','CondPreDrug','CondPostDrug','ExtPostDrug'})
    ylabel('Escape Latency (s)')
    ylim([-10 230]),xlim([0 7.5])
    
    
end

close all
figure;
for ZoneType = 2
    
    SalSafe = [EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Sal{ZoneType}{2}];
    
    SalShock = [EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Sal{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Sal{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Sal{ZoneType}{2}];
    
    FlxSafe = [EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.Flx{ZoneType}{2}];
    
    FlxShock = [EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.Flx{ZoneType}{2};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Flx{ZoneType}{1};...
        EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.Flx{ZoneType}{2}];
    
    subplot(1,4,1:2)
    errorbar(1,mean(SalSafe(1,:)'),stdError(SalSafe(1,:)'),'b','linewidth',2)
    hold on
    errorbar(1,mean(SalShock(1,:)'),stdError(SalShock(1,:)'),'r','linewidth',2)
    errorbar(1,mean(FlxSafe(1,:)'),stdError(FlxSafe(1,:)'),'b','linewidth',2,'linestyle',':')
    hold on
    errorbar(1,mean(FlxShock(1,:)'),stdError(FlxShock(1,:)'),'r','linewidth',2,'linestyle',':')
    errorbar(2:7,mean(SalSafe(2:7,:)'),stdError(SalSafe(2:7,:)'),'b','linewidth',2)
    hold on
    errorbar(2:7,mean(SalShock(2:7,:)'),stdError(SalShock(2:7,:)'),'r','linewidth',2)
    errorbar(2:7,mean(FlxSafe(2:7,:)'),stdError(FlxSafe(2:7,:)'),'b','linewidth',2,'linestyle',':')
    hold on
    errorbar(2:7,mean(FlxShock(2:7,:)'),stdError(FlxShock(2:7,:)'),'r','linewidth',2,'linestyle',':')
    ylim([-10 230]),xlim([0 7.5])
    set(gca,'XTick',[1,2.5,4.5,6.5],'XTickLabel',{'Hab','CondPreDrug','CondPostDrug','ExtPostDrug'})
    line([3.5 3.5],ylim,'color','k','linewidth',3)
    text(3.7,210,'Injection')
    ylabel('Escape Latency (s)')
        legend({'Safe-SAL','Shock-SAL','Safe-FLX','Shock-FLX'})
   
    
    subplot(1,4,3)
    PlotErrorSpreadN_KJ([reshape(SalSafe(4:end,:),16,1),reshape(FlxSafe(4:end,:),16,1)],'newfig',0)
    ylabel('Escape Latency (s)')
        title('Safe')
    
    ylim([-10 230])
    set(gca,'XTick',[1,2],'XTickLabel',{'SAL','FLX'})
    
    subplot(1,4,4)
    PlotErrorSpreadN_KJ([reshape(SalShock(4:end,:),16,1),reshape(FlxShock(4:end,:),16,1)],'newfig',0)
            ylabel('Escape Latency (s)')
title('Shock')
    ylim([0 30])
    set(gca,'XTick',[1,2],'XTickLabel',{'SAL','FLX'})
    
    
    
end






