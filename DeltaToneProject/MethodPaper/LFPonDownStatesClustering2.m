%%LFPonDownStatesClustering2
% 05.03.2018 KJ
%
% meancurves on downstates, for many channels and many animals
% clustering of the response to down states, using manual features, not
% automatic
%
%   see 
%       LFPonDownStatesLayer LFPonDownStatesClustering
%


%load
clear
load(fullfile(FolderProjetDelta,'Data','LFPonDownStatesLayer.mat'))
load(fullfile(FolderProjetDelta,'Data','PfcSpectrumSubstages.mat'))


%substages plot params
NameEpoch = {'N1', 'N2', 'N3', 'REM', 'Wake'};
colori_sub = {'k', [1 0.5 1], 'r', [0.1 0.7 0], [0.5 0.2 0.1]}; %substage color


%adapt data
all_curves = [];
night = [];
features = [];

for p=1:length(layer_res.path)
    curves = layer_res.down.meancurves2{p};
    for ch=1:length(curves)
        x = curves{ch}(:,1);
        y = curves{ch}(:,2);        
        
        if ~(p>8 & p<13 & ch==5) % channel 15 of Mouse 403 = weird
            all_curves = [all_curves ; y'];
            night = [night ; p ch];
        
        
            %% Feature extraction : extrema and their position

            %postive deflection
            if sum(y(x>0 & x<=150))>0
                x1 = x>0 & x<=200;
                x2 = x>150 & x<=350;
                [feat1, feat2] = max(y(x1));
                [feat3, feat4] = min(y(x2));
                x1 = x(x1);
                x2 = x(x2);
                feat2 = x1(feat2);
                feat4 = x2(feat4);

            %negative deflection
            else
                x1 = x>0 & x<=250;
                x2 = x>200 & x<=350;
                [feat1, feat2] = min(y(x>0 & x<=250));
                [feat3, feat4] = max(y(x>200 & x<=350));
                x1 = x(x1);
                x2 = x(x2);
                feat2 = x1(feat2);
                feat4 = x2(feat4);
            end

            features = [features; feat1 feat2 feat3 feat4];
        
        end        
    end
end



%% clustering

cluster_algo = 'fuzzy';
nb_centroid = 4;
nb_pc = 4;
X = features(:,1:4); % each curves in the new space, data to be clustered

%K-means
if strcmpi(cluster_algo,'kmeans')
    rmpath('/home/mobsjunior/Dropbox/Kteam/PrgMatlab/Fra/UtilsStats/') %avoid conflict, several kmeans function

    eva = evalclusters(X,'kmeans','CalinskiHarabasz','klist',4:15);
    nb_centroid = eva.OptimalK;
    clusterX = kmeans(X, nb_centroid);
    
% fuzzy clustering
elseif strcmpi(cluster_algo,'fuzzy')
    [centers,U] = fcm(X, nb_centroid);
    [~, clusterX] = max(U,[],1);
    clusterX=clusterX';

%gaussian mixture model
elseif strcmpi(cluster_algo,'gmm')
    options = statset('MaxIter',2000); % Increase number of EM iterations
    gmfit = fitgmdist(X,nb_centroid, 'CovarianceType','full', 'SharedCovariance',false, 'Options',options);
    clusterX = cluster(gmfit,X);
    
end

%colors
colori_cluster = distinguishable_colors(nb_centroid);
curve_color = nan(length(clusterX),3);
for i=1:length(clusterX)
    curve_color(i,:) = colori_cluster(clusterX(i),:);
end


%% PLOT

%clustering plot
figure, hold on
gscatter(X(:,1),X(:,3), clusterX, colori_cluster)


% Mean curves
for k=1:nb_centroid
    figure, hold on
    
    idx_curves = find(clusterX==k);
    
    for i=idx_curves'
        p = night(i,1);
        ch = night(i,2);

        %Down states mean curves
        curve_down = layer_res.down.meancurves2{p}{ch};
        subplot(2,2,1), hold on
        plot(curve_down(:,1), curve_down(:,2)), hold on

        %Ripples mean curves
        try
            curve_ripple = layer_res.ripples.meancurves{p}{ch};
            subplot(2,2,3), hold on
            plot(curve_ripple(:,1), curve_ripple(:,2)), hold on
            
        end
        
        % Spectrum for substages
        spectra_substages = spectra_res.spectrum{p};
        
        for sub=1:4
            freq     = spectra_substages{ch,sub}(:,1); 
            spectrum = spectra_substages{ch,sub}(:,2);
            
            %Spectrum f*P(f)
            subplot(2,2,2), hold on
            norm_spectrum = freq.*spectrum;
            hold on, plot(freq, norm_spectrum, 'color',colori_sub{sub})
            
            %Spectrum 10*log10(P(f))
            subplot(2,2,4), hold on
            log_spectrum = 10*log10(spectrum);
            hold on, plot(freq, log_spectrum, 'color',colori_sub{sub})
        end
        
    end
    
    % plot properties
    subplot(2,2,1), hold on
    xlim([-200 400]), ylim([-1500 3000]), title('On down states'), hold on
    subplot(2,2,3), hold on
    xlim([-200 400]), ylim([-1000 1000]), title('On ripples'), hold on
    
    subplot(2,2,2), hold on
    legend(NameEpoch(1:4)), title('Spectrum f*P(f)'), hold on
    subplot(2,2,4), hold on
    legend(NameEpoch(1:4)), title('Spectrum 10*log10(P(f))'), hold on
    
    namefig = ['Centroid n°' num2str(k)];
    suplabel(namefig,'t');
    
    
end


