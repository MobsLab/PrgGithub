%%FindSoloistChorist_KJ
% 13.04.2018 KJ
%
% return informations on a list of neurons
%
% function [numSoloist, numChorist] = FindSoloistChorist_KJ(S, NumNeurons, varargin)
%
% INPUT:
% - S                           - struct of tsd - spike data
% - NumNeurons                  - a list of neuron number
%
% - Epoch(optional)             - Epoch on which S is restricted for firing rates  
%
%
% OUTPUT:
% - numSoloist                  = neuron number of the soloist
% - numChorist                  = neuron number of the chorist
%
%
%   see 
%       
%


function [numSoloist, numChorist] = FindSoloistChorist_KJ(S, NumNeurons, varargin)


%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
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
    thresh=1;
end

%params
binsize_cc = 5;
nbins_cc = 500;


%% init
S = S(NumNeurons);
if exist('Epoch','var')
    for i=1:length(S) 
        S{i} = Restrict(S{i}, Epoch);
    end
end


%% Soloist vs Chorist

for i=1:length(S)
    num = setdiff(1:length(S), i);
    [Cc(i,:), x_cc] = CrossCorr(Range(S{i}), Range(PoolNeurons(S,num)), binsize_cc, nbins_cc);
end

%normalized cross-correlograms
Cc_norm = Cc;
Cc_norm(isnan(Cc_norm))=0;
Cc_norm = zscore(Cc_norm')';
Cc_norm = SmoothDec(Cc_norm,[0.0001 3]);


%distinguish soloist and chorist
Chorist_idx = [];
Soloist_idx = [];
for i=1:length(S)
    if mean(Cc_norm(i,x_cc>-50&x_cc<50)) > thresh * mean(Cc_norm(i,x_cc<-250))
        Chorist_idx = [Chorist_idx i];
    else
        Soloist_idx = [Soloist_idx i];
    end
end


%assign
numSoloist = NumNeurons(Soloist_idx);
numChorist = NumNeurons(Chorist_idx);



end

