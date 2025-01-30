%%LFPlayerInfluenceFigures
% 15.03.2018 KJ
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Gather data and plot analysis
%   
%
% see
%   LFPlayerInfluenceOnDetection LFPlayerInfluenceOnDetectionMouse
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))



%% exlusion
excluded_nights = [];
excluded_nights = [excluded_nights 9:12]; %Problem with mouse403
excluded_nights = [excluded_nights 13:16]; %Problem with mouse451

excluded_signals = [5:8;1 1 1 1]';

%exclude signals from right hemisphere in 508-509
bihemisphere = [find(strcmpi(layer_res.name,'Mouse508')) find(strcmpi(layer_res.name,'Mouse509'))]; 
for p=bihemisphere
    right_channels = find(layer_res.channels{p}>31);
    excluded_signals = [excluded_signals ; [repmat(p,length(right_channels),1) right_channels] ];
end


%% clustering

%feature extraction and clustering
meancurves = layer_res.down.meandown2;
nb_clusters = 5;
algo_clustering = 'manual';
method_features = 'adhoc';

[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);

%colors
nb_clusters = length(unique(clusterX));
colori = [distinguishable_colors(nb_clusters) ; 0.4 0.4 0.4];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


%% mean curves and correlograms

%on down states
[mc_down_lfp, lgd_down]         = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.down.meandown2, nb_clusters);
%on ripples
[mc_ripples_lfp, lgd_ripples]   = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.ripples_correct.meancurves, nb_clusters);
%mean firing rate
[mc_delta_fr, lgd_fr]           = Get_MeanFiringRate_cluster_KJ(night, clusterX, nb_clusters);

%mean crosscorrelogram down-delta
[co_down_delta, lgd_correlo] = Get_meancorreloDelta_cluster_KJ(night, clusterX, nb_clusters);


%% PLOT



%Fig1 : Mean LFP on down
figure, hold on
for k=1:length(mc_down_lfp.x)
    try
        hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
    end
end
set(gca,'xlim',[-300 500])
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.7 0.7 0.7]),
legend(mdo, lgd_down),
title('Mean LFP on down states'), 
set(gca,'FontName','Times','fontsize',20),


%Fig2 : clusters in 2D scatter plot
figure, hold on
gscatter(X(:,1),X(:,2), clusterX, colori,'.',30);
set(gca,'xlim',[-1200 2500],'ylim',[-1400 400], 'ytick', -1200:400:400)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
set(gca,'FontName','Times','fontsize',20),


%Fig3 - Correlogram down-delta
figure, hold on
for k=1:length(co_down_delta.x)
    try
        hold on, crd(k) = plot(co_down_delta.x{k}, co_down_delta.y{k},'color', colori_cluster{k});
    end
end
set(gca,'xlim',[-200 300],'xtick',-200:100:300,'ylim',[0 1.4], 'ytick', [0 0.5 1 1.4])
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.7 0.7 0.7])
xlabel('ms'), legend(crd, lgd_correlo), 
title('Mean correlogram down-delta'),
set(gca,'FontName','Times','fontsize',20),


%Fig4 : Mean LFP on ripples
figure, hold on
for k=1:length(mc_ripples_lfp.x)
    hold on, mr(k) = plot(mc_ripples_lfp.x{k}, mc_ripples_lfp.y{k},'color', colori_cluster{k});
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.7 0.7 0.7])
xlim([-400 500]), legend(mr, lgd_ripples)
title('Mean LFP on ripples'), hold on
set(gca,'FontName','Times','fontsize',20),


%Fig5 : Mean Firing rate on deltas
figure, hold on
for k=1:length(mc_delta_fr.x)
    hold on, mfr(k) = plot(mc_delta_fr.x{k}, mc_delta_fr.y{k},'color', colori_cluster{k});
end
set(gca,'xlim',[-400 400],'xtick',-400:200:400,'ylim',[0 1.6], 'ytick', 0:0.5:1.5)
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.7 0.7 0.7])
legend(mfr, lgd_fr)
title('Mean Firing rate on delta waves'), hold on
set(gca,'FontName','Times','fontsize',20),





