%%Fig1TonesInUp_midthesis
% 11.08.2018 KJ
%
% effect of tones around up states
% mean of each night distrib
%
%   see 
%       Fig1TonesInUpEffect
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


%% distrib

%tones
for p=1:4
    [mouse.d_before.tones{p}, mouse.x_before.tones{p}] = histcounts(-figure_res.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.tones{p} = mouse.x_before.tones{p}(1:end-1) + diff(mouse.x_before.tones{p});
    
    [mouse.d_after.tones{p}, mouse.x_after.tones{p}] = histcounts(figure_res.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.tones{p} = mouse.x_after.tones{p}(1:end-1) + diff(mouse.x_after.tones{p});
    
    norm_tones = figure_res.tones_bef{p} ./ (figure_res.tones_bef{p} + figure_res.tones_aft{p});
    [mouse.d_norm.tones{p}, mouse.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.tones{p} = mouse.x_norm.tones{p}(1:end-1) + diff(mouse.x_norm.tones{p});

    
end

%sham
for p=1:length(figsham_res.path)
    [mouse.d_before.sham{p}, mouse.x_before.sham{p}] = histcounts(-figsham_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.sham{p} = mouse.x_before.sham{p}(1:end-1) + diff(mouse.x_before.sham{p});
    
    [mouse.d_after.sham{p}, mouse.x_after.sham{p}] = histcounts(figsham_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.sham{p} = mouse.x_after.sham{p}(1:end-1) + diff(mouse.x_after.sham{p});
    
    norm_sham = figsham_res.sham_bef{p} ./ (figsham_res.sham_bef{p} + figsham_res.sham_aft{p});
    [mouse.d_norm.sham{p}, mouse.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    mouse.x_norm.sham{p} = mouse.x_norm.sham{p}(1:end-1) + diff(mouse.x_norm.sham{p});
    
end


%% average distributions

d_before.tones     = [];
d_after.tones      = [];
d_norm.tones       = [];

x_before.tones     = mouse.x_before.tones{1};
x_after.tones      = mouse.x_after.tones{1};
x_norm.tones       = mouse.x_norm.tones{1};

d_before.sham      = [];
d_after.sham       = [];
d_norm.sham        = [];

x_before.sham   = mouse.x_before.sham{1};
x_after.sham    = mouse.x_after.sham{1};
x_norm.sham     = mouse.x_norm.sham{1};


%tones
for p=1:4
    d_before.tones     = [d_before.tones ; mouse.d_before.tones{p}];
    d_after.tones      = [d_after.tones ; mouse.d_after.tones{p}];
    d_norm.tones       = [d_norm.tones ; mouse.d_norm.tones{p}];
end

%sham
for p=1:length(figsham_res.path)
    
    d_before.sham      = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham       = [d_after.sham ; mouse.d_after.sham{p}];
    d_norm.sham        = [d_norm.sham ; mouse.d_norm.sham{p}];
    
end

%std
std_before.tones     = std(d_before.tones,1);
std_after.tones      = std(d_after.tones,1);
std_norm.tones       = std(d_norm.tones,1);

std_before.sham     = std(d_before.sham,1);
std_after.sham      = std(d_after.sham,1);
std_norm.sham       = std(d_norm.sham,1);

%mean
d_before.tones     = mean(d_before.tones,1);
d_after.tones      = mean(d_after.tones,1);
d_norm.tones       = mean(d_norm.tones,1);

d_before.sham     = mean(d_before.sham,1);
d_after.sham      = mean(d_after.sham,1);
d_norm.sham       = mean(d_norm.sham,1);


%distrib
d_before.tones(x_before.tones>0)=[];
x_before.tones(x_before.tones>0)=[];
d_before.sham(x_before.sham>0)=[];
x_before.sham(x_before.sham>0)=[];

d_after.tones(x_after.tones<0)=[];
x_after.tones(x_after.tones<0)=[];
d_after.sham(x_after.sham<0)=[];
x_after.sham(x_after.sham<0)=[];


%% pool data raster

select_tone = 'inside'; %{'inside', 'outside', 'around'}
select_neurons = 'all'; % {'all','excited','neutral','inhibit'}
select_order = 'after'; %{'before','after'}

MatMUA.tones  = [];
MatMUA.sham   = [];
ibefore.tones = [];
ibefore.sham  = [];


%tones
for p=1:4
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


%% MUA response
%tones mua response
y_mua_tones = mean(MatMUA.tones,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua<-0.5e4));

%sham mua response
y_mua_sham = mean(MatMUA.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua<-0.5e4));


%% PLOT
% figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


%TONES - raster plot
subtightplot(4,4,8+1,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.tones,1), MatMUA.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones in up states')


%SHAM - raster plot
subtightplot(4,4,8+5,gap), hold on
imagesc(x_mua/1E4, 1:size(MatMUA.sham,1), MatMUA.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Sham in Up states')

% MUA
subtightplot(4,4,8+[2 6],gap), hold on
h(1) = plot(x_mua/1E4, y_mua_tones, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/1E4, y_mua_sham, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-0.4 0.4]);
line([0.04 0.04], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7])
lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
xlabel('time from tones (s)'),
title('Mean MUA on tones/sham'),


%Distrib of start and end of up states
clear h
subtightplot(4,4,8+[3 7],gap), hold on


h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', 'r', 'linewidth',2);

ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
% lgd2 = legend(hh, 'tones', 'sham'); lgd2.Location='northeast';
xlabel('time from tones (ms)'),
title('occurence of start/end of Up'),


%Distrib occurence norm
clear h
subtightplot(4,4,8+[4 8],gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'),  
ylim([0.02 0.08]), yticks(0:0.01:0.08), 
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
title('Occurence of tones/sham in Up (normalized)')








