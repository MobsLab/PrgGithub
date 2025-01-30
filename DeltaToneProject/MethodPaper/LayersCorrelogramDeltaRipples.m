%%LayersCorrelogramDeltaRipples
% 15.03.2018 KJ
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Coupling delta ripples in function of the clusters
%   
%
% see
%   LFPlayerInfluenceOnDetection LFPlayerInfluenceOnDetectionMouse
%


% load
clear
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))



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
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end

%% DATA
% mean crosscorrelogram ripples-down/delta
[co_ripples_delta, lgd_correlo] = Get_meancorreloRipples_cluster_KJ(night, clusterX, nb_clusters);

% quantification of correlogram peaks
[peak_correlogram, legend_bar] = Get_QuantifCorreloDelta_cluster_KJ(night, clusterX, nb_clusters);
columntest = [];
for k=1:length(co_ripples_delta.x)
    columntest = [ columntest ; [length(co_ripples_delta.x)+1 k] ];
end


%% PLOT

%Fig1 - Correlogram ripples vs down/delta-multi
figure, hold on

hold on, cor(1) = plot(co_ripples_delta.x{end}, co_ripples_delta.y{end}, 'color', colori_cluster{end}, 'linewidth',2); %multi layer
hold on, cor(2) = plot(co_ripples_delta.x{end}, co_ripples_delta.down,   'color', 'k', 'linewidth',2); %down states 
%properties
set(gca,'xlim',[-400 400],'ylim',[0 1.1], 'ytick', 0:0.2:1)
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.7 0.7 0.7])
xlabel('ms'), legend(cor, [lgd_correlo{end}, {'down'}]), 
title('Mean correlogram on SPW-ripples'),
set(gca,'FontName','Times','fontsize',20),


%Fig2 -Quantification of Rip-delta peak
show_sig = 'sig';
figure, hold on
PlotErrorBarN_KJ(peak_correlogram, 'newfig',0, 'barcolors',[colori_cluster 'k'], 'paired',0, 'ShowSigstar',show_sig,'ColumnTest',columntest);
set(gca,'xtick',1:length(legend_bar),'XtickLabel',legend_bar)
title('Ripples-Delta Coupling')
set(gca, 'ytick', 0:1:3, 'FontName','Times','fontsize',20),










