%%FigTonesInUpN2N3
% 18.09.2018 KJ
%
% effect of tones in down states
% in N2 and N3
%
%   see 
%       Fig1TonesInUp_midthesis FigTonesInDownN2N3
%       FigRipplesInUpN2N3
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

animals = unique(tones_res.name);


%% transitions probability

%tones
proba.n2.tones = [];
proba.n3.tones = [];
proba.nrem.tones = [];

for m=1:length(animals)
    
    probn2_mouse = [];
    probn3_mouse = [];
    probnrem_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probn2_mouse = [probn2_mouse tones_res.n2.transit_rate{p}];
            probn3_mouse = [probn3_mouse tones_res.n3.transit_rate{p}];
            probnrem_mouse = [probnrem_mouse tones_res.nrem.transit_rate{p}];
        end
    end
    
    %N2
    proba.n2.tones = [proba.n2.tones mean(probn2_mouse)];
    %N3
    proba.n3.tones = [proba.n3.tones mean(probn3_mouse)];
    %NREM
    proba.nrem.tones = [proba.nrem.tones mean(probnrem_mouse)];
end



%sham
proba.n2.sham = [];
proba.n3.sham = [];
proba.nrem.sham = [];
for m=1:length(animals)
    
    probn2_mouse = [];
    probn3_mouse = [];
    probnrem_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            probn2_mouse = [probn2_mouse sham_res.n2.transit_rate{p}];
            probn3_mouse = [probn3_mouse sham_res.n3.transit_rate{p}];
            probnrem_mouse = [probnrem_mouse sham_res.nrem.transit_rate{p}];
        end
    end
    
    %N2
    proba.n2.sham = [proba.n2.sham mean(probn2_mouse)];
    %N3
    proba.n3.sham = [proba.n3.sham mean(probn3_mouse)];
    %NREM
    proba.nrem.sham = [proba.nrem.sham mean(probnrem_mouse)];
end





%% distrib

