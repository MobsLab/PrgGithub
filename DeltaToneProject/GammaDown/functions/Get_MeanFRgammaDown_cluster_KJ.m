%%Get_MeanFRgammaDown_cluster_KJ
% 24.04.2018 KJ
%
% Meancurves Firing rate on gamma down, for each clusters
%
% [meancurves, legend_curve] = Get_MeanFRgammaDown_cluster_KJ(night, clusters, nb_clusters)
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
%       LFPlayerInfluenceOnDetectionMouse Get_MeanFiringRate_cluster_KJ GammaDownChannelAnalysisFiringRate
%


function [meancurves, legend_curve] = Get_MeanFRgammaDown_cluster_KJ(night, clusters, nb_clusters)

load(fullfile(FolderDeltaDataKJ, 'GammaDownChannelAnalysisFiringRate.mat'))


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
        curve_event = gammafr_res.gamma{p}{ch};
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



end







