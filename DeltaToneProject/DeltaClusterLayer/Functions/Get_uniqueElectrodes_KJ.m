%%Get_uniqueElectrodes_KJ
% 22.07.2019 KJ
%
% Data of delta/down detection for each clusters
%
% [animals, electrodes, all_electrodes, ecog] = Get_uniqueElectrodes_KJ(struct_res)
%
% INPUT:
% - struct_res              = (struct) structure containing path, animals name, channels                         
%
%
% OUTPUT:
% - animals                 = list of mice
% - electrodes              = list of unique pair (animals, channel)
% - all_electrodes          = all pairs (animals, channel)
% - ecog                    = boolean - which electrode is ecog  
%
%   see 
%       LayerClusterAveragePerChannel
%


function [animals, electrodes,all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(struct_res,varargin)


%% CHECK INPUTS

if nargin < 1 
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'exclude'
            exclude = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('exclude','var')
    exclude=[];
end

%animals
animals = unique(struct_res.name);
if ~isempty(exclude)
    for i=1:length(exclude)
        animals(strcmpi(animals,exclude{i})) = [];
    end
end

% electrodes
all_electrodes = [];
for p=1:length(struct_res.path)
    if ismember(struct_res.name{p},animals)
        channels = struct_res.channels{p};
        for ch=1:length(channels)
            row_elec = [find(strcmpi(animals,struct_res.name{p})) channels(ch) ismember(channels(ch),struct_res.ecogs{p})];
            all_electrodes = [all_electrodes ; row_elec];
        end
    end
end
electrodes = unique(all_electrodes, 'rows');

%results
all_electrodes = all_electrodes(:,1:2);
ecogs = electrodes(:,3);
electrodes = electrodes(:,1:2);


end


