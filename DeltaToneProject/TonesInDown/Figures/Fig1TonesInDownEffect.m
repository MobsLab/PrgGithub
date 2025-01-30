%%Fig1TonesInDownEffect
% 11.05.2018 KJ
%
% effect of tones around down states
% mean of each night distrib
%
%   see 
%       FiguresTonesInDownPerRecord FiguresTonesInDownPerRecordPlot PoolTonesIndownEffectPlot
%       Fig1TonesInUpEffect
%
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'FiguresTonesInDownPerRecord.mat'))
load(fullfile(FolderDeltaDataKJ,'FiguresShamInDownPerRecord.mat'))

load(fullfile(FolderDeltaDataKJ,'ToneInDownRasterNeuron.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInDownRasterNeuron.mat'))


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
    
    [mouse.d_postdown.tones{p}, mouse.x_postdown.tones{p}] = histcounts(figure_res.tones_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postdown.tones{p} = mouse.x_postdown.tones{p}(1:end-1) + diff(mouse.x_postdown.tones{p});
    
    norm_tones = figure_res.tones_bef{p} ./ (figure_res.tones_bef{p} + figure_res.tones_aft{p});
    [mouse.d_norm.tones{p}, mouse.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.tones{p} = mouse.x_norm.tones{p}(1:end-1) + diff(mouse.x_norm.tones{p});
    
    %ratio    
    ratio_indown = abs(figure_res.tones_bef{p} ./ figure_res.tones_aft{p});
    [mouse.y_ratio.tones{p}, mouse.x_ratio.tones{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.tones{p}= mouse.x_ratio.tones{p}(1:end-1) + diff(mouse.x_ratio.tones{p});
    
end

%sham
for p=1:length(figsham_res.path)
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figsham_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figsham_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    [mouse.d_postdown.sham{p}, mouse.x_postdown.sham{p}] = histcounts(figsham_res.sham_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postdown.sham{p} = mouse.x_postdown.sham{p}(1:end-1) + diff(mouse.x_postdown.sham{p});
    
    norm_sham = figsham_res.sham_bef{p} ./ (figsham_res.sham_bef{p} + figsham_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
    
    %ratio    
    ratio_indown = abs(figsham_res.sham_bef{p} ./ figsham_res.sham_aft{p});
    [mouse.y_ratio.sham{p}, mouse.x_ratio.sham{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.sham{p}= mouse.x_ratio.sham{p}(1:end-1) + diff(mouse.x_ratio.sham{p});
end



%% average distributions

d_before.tones     = [];
d_after.tones      = [];
d_postdown.tones   = [];
d_norm.tones       = [];
y_ratio.tones      = []; 

x_before.tones     = mouse.x_before.tones{1};
x_after.tones      = mouse.x_after.tones{1};
x_postdown.tones   = mouse.x_postdown.tones{1};
x_norm.tones       = mouse.x_norm.tones{1};
x_ratio.tones      = mouse.x_ratio.tones{1};

d_before.sham      = [];
d_after.sham       = [];
d_postdown.sham    = [];
d_norm.sham        = [];
y_ratio.sham       = []; 

x_before.sham   = mouse.x_before.sham{1};
x_after.sham    = mouse.x_after.sham{1};
x_postdown.sham = mouse.x_postdown.sham{1};
x_norm.sham     = mouse.x_norm.sham{1};
x_ratio.sham    = mouse.x_ratio.sham{1};


%tones
for p=1:length(figure_res.path)
    d_before.tones     = [d_before.tones ; mouse.d_before.tones{p}];
    d_after.tones      = [d_after.tones ; mouse.d_after.tones{p}];
    d_postdown.tones   = [d_postdown.tones ; mouse.d_postdown.tones{p}];
    d_norm.tones       = [d_norm.tones ; mouse.d_norm.tones{p}];
    y_ratio.tones      = [y_ratio.tones ; mouse.y_ratio.tones{p}];    
end

%sham
for p=1:length(figsham_res.path)
    
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_postdown.sham    = [d_postdown.sham ; mouse.d_postdown.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    y_ratio.sham       = [y_ratio.sham ; mouse.y_ratio.sham{p}];
    
end

%mean
d_before.tones     = mean(d_before.tones,1);
d_after.tones      = mean(d_after.tones,1);
d_postdown.tones   = mean(d_postdown.tones,1);
d_norm.tones       = mean(d_norm.tones,1);
y_ratio.tones      = mean(y_ratio.tones,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_postdown.sham   = mean(d_postdown.sham,1);
d_norm.sham       = mean(d_norm.sham,1);
y_ratio.sham      = mean(y_ratio.sham,1);


%% pool data

select_tone = 'inside'; %{'inside', 'outside', 'around'}
select_neurons = 'all'; % {'all','excited','neutral','inhibit'}
select_order = 'before'; %{'before','after','postdown'}

MatMUA.tones  = [];
MatMUA.sham   = [];
ibefore.tones = [];
ibefore.sham  = [];


%tones
for p=1:length(figure_res.path)
    raster_tsd = tones_res.rasters.(select_tone).(select_neurons){p};
    x_mua = Range(raster_tsd);
    MatMUA.tones = [MatMUA.tones ; Data(raster_tsd)'];
    
    ibefore.tones = [ibefore.tones ; tones_res.(select_tone).(select_order){p}];
    
    
end

%sham
for p=1:length(figsham_res.path)
    raster_tsd = sham_res.rasters.(select_tone).(select_neurons){p};
    x_mua = Range(raster_tsd);
    MatMUA.sham = [MatMUA.sham ; Data(raster_tsd)'];
    
    ibefore.sham = [ibefore.sham ; sham_res.(select_tone).(select_order){p}];
    
end

%sort raster
[~,idx_order] = sort(ibefore.tones);
MatMUA.tones  = MatMUA.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.sham);
MatMUA.sham  = MatMUA.sham(idx_order, :);
        

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
subtightplot(2,3,1,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.tones,1), MatMUA.tones), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_tones = mean(MatMUA.tones,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua<-0.5e4));
plot(x_mua/1E4, y_mua_tones, 'color', 'w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside down states')


%SHAM - raster plot
subtightplot(2,3,2,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.sham,1), MatMUA.sham), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_sham = mean(MatMUA.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua<-0.5e4));
hold on, plot(x_mua/1E4, y_mua_tones, 'color', [0.5 0.5 0.5], 'linewidth', 2);
hold on, plot(x_mua/1E4, y_mua_sham, '-w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Sham inside down states')

%Distrib occurence norm
clear h
subtightplot(2,3,3,gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
legend(h, 'tones', 'sham'),
title('Occurence of tones/sham in Down state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(2,3,4,gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.tones, Smooth(d_postdown.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
legend(h, 'start', 'end', 'down post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(2,3,5,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.sham, Smooth(d_postdown.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


%Distrib log-ratio
clear h
subtightplot(2,3,6,gap), hold on
h(1) = plot(x_ratio.tones, Smooth(y_ratio.tones,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'tones', 'sham'),










