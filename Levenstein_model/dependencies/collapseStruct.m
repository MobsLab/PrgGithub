function c = collapseStruct(s,squeez)
% function c = collapseStruct(s,squeez)
%
% Collapses array structure 's' into scalar structure 'c'.  Arrays with one
% non-uniform dimension are concatenated along that dimension.  Arrays with
% multiple non-uniform dimensions are shoveled into a cell.  Constant
% arrays are collapsed into a scalar.  Dimension ordering should stay
% sensible.
%
% squeez is logical to squeeze the output fields.
%
% For many structures, this function results in massive memory savings.
%
% T.Hilmer, UH
% 2010.10.01  version 2
%   vectors -> vector instead of cell
% 2010.02.11  version 1

if numel(s) == 1, c = s; return, end % already scalar structure

f = fieldnames(s);

if nargin > 1 && squeez
    sq = @(x)squeeze(x); % squeeze output
else
    sq = @(x)x; % do nothing
end

Nf = length(f);
Ns = length(s);

for n = 1:Nf

    for m = 1:Ns
        dim(m,:) = size(s(m).(f{n}));
    end

    cl = ~sum(diff(dim));% logic for constant dimensions

    x = s(1).(f{n});% only for checking class.  not used for size


    if all(cl) % All Constant Dimensions
        if isscalar(x) || isvector(x)% scalars -> vector ,  vectors -> array
            y = cat(find(dim(1,:)==1,1,'first'),s(:).(f{n}));
        elseif ~sum(dim(:))% trivial case of all empty
            y = x; % keeps class
        else % arrays -> N+1 array
            y = cat(size(dim,2)+1,s(:).(f{n}));
        end

    elseif 1==sum(cl) % One Non-Constant Dimension
        % concatenate on the non-constant
        if ~ischar(x)% not appropriate for character arrays
            y = cat(find(~cl),s(:).(f{n}));
        else
            y = {s(:).(f{n})};
        end
    else
        error('unexpected situation')
         y = {s(:).(f{n})}; % shoveling into array works, but need to inspect
    end

    % collapse constant fields to scalars:
    if ~isstruct(y) && (length(unique(squeeze(y)))==1 || ischar(y))
        if iscell(y)
            y = y{1};
        elseif ischar(y) & strmatch(y(1,:),y,'exact')
            y = y(1,:);
        else
            y = y(1);
        end
    end

    c.(f{n}) = sq(y);
    clear y % so it doesn't propagate to next field
end