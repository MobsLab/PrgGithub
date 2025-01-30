%%LFPlayerDeltaCluster1
% 04.06.2019 KJ
%
%   Check if layer/cluster of a channel can be estimated only with delta
%   waves and copare with down response
%      
%
% see
%   LFPonDeltaWavesLayer LFPlayerInfluenceOnDetection LFPonDownStatesLayer
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))


%init
gap = [0.07 0.04];
animals = unique(layer_res.name);


for m=1:length(animals)
    
    clearvars -except m layer_res animals gap

    mouse_path = find(strcmpi(animals{m},layer_res.name));
    % exlusion
    excluded_nights = setdiff(1:length(layer_res.path), mouse_path);
    excluded_signals = [];

    nb_clusters = 5;
    algo_clustering = 'manual';
    method_features = 'adhoc';
    
    %feature extraction and clustering
    meancurves_down = layer_res.down.meandown2;
    [all_curves_down, nightDown, Xdown, clusterDown, ~] = Clustering_Curves_KJ(meancurves_down, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                        'excluded_signals',excluded_signals,'excluded_nights',excluded_nights);
    
    meancurves_delta = layer_res.delta.meandelta1;
    [all_curves_delta, nightDelta, Xdelta, clusterDelta, ~] = Clustering_Curves_KJ(meancurves_delta, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                        'excluded_signals',excluded_signals,'excluded_nights',excluded_nights); 
                                    
    meancurves_delta_ch = layer_res.delta.meandelta_ch1;
    [all_curves_delta2, nightDelta2, Xdelta2, clusterDelta2, ~] = Clustering_Curves_KJ(meancurves_delta_ch, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                        'excluded_signals',excluded_signals,'excluded_nights',excluded_nights); 
                                    
    %colors
    colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
    for i=1:nb_clusters+1
        colori_cluster{i} = colori(i,:);
    end


    %% mean curves and correlograms

    %on down states
    [mc_down_lfp, lgd_down]       = Get_MeanSignal_cluster_KJ(nightDown, clusterDown, meancurves_down, nb_clusters);
    %on delta waves
    [mc_delta_lfp, lgd_delta]     = Get_MeanSignal_cluster_KJ(nightDelta, clusterDelta, meancurves_delta, nb_clusters);
    %on delta waves channel
    [mc_delta_lfp2, lgd_delta2]     = Get_MeanSignal_cluster_KJ(nightDelta2, clusterDelta2, meancurves_delta_ch, nb_clusters);
    


    %% PLOT

    %params plot
    show_sig = 'sig';

    %
    figure, hold on

    %S1 : Mean LFP on down
    subtightplot(2,3,1,gap), hold on
    for k=1:length(mc_down_lfp.x)
        try
            hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 500]), title('Mean LFP on down states'), hold on
    try legend(mdo, lgd_down), end

    %S4 : clusters in 2D scatter plot
    subtightplot(2,3,4,gap), hold on
    gscatter(Xdown(:,1),Xdown(:,2), clusterDown, colori(unique(clusterDown),:));
    xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
    xlim([-1400 2900]),  ylim([-1400 400]), title(animals{m}),
    
    

    %S2 : Mean LFP on delta
    subtightplot(2,3,2,gap), hold on
    for k=1:length(mc_delta_lfp.x)
        try
            hold on, mdl(k) = plot(mc_delta_lfp.x{k}, mc_delta_lfp.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 500]), title('Mean LFP on delta waves'), hold on
    try legend(mdl, lgd_delta), end

    %S5 : clusters in 2D scatter plot
    subtightplot(2,3,5,gap), hold on
    gscatter(Xdelta(:,1),Xdelta(:,2), clusterDelta	, colori(unique(clusterDelta),:));
    xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
    xlim([-1400 2900]), ylim([-1400 400]),
    
    
    %S3 : Mean LFP on delta channel
    subtightplot(2,3,3,gap), hold on
    for k=1:length(mc_delta_lfp2.x)
        try
            hold on, mdl(k) = plot(mc_delta_lfp2.x{k}, mc_delta_lfp2.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 500]), title('Mean LFP on delta waves channel'), hold on
    try legend(mdl, lgd_delta2), end

    %S6 : clusters in 2D scatter plot
    subtightplot(2,3,6,gap), hold on
    gscatter(Xdelta2(:,1),Xdelta2(:,2), clusterDelta2	, colori(unique(clusterDelta2),:));
    xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
    xlim([-1400 2900]), ylim([-1400 400]),

end





