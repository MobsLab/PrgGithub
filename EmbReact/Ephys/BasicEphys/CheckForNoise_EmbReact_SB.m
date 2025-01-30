
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
                    try
                        load('ChannelsToAnalyse/dHPC_rip.mat')
                        channel;
                    catch
                        try
                            load('ChannelsToAnalyse/dHPC_deep.mat')
                            channel;
                        catch
                            try
                                load('ChannelsToAnalyse/dHPC_sup.mat')
                                channel;
                            catch
                                load('ChannelsToAnalyse/Bulb_deep.mat')
                                channel;
                            end
                        end
                    end
                    try
                        FindNoiseEpoch([cd filesep],channel,0);
                    catch
                        disp('error, no HPC channels, doing it on Bulb')
                                                        load('ChannelsToAnalyse/Bulb_deep.mat')
                        FindNoiseEpoch_BM([cd filesep],channel,0);
                    end
                    close all
                end
            end
        end
    end
end