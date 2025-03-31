%%ClusterLayerUsingDeltaWaves
% 20.07.2019 KJ
%
%   Load data from Method paper analysis and average on nights, per
%   (channel-mouse)
%   
%   -> Gather data and average
%   
%
% see
%   LayerClusterAveragePerChannel LFPonDownStatesLayer DeltaSingleChannelAnalysis
%



% load
clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'))
load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysis.mat'))

                           
%% unique animals & electrodes

[animals, electrodes,all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(layer_res);

%save
average_res.animals = animals;
average_res.all_electrodes = all_electrodes;
average_res.electrodes = electrodes;
average_res.ecogs = electrodes;


%% Clustering using features

% meancurves
meancurves = layer_res.down.meandown2;
    
%features extraction
X = nan(size(electrodes));
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_feat1     = [];
    elec_feat2     = [];
    %look for electrode data
    for p=1:length(single_res.path)
        if strcmpi(animals{m},single_res.name{p})
            channels = single_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    x = meancurves{p}{ch}(:,1);
                    y = meancurves{p}{ch}(:,2);
                    %postive deflection
                    if sum(y(x>0 & x<=150))>0
                        x1 = x>0 & x<=200;
                        x2 = x>150 & x<=350;
                        elec_feat1 = [elec_feat1 max(y(x1))];
                        elec_feat2 = [elec_feat2 min(y(x2))];
                    %negative deflection
                    else
                        x1 = x>0 & x<=250;
                        x2 = x>200 & x<=350;
                        elec_feat1 = [elec_feat1 min(y(x1))];
                        elec_feat2 = [elec_feat2 max(y(x2))];
                    end
                end
            end
        end
    end
    
    %mean and save
    X(i,:) = [mean(elec_feat1) mean(elec_feat2)];

end


%clustering
clusterX = nan(length(X),1);

xp = X(:,1);
yp = X(:,2);
cond{1} = yp>(0.8*xp+200);
cond{2} = yp<=(0.8*xp+200) & yp>(0.8*xp-900);
cond{3} = yp<=(0.8*xp-900) & yp>(0.8*xp-1600);
cond{4} = yp<=(0.8*xp-1600) & yp>(0.7*xp-2140);
cond{5} = yp<=(0.7*xp-2140);

for i=1:length(cond)
    clusterX(cond{i}) = i;
end

nb_clusters = length(unique(clusterX));

%colors
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end

%save
average_res.X = X;
average_res.clusterX = clusterX;


%% features for 

% meancurves
meancurves = layer_res.delta.meandelta_ch2;
    
%features extraction
X2 = nan(size(electrodes));
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_feat1     = [];
    elec_feat2     = [];
    %look for electrode data
    for p=1:length(single_res.path)
        if strcmpi(animals{m},single_res.name{p})
            channels = single_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    x = meancurves{p}{ch}(:,1);
                    y = meancurves{p}{ch}(:,2);
                    %postive deflection
                    if sum(y(x>0 & x<=150))>0
                        x1 = x>0 & x<=150;
                        x2 = x>150 & x<=300;
                        elec_feat1 = [elec_feat1 max(y(x1))];
                        elec_feat2 = [elec_feat2 min(y(x2))];
                    %negative deflection
                    else
                        x1 = x>0 & x<=150;
                        x2 = x>150 & x<=300;
                        elec_feat1 = [elec_feat1 min(y(x1))];
                        elec_feat2 = [elec_feat2 max(y(x2))];
                    end
                end
            end
        end
    end
    
    %mean and save
    X2(i,:) = [mean(elec_feat1) mean(elec_feat2)];

end

%clustering
clusterX2 = nan(length(X2),1);

xp = X2(:,1);
yp = X2(:,2);
cond{1} = yp>(0.8*xp+200);
cond{2} = yp<=(0.8*xp+200) & yp>(0.8*xp-900);
cond{3} = yp<=(0.8*xp-900) & yp>(0.8*xp-1600);
cond{4} = yp<=(0.8*xp-1600) & yp>(0.7*xp-2140);
cond{5} = yp<=(0.7*xp-2140);

for i=1:length(cond)
    clusterX2(cond{i}) = i;
end

clusterX = clusterX2;
average_res.clusterX = clusterX;


%% DeltaSingleChannelAnalysis per electrode (see Get_DownDeltaStat_detection_KJ)
% precision, recall, frechet distance, ratio decrease, 

for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    elec_frechet    = [];
    elec_decrease   = [];
    
    %look for electrode data
    for p=1:length(single_res.path)
        if strcmpi(animals{m},single_res.name{p})
            channels = single_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    %recall, precision, fscore
                    recall = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.down_only{p}(ch));
                    precision = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.delta_only{p}(ch));
                    fscore = 2 * recall .* precision / (recall + precision);
                    
                    elec_recall     = [elec_recall recall];
                    elec_precision  = [elec_precision precision];
                    elec_fscore     = [elec_fscore fscore];
                    elec_frechet    = [elec_frechet single_res.density.distance{p}{ch}];
                    elec_decrease   = [elec_decrease single_res.density.decrease{p}{ch}];
                    
                end
            end
        end
    end
    
    %mean and save
    average_res.recall(i)    = mean(elec_recall);
    average_res.precision(i) = mean(elec_precision);
    average_res.fscore(i)    = mean(elec_fscore);
    average_res.frechet(i)   = mean(elec_frechet);
    average_res.decrease(i)  = mean(elec_decrease);
