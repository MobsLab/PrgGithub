%%LFPlayerInfluenceOnDetectionOld
% 10.03.2018 KJ
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Gather data and plot analysis
%   
%
% see
%   LFPlayerInfluenceOnDetection
%   LFPonDownStatesClustering3 DeltaSingleChannelDensityPlot
%   DeltaSingleChannelAnalysis2 LFPlayerInfluenceOnDetectionMouse
%


% load
clear
load(fullfile(FolderProjetDelta,'Data','DeltaSingleChannelAnalysis.mat'))
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))
% load([FolderProjetDelta 'Data/DeltaSingleChannelRipplesCorrelation.mat'])
load([FolderProjetDelta 'Data/DeltaSingleChannelAnalysisCrossCorr.mat'])

%% init
animals = unique(layer_res.name);

% exlusion
excluded_nights = [9:12 23]; %Problem with mouse403
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird

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
% load(fullfile(FolderProjetDelta,'Data','clusterX.mat'))

nb_clusters = length(unique(clusterX));
colori = distinguishable_colors(nb_clusters+1);
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end


%% down and delta detection comparison

for p=1:length(single_res.path)
    for ch=1:length(single_res.channels{p})
        idx = find(ismember(night, [p ch], 'rows'));
        if ~isempty(idx)
            d_delta = single_res.density.delta{p}{ch};
            
            %distances and similarities
            ratio_decrease(idx) = abs(single_res.density.decrease{p}{ch});
            frechet_distance(idx) = single_res.density.distance{p}{ch};
            down_only(idx)  = single_res.down_only{p}(ch);
            delta_only(idx) = single_res.delta_only{p}(ch);
            down_delta(idx) = single_res.down_delta{p}(ch);
            %ripples
            try
                nb_down_rip = correlo_res.down.rippled(p);
                nb_delta_rip = correlo_res.delta.rippled(p,ch);
                nb_rip = correlo_res.ripples.nb(p);
                diff_coupling(idx) = (nb_down_rip - nb_delta_rip)/nb_rip;
            catch
                diff_coupling(idx) = nan;
            end
                    
        
        %multi layer
        elseif single_res.channels{p}(ch)==-1 && ~ismember(p, excluded_nights)
            %distances and similarities
            multi.ratio_decrease(p) = abs(single_res.density.decrease{p}{ch});
            multi.frechet_distance(p) = single_res.density.distance{p}{ch};
            multi.down_only(p)  = single_res.down_only{p}(ch);
            multi.delta_only(p) = single_res.delta_only{p}(ch);
            multi.down_delta(p) = single_res.down_delta{p}(ch);
            %ripples
            try
                nb_down_rip = correlo_res.down.rippled(p);
                nb_delta_rip = correlo_res.delta.rippled(p,ch);
                nb_rip = correlo_res.ripples.nb(p);
                multi.diff_coupling(p) = (nb_down_rip - nb_delta_rip)/nb_rip;
            catch
                multi.diff_coupling(idx) = nan;
            end
        end
    end
            
end

%recall, precision, true and false positive
d_recall = down_delta ./ (down_delta + down_only);
for i=1:nb_clusters
    down_recall{i} = d_recall(clusterX==i);
end
down_recall{end+1} = multi.down_delta ./ (multi.down_delta + multi.down_only);

d_precision = down_delta ./ (down_delta + delta_only);
for i=1:nb_clusters
    precision_detect{i} = d_precision(clusterX==i);
end
precision_detect{end+1} = multi.down_delta ./ (multi.down_delta + multi.delta_only);

%distance between density curves
for i=1:nb_clusters
    distance_density{i} = frechet_distance(clusterX==i);
end
distance_density{end+1} = multi.frechet_distance;

%ratio of change in decrease density
for i=1:nb_clusters
    diff_decrease{i} = ratio_decrease(clusterX==i);
end
diff_decrease{end+1} = multi.ratio_decrease;

%ripples couplig
for i=1:nb_clusters
    ripples_coupling{i} = diff_coupling(clusterX==i);
end
ripples_coupling{end+1} = multi.diff_coupling;



%% correlogram down delta
correlos = cell(0);
correlo_multi = [];
for p=1:length(singcor_res.path)
    nb_channels = length(singcor_res.channels{p});
    multi_peak = max(singcor_res.down_delta.y{p,nb_channels});
    
    for i=1:nb_channels
        correlos{p,i} = singcor_res.down_delta.y{p,i} / multi_peak;
    end
    
    % mean of multi-layer delta
    if ~ismember(p, excluded_nights)
        correlo_multi = [correlo_multi correlos{p,nb_channels}];
    end
