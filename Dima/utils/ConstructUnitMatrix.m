%ConstructUnitMatrix - Construct unit matrix to use in IsolationDistance function.
%
% Creates matrix that defines which IsolatoinDistance needs to process 
%
%  USAGE
%
%    units = ConstructUnitMatrix(tetrodeChannels, TT)
%
%    tetrodeChannels       a cell containing channels of each electrode
%    group
%    TT     a cell that contains a number of electrode group and a number
%    of cluster for each of the clusters
%
%  OUTPUT
%
%       <units>
%    A cell with as many units matrices as you have the electrode groups
%
%       SEE
%     
%   IsolationDistance, CalcBasicNeuronInfo
% 
% Copyright (C) 2018 by Dmitri Bryzgalov
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or
% (at your option) any later version.

function units = ConstructUnitMatrix(tetrodeChannels, TT)

units = cell(1,length(tetrodeChannels));

%% Find number of units in one electrode group (including MUA)

N_temp = [TT{:}];
N_elec = N_temp(1:2:end); % This vector contains number of electrode groups
N_unit = N_temp(2:2:end); % This vector contains number of clusters

lastgroup = max(N_elec);

if lastgroup ~= length (tetrodeChannels)
    error ('TT does not match tetrodeChannels');
end

NClust = ones(1,length(tetrodeChannels));
ClustStart = ones(1,length(tetrodeChannels));

for j = 1:length(tetrodeChannels)
    Clust = find(N_elec==j);
    ClustStart(j) = N_unit(Clust(1));
    NClust(j) = length(find(N_elec==j));
end

%% Construct the units

for j = 1:length (tetrodeChannels)
    if NClust == 1
       units{j} = [1*j ClustStart(j)]; 
    elseif ClustStart(j) == 2
        units{j} = [ones(NClust(j),1)*j [ClustStart(j):NClust(j)+1]'];
    else
        units{j} = [ones(NClust(j),1)*j [ClustStart(j):NClust(j)]'];
    end
end

units = units;

end