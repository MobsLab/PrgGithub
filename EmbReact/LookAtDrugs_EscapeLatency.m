clear all
clear Dir

SessNames = {'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};

for ss = 1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for mouse = 1:length(Dir.path)-1
        mouse
        try
            VarTestPost.DrugType{mouse} = Dir.ExpeInfo{mouse}{1}.DrugInjected;
            VarTestPost.MouseID(mouse) = Dir.ExpeInfo{mouse}{1}.nmouse;
           
            for dd=1:length(Dir.path{mouse});
                
                
                cd(Dir.path{mouse}{dd})
                disp(Dir.path{mouse}{dd})
                clear Params Behav NoDoorEpoch
                load('behavResources_SB.mat','Params','Behav')
                load('ExpeInfo.mat')
                for k = 1:3
                    try
                        temp(k,dd) = Behav.EscapeLat.ZoneEpoch(k);
                    catch
                        temp(k,dd) = NaN;
                        
                    end
                    try
                        tempAl(k,dd) = Behav.EscapeLat.ZoneEpochAligned(k);
                    catch
                        tempAl(k,dd) = NaN;
                    end
                    
                end
            end
            for k = 1:3
                EscapLat{ss}{k}(mouse) = nanmean(temp(k,:));
                EscapLatAl{ss}{k}(mouse) = nanmean(tempAl(k,:));
            end
            EscapLatMin{ss}(mouse) = nanmean(nanmin(temp,[],1));
            EscapLatAlMin{ss}(mouse) =nanmean(nanmin(tempAl,[],1));
            
            clear temp tempAl
        end
    end
end




MiceID.DZP = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'DIAZEPAM'))));
MiceID.SAL = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'SAL'))) | not(cellfun(@isempty,strfind(VarTestPost.DrugType,'SALINE'))));
MiceID.FlxCh =  find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'CHRONIC_FLUOXETINE'))) | not(cellfun(@isempty,strfind(VarTestPost.DrugType,'FLXCHRONIC'))));
MiceID.FlxAc = find(not(cellfun(@isempty,strfind(VarTestPost.DrugType,'FLX'))));



DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
Titre = {'ActAv -'}
k=3
figure
for ss = 1:4
    for dtype = 1:length(DrugTypes)
        Lat{dtype} =  EscapLatAl{ss}{k}(MiceID.(DrugTypes{dtype}));
    end
    subplot(4,1,ss)
    PlotErrorBarN_KJ(Lat,'paired',0,'newfig',0)
    set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
end

DrugTypes = {'SAL','FlxCh','FlxAc','DZP'};
Titre = {'ActAv - Cond','PassAv - Cond','ActAv-Ext','PassAv-Ext'};

figure
for ss = 3:4
    for dtype = 1:length(DrugTypes)
        Lat{dtype} =  EscapLatAlMin{ss}(MiceID.(DrugTypes{dtype}));
    end
    subplot(2,1,ss-2)
    PlotErrorBarN_KJ(Lat,'paired',0,'newfig',0)
    set(gca,'XTick',1:4,'XTickLabel',DrugTypes)
    ylim([0 250])
    title(Titre{ss})
end