end
correlo_multi = mean(correlo_multi, 2);


%% PLOT
figure, hold on

for k=1:nb_clusters
    
    idx_curves = find(clusterX==k);
    curves_down_k = [];
    curves_delta_k = [];
    curves_crosscor_k = [];
    %cluster legend
    if strcmpi(algo_clustering,'animals')
        legd{k} = animals{k}(end-2:end);
    else
        legd{k}=num2str(k);
    end
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %LFP on down
        curve_down = layer_res.down.meandown2{p}{ch};
        curves_down_k = [curves_down_k curve_down(:,2)];
        x_down = curve_down(:,1);
        
        %LFP on delta waves
        curve_delta = layer_res.delta.meandelta2{p}{ch};
        if ~isempty(curve_delta)
            curves_delta_k = [curves_delta_k curve_delta(:,2)];
            x_delta = curve_delta(:,1);
        end
        
        % mean cross down - delta
        curve_crosscor = correlos{p,ch};
        curves_crosscor_k = [curves_crosscor_k curve_crosscor];
        x_crosscor = singcor_res.down_delta.x{p,ch};
        
    end
    
    %average
    mean_down  = mean(curves_down_k,2);
    mean_delta = mean(curves_delta_k,2);
    mean_crosscor = mean(curves_crosscor_k,2);
    
    % mean LFP on down states
    subplot(2,4,1), 
    hold on, md(k) = plot(x_down, mean_down,'color', colori_cluster{k});
    
%     % mean LFP on delta waves
%     subplot(2,4,5), 
%     hold on, mr(k) = plot(x_delta, mean_delta,'color', colori_cluster{k});
    
    % mean cross down - delta
    subplot(2,4,6), 
    hold on, mc(k) = plot(x_crosscor, mean_crosscor,'color', colori_cluster{k});
    
end


%plot properties
subplot(2,4,1), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(md, legd), title('Mean LFP on down states'), hold on

% subplot(2,4,5), hold on
% line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
% xlim([-400 500]), legend(mr, legd), title('Mean LFP on delta waves'), hold on


%clusters in 2D scatter plot
subplot(2,4,2), hold on
gscatter(X(:,1),X(:,2), clusterX, colori)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),

legd{end+1} = 'Multi layer';
show_sig='sig';

% mean-correlograms
subplot(2,4,6), hold on
hold on, mc(nb_clusters+1) = plot(x_crosscor, correlo_multi, 'color', colori_cluster{nb_clusters+1});
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(mc, legd), title('Mean Crosscor on down for delta'), hold on

%Recall-precision
subplot(2,4,5), hold on
gscatter(d_recall, d_precision, clusterX, colori), hold on
scatter(down_recall{nb_clusters+1}, precision_detect{nb_clusters+1}, 40, colori_cluster{nb_clusters+1}, 'filled','d'), hold on
xlabel('recall'), ylabel('precision')

%Recall
subplot(2,4,3), hold on
% PlotErrorSpreadN_KJ(down_recall,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(down_recall,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar',show_sig);
set(gca,'xtick',1:nb_clusters+1,'XtickLabel',legd)
title('Recall of down states')

%Precision
subplot(2,4,4), hold on
% PlotErrorSpreadN_KJ(precision_detect,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(precision_detect,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar',show_sig);
set(gca,'xtick',1:nb_clusters+1,'XtickLabel',legd)
title('Precision of detection')

%Similarity of density curves
subplot(2,4,7), hold on
% PlotErrorSpreadN_KJ(distance_density,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(distance_density,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar',show_sig);
set(gca,'xtick',1:nb_clusters+1,'XtickLabel',legd)
title('Distance between delta and down density curves')

%Decrease of density
subplot(2,4,8), hold on
% PlotErrorSpreadN_KJ(diff_decrease,'newfig',0, 'plotcolors',colori_cluster);
PlotErrorBarN_KJ(diff_decrease,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar',show_sig);
set(gca,'xtick',1:nb_clusters+1,'XtickLabel',legd)
title('Decrease difference')

% %Difference in number of couples Delta-SWS
% subplot(2,4,8), hold on
% % PlotErrorSpreadN_KJ(ripples_coupling,'newfig',0, 'plotcolors',colori_cluster);
% PlotErrorBarN_KJ(ripples_coupling,'newfig',0, 'barcolors',colori_cluster,'paired',0,'ShowSigstar',show_sig);
% set(gca,'xtick',1:nb_clusters+1,'XtickLabel',legd)
% title('Ripples-delta difference')









