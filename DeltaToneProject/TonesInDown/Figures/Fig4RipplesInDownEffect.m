%%Fig4RipplesInDownEffect
% 30.05.2018 KJ
%
% effect of tones around down states
% mean of each night distrib
%
%   see 
%       Fig4RipplesInUpEffect
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'FiguresRipplesInDownPerRecord.mat'))

load(fullfile(FolderDeltaDataKJ,'RipplesInDownRasterNeuron.mat'))
% load(fullfile(FolderDeltaDataKJ,'ShamRipplesInDownRasterNeuron.mat'))

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
    
    [mouse.d_postdown.ripples{p}, mouse.x_postdown.ripples{p}] = histcounts(figure_res.ripples_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postdown.ripples{p} = mouse.x_postdown.ripples{p}(1:end-1) + diff(mouse.x_postdown.ripples{p});
    
    norm_tones = figure_res.ripples_bef{p} ./ (figure_res.ripples_bef{p} + figure_res.ripples_aft{p});
    [mouse.d_norm.ripples{p}, mouse.x_norm.ripples{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.ripples{p} = mouse.x_norm.ripples{p}(1:end-1) + diff(mouse.x_norm.ripples{p});
    
    
    %sham
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figure_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figure_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    [mouse.d_postdown.sham{p}, mouse.x_postdown.sham{p}] = histcounts(figure_res.sham_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postdown.sham{p} = mouse.x_postdown.sham{p}(1:end-1) + diff(mouse.x_postdown.sham{p});
    
    norm_sham = figure_res.sham_bef{p} ./ (figure_res.sham_bef{p} + figure_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
    
    %ratio    
    ratio_indown = abs(figure_res.ripples_bef{p} ./ figure_res.ripples_aft{p});
    [mouse.y_ratio.ripples{p}, mouse.x_ratio.ripples{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.ripples{p}= mouse.x_ratio.ripples{p}(1:end-1) + diff(mouse.x_ratio.ripples{p});
    
    ratio_indown = abs(figure_res.sham_bef{p} ./ figure_res.sham_aft{p});
    [mouse.y_ratio.sham{p}, mouse.x_ratio.sham{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.sham{p}= mouse.x_ratio.sham{p}(1:end-1) + diff(mouse.x_ratio.sham{p});
end



%% average distributions

d_before.ripples     = [];
d_after.ripples      = [];
d_postdown.ripples   = [];
d_norm.ripples       = [];
y_ratio.ripples      = []; 

x_before.ripples     = mouse.x_before.ripples{1};
x_after.ripples      = mouse.x_after.ripples{1};
x_postdown.ripples   = mouse.x_postdown.ripples{1};
x_norm.ripples       = mouse.x_norm.ripples{1};
x_ratio.ripples      = mouse.x_ratio.ripples{1};

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


for p=1:4
    d_before.ripples     = [d_before.ripples ; mouse.d_before.ripples{p}];
    d_after.ripples      = [d_after.ripples ; mouse.d_after.ripples{p}];
    d_postdown.ripples   = [d_postdown.ripples ; mouse.d_postdown.ripples{p}];
    d_norm.ripples       = [d_norm.ripples ; mouse.d_norm.ripples{p}];
    y_ratio.ripples      = [y_ratio.ripples ; mouse.y_ratio.ripples{p}];
    
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_postdown.sham    = [d_postdown.sham ; mouse.d_postdown.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    y_ratio.sham       = [y_ratio.sham ; mouse.y_ratio.sham{p}];
    
end

%mean
d_before.ripples     = mean(d_before.ripples,1);
d_after.ripples      = mean(d_after.ripples,1);
d_postdown.ripples   = mean(d_postdown.ripples,1);
d_norm.ripples       = mean(d_norm.ripples,1);
y_ratio.ripples      = mean(y_ratio.ripples,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_postdown.sham   = mean(d_postdown.sham,1);
d_norm.sham       = mean(d_norm.sham,1);
y_ratio.sham      = mean(y_ratio.sham,1);


%% pool data

select_rip = 'inside'; %{'inside', 'outside', 'around'}
% select_neurons = 'all'; % {'all','excited','neutral','inhibit'}
select_order = 'before'; %{'before','after','postdown'}

MatMUA.ripples  = [];
MatMUA.sham   = [];
ibefore.ripples = [];
ibefore.sham  = [];


for p=1:length(ripples_res.path)
    
    %tones
    raster_tsd = ripples_res.rasters.(select_rip){p};
    x_mua = Range(raster_tsd);
    MatMUA.ripples = [MatMUA.ripples ; Data(raster_tsd)'];
    
    ibefore.ripples = [ibefore.ripples ; ripples_res.(select_rip).(select_order){p}];
    
    %sham
    raster_tsd = sham_res.rasters.(select_rip){p};
    raster_y = Data(raster_tsd)';
    x_mua = Range(raster_tsd);
    
    try
        MatMUA.sham = [MatMUA.sham ; raster_y];
    catch
        raster_y = [raster_y zeros(size(raster_y,1),size(MatMUA.sham,2)-size(raster_y,2))];
        MatMUA.sham = [MatMUA.sham ; raster_y];
    end
    ibefore.sham = [ibefore.sham ; sham_res.(select_rip).(select_order){p}];
    
end

%sort raster
[~,idx_order] = sort(ibefore.ripples);
MatMUA.ripples  = MatMUA.ripples(idx_order, :);
        
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
imagesc(x_mua/1E4, 1:size(MatMUA.ripples,1), MatMUA.ripples), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_ripples = mean(MatMUA.ripples,1);
y_mua_ripples = Smooth(y_mua_ripples ,1);
y_mua_ripples = y_mua_ripples / mean(y_mua_ripples(x_mua<-0.5e4));
plot(x_mua/1E4, y_mua_ripples, 'color', 'w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.ripples,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to ripples (s)'), ylabel('#ripples'),
title('Ripples inside down states')


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
plot(x_mua/1E4, y_mua_ripples, 'color', [0.5 0.5 0.5], 'linewidth', 2);
plot(x_mua/1E4, y_mua_sham, '-w', 'linewidth', 2);
set(gca,'YLim', [0 2]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Random times inside down states')

%Distrib occurence norm
clear h
subtightplot(2,3,3,gap), hold on
h(1) = plot(x_norm.ripples, Smooth(d_norm.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
legend(h, 'ripples', 'sham'),
title('Occurence of ripples/sham in Down state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(2,3,4,gap), hold on
h(1) = plot(x_before.ripples, Smooth(d_before.ripples, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.ripples, Smooth(d_after.ripples, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.ripples, Smooth(d_postdown.ripples, smoothing), 'color', [0 0.8 0], 'linewidth',2);
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
h(1) = plot(x_ratio.ripples, Smooth(y_ratio.ripples,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'ripples', 'sham'),










