%%FigRipplesInDownNREM_fr
% 18.09.2019 KJ
%
% effect of ripples in Down states
% in N2 and N3
%
%   see 
%       FigRipplesInDownN2N3 FigRipplesInUpNREM
%
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesInDownN2N3Effect.mat'))

load(fullfile(FolderDeltaDataKJ,'RipplesInDownN2N3Raster.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
smoothing = 1;

animals = unique(ripples_res.name);



%% transitions probability

proba.nrem.ripples = [];
proba.nrem.sham = [];
for m=1:length(animals)
    
    probnrem_rip = []; probnrem_sham = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            probnrem_rip = [probnrem_rip ripples_res.nrem.transit_rate.ripples{p}];
            probnrem_sham = [probnrem_sham ripples_res.nrem.transit_rate.sham{p}];
        end
    end
    %NREM
    proba.nrem.ripples = [proba.nrem.ripples mean(probnrem_rip)];
    proba.nrem.sham    = [proba.nrem.sham mean(probnrem_sham)];
end


%% distrib

for p=1:length(ripples_res.path)    
    %ripples
    y_data = ripples_res.nrem.ripples_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.ripples{p}, nrem.x_before.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.ripples{p} = nrem.x_before.ripples{p}(1:end-1) + diff(nrem.x_before.ripples{p});
    
    y_data = ripples_res.nrem.ripples_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.ripples{p}, nrem.x_after.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.ripples{p} = nrem.x_after.ripples{p}(1:end-1) + diff(nrem.x_after.ripples{p});
    
    norm_ripples = ripples_res.nrem.ripples_bef{p} ./ (ripples_res.nrem.ripples_bef{p} + ripples_res.nrem.ripples_aft{p});
    [nrem.d_norm.ripples{p}, nrem.x_norm.ripples{p}] = histcounts(norm_ripples, edges_norm, 'Normalization','probability');
    nrem.x_norm.ripples{p} = nrem.x_norm.ripples{p}(1:end-1) + diff(nrem.x_norm.ripples{p});
    
    
    %sham
    y_data = ripples_res.nrem.sham_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.sham{p}, nrem.x_before.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.sham{p} = nrem.x_before.sham{p}(1:end-1) + diff(nrem.x_before.sham{p});
    
    y_data = ripples_res.nrem.sham_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.sham{p}, nrem.x_after.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.sham{p} = nrem.x_after.sham{p}(1:end-1) + diff(nrem.x_after.sham{p});
    
    norm_sham = ripples_res.nrem.sham_bef{p} ./ (ripples_res.nrem.sham_bef{p} + ripples_res.nrem.sham_aft{p});
    [nrem.d_norm.sham{p}, nrem.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    nrem.x_norm.sham{p} = nrem.x_norm.sham{p}(1:end-1) + diff(nrem.x_norm.sham{p});
end


%% average distributions

%NREM
d_before.nrem.ripples     = [];
d_after.nrem.ripples      = [];
d_norm.nrem.ripples       = [];

x_before.nrem.ripples     = nrem.x_before.ripples{1};
x_after.nrem.ripples      = nrem.x_after.ripples{1};
x_norm.nrem.ripples       = nrem.x_norm.ripples{1};

d_before.nrem.sham      = [];
d_after.nrem.sham       = [];
d_norm.nrem.sham        = [];

x_before.nrem.sham   = nrem.x_before.sham{1};
x_after.nrem.sham    = nrem.x_after.sham{1};
x_norm.nrem.sham     = nrem.x_norm.sham{1};


%ripples
for m=1:length(animals)
    nrem_before_mouse = [];
    nrem_after_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.ripples{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.ripples{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.ripples{p}];
        end
    end
    d_before.nrem.ripples  = [d_before.nrem.ripples ; mean(nrem_before_mouse,1)];
    d_after.nrem.ripples   = [d_after.nrem.ripples ; mean(nrem_after_mouse,1)];
    d_norm.nrem.ripples    = [d_norm.nrem.ripples ; Smooth(mean(nrem_norm_mouse,1),smoothing)'];
end

%sham
for m=1:length(animals)
    nrem_before_mouse = [];
    nrem_after_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.sham{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.sham{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.sham{p}];
        end
    end
    
    d_before.nrem.sham  = [d_before.nrem.sham ; mean(nrem_before_mouse,1)];
    d_after.nrem.sham   = [d_after.nrem.sham ; mean(nrem_after_mouse,1)];
    d_norm.nrem.sham    = [d_norm.nrem.sham ; Smooth(mean(nrem_norm_mouse,1),smoothing)'];
end


%mean and std 
std_before.nrem.ripples   = std(d_before.nrem.ripples,1) / sqrt(size(d_before.nrem.ripples,1));
std_after.nrem.ripples    = std(d_after.nrem.ripples,1) / sqrt(size(d_after.nrem.ripples,1));
std_norm.nrem.ripples     = std(d_norm.nrem.ripples,1) / sqrt(size(d_norm.nrem.ripples,1));
d_before.nrem.ripples     = mean(d_before.nrem.ripples,1);
d_after.nrem.ripples      = mean(d_after.nrem.ripples,1);
d_norm.nrem.ripples       = mean(d_norm.nrem.ripples,1);

std_before.nrem.sham   = std(d_before.nrem.sham,1) / sqrt(size(d_before.nrem.sham,1));
std_after.nrem.sham    = std(d_after.nrem.sham,1) / sqrt(size(d_after.nrem.sham,1));
std_norm.nrem.sham     = std(d_norm.nrem.sham,1) / sqrt(size(d_norm.nrem.sham,1));
d_before.nrem.sham     = mean(d_before.nrem.sham,1);
d_after.nrem.sham      = mean(d_after.nrem.sham,1);
d_norm.nrem.sham       = mean(d_norm.nrem.sham,1);

%distrib
d_before.nrem.ripples(x_before.nrem.ripples>0)=[];
std_before.nrem.ripples(x_before.nrem.ripples>0)=[];
x_before.nrem.ripples(x_before.nrem.ripples>0)=[];
d_before.nrem.sham(x_before.nrem.sham>0)=[];
std_before.nrem.sham(x_before.nrem.sham>0)=[];
x_before.nrem.sham(x_before.nrem.sham>0)=[];

d_after.nrem.ripples(x_after.nrem.ripples<0)=[];
std_after.nrem.ripples(x_after.nrem.ripples<0)=[];
x_after.nrem.ripples(x_after.nrem.ripples<0)=[];
d_after.nrem.sham(x_after.nrem.sham<0)=[];
std_after.nrem.sham(x_after.nrem.sham<0)=[];
x_after.nrem.sham(x_after.nrem.sham<0)=[];


%% pool data

order_ripples = 'ripples_bef'; %{'ripples_bef','ripples_aft'}
order_sham = 'sham_bef'; %{'sham_bef','sham_aft'}

MatMUA.nrem.ripples  = []; MatMUA.nrem.sham   = [];
ibefore.nrem.ripples = []; ibefore.nrem.sham  = [];


for p=1:length(ripples_res.path)
    
    %ripples
    raster_tsd = ripraster_res.nrem.rasters.ripples{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.ripples = [MatMUA.nrem.ripples ; Data(raster_tsd)'];
    
    ibefore.nrem.ripples = [ibefore.nrem.ripples ; ripraster_res.nrem.(order_ripples){p}];
    
    
    %sham
    raster_tsd = ripraster_res.nrem.rasters.sham{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.sham = [MatMUA.nrem.sham ; Data(raster_tsd)'];
    
    ibefore.nrem.sham = [ibefore.nrem.sham ; ripraster_res.nrem.(order_sham){p}];
end


%sort raster
[~,idx_order] = sort(ibefore.nrem.ripples);
MatMUA.nrem.ripples  = MatMUA.nrem.ripples(idx_order, :);
        
[~,idx_order] = sort(ibefore.nrem.sham);
MatMUA.nrem.sham  = MatMUA.nrem.sham(idx_order, :);


%% MUA response
y_mua_ripples.nrem = mean(MatMUA.nrem.ripples,1);
y_mua_ripples.nrem = Smooth(y_mua_ripples.nrem ,1);
y_mua_ripples.nrem = y_mua_ripples.nrem / mean(y_mua_ripples.nrem(x_mua<-0.5e4));

y_mua_sham.nrem = mean(MatMUA.nrem.sham,1);
y_mua_sham.nrem = Smooth(y_mua_sham.nrem ,1);
y_mua_sham.nrem = y_mua_sham.nrem / mean(y_mua_sham.nrem(x_mua<-0.5e4));


%% PLOT
gap = [0.1 0.07];
fontsize = 20;
paired = 1;
optiontest = 'ranksum';
smoothing = 0;

color_rip = [0 0.6 0];
color_rdm = 'r';


figure, hold on
%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


% %Ripples - raster plot
% subtightplot(6,4,[1 5],gap), hold on
% imagesc(x_mua/10, 1:size(MatMUA.nrem.ripples,1), MatMUA.nrem.ripples), hold on
% axis xy, hold on
% line([0 0], ylim,'linewidth',2,'color','w'), hold on
% set(gca,'YLim', [0 size(MatMUA.nrem.ripples,1)], 'XLim',[-400 400],'Fontsize',14);
% xlabel('time relative to ripples (ms)'), ylabel('#ripples'),
% title('Ripples')
% caxis([0 3]),
% 
% 
% %SHAM - raster plot
% subtightplot(6,4,[9 13],gap), hold on
% imagesc(x_mua/10, 1:size(MatMUA.nrem.sham,1), MatMUA.nrem.sham), hold on
% axis xy, hold on
% line([0 0], ylim,'linewidth',2,'color','w'), hold on
% set(gca,'YLim', [0 size(MatMUA.nrem.sham,1)], 'ytick',0:5e4:20e4, 'XLim',[-400 400],'Fontsize',14);
% xlabel('time relative to random (ms)'), ylabel('#random'),
% title('Random')
% caxis([0 3]),

% MUA
clear h
subtightplot(6,4,[2 6 10 14],gap), hold on
h(1) = plot(x_mua/10, y_mua_ripples.nrem, 'color', color_rip, 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.nrem, 'color', color_rdm, 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
xlabel('temps (ms)'),
ylabel('Taux de décharge normalisé'),


%Distrib of start and end of Up states
clear h
subtightplot(6,4,[3 7],gap), hold on

h(1) = plot(x_before.nrem.ripples, Smooth(d_before.nrem.ripples, 0), 'color', color_rip, 'linewidth',1);
hh(1) = plot(x_after.nrem.ripples, Smooth(d_after.nrem.ripples, 0), 'color', color_rip, 'linewidth',2);
h(2) = plot(x_before.nrem.sham, Smooth(d_before.nrem.sham, 0), 'color', color_rdm, 'linewidth',1);
hh(2) = plot(x_after.nrem.sham, Smooth(d_after.nrem.sham, 0), 'color', color_rdm, 'linewidth',2);

set(gca,'xlim',[-400 400],'ylim', [0 0.09], 'ytick',0:0.02:0.1, 'Fontsize',fontsize), 
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('temps (ms)'),
ylabel({'Probabilité', 'de transition'}),


%Transition probability
subtightplot(6,4,[11 15],gap), hold on

XL = [0.6 2.4];
Xbar = [1.2 1.8];
colors_rip = {[0 0.5 0],[1 1 0.8]};
colors_rdm = {[1 0 0],[1 0.5 0.5]};

notBoxPlot(proba.nrem.ripples,Xbar(1), 'patchColors', colors_rip),
notBoxPlot(proba.nrem.sham,Xbar(2), 'patchColors', colors_rdm),
for l=1:length(proba.nrem.ripples)
    line(Xbar, [proba.nrem.ripples(l) proba.nrem.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.72 0.72], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.75, '**', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',[0 0.9],'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'ripples','random'},'xlim', XL),
ylabel({'Taux de transitions', 'Down>Up'}),


%Distrib occurence norm
clear h
subtightplot(6,4,[4 8 12 16],gap), hold on
errorbar(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), Smooth(std_norm.nrem.sham, smoothing), 'color', color_rdm,'CapSize',1)
errorbar(x_norm.nrem.ripples, Smooth(d_norm.nrem.ripples, smoothing), Smooth(std_norm.nrem.ripples, smoothing), 'color', color_rip,'CapSize',1)
h(1) = plot(x_norm.nrem.ripples, Smooth(d_norm.nrem.ripples, smoothing), 'color', color_rip, 'linewidth',2);
h(2) = plot(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), 'color', color_rdm', 'linewidth',2);

xlabel('temps normalisé'), ylabel('Probabilité d''occurence dans le Down'),
set(gca, 'xtick',0:0.5:1 , 'ytick',0:0.02:0.08, 'ylim', [0.03 0.08], 'Fontsize',fontsize),
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';









