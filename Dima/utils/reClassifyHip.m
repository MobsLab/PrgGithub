function reClassifyHip(mice)

% Get data
Dir = PathForExperimentsERC('UMazePAG');
Dir = RestrictPathForExperiment(Dir,'nMice',mice);

for imouse = 1:length(Dir.path)
    wave = load([Dir.path{imouse}{1} 'MeanWaveform.mat']);
    spikes = load([Dir.path{imouse}{1} 'SpikeData.mat'], 'S');
    lfp = load([Dir.path{imouse}{1} 'LFPData/LFP0.mat']);
    
    cd(Dir.path{imouse}{1});
    UnitID = ClassifyHippocampalWaveforms(wave.W, spikes.S, lfp.LFP, [dropbox filesep 'Kteam'], 0, 'recompute', 1);
    
    load('SpikeData.mat', 'MatInfoNeurons', 'BasicNeuronInfo');
    MatInfoNeurons(:,3) = UnitID(:,1);
    BasicNeuronInfo.neuroclass(:,1) = UnitID(:,1);
    save('SpikeData.mat', 'MatInfoNeurons', 'BasicNeuronInfo', '-append');
    
    clear MatInfoNeurons BasicNeuronInfo
    
end


end