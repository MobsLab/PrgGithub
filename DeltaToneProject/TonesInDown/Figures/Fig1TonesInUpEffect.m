%%Fig1TonesInUpEffect
% 18.05.2018 KJ
%
% effect of tones around up states
% mean of each night distrib
%
%   see 
%       FiguresTonesInUpPerRecord Fig1TonesInDownEffect
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'FiguresTonesInUpPerRecord.mat'))
load(fullfile(FolderDeltaDataKJ,'FiguresShamInUpPerRecord.mat'))

load(fullfile(FolderDeltaDataKJ,'ToneInUpRasterNeuron.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInUpRasterNeuron.mat'))

%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% distrib

%tones
for p=1:length(figure_res.path)
    [mouse.d_before.tones{p}, mouse.x_before.tones{p}] = histcounts(-figure_res.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.tones{p} = mouse.x_before.tones{p}(1:end-1) + diff(mouse.x_before.tones{p});
    
    [mouse.d_after.tones{p}, mouse.x_after.tones{p}] = histcounts(figure_res.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.tones{p} = mouse.x_after.tones{p}(1:end-1) + diff(mouse.x_after.tones{p});
    
    [mouse.d_postup.tones{p}, mouse.x_postup.tones{p}] = histcounts(figure_res.tones_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postup.tones{p} = mouse.x_postup.tones{p}(1:end-1) + diff(mouse.x_postup.tones{p});
    
    norm_tones = figure_res.tones_bef{p} ./ (figure_res.tones_bef{p} + figure_res.tones_aft{p});
    [mouse.d_norm.tones{p}, mouse.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.tones{p} = mouse.x_norm.tones{p}(1:end-1) + diff(mouse.x_norm.tones{p});
    
    %ratio    
    ratio_inup = abs(figure_res.tones_bef{p} ./ figure_res.tones_aft{p});
    [mouse.y_ratio.tones{p}, mouse.x_ratio.tones{p}] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
    mouse.x_ratio.tones{p}= mouse.x_ratio.tones{p}(1:end-1) + diff(mouse.x_ratio.tones{p});
    
end


%sham
for p=1:length(figsham_res.path)
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figsham_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figsham_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    [mouse.d_postup.sham{p}, mouse.x_postup.sham{p}] = histcounts(figsham_res.sham_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postup.sham{p} = mouse.x_postup.sham{p}(1:end-1) + diff(mouse.x_postup.sham{p});
    
    norm_sham = figsham_res.sham_bef{p} ./ (figsham_res.sham_bef{p} + figsham_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
    %sham
    ratio_inup = abs(figsham_res.sham_bef{p} ./ figsham_res.sham_aft{p});
    [mouse.y_ratio.sham{p}, mouse.x_ratio.sham{p}] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
    mouse.x_ratio.sham{p}= mouse.x_ratio.sham{p}(1:end-1) + diff(mouse.x_ratio.sham{p});
end


%% average distributions

d_before.tones     = [];
d_after.tones      = [];
d_postup.tones     = [];
d_norm.tones       = [];
y_ratio.tones      = []; 

x_before.tones     = mouse.x_before.tones{1};
x_after.tones      = mouse.x_after.tones{1};
x_postup.tones     = mouse.x_postup.tones{1};
x_norm.tones       = mouse.x_norm.tones{1};
x_ratio.tones      = mouse.x_ratio.tones{1};

d_before.sham      = [];
d_after.sham       = [];
d_postup.sham      = [];
d_norm.sham        = [];
y_ratio.sham       = []; 

x_before.sham   = mouse.x_before.sham{1};
x_after.sham    = mouse.x_after.sham{1};
x_postup.sham   = mouse.x_postup.sham{1};
x_norm.sham     = mouse.x_norm.sham{1};
x_ratio.sham    = mouse.x_ratio.sham{1};


%tones
for p=1:length(figure_res.path)
    d_before.tones     = [d_before.tones ; mouse.d_before.tones{p}];
    d_after.tones      = [d_after.tones ; mouse.d_after.tones{p}];
    d_postup.tones     = [d_postup.tones ; mouse.d_postup.tones{p}];
    d_norm.tones       = [d_norm.tones ; mouse.d_norm.tones{p}];
    y_ratio.tones      = [y_ratio.tones ; mouse.y_ratio.tones{p}];
end

%sham
for p=1:length(sham_res.path)
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_postup.sham      = [d_postup.sham ; mouse.d_postup.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    y_ratio.sham       = [y_ratio.sham ; mouse.y_ratio.sham{p}];
end


%mean
d_before.tones     = mean(d_before.tones,1);
d_after.tones      = mean(d_after.tones,1);
d_postup.tones     = mean(d_postup.tones,1);
d_norm.tones       = mean(d_norm.tones,1);
y_ratio.tones      = mean(y_ratio.tones,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_postup.sham     = mean(d_postup.sham,1);
d_norm.sham       = mean(d_norm.sham,1);
y_ratio.sham      = mean(y_ratio.sham,1);


%% pool data raster

select_tone = 'inside'; %{'inside', 'outside', 'around'}
select_neurons = 'all'; % {'all','excited','neutral','inhibit'}

%tones
MatMUA.tones  = [];
for p=1:length(figure_res.path)
    raster_tsd   = tones_res.rasters.(select_tone).(select_neurons){p};
    x_mua.tones  = Range(raster_tsd);
    MatMUA.tones = [MatMUA.tones ; Data(raster_tsd)'];
        
end

%sham
MatMUA.sham   = [];
for p=1:length(sham_res.path)
    raster_tsd  = sham_res.rasters.(select_tone).(select_neurons){p};
    x_mua.sham  = Range(raster_tsd);
    MatMUA.sham = [MatMUA.sham ; Data(raster_tsd)'];
end


%% sort raster

%tones
ibefore.tones = [];
iafter.tones = [];
for p=1:length(figure_res.path)
    ibefore.tones = [ibefore.tones ; tones_res.(select_tone).before{p}];
    iafter.tones = [iafter.tones ; tones_res.(select_tone).after{p}];
end

%sham
ibefore.sham  = [];
iafter.sham  = [];
for p=1:length(sham_res.path)
    ibefore.sham = [ibefore.sham ; sham_res.(select_tone).before{p}];
    iafter.sham = [iafter.sham ; sham_res.(select_tone).after{p}];
end


%before
[~,idx_order] = sort(ibefore.tones);
MatBefore.tones  = MatMUA.tones(idx_order, :);
[~,idx_order] = sort(ibefore.sham);
MatBefore.sham = MatMUA.sham(idx_order, :);

%after
[~,idx_order] = sort(iafter.tones);
MatAfter.tones = MatMUA.tones(idx_order, :);
[~,idx_order] = sort(iafter.sham);
MatAfter.sham = MatMUA.sham(idx_order, :);
        

%% PLOT
figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


%TONES - raster plot
subtightplot(3,6,1:2,gap), hold on
imagesc(x_mua.tones/1E4, 1:size(MatMUA.tones,1), MatAfter.tones), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_tones = mean(MatMUA.tones,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua.tones<-0.5e4));
plot(x_mua.tones/1E4, y_mua_tones, 'color', 'w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to tones (ms)'),
ylabel('#tones'),
title('Tones inside Up states')


%SHAM - raster plot
subtightplot(3,6,3:4,gap), hold on
imagesc(x_mua.sham/1E4, 1:size(MatMUA.sham,1), MatAfter.sham), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_sham = mean(MatMUA.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua.sham<-0.5e4));
plot(x_mua.tones/1E4, y_mua_tones, 'color',  [0.5 0.5 0.5], 'linewidth', 2);
plot(x_mua.sham/1E4, y_mua_sham, '-w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'),
title('Sham inside Up states')


%TONES - raster plot - half half 
subtightplot(3,6,7,gap, [0 0], [0.05 -0.11]), hold on
imagesc(x_mua.tones/1E4, 1:size(MatMUA.tones,1), MatBefore.tones), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[-0.4 0], 'yticklabel',{[]});
ylabel('#tones'),

subtightplot(3,6,8,gap, [0 0], [0 -0.05]), hold on
imagesc(x_mua.tones/1E4, 1:size(MatMUA.tones,1), MatAfter.tones), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[0 0.4], 'yticklabel',{[]});

%SHAM - raster plot - half half 
subtightplot(3,6,9,gap, [0 0], [0.01 -0.04]), hold on
imagesc(x_mua.sham/1E4, 1:size(MatMUA.sham,1), MatBefore.sham), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0], 'yticklabel',{[]});

subtightplot(3,6,10,gap, [0 0], [-0.07 -0.01]), hold on
imagesc(x_mua.sham/1E4, 1:size(MatMUA.sham,1), MatAfter.sham), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[0 0.4], 'yticklabel',{[]});


%Distrib occurence norm
clear h
subtightplot(3,6,5:6,gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
lgd = legend(h, 'tones', 'sham');
lgd.Location= 'northwest';
title('Occurence of tones/sham in Up state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(3,6,13:14,gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.tones, Smooth(d_postup.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7]),
xlabel('time relative to tones (s)'),
legend(h, 'start', 'end', 'up post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(3,6,15:16,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.sham, Smooth(d_postup.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7]),
xlabel('time relative to tones (s)'),


%Distrib log-ratio
clear h
subtightplot(3,6,17:18,gap), hold on
h(1) = plot(x_ratio.tones, Smooth(y_ratio.tones,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'tones', 'sham'),










