%%LFPonDownStatesClustering3
% 06.03.2018 KJ
%
% meancurves on downstates, for many channels and many animals
% clustering of the response to down states, using manual features, not
% automatic
%
%   see 
%       LFPonDownStatesLayer LFPonDownStatesClustering LFPonDownStatesClustering2
%


% load
clear
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))
load(fullfile(FolderProjetDelta,'Data','PfcSpectrumSubstages.mat'))


%% clustering

animals = unique(layer_res.name);

% exlusion
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird

%feature extraction and clustering
meancurves = layer_res.down.meandown2;
nb_clusters = 5;
algo_clustering = 'manual';
method_features = 'adhoc';

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
    
    idx_curves = find(clusterX==k);
    curves_down_k = [];
    curves_ripples_k = [];
    spectra_N1_k = [];
    spectra_N2_k = [];
    spectra_N3_k = [];
    legd{k} = num2str(k); %cluster legend
    
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
        
        % Spectrum for N1
        sub=1;
        freq_n1  = spectra_res.spectrum{p}{ch,sub}(:,1);
        spectrum = spectra_res.spectrum{p}{ch,sub}(:,2);
        norm_spectrum = freq_n1 .* spectrum;
        norm_spectrum = norm_spectrum / max(norm_spectrum);
        spectra_N1_k = [spectra_N1_k norm_spectrum];
        
        % Spectrum for N2
        sub=2;
        freq_n2  = spectra_res.spectrum{p}{ch,sub}(:,1);
        spectrum = spectra_res.spectrum{p}{ch,sub}(:,2);
        norm_spectrum = freq_n2 .* spectrum;
        norm_spectrum = norm_spectrum / max(norm_spectrum);
        spectra_N2_k = [spectra_N2_k norm_spectrum];
        
        % Spectrum for N3
        sub=3;
        freq_n3  = spectra_res.spectrum{p}{ch,sub}(:,1);
        spectrum = spectra_res.spectrum{p}{ch,sub}(:,2);
        norm_spectrum = freq_n3 .* spectrum;
        norm_spectrum = norm_spectrum / max(norm_spectrum);
        spectra_N3_k = [spectra_N3_k norm_spectrum];
        
    end
    
    %average
    mean_down    = mean(curves_down_k,2);
    mean_ripples = mean(curves_ripples_k,2);
    mean_N1 = mean(spectra_N1_k,2);
    mean_N2 = mean(spectra_N2_k,2);
    mean_N3 = mean(spectra_N3_k,2);
    
    % mean LFP on down states
    subplot(2,3,1), 
    hold on, plot(x_down, mean_down,'color', colori_cluster{k})
    
    % mean LFP on ripples
    subplot(2,3,4), 
    hold on, plot(x_rip, mean_ripples,'color', colori_cluster{k})
    
    % spectra for N1
    subplot(2,3,2), hold on
    hold on, plot(freq_n1, mean_N1,'color', colori_cluster{k})
    
    % spectra for N2
    subplot(2,3,3), hold on
    hold on, plot(freq_n2, mean_N2,'color', colori_cluster{k})
    
    % spectra for N3
    subplot(2,3,6), hold on
    hold on, plot(freq_n3, mean_N3,'color', colori_cluster{k})
    
end

%scatter
subplot(2,3,5), hold on
gscatter(X(:,1),X(:,2), clusterX, colori)
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
xlim([-1400 2900]),

% plot properties
subplot(2,3,1), hold on
xlim([-400 500]), legend(legd), title('Mean LFP on down states'), hold on
subplot(2,3,4), hold on
xlim([-400 500]), legend(legd), title('Mean LFP on ripples'), hold on

subplot(2,3,2), hold on
legend(legd), xlim([0 30]), title('Spectrum f*P(f) in N1'), hold on
subplot(2,3,3), hold on
legend(legd), xlim([0 30]), title('Spectrum f*P(f) in N2'), hold on
subplot(2,3,6), hold on
legend(legd), xlim([0 30]), title('Spectrum f*P(f) in N3'), hold on

suplabel('Comparison of PFCx layers','t');


