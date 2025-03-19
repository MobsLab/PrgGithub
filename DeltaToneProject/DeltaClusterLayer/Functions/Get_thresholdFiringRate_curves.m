%%Get_thresholdFiringRate_curves
% 21.03.2018 KJ
%
% Curves firing rate in function of threshold (in std) for each night of
% each cluster
%
% [curves, legend_curve] = Get_MeanFiringRate_cluster_KJ(night, clusters, nb_clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night 
%
% OUTPUT:
% - curves              = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function [curves_firing, curves_density, x_threshold, legend_curve] = Get_thresholdFiringRate_curves(night, clusters, nb_clusters)

load(fullfile(FolderDeltaDataKJ,'DeltaThresholdStdDetectionFiring.mat'))

x_threshold = thD_list;

%% CHECK INPUTS

if nargin < 2
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

night_path = unique(night(:,1));


%% loop on clusters

for k=1:nb_clusters
    
    idx_curves = find(clusters==k);
    curves_firing{k} = cell(0);
    curves_density{k} = cell(0);
    
    %cluster legend
    legend_curve{k}=num2str(k);
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        curves_firing{k}{end+1} = thresh_res.single.firing_rate{p}{ch};
        curves_density{k}{end+1} = thresh_res.single.delta_density{p}{ch};
    end
end

%% multi layer correlogram
k = nb_clusters+1;
curves_firing{k} = cell(0);
curves_density{k} = cell(0);
legend_curve{k} = '2-layers';

for n=1:length(night_path)
    p = night_path(n);
    curves_firing{k}{end+1} = thresh_res.diff.firing_rate{p};
    curves_density{k}{end+1} = thresh_res.diff.delta_density{p};
    
end


end







