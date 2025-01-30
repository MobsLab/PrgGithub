%%ClusterToneEffectonNeurons
% 21.06.2018 KJ
%
%
% see
%   ParcoursToneEffectOnNeuronsFeatures
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'ParcoursToneEffectOnNeuronsFeatures.mat'))

%params
nb_pc = 5;
algo_clustering = 'kmeans';
nb_clusters = 3;


%% concatenate

Mat.upup    = [];
Mat.updown  = [];
Mat.down    = [];
Mat.ripples = [];

for p=1:4 %length(effect_res.path)

    Ccfeat = effect_res.ccfeat{p};
    
    Mat.upup    = [Mat.upup ; Ccfeat.upup]; 
    Mat.updown  = [Mat.updown ; Ccfeat.updown];
    Mat.down    = [Mat.down ; Ccfeat.down];
    Mat.ripples = [Mat.ripples ; Ccfeat.ripples];
    
end


%% pca
[coeff.upup, score.upup]       = pca(Mat.upup);
[coeff.updown, score.updown]   = pca(Mat.updown);
[coeff.down, score.down]       = pca(Mat.down);
[coeff.ripples, score.ripples] = pca(Mat.ripples);

X = [score.upup(:,1:nb_pc) score.updown(:,1:nb_pc) score.down(:,1:nb_pc) score.ripples(:,1:nb_pc)];



%% clustering

%K-means
if strcmpi(algo_clustering,'kmeans')
    rmpath('/home/mobsjunior/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/') %avoid conflict, several kmeans function

%     eva = evalclusters(X,'kmeans','CalinskiHarabasz','klist',2:8);
%     nb_clusters = eva.OptimalK;
    
    clusterX = kmeans(X, nb_clusters);
    
% fuzzy clustering
elseif strcmpi(algo_clustering,'fuzzy')
    [~, U] = fcm(X, nb_clusters);
    [~, clusterX] = max(U,[],1);
    clusterX = clusterX';

%gaussian mixture model
elseif strcmpi(algo_clustering,'gmm')
%     eva = evalclusters(X,'gmdistribution','CalinskiHarabasz','klist',2:8);
%     nb_clusters = eva.OptimalK;
    
    options = statset('MaxIter',1000); % Increase number of EM iterations
    gmfit = fitgmdist(X,nb_clusters, 'CovarianceType','full', 'SharedCovariance',false, 'Options',options);
    clusterX = cluster(gmfit,X);
    
end

%colori
colori_cluster = distinguishable_colors(nb_clusters);


%centroids
for clu=1:nb_clusters
    idx = find(clusterX==clu);
    
    curveproj.upup{clu}    = [];
    curveproj.updown{clu}  = [];
    curveproj.down{clu}    = [];
    curveproj.ripples{clu} = [];
    
    for i=1:length(idx) 
        
        proj.upup    = coeff.upup(:,1) * score.upup(idx(i),1);
        proj.updown  = coeff.upup(:,1) * score.updown(idx(i),1);
        proj.down    = coeff.upup(:,1) * score.down(idx(i),1);
        proj.ripples = coeff.upup(:,1) * score.ripples(idx(i),1);
        
        for k=2:nb_pc
            proj.upup    = proj.upup + coeff.upup(:,k) * score.upup(idx(i),k);
            proj.updown  = proj.updown + coeff.upup(:,k) * score.updown(idx(i),k);
            proj.down    = proj.down + coeff.upup(:,k) * score.down(idx(i),k);
            proj.ripples = proj.ripples + coeff.upup(:,k) * score.ripples(idx(i),k);
        end
        
        curveproj.upup{clu}    = [curveproj.upup{clu} proj.upup];
        curveproj.updown{clu}  = [curveproj.updown{clu} proj.updown];
        curveproj.down{clu}    = [curveproj.down{clu} proj.down];
        curveproj.ripples{clu} = [curveproj.ripples{clu} proj.ripples] ;
    
    end
    
    curveproj.upup{clu}    = mean(curveproj.upup{clu},2);
    curveproj.updown{clu}  = mean(curveproj.updown{clu},2);
    curveproj.down{clu}    = mean(curveproj.down{clu},2);
    curveproj.ripples{clu} = mean(curveproj.ripples{clu},2);
    
end





%% PLOT
figure, hold on
subplot(2,2,1), hold on
gscatter(X(:,2),X(:,8), clusterX);

subplot(2,2,2), hold on
gscatter(X(:,17),X(:,9), clusterX);

subplot(2,2,3), hold on
gscatter(X(:,11),X(:,1), clusterX);

subplot(2,2,4), hold on
gscatter(X(:,19),X(:,4), clusterX);




% clusters
figure, hold on
subplot(2,2,1), hold on
gscatter(X(:,2),X(:,8), clusterX);

subplot(2,2,2), hold on
gscatter(X(:,17),X(:,9), clusterX);

subplot(2,2,3), hold on
gscatter(X(:,11),X(:,1), clusterX);

subplot(2,2,4), hold on
gscatter(X(:,19),X(:,4), clusterX);





