function f_disprof_clustPlot(result,txt)
% - plot dendrogram of a DISPROF-based custer analysis
% 
% USAGE: f_disprof_clustPlot(result,txt);
% 
% result = structure of results obtained from 'f_disprof_clust' function
% txt    = cell array of row labels, if empty autocreate
%          e.g., txt = {'A' 'B' 'C'};
% 
% SEE ALSO: f_disprof_clust

% -----Author:-----
% by David L. Jones, Jan-2014
%
% This file is part of the FATHOM Toolbox for Matlab and is released under
% the GNU General Public License, version 2.

% -----Set defaults & check input:-----
if (nargin < 2), txt = f_num2cell([1:numel(result.grp)]); end % default use grouping vector
% -------------------------------------

% Make sure labels are of compatible size:
txt = txt(:); % force cell array into a column

if size(txt,1) ~= size(result.grp,1)
   error('TXT & RESULT.Z don''t have the same # of rows!')
end

% Create dendrogram:
figure;
set(gcf,'color','w'); % set background color to white
H = dendrogram(result.Z,0,'LABELS',txt,'ORIENTATION','top');

% Flip the order of graphics handles:
H = flipud(H);

% Set the color:
set(H(result.colS==1),'Color','k');          % heterogeneous clusters
set(H(result.colS==0),'Color',[1 1 1]*0.75); % homogeneous clusters

% Customize plot:
box on;
title('\bfDISPROF-based Cluster Analysis');
ylabel('\bfDissimilarity');
