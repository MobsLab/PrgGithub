%%DeltaThresholdStdDetectionFiringPlot
% 20.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at the firing rate in function of the threshold
%   -> here we plot  
%
% see
%   DeltaThresholdStdDetectionFiring Figure1DetectionPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))

gap=0.08;
animals = unique(layer_res.name);


for m=1:length(animals)
    
    clearvars -except m layer_res animals gap

    excluded_signals = [];
    excluded_nights = [];

    % exlusion
    mouse_path = find(strcmpi(animals{m},layer_res.name));
    % exlusion
    excluded_nights = setdiff(1:length(layer_res.path), mouse_path);


    bihemisphere = [find(strcmpi(layer_res.name,'Mouse508')) find(strcmpi(layer_res.name,'Mouse509'))]; 
    for b=1:length(bihemisphere)
        right_channels = find(layer_res.channels{bihemisphere(b)}>31);
        excluded_signals = [excluded_signals ; [repmat(bihemisphere(b),length(right_channels),1) right_channels] ];
    end


    %% clustering

    %feature extraction and clustering
    meancurves = layer_res.down.meandown2;
    nb_clusters = 5;
    algo_clustering = 'manual';
    method_features = 'adhoc';

    [all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                        'excluded_signals',excluded_signals, 'excluded_nights',excluded_nights);

    nb_clusters = max(clusterX);
    colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
    for i=1:nb_clusters+1
        colori_cluster{i} = colori(i,:);
    end


    %% Threshold firin rate curves
    [curves_firing, curves_density, x_threshold, legend_curve] = Get_thresholdFiringRate_curves(night, clusterX);


    %% PLOT

    figure, hold on

    s=1;
    for k=1:length(curves_firing)
        c_firing = curves_firing{k};
        c_density = curves_density{k};
        
        if ~isempty(c_firing)
            subplot(2,5,s), hold on
            for i=1:length(c_firing)
                plot(x_threshold, c_firing{i}), hold on
            end
            title(legend_curve{k})
            
            subplot(2,5,s+5), hold on
            for i=1:length(c_density)
                plot(x_threshold, c_density{i}), hold on
            end
            s=s+1;
        end

    end
    
    suplabel(animals{m},'t');



end


