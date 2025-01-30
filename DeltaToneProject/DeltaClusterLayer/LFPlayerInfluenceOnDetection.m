%%LFPlayerInfluenceOnDetection
% 13.03.2018 KJ
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Gather data and plot analysis
%   
%
% see
%   LFPlayerInfluenceOnDetectionOld
%   LFPonDownStatesClustering3 DeltaSingleChannelDensityPlot
%   DeltaSingleChannelAnalysis2 LFPlayerInfluenceOnDetectionMouse
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))


%% init
animals = unique(layer_res.name);
gap = [0.07 0.04];

excluded_signals = [];
excluded_nights = [];

% exlusion
% excluded_nights = [excluded_nights 9:12]; %Problem with mouse403
% excluded_nights = [excluded_nights 13:16]; %Problem with mouse451

% 
% bihemisphere = [find(strcmpi(layer_res.name,'Mouse508')) find(strcmpi(layer_res.name,'Mouse509'))]; 
% for p=bihemisphere
%     right_channels = find(layer_res.channels{p}>31);
%     excluded_signals = [excluded_signals ; [repmat(p,length(right_channels),1) right_channels] ];
% end


% selected_path = 1;
% all_path = 1:length(layer_res.path);
% excluded_nights = setdiff(all_path, selected_path);
% 

%% clustering

%feature extraction and clustering
meancurves = layer_res.down.meandown2;
nb_clusters = 5;
algo_clustering = 'manual';
method_features = 'adhoc';

[~, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);

nb_clusters = length(unique(clusterX));
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


%% precision, recall, distances...
[down_recall, precision_detect, fscore_detect, distance_density, diff_decrease, roc_curves, legend_stat] = Get_DownDeltaStat_cluster_KJ(night, clusterX, nb_clusters);


%% mean curves and correlograms

%on down states
[mc_down_lfp, lgd_down]         = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.down.meandown2, nb_clusters);
%on delta waves
[mc_delta_lfp, lgd_delta]       = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.delta.meandelta_ch2, nb_clusters);
%on ripples
[mc_ripples_lfp, lgd_ripples]   = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.ripples_correct.meancurves, nb_clusters);
%mean firing rate
[mc_delta_fr, lgd_fr]           = Get_MeanFiringRate_cluster_KJ(night, clusterX, nb_clusters);

%mean crosscorrelogram down-delta
[co_down_delta, lgd_correlo1] = Get_meancorreloDelta_cluster_KJ(night, clusterX, nb_clusters);
%mean crosscorrelogram ripples-down/delta
[co_ripples_delta, lgd_correlo2] = Get_meancorreloRipples_cluster_KJ(night, clusterX, nb_clusters);


%% quantification of correlogram peaks
[peak_correlogram, legend_corr] = Get_QuantifCorreloDelta_cluster_KJ(night, clusterX, nb_clusters);


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
title('Mean LFP on down states'), hold on
try legend(mdo, lgd_down), end


%S2 : clusters in 2D scatter plot
subtightplot(2,4,2,gap), hold on
gscatter(X(:,1),X(:,2), clusterX, colori);
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),



%S3 - Correlogram down-delta
subtightplot(2,4,3,gap), hold on
for k=1:length(co_down_delta.x)
    try
        hold on, crd(k) = plot(co_down_delta.x{k}, co_down_delta.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-350 350]), title('Mean correlogram down-delta'), hold on
try legend(crd, lgd_correlo1), end


% %S4 : Density similarity 
% subtightplot(2,4,4,gap), hold on
% PlotErrorBarN_KJ(distance_density, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
% set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
% title('Distance between delta and down density curves')

%S4 : F1-score
subtightplot(2,4,4,gap), hold on
PlotErrorBarN_KJ(fscore_detect, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
title('F1-score')


%S5 : Mean LFP on ripples
subtightplot(2,4,5,gap), hold on
for k=1:length(mc_ripples_lfp.x)
    try
        hold on, mr(k) = plot(mc_ripples_lfp.x{k}, mc_ripples_lfp.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean LFP on ripples'), hold on
try legend(mr, lgd_ripples), end


%S6 : Mean Firing rate on deltas
subtightplot(2,4,6,gap), hold on
for k=1:length(mc_delta_fr.x)
    try
        hold on, mfr(k) = plot(mc_delta_fr.x{k}, mc_delta_fr.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean Firing rate on delta waves'), hold on
try legend(mfr, lgd_fr), end


%S7 : Correlogram ripples-delta
subtightplot(2,4,7,gap), hold on
for k=1:length(co_ripples_delta.x)
    try
        hold on, cor(k) = plot(co_ripples_delta.x{k}, co_ripples_delta.y{k},'color', colori_cluster{k});
    end
end
try
    cor(k+1) = plot(co_ripples_delta.x{k}, co_ripples_delta.down,'color', 'k', 'linewidth',2);
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 400]), title('Mean correlogram ripples-delta'), hold on
try legend(cor, [lgd_correlo2 'down']), end


%S8: Quantification of Rip-delta peak
subtightplot(2,4,8,gap), hold on
PlotErrorBarN_KJ(peak_correlogram, 'newfig',0, 'barcolors',[colori_cluster 'k'], 'paired',0, 'ShowSigstar',show_sig);
set(gca,'xtick',1:length(legend_corr),'XtickLabel',legend_corr)
title('Ripples-Delta Coupling')




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
% title('Distance between delta and down density curves')
% 
% %Decrease of density
% PlotErrorBarN_KJ(diff_decrease, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
% set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
% title('Decrease difference')

% %Meal LFP on deltas
% for k=1:length(mc_delta_lfp.x)
%     try
%         hold on, mdl(k) = plot(mc_delta_lfp.x{k}, mc_delta_lfp.y{k},'color', colori_cluster{k});
%     end
% end
% xlim([-400 500]), ylim([-2100 2600]),
% line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
% title('Mean LFP on delta waves'), hold on
% try legend(mdl, lgd_delta), end