end

%2-layers
for m=1:length(animals)
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    elec_frechet    = [];
    elec_decrease   = [];
    
    for p=1:length(single_res.path)
        if strcmpi(animals{m},single_res.name{p})
            ch = find(single_res.channels{p}==-1);
            %recall, precision, fscore
            recall = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.down_only{p}(ch));
            precision = single_res.down_delta{p}(ch) / (single_res.down_delta{p}(ch) + single_res.delta_only{p}(ch));
            fscore = 2 * recall .* precision / (recall + precision);

            elec_recall     = [elec_recall recall];
            elec_precision  = [elec_precision precision];
            elec_fscore     = [elec_fscore fscore];
            elec_frechet    = [elec_frechet single_res.density.distance{p}{ch}];
            elec_decrease   = [elec_decrease single_res.density.decrease{p}{ch}];
        end
    end
    
    %mean and save
    multi_res.recall(m)    = mean(elec_recall);
    multi_res.precision(m) = mean(elec_precision);
    multi_res.fscore(m)    = mean(elec_fscore);
    multi_res.frechet(m)   = mean(elec_frechet);
    multi_res.decrease(m)  = mean(elec_decrease);
end


%clustering
for i=1:nb_clusters
    down_recall{i}      = average_res.recall(average_res.clusterX==i);
    precision_detect{i} = average_res.precision(average_res.clusterX==i);
    fscore_detect{i}    = average_res.fscore(average_res.clusterX==i);
    distance_density{i} = average_res.frechet(average_res.clusterX==i);
    diff_decrease{i}    = average_res.decrease(average_res.clusterX==i);
    legend_stat{i}      = num2str(i);
end
down_recall{nb_clusters+1}      = multi_res.recall;
precision_detect{nb_clusters+1} = multi_res.precision;
fscore_detect{nb_clusters+1}    = multi_res.fscore;
distance_density{nb_clusters+1} = multi_res.frechet;
diff_decrease{nb_clusters+1}    = multi_res.decrease;
legend_stat{nb_clusters+1}      = '2-layers';



%% Meancurves: LFP on Down/delta/ripples

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_elecdown    = [];
    y_elecdelta   = [];
    y_elecripples = [];
    
    %look for electrode data
    for p=1:length(single_res.path)
        if strcmpi(animals{m},single_res.name{p})
            channels = single_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    y_elecdown    = [y_elecdown layer_res.down.meandown2{p}{ch}(:,2)];
                    y_elecdelta   = [y_elecdelta layer_res.delta.meandelta_ch2{p}{ch}(:,2)];
            
                    x_elecdown    = layer_res.down.meandown2{p}{ch}(:,1);
                    x_elecdelta   = layer_res.delta.meandelta_ch2{p}{ch}(:,1);
                    
                    try
                        y_elecripples = [y_elecripples layer_res.ripples_correct.meancurves{p}{ch}(:,2)];
                        x_elecripples = layer_res.ripples_correct.meancurves{p}{ch}(:,1);
                    end
                    
                end
            end
        end
    end
    
    average_res.y_elecdown{i}    = mean(y_elecdown,2); 
    average_res.y_elecdelta{i}   = mean(y_elecdelta,2);
    average_res.y_elecripples{i} = mean(y_elecripples,2);
    
    average_res.x_elecdown{i}    = x_elecdown; 
    average_res.x_elecdelta{i}   = x_elecdelta;
    average_res.x_elecripples{i} = x_elecripples;

end


