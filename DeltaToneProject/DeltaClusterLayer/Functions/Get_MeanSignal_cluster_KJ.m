%%Get_MeanSignal_cluster_KJ
% 13.03.2018 KJ
%
% Meancurves LFP on ripples, for each clusters
%
% [meancurves, legend_curve] = Get_MeanLFPonEvent_cluster_KJ(night, clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night 
% - curves_struct       = structure containing mean curves of each night and channel 
%
% OUTPUT:
% - meancurves          = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function [meancurves, legend_curve] = Get_MeanSignal_cluster_KJ(night, clusters, curves_struct, nb_clusters)


%% CHECK INPUTS

if nargin < 3
  error('Incorrect number of parameters.');
elseif nargin < 4
    nb_clusters = max(clusters);
end


%% loop on clusters

for k=1:nb_clusters
    
    idx_curves = find(clusters==k);
    curves_event_k = [];
    
    %cluster legend
    legend_curve{k}=num2str(k);
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %LFP on down
        curve_event = curves_struct{p}{ch};
        try
            curves_event_k = [curves_event_k curve_event(:,2)];
            x_curve = curve_event(:,1);
        end
    end
    
    %save
    if ~isempty(curves_event_k)
        meancurves.x{k} = x_curve;
        meancurves.y{k} = mean(curves_event_k,2);    
    else
        meancurves.x{k} = [];
        meancurves.y{k} = [];
    end
end


end


