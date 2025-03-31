%%StatOnNeuronGroup_KJ
% 12.04.2018 KJ
%
% return informations on a list of neurons
%
% function [firingrates, neuron_type, neuron_layer] = StatOnNeuronGroup_KJ(NumNeurons, S, unitID, neuronLayers, varargin)
%
% INPUT:
% - S                           - struct of tsd - spike data
% - NumNeurons                  - a list of neuron number
% - unitID                      - ID of neurons (>0 if pyr, <0 if int)
% - neuronLayers                - layers of neurons (clusterX)
%
% - Epoch(optional)             - Epoch on which S is restricted for firing rates  
%
%
% OUTPUT:
% - firingrates                 = firing rates of each neuron
% - neuron_type                 = pyr or int (>0 or <0) 
% - neuron_layer                = layers of neurons (clusterX)
%
%
%   see 
%       
%


function [firingrates, neuron_type, neuron_layer] = StatOnNeuronGroup_KJ(S, NumNeurons,UnitID, neuronsLayers, varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'Epoch'
            Epoch = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%% Type of neurons
neuron_type = UnitID(NumNeurons,1);

%% Neurons layer
neuron_layer = neuronsLayers(NumNeurons)'; 


%% Firing Rates
S = S(NumNeurons);
if exist('Epoch','var')
    for i=1:length(S) 
        S{i} = Restrict(S{i}, Epoch);
    end
end

firingrates = nan(length(S), 1);
for i=1:length(S) 
    firingrates(i) = length(S{i}) / (max(Range(S{i}))*1e-4);
end


end