%CLUSTERING
for k=1:nb_clusters
    
    %cluster legend
    lgd_curve{k}=num2str(k);
    
    %idx curves
    idx_curves = find(average_res.clusterX==k);
    y_meandown_k    = [];
    y_meandelta_k   = [];
    y_meanripples_k = [];
    
    for i=1:length(idx_curves)
        
        idx = idx_curves(i);
        %Down 
        if ~isempty(average_res.y_elecdown{idx})
            y_meandown_k = [y_meandown_k average_res.y_elecdown{idx}];
            x_meandown_k = average_res.x_elecdown{idx};
        end
        %Delta 
        if ~isempty(average_res.y_elecdelta{idx})
            y_meandelta_k = [y_meandelta_k average_res.y_elecdelta{idx}];
            x_meandelta_k = average_res.x_elecdelta{idx};
        end
        %Ripples 
        if ~isempty(average_res.y_elecripples{idx})
            y_meanripples_k = [y_meanripples_k average_res.y_elecripples{idx}];
            x_meanripples_k = average_res.x_elecripples{idx};
        end
    end
    
    %save
    mc_down_lfp.y{k}    = mean(y_meandown_k,2); 
    mc_delta_lfp.y{k}   = mean(y_meandelta_k,2);
    mc_ripples_lfp.y{k} = mean(y_meanripples_k,2);
    
    mc_down_lfp.x{k}    = x_meandown_k; 
    mc_delta_lfp.x{k}   = x_meandelta_k;
    mc_ripples_lfp.x{k} = x_meanripples_k;   

end



%% Firing Rate Curves
load(fullfile(FolderDeltaDataKJ, 'DeltaSingleChannelAnalysisFiringRate.mat'))
normalisation=1;

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_firingdelta    = [];
    
    %look for electrode data
    for p=1:length(singfr_res.path)
        if strcmpi(animals{m},singfr_res.name{p})
            channels = singfr_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec 
                    y_centered = CenterFiringRateCurve(singfr_res.deltas{p}{ch}(:,1), singfr_res.deltas{p}{ch}(:,2), normalisation);
                    y_firingdelta = [y_firingdelta y_centered];
                    x_firingdelta = singfr_res.deltas{p}{ch}(:,1);
                    
                end
            end
        end
    end
    
    average_res.y_firingdelta{i} = mean(y_firingdelta,2);    
    average_res.x_firingdelta{i} = x_firingdelta; 
end
%2-layers
for m=1:length(animals)
    y_firingdelta = [];
    
    for p=1:length(singfr_res.path)
        if strcmpi(animals{m},singfr_res.name{p})
            ch = find(singfr_res.channels{p}==-1);
            y_centered = CenterFiringRateCurve(singfr_res.deltas{p}{ch}(:,1), singfr_res.deltas{p}{ch}(:,2), normalisation);
            y_firingdelta = [y_firingdelta y_centered];
            x_firingdelta = singfr_res.deltas{p}{ch}(:,1);
        end
    end
    multi_res.y_firingdelta{m} = mean(y_firingdelta,2);    
    multi_res.x_firingdelta{m} = x_firingdelta; 
end


%CLUSTERING
for k=1:nb_clusters
    
    %cluster legend
    lgd_firing{k}=num2str(k);
    
    %idx curves
    idx_curves = find(average_res.clusterX==k);
    y_firing_k = [];
    
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        if ~isempty(average_res.y_firingdelta{idx})
            y_firing_k = [y_firing_k average_res.y_firingdelta{idx}];
            x_firing_k = average_res.x_firingdelta{idx};
        end
    end
    
    %save
    mc_delta_fr.y{k}    = mean(y_firing_k,2);     
    mc_delta_fr.x{k}    = x_firing_k; 

end

%2-layers
k = nb_clusters+1;
lgd_firing{k}='2-layers';
y_firing_k = [];
for m=1:length(multi_res.y_firingdelta)
    y_firing_k = [y_firing_k multi_res.y_firingdelta{m}];
    x_firing_k = multi_res.x_firingdelta{m};
end
mc_delta_fr.y{k}    = mean(y_firing_k,2);     
mc_delta_fr.x{k}    = x_firing_k; 




%% Mean-correlograms Down-delta
load(fullfile(FolderDeltaDataKJ, 'DeltaSingleChannelAnalysisCrossCorr.mat'))
smoothing=1;

%normalize the correlogram, dividing by the maximum of 2-layers correlogram
%with down
for p=1:length(singcor_res.path)
    nb_channels = length(singcor_res.channels{p});
    multi_peak = max(singcor_res.down_delta.y{p,nb_channels});

    for ch=1:nb_channels
        norm_correlograms{p,ch} = singcor_res.down_delta.y{p,ch} / multi_peak;
    end
