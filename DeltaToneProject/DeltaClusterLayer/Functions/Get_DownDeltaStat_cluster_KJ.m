%%Get_DownDeltaStat_detection_KJ
% 13.03.2018 KJ
%
% Data of delta/down detection for each clusters
%
% [down_recall precision_detect distance_density diff_decrease, legend_stat] = Get_DownDeltaStat_cluster_KJ(nights, clusters)
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
% - fscore_detect           = (struct) f1-score of detection for clusters   
% - distance_density        = (struct) distance between density curves clusters 
% - diff_decrease           = (struct) difference in density slope for clusters 
% - roc_curves              = (struct) roc curves for precision/recall
% - legend_stat             = legend
%
%
%   see 
%       LFPlayerInfluenceOnDetectionMouse
%


function [down_recall, precision_detect, fscore_detect, distance_density, diff_decrease, roc_curves, legend_stat] = Get_DownDeltaStat_cluster_KJ(night, clusters, nb_clusters)


%% CHECK INPUTS

if nargin < 2 
  error('Incorrect number of parameters.');
elseif nargin < 3
    nb_clusters = max(clusters);
end

%load
load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysis.mat')) %DeltaSingleChannelAnalysis


%% loop for distances and similarities

night_path = unique(night(:,1));

%single layer
for n=1:length(night_path)
    p = night_path(n);  
    for ch=1:length(single_res.channels{p})
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)            
            ratio_decrease(idx) = abs(single_res.density.decrease{p}{ch});
            frechet_distance(idx) = single_res.density.distance{p}{ch};
            down_only(idx)  = single_res.down_only{p}(ch);
            delta_only(idx) = single_res.delta_only{p}(ch);
            down_delta(idx) = single_res.down_delta{p}(ch);
        end
    end     
end


%multi layer
for n=1:length(night_path)
    p = night_path(n);    
    ch = find(single_res.channels{p}==-1);

    multi.ratio_decrease(n) = abs(single_res.density.decrease{p}{ch});
    multi.frechet_distance(n) = single_res.density.distance{p}{ch};
    multi.down_only(n)  = single_res.down_only{p}(ch);
    multi.delta_only(n) = single_res.delta_only{p}(ch);
    multi.down_delta(n) = single_res.down_delta{p}(ch);
    
end


%% Regroup by clusters and add data of multi layer

%recall, precision, true and false positive
d_recall = down_delta ./ (down_delta + down_only);
for i=1:nb_clusters
    down_recall{i} = d_recall(clusters==i);
end
down_recall{end+1} = multi.down_delta ./ (multi.down_delta + multi.down_only);

d_precision = down_delta ./ (down_delta + delta_only);
for i=1:nb_clusters
    precision_detect{i} = d_precision(clusters==i);
end
precision_detect{end+1} = multi.down_delta ./ (multi.down_delta + multi.delta_only);

%f1-score
for i=1:length(precision_detect)
    fscore_detect{i} = 2 * down_recall{i} .* precision_detect{i} ./ (down_recall{i} + precision_detect{i});
end

%distance between density curves
for i=1:nb_clusters
    distance_density{i} = frechet_distance(clusters==i);
end
distance_density{end+1} = multi.frechet_distance;

%ratio of change in decrease density
for i=1:nb_clusters
    diff_decrease{i} = ratio_decrease(clusters==i);
end
diff_decrease{end+1} = multi.ratio_decrease;


%legend
for i=1:nb_clusters
    legend_stat{i} = num2str(i);
end
legend_stat{end+1} = '2-layers';



%% ROC curves for precision/recall
for i=1:length(down_recall)
    recall      = down_recall{i};
    precision   = precision_detect{i};
    
    %sort for graph
    [precision, idx] = sort(precision);
    recall = recall(idx);
    
    roc_curves.x{i} = precision;
    roc_curves.y{i} = recall;
end

%fix
for i=1:nb_clusters
    if sum(clusters==i)==0
        down_recall{i} = 0;
        precision_detect{i} = 0;
        distance_density{i} = 0;
        diff_decrease{i} = 0;
        roc_curves.x{i} = 0;
        roc_curves.y{i} = 0;
    end
end


end


