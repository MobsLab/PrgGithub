%%DeltaDensityCompareChannel1
% 15.03.2018 KJ
%
%   Plot down and delta density for PFCx channels of one mouse
%   -> plot  
%
% see
%   DeltaMultiChannelAnalysis2 DeltaSingleChannelDensityPlot
%


clear

%params
nb_clusters = 5;
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


% load
load([FolderProjetDelta 'Data/DeltaSingleChannelAnalysis.mat'])
Dir = PathForExperimentsBasalSleepSpike;
density = single_res.density;

smoothing = 0;

%night and channels
p=18;
night_cluster = [];
night_cluster = [night_cluster ; p 8 2];
night_cluster = [night_cluster ; p 4 4];



%down
[x_down, y_down] = AdaptDensityCurves(density.x{p}, density.down{p},smoothing);
idx_down = y_down > max(y_down)/8;
[p_down,~]  = polyfit(x_down(idx_down), y_down(idx_down), 1);
reg_down    = polyval(p_down,x_down);

%multi layer
[x_multi, y_multi] = AdaptDensityCurves(density.x{p}, density.delta{p}{end},smoothing);
%distances and similarities
frechet_distance = DiscreteFrechetDist(y_down, y_multi);
%regression
idx_multi = y_multi > max(y_multi)/8;
[p_multi,~] = polyfit(x_multi(idx_multi), y_multi(idx_multi), 1);
reg_multi   = polyval(p_multi,x_multi);


%% PLOT
figure, hold on
subplot(2,2,1:2), hold on

%down
h(1) = plot(x_down, y_down, 'color', 'b','linewidth',2); hold on
plot(x_down, reg_down, 'color', 'b','linewidth',2), hold on
lgd{1} = 'Down state';
%multi
h(2) = plot(x_multi, y_multi, 'color', colori_cluster{end},'linewidth',2); hold on
plot(x_multi, reg_multi, 'color', colori_cluster{end},'linewidth',2),
lgd{2} = ['Multi-layer  - distance ' num2str(frechet_distance)];

for i=1:size(night_cluster,1)
        
    ch = night_cluster(i,2);
    %delta
    [x_delta, y_delta] = AdaptDensityCurves(density.x{p}, density.delta{p}{ch},smoothing);
    
    %distances and similarities
    frechet_distance = DiscreteFrechetDist(y_down, y_delta);
    %regression
    idx_delta = y_delta > max(y_delta)/8;
    [p_delta,~] = polyfit(x_delta(idx_delta), y_delta(idx_delta), 1);
    reg_delta   = polyval(p_delta,x_delta);

    %plot
    h(i+2) = plot(x_delta, y_delta, 'color', colori_cluster{night_cluster(i,3)}); hold on
    plot(x_delta, reg_delta, 'color', colori_cluster{night_cluster(i,3)}),
    
    lgd{i+2} = [ 'Channel ' num2str(single_res.channels{p}(night_cluster(i,2))) ' - Cluster ' num2str(night_cluster(i,3)) ' - distance ' num2str(frechet_distance) ];

    

end

%plot properties
legend(h, lgd),xlim([2 10])
title('Delta waves density - one night')

%% Bar plot


% load
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))

%exclusion
excluded_signals = [];
excluded_nights = [];
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird

excluded_nights = [excluded_nights 9:12]; %Problem with mouse403
excluded_nights = [excluded_nights 13:16]; %Problem with mouse451
excluded_nights = [excluded_nights 23]; %Problem with mouse451

bihemisphere = [find(strcmpi(layer_res.name,'Mouse508')) find(strcmpi(layer_res.name,'Mouse509'))]; 
for p=bihemisphere
    right_channels = find(layer_res.channels{p}>31);
    excluded_signals = [excluded_signals ; [repmat(p,length(right_channels),1) right_channels] ];
end


%feature extraction and clustering
meancurves = layer_res.down.meandown2;
nb_clusters = 5;
algo_clustering = 'manual';
method_features = 'adhoc';
show_sig = 'sig';

[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);


% precision, recall, distances...
[~, ~, distance_density, diff_decrease, ~, legend_stat] = Get_DownDeltaStat_cluster_KJ(night, clusterX, nb_clusters);


%Similarity of density curves
subplot(2,2,3), hold on
PlotErrorBarN_KJ(distance_density, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
title('Distance between delta and down density curves')

%Decrease of density
subplot(2,2,4), hold on
PlotErrorBarN_KJ(diff_decrease, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
title('Decrease difference')









