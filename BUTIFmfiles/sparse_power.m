function pow = sparse_power(model,varargin)%fmin,fmax,kind,OFFSET)
% This function computes the sparse power in a given frequency range,
% from a bump model.
%
% Input parameters:
% - model: the bump model
% - fmin: minimal frequency of the range. if empty, model.freqmin will be
% used instead.
% - fmax: maximal frequency of the range. if empty, model.freqmax will be
% used instead.
% - kind: 0 for z-score amplitude, 1 for wavelet amplitude, 2 for unscaled
% bump amplitude.If empty, the wavelet amplitude will be computed (kind=1).
% - OFFSET: ignore this parameter for versions > 3 (ButIf2.0 and over)
%           this parameter indicates the z-scoreoffset used for modeling
%           (usually in the range [-1..3])
%
% Output parameters:
% - pow: a vector with the sparse power of each of the N trials of the
% model
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

if (nargin < 2) | (isempty(varargin{1}))
    fmin = model.freqmin;
else
    fmin = varargin{1};
end;
if (nargin < 3) | (isempty(varargin{2}))
    fmax = model.freqmax;
else
    fmax = varargin{2};
end;
if (nargin < 4) | (isempty(varargin{3}))
    kind = 1;
else
    kind = varargin{3};
end;
if (model.version > 3)
    OFFSET = model.zscore_offset;
else
    if (nargin < 5) | (isempty(varargin{4}))
        disp('for models with version < 4 (ButIf2.0 package) the offset used for modeling must be given');
        return;
    else
        OFFSET = varargin{4};
    end;
end;
if (fmin < model.freqmin) | (fmax > model.freqmax)
    disp('frequency bounds out of range, values must be in [freqmin..freqmax]');
    return;
else
    difmin = fmin - model.freqmin;
    indmax = model.size_freq - floor(difmin/model.freqsmp) - model.ByDn;
    difmax = model.freqmax - fmax;
    indmin = floor(difmax/model.freqsmp) + model.ByUp + 1;
end;
pow = zeros(model.N,1);
for trial=1:model.N
    indec = get_1dec(model,trial);
    if (kind ~= 2)
        amp = indec(:,1);
        for b=1:size(indec,1),
            fpos = round(indec(b,4));
            vs = model.varspec{trial};
            sp = model.spectre{trial};
            ne = model.maxnorm{trial};
            if (vs(fpos) ~= 0)
                zamp = (amp(b)*ne-OFFSET);
                wamp = vs(fpos)*max(zamp,0)+sp(fpos);
            else
                zamp = (amp(b)*ne-OFFSET);
                wamp = max(zamp,0)+sp(fpos);
            end;
            if (kind == 0)
                amp(b) = zamp;
            else
                amp(b) = wamp;
            end;
        end;
        indec(:,1) = amp;
    end;
    inmn = indec(find(indec(:,4)>=indmin),:);
    inmx = inmn(find(inmn(:,4)<=indmax),:);
    pow(trial) = sum(inmx(:,1));
end;