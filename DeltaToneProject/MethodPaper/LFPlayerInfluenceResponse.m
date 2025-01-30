%%LFPlayerInfluenceResponse
% 11.03.2018 KJ
%
% meancurves on downstates/delta/ripples, for many channels and many animals
% clustering of the response to down states, using manual features, not
% automatic
%
%   see 
%       LFPlayerInfluenceOnDetection LFPonDownStatesClustering3   
%


% load
clear
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))


%% params
nb_clusters = 5;
algo_clustering = 'manual';
method_features = 'adhoc';
nx=2;ny=2; %subplot dim

excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird
% animals = unique(layer_res.name);


%% clustering
%feature extraction and clustering
meancurves = layer_res.down.meandown2;
[all_curves, night, X, clusterX, ~] = Clustering_Curves_KJ(meancurves, 'features',method_features,'algo_clustering',algo_clustering,'nb_clusters',nb_clusters, ...
                                    'excluded_signals',excluded_signals);
% load(fullfile(FolderProjetDelta,'Data','clusterX.mat'))

nb_clusters = length(unique(clusterX));
colori = distinguishable_colors(nb_clusters+1);
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end

%order by amplitude
for i=1:nb_clusters
    amplitude_clusters(i) = mean(X(clusterX==i,1))+mean(X(clusterX==i,2));
end
[~, idx_order] = sort(amplitude_clusters);
a=1:nb_clusters; idx_order = a(idx_order);
new_clusterX = nan(length(clusterX),1);
for i=1:nb_clusters
    new_clusterX(clusterX==idx_order(i))=i;
end
clusterX = new_clusterX;


%% PLOT

%clustering plot
figure, hold on

for k=1:nb_clusters
    
    %init
    idx_curves = find(clusterX==k);
    curves_down_k    = [];
    curves_ripples_k = [];
    curves_delta_k   = [];
    
    legd{k} = num2str(k); %cluster legend
    
    %loop over nights
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);
        
        %LFP on down
        curve_down = layer_res.down.meandown2{p}{ch};
        curves_down_k = [curves_down_k curve_down(:,2)];
        x_down = curve_down(:,1);
        
        %LFP on ripples
        curve_ripple = layer_res.ripples.meancurves{p}{ch};
        if ~isempty(curve_ripple)
            curves_ripples_k = [curves_ripples_k curve_ripple(:,2)];
            x_rip = curve_ripple(:,1);
        end
        
        %LFP on delta waves
        curve_delta = layer_res.delta.meandelta2{p}{ch};
        if ~isempty(curve_delta)
            curves_delta_k = [curves_delta_k curve_delta(:,2)];
            x_delta = curve_delta(:,1);
        end
        
        
    end
    
    %average
    mean_down    = mean(curves_down_k,2);
    mean_delta   = mean(curves_delta_k,2);
    mean_ripples = mean(curves_ripples_k,2);
    
    % mean LFP on down states
    subplot(ny,nx,1), 
    hold on, mdo(k) = plot(x_down, mean_down,'color', colori_cluster{k});
    
    % mean LFP on delta waves
    subplot(ny,nx,3), 
    hold on, mdl(k) = plot(x_delta, mean_delta,'color', colori_cluster{k});
    
    % mean LFP on ripples
    subplot(ny,nx,4), 
    hold on, mr(k) = plot(x_rip, mean_ripples,'color', colori_cluster{k});
    
    
end

%scatter plot
subplot(ny,nx,2), hold on
gscatter(X(:,1),X(:,2), clusterX, colori)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),

%plot properties
subplot(ny,nx,1), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(mdo, legd), title('Mean LFP on down states'), hold on
subplot(ny,nx,3), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(mdl, legd), title('Mean LFP on delta waves'), hold on
subplot(ny,nx,4), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), legend(mr, legd), title('Mean LFP on SPW-Rs'), hold on


%main title
suplabel('Comparison of PFCx layers','t');






