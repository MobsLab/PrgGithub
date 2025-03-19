%%Get_MeanFiringRate_cluster_KJ
% 13.03.2018 KJ
%
% Meancurves Firing rate on delta waves, for each clusters and multi layer
%
% [meancurves, legend_curve] = Get_MeanFiringRate_cluster_KJ(night, clusters, nb_clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night 
%
% OUTPUT:
% - meancurves          = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function [meancurves, legend_curve] = Get_MeanFiringRate_cluster_KJ(night, clusters, nb_clusters)

load(fullfile(FolderDeltaDataKJ, 'DeltaSingleChannelAnalysisFiringRate.mat'))


%% CHECK INPUTS

if nargin < 2
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

night_path = unique(night(:,1));
normalisation = 1;

%% loop on clusters

for k=1:nb_clusters
    
    idx_curves = find(clusters==k);
    curves_event_k = [];
    
    %cluster legend
    legend_curve{k}=num2str(k);
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %Concatenate
        curve_event = singfr_res.deltas{p}{ch};
        try
            y_centered = CenterFiringRateCurve(curve_event(:,1), curve_event(:,2), normalisation);
            curves_event_k = [curves_event_k y_centered];
            x_curve = curve_event(:,1);
        end
    end
    
    %save
    if ~isempty(curves_event_k)
        meancurves.x{k} = x_curve;
        meancurves.y{k} = Smooth(mean(curves_event_k,2),1);    
    else
        meancurves.x{k} = [];
        meancurves.y{k} = [];
    end
end

%% multi layer correlogram
k = nb_clusters+1;
curves_event_k = []; x_curve = [];
legend_curve{k}='2-layers';

for n=1:length(night_path)
    p = night_path(n);
    ch = length(singfr_res.channels{p});
    curve_event = singfr_res.deltas{p}{ch};
    %Concatenate
    try
        y_centered = CenterFiringRateCurve(curve_event(:,1), curve_event(:,2), normalisation);
        curves_event_k = [curves_event_k y_centered];
        x_curve = curve_event(:,1);
    end
end
%save
meancurves.x{k} = x_curve;
meancurves.y{k} = Smooth(mean(curves_event_k,2),1); 


end







