%%FigTonesInUpNREM_fr
% 18.09.2018 KJ
%
% effect of tones in down states
% in N2 and N3
%
%   see 
%       FigTonesInUpN2N3 FigTonesInDownNREM
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'TonesInUpN2N3Effect.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInUpN2N3Effect.mat'))

load(fullfile(FolderDeltaDataKJ,'TonesInUpN2N3Raster.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInUpN2N3Raster.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
smoothing = 1;
animals = unique(tones_res.name);


%% transitions probability

%tones
proba.nrem.tones = [];

for m=1:length(animals)
    
    probnrem_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse tones_res.nrem.transit_rate{p}];
        end
    end
    %NREM
    proba.nrem.tones = [proba.nrem.tones mean(probnrem_mouse)];
end



%sham
proba.nrem.sham = [];
for m=1:length(animals)
    
    probnrem_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse sham_res.nrem.transit_rate{p}];
        end
    end
    %NREM
    proba.nrem.sham = [proba.nrem.sham mean(probnrem_mouse)];
end





%% distrib

%tones
for p=1:length(tones_res.path)
    
    %NREM
    [nrem.d_before.tones{p}, nrem.x_before.tones{p}] = histcounts(-tones_res.nrem.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    nrem.x_before.tones{p} = nrem.x_before.tones{p}(1:end-1) + diff(nrem.x_before.tones{p});
    
    [nrem.d_after.tones{p}, nrem.x_after.tones{p}] = histcounts(tones_res.nrem.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    nrem.x_after.tones{p} = nrem.x_after.tones{p}(1:end-1) + diff(nrem.x_after.tones{p});
    
    norm_tones = tones_res.nrem.tones_bef{p} ./ (tones_res.nrem.tones_bef{p} + tones_res.nrem.tones_aft{p});
    [nrem.d_norm.tones{p}, nrem.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    nrem.x_norm.tones{p} = nrem.x_norm.tones{p}(1:end-1) + diff(nrem.x_norm.tones{p});
end

%sham
for p=1:length(sham_res.path)
    
    %NREM
    [nrem.d_before.sham{p}, nrem.x_before.sham{p}] = histcounts(-sham_res.nrem.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    nrem.x_before.sham{p} = nrem.x_before.sham{p}(1:end-1) + diff(nrem.x_before.sham{p});
    
    [nrem.d_after.sham{p}, nrem.x_after.sham{p}] = histcounts(sham_res.nrem.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    nrem.x_after.sham{p} = nrem.x_after.sham{p}(1:end-1) + diff(nrem.x_after.sham{p});
    
    norm_sham = sham_res.nrem.sham_bef{p} ./ (sham_res.nrem.sham_bef{p} + sham_res.nrem.sham_aft{p});
    [nrem.d_norm.sham{p}, nrem.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    nrem.x_norm.sham{p} = nrem.x_norm.sham{p}(1:end-1) + diff(nrem.x_norm.sham{p});
    
end


%% average distributions

d_before.nrem.tones     = [];
d_after.nrem.tones      = [];
d_norm.nrem.tones       = [];

x_before.nrem.tones     = nrem.x_before.tones{1};
x_after.nrem.tones      = nrem.x_after.tones{1};
x_norm.nrem.tones       = nrem.x_norm.tones{1};

d_before.nrem.sham      = [];
d_after.nrem.sham       = [];
d_norm.nrem.sham        = [];

x_before.nrem.sham   = nrem.x_before.sham{1};
x_after.nrem.sham    = nrem.x_after.sham{1};
x_norm.nrem.sham     = nrem.x_norm.sham{1};

%tones
for m=1:length(animals)
    
    nrem_before_mouse = [];
    nrem_after_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.tones{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.tones{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.tones{p}];
        end
    end

    d_before.nrem.tones  = [d_before.nrem.tones ; mean(nrem_before_mouse,1)];
    d_after.nrem.tones   = [d_after.nrem.tones ; mean(nrem_after_mouse,1)];
    d_norm.nrem.tones    = [d_norm.nrem.tones ; Smooth(mean(nrem_norm_mouse,1),smoothing)'];
end


%sham
for m=1:length(animals)
    nrem_before_mouse = [];
    nrem_after_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.sham{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.sham{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.sham{p}];
        end
    end

    d_before.nrem.sham  = [d_before.nrem.sham ; mean(nrem_before_mouse,1)];
    d_after.nrem.sham   = [d_after.nrem.sham ; mean(nrem_after_mouse,1)];
    d_norm.nrem.sham    = [d_norm.nrem.sham ; Smooth(mean(nrem_norm_mouse,1),smoothing)'];
end


%mean NREM
std_before.nrem.tones   = std(d_before.nrem.tones,1) / sqrt(size(d_before.nrem.tones,1));
std_after.nrem.tones    = std(d_after.nrem.tones,1) / sqrt(size(d_after.nrem.tones,1));
std_norm.nrem.tones     = std(d_norm.nrem.tones,1) / sqrt(size(d_norm.nrem.tones,1));
d_before.nrem.tones     = mean(d_before.nrem.tones,1);
d_after.nrem.tones      = mean(d_after.nrem.tones,1);
d_norm.nrem.tones       = mean(d_norm.nrem.tones,1);

std_before.nrem.sham   = std(d_before.nrem.sham,1) / sqrt(size(d_before.nrem.sham,1));
std_after.nrem.sham    = std(d_after.nrem.sham,1) / sqrt(size(d_after.nrem.sham,1));
std_norm.nrem.sham     = std(d_norm.nrem.sham,1) / sqrt(size(d_norm.nrem.sham,1));
d_before.nrem.sham     = mean(d_before.nrem.sham,1);
d_after.nrem.sham      = mean(d_after.nrem.sham,1);
d_norm.nrem.sham       = mean(d_norm.nrem.sham,1);


%distrib NREM
d_before.nrem.tones(x_before.nrem.tones>0)=[];
std_before.nrem.tones(x_before.nrem.tones>0)=[];
x_before.nrem.tones(x_before.nrem.tones>0)=[];
d_before.nrem.sham(x_before.nrem.sham>0)=[];
std_before.nrem.sham(x_before.nrem.sham>0)=[];
x_before.nrem.sham(x_before.nrem.sham>0)=[];

d_after.nrem.tones(x_after.nrem.tones<0)=[];
std_after.nrem.tones(x_after.nrem.tones<0)=[];
x_after.nrem.tones(x_after.nrem.tones<0)=[];
d_after.nrem.sham(x_after.nrem.sham<0)=[];
std_after.nrem.sham(x_after.nrem.sham<0)=[];
x_after.nrem.sham(x_after.nrem.sham<0)=[];


%% pool data

select_order = 'after'; %{'before','after'}

MatMUA.nrem.tones  = []; MatMUA.nrem.sham   = [];
ibefore.nrem.tones = []; ibefore.nrem.sham  = [];

%tones
for p=1:length(tones_res.path)
    
    %NREM
    raster_tsd = tonesras_res.nrem.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.tones = [MatMUA.nrem.tones ; Data(raster_tsd)'];
    
    ibefore.nrem.tones = [ibefore.nrem.tones ; tonesras_res.nrem.(select_order){p}];
end

%sham
for p=1:length(sham_res.path)
    
    %NREM
    raster_tsd = shamras_res.nrem.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.sham = [MatMUA.nrem.sham ; Data(raster_tsd)'];
    
    ibefore.nrem.sham = [ibefore.nrem.sham ; shamras_res.nrem.(select_order){p}];
end

%sort raster in NREM
[~,idx_order] = sort(ibefore.nrem.tones);
MatMUA.nrem.tones  = MatMUA.nrem.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.nrem.sham);
MatMUA.nrem.sham  = MatMUA.nrem.sham(idx_order, :);


%% MUA response
y_mua_tones.mean = mean(MatMUA.nrem.tones,1);
y_mua_tones.mean = Smooth(y_mua_tones.mean ,1);
y_mua_tones.mean = y_mua_tones.mean / mean(y_mua_tones.mean(x_mua<-0.5e4));

y_mua_sham.mean = mean(MatMUA.nrem.sham,1);
y_mua_sham.mean = Smooth(y_mua_sham.mean ,1);
y_mua_sham.mean = y_mua_sham.mean / mean(y_mua_sham.mean(x_mua<-0.5e4));


%% PLOT
gap = [0.1 0.08];
fontsize = 20;
paired = 1;
optiontest = 'ranksum';
x_impact = 31;
smoothing = 0;
color_tones = [0 0 1];
color_sham  = [0.3 0.3 0.3];
colors_tones = {[0 0 1],[0.53 0.81 0.98]}; 
colors_sham = {[0.3 0.3 0.3],[0.7 0.7 0.7]};


figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

%TONES - raster plot
subtightplot(6,4,[1 5],gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.nrem.tones,1), MatMUA.nrem.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([x_impact x_impact], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.tones,1)], 'XLim',[-400 400],'Fontsize',14);
xlabel('temps depuis stim (ms)'), ylabel('#stim'),
caxis([0 3]),
title('Stim')


%SHAM - raster plot
subtightplot(6,4,[9 13],gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.nrem.sham,1), MatMUA.nrem.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([x_impact x_impact], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.sham,1)], 'XLim',[-400 400],'Fontsize',14);
xlabel('temps depuis sham (ms)'), ylabel('#sham'),
caxis([0 3]),
title('Sham')

% MUA
clear h
subtightplot(6,4,[2 6 10 14],gap), hold on
h(2) = plot(x_mua/10, y_mua_sham.mean, 'color', color_sham, 'linewidth', 2);
h(1) = plot(x_mua/10, y_mua_tones.mean, 'color', color_tones, 'linewidth', 2);
set(gca,'YLim', [0 2],'XLim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([x_impact x_impact], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
lgd = legend(h, 'stim', 'sham'); lgd.Location='northwest';
xlabel('temps (ms)'),
ylabel('Taux de décharge normalisé'),



%Distrib of start and end of Up states
clear h
subtightplot(6,4,[3 7],gap), hold on

h(2) = plot(x_before.nrem.sham, Smooth(d_before.nrem.sham, 0), 'color', color_sham, 'linewidth',1);
hh(2) = plot(x_after.nrem.sham, Smooth(d_after.nrem.sham, 0), 'color', color_sham, 'linewidth',2);
h(1) = plot(x_before.nrem.tones, Smooth(d_before.nrem.tones, 0), 'color', color_tones, 'linewidth',1);
hh(1) = plot(x_after.nrem.tones, Smooth(d_after.nrem.tones, 0), 'color', color_tones, 'linewidth',2);

set(gca,'XLim',[-400 400],'ylim', [0 0.07], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('temps (ms)'),
ylabel({'Probabilité', 'de transition'}),


%Transition probability
subtightplot(6,4,[11 15],gap), hold on
XL = [0.9 2.1];
Xbar = [1.2 1.8];

notBoxPlot(proba.nrem.tones,Xbar(1), 'patchColors', colors_tones),
notBoxPlot(proba.nrem.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.nrem.tones)
    line(Xbar, [proba.nrem.tones(l) proba.nrem.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.75 0.75], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.77, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ytick',0:0.25:1, 'ylim',[0 0.87],'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'stim','sham'},'xlim', XL),
ylabel({'Taux de transitions', 'Up>Down'}),


%Distrib occurence norm
clear h
subtightplot(6,4,[4 8 12 16],gap), hold on

errorbar(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), Smooth(std_norm.nrem.sham, smoothing), 'color', color_sham,'CapSize',1)
errorbar(x_norm.nrem.tones, Smooth(d_norm.nrem.tones, smoothing), Smooth(std_norm.nrem.tones, smoothing), 'color', color_tones,'CapSize',1)
h(2) = plot(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), 'color', color_sham', 'linewidth',2);
h(1) = plot(x_norm.nrem.tones, Smooth(d_norm.nrem.tones, smoothing), 'color', color_tones, 'linewidth',2);


xlabel('temps normalisé'), ylabel('Probabilité d''occurence dans le Up'),
set(gca, 'ytick',0:0.02:0.08, 'ylim', [0.02 0.08], 'Fontsize',fontsize),
lgd = legend(h, 'Stim', 'Sham'); lgd.Location='northwest';


