function cnt = sparse_count(model,fmin,fmax)
% This function computes the number of bumps whose center lie in a given 
% frequency range, from a bump model.
%
% Input parameters:
% - model: the bump model
% - fmin: minimal frequency of the range. if empty, model.freqmin will be
% used instead.
% - fmax: maximal frequency of the range. if empty, model.freqmax will be
% used instead.
%
% Output parameters:
% - cnt: a vector with the number of bumps of each of the N trials of the
% model
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

if ((nargin < 2) | (isempty(varargin{2}))
    fmin = model.freqmin;
end;
if ((nargin < 3) | (isempty(varargin{3}))
    fmax = model.freqmax;
end;
if (fmin < model.freqmin) | (fmax > model.freqmax)
    disp('frequency bounds out of range');
    return;
else
    difmin = fmin - model.freqmin + model.ByDn;
    indmax = model.size_freq - floor(difmin/model.freqsmp);
    difmax = model.freqmax - fmax + model.ByUp;
    indmin = floor(difmax/model.freqsmp) + 1;
end;
cnt = zeros(model.N,1);
for trial=1:model.N
    indec = get_1dec(model,trial);
    inmn = indec(find(indec(:,4)>=indmin),:);
    inmx = inmn(find(inmn(:,4)<=indmax),:);
    cnt(trial) = length(inmx(:,1));
end;