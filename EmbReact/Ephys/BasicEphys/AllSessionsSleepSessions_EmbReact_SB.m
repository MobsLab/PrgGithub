
for ss=1:length(SessNames)
    if not(isempty(strfind(lower(SessNames{ss}),'sleep')))
        Dir=PathForExperimentsEmbReact(SessNames{ss});
        for d=1:length(Dir.path)
            for dd=1:length(Dir.path{d})
                if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})
                    clear SWSEpoch
                    load('StateEpochSB.mat','SWSEpoch')
                    try SWSEpoch
                    catch
                        BulbSleepScript
                    end
                    
                end
            end
        end
    end
end