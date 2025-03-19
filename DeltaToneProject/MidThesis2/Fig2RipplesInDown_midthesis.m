%%Fig2RipplesInDown_midthesis
% 11.08.2018 KJ
%
% effect of ripples around down states
% mean of each night distrib
%
%   see 
%       Fig1TonesInDownEffect Fig2RipplesInUp_midthesis
%
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'FiguresRipplesInDownPerRecord.mat'))
load(fullfile(FolderDeltaDataKJ,'RipplesInDownRasterNeuron.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;


%% distrib

%tones
for p=1:length(figure_res.path)
    [mouse.d_before.ripples{p}, mouse.x_before.ripples{p}] = histcounts(-figure_res.ripples_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.ripples{p} = mouse.x_before.ripples{p}(1:end-1) + diff(mouse.x_before.ripples{p});
    
    [mouse.d_after.ripples{p}, mouse.x_after.ripples{p}] = histcounts(figure_res.ripples_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.ripples{p} = mouse.x_after.ripples{p}(1:end-1) + diff(mouse.x_after.ripples{p});
    
    norm_tones = figure_res.ripples_bef{p} ./ (figure_res.ripples_bef{p} + figure_res.ripples_aft{p});
    [mouse.d_norm.ripples{p}, mouse.x_norm.ripples{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.ripples{p} = mouse.x_norm.ripples{p}(1:end-1) + diff(mouse.x_norm.ripples{p});

    
end

%sham
for p=1:length(figure_res.path)
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figure_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figure_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    norm_sham = figure_res.sham_bef{p} ./ (figure_res.sham_bef{p} + figure_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
end


%% average distributions

d_before.ripples    = [];
d_after.ripples     = [];
d_norm.ripples      = [];

x_before.ripples    = mouse.x_before.ripples{1};
x_after.ripples     = mouse.x_after.ripples{1};
x_norm.ripples      = mouse.x_norm.ripples{1};

d_before.sham      = [];
d_after.sham       = [];
d_norm.sham        = [];

x_before.sham   = mouse.x_before.sham{1};
x_after.sham    = mouse.x_after.sham{1};
x_norm.sham     = mouse.x_norm.sham{1};


%tones
for p=1:length(figure_res.path)
    d_before.ripples    = [d_before.ripples; mouse.d_before.ripples{p}];
    d_after.ripples     = [d_after.ripples; mouse.d_after.ripples{p}];
    d_norm.ripples      = [d_norm.ripples; mouse.d_norm.ripples{p}];
end

%sham
for p=1:length(figure_res.path)
    
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    
end

%mean
d_before.ripples    = mean(d_before.ripples,1);
d_after.ripples     = mean(d_after.ripples,1);
d_norm.ripples      = mean(d_norm.ripples,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_norm.sham       = mean(d_norm.sham,1);


%distrib
d_before.ripples(x_before.ripples>0)=[];
x_before.ripples(x_before.ripples>0)=[];
d_before.sham(x_before.sham>0)=[];
x_before.sham(x_before.sham>0)=[];

d_after.ripples(x_after.ripples<0)=[];
x_after.ripples(x_after.ripples<0)=[];
d_after.sham(x_after.sham<0)=[];
x_after.sham(x_after.sham<0)=[];


%% pool data

select_rip = 'inside'; %{'inside', 'outside', 'around'}
select_order = 'before'; %{'before','after'}

MatMUA.ripples = [];
MatMUA.sham   = [];
ibefore.ripples= [];
ibefore.sham  = [];


%tones
for p=1:length(figure_res.path)
    raster_tsd = ripples_res.rasters.(select_rip){p};
    x_mua = Range(raster_tsd);
    MatMUA.ripples= [MatMUA.ripples; Data(raster_tsd)'];
    
    ibefore.ripples= [ibefore.ripples; ripples_res.(select_rip).(select_order){p}];
    
end

%sham
for p=1:length(figure_res.path)
    raster_tsd = sham_res.rasters.(select_rip){p};
    x_mua = Range(raster_tsd);
    d_mua =  Data(raster_tsd)';
    if size(d_mua,2)<size(MatMUA.sham,2)
        d_mua = [d_mua zeros(size(d_mua,1),size(MatMUA.sham,2)-size(d_mua,2))];
    end
    
    MatMUA.sham = [MatMUA.sham ; d_mua];
    
    ibefore.sham = [ibefore.sham ; sham_res.(select_rip).(select_order){p}];
    
end

%sort raster
[~,idx_order] = sort(ibefore.ripples);
MatMUA.ripples = MatMUA.ripples(idx_order, :);
        
[~,idx_order] = sort(ibefore.sham);
MatMUA.sham  = MatMUA.sham(idx_order, :);


%% MUA response
%tones mua response
y_mua_tones = mean(MatMUA.ripples,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua<-0.5e4));

%sham mua response
y_mua_sham = mean(MatMUA.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua<-0.5e4));


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
subtightplot(4,4,1,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.ripples,1), MatMUA.ripples), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
set(gca,'YLim', [0 size(MatMUA.ripples,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to ripples (s)'), ylabel('#tones'),
title('Ripples inside down states')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.sham,1), MatMUA.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to random (ms)'), ylabel('#random'),
title('Random time inside down states')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/1E4, y_mua_tones, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/1E4, y_mua_sham, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-0.4 0.4]);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
xlabel('time from ripples (s)'),
title('Mean MUA on ripples/random'),


%Distrib of start and end of down states
clear h
subtightplot(4,4,[3 7],gap), hold on

h(1) = plot(x_before.ripples, Smooth(d_before.ripples, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.ripples, Smooth(d_after.ripples, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', 'r', 'linewidth',2);

ylim([0 0.2]), yticks(0:0.05:0.2),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
lgd2 = legend(hh, 'ripples', 'random'); lgd2.Location='northeast';
xlabel('time from ripples (ms)'),
title('occurence of start/end of Down'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.ripples, Smooth(d_norm.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), yticks(0:0.02:0.08),
lgd = legend(h, 'ripples', 'random'); lgd.Location='northeast';
title('Occurence of ripples/random in Down state (normalized)'),










