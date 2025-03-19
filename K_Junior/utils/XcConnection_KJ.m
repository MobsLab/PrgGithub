%XcConnection_KJ
%18.01.2018 KJ  
%
% [SynC,ConStr] = XcConnection_KJ(y_correlogram, average_shuffle, inf_shuffle, sup_shuffle, std_shuffle, t_correlogram, conf_int, varargin)
%
% Find synaptic connectivity between neurons and compute connectivity
% strength
% based on cross-correlograms and shuffled data
%
%
%% INPUT:
%   y_correlogram               Normal CrossCorr
%   average_shuffle             Jittered average CrossCorr
%   inf_shuffle                 lower bound of confidence Interval
%   sup_shuffle                 upper bound  bound of confidence Interval
%   std_shuffle                 bin center points
%   t_correlogram               timestamps of y_correlogram
%   conf_int                    max and min values for AtoB and BtoA
%
%   window_inh
% 
%
%% OUTPUT:
%   SynC            synaptic connectivity [s12 s21] where:
%                       s12 is the connectivity from neuron 1 to neuron 2
%                       s21 is the connectivity from neuron 2 to neuron 1
%                       1 for excitation and -1 for inhibition
%   ConStr          connectivity strength [c12 c21] 
%
%
%%  SEE
%       FindMonoSynapticConnectivity XcConnection_SB XcJitter_KJ
%       Adrien Peyrache, based on Fujisawa et al. 2008
%
%


function [SynC,ConStr] = XcConnection_KJ(y_correlogram, average_shuffle, inf_shuffle, sup_shuffle, std_shuffle, t_correlogram, conf_int, varargin)


%% Initiation

if nargin < 5 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'window_exc'
            window_exc = varargin{i+1};
            if isivector(window_exc,'#2','>0')
                error('Incorrect value for property ''window_exc''.');
            end
        case 'window_inh'
            window_inh = varargin{i+1};
            if isivector(window_inh,'#2','>0')
                error('Incorrect value for property ''window_inh''.');
            end
        case 'same_tetrode'
            same_tetrode = varargin{i+1};
            if same_tetrode~=0 && same_tetrode ~=1
                error('Incorrect value for property ''same_tetrode''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


if ~exist('window_exc', 'var')
    window_exc = [1 4];
end
if ~exist('window_inh', 'var')
    window_inh = [1.5 4];
end
if ~exist('same_tetrode', 'var')
    same_tetrode = 0;
end


minB = window_exc(1);
maxB = window_exc(2);

SynC = [0 0];
ConStr = [0 0];


%% After

% Activation
bIx = find(t_correlogram>=window_exc(1) & t_correlogram<=window_exc(2));
h = y_correlogram(bIx);
m = average_shuffle(bIx);
s = std_shuffle(bIx);

if sum(h>conf_int(1,1))>0 % larger than global max
    [labvect,numReg] = bwlabel((h-sup_shuffle(bIx))>0);
    mea = regionprops(labvect,'Area');
    v=0;
    for i=1:numReg
        if mea(i).Area>1
            [v,ix] = max(h-sup_shuffle(bIx));
        end
    end
    if v>0 % is it above the local max
        SynC(1) = 1;
        ConStr(1) = (h(ix)-m(ix))/s(ix);
    end
end


%Inhibition
bIx = find(t_correlogram>=window_inh(1) & t_correlogram<=window_inh(2));
h = y_correlogram(bIx);
m = average_shuffle(bIx);
s = std_shuffle(bIx);

if sum(h<conf_int(2,1))>same_tetrode % (same_tetrode = 0 or 1)
    [labvect,numReg] = bwlabel((h-inf_shuffle(bIx))<0);
    mea = regionprops(labvect,'Area');
    v=0;
    for i=1:numReg
        if mea(i).Area>1
            [v,ix] = min(h-inf_shuffle(bIx));
        end
    end
    if v<0
        p = (m(ix)-h(ix))/s(ix);
        if ~SynC(1) || p>ConStr(1)
            SynC(1) = -1;
            ConStr(1) = p;
        end
    end
end


%% Before

%Activation
bIx = find(t_correlogram>=-window_exc(2) & t_correlogram<=-window_exc(1));
h = y_correlogram(bIx);
m = average_shuffle(bIx);
s = std_shuffle(bIx);

if sum(h>conf_int(1,2))>0
    [labvect,numReg] = bwlabel((h-sup_shuffle(bIx))>0);
    mea = regionprops(labvect,'Area');
    v=0;
    for i=1:numReg
        if mea(i).Area>1
            [v,ix] = max(h-sup_shuffle(bIx));
        end
    end
    if v>0
        SynC(2) = 1;
        ConStr(2) = (h(ix)-m(ix))/s(ix);
    end
end


%Inhibition
bIx = find(t_correlogram>=-window_inh(2) & t_correlogram<=-window_inh(1));
h = y_correlogram(bIx);
m = average_shuffle(bIx);
s = std_shuffle(bIx);

if sum(h<conf_int(2,2))>same_tetrode % (same_tetrode = 0 or 1)
    [labvect,numReg] = bwlabel((h-inf_shuffle(bIx))<0);
    mea = regionprops(labvect,'Area');
    v=0;
    for i=1:numReg
        if mea(i).Area>1
            [v,ix] = min(h-inf_shuffle(bIx));
        end
    end
    if v<0
        p = (m(ix)-h(ix))/s(ix);
        if ~SynC(2) || p>ConStr(2)
            SynC(2) = -1;
            ConStr(2) = p;
        end
    end
end


end




