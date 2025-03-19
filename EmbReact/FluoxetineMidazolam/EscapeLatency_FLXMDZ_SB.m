clear all
SessNames = {'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

MouseGroup = {'Sal','Mdz','Flx','FlxChr'};

Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [876,877];

for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for mg = 1:length(MouseGroup)
        Files.(MouseGroup{mg}) = cell(1,length(Mice.(MouseGroup{mg})));
    end
    
    
    for d = 1:length(Dir.path)
        
        for mg = 1:length(MouseGroup)
            
            if sum(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))
                
                for p = 1:length(Dir.path{d})
                    Files.(MouseGroup{mg}){find(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                end
            end
        end
    end
    
    
    for mg = 1:length(MouseGroup)
        
        for dd = 1:4
            for k = 1:3
                EscapeLatency.Zone.(SessNames{ss}).(MouseGroup{mg}){k}{dd} = [];
                EscapeLatency.Zone.(SessNames{ss}).(MouseGroup{mg}){k}{dd}  = [];
                EscapeLatency.ZoneAligned.(SessNames{ss}).(MouseGroup{mg}){k}{dd} = [];
                EscapeLatency.ZoneAligned.(SessNames{ss}).(MouseGroup{mg}){k}{dd} = [];
            end
        end
    end
    
    for mg = 1:length(MouseGroup)
        
        for mm = 1:length(Files.(MouseGroup{mg}))
            for dd = 1:length(Files.(MouseGroup{mg}){mm})
                
                cd(Files.(MouseGroup{mg}){mm}{dd})
                disp(Files.(MouseGroup{mg}){mm}{dd})
                clear Params Behav NoDoorEpoch
                load('behavResources_SB.mat','Params','Behav')
                load('ExpeInfo.mat')
                
                
                % The three measures are : opp corner - middle - opp side
                Reorder = [2,1,3];
                for k = 1:3
                    EscapeLatency.Zone.(SessNames{ss}).(MouseGroup{mg}){Reorder(k)}{dd} = [ EscapeLatency.Zone.(SessNames{ss}).(MouseGroup{mg}){k}{dd},Behav.EscapeLat.ZoneEpoch(k)];
                    EscapeLatency.ZoneAligned.(SessNames{ss}).(MouseGroup{mg}){Reorder(k)}{dd} = [ EscapeLatency.ZoneAligned.(SessNames{ss}).(MouseGroup{mg}){k}{dd},Behav.EscapeLat.ZoneEpochAligned(k)];
                end
                
                
            end
        end
    end
end

close all
Cols = [[0.6 0.6 0.6];[0.6 1 0.6];[1 0.8 1];[0.6 0.4 0.6]];
subplot(3,2,(1-1)*2+1)
for mg = 1:length(MouseGroup)
    
    errorbar(1,-10,1,'color',Cols(mg,:),'linewidth',2)
    hold on
end
for ZoneType = 1:3
    for mg = 1:length(MouseGroup)
        SafeEscape = [EscapeLatency.ZoneAligned.HabituationBlockedSafe_PreDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PreDrug.(MouseGroup{mg}){ZoneType}{2};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedSafe_PostDrug.(MouseGroup{mg}){ZoneType}{2};...
            EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.ExtinctionBlockedSafe_PostDrug.(MouseGroup{mg}){ZoneType}{2}];
        
        ShockEscape = [EscapeLatency.ZoneAligned.HabituationBlockedShock_PreDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PreDrug.(MouseGroup{mg}){ZoneType}{2};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.UMazeCondBlockedShock_PostDrug.(MouseGroup{mg}){ZoneType}{2};...
            EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.(MouseGroup{mg}){ZoneType}{1};...
            EscapeLatency.ZoneAligned.ExtinctionBlockedShock_PostDrug.(MouseGroup{mg}){ZoneType}{2}];
        
        
        subplot(3,2,(ZoneType-1)*2+1)
        errorbar(1,mean(SafeEscape(1,:)'),stdError(SafeEscape(1,:)'),'color',Cols(mg,:),'linewidth',2)
        hold on
        errorbar(2:7,mean(SafeEscape(2:7,:)'),stdError(SafeEscape(2:7,:)'),'color',Cols(mg,:),'linewidth',2)
        ylim([-10 230]),xlim([0 7.5])
        set(gca,'XTick',[1,2.5,4.5,6.5],'XTickLabel',{'Hab','CondPreDrug','CondPostDrug','ExtPostDrug'},'linewidth',2)
        line([3.5 3.5],ylim,'color','k','linewidth',3)
        text(3.7,210,'Injection')
        ylabel('Escape Latency (s)')
        box off
        if ZoneType ==1
            title('Safe side')
        end
        
        subplot(3,2,(ZoneType-1)*2+2)
        errorbar(2:7,mean(ShockEscape(2:7,:)'),stdError(ShockEscape(2:7,:)'),'color',Cols(mg,:),'linewidth',2)
        hold on
        errorbar(1,mean(ShockEscape(1,:)'),stdError(ShockEscape(1,:)'),'color',Cols(mg,:),'linewidth',2)
        
        ylim([-10 230]),xlim([0 7.5])
        
        set(gca,'XTick',[1,2.5,4.5,6.5],'XTickLabel',{'Hab','CondPreDrug','CondPostDrug','ExtPostDrug'},'linewidth',2)
        line([3.5 3.5],ylim,'color','k','linewidth',3)
        text(3.7,210,'Injection')
        ylabel('Escape Latency (s)')
        box off
        if ZoneType ==1
            title('Shock side')
        end
    end
end

subplot(3,2,(1-1)*2+1)
legend(MouseGroup,'Location','NorthWest')