end

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_correlo    = [];
    
    %look for electrode data
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            channels = singcor_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec 

                    y_correlo = [y_correlo norm_correlograms{p,ch}];
                    x_correlo = singcor_res.down_delta.x{p,ch};
                    
                end
            end
        end
    end
    
    average_res.y_correlo{i} = Smooth(mean(y_correlo,2),smoothing);    
    average_res.x_correlo{i} = x_correlo; 
end
%2-layers
for m=1:length(animals)
    y_correlo = [];
    
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            ch = find(singcor_res.channels{p}==-1);

            y_correlo = [y_correlo norm_correlograms{p,ch}];
            x_correlo = singcor_res.down_delta.x{p,ch};
        end
    end
    multi_res.y_correlo{m} = Smooth(mean(y_correlo,2),smoothing);    
    multi_res.x_correlo{m} = x_correlo; 
end


%CLUSTERING
for k=1:nb_clusters
    
    %cluster legend
    lgd_correlo1{k}=num2str(k);
    
    %idx curves
    idx_curves = find(clusterX==k);
    y_correlo_k = [];
    
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        if ~isempty(average_res.y_correlo{idx})
            y_correlo_k = [y_correlo_k average_res.y_correlo{idx}];
            x_correlo_k = average_res.x_correlo{idx};
        end
    end
    
    %save
    co_down_delta.y{k}    = mean(y_correlo_k,2);     
    co_down_delta.x{k}    = x_correlo_k; 

end

%2-layers
k = nb_clusters+1;
lgd_correlo1{k}='2-layers';
y_correlo_k = [];
for m=1:length(multi_res.y_correlo)
    y_correlo_k = [y_correlo_k multi_res.y_correlo{m}];
    x_correlo_k = multi_res.x_correlo{m};
end
co_down_delta.y{k}    = mean(y_correlo_k,2);     
co_down_delta.x{k}    = x_correlo_k; 


%% Mean-correlograms with Ripples
smoothing=1;

%normalize the correlogram, dividing by the maximum of 2-layers correlogram
%with down
for p=1:length(singcor_res.path)
    nb_channels = length(singcor_res.channels{p});
    try
        ripdown_peak = max(singcor_res.rip_down.y{p});
        norm_down{p} = singcor_res.rip_down.y{p} / ripdown_peak;
        
        for ch=1:nb_channels
            norm_correlograms{p,ch} = singcor_res.rip_delta.y{p,ch} / ripdown_peak;
        end
    end
end

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_correlo    = [];
    
    %look for electrode data
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            channels = singcor_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec 

                    y_correlo = [y_correlo norm_correlograms{p,ch}];
                    x_correlo = singcor_res.rip_delta.x{p,ch};
                    
                end
            end
        end
    end
    
    average_res.y_correlo{i} = Smooth(mean(y_correlo,2),smoothing);    
    average_res.x_correlo{i} = x_correlo; 
end
%2-layers
for m=1:length(animals)
    y_correlo = [];
    
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            ch = find(singcor_res.channels{p}==-1);

            y_correlo = [y_correlo norm_correlograms{p,ch}];
            x_correlo = singcor_res.rip_delta.x{p,ch};
        end
    end
    multi_res.y_correlo{m} = Smooth(mean(y_correlo,2),smoothing);    
    multi_res.x_correlo{m} = x_correlo; 
end


%CLUSTERING
for k=1:nb_clusters
    
    %cluster legend
    lgd_correlo2{k}=num2str(k);
    
    %idx curves
    idx_curves = find(average_res.clusterX==k);
    y_correlo_k = [];
    
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        if ~isempty(average_res.y_correlo{idx})
            y_correlo_k = [y_correlo_k average_res.y_correlo{idx}];
            x_correlo_k = average_res.x_correlo{idx};
        end
    end
    
    %save
    co_ripples_delta.y{k}    = mean(y_correlo_k,2);     
    co_ripples_delta.x{k}    = x_correlo_k; 

end

%2-layers
k = nb_clusters+1;
lgd_correlo2{k}='2-layers';
y_correlo_k = [];
for m=1:length(multi_res.y_correlo)
    y_correlo_k = [y_correlo_k multi_res.y_correlo{m}];
end
co_ripples_delta.y{k} = mean(y_correlo_k,2);     
co_ripples_delta.x{k} = multi_res.x_correlo{1}; 

%down state correlogram
curves_event_k = [];
for p=1:length(singcor_res.path)
    try
        curves_event_k = [curves_event_k norm_down{p}];
    end
