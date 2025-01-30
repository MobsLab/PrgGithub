%%LFPlayerAndSpectra
% 14.03.2018 KJ
%
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Gather data and plot analysis
%   -> show spectra
%   
%
% see
%   LFPlayerInfluenceOnDetection
%   LFPlayerInfluenceOnSpectra2
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))
load(fullfile(FolderDeltaDataKJ,'PfcSpectrumSubstages.mat'))


%% init

excluded_signals = [];
excluded_nights = [];

% exlusion
excluded_nights = [9:12 23]; %Problem with mouse403
excluded_signals = [9:12;5 5 5 5]'; %channel 15 of Mouse 403 = weird
excluded_signals = [5:8;1 1 1 1]';

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

%substages
NameEpoch = {'N1','N2','N3','REM','Wake'};
colori_sub = {'k', [1 0.5 1], 'r', [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color


%% mean curves and spectrum

%on down states
[mc_down_lfp, lgd_down]   = Get_MeanSignal_cluster_KJ(night, clusterX, layer_res.down.meandown2, nb_clusters);

%spectra average
[meanspectrum_n23, lgd_n23] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 2:3, 'f_sp', nb_clusters);
[normspectrum_n23, ~] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 2:3, 'norm_f_sp', nb_clusters);

[meanspectrum_n1, lgd_n1] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 1, 'f_sp', nb_clusters);
[meanspectrum_rem, lgd_rem] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 4, 'f_sp', nb_clusters);
[meanspectrum_wake, lgd_wake] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 5, 'f_sp', nb_clusters);


%% PLOT

%params plot
show_sig = 'sig';

figure, hold on

%S1 : Mean LFP on down
subplot(2,3,1), hold on
for k=1:length(mc_down_lfp.x)
    try
        hold on, ms2(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean LFP on down states'), hold on
try legend(ms2, lgd_down), end





%S2 : Mean Spectrum in N2+N3
subplot(2,3,2), hold on
for k=1:length(meanspectrum_n23.x)
    try
        hold on, ms23(k) = plot(meanspectrum_n23.x{k}, meanspectrum_n23.y{k},'color', colori_cluster{k});
    end
end
xlim([1.2 30]), title('Mean Spectra in N2+N3 - f*P(f)'), hold on
try legend(ms23, lgd_n23), end


%S3 : same spectrum normalized
subplot(2,3,3), hold on
for k=1:length(normspectrum_n23.x)
    try
        hold on, msn(k) = plot(normspectrum_n23.x{k}, normspectrum_n23.y{k},'color', colori_cluster{k});
    end
end
xlim([1.2 30]), title('Rescaled spectra'), hold on
try legend(msn, lgd_n23), end


%S1 : Mean Spectrum in N1
subplot(2,3,4), hold on
for k=1:length(meanspectrum_n1.x)
    try
        hold on, mn1(k) = plot(meanspectrum_n1.x{k}, meanspectrum_n1.y{k},'color', colori_cluster{k});
    end
end
xlim([1.2 30]), title('Mean Spectra in N1 - f*P(f)'), hold on
try legend(mn1, lgd_n1), end


%S5 : Mean Spectrum in REM
subplot(2,3,5), hold on
for k=1:length(meanspectrum_rem.x)
    try
        hold on, mrem(k) = plot(meanspectrum_rem.x{k}, meanspectrum_rem.y{k},'color', colori_cluster{k});
    end
end
xlim([1.2 30]), title('Mean Spectra in REM - f*P(f)'), hold on
try legend(mrem, lgd_rem), end


%S6 : Mean Spectrum in Wake
subplot(2,3,6), hold on
for k=1:length(meanspectrum_wake.x)
    try
        hold on, msw(k) = plot(meanspectrum_wake.x{k}, meanspectrum_wake.y{k},'color', colori_cluster{k});
    end
end
xlim([1.2 30]), title('Mean Spectra in Wake - f*P(f)'), hold on
try legend(msw, lgd_wake), end





%%%%%%%%%%%%%%%%%%%%%
% %S4 : clusters in 2D scatter plot
% subplot(2,3,4), hold on
% gscatter(X(:,1),X(:,2), clusterX, colori);
% xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
% xlim([-1400 2900]),


