clear all
Dir=PathForExperimentsDeltaSleep2016('Basal');
keepGoodLow=3;
keepNoLow=1;
BadMice={'Mouse244','Mouse294'};

for mm=2:length(Dir.path)
    mm
        cd(Dir.path{mm})
        if not(strcmp(Dir.name{mm},BadMice{1}) | strcmp(Dir.name{mm},BadMice{2}))
            
            
            disp('loading data')
            load('StateEpochSB.mat','REMEpoch')
            
            try
                load('ChannelsToAnalyse/dHPC_deep.mat')
                Channel.HPC=channel;
            catch
                
                load('ChannelsToAnalyse/dHPC_rip.mat')
                Channel.HPC=channel;
            end
            
            load('ChannelsToAnalyse/Bulb_deep.mat')
            Channel.OB=channel;
            
            load('ChannelsToAnalyse/PFCx_deep.mat')
            Channel.PFCx=channel;
            
            LowCohgramSB([Dir.path{mm},filesep],Channel.HPC,'H',Channel.OB,'B',1)
            LowCohgramSB([Dir.path{mm},filesep],Channel.HPC,'H',Channel.PFCx,'PFCx',1)
            LowCohgramSB([Dir.path{mm},filesep],Channel.OB,'B',Channel.PFCx,'PFCx',1)
            
        end
end