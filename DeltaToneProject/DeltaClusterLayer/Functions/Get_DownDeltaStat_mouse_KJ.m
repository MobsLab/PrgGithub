%%Get_DownDeltaStat_mouse_KJ
% 13.03.2018 KJ
%
% Data of delta/down detection for each clusters, averaged by mouse
%
% [down_recall precision_detect distance_density diff_decrease, legend_stat] = Get_DownDeltaStat_mouse_KJ
%
% INPUT:
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
%       LayerClusterAveragePerChannel LFPlayerInfluenceOnDetectionMouse Get_DownDeltaStat_cluster_KJ 
%


function [down_recall, precision_detect, fscore_detect, distance_density, diff_decrease, roc_curves, legend_stat] = Get_DownDeltaStat_mouse_KJ


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





end