%%FigureCharacterisationDeltaDownStates
% 12.09.2019 KJ
%
%   
%   
%
% see
%   LayerElectrodeDetectionMetrics LayerClusterAveragePerChannel
%   LayerElectrodeDetectionMetricsPlot




% load
clear
load(fullfile(FolderDeltaDataKJ,'CharacterisationDeltaDownStates.mat'))

normfrcurve = 1;
smoothingfr = 2;
smoothingcc = 0;
amplitude_range = [-1000 -10 60 200 300 600];
factorLFP = 0.195;

exclude = [[8 31]];

% unique animals & electrodes
[animals, electrodes, all_electrodes, ecogs] = Get_uniqueElectrodes_KJ(layer_res,'exclude',{'Mouse330'});


idexclude = ismember(electrodes, exclude, 'rows');
electrodes(idexclude,:)=[];
ecogs(idexclude)=[];
all_electrodes(ismember(all_electrodes, exclude, 'rows'),:) = [];


%% Meancurves: LFP on Down for each electrodes

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_elecdown    = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    y_elecdown = [y_elecdown layer_res.down.meandown{p}{ch}(:,2)*factorLFP];            
                    x_elecdown = layer_res.down.meandown{p}{ch}(:,1);                   
                end
            end
        end
    end
    
    average_res.y_elecdown{i} = mean(y_elecdown,2);     
    average_res.x_elecdown{i} = x_elecdown; 

end


%% Features in 1D-space
% meancurves
meancurves = layer_res.down.meandown;
    
%features extraction
for i=1:size(electrodes,1)
    
    xi = average_res.x_elecdown{i};
    yi = average_res.y_elecdown{i};
    %postive deflection
    if sum(yi(xi>0 & xi<=150))>0
        idx = xi>0 & xi<=200;
        Xp(i,1) = max(yi(idx));
    %negative deflection
    else
        idx = xi>0 & xi<=250;
        Xp(i,1) = min(yi(idx));
    end
    
end


%% Clusters
%clustering
clusterX = nan(length(Xp),1);

for c=1:length(amplitude_range)-1
    cond = Xp>amplitude_range(c) & Xp<=amplitude_range(c+1);
    clusterX(cond) = c+1;
end
clusterX(ecogs==1) = 1;
nb_clusters = length(unique(clusterX));
x_amplitude = 1:6;


%Mean curves on down states
for k=1:nb_clusters
    
    %idx curves
    idx_curves = find(clusterX==k);
    y_meandown_k     = [];
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        %Down 
        if ~isempty(average_res.y_elecdown{idx})
            y_meandown_k = [y_meandown_k average_res.y_elecdown{idx}];
            x_meandown_k = average_res.x_elecdown{idx};
        end
    end
    mc_down_lfp.y{k}     = mean(y_meandown_k,2);
    mc_down_lfp.x{k}     = x_meandown_k; 
end

%x-values spread for plot
binWidth = 30;
stdWidth = 0.5;
x_fig = ones(size(Xp));

for b=-200:binWidth:500
    
    valIdx = find(Xp>=b & Xp<b+binWidth);
    nVal = length(valIdx);
    
    if nVal > 1 % spread
        spreadWidth = stdWidth*0.9*(1-exp(log(0.9)*(nVal-1)));
        spreadDist = spreadWidth / (nVal - 1);
        offset = spreadDist / 2;
        for v = 1:nVal
            x_fig(valIdx(v)) = x_fig(valIdx(v)) + offset;
            % update offset
            offset = offset - sign(offset) * spreadDist * v;
        end
    end
end


%% Mean firing rate

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_mua = [];
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    y_centered = CenterFiringRateCurve(layer_res.met_mua.single{p}{ch}(:,1), layer_res.met_mua.single{p}{ch}(:,2), normfrcurve);
                    y_mua = [y_mua y_centered];            
                    x_mua = layer_res.met_mua.single{p}{ch}(:,1);                   
                end
            end
        end
    end
    average_res.y_mua{i} = mean(y_mua,2);     
    average_res.x_mua{i} = x_mua; 
end

%Clusters
for k=1:nb_clusters    
    %idx curves
    idx_curves = find(clusterX==k);
    y_mua_k    = [];
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        %Down 
        if ~isempty(average_res.y_mua{idx})
            y_mua_k = [y_mua_k average_res.y_mua{idx}];
            x_mua_k = average_res.x_mua{idx};
        end
    end
    mc_fr_delta.y{k} = runmean(mean(y_mua_k,2), smoothingfr);
    mc_fr_delta.x{k} = x_mua_k; 
end



%2-layers
for m=1:length(animals)
    y_mua = [];

    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            for h=1:length(layer_res.met_mua.multi{p})
                y_centered = CenterFiringRateCurve(layer_res.met_mua.multi{p}{h}(:,1), layer_res.met_mua.multi{p}{h}(:,2), normfrcurve);
                y_mua = [y_mua y_centered]; 
                x_mua = layer_res.met_mua.multi{p}{h}(:,1);
            end
        end
    end

    %mean and save
    multi_res.y_mua{m} = mean(y_mua,2);     
    multi_res.x_mua{m} = x_mua; 
