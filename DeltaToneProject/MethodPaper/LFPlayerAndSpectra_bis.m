%%LFPlayerAndSpectra_bis
% 14.03.2018 KJ
%
%
%   Split signals (night+channel) in clusters in function of their response to down states
%   
%   -> Gather data and plot analysis
%   -> show spectra
%   -> no subplot
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
[meanspectrum_n2, lgd_n2] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 2, 'norm_f_sp', nb_clusters);
[meanspectrum_n3, lgd_n3] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 3, 'f_sp', nb_clusters);

[meanspectrum_n1, lgd_n1] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 1, 'f_sp', nb_clusters);
[meanspectrum_rem, lgd_rem] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 4, 'f_sp', nb_clusters);
[meanspectrum_wake, lgd_wake] = Get_MeanSpectrum_cluster_KJ(night, clusterX, spectra_res.spectrum, 5, 'f_sp', nb_clusters);


%% PLOT

% %Mean Spectrum in cluster 1
% figure, hold on
% subplot(1,2,1),hold on
% 
% hold on, cl1(1) = plot(meanspectrum_n1.x{1}, meanspectrum_n1.y{1}/1e5,'color', colori_sub{1});
% hold on, cl1(2) = plot(meanspectrum_n2.x{1}, meanspectrum_n2.y{1}/1e5,'color', colori_sub{2});
% hold on, cl1(3) = plot(meanspectrum_n3.x{1}, meanspectrum_n3.y{1}/1e5,'color', colori_sub{3});
% hold on, cl1(4) = plot(meanspectrum_rem.x{1}, meanspectrum_rem.y{1}/1e5,'color', colori_sub{4});
% hold on, cl1(5) = plot(meanspectrum_wake.x{1}, meanspectrum_wake.y{1}/1e5,'color', colori_sub{5});
% 
% %properties
% set(gca,'xlim',[1.3 25], 'ytick', 0:0.2:1), hold on
% set(gca,'FontName','Times','fontsize',20), title('1 - Sup'),
% xlabel('Hz'), ylabel('f*P(f)')
% 
% 
% %Mean Spectrum in cluster 5
% subplot(1,2,2),hold on
% 
% hold on, cl5(1) = plot(meanspectrum_n1.x{5}, meanspectrum_n1.y{5}/1e5,'color', colori_sub{1});
% hold on, cl5(2) = plot(meanspectrum_n2.x{5}, meanspectrum_n2.y{5}/1e5,'color', colori_sub{2});
% hold on, cl5(3) = plot(meanspectrum_n3.x{5}, meanspectrum_n3.y{5}/1e5,'color', colori_sub{3});
% hold on, cl5(4) = plot(meanspectrum_rem.x{5}, meanspectrum_rem.y{5}/1e5,'color', colori_sub{4});
% hold on, cl5(5) = plot(meanspectrum_wake.x{5}, meanspectrum_wake.y{5}/1e5,'color', colori_sub{5});
% 
% %properties
% set(gca,'xlim',[1.3 25], 'ylim',[0 3.5], 'ytick', 1:3), hold on
% set(gca,'FontName','Times','fontsize',20), title('5 - deep'),
% legend(cl5, NameEpoch), xlabel('Hz'),


%Mean Spectrum in N2
figure, hold on
subplot(1,2,1),hold on
for k=1:length(meanspectrum_n2.x)
    try
        hold on, ms2(k) = plot(meanspectrum_n2.x{k}, meanspectrum_n2.y{k},'color', colori_cluster{k});
    end
end
%properties
set(gca,'xlim',[1.3 25],'ytick',[0 1]), hold on
set(gca,'FontName','Times','fontsize',20), title('N2'),
xlabel('Hz'), ylabel('f*P(f)')

% 
% %Mean Spectrum in N3
% subplot(1,2,2),hold on
% for k=1:length(meanspectrum_n3.x)
%     try
%         hold on, ms3(k) = plot(meanspectrum_n3.x{k}, meanspectrum_n3.y{k}/1e5,'color', colori_cluster{k});
%     end
% end
% % properties
% set(gca,'xlim',[1.3 25], 'ylim',[0 3.5], 'ytick', 1:3), hold on
% set(gca,'FontName','Times','fontsize',20), title('N3'),
% legend(ms3, lgd_n3), xlabel('Hz'),




