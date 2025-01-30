%%Get_meancorreloGamma_cluster_KJ
% 13.03.2018 KJ
%
% Mean Correlogram Down-GammaDown, for each clusters
%
% [meancurves, legend_curve] = Get_meancorreloGamma_cluster_KJ(night, clusters)
%
% INPUT:
% - nights              = (struct) nights_path + channels 
% - clusters            = clusters of each night 
%
% OUTPUT:
% - meancurves          = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse Get_meancorreloDelta_cluster_KJ GammaDownChannelAnalysisCrossCorr
%


function [meancurves, legend_curve] = Get_meancorreloGamma_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

smoothing=1;

load(fullfile(FolderDeltaDataKJ,'GammaDownChannelAnalysisCrossCorr.mat'))

night_path = unique(night(:,1));


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
        try
            y_curve = gammacorr_res.down_gamma.y{p,ch};
            curves_event_k = [curves_event_k y_curve];
            x_curve = gammacorr_res.down_gamma.x{p,ch};
        end
    end
    
    %save
    if ~isempty(curves_event_k)
        meancurves.x{k} = x_curve;
        meancurves.y{k} = Smooth(mean(curves_event_k,2),smoothing);    
    else
        meancurves.x{k} = [];
        meancurves.y{k} = [];
    end
end
 

end