end
%average
mc_fr_diff.y = runmean(mean(cell2mat(multi_res.y_mua), 2), smoothingfr);
mc_fr_diff.x = multi_res.x_mua{1};


%% Mean cross corr

%averaged
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    y_crosscorr = [];
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    x_cc = layer_res.cc.single{p}{ch}(:,1);
                    y_cc = layer_res.cc.single{p}{ch}(:,2);
                    if mean(y_cc(x_cc<-450))==0
                        continue
                    end                    
                    y_crosscorr = [y_crosscorr y_cc/mean(y_cc(x_cc<-450))];            
                                       
                end
            end
        end
    end
    average_res.y_cc{i} = nanmean(y_crosscorr,2);     
    average_res.x_cc{i} = x_cc; 
end

%Clusters
for k=1:nb_clusters    
    %idx curves
    idx_curves = find(clusterX==k);
    y_cc_k    = [];
    for i=1:length(idx_curves)
        idx = idx_curves(i);
        %Down 
        if ~isempty(average_res.y_cc{idx})
            y_cc_k = [y_cc_k average_res.y_cc{idx}];
            x_cc_k = average_res.x_cc{idx};
        end
    end
    cc_delta.y{k} = runmean(nanmean(y_cc_k,2), smoothingcc);
    cc_delta.x{k} = x_cc_k; 
end

%2-layers
for m=1:length(animals)
    y_crosscorr = [];

    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            for h=1:length(layer_res.cc.multi{p})
                x_cc = layer_res.cc.multi{p}{h}(:,1);
                y_cc = layer_res.cc.multi{p}{h}(:,2);
                y_crosscorr = [y_crosscorr y_cc/mean(y_cc(x_cc<-450))]; 
            end
        end
    end

    %mean and save
    multi_res.y_cc{m} = mean(y_crosscorr,2);     
    multi_res.x_cc{m} = x_cc; 
end
%average
cc_diff.y = runmean(mean(cell2mat(multi_res.y_cc), 2), smoothingcc);
cc_diff.x = multi_res.x_cc{1};



%% Accuracy on down state detection

% precision, recall, frechet distance, ratio decrease, 
for i=1:size(electrodes,1)
    m = electrodes(i,1);
    elec = electrodes(i,2);
    
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];
    
    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            channels = layer_res.channels{p};
            for ch=1:length(channels)
                if channels(ch)==elec
                    elec_recall     = [elec_recall 1-layer_res.single.recall{p}(ch)];
                    elec_precision  = [elec_precision 1-layer_res.single.precision{p}(ch)];
                    elec_fscore     = [elec_fscore layer_res.single.fscore{p}(ch)];
                end
            end
        end
    end
    
    %mean and save
    average_res.recall(i)    = mean(elec_recall);
    average_res.precision(i) = mean(elec_precision);
    average_res.fscore(i)    = mean(elec_fscore);
end

%data for plot line
for c=1:nb_clusters
    yline.recall{c}    = average_res.recall(clusterX==c) * 100;
    yline.precision{c} = average_res.precision(clusterX==c) * 100;
    yline.fscore{c}    = average_res.fscore(clusterX==c) * 100;
end


%% multi layer
%2-layers
for m=1:length(animals)
    elec_recall     = [];
    elec_precision  = [];
    elec_fscore     = [];

    %look for electrode data
    for p=1:length(layer_res.path)
        if strcmpi(animals{m},layer_res.name{p})
            elec_recall     = [elec_recall 1-max(layer_res.multi.recall{p})];
            elec_precision  = [elec_precision 1-max(layer_res.multi.precision{p})];
            elec_fscore     = [elec_fscore max(layer_res.multi.fscore{p})];
        end
    end

    %mean and save
    multi_res.recall(m)    = mean(elec_recall);
    multi_res.precision(m) = mean(elec_precision);
    multi_res.fscore(m)    = mean(elec_fscore);
end


%% Best score for each animals
for m=1:length(animals)
    
    
    idx_animal = electrodes(:,1)==m;   
    bestelec.recall(m,1)    = max(average_res.recall(idx_animal));
    bestelec.precision(m,1) = max(average_res.precision(idx_animal));
    bestelec.fscore(m,1)    = min(average_res.fscore(idx_animal));
    
    bestelec.recall(m,2)    = mean(average_res.recall(idx_animal));
    bestelec.precision(m,2) = mean(average_res.precision(idx_animal));
    bestelec.fscore(m,2)    = mean(average_res.fscore(idx_animal));
    
    bestelec.recall(m,3)   = multi_res.recall(m);
    bestelec.precision(m,3)= multi_res.precision(m);
    bestelec.fscore(m,3)   = multi_res.fscore(m);
    
