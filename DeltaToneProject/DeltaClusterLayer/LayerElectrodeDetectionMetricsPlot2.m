%%LayerElectrodeDetectionMetricsPlot2
% 30.07.2019 KJ
%
%   
%   
%
% see
%   LayerElectrodeDetectionMetrics LayerElectrodeDetectionMetricsPlot
%




% load
clear
load(fullfile(FolderDeltaDataKJ,'LayerElectrodeDetectionMetrics.mat'))

% unique animals & electrodes
[animals, electrodes, all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(layer_res);


%% Meancurves: LFP on Down and Ripples

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_elecdown    = [];
    y_elecdelta   = [];
    y_elecripples = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    y_elecdown    = [y_elecdown layer_res.down.meandown{p}{ch}(:,2)];            
                    x_elecdown    = layer_res.down.meandown{p}{ch}(:,1);                   
                    try
                        y_elecripples = [y_elecripples layer_res.ripples_correct.meancurves{p}{ch}(:,2)];
                        x_elecripples = layer_res.ripples_correct.meancurves{p}{ch}(:,1);
                    end
                    
                end
            end
        end
    end
    
    average_res.y_elecdown{i}    = mean(y_elecdown,2); 
    average_res.y_elecripples{i} = mean(y_elecripples,2);
    
    average_res.x_elecdown{i}    = x_elecdown; 
    average_res.x_elecripples{i} = x_elecripples;

end


%% Features in 2D-space
% meancurves
meancurves = layer_res.down.meandown;
    
%features extraction
X = nan(size(electrodes,1),4);
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_feat1 = [];
    elec_feat2 = [];
    elec_feat3 = [];
    elec_feat4 = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    x_curve = meancurves{p}{ch}(:,1);
                    y_curve = meancurves{p}{ch}(:,2);
                    %postive deflection
                    if sum(y_curve(x_curve>0 & x_curve<=150))>0
                        x1 = x_curve>0 & x_curve<=200;
                        x2 = x_curve>150 & x_curve<=350;
                        
                        [v,idx] = max(y_curve(x1));
                        elec_feat1 = [elec_feat1 v];
                        elec_feat3 = [elec_feat3 x_curve(find(x1,1)+idx)];
                        
                        [v,idx] = min(y_curve(x2));
                        elec_feat2 = [elec_feat2 v];
                        elec_feat4 = [elec_feat4 x_curve(find(x2,1)+idx)];
                        
                    %negative deflection
                    else
                        x1 = x_curve>0 & x_curve<=250;
                        x2 = x_curve>200 & x_curve<=350;

                        [v,idx] = min(y_curve(x1));
                        elec_feat1 = [elec_feat1 v];
                        elec_feat3 = [elec_feat3 x_curve(find(x1,1)+idx)];
                        
                        [v,idx] = max(y_curve(x2));
                        elec_feat2 = [elec_feat2 v];
                        elec_feat4 = [elec_feat4 x_curve(find(x2,1)+idx)];
                        
                    end
                end
            end
        end
    end
    
    %mean and save
    X(i,:) = [mean(elec_feat1) mean(elec_feat2) mean(elec_feat3) mean(elec_feat4)];

end

%axes
xp = X(:,1); %first amplitude
yp = X(:,2); %second amplitude
zp = X(:,4); %second amplitude


%Linear projection
p = polyfit(xp,yp,1); %linear regression
xfit = -700:2000;
yfit = polyval(p,xfit);
% vec_reg = (p'/norm(p))*ones(1,size(xp,1));
% new_xp = dot(X',vec_reg); % Projection

idx_above = (xp>1200) & (yp>p(1)*xp+p(2));
idx_below = (xp>500) & (yp<p(1)*xp+p(2));
elec_above = electrodes(idx_above,:);
elec_below = electrodes(idx_below,:);


%% Clusters
%clustering
clusterX = nan(length(X),1);

cond{1} = xp<=-150;
cond{2} = xp>-150 & xp<=270;
cond{3} = xp>270 & xp<=850;
cond{4} = xp>850 & xp<=1550;
cond{5} = xp>1550;
cond{6} = ecogs==1; %ecog

for i=1:length(cond)
    clusterX(cond{i}) = i;
end
nb_clusters = length(unique(clusterX));

%colors
colori = distinguishable_colors(nb_clusters);
colori(6,:) = [0 0 0];
for i=1:nb_clusters
    colori_cluster{i} = colori(i,:);
end

%save
average_res.X = X;
average_res.clusterX = clusterX;


%% Accuracy on down state detection

% precision, recall, frechet distance, ratio decrease, 
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    elec_frechet    = [];
    elec_decrease   = [];
    
    elec_peakccdown = [];
    elec_peakccrip  = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec

                    
                    elec_recall     = [elec_recall layer_res.single.recall{p}(ch)];
                    elec_precision  = [elec_precision layer_res.single.precision{p}(ch)];
                    elec_fscore     = [elec_fscore layer_res.single.fscore{p}(ch)];
                    elec_frechet    = [elec_frechet layer_res.single.frechet_distance{p}(ch)];
                    elec_decrease   = [elec_decrease layer_res.single.ratio_decrease{p}(ch)];
                    elec_peakccdown = [elec_peakccdown layer_res.peakcc.down_deltach{p}(ch)];
                    try
                        elec_peakccrip  = [elec_peakccrip layer_res.peakcc.rip_deltach{p}(ch)];
                    catch
                        elec_peakccrip  = [elec_peakccrip nan];
                    end
                end
            end
        end
    end
    
    %mean and save
    average_res.recall(i)    = mean(elec_recall);
    average_res.precision(i) = mean(elec_precision);
    average_res.fscore(i)    = mean(elec_fscore);
    average_res.frechet(i)   = mean(elec_frechet);
    average_res.decrease(i)  = mean(elec_decrease)*100;
    average_res.ccdown(i)    = mean(elec_peakccdown);
    average_res.ccrip(i)     = nanmean(elec_peakccrip);
end

%data for plot line
projected=0;

if projected
    amplitude_range = [-200:100:800];
    xp = new_xp;
else
    amplitude_range = [-700:200:2000];
    xp = X(:,1);
end

x_plot = amplitude_range(1:end-1) + diff(amplitude_range)/2;

for i=1:length(amplitude_range)-1
    yline.recall{i}     = average_res.recall(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    yline.precision{i}  = average_res.precision(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    yline.fscore{i}     = average_res.fscore(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    
    yline.frechet{i}  = average_res.frechet(xp>=amplitude_range(i) & xp<amplitude_range(i+1));
    yline.decrease{i} = abs(average_res.decrease(xp>=amplitude_range(i) & xp<amplitude_range(i+1)));
    yline.ccdown{i}   = abs(average_res.ccdown(xp>=amplitude_range(i) & xp<amplitude_range(i+1)));
    yline.ccrip{i}    = abs(average_res.ccrip(xp>=amplitude_range(i) & xp<amplitude_range(i+1)));
end


%% multi layer
%2-layers
for m=1:length(animals)
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    elec_frechet    = [];
    elec_decrease   = [];
    elec_peakccdown = [];
    elec_peakccrip  = [];
    
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
                elec_recall     = [elec_recall max(layer_res.multi.recall{p})];
                elec_precision  = [elec_precision max(layer_res.multi.precision{p})];
                elec_fscore     = [elec_fscore max(layer_res.multi.fscore{p})];
                elec_frechet    = [elec_frechet min(layer_res.multi.frechet_distance{p})];
                elec_decrease   = [elec_decrease min(layer_res.multi.ratio_decrease{p})];
                elec_peakccdown = [elec_peakccdown max(layer_res.peakcc.down_delta{p})];
                elec_peakccrip  = [elec_peakccrip max(layer_res.peakcc.rip_delta{p})];
        end
    end

    %mean and save
    multi_res.recall(m)    = mean(elec_recall);
    multi_res.precision(m) = mean(elec_precision);
    multi_res.fscore(m)    = mean(elec_fscore);
    multi_res.frechet(m)   = mean(elec_frechet);
    multi_res.decrease(m)  = mean(elec_decrease)*100;
    multi_res.ccdown(m)    = mean(elec_peakccdown);
    multi_res.ccrip(m)     = nanmean(elec_peakccrip);
end



%% Best score for each animals
for m=1:length(animals)
    
    
    idx_animal = electrodes(:,1)==m;   
    bestelec.recall(m,1)    = mean(average_res.recall(idx_animal));
    bestelec.precision(m,1) = mean(average_res.precision(idx_animal));
    bestelec.fscore(m,1)    = mean(average_res.fscore(idx_animal));
    bestelec.frechet(m,1)   = mean(average_res.frechet(idx_animal));
    bestelec.decrease(m,1)  = mean(average_res.decrease(idx_animal));
    bestelec.ccdown(m,1)    = mean(average_res.ccdown(idx_animal));
    bestelec.ccrip(m,1)     = nanmean(average_res.ccrip(idx_animal));
    
    bestelec.recall(m,2)   = multi_res.recall(m);
    bestelec.precision(m,2)= multi_res.precision(m);
    bestelec.fscore(m,2)   = multi_res.fscore(m);
    bestelec.frechet(m,2)  = multi_res.frechet(m);
    bestelec.decrease(m,2) = multi_res.decrease(m);
    bestelec.ccdown(m,2)   = multi_res.ccdown(m);
    bestelec.ccrip(m,2)    = multi_res.ccrip(m);
    
end




%% Meancurves: LFP on Down/delta/ripples

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_elecdown     = [];
    y_elecdelta    = [];
    y_elecripples  = [];
    y_elecspindles = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    
                    y_elecdown    = [y_elecdown layer_res.down.meandown{p}{ch}(:,2)];            
                    x_elecdown    = layer_res.down.meandown{p}{ch}(:,1);                    
                    try
                        y_elecripples = [y_elecripples layer_res.ripples.meancurves{p}{ch}(:,2)];
                        x_elecripples = layer_res.ripples.meancurves{p}{ch}(:,1);
                    end
                    try
                        y_elecspindles = [y_elecspindles layer_res.spindles.meancurves{p}{ch}(:,2)];
                        x_elecspindles = layer_res.spindles.meancurves{p}{ch}(:,1);
                    end
                end
            end
        end
    end
    
    average_res.y_elecdown{i}     = mean(y_elecdown,2); 
    average_res.y_elecripples{i}  = mean(y_elecripples,2);
    average_res.y_elecspindles{i} = mean(y_elecspindles,2);
    
    average_res.x_elecdown{i}     = x_elecdown; 
    average_res.x_elecripples{i}  = x_elecripples;
    average_res.x_elecspindles{i} = x_elecspindles;
    
end


%CLUSTERING
for k=1:nb_clusters
    
    %cluster legend
    lgd_curve{k}=num2str(k);
    
    %idx curves
    idx_curves = find(average_res.clusterX==k);
    y_meandown_k     = [];
    y_meanripples_k  = [];
    y_meanspindles_k = [];
    
    for i=1:length(idx_curves)
        
        idx = idx_curves(i);
        %Down 
        if ~isempty(average_res.y_elecdown{idx})
            y_meandown_k = [y_meandown_k average_res.y_elecdown{idx}];
            x_meandown_k = average_res.x_elecdown{idx};
        end
        %Ripples 
        if ~isempty(average_res.y_elecripples{idx})
            y_meanripples_k = [y_meanripples_k average_res.y_elecripples{idx}];
            x_meanripples_k = average_res.x_elecripples{idx};
        end
        %Spindles 
        if ~isempty(average_res.y_elecspindles{idx})
            y_meanspindles_k = [y_meanspindles_k average_res.y_elecspindles{idx}];
            x_meanspindles_k = average_res.x_elecspindles{idx};
        end
    end
    
    %save
    mc_down_lfp.y{k}     = mean(y_meandown_k,2); 
    mc_ripples_lfp.y{k}  = mean(y_meanripples_k,2);
    mc_spindles_lfp.y{k} = nanmean(y_meanspindles_k,2);
    
    mc_down_lfp.x{k}     = x_meandown_k; 
    mc_ripples_lfp.x{k}  = x_meanripples_k; 
    mc_spindles_lfp.x{k} = x_meanspindles_k; 

end


%% PLOT

%params plot
show_sig = 'sig';
gap = [0.09 0.04];
sz=25;

figure, hold on

%Mean curves
subplot(2,2,1), hold on

for i=1:length(average_res.y_elecdown)
    hold on, plot(average_res.x_elecdown{i}, average_res.y_elecdown{i});
end
xlim([-400 500]), ylim([-2100 2600]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
xlabel('Time from down states start (ms)'), ylabel('amplitude')
title('Mean LFP on down states'), hold on


%Features
subplot(2,2,2), hold on
hold on, plot(xfit, yfit),
gscatter(X(:,1),X(:,2), clusterX, colori);
scatter(X(ecogs==1,1),X(ecogs==1,2), sz,'filled','MarkerFaceColor','k');
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')


%S1 : Mean LFP on down
subplot(2,2,3), hold on
for k=1:length(mc_down_lfp.x)
    try
        hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori_cluster{k});
    end
end
xlim([-200 500]), ylim([-1100 2100]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Mean LFP on down states'), hold on
try legend(mdo, lgd_curve), end

%S5 : Mean LFP on ripples
subplot(2,2,4), hold on
for k=1:length(mc_ripples_lfp.x)
    try
        hold on, mr(k) = plot(mc_ripples_lfp.x{k}, mc_ripples_lfp.y{k},'color', colori_cluster{k});
    end
end
xlim([-600 600]),  ylim([-800 400]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
title('Mean LFP on ripples'), hold on


%% Plot scatter 3D 
figure, hold on
scatter3(xp,yp,zp,25,'filled'),
xlabel('amplitude 1'), ylabel('amplitude 2'), zlabel('timestamp 2'),

%% Populations above and below the line

%colors
colori = distinguishable_colors(12);
for i=1:12
    colori_animals{i} = colori(i,:);
end


xp = X(:,1); %first amplitude
yp = X(:,2); %second amplitude

p = polyfit(xp,yp,1); %linear regression

idx_above = (xp>500) & (xp<1000) & (yp>p(1)*xp+p(2));
idx_below = (xp>500) & (xp<1000) & (yp<p(1)*xp+p(2));
idx_above = (xp>1000) & (xp<5000) & (yp>p(1)*xp+p(2));
idx_below = (xp>1000) & (xp<5000) & (yp<p(1)*xp+p(2));
elec_above = electrodes(idx_above,:);
elec_below = electrodes(idx_below,:);


figure, hold on

%points above
subplot(1,2,1), hold on
clear h lgdc

idx = find(idx_above);
for k=1:length(idx)
    i = idx(k);
    y_curve = average_res.y_elecdown{i};
    x_curve = average_res.x_elecdown{i};
    hold on, h(k)=plot(x_curve, y_curve, 'color',colori_animals{electrodes(i,1)});
    lgdc{k}= animals{electrodes(i,1)};
end
xlim([-200 500]), ylim([-1500 2100]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Points above the line'), hold on
legend(h,lgdc),

%points below
subplot(1,2,2), hold on
clear h lgdc

idx = find(idx_below);
for k=1:length(idx)
    i = idx(k);
    y_curve = average_res.y_elecdown{i};
    x_curve = average_res.x_elecdown{i};
    hold on, h(k)=plot(x_curve, y_curve, 'color',colori_animals{electrodes(i,1)});
    lgdc{k} = animals{electrodes(i,1)};
end
xlim([-200 500]), ylim([-1500 2100]),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Points below the line'), hold on
legend(h,lgdc),





