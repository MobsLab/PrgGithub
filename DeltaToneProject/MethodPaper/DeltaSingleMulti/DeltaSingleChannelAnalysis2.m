%%DeltaSingleChannelAnalysis2
% 08.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   -> analysis 
%
% see
%   DetectDeltaDepthSingleChannel DeltaSingleChannelAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysis.mat'))
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))


%% clustering

%feature extraction and clustering
meandown = layer_res.down.meandown2;
nb_clusters = 6;
algo_clustering = 'manual';
method_features = 'adhoc';

[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals,'excluded_nights',excluded_nights);
                                
                                
% load(fullfile(FolderProjetDelta,'Data','clusterX.mat'))


nb_clusters = length(unique(clusterX));
colori = distinguishable_colors(nb_clusters);
for i=1:nb_clusters
    colori_cluster{i} = colori(i,:);
end

%order by amplitude
for i=1:nb_clusters
    amplitude_clusters(i) = mean(X(clusterX==i,1));
end
[~, idx_order] = sort(amplitude_clusters);
a=1:nb_clusters; idx_order = a(idx_order);
new_clusterX = nan(length(clusterX),1);
for i=1:nb_clusters
    new_clusterX(clusterX==idx_order(i))=i;
end
clusterX = new_clusterX;

for i=1:length(X)
    InfoX{i} = ['p=' num2str(night(i,1))  ' - ch=' num2str(night(i,2))];
end
    
%% down and delta detection comparison

for p=1:length(single_res.path)

    %densities
    down_density = single_res.density.down{p};
    deltas_densities = single_res.density.delta{p};
    
    for ch=1:length(single_res.channels{p})
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)
            %distances and similarities
            frechet_distance(idx) = DiscreteFrechetDist(down_density, deltas_densities{ch});
            down_only(idx)  = single_res.down_only{p}(ch);
            delta_only(idx) = single_res.delta_only{p}(ch);
            down_delta(idx) = single_res.down_delta{p}(ch);
        end
    end
            
end

%recall, precision, true and false positive
d_recall = down_delta ./ (down_delta + down_only);
for i=1:nb_clusters
    down_recall{i} = d_recall(clusterX==i);
end
d_precision = down_delta ./ (down_delta + delta_only);
for i=1:nb_clusters
    precision_detect{i} = d_precision(clusterX==i);
end

%distance between density curves
for i=1:nb_clusters
    distance_density{i} = frechet_distance(clusterX==i);
end


%% PLOT
figure, hold on

for k=1:nb_clusters
    
    idx_curves = find(clusterX==k);
    curves_down_k = [];
    curves_ripples_k = [];
    legd{k} = num2str(k); %cluster legend
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %LFP on down
        curve_down = layer_res.down.meancurves2{p}{ch};
        curves_down_k = [curves_down_k curve_down(:,2)];
        x_down = curve_down(:,1);
        
        %LFP on ripples
        curve_ripple = layer_res.ripples.meancurves{p}{ch};
        if ~isempty(curve_ripple)
            curves_ripples_k = [curves_ripples_k curve_ripple(:,2)];
            x_rip = curve_ripple(:,1);
        end
        
    end
    
    %average
    mean_down    = mean(curves_down_k,2);
    mean_ripples = mean(curves_ripples_k,2);
    
    % mean LFP on down states
    subplot(2,3,1), 
    hold on, md(k) = plot(x_down, mean_down,'color', colori_cluster{k});
    
    % mean LFP on ripples
    subplot(2,3,4), 
    hold on, mr(k) = plot(x_rip, mean_ripples,'color', colori_cluster{k});
    
end

%plot properties
subplot(2,3,1), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(md, legd), title('Mean LFP on down states'), hold on
subplot(2,3,4), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(mr, legd), title('Mean LFP on ripples'), hold on


%clusters in 2D scatter plot
subplot(2,3,2), hold on
gscatter(X(:,1),X(:,2), clusterX, colori)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),

%Recall
subplot(2,3,3), hold on
% PlotErrorSpreadN_KJ(down_recall,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(down_recall,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar','none');
title('Recall of down states')

%Similarity of density curves
subplot(2,3,5), hold on
% PlotErrorSpreadN_KJ(distance_density,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(distance_density,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar','none');
title('Distance between delta and down density curves')

%Precision
subplot(2,3,6), hold on
% PlotErrorSpreadN_KJ(precision_detect,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(precision_detect,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar','none');
title('Precision of detection')