end
bestelec.recall = bestelec.recall * 100; %in %
bestelec.precision = bestelec.precision * 100; %in %
bestelec.fscore = bestelec.fscore * 100; %in %


%% PLOT

%labels
labels = {'ECog','group 1','group 2','group 3','group 4','group 5'};

fontsize = 20;

% colors
color_diff = [0.6 0.6 0.6];

colori{1} = [0 0 0];
colori{2} = [0 0 1];
colori{3} = [0 0.5 0];
colori{4} = [1 0 0.3];
colori{5} = [1 0.45 0];
colori{6} = [1 0 0];

matColors = [];
for i=1:length(colori)
    matColors = [matColors;colori{i}];
end


%Figure all meancurves
figure, hold on
for i=1:length(average_res.y_elecdown)
    if electrodes(i,1)==4 && electrodes(i,2)==8
        continue
    end
    hold on, plot(average_res.x_elecdown{i}, average_res.y_elecdown{i}, 'color', [0.5 0.5 0.5]);
end
set(gca, 'xlim',[-400 500], 'ylim',[-400 500],'fontsize',fontsize),
line([0 0],get(gca,'ylim'),'linewidth',1,'color','k'),
xlabel('Time from down states start (ms)'), ylabel('Amplitude (µV)')
title('Mean LFP on down states'), hold on


%Figure 6 groups
figure, hold on

subplot(1,2,1), hold on
sz = 25;

y_fig = Xp(:,1);
h = gscatter(x_fig, y_fig, clusterX, matColors, [], 30);
ylim([-400 500]), xlim([0.5 1.5])
%lines
for i=2:length(amplitude_range)-1
    line(get(gca,'xlim'), [amplitude_range(i) amplitude_range(i)], 'linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'),
end
legend(h,labels)
ylabel('Amplitude extrema on down states (µV)')
set(gca,'xtick',[],'fontsize',fontsize)
xlabel(''),


% mean curves
subplot(1,2,2), hold on

for k=1:length(mc_down_lfp.x)
    hold on, mdo(k) = plot(mc_down_lfp.x{k}, mc_down_lfp.y{k},'color', colori{k}, 'linewidth',2);
end
set(gca, 'xlim',[-200 500], 'ylim',[-400 500],'fontsize',fontsize),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
xlabel('Time from down states start (ms)'), ylabel('Amplitude (µV)')
title('Mean LFP on down states'), hold on
legend(mdo, labels)


%% MEAN FR and CC

% firing rate
figure, hold on

subplot(1,2,1), hold on
for k=1:length(mc_fr_delta.x)
    hold on, mfr(k) = plot(mc_fr_delta.x{k}, mc_fr_delta.y{k},'color', colori{k}, 'linewidth',2);
end
mfr(end+1) = plot(mc_fr_diff.x, mc_fr_diff.y, 'color', color_diff, 'linewidth',2);
set(gca,'xlim',[-500 500], 'ylim',[0 1.6],'fontsize',fontsize),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Mean Firing Rate on delta waves'), hold on
xlabel('Time from delta waves center (ms)'), ylabel('Normalized firing rate')
legend(mfr, [labels {'2-layers'}])

% Cross Corr
subplot(1,2,2), hold on
for k=1:length(cc_delta.x)
    hold on, mcc(k) = plot(cc_delta.x{k}, cc_delta.y{k},'color', colori{k}, 'linewidth',2);
end
mcc(end+1) = plot(cc_diff.x, cc_diff.y, 'color', color_diff, 'linewidth',2);
set(gca, 'xlim', [-500 500], 'ylim',[0 8],'fontsize',fontsize),
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
title('Averaged Cross-Correlogram with down states'), hold on
xlabel('Time from down states center (ms)'), ylabel('Normalized occurence of delta waves')
legend(mcc, [labels {'2-layers'}])


%% Recall precision for each group
show_sig = 'sig';

figure, hold on

subplot(1,2,1), hold on
PlotErrorBarN_KJ(yline.precision, 'newfig',0, 'barcolors', colori, 'paired',0, 'ShowSigstar','none','showpoints',0); hold on
set(gca, 'ylim',[0 100], 'ytick',0:20:100, 'xlim', [0 7], 'xtick', 1:6, 'XTickLabel',labels,'fontsize',fontsize), 
ylabel('% false postive'), xtickangle(30)


% Recall precision compare with two layers
subplot(1,2,2), hold on
PlotErrorBarN_KJ(bestelec.precision, 'newfig',0, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca, 'xlim',[0 4], 'ylim',[0 100],'ytick',0:20:100,'fontsize',fontsize),
set(gca, 'XTick',1:3 ,'XTickLabel',{'worst electrode','best electrodes','2-layers'})
ylabel('% false positives'), xtickangle(15)



















