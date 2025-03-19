%%GammaDownThresholdStdDetectionFiringPlot
% 20.04.2018 KJ
%
%   Compare gamma-down detection for each location of PFCx
%   Look at the firing rate in function of the threshold
%   -> here we plot  
%
% see
%   GammaDownThresholdStdDetectionFiring Figure1DetectionPlot
%   GammaDownThresholdStdDetectionFiringPlot2
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))


%% init
animals = unique(layer_res.name);

excluded_signals = [];
excluded_nights = [];

% exlusion
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird
excluded_signals = [5:8;1 1 1 1]'; %

excluded_nights = [excluded_nights 9:12]; %Problem with mouse403
excluded_nights = [excluded_nights 13:16]; %Problem with mouse451


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

nb_clusters = length(unique(clusterX));
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


%% Threshold firin rate curves
[curves_firing, curves_density, x_threshold, legend_curve] = Get_thresholdFRgamma_curves(night, clusterX, nb_clusters);


%% PLOT

figure, hold on
gap=0.03;


for k=1:length(curves_firing)
    subtightplot(2,3,k,gap), hold on
    
    c_firing = curves_firing{k};
    for i=1:length(c_firing)
        plot(x_threshold, c_firing{i}), hold on
    end
    title(legend_curve{k})

end

figure, hold on
gap=0.03;


for k=1:length(curves_firing)
    subtightplot(2,3,k,gap), hold on
    
    c_density = curves_density{k};
    for i=1:length(c_density)
        plot(x_threshold, c_density{i}), hold on
    end
    title(legend_curve{k})

end





