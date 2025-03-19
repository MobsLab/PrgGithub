%%MakeNeuronInfoData_KJ
% 04.04.2018 KJ
%
%
% see
%   LinkNeuronsToLayers_KJ FindSoloistChorist_KJ
%


clear


Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);

Dir = PathForExperimentsBasalSleepSpike;

for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    %% load 
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    NumNeurons = number;
    load('SpikeData.mat', 'S', 'neuronsLayers')
    load('NeuronClassification.mat', 'UnitID')
    
    load('SleepSubstages.mat')
    Substages = Epoch([1:5 7]);
    NameSubstages = Epoch([1:5 7]);
    
    clear number Epoch NameEpoch
    
    
    %% Get info
    
    %Soloist-chorist
    [numSoloist, numChorist] = FindSoloistChorist_KJ(S, NumNeurons);
    neuron_soloist = zeros(length(NumNeurons),1);
    neuron_soloist(ismember(NumNeurons,numSoloist)) = 1;
    
    %Info
    [firingrates, neuron_type, neuron_layer] = StatOnNeuronGroup_KJ(S, NumNeurons, UnitID, neuronsLayers);
    
    %Preferred substages
    [neuron_substages, fr_substages] = FindNeuronPreferredSubstage_KJ(S, NumNeurons, Substages);
    neuron_substages(isnan(neuron_substages)) = 0;
    
    
    %% save
    MatInfoNeurons = nan(length(NumNeurons), 6);
    
    MatInfoNeurons(:,1) = NumNeurons';
    MatInfoNeurons(:,2) = firingrates;
    MatInfoNeurons(:,3) = neuron_type;
    MatInfoNeurons(:,4) = neuron_layer;
    MatInfoNeurons(:,5) = neuron_soloist;
    MatInfoNeurons(:,6) = neuron_substages;
    
    InfoNeurons.structure   = 'PFCx';
    InfoNeurons.NumNeurons  = NumNeurons;
    InfoNeurons.firingrate  = firingrates;
    InfoNeurons.fr_substage = fr_substages;
    InfoNeurons.substages   = neuron_substages;
    InfoNeurons.putative    = neuron_type;
    InfoNeurons.layer       = neuron_layer;
    InfoNeurons.soloist     = neuron_soloist;

    save('InfoNeuronsPFCx', 'MatInfoNeurons', 'InfoNeurons')
    
end





