%%Get_DownGammaStat_detection_KJ
% 24.04.2018 KJ
%
% Data of gammadown/down detection for each clusters
%
% [down_recall precision_detect distance_density diff_decrease, legend_stat] = Get_DownGammaStat_detection_KJ(nights, clusters)
%
% INPUT:
% - nights                  = (struct) nights_path + channels 
% - clusters                = clusters of each night                          
%

%
%
% OUTPUT:
% - down_recall             = (struct) recall of down states for clusters 
% - precision_detect        = (struct) precision of detection for clusters   
% - distance_density        = (struct) distance between density curves clusters 
% - diff_decrease           = (struct) difference in density slope for clusters 
% - roc_curves              = (struct) roc curves for precision/recall
% - legend_stat             = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse Get_DownDeltaStat_cluster_KJ GammaDownChannelAnalysis
%


function [down_recall, precision_detect, distance_density, diff_decrease, legend_stat] = Get_DownGammaStat_detection_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

%load
load(fullfile(FolderDeltaDataKJ,'GammaDownChannelAnalysis.mat'))


%% loop for distances and similarities

night_path = unique(night(:,1));

%single layer
for n=1:length(night_path)
    p = night_path(n);  
    for ch=1:length(analyz_res.channels{p})
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)            
            ratio_decrease(idx) = abs(analyz_res.density.decrease{p}{ch});
            frechet_distance(idx) = analyz_res.density.distance{p}{ch};
            down_only(idx)  = analyz_res.down_only{p}(ch);
            gamma_only(idx) = analyz_res.gamma_only{p}(ch);
            down_gamma(idx) = analyz_res.down_gamma{p}(ch);
        end
    end     
end


%% Regroup by clusters and add data of multi layer

%recall, precision, true and false positive
d_recall = down_gamma ./ (down_gamma + down_only);
for i=1:nb_clusters
    down_recall{i} = d_recall(clusters==i);
end

d_precision = down_gamma ./ (down_gamma + gamma_only);
for i=1:nb_clusters
    precision_detect{i} = d_precision(clusters==i);
end

%distance between density curves
for i=1:nb_clusters
    distance_density{i} = frechet_distance(clusters==i);
end

%ratio of change in decrease density
for i=1:nb_clusters
    diff_decrease{i} = ratio_decrease(clusters==i);
end

%legend
for i=1:nb_clusters
    legend_stat{i} = num2str(i);
end


%fix
for i=1:nb_clusters
    if sum(clusters==i)==0
        down_recall{i} = 0;
        precision_detect{i} = 0;
        distance_density{i} = 0;
        diff_decrease{i} = 0;
    end
end


end


