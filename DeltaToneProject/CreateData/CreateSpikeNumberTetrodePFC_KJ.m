% CreateSpikeNumberTetrodePFC_KJ
% 07.11.2017 KJ
%
% create spike to analyse for each tetrodes
%
% Info
%   see CreateSpikeToAnalyse_KJ
%


try
    
    %load
    load('SpikeData.mat', 'tetrodeChannels', 'TT');
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    numNeurons = number;
    
    %all channel indices for each neuron
    all_channels = [];
    for i=1:length(numNeurons)
        all_channels(i) = TT{i}(1);
    end
    channels = unique(all_channels);
    
    %neurons for each tetrode
    for ch=1:length(channels)
        numbers{ch} = numNeurons(all_channels==channels(ch));
    end
    
    %real channel
    channels = tetrodeChannels(channels);
    
    %save
    save SpikesToAnalyse/PFCx_tetrodes numbers channels

catch
    disp('problem for this record') 
end
