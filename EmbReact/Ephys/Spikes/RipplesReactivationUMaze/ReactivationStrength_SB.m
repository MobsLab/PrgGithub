function strength = ReactivationStrength_SB(spikes,templates);

% Modified by SB from original code to make compatible with format for
% spikes in the lab
%ReactivationStrength - Assess reactivation strength of cell assemblies.
%
% Estimates how similar spiking activity is to given templates, across time.
% Time bins can be automatically determined using a fixed bin size, or provided
% as an explicit list (e.g. computed using theta phases).
%
%  USAGE
%
%    strength = ReactivationStrength(spikes,templates,<options>)
%
%   INPUT
%
%   spikes = matrix of firing rates (bin count x neuron number) (use MakeQfromS for example)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'bins'        list of [start stop] for all bins
%     'binSize'     bin size in s (default = 0.050)
%     'overlap'     overlap between successive bins (default = binSize/2)
%     'step'        step between successive bins (default = binSize/2)
%    =========================================================================
%
%  OUTPUT
%
%    strength       reactivation strength across time (if time bins are not
%                   explicitly provided, the first bin is centered on the
%                   first spike)
%
%  SEE
%
%    See also ActivityTemplates.

% Copyright (C) 2016-2018 by Michaël Zugaro, Ralitsa Todorova
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

% spikes = zscore(full(spikes));
spikes = (full(spikes));

nUnits = size(templates,2);
nBins = size(spikes,1);
dN = spikes;

% Compute reactivation strengths
nTemplates = size(templates,3);
strength = zeros(nBins,nTemplates);
for i = 1:nTemplates,
    template = templates(:,:,i);
    % Set the diagonal to zero to not count coactivation of i and j when i=j
    template = template - diag(diag(template));
    strength(:,i) = nansum(dN*(template).*dN,2);
end
