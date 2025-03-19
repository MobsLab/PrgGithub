%%Fig4RipplesCorrectedInUpEffect
% 18.06.2018 KJ
%
% effect of tones around up states
% mean of each night distrib
%
%   see 
%       FiguresTonesInUpPerRecord Fig1TonesInUpEffect Fig4RipplesInDownEffect
%       Fig4RipplesInUpEffect
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'FiguresRipplesInUpCorrectedPerRecord_2.mat'))

load(fullfile(FolderDeltaDataKJ,'RipplesCorrectedInUpRasterNeuron.mat'))
% load(fullfile(FolderDeltaDataKJ,'RipplesShamCorrectedInUpRasterNeuron.mat'))

%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% distrib
for p=1:length(figure_res.path)
    
    %tones
    [mouse.d_before.ripples{p}, mouse.x_before.ripples{p}] = histcounts(-figure_res.ripples_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.ripples{p} = mouse.x_before.ripples{p}(1:end-1) + diff(mouse.x_before.ripples{p});
    
    [mouse.d_after.ripples{p}, mouse.x_after.ripples{p}] = histcounts(figure_res.ripples_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.ripples{p} = mouse.x_after.ripples{p}(1:end-1) + diff(mouse.x_after.ripples{p});
    
    [mouse.d_postup.ripples{p}, mouse.x_postup.ripples{p}] = histcounts(figure_res.ripples_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postup.ripples{p} = mouse.x_postup.ripples{p}(1:end-1) + diff(mouse.x_postup.ripples{p});
    
    norm_tones = figure_res.ripples_bef{p} ./ (figure_res.ripples_bef{p} + figure_res.ripples_aft{p});
    [mouse.d_norm.ripples{p}, mouse.x_norm.ripples{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.ripples{p} = mouse.x_norm.ripples{p}(1:end-1) + diff(mouse.x_norm.ripples{p});
    
    
    %sham
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figure_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figure_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    [mouse.d_postup.sham{p}, mouse.x_postup.sham{p}] = histcounts(figure_res.sham_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postup.sham{p} = mouse.x_postup.sham{p}(1:end-1) + diff(mouse.x_postup.sham{p});
    
    norm_sham = figure_res.sham_bef{p} ./ (figure_res.sham_bef{p} + figure_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
    
    %ratio    
    ratio_inup = abs(figure_res.ripples_bef{p} ./ figure_res.ripples_aft{p});
    [mouse.y_ratio.ripples{p}, mouse.x_ratio.ripples{p}] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
    mouse.x_ratio.ripples{p}= mouse.x_ratio.ripples{p}(1:end-1) + diff(mouse.x_ratio.ripples{p});
    
    ratio_inup = abs(figure_res.sham_bef{p} ./ figure_res.sham_aft{p});
    [mouse.y_ratio.sham{p}, mouse.x_ratio.sham{p}] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
    mouse.x_ratio.sham{p}= mouse.x_ratio.sham{p}(1:end-1) + diff(mouse.x_ratio.sham{p});
end



%% average distributions

d_before.ripples     = [];
d_after.ripples      = [];
d_postup.ripples     = [];
d_norm.ripples       = [];
y_ratio.ripples      = []; 

x_before.ripples     = mouse.x_before.ripples{1};
x_after.ripples      = mouse.x_after.ripples{1};
x_postup.ripples     = mouse.x_postup.ripples{1};
x_norm.ripples       = mouse.x_norm.ripples{1};
x_ratio.ripples      = mouse.x_ratio.ripples{1};

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


for p=1:4
    d_before.ripples     = [d_before.ripples ; mouse.d_before.ripples{p}];
    d_after.ripples      = [d_after.ripples ; mouse.d_after.ripples{p}];
    d_postup.ripples     = [d_postup.ripples ; mouse.d_postup.ripples{p}];
    d_norm.ripples       = [d_norm.ripples ; mouse.d_norm.ripples{p}];
    y_ratio.ripples      = [y_ratio.ripples ; mouse.y_ratio.ripples{p}];
    
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_postup.sham      = [d_postup.sham ; mouse.d_postup.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    y_ratio.sham       = [y_ratio.sham ; mouse.y_ratio.sham{p}];
    
end

%mean
d_before.ripples     = mean(d_before.ripples,1);
d_after.ripples      = mean(d_after.ripples,1);
d_postup.ripples     = mean(d_postup.ripples,1);
d_norm.ripples       = mean(d_norm.ripples,1);
y_ratio.ripples      = mean(y_ratio.ripples,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_postup.sham     = mean(d_postup.sham,1);
d_norm.sham       = mean(d_norm.sham,1);
y_ratio.sham      = mean(y_ratio.sham,1);


%% pool data raster

select_rip = 'inside'; %{'inside', 'outside', 'around'}

MatMUA.ripples  = [];
MatMUA.sham   = [];
for p=1:length(ripples_res.path)
    
    %tones
    raster_tsd   = ripples_res.rasters.(select_rip){p};
    x_mua.ripples  = Range(raster_tsd);
    MatMUA.ripples = [MatMUA.ripples ; Data(raster_tsd)'];
        
    %sham
    raster_tsd  = sham_res.rasters.(select_rip){p};
    x_mua.sham  = Range(raster_tsd);
    try
        MatMUA.sham = [MatMUA.sham ; Data(raster_tsd)'];
    catch
        m = Data(raster_tsd)';
        m = [m zeros(size(m,1),1)];
        MatMUA.sham = [MatMUA.sham ; m];
    end
end


%% sort raster

ibefore.ripples = [];
ibefore.sham  = [];
iafter.ripples = [];
iafter.sham  = [];
for p=1:4
    %tones
    ibefore.ripples = [ibefore.ripples ; ripples_res.(select_rip).before{p}];
    iafter.ripples = [iafter.ripples ; ripples_res.(select_rip).after{p}];
    
    %sham
    ibefore.sham = [ibefore.sham ; sham_res.(select_rip).before{p}];
    iafter.sham = [iafter.sham ; sham_res.(select_rip).after{p}];
end


%before
[~,idx_order] = sort(ibefore.ripples);
MatBefore.ripples  = MatMUA.ripples(idx_order, :);
[~,idx_order] = sort(ibefore.sham);
MatBefore.sham = MatMUA.sham(idx_order, :);

%after
[~,idx_order] = sort(iafter.ripples);
MatAfter.ripples = MatMUA.ripples(idx_order, :);
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
imagesc(x_mua.ripples/1E4, 1:size(MatMUA.ripples,1), MatAfter.ripples), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_ripples = mean(MatMUA.ripples,1);
y_mua_ripples = Smooth(y_mua_ripples ,1);
y_mua_ripples = y_mua_ripples / mean(y_mua_ripples(x_mua.ripples<-0.5e4));
plot(x_mua.ripples/1E4, y_mua_ripples, 'color', 'w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.ripples,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to ripples (ms)'),
ylabel('#ripples'),
title('Ripples inside Up states')


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
plot(x_mua.ripples/1E4, y_mua_ripples, 'color', [0.5 0.5 0.5], 'linewidth', 2);
plot(x_mua.sham/1E4, y_mua_sham, '-w', 'linewidth', 2);

set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'),
title('Sham inside Up states')


%TONES - raster plot - half half 
subtightplot(3,6,7,gap, [0 0], [0.05 -0.11]), hold on
imagesc(x_mua.ripples/1E4, 1:size(MatMUA.ripples,1), MatBefore.ripples), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.ripples,1)], 'XLim',[-0.4 0], 'yticklabel',{[]});
ylabel('#tones'),

subtightplot(3,6,8,gap, [0 0], [0 -0.05]), hold on
imagesc(x_mua.ripples/1E4, 1:size(MatMUA.ripples,1), MatAfter.ripples), hold on
axis xy, hold on
set(gca,'YLim', [0 size(MatMUA.ripples,1)], 'XLim',[0 0.4], 'yticklabel',{[]});

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
h(1) = plot(x_norm.ripples, Smooth(d_norm.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
lgd = legend(h, 'ripples', 'sham');
lgd.Location= 'northwest';
title('Occurence of ripples/sham in Up state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(3,6,13:14,gap), hold on
h(1) = plot(x_before.ripples, Smooth(d_before.ripples, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.ripples, Smooth(d_after.ripples, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.ripples, Smooth(d_postup.ripples, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7]),
xlabel('time relative to ripples (s)'),
legend(h, 'start', 'end', 'up post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(3,6,15:16,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.sham, Smooth(d_postup.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7]),
xlabel('time relative to ripples (s)'),


%Distrib log-ratio
clear h
subtightplot(3,6,17:18,gap), hold on
h(1) = plot(x_ratio.ripples, Smooth(y_ratio.ripples,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'ripples', 'sham'),










