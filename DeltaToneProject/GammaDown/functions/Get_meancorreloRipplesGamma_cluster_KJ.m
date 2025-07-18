%%Get_meancorreloRipplesGamma_cluster_KJ
% 24.04.2018 KJ
%
% Mean Correlogram Ripples-delta, for each clusters
%
% [meancurves, legend_curve] = Get_meancorreloRipplesGamma_cluster_KJ(night, clusters)
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
%       LFPlayerInfluenceOnDetectionMouse Get_meancorreloRipples_cluster_KJ
%       GammaDownChannelAnalysisCrossCorr
%


function [meancurves, legend_curve] = Get_meancorreloRipplesGamma_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

smoothing=3;

load(fullfile(FolderDeltaDataKJ,'GammaDownChannelAnalysisCrossCorr.mat'))

night_path = unique(night(:,1));


%% normalize the correlogram, dividing by rip-down
for n=1:length(night_path)
    p = night_path(n); 
    nb_channels = length(gammacorr_res.channels{p});
    
    try
        ripdown_peak = max(gammacorr_res.rip_down.y{p});
        norm_down{p} = gammacorr_res.rip_down.y{p} / ripdown_peak;
        
        for ch=1:nb_channels
            norm_correlograms{p,ch} = gammacorr_res.rip_gamma.y{p,ch} / ripdown_peak;
        end
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
        
        %Concatenate
        try
            y_curve = norm_correlograms{p,ch};
            curves_event_k = [curves_event_k y_curve];
            x_curve = gammacorr_res.rip_gamma.x{p,ch};
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


%% down state correlogram
curves_event_k = [];
for n=1:length(night_path)
    p = night_path(n);
    %LFP on down
    try
        y_curve = norm_down{p};
        curves_event_k = [curves_event_k y_curve];
    end
end
%save
meancurves.down = Smooth(mean(curves_event_k,2),smoothing);

end


