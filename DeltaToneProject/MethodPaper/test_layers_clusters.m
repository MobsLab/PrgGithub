%test_layers_clusters


% load
clear
load(fullfile(FolderProjetDelta,'Data','DeltaSingleChannelAnalysis.mat'))
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))


%% clustering

% exlusion
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird

%feature extraction and clustering
meancurves = layer_res.down.meandown2;
nb_clusters = 6;
algo_clustering = 'manual';
method_features = 'adhoc';

[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals);

%% down and delta detection comparison

for p=1:length(single_res.path)

    %densities
    d_down = single_res.density.down{p};
    
    for ch=1:length(single_res.channels{p})
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)
            d_delta = single_res.density.delta{p}{ch};
            
            %distances and similarities
            ratio_decrease(idx)   = CompareDecreaseDensity(d_down, d_delta, single_res.density.x{p});
            frechet_distance(idx) = DiscreteFrechetDist(d_down, d_delta);
            down_only(idx)  = single_res.down_only{p}(ch);
            delta_only(idx) = single_res.delta_only{p}(ch);
            down_delta(idx) = single_res.down_delta{p}(ch);
        end
    end
            
end

%recall, precision, true and false positive
d_recall = down_delta ./ (down_delta + down_only);
d_precision = down_delta ./ (down_delta + delta_only);



%% group



%% Plot

%clusters
figure, hold on
gscatter(X(:,1),X(:,2), clusterX, colori)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),
xa=-1000:2500;
hold on,plot(xa,-0.55*xa-39.5),ylim([-1200 400])

hold on,plot(xa,0.8*xa-200),ylim([-1200 400])
hold on,plot(xa,0.8*xa-900),ylim([-1200 400])
hold on,plot(xa,0.8*xa-1600),ylim([-1200 400])
hold on,plot(xa,0.7*xa-2140),ylim([-1200 400])


%values
scattersize = 25;
figure, hold on

subplot(2,2,1), hold on
scatter(X(:,1),X(:,2), scattersize, d_recall,'filled'), hold on
xlim([-1400 2900]), title('recall')
subplot(2,2,2), hold on
scatter(X(:,1),X(:,2), scattersize, d_precision,'filled'), hold on
xlim([-1400 2900]), title('precision')
subplot(2,2,3), hold on
scatter(X(:,1),X(:,2), scattersize, ratio_decrease,'filled'), hold on
xlim([-1400 2900]), title('decrease ratio')
subplot(2,2,4), hold on
scatter(X(:,1),X(:,2), scattersize, frechet_distance,'filled'), hold on
xlim([-1400 2900]), title('distance curve')


%animals









