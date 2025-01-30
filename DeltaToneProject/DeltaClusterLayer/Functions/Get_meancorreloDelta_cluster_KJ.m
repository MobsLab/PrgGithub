%%Get_meancorreloDelta_cluster_KJ
% 13.03.2018 KJ
%
% Mean Correlogram Down-Delta, for each clusters
%
% [meancurves, legend_curve] = Get_meancorreloDelta_cluster_KJ(night, clusters)
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
%       LFPlayerInfluenceOnDetectionMouse
%


function [meancurves, legend_curve] = Get_meancorreloDelta_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

smoothing=1;

load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysisCrossCorr.mat'))

night_path = unique(night(:,1));


%% normalize the correlogram, dividing by rip-down
for n=1:length(night_path)
    p = night_path(n); 
    nb_channels = length(singcor_res.channels{p});
    multi_peak = max(singcor_res.down_delta.y{p,nb_channels});
    
    for ch=1:nb_channels
        norm_correlograms{p,ch} = singcor_res.down_delta.y{p,ch} / multi_peak;
    end
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
        try
            y_curve = norm_correlograms{p,ch};
            curves_event_k = [curves_event_k y_curve];
            x_curve = singcor_res.down_delta.x{p,ch};
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


%% multi layer correlogram
k = nb_clusters+1;
curves_event_k = []; x_curve = [];
legend_curve{k}='2-layers';
for n=1:length(night_path)
    p = night_path(n);
    ch = length(singcor_res.channels{p});
    %LFP on down
    try
        y_curve = norm_correlograms{p,ch};
        curves_event_k = [curves_event_k y_curve];
        x_curve = singcor_res.down_delta.x{p,ch};
    end
end
%save
meancurves.x{k} = x_curve;
meancurves.y{k} = Smooth(mean(curves_event_k,2),smoothing);  

end