%tones
for p=1:length(tones_res.path)
    
    %N2
    [n2.d_before.tones{p}, n2.x_before.tones{p}] = histcounts(-tones_res.n2.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    n2.x_before.tones{p} = n2.x_before.tones{p}(1:end-1) + diff(n2.x_before.tones{p});
    
    [n2.d_after.tones{p}, n2.x_after.tones{p}] = histcounts(tones_res.n2.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    n2.x_after.tones{p} = n2.x_after.tones{p}(1:end-1) + diff(n2.x_after.tones{p});
    
    norm_tones = tones_res.n2.tones_bef{p} ./ (tones_res.n2.tones_bef{p} + tones_res.n2.tones_aft{p});
    [n2.d_norm.tones{p}, n2.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    n2.x_norm.tones{p} = n2.x_norm.tones{p}(1:end-1) + diff(n2.x_norm.tones{p});

    %N3
    [n3.d_before.tones{p}, n3.x_before.tones{p}] = histcounts(-tones_res.n3.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    n3.x_before.tones{p} = n3.x_before.tones{p}(1:end-1) + diff(n3.x_before.tones{p});
    
    [n3.d_after.tones{p}, n3.x_after.tones{p}] = histcounts(tones_res.n3.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    n3.x_after.tones{p} = n3.x_after.tones{p}(1:end-1) + diff(n3.x_after.tones{p});
    
    norm_tones = tones_res.n3.tones_bef{p} ./ (tones_res.n3.tones_bef{p} + tones_res.n3.tones_aft{p});
    [n3.d_norm.tones{p}, n3.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    n3.x_norm.tones{p} = n3.x_norm.tones{p}(1:end-1) + diff(n3.x_norm.tones{p});
    
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
    
    %N2
    [n2.d_before.sham{p}, n2.x_before.sham{p}] = histcounts(-sham_res.n2.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    n2.x_before.sham{p} = n2.x_before.sham{p}(1:end-1) + diff(n2.x_before.sham{p});
    
    [n2.d_after.sham{p}, n2.x_after.sham{p}] = histcounts(sham_res.n2.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    n2.x_after.sham{p} = n2.x_after.sham{p}(1:end-1) + diff(n2.x_after.sham{p});
    
    norm_sham = sham_res.n2.sham_bef{p} ./ (sham_res.n2.sham_bef{p} + sham_res.n2.sham_aft{p});
    [n2.d_norm.sham{p}, n2.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    n2.x_norm.sham{p} = n2.x_norm.sham{p}(1:end-1) + diff(n2.x_norm.sham{p});
    
    %N3
    [n3.d_before.sham{p}, n3.x_before.sham{p}] = histcounts(-sham_res.n3.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    n3.x_before.sham{p} = n3.x_before.sham{p}(1:end-1) + diff(n3.x_before.sham{p});
    
    [n3.d_after.sham{p}, n3.x_after.sham{p}] = histcounts(sham_res.n3.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    n3.x_after.sham{p} = n3.x_after.sham{p}(1:end-1) + diff(n3.x_after.sham{p});
    
    norm_sham = sham_res.n3.sham_bef{p} ./ (sham_res.n3.sham_bef{p} + sham_res.n3.sham_aft{p});
    [n3.d_norm.sham{p}, n3.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    n3.x_norm.sham{p} = n3.x_norm.sham{p}(1:end-1) + diff(n3.x_norm.sham{p});
    
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

%N2
d_before.n2.tones     = [];
d_after.n2.tones      = [];
d_norm.n2.tones       = [];

x_before.n2.tones     = n2.x_before.tones{1};
x_after.n2.tones      = n2.x_after.tones{1};
x_norm.n2.tones       = n2.x_norm.tones{1};

d_before.n2.sham      = [];
d_after.n2.sham       = [];
d_norm.n2.sham        = [];

x_before.n2.sham   = n2.x_before.sham{1};
x_after.n2.sham    = n2.x_after.sham{1};
x_norm.n2.sham     = n2.x_norm.sham{1};

%N3
d_before.n3.tones     = [];
d_after.n3.tones      = [];
d_norm.n3.tones       = [];

x_before.n3.tones     = n3.x_before.tones{1};
x_after.n3.tones      = n3.x_after.tones{1};
x_norm.n3.tones       = n3.x_norm.tones{1};

d_before.n3.sham      = [];
d_after.n3.sham       = [];
d_norm.n3.sham        = [];

x_before.n3.sham   = n3.x_before.sham{1};
x_after.n3.sham    = n3.x_after.sham{1};
x_norm.n3.sham     = n3.x_norm.sham{1};

%NREM
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
    
    n2_before_mouse = [];
    n3_before_mouse = [];
    nrem_before_mouse = [];
    
    n2_after_mouse = [];
    n3_after_mouse = [];
    nrem_after_mouse = [];
    
    n2_norm_mouse = [];
    n3_norm_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            n2_before_mouse = [n2_before_mouse ; n2.d_before.tones{p}];
            n3_before_mouse = [n3_before_mouse ; n3.d_before.tones{p}];
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.tones{p}];

            n2_after_mouse = [n2_after_mouse ; n2.d_after.tones{p}];
            n3_after_mouse = [n3_after_mouse ; n3.d_after.tones{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.tones{p}];

            n2_norm_mouse = [n2_norm_mouse ; n2.d_norm.tones{p}];
            n3_norm_mouse = [n3_norm_mouse ; n3.d_norm.tones{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.tones{p}];
        end
    end
    
    d_before.n2.tones    = [d_before.n2.tones ; mean(n2_before_mouse,1)];
    d_before.n3.tones    = [d_before.n3.tones ; mean(n3_before_mouse,1)];
    d_before.nrem.tones  = [d_before.nrem.tones ; mean(nrem_before_mouse,1)];
    
    d_after.n2.tones     = [d_after.n2.tones ; mean(n2_after_mouse,1)];
    d_after.n3.tones     = [d_after.n3.tones ; mean(n3_after_mouse,1)];
    d_after.nrem.tones   = [d_after.nrem.tones ; mean(nrem_after_mouse,1)];
    
    d_norm.n2.tones      = [d_norm.n2.tones ; mean(n2_norm_mouse,1)];
    d_norm.n3.tones      = [d_norm.n3.tones ; mean(n3_norm_mouse,1)];
    d_norm.nrem.tones    = [d_norm.nrem.tones ; mean(nrem_norm_mouse,1)];
end


%sham
for m=1:length(animals)
    
    n2_before_mouse = [];
    n3_before_mouse = [];
    nrem_before_mouse = [];
    
    n2_after_mouse = [];
    n3_after_mouse = [];
    nrem_after_mouse = [];
    
    n2_norm_mouse = [];
    n3_norm_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            n2_before_mouse = [n2_before_mouse ; n2.d_before.sham{p}];
            n3_before_mouse = [n3_before_mouse ; n3.d_before.sham{p}];
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.sham{p}];

            n2_after_mouse = [n2_after_mouse ; n2.d_after.sham{p}];
            n3_after_mouse = [n3_after_mouse ; n3.d_after.sham{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.sham{p}];

            n2_norm_mouse = [n2_norm_mouse ; n2.d_norm.sham{p}];
            n3_norm_mouse = [n3_norm_mouse ; n3.d_norm.sham{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.sham{p}];
        end
    end

    d_before.n2.sham    = [d_before.n2.sham ; mean(n2_before_mouse,1)];
    d_before.n3.sham    = [d_before.n3.sham ; mean(n3_before_mouse,1)];
    d_before.nrem.sham  = [d_before.nrem.sham ; mean(nrem_before_mouse,1)];
    
    d_after.n2.sham     = [d_after.n2.sham ; mean(n2_after_mouse,1)];
    d_after.n3.sham     = [d_after.n3.sham ; mean(n3_after_mouse,1)];
    d_after.nrem.sham   = [d_after.nrem.sham ; mean(nrem_after_mouse,1)];
    
    d_norm.n2.sham      = [d_norm.n2.sham ; mean(n2_norm_mouse,1)];
    d_norm.n3.sham      = [d_norm.n3.sham ; mean(n3_norm_mouse,1)];
    d_norm.nrem.sham    = [d_norm.nrem.sham ; mean(nrem_norm_mouse,1)];
end


%mean N2
std_before.n2.tones   = std(d_before.n2.tones,1) / sqrt(size(d_before.n2.tones,1));
std_after.n2.tones    = std(d_after.n2.tones,1) / sqrt(size(d_after.n2.tones,1));
std_norm.n2.tones     = std(d_norm.n2.tones,1) / sqrt(size(d_norm.n2.tones,1));
d_before.n2.tones     = mean(d_before.n2.tones,1);
d_after.n2.tones      = mean(d_after.n2.tones,1);
d_norm.n2.tones       = mean(d_norm.n2.tones,1);

std_before.n2.sham   = std(d_before.n2.sham,1) / sqrt(size(d_before.n2.sham,1));
std_after.n2.sham    = std(d_after.n2.sham,1) / sqrt(size(d_after.n2.sham,1));
std_norm.n2.sham     = std(d_norm.n2.sham,1) / sqrt(size(d_norm.n2.sham,1));
d_before.n2.sham     = mean(d_before.n2.sham,1);
d_after.n2.sham      = mean(d_after.n2.sham,1);
d_norm.n2.sham       = mean(d_norm.n2.sham,1);

%mean N3
std_before.n3.tones   = std(d_before.n3.tones,1) / sqrt(size(d_before.n3.tones,1));
std_after.n3.tones    = std(d_after.n3.tones,1) / sqrt(size(d_after.n3.tones,1));
std_norm.n3.tones     = std(d_norm.n3.tones,1) / sqrt(size(d_norm.n3.tones,1));
d_before.n3.tones     = mean(d_before.n3.tones,1);
d_after.n3.tones      = mean(d_after.n3.tones,1);
d_norm.n3.tones       = mean(d_norm.n3.tones,1);

std_before.n3.sham   = std(d_before.n3.sham,1) / sqrt(size(d_before.n3.sham,1));
std_after.n3.sham    = std(d_after.n3.sham,1) / sqrt(size(d_after.n3.sham,1));
std_norm.n3.sham     = std(d_norm.n3.sham,1) / sqrt(size(d_norm.n3.sham,1));
d_before.n3.sham     = mean(d_before.n3.sham,1);
d_after.n3.sham      = mean(d_after.n3.sham,1);
d_norm.n3.sham       = mean(d_norm.n3.sham,1);

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



%distrib N2
d_before.n2.tones(x_before.n2.tones>0)=[];
std_before.n2.tones(x_before.n2.tones>0)=[];
x_before.n2.tones(x_before.n2.tones>0)=[];
d_before.n2.sham(x_before.n2.sham>0)=[];
std_before.n2.sham(x_before.n2.sham>0)=[];
x_before.n2.sham(x_before.n2.sham>0)=[];

d_after.n2.tones(x_after.n2.tones<0)=[];
std_after.n2.tones(x_after.n2.tones<0)=[];
x_after.n2.tones(x_after.n2.tones<0)=[];
d_after.n2.sham(x_after.n2.sham<0)=[];
std_after.n2.sham(x_after.n2.sham<0)=[];
x_after.n2.sham(x_after.n2.sham<0)=[];

%distrib N3
d_before.n3.tones(x_before.n3.tones>0)=[];
std_before.n3.tones(x_before.n3.tones>0)=[];
x_before.n3.tones(x_before.n3.tones>0)=[];
d_before.n3.sham(x_before.n3.sham>0)=[];
std_before.n3.sham(x_before.n3.sham>0)=[];
x_before.n3.sham(x_before.n3.sham>0)=[];

d_after.n3.tones(x_after.n3.tones<0)=[];
std_after.n3.tones(x_after.n3.tones<0)=[];
x_after.n3.tones(x_after.n3.tones<0)=[];
d_after.n3.sham(x_after.n3.sham<0)=[];
std_after.n3.sham(x_after.n3.sham<0)=[];
x_after.n3.sham(x_after.n3.sham<0)=[];

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

MatMUA.n2.tones  = []; MatMUA.n2.sham   = [];
ibefore.n2.tones = []; ibefore.n2.sham  = [];
MatMUA.n3.tones  = []; MatMUA.n3.sham   = [];
ibefore.n3.tones = []; ibefore.n3.sham  = [];
MatMUA.nrem.tones  = []; MatMUA.nrem.sham   = [];
ibefore.nrem.tones = []; ibefore.nrem.sham  = [];


%tones
for p=1:length(tones_res.path)
    
    %N2
    raster_tsd = tonesras_res.n2.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.n2.tones = [MatMUA.n2.tones ; Data(raster_tsd)'];
    
    ibefore.n2.tones = [ibefore.n2.tones ; tonesras_res.n2.(select_order){p}];
    
    %N3
    raster_tsd = tonesras_res.n3.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.n3.tones = [MatMUA.n3.tones ; Data(raster_tsd)'];
    
    ibefore.n3.tones = [ibefore.n3.tones ; tonesras_res.n3.(select_order){p}];
    
    %NREM
    raster_tsd = tonesras_res.nrem.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.tones = [MatMUA.nrem.tones ; Data(raster_tsd)'];
    
    ibefore.nrem.tones = [ibefore.nrem.tones ; tonesras_res.nrem.(select_order){p}];
end

%sham
for p=1:length(sham_res.path)
    
    %N2
    raster_tsd = shamras_res.n2.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.n2.sham = [MatMUA.n2.sham ; Data(raster_tsd)'];
    
    ibefore.n2.sham = [ibefore.n2.sham ; shamras_res.n2.(select_order){p}];
    
    %N3
    raster_tsd = shamras_res.n3.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.n3.sham = [MatMUA.n3.sham ; Data(raster_tsd)'];
    
    ibefore.n3.sham = [ibefore.n3.sham ; shamras_res.n3.(select_order){p}];
    
    %NREM
    raster_tsd = shamras_res.nrem.rasters{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.sham = [MatMUA.nrem.sham ; Data(raster_tsd)'];
    
    ibefore.nrem.sham = [ibefore.nrem.sham ; shamras_res.nrem.(select_order){p}];
end

%sort raster in N2
[~,idx_order] = sort(ibefore.n2.tones);
MatMUA.n2.tones  = MatMUA.n2.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.n2.sham);
MatMUA.n2.sham  = MatMUA.n2.sham(idx_order, :);

%sort raster in N3
[~,idx_order] = sort(ibefore.n3.tones);
MatMUA.n3.tones  = MatMUA.n3.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.n3.sham);
MatMUA.n3.sham  = MatMUA.n3.sham(idx_order, :);

%sort raster in NREM
[~,idx_order] = sort(ibefore.nrem.tones);
MatMUA.nrem.tones  = MatMUA.nrem.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.nrem.sham);
MatMUA.nrem.sham  = MatMUA.nrem.sham(idx_order, :);


%% MUA response

%mean response in N2
y_mua_tones.n2 = mean(MatMUA.n2.tones,1);
y_mua_tones.n2 = Smooth(y_mua_tones.n2 ,1);
y_mua_tones.n2 = y_mua_tones.n2 / mean(y_mua_tones.n2(x_mua<-0.5e4));

y_mua_sham.n2 = mean(MatMUA.n2.sham,1);
y_mua_sham.n2 = Smooth(y_mua_sham.n2 ,1);
y_mua_sham.n2 = y_mua_sham.n2 / mean(y_mua_sham.n2(x_mua<-0.5e4));

%mean response in N3
y_mua_tones.n3 = mean(MatMUA.n3.tones,1);
y_mua_tones.n3 = Smooth(y_mua_tones.n3 ,1);
y_mua_tones.n3 = y_mua_tones.n3 / mean(y_mua_tones.n3(x_mua<-0.5e4));

y_mua_sham.n3 = mean(MatMUA.n3.sham,1);
y_mua_sham.n3 = Smooth(y_mua_sham.n3 ,1);
y_mua_sham.n3 = y_mua_sham.n3 / mean(y_mua_sham.n3(x_mua<-0.5e4));


%mean response in NREM
y_mua_tones.nrem = mean(MatMUA.nrem.tones,1);
y_mua_tones.nrem = Smooth(y_mua_tones.nrem ,1);
y_mua_tones.nrem = y_mua_tones.nrem / mean(y_mua_tones.nrem(x_mua<-0.5e4));

y_mua_sham.nrem = mean(MatMUA.nrem.sham,1);
y_mua_sham.nrem = Smooth(y_mua_sham.nrem ,1);
y_mua_sham.nrem = y_mua_sham.nrem / mean(y_mua_sham.nrem(x_mua<-0.5e4));


%% PLOT
gap = [0.1 0.04];
smoothing = 1;
fontsize = 13;
paired = 1;
optiontest = 'ranksum';


%%%%%%%%%%
%N2
%%%%%%%%%%
figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

%TONES - raster plot
subtightplot(4,4,1,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n2.tones,1), MatMUA.n2.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n2.tones,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside up states - N2')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n2.sham,1), MatMUA.n2.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n2.sham,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Sham inside up states - N2')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_tones.n2, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.n2, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'XLim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
xlabel('time from tones (s)'),
title('Mean MUA on tones/sham - N2'),


%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.n2.tones proba.n2.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('probability of transition Up>Down'),


%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.n2.tones, Smooth(d_before.n2.tones, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.n2.tones, Smooth(d_after.n2.tones, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.n2.sham, Smooth(d_before.n2.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.n2.sham, Smooth(d_after.n2.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
% lgd2 = legend(hh, 'tones', 'sham'); lgd2.Location='northeast';
xlabel('time from tones (ms)'),
title('occurence of start/end of up - N2'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.n2.tones, Smooth(d_norm.n2.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.n2.sham, Smooth(d_norm.n2.sham, smoothing), 'color', 'r', 'linewidth',2); 
hs(1) = shadedErrorBar(x_norm.n2.tones, Smooth(d_norm.n2.tones, smoothing), Smooth(std_norm.n2.tones, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.n2.sham, Smooth(d_norm.n2.sham, smoothing), Smooth(std_norm.n2.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
title({'Occurence of tones/sham' , 'in Up state (normalized) - N2'}),



%%%%%%%%%%
%N3
%%%%%%%%%%
figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

%TONES - raster plot
subtightplot(4,4,1,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n3.tones,1), MatMUA.n3.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n3.tones,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside up states - N3')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n3.sham,1), MatMUA.n3.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n3.sham,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Sham inside up states - N3')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_tones.n3, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.n3, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'XLim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
xlabel('time from tones (s)'),
title('Mean MUA on tones/sham - N3'),

%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.n3.tones proba.n3.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('probability of transition Up>Down'),

%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.n3.tones, Smooth(d_before.n3.tones, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.n3.tones, Smooth(d_after.n3.tones, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.n3.sham, Smooth(d_before.n3.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.n3.sham, Smooth(d_after.n3.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from tones (ms)'),
title('occurence of start/end of up - N3'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.n3.tones, Smooth(d_norm.n3.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.n3.sham, Smooth(d_norm.n3.sham, smoothing), 'color', 'r', 'linewidth',2);
hs(1) = shadedErrorBar(x_norm.n3.tones, Smooth(d_norm.n3.tones, smoothing), Smooth(std_norm.n3.tones, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.n3.sham, Smooth(d_norm.n3.sham, smoothing), Smooth(std_norm.n3.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
title({'Occurence of tones/sham', 'in Up state (normalized) - N3'}),


%%%%%%%%%%
%NREM
%%%%%%%%%%
figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

%TONES - raster plot
subtightplot(4,4,1,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.nrem.tones,1), MatMUA.nrem.tones), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.tones,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside up states - NREM')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.nrem.sham,1), MatMUA.nrem.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.sham,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to sham (ms)'), ylabel('#sham'),
title('Sham inside up states - NREM')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_tones.nrem, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.nrem, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'XLim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
xlabel('time from tones (s)'),
title('Mean MUA on tones/sham - NREM'),

%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.nrem.tones proba.nrem.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('probability of transition Up>Down'),

%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.nrem.tones, Smooth(d_before.nrem.tones, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.nrem.tones, Smooth(d_after.nrem.tones, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.nrem.sham, Smooth(d_before.nrem.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.nrem.sham, Smooth(d_after.nrem.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from tones (ms)'),
title('occurence of start/end of up - NREM'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.nrem.tones, Smooth(d_norm.nrem.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), 'color', 'r', 'linewidth',2);
hs(1) = shadedErrorBar(x_norm.nrem.tones, Smooth(d_norm.nrem.tones, smoothing), Smooth(std_norm.nrem.tones, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), Smooth(std_norm.nrem.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
% lgd = legend(h, 'tones', 'sham'); lgd.Location='northwest';
title({'Occurence of tones/sham', 'in Up state (normalized) - NREM'}),



%% PLOT Bar Transition probability

figure, hold on 
fontsize = 20;

%NREM
subtightplot(2,3,1,gap), hold on
PlotErrorBarN_KJ({proba.nrem.tones proba.nrem.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 1],'ytick',0:0.2:1,'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('Tones in NREM')

%N2
subtightplot(2,3,2,gap), hold on
PlotErrorBarN_KJ({proba.n2.tones proba.n2.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 1],'ytick',0:0.2:1,'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('Tones in N2')

%N3
subtightplot(2,3,3,gap), hold on
PlotErrorBarN_KJ({proba.n3.tones proba.n3.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 1],'ytick',0:0.2:1, 'xtick',1:2,'XtickLabel',{'tones','sham'},'Fontsize',fontsize),
title('Tones in N3')





