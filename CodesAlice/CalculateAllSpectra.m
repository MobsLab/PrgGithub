SessionNames={'CalibrationMAPEyeshock','TestPostMAPEyeshock','UMazeCondMAPEyeshock','TestPreMAPEyeshock','WallRetestShockMAPEyeshock','WallRetestSafeMAPEyeshock','WallHabShockMAPEyeshock'...
    'WallHabSafeMAPEyeshock','WallCondShockMAPEyeshock','WallCondSafeMAPEyeshock','HabituationMAPEyeshock'};

for ss=1:length(SessionNames)
    SessionNames{ss}
    Dir=PathForExperimentsEmbReact(SessionNames{ss})
    for mouse=1:length(Dir.path)
        for session=1:length(Dir.path{mouse})
            cd(Dir.path{mouse}{session})
            
            if Dir.ExpeInfo{mouse}{session}.nmouse==564
               channel=10;
               save('ChannelsToAnalyse/Bulb_deep.mat','channel')
               clear channel
            end
            % Spectra of OB
            load('ChannelsToAnalyse/Bulb_deep.mat')
            LowSpectrumSB([cd filesep],channel,'B',0); clear channel
            % Spectra of HPC
            load('ChannelsToAnalyse/dHPC_rip.mat')
            LowSpectrumSB([cd filesep],channel,'HPC',0); clear channel
            % Spectra of PFC
            load('ChannelsToAnalyse/PFCx_deep.mat')
            LowSpectrumSB([cd filesep],channel,'PFCx',0); clear channel
        end
    end
end