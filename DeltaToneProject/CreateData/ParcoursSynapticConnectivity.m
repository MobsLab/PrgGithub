%%ParcoursSynapticConnectivity
% 21.01.2019 KJ
%
%
%   Compute Neuron Connectivity
%
% see
%
%



clear


Dir=PathForExperimentsDeltaSleepSpikes('all');


for p=1:length(Dir.path)

    %goto
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    
    % load spike data and info
    load('SpikeData.mat','S','TT')
%     load('InfoNeuronsAll.mat')
%     neuronClass = InfoNeurons.putative;
%     neuronFR = InfoNeurons.firingrate;
    
    % connectivity
    if exist('SpikeConnectivity.mat','file')~=2
        [MatConnectivity,ConnectivityStrength] = FindMonoSynapticConnectivity(S,TT);
        NumNeurons = 1:length(S);
        save SpikeConnectivity MatConnectivity ConnectivityStrength NumNeurons
    else
        load('SpikeConnectivity.mat')
    end
    
%     % 
%     nb_excit.output = sum(MatConnectivity==1,2);
%     nb_inhib.output = sum(MatConnectivity==-1,2);
%     nb_excit.input = sum(MatConnectivity==1,1)';
%     nb_inhib.input = sum(MatConnectivity==-1,1)';
%     
%     
%     % putative interneurons with excitatory connections
%     idx = find(neuronClass<0 & nb_excit.output>=1);
%     [idx neuronFR(idx) nb_inhib.output(idx) nb_excit.output(idx)]
    
    
end





