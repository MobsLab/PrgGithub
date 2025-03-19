%%LayerElectrodeDetectionMetricsPlot
% 30.07.2019 KJ
%
%   
%   
%
% see
%   LayerElectrodeDetectionMetrics LayerClusterAveragePerChannel
%   LayerElectrodeDetectionMetricsPlot2




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
X = nan(size(electrodes));
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_feat1     = [];
    elec_feat2     = [];
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
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

%axes
xp = X(:,1); %first amplitude
yp = X(:,2); %second amplitude


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
    amplitude_range = -200:100:800;
    xp = new_xp;
else
    amplitude_range = -700:200:2000;
    xp = X(:,1);
end

x_plot = amplitude_range(1:end-1) + diff(amplitude_range)/2;

for i=1:length(amplitude_range)-1
    yline.recall{i}    = average_res.recall(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    yline.precision{i} = average_res.precision(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    yline.fscore{i}    = average_res.fscore(xp>=amplitude_range(i) & xp<amplitude_range(i+1)) * 100;
    
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


%% Ripples with down

for m=1:length(animals)
    rip_down = [];
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            rip_down  = [rip_down max(layer_res.peakcc.rip_down{p})];
        end
    end
    
    %mean and save
    down_res.ccrip(m) = nanmean(rip_down);
    
end


%% Best score for each animals
for m=1:length(animals)
    
    
    idx_animal = electrodes(:,1)==m;   
    bestelec.recall(m,1)    = min(average_res.recall(idx_animal));
    bestelec.precision(m,1) = min(average_res.precision(idx_animal));
    bestelec.fscore(m,1)    = min(average_res.fscore(idx_animal));
    bestelec.frechet(m,1)   = max(average_res.frechet(idx_animal));
    bestelec.decrease(m,1)  = max(average_res.decrease(idx_animal));
    bestelec.ccdown(m,1)    = min(average_res.ccdown(idx_animal));
    bestelec.ccrip(m,1)     = nanmin(average_res.ccrip(idx_animal));
    
    bestelec.recall(m,2)    = mean(average_res.recall(idx_animal));
    bestelec.precision(m,2) = mean(average_res.precision(idx_animal));
    bestelec.fscore(m,2)    = mean(average_res.fscore(idx_animal));
    bestelec.frechet(m,2)   = mean(average_res.frechet(idx_animal));
    bestelec.decrease(m,2)  = mean(average_res.decrease(idx_animal));
    bestelec.ccdown(m,2)    = mean(average_res.ccdown(idx_animal));
    bestelec.ccrip(m,2)     = nanmax(average_res.ccrip(idx_animal));
    
    bestelec.recall(m,3)   = multi_res.recall(m);
    bestelec.precision(m,3)= multi_res.precision(m);
    bestelec.fscore(m,3)   = multi_res.fscore(m);
    bestelec.frechet(m,3)  = multi_res.frechet(m);
    bestelec.decrease(m,3) = multi_res.decrease(m);
    bestelec.ccdown(m,3)   = multi_res.ccdown(m);
    bestelec.ccrip(m,3)    = multi_res.ccrip(m);
    
    
    %ripples and down
    try
        bestelec.ccrip(m,4) = down_res.ccrip(m);
    end
    
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
scatter(X(:,1),X(:,2), sz,'filled');
xlabel('amplitude 1st extrema (mi-down)'), ylabel('amplitude 2nd extrema (post-down)')


%Precision-recall-fscore
subplot(2,2,3), hold on
[~,h(1)]=PlotErrorLineN_KJ(yline.recall, 'x_data',x_plot,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(yline.precision, 'x_data',x_plot,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(3)]=PlotErrorLineN_KJ(yline.fscore, 'x_data',x_plot,'newfig',0,'linecolor',[0.3 0.3 0.3],'ShowSigstar','none','errorbars',1,'linespec','-.');
legend(h,'recall','precision','fscore')
set(gca, 'ylim',[0 100], 'xlim', [-600 1600]), 
xlabel('amplitude 1st extrema (mi-down)'), ylabel('%')


%Compare with two-layers
barcolors={'b','r',[0.7 0.7 0.7]};
subplot(2,2,4), hold on
PlotErrorBarN_KJ(bestelec.recall, 'x_data',1:3, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
PlotErrorBarN_KJ(bestelec.precision, 'x_data',5:7, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
PlotErrorBarN_KJ(bestelec.fscore, 'x_data',9:11, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',[1:3 5:7 9:11] ,'XTickLabel',{'recall worst channel','best channel','2-layer','precision worst channel','best channel','2-layer','fscore worst channel','best channel','2-layer'})
xtickangle(30), xlim([0 12]),
title('with 2-layers')



%% PLOT

% %% Homeostasis and correlogram with down
% 
figure, hold on
%Frechet distance
subplot(2,3,1), hold on
[~,h(1)]=PlotErrorLineN_KJ(yline.frechet, 'x_data',x_plot,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('amplitude 1st extrema (mi-down)'), ylabel('Frechet distance')
xlim([-600 1600]),
%Bar plot
barcolors={'b','r',[0.7 0.7 0.7]};
subplot(2,3,4), hold on
PlotErrorBarN_KJ(bestelec.frechet, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',{'worst channel','best channel','2-layer'})
ylabel('Frechet distance')
xlim([0 4]),
title('Distance between density curves')

%Cross-correlogram
subplot(2,3,2), hold on
[~,h(1)]=PlotErrorLineN_KJ(yline.ccdown, 'x_data',x_plot,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('amplitude 1st extrema (mi-down)'), ylabel('Cross-corr with down')
xlim([-600 1600]),
%Compare with two-layers
subplot(2,3,5), hold on
PlotErrorBarN_KJ(bestelec.ccdown, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:3 ,'XTickLabel',{'worst channel','best channel','2-layer'})
xlim([0 4]),
title('Cross-correlogram maxima')


%Cross-correlogram ripples
subplot(2,3,3), hold on
[~,h(1)]=PlotErrorLineN_KJ(yline.ccrip, 'x_data',x_plot,'newfig',0,'linecolor','k','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('amplitude 1st extrema (mi-down)'), ylabel('Cross-corr with ripples')
xlim([-600 1600]),
%Compare with two-layers
subplot(2,3,6), hold on
PlotErrorBarN_KJ(bestelec.ccrip, 'newfig',0, 'barcolors',[barcolors {'k'}], 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca,'XTick',1:4 ,'XTickLabel',{'worst channel','best channel','2-layer','down'})
xlim([0 5]),
title('Cross-correlogram with ripples')




