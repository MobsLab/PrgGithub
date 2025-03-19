%%QuantificationDeltaDetectionLayer
% 25.09.2018 KJ
%
%   
%
% see
%   LFPlayerInfluenceOnDetection
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

[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);

nb_clusters = length(unique(clusterX));
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


%% precision, recall, distances...
[down_recall, precision_detect, fscore_detect, distance_density, diff_decrease, roc_curves, legend_stat] = Get_DownDeltaStat_cluster_KJ(night, clusterX, nb_clusters);

%% mean curves
%on down states
[mc_down_lfp, lgd_down]         = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.down.meandown2, nb_clusters);



%% PLOT

%params plot
show_sig = 'sig';
column_test = [1 6; 2 6; 3 6; 4 6; 5 6];
showPoints = 0;
fontsize=16;

figure, hold on

% 
% %S1 : Mean LFP on down
% subplot(2,2,1), hold on
% for k=1:length(mc_down_lfp.x)
%     try
%         hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
%     end
% end
% xlim([-400 500]), ylim([-2100 2600]),
% line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
% title('Mean LFP on down states'), hold on
% try legend(mdo, lgd_down), end


% %S2 : clusters in 2D scatter plot
% subplot(2,2,1), hold on
% gscatter(X(:,1),X(:,2), clusterX, colori);
% xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
% xlim([-1400 2900]),
% 
% 
% %S3 : F1-score
% column_test = [1 6; 2 6 ; 3 6 ; 4 6; 5 6];
% subplot(2,2,2), hold on
% PlotErrorBarN_KJ(fscore_detect, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig,'ColumnTest', column_test,'showPoints',showPoints);
% set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
% title('F1-score')


%Similarity of density curves
subplot(1,2,1), hold on
PlotErrorBarN_KJ(distance_density, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig,'ColumnTest', column_test,'showPoints',showPoints);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat,'fontsize',fontsize)
title('Distance between delta and down density curves')

%Decrease of density
subplot(1,2,2), hold on
PlotErrorBarN_KJ(diff_decrease, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig,'ColumnTest', column_test,'showPoints',showPoints);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat,'fontsize',fontsize),
ylabel('ratio'),
title('Slope relative difference')


