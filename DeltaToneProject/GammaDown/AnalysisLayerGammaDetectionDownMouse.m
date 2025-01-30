%%AnalysisLayerGammaDetectionDownMouse
% 24.04.2018 KJ
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   Compare layers for the detection of down states via gamma
%   
%   -> Gather data and plot analysis
%   
%
% see
%   LFPlayerInfluenceOnDetection LFPlayerInfluenceOnDetectionMouse AnalysisLayerGammaDetectionDown
%
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayerGamma.mat'))


%% init
animals = unique(layer_res.name);
gap = [0.07 0.04];


animals = unique(layer_res.name);


for m=1:length(animals)


    clearvars -except m layer_res animals layergam_res gap

    mouse_path = find(strcmpi(animals{m},layer_res.name));
    % exlusion
    excluded_nights = setdiff(1:length(layer_res.path), mouse_path);
    excluded_signals = [];


    %% clustering

    %feature extraction and clustering
    meancurves = layer_res.down.meandown2;
    nb_clusters = 5;
    algo_clustering = 'manual';
    method_features = 'adhoc';

    [all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                        'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);

    nb_clusters = max(clusterX);
    colori = distinguishable_colors(nb_clusters);
    for i=1:nb_clusters
        colori_cluster{i} = colori(i,:);
    end


    %% precision, recall, distances...
    [down_recall, precision_detect, distance_density, diff_decrease, legend_stat] = Get_DownGammaStat_detection_KJ(night, clusterX, nb_clusters);


    %% mean curves and correlograms

    %on down states
    [mc_down_lfp, lgd_down]       = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.down.meandown2, nb_clusters);
    %on gammaDown
    [mc_gamma_lfp, lgd_gammad]    = Get_MeanSignal_cluster_KJ(night, clusterX, layergam_res.meangamma2, nb_clusters);
    %mean firing rate
    [mc_gamma_fr, lgd_fr]         = Get_MeanFRgammaDown_cluster_KJ(night, clusterX, nb_clusters);

    %mean crosscorrelogram down-delta
    [co_down_gamma, lgd_correlo1] = Get_meancorreloGamma_cluster_KJ(night, clusterX, nb_clusters); %TODO
    %mean crosscorrelogram ripples-down/delta
    [co_ripples_gamma, lgd_correlo2] = Get_meancorreloRipplesGamma_cluster_KJ(night, clusterX, nb_clusters); %TODO


    %% quantification of correlogram peaks
    [peak_correlogram, legend_corr] = Get_QuantifCorreloGamma_cluster_KJ(night, clusterX, nb_clusters); %TODO


    %% PLOT

    %params plot
    show_sig = 'sig';


    figure, hold on


    %S1 : Mean LFP on down
    subtightplot(2,4,1,gap), hold on
    for k=1:length(mc_down_lfp.x)
        try
            hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
        end
    end
    xlim([-400 500]), ylim([-2100 2600]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    title('Mean LFP on down state'), hold on
    try legend(mdo, lgd_down), end


    %S2 : clusters in 2D scatter plot
    subtightplot(2,4,2,gap), hold on
    colori = colori(unique(clusterX),:);
    gscatter(X(:,1),X(:,2), clusterX, colori);
    xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
    xlim([-1400 2900]),
    title(animals{m})


    %S3 - Correlogram down-delta
    subtightplot(2,4,3,gap), hold on
    for k=1:length(co_down_gamma.x)
        try
            hold on, crd(k) = plot(co_down_gamma.x{k}, co_down_gamma.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-350 350]), title('Mean correlogram down-gammadown'), hold on
    try legend(crd, lgd_correlo1), end


    %S4 : Density similarity 
    subtightplot(2,4,4,gap), hold on
    PlotErrorBarN_KJ(distance_density, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
    set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
    title('Distance between density curves')


    %S5 : Mean LFP on gamma down
    subtightplot(2,4,5,gap), hold on
    for k=1:length(mc_gamma_lfp.x)
        try
            hold on, mdl(k) = plot(mc_gamma_lfp.x{k}, mc_gamma_lfp.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 500]), title('Mean LFP on gamma down'), hold on
    try legend(mdl, lgd_gammad), end

    %S6 : Mean Firing rate on deltas
    subtightplot(2,4,6,gap), hold on
    for k=1:length(mc_gamma_fr.x)
        try
            hold on, mfr(k) = plot(mc_gamma_fr.x{k}, mc_gamma_fr.y{k},'color', colori_cluster{k});
        end
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 500]), title('Mean Firing rate on gamma down'), hold on
    try legend(mfr, lgd_fr), end


    %S7 : Correlogram ripples-delta
    subtightplot(2,4,7,gap), hold on
    for k=1:length(co_ripples_gamma.x)
        try
            hold on, cor(k) = plot(co_ripples_gamma.x{k}, co_ripples_gamma.y{k},'color', colori_cluster{k});
        end
    end
    try
        cor(k+1) = plot(co_ripples_gamma.x{k}, co_ripples_gamma.down,'color', 'k', 'linewidth',2);
    end
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
    xlim([-400 400]), title('Mean correlogram Ripples-GammaDown'), hold on
    try legend(cor, [lgd_correlo2 'down']), end


    %S8: Quantification of Rip-delta peak
    subtightplot(2,4,8,gap), hold on
    PlotErrorBarN_KJ(peak_correlogram, 'newfig',0, 'barcolors',[colori_cluster 'k'], 'paired',0, 'ShowSigstar',show_sig);
    set(gca,'xtick',1:length(legend_corr),'XtickLabel',legend_corr)
    title('Ripples-GammaDown Coupling')




    %%

    %Recall
    % PlotErrorBarN_KJ(down_recall, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
    % set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
    % title('Recall of down states')

    %Precision
    % PlotErrorBarN_KJ(down_recall, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
    % set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
    % title('Precision of detection')

    % %Similarity of density curves
    % PlotErrorBarN_KJ(distance_density, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
    % set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
    % title('Distance between gamma-down and down density curves')
    % 
    % %Decrease of density
    % PlotErrorBarN_KJ(diff_decrease, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
    % set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
    % title('Decrease difference')


end







