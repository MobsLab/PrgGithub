%%FindNeuronPreferredSubstage_KJ
% 13.04.2018 KJ
%
% find preferred substages for each neurons
%
% function [neuron_substages, firing_rates] = FindNeuronPreferredSubstage_KJ(S, NumNeurons, Substages, varargin)
%
% INPUT:
% - S                           - struct of tsd - spike data
% - NumNeurons                  - a list of neuron number
% - Substages                   - Substages Epoch
%
% - threshold(optional)         - threshold on the FR difference between 1st and 2nd substage to assign a value 
%
%
% OUTPUT:
% - neuron_substages            = preferred substages for each neuron (NaN if none) 
% - firing_rates                = firing rates of neurons in each substages
%
%
%   see 
%       
%


function [neuron_substages, firing_rates] = FindNeuronPreferredSubstage_KJ(S, NumNeurons, Substages, varargin)


%% CHECK INPUTS

if nargin < 3 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'threshold'
            thresh = varargin{i+1};
            if thresh<=0
                error('Incorrect value for property ''threshold''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('thresh','var')
    thresh=0.75;
end


%% init
S = S(NumNeurons);


%% firing rates in each substages
firing_rates = nan(length(S), length(Substages));
for i=1:length(S)
    for sub=1:length(Substages)
        firing_rates(i,sub) = length(Restrict(S{i}, Substages{sub})) / (tot_length(Substages{sub})*1e-4);
    end
end


%% Preferred substages
MATfr = firing_rates(:,1:5); %keep only {N1,N2,N3,REM,Wake}

%maximum FR
[sort_fr, id_fr] = sort(MATfr, 2, 'descend');
neuron_substages = id_fr(:,1);

%check if second/first < thresh (75% in Marie's paper)
real_preferrence = (sort_fr(:,2) ./ sort_fr(:,1)) < thresh;
neuron_substages(~real_preferrence) = nan;



end





