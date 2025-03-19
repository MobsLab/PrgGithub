clear all
SessNames = {'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug',...
    'HabituationBlockedShock_EyeShock','HabituationBlockedSafe_EyeShock',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug',...
    'ExtinctionBlockedShock_EyeShock' 'ExtinctionBlockedSafe_EyeShock'};

for ss = 1:length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for mm=1:length(Dir.path)
        
        for dd = 1:length(Dir.path{mm})
            cd(Dir.path{mm}{dd})
            
            clear Params Behav NoDoorEpoch
            load('behavResources_SB.mat','Params','Behav')
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
                try
                % The three measures are : opp corner - middle - opp side
                Reorder = [2,1,3];
                for k = 1:3
                    EscapeLatency.Zone.(SessNames{ss}){mm}(dd,:) = Behav.EscapeLat.ZoneEpoch(k);
                    EscapeLatency.ZoneAligned.(SessNames{ss}){mm}(dd,:) = Behav.EscapeLat.ZoneEpochAligned(k) ;
                end
                catch
                    disp('fail')
                    for k = 1:3
                        EscapeLatency.Zone.(SessNames{ss}){mm}(dd,:) = NaN;
                        EscapeLatency.ZoneAligned.(SessNames{ss}){mm}(dd,:) = NaN;
                    end
                    
                end
                
            end
        end
    end
end
