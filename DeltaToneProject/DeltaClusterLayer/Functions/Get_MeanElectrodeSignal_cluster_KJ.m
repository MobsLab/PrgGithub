%%Get_MeanElectrodeSignal_cluster_KJ
% 13.03.2018 KJ
%
% Meancurves LFP on ripples, for each clusters (averaged by electrode)
%
% [meancurves, legend_curve] = Get_MeanElectrodeSignal_cluster_KJ(night, clusters)
%
% INPUT:
% - electrodes          = list of unique pair (animal,channel)
% - all_electrodes      = all electrodes corresponding to curves_struct
% - clusters            = clusters of each night 
% - curves_struct       = structure containing mean curves of each night and channel 
%
% OUTPUT:
% - meancurves          = (struct) mean LFP on Down staesfor each clusters
% - legend_curve        = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse Get_MeanSignal_cluster_KJ LayerClusterAveragePerChannel
%


function [meancurves, legend_curve] = Get_MeanElectrodeSignal_cluster_KJ(electrodes, all_electrodes, clusters, curves_struct, nb_clusters)


%% CHECK INPUTS

if nargin < 4
  error('Incorrect number of parameters.');
elseif nargin < 5
    nb_clusters = max(clusters);
end


%% average curves by electrode
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    elec_frechet    = [];
    elec_decrease   = [];
    
    %look for electrode data
    for p=1:length(all_electrodes)
        if strcmpi(animals{m},single_res.name{p})
            channels = single_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    %recall, precision, fscore
                    recall = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.down_only{p}(ch));
                    precision = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.delta_only{p}(ch));
                    fscore = 2 * recall .* precision / (recall + precision);
                    
                    elec_recall     = [elec_recall recall];
                    elec_precision  = [elec_precision precision];
                    elec_fscore     = [elec_fscore fscore];
                    elec_frechet    = [elec_frechet single_res.density.distance{p}{ch}];
                    elec_decrease   = [elec_decrease single_res.density.decrease{p}{ch}];
                    
                end
            end
        end
    end
    
    %mean and save
    average_res.recall(i)    = mean(elec_recall);
    average_res.precision(i) = mean(elec_precision);
    average_res.fscore(i)    = mean(elec_fscore);
    average_res.frechet(i)   = mean(elec_frechet);
    average_res.decrease(i)  = mean(elec_decrease);
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


