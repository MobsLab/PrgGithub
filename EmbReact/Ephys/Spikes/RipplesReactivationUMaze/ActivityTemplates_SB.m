function [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(spikes,AllTemp)

% Modified by SB from original code to make compatible with format for
% spikes in the lab
%ActivityTemplates - Compute activity templates from PCA of spike trains.
%
% Computes the templates for the component activation analysis described in
% Peyrache et al (2009). These templates can then be tested on different data
% sets using <a href="matlab:help ReactivationStrength">ReactivationStrength</a>. Time bins can be automatically determined
% using a fixed bin size, or provided as an explicit list (e.g. computed using
% theta phases).
%
%  USAGE
%
%    [templates,correlations,eigenvalues] = ActivityTemplates(spikes,<options>)
%       Input : 
%    spikes : bins * units matrix of spike counts - no need to zscore
%    AllTemp = 1 if you want to keep all templates; =0 if you want only the
%    significant ones
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'bins'        list of [start stop] for all bins
%     'binSize'     bin size in s (default = 0.050)
%    =========================================================================
%
%  OUTPUT
%
%    templates      3D array of template matrices (dimension 3 is template #,
%                   ordered in descending order of corresponding eigenvalue)
%    correlations   spike count correlation matrix
%    eigenvalues    significant eigenvalues, listed in descending order
%
%  SEE
%
%    See also ReactivationStrength.

% Copyright (C) 2016-2018 by Michaël Zugaro, Ralitsa Todorova
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.
spikes = full(spikes);
templates = NaN;
correlations = NaN;
eigenvalues = NaN;

nUnits = size(spikes,2);
nBins = size(spikes,1);
if isempty(nUnits), return; end



%% Create correlation matrix

% empirically I found that corrcoef stabilizes the eigenvalues,
% particularly for the low values so I changed it - SB
% these two lines were commented
% n = zscore(spikes);
% correlations = (1/(nBins-1))*n'*n;
% and replaced by this one
correlations = corrcoef(spikes);
correlations(isnan(correlations)) = 0;
% Compute eigenvalues/vectors and sort in descending order
[eigenvectors,eigenvalues] = eig(correlations);
[eigenvalues,i] = sort(diag(eigenvalues),'descend');
eigenvectors = eigenvectors(:,i);

% Enforce a sign convention on the coefficients -- the largest element in each
% column will have a positive sign. - taken from A.Peyrache - SB
[p,d] = size(eigenvectors);
[~,maxind] = max(abs(eigenvectors),[],1);
colsign = sign(eigenvectors(maxind + (0:p:(d-1)*p)));
eigenvectors = bsxfun(@times,eigenvectors,colsign);


%% Keep only significant eigenvalues and compute templates

q = nBins/nUnits;
if q < 1,
    warning('Not enough time bins to determine significant templates');
%     eigenvalues = NaN;
end
lambdaMax = (1+sqrt(1/q))^2;


if AllTemp == 1
    templates = zeros(nUnits,nUnits,length(eigenvalues));
    for i = 1:length(eigenvalues)
        templates(:,:,i) = eigenvectors(:,i)*eigenvectors(:,i)';
        templates(:,:,i) = templates(:,:,i);% - diag(diag(templates(:,:,i))); % remove the diagonal
    end
    
else
    
    significant = eigenvalues>lambdaMax;
    if sum(significant)==0
        significant(1) = 1;
    end
    eigenvectors = eigenvectors(:,significant);
    templates = zeros(nUnits,nUnits,sum(significant));
    
    for i = 1:sum(significant),
        templates(:,:,i) = eigenvectors(:,i)*eigenvectors(:,i)';
        templates(:,:,i) = templates(:,:,i) - diag(diag(templates(:,:,i))); % remove the diagonal
    end
end