end
%save
co_ripples_delta.down = Smooth(mean(curves_event_k,2),smoothing);


%% Quantif Correlogram Rip-delta

%down state correlogram
peak_ripdown = [];
for p=1:length(singcor_res.path)
    try
        x_sig = singcor_res.rip_down.x{p};
        y_sig = singcor_res.rip_down.y{p};
        peak_ripdown(p) = max(y_sig(x_sig>0));
    catch
        peak_ripdown(p) = nan;
    end
end
%save
peak_ripdown(peak_ripdown==0 | isnan(peak_ripdown))=[];


%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    peak_rips = [];
    
    %look for electrode data
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            channels = singcor_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec 
                    try
                        x_sig = singcor_res.rip_delta.x{p,ch};
                        y_sig = singcor_res.rip_delta.y{p,ch};
                        peak_rips = [peak_rips max(y_sig(x_sig>0))];
                    end
                end
            end
        end
    end    
    average_res.peak_rips(i)= mean(peak_rips);    
end

%2-layers
for m=1:length(animals)
    peak_rips = [];
    
    for p=1:length(singcor_res.path)
        if strcmpi(animals{m},singcor_res.name{p})
            ch = find(singcor_res.channels{p}==-1);
            try
                x_sig = singcor_res.rip_delta.x{p,ch};
                y_sig = singcor_res.rip_delta.y{p,ch};
                peak_rips = [peak_rips max(y_sig(x_sig>0))];
            end
        end
    end
    multi_res.peak_rips(m) = mean(peak_rips);      
end


%CLUSTERING

for i=1:nb_clusters
    peak_correlogram{i} = average_res.peak_rips(clusterX==i);
end
peak_correlogram{end+1} = multi_res.peak_rips;
peak_correlogram{end+1} = peak_ripdown;


%legend
for i=1:nb_clusters
    legend_corr{i} = num2str(i);
end
legend_corr{end+1} = '2-layers';
legend_corr{end+1} = 'down';



%% PLOT

%params plot
show_sig = 'sig';
gap = [0.07 0.04];

figure, hold on


%S1 : Mean LFP on down
subtightplot(2,4,1,gap), hold on
for k=1:length(mc_down_lfp.x)
    try
        hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
    end
end
xlim([-400 500]), ylim([-2100 2600]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Mean LFP on down states'), hold on
try legend(mdo, lgd_curve), end


%S2 : clusters in 2D scatter plot
subtightplot(2,4,2,gap), hold on
gscatter(X(:,1),X(:,2), clusterX, colori);
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
% xlim([-1400 2900]),


%S3 - Correlogram down-delta
subtightplot(2,4,3,gap), hold on
for k=1:length(co_down_delta.x)
    try
        hold on, crd(k) = plot(co_down_delta.x{k}, co_down_delta.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-350 350]), title('Mean correlogram down-delta'), hold on
try legend(crd, lgd_correlo1), end


%S4 : F1-score
subtightplot(2,4,4,gap), hold on
PlotErrorBarN_KJ(fscore_detect, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'ShowSigstar',show_sig);
set(gca,'xtick',1:length(legend_stat),'XtickLabel',legend_stat)
title('F1-score')


%S5 : Mean LFP on ripples
subtightplot(2,4,5,gap), hold on
for k=1:length(mc_ripples_lfp.x)
    try
        hold on, mr(k) = plot(mc_ripples_lfp.x{k}, mc_ripples_lfp.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean LFP on ripples'), hold on
try legend(mr, lgd_curve), end


%S6 : clusters in 2D scatter plot
subtightplot(2,4,6,gap), hold on
gscatter(X2(:,1),X2(:,2), clusterX, colori);
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')
% xlim([--2000 2900]),


%S7 : Mean LFP on ripples
subtightplot(2,4,7,gap), hold on
for k=1:length(mc_delta_lfp.x)
    try
        hold on, mr(k) = plot(mc_delta_lfp.x{k}, mc_delta_lfp.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean LFP on deltas'), hold on
try legend(mr, lgd_curve), end


%S8 : Mean Firing rate on deltas
subtightplot(2,4,8,gap), hold on
for k=1:length(mc_delta_fr.x)
    try
        hold on, mfr(k) = plot(mc_delta_fr.x{k}, mc_delta_fr.y{k},'color', colori_cluster{k});
    end
end
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
xlim([-400 500]), title('Mean Firing rate on delta waves'), hold on
try legend(mfr, lgd_fr), end
