%GetAllRipplesSleep
%SB

clear Info
Info.hemisphere = [];
Info.scoring = [];
Info.threshold = [5 7];
Info.durations = [150 20 200];
Info.frequency_band = [120 250];


for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if not(Dir.ExpeInfo{d}{dd}.nmouse==117)
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                clear SWSEpoch TotalNoiseEpoch LFP
            
                
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    clear channel SWSEpoch LFP
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    load(['LFPData/LFP',num2str(channel),'.mat'])
                    load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch')
                    if not(exist('SWSEpoch'))
                        BulbSleepScript
                        load('StateEpochSB.mat','TotalNoiseEpoch','SWSEpoch')
                    end
                    
                    InputInfo.Epoch=SWSEpoch-TotalNoiseEpoch;
                    if not(isempty(Start(InputInfo.Epoch)))
                        [Ripples, meanVal, stdVal] = FindRipplesKJ(LFP, InputInfo.Epoch);
                    end
                    InputInfo=rmfield(InputInfo,'Epoch');
                end
            end
        end
    end
end