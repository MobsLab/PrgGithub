%%Clustering_Curves_KJ
% 06.03.2018 KJ
%
% clustering of the response to events
%
% function [all_curves, night, X, clusterX, colori_cluster] = Clustering_Curves_KJ(meancurves, varargin)
%
% INPUT:
% - meancurves                  a structure with the curves for the p record, with several channel per records
%                           
%
% - features (optional)         = method for feature extraction: 'adhoc','pca','t_sne'
%                               (default 'adhoc')
% - algo_clustering (optional)  = algorithm used for the clustering: 'kmeans', 'fuzzy', 'gmm', 'manual'
%                               (default 'fuzzy')
% - nb_clusters (optional)      = number of clusters requested
%                               (default 5)
% - excluded_signals (optional) = signals exceluded from the clustering
%

%
%
% OUTPUT:
% - all_curves      = matrix (n_curves x n_pt) containing all curves 
% - night           = matrix (n_curves x 2) with index of path and channel in meancurves  
% - X               = reduced data after feature extraction
% - clusterX        = clusters of X
% - colori_cluster  = colors for each clusters
%
%
%   see 
%       LFPonDownStatesClustering
%


function [all_curves, night, X, clusterX, colori_cluster] = Clustering_Curves_KJ(meancurves, varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'features'
            features = varargin{i+1};
            if ~isstring_FMAToolbox(features, 'pca' , 'adhoc', 't_sne')
                error('Incorrect value for property ''features''.');
            end
        case 'algo_clustering'
            algo_clustering = varargin{i+1};
            if ~isstring_FMAToolbox(algo_clustering, 'kmeans' , 'fuzzy' , 'gmm' , 'manual', 'animals')
                error('Incorrect value for property ''algo_clustering''.');
            end
        case 'nb_clusters'
            nb_clusters = varargin{i+1};
            if nb_clusters<=0
                error('Incorrect value for property ''nb_clusters''.');
            end
        case 'ordering'
            ordering = varargin{i+1};
            if ordering~=0 && ordering~=1
                error('Incorrect value for property ''ordering~=0''.');
            end
        case 'excluded_signals'
            excluded_signals = varargin{i+1};
        case 'excluded_nights'
            excluded_nights = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('features','var')
    features='adhoc';
end
if ~exist('algo_clustering','var')
    features='fuzzy';
end
if ~exist('nb_clusters','var')
    nb_clusters=5;
end
if ~exist('ordering','var')
    ordering=1;
end
if ~exist('excluded_signals','var')
    excluded_signals=[];
end
if ~exist('excluded_nights','var')
    excluded_nights=[];
end


%% collect and adapt data

%night and channels
night = [];
for p=1:length(meancurves)
    for ch=1:length(meancurves{p})
        night = [night ; p ch];
    end
end
%exclusion nights
night(ismember(night(:,1),excluded_nights),:) = [];
%exclude signals
if ~isempty(excluded_signals)
    night(ismember(night,excluded_signals,'rows'),:) = [];
end

%all curves
all_curves = [];
for i=1:size(night,1)
    p = night(i,1);
    ch = night(i,2);
    
    x = meancurves{p}{ch}(:,1);
    all_curves = [all_curves ; meancurves{p}{ch}(:,2)'];
end
 

%% Feature extraction

%adhoc : extrema amplitudes and positions
if strcmpi(features,'adhoc')
    X = [];
    for i=1:size(all_curves)
        y = all_curves(i,:);
        
        %postive deflection
        if sum(y(x>0 & x<=150))>0
            x1 = x>0 & x<=200;
            x2 = x>150 & x<=350;
            [feat1, feat3] = max(y(x1));
            [feat2, feat4] = min(y(x2));
            x1 = x(x1);
            x2 = x(x2);
            feat3 = x1(feat3);
            feat4 = x2(feat4);

        %negative deflection
        else
            x1 = x>0 & x<=250;
            x2 = x>200 & x<=350;
            [feat1, feat3] = min(y(x1));
            [feat2, feat4] = max(y(x2));
            x1 = x(x1);
            x2 = x(x2);
            feat3 = x1(feat3);
            feat4 = x2(feat4);
        end

        X = [X; feat1 feat2 feat3 feat4];
    end

%PCA
elseif strcmpi(features,'pca')
    [~, score] = pca(all_curves);
    nb_pc = 2;
    X = score(:,1:nb_pc);

%t-SNE
elseif strcmpi(features,'t_sne')
    X = tsne(all_curves);    
end


%% clustering

%K-means
if strcmpi(algo_clustering,'kmeans')
    rmpath('/home/mobsjunior/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/') %avoid conflict, several kmeans function

%     eva = evalclusters(X,'kmeans','CalinskiHarabasz','klist',4:15);
%     nb_centroid = eva.OptimalK;
    clusterX = kmeans(X, nb_clusters);
    
% fuzzy clustering
elseif strcmpi(algo_clustering,'fuzzy')
    [~, U] = fcm(X, nb_clusters);
    [~, clusterX] = max(U,[],1);
    clusterX = clusterX';

%gaussian mixture model
elseif strcmpi(algo_clustering,'gmm')
    options = statset('MaxIter',2000); % Increase number of EM iterations
    gmfit = fitgmdist(X,nb_clusters, 'CovarianceType','full', 'SharedCovariance',false, 'Options',options);
    clusterX = cluster(gmfit,X);
    
%clustered by animals
elseif strcmpi(algo_clustering,'animals')
    %get animals name
    load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'),'layer_res');
    animals_path = layer_res.name;
    animals = unique(animals_path);
    
    nb_clusters = length(animals);
    clusterX = nan(size(X,1),1);
    for i=1:nb_clusters
        nights_animals = find(strcmpi(animals_path,animals{i}));
        clusterX(ismember(night(:,1), nights_animals)) = i;
    end
    
    
%ad hoc clustering
elseif strcmpi(algo_clustering,'manual')
    clusterX = nan(length(X),1);
    
    xp = X(:,1);
    yp = X(:,2);
    
    clear cond
    cond{1} = yp>(0.8*xp+200);
    cond{2} = yp<=(0.8*xp+200) & yp>(0.8*xp-900);
    cond{3} = yp<=(0.8*xp-900) & yp>(0.8*xp-1600);
    cond{4} = yp<=(0.8*xp-1600) & yp>(0.7*xp-2140);
    cond{5} = yp<=(0.7*xp-2140);

%     cond{1} = xp<=-300;
%     cond{2} = xp<=600 & xp>-300;
%     cond{3} = xp<=900 & xp>600;
%     cond{4} = xp<=1600 & xp>900;
%     cond{5} = xp>1600;
%  
%     a=0.8;
%     cond{1} = yp>(a*xp-200);
%     cond{2} = yp<=(a*xp-200) & yp>(a*xp-1000);
%     cond{3} = yp<=(a*xp-1000) & yp>(a*xp-1400);
%     cond{4} = yp<=(a*xp-1400) & yp>(a*xp-1900);
%     cond{5} = yp<=(a*xp-1900);
    
    for i=1:length(cond)
        clusterX(cond{i}) = i;
    end
    
    nb_clusters = length(unique(clusterX));
end


%% ordering eventually, by amplityude
if ordering && ~strcmpi(algo_clustering,'manual')
    
    %amplitudes
    for i=1:nb_clusters
        amplitude_clusters(i) = mean(X(clusterX==i,1))+mean(X(clusterX==i,2));
    end
    
    %order
    [~, idx_order] = sort(amplitude_clusters);
    a=1:nb_clusters; idx_order = a(idx_order);
    new_clusterX = nan(length(clusterX),1);
    for i=1:nb_clusters
        new_clusterX(clusterX==idx_order(i))=i;
    end
    clusterX = new_clusterX;
end


%% colors
colori_cluster = distinguishable_colors(nb_clusters);


end



