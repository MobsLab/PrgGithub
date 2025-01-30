 
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if (Dir.ExpeInfo{d}{dd}.nmouse==MouseToDo)
                clear channel
                cd(Dir.path{d}{dd})
                if not(exist('StateEpochSB.mat'))>0
                    disp(Dir.path{d}{dd})
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    channel;
                    
                    FindNoiseEpoch_BM([cd filesep],channel,0);
                end
                close all
            end
        end
    end
end
