%%FigRipplesInUpN2N3
% 18.09.2018 KJ
%
% effect of ripples in Up states
% in N2 and N3
%
%   see 
%       FigRipplesInDownN2N3 FigTonesInUpN2N3
%
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesInUpN2N3Effect.mat'))

load(fullfile(FolderDeltaDataKJ,'RipplesInUpN2N3Raster.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;


animals = unique(ripples_res.name);


%% transitions probability

proba.n2.ripples = [];
proba.n3.ripples = [];
proba.nrem.ripples = [];
proba.n2.sham = [];
proba.n3.sham = [];
proba.nrem.sham = [];
for m=1:length(animals)
    
    probn2_rip = []; probn2_sham = [];
    probn3_rip = []; probn3_sham = [];
    probnrem_rip = []; probnrem_sham = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            probn2_rip = [probn2_rip ripples_res.n2.transit_rate.ripples{p}];
            probn3_rip = [probn3_rip ripples_res.n3.transit_rate.ripples{p}];
            probnrem_rip = [probnrem_rip ripples_res.nrem.transit_rate.ripples{p}];
            
            probn2_sham = [probn2_sham ripples_res.n2.transit_rate.sham{p}];
            probn3_sham = [probn3_sham ripples_res.n3.transit_rate.sham{p}];
            probnrem_sham = [probnrem_sham ripples_res.nrem.transit_rate.sham{p}];
        end
    end
    
    %N2
    proba.n2.ripples = [proba.n2.ripples mean(probn2_rip)];
    proba.n2.sham    = [proba.n2.sham mean(probn2_sham)];
    %N3
    proba.n3.ripples = [proba.n3.ripples mean(probn3_rip)];
    proba.n3.sham    = [proba.n3.sham mean(probn3_sham)];
    %NREM
    proba.nrem.ripples = [proba.nrem.ripples mean(probnrem_rip)];
    proba.nrem.sham    = [proba.nrem.sham mean(probnrem_sham)];
end

% 
% proba.n2.ripples = [];
% proba.n3.ripples = [];
% proba.nrem.ripples = [];
% proba.n2.sham = [];
% proba.n3.sham = [];
% proba.nrem.sham = [];
% for p=1:length(ripples_res.path)
%     %N2
%     proba.n2.ripples = [proba.n2.ripples ripples_res.n2.transit_rate.ripples{p}];
%     proba.n2.sham = [proba.n2.sham ripples_res.n2.transit_rate.sham{p}];
%     %N3
%     proba.n3.ripples = [proba.n3.ripples ripples_res.n3.transit_rate.ripples{p}];
%     proba.n3.sham = [proba.n3.sham ripples_res.n3.transit_rate.sham{p}];
%     %NREM
%     proba.nrem.ripples = [proba.nrem.ripples ripples_res.nrem.transit_rate.ripples{p}];
%     proba.nrem.sham = [proba.nrem.sham ripples_res.nrem.transit_rate.sham{p}];
% end


%% distrib

for p=1:length(ripples_res.path)    
    %ripples
    %N2
    y_data = ripples_res.n2.ripples_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [n2.d_before.ripples{p}, n2.x_before.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n2.x_before.ripples{p} = n2.x_before.ripples{p}(1:end-1) + diff(n2.x_before.ripples{p})/2;
    
    y_data = ripples_res.n2.ripples_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [n2.d_after.ripples{p}, n2.x_after.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n2.x_after.ripples{p} = n2.x_after.ripples{p}(1:end-1) + diff(n2.x_after.ripples{p})/2;
    
    norm_ripples = ripples_res.n2.ripples_bef{p} ./ (ripples_res.n2.ripples_bef{p} + ripples_res.n2.ripples_aft{p});
    [n2.d_norm.ripples{p}, n2.x_norm.ripples{p}] = histcounts(norm_ripples, edges_norm, 'Normalization','probability');
    n2.x_norm.ripples{p} = n2.x_norm.ripples{p}(1:end-1) + diff(n2.x_norm.ripples{p})/2;

    %N3
    y_data = ripples_res.n3.ripples_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [n3.d_before.ripples{p}, n3.x_before.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n3.x_before.ripples{p} = n3.x_before.ripples{p}(1:end-1) + diff(n3.x_before.ripples{p})/2;
    
    y_data = ripples_res.n3.ripples_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [n3.d_after.ripples{p}, n3.x_after.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n3.x_after.ripples{p} = n3.x_after.ripples{p}(1:end-1) + diff(n3.x_after.ripples{p})/2;
    
    norm_ripples = ripples_res.n3.ripples_bef{p} ./ (ripples_res.n3.ripples_bef{p} + ripples_res.n3.ripples_aft{p});
    [n3.d_norm.ripples{p}, n3.x_norm.ripples{p}] = histcounts(norm_ripples, edges_norm, 'Normalization','probability');
    n3.x_norm.ripples{p} = n3.x_norm.ripples{p}(1:end-1) + diff(n3.x_norm.ripples{p})/2;
    
    %NREM
    y_data = ripples_res.nrem.ripples_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.ripples{p}, nrem.x_before.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.ripples{p} = nrem.x_before.ripples{p}(1:end-1) + diff(nrem.x_before.ripples{p})/2;
    
    y_data = ripples_res.nrem.ripples_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.ripples{p}, nrem.x_after.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.ripples{p} = nrem.x_after.ripples{p}(1:end-1) + diff(nrem.x_after.ripples{p})/2;
    
    norm_ripples = ripples_res.nrem.ripples_bef{p} ./ (ripples_res.nrem.ripples_bef{p} + ripples_res.nrem.ripples_aft{p});
    [nrem.d_norm.ripples{p}, nrem.x_norm.ripples{p}] = histcounts(norm_ripples, edges_norm, 'Normalization','probability');
    nrem.x_norm.ripples{p} = nrem.x_norm.ripples{p}(1:end-1) + diff(nrem.x_norm.ripples{p})/2;
    
    
    %sham
    %N2
    y_data = ripples_res.n2.sham_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [n2.d_before.sham{p}, n2.x_before.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n2.x_before.sham{p} = n2.x_before.sham{p}(1:end-1) + diff(n2.x_before.sham{p})/2;
    
    y_data = ripples_res.n2.sham_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [n2.d_after.sham{p}, n2.x_after.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n2.x_after.sham{p} = n2.x_after.sham{p}(1:end-1) + diff(n2.x_after.sham{p})/2;
    
    norm_sham = ripples_res.n2.sham_bef{p} ./ (ripples_res.n2.sham_bef{p} + ripples_res.n2.sham_aft{p});
    [n2.d_norm.sham{p}, n2.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    n2.x_norm.sham{p} = n2.x_norm.sham{p}(1:end-1) + diff(n2.x_norm.sham{p})/2;
    
    %N3
    y_data = ripples_res.n3.sham_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [n3.d_before.sham{p}, n3.x_before.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n3.x_before.sham{p} = n3.x_before.sham{p}(1:end-1) + diff(n3.x_before.sham{p})/2;
    
    y_data = ripples_res.n3.sham_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [n3.d_after.sham{p}, n3.x_after.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    n3.x_after.sham{p} = n3.x_after.sham{p}(1:end-1) + diff(n3.x_after.sham{p})/2;
    
    norm_sham = ripples_res.n3.sham_bef{p} ./ (ripples_res.n3.sham_bef{p} + ripples_res.n3.sham_aft{p});
    [n3.d_norm.sham{p}, n3.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    n3.x_norm.sham{p} = n3.x_norm.sham{p}(1:end-1) + diff(n3.x_norm.sham{p})/2;
    
    %NREM
    y_data = ripples_res.nrem.sham_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.sham{p}, nrem.x_before.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.sham{p} = nrem.x_before.sham{p}(1:end-1) + diff(nrem.x_before.sham{p})/2;
    
    y_data = ripples_res.nrem.sham_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.sham{p}, nrem.x_after.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.sham{p} = nrem.x_after.sham{p}(1:end-1) + diff(nrem.x_after.sham{p})/2;
    
    norm_sham = ripples_res.nrem.sham_bef{p} ./ (ripples_res.nrem.sham_bef{p} + ripples_res.nrem.sham_aft{p});
    [nrem.d_norm.sham{p}, nrem.x_norm.sham{p}] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
    nrem.x_norm.sham{p} = nrem.x_norm.sham{p}(1:end-1) + diff(nrem.x_norm.sham{p})/2;
end


%% average distributions

%N2
d_before.n2.ripples     = [];
d_after.n2.ripples      = [];
d_norm.n2.ripples       = [];

x_before.n2.ripples     = n2.x_before.ripples{1};
x_after.n2.ripples      = n2.x_after.ripples{1};
x_norm.n2.ripples       = n2.x_norm.ripples{1};

d_before.n2.sham      = [];
d_after.n2.sham       = [];
d_norm.n2.sham        = [];

x_before.n2.sham   = n2.x_before.sham{1};
x_after.n2.sham    = n2.x_after.sham{1};
x_norm.n2.sham     = n2.x_norm.sham{1};

%N3
d_before.n3.ripples     = [];
d_after.n3.ripples      = [];
d_norm.n3.ripples       = [];

x_before.n3.ripples     = n3.x_before.ripples{1};
x_after.n3.ripples      = n3.x_after.ripples{1};
x_norm.n3.ripples       = n3.x_norm.ripples{1};

d_before.n3.sham      = [];
d_after.n3.sham       = [];
d_norm.n3.sham        = [];

x_before.n3.sham   = n3.x_before.sham{1};
x_after.n3.sham    = n3.x_after.sham{1};
x_norm.n3.sham     = n3.x_norm.sham{1};

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
    
    n2_before_mouse = [];
    n3_before_mouse = [];
    nrem_before_mouse = [];
    
    n2_after_mouse = [];
    n3_after_mouse = [];
    nrem_after_mouse = [];
    
    n2_norm_mouse = [];
    n3_norm_mouse = [];
    nrem_norm_mouse = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            n2_before_mouse = [n2_before_mouse ; n2.d_before.ripples{p}];
            n3_before_mouse = [n3_before_mouse ; n3.d_before.ripples{p}];
            nrem_before_mouse = [nrem_before_mouse ; nrem.d_before.ripples{p}];

            n2_after_mouse = [n2_after_mouse ; n2.d_after.ripples{p}];
            n3_after_mouse = [n3_after_mouse ; n3.d_after.ripples{p}];
            nrem_after_mouse = [nrem_after_mouse ; nrem.d_after.ripples{p}];

            n2_norm_mouse = [n2_norm_mouse ; n2.d_norm.ripples{p}];
            n3_norm_mouse = [n3_norm_mouse ; n3.d_norm.ripples{p}];
            nrem_norm_mouse = [nrem_norm_mouse ; nrem.d_norm.ripples{p}];
        end
    end
    
    d_before.n2.ripples    = [d_before.n2.ripples ; mean(n2_before_mouse,1)];
    d_before.n3.ripples    = [d_before.n3.ripples ; mean(n3_before_mouse,1)];
    d_before.nrem.ripples  = [d_before.nrem.ripples ; mean(nrem_before_mouse,1)];
    
    d_after.n2.ripples     = [d_after.n2.ripples ; mean(n2_after_mouse,1)];
    d_after.n3.ripples     = [d_after.n3.ripples ; mean(n3_after_mouse,1)];
    d_after.nrem.ripples   = [d_after.nrem.ripples ; mean(nrem_after_mouse,1)];
    
    d_norm.n2.ripples      = [d_norm.n2.ripples ; mean(n2_norm_mouse,1)];
    d_norm.n3.ripples      = [d_norm.n3.ripples ; mean(n3_norm_mouse,1)];
    d_norm.nrem.ripples    = [d_norm.nrem.ripples ; mean(nrem_norm_mouse,1)];
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
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
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
std_before.n2.ripples   = std(d_before.n2.ripples,1) / sqrt(size(d_before.n2.ripples,1));
std_after.n2.ripples    = std(d_after.n2.ripples,1) / sqrt(size(d_after.n2.ripples,1));
std_norm.n2.ripples     = std(d_norm.n2.ripples,1) / sqrt(size(d_norm.n2.ripples,1));
d_before.n2.ripples     = mean(d_before.n2.ripples,1);
d_after.n2.ripples      = mean(d_after.n2.ripples,1);
d_norm.n2.ripples       = mean(d_norm.n2.ripples,1);

std_before.n2.sham   = std(d_before.n2.sham,1) / sqrt(size(d_before.n2.sham,1));
std_after.n2.sham    = std(d_after.n2.sham,1) / sqrt(size(d_after.n2.sham,1));
std_norm.n2.sham     = std(d_norm.n2.sham,1) / sqrt(size(d_norm.n2.sham,1));
d_before.n2.sham     = mean(d_before.n2.sham,1);
d_after.n2.sham      = mean(d_after.n2.sham,1);
d_norm.n2.sham       = mean(d_norm.n2.sham,1);

%mean N3
std_before.n3.ripples   = std(d_before.n3.ripples,1) / sqrt(size(d_before.n3.ripples,1));
std_after.n3.ripples    = std(d_after.n3.ripples,1) / sqrt(size(d_after.n3.ripples,1));
std_norm.n3.ripples     = std(d_norm.n3.ripples,1) / sqrt(size(d_norm.n3.ripples,1));
d_before.n3.ripples     = mean(d_before.n3.ripples,1);
d_after.n3.ripples      = mean(d_after.n3.ripples,1);
d_norm.n3.ripples       = mean(d_norm.n3.ripples,1);

std_before.n3.sham   = std(d_before.n3.sham,1) / sqrt(size(d_before.n3.sham,1));
std_after.n3.sham    = std(d_after.n3.sham,1) / sqrt(size(d_after.n3.sham,1));
std_norm.n3.sham     = std(d_norm.n3.sham,1) / sqrt(size(d_norm.n3.sham,1));
d_before.n3.sham     = mean(d_before.n3.sham,1);
d_after.n3.sham      = mean(d_after.n3.sham,1);
d_norm.n3.sham       = mean(d_norm.n3.sham,1);

%mean NREM
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



%distrib N2
d_before.n2.ripples(x_before.n2.ripples>0)=[];
std_before.n2.ripples(x_before.n2.ripples>0)=[];
x_before.n2.ripples(x_before.n2.ripples>0)=[];
d_before.n2.sham(x_before.n2.sham>0)=[];
std_before.n2.sham(x_before.n2.sham>0)=[];
x_before.n2.sham(x_before.n2.sham>0)=[];

d_after.n2.ripples(x_after.n2.ripples<0)=[];
std_after.n2.ripples(x_after.n2.ripples<0)=[];
x_after.n2.ripples(x_after.n2.ripples<0)=[];
d_after.n2.sham(x_after.n2.sham<0)=[];
std_after.n2.sham(x_after.n2.sham<0)=[];
x_after.n2.sham(x_after.n2.sham<0)=[];

%distrib N3
d_before.n3.ripples(x_before.n3.ripples>0)=[];
std_before.n3.ripples(x_before.n3.ripples>0)=[];
x_before.n3.ripples(x_before.n3.ripples>0)=[];
d_before.n3.sham(x_before.n3.sham>0)=[];
std_before.n3.sham(x_before.n3.sham>0)=[];
x_before.n3.sham(x_before.n3.sham>0)=[];

d_after.n3.ripples(x_after.n3.ripples<0)=[];
std_after.n3.ripples(x_after.n3.ripples<0)=[];
x_after.n3.ripples(x_after.n3.ripples<0)=[];
d_after.n3.sham(x_after.n3.sham<0)=[];
std_after.n3.sham(x_after.n3.sham<0)=[];
x_after.n3.sham(x_after.n3.sham<0)=[];

%distrib NREM
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

order_ripples = 'ripples_aft'; %{'ripples_bef','ripples_aft'}
order_sham = 'sham_aft'; %{'sham_bef','sham_aft'}


MatMUA.n2.ripples  = []; MatMUA.n2.sham   = [];
ibefore.n2.ripples = []; ibefore.n2.sham  = [];
MatMUA.n3.ripples  = []; MatMUA.n3.sham   = [];
ibefore.n3.ripples = []; ibefore.n3.sham  = [];
MatMUA.nrem.ripples  = []; MatMUA.nrem.sham   = [];
ibefore.nrem.ripples = []; ibefore.nrem.sham  = [];


for p=1:length(ripples_res.path)
    
    %ripples
    %N2
    raster_tsd = ripraster_res.n2.rasters.ripples{p};
    MatMUA.n2.ripples = [MatMUA.n2.ripples ; Data(raster_tsd)'];
    
    ibefore.n2.ripples = [ibefore.n2.ripples ; ripraster_res.n2.(order_ripples){p}];
    
    %N3
    raster_tsd = ripraster_res.n3.rasters.ripples{p};
    try
        MatMUA.n3.ripples = [MatMUA.n3.ripples ; Data(raster_tsd)'];
    end
    ibefore.n3.ripples = [ibefore.n3.ripples ; ripraster_res.n3.(order_ripples){p}];
    
    %NREM
    raster_tsd = ripraster_res.nrem.rasters.ripples{p};
    MatMUA.nrem.ripples = [MatMUA.nrem.ripples ; Data(raster_tsd)'];
    
    ibefore.nrem.ripples = [ibefore.nrem.ripples ; ripraster_res.nrem.(order_ripples){p}];
    
    
    %sham
    %N2
    raster_tsd = ripraster_res.n2.rasters.sham{p};
    MatMUA.n2.sham = [MatMUA.n2.sham ; Data(raster_tsd)'];
    
    ibefore.n2.sham = [ibefore.n2.sham ; ripraster_res.n2.(order_sham){p}];
    
    %N3
    raster_tsd = ripraster_res.n3.rasters.sham{p};
    MatMUA.n3.sham = [MatMUA.n3.sham ; Data(raster_tsd)'];
    
    ibefore.n3.sham = [ibefore.n3.sham ; ripraster_res.n3.(order_sham){p}];
    
    %NREM
    raster_tsd = ripraster_res.nrem.rasters.sham{p};
    x_mua = Range(raster_tsd);
    MatMUA.nrem.sham = [MatMUA.nrem.sham ; Data(raster_tsd)'];
    
    ibefore.nrem.sham = [ibefore.nrem.sham ; ripraster_res.nrem.(order_sham){p}];
end


%sort raster in N2
[~,idx_order] = sort(ibefore.n2.ripples);
MatMUA.n2.ripples  = MatMUA.n2.ripples(idx_order, :);
        
[~,idx_order] = sort(ibefore.n2.sham);
MatMUA.n2.sham  = MatMUA.n2.sham(idx_order, :);

%sort raster in N3
[~,idx_order] = sort(ibefore.n3.ripples);
MatMUA.n3.ripples  = MatMUA.n3.ripples(idx_order, :);
        
[~,idx_order] = sort(ibefore.n3.sham);
MatMUA.n3.sham  = MatMUA.n3.sham(idx_order, :);

%sort raster in NREM
[~,idx_order] = sort(ibefore.nrem.ripples);
MatMUA.nrem.ripples  = MatMUA.nrem.ripples(idx_order, :);
        
[~,idx_order] = sort(ibefore.nrem.sham);
MatMUA.nrem.sham  = MatMUA.nrem.sham(idx_order, :);


%% MUA response

%mean response in N2
y_mua_ripples.n2 = mean(MatMUA.n2.ripples,1);
y_mua_ripples.n2 = Smooth(y_mua_ripples.n2 ,1);
y_mua_ripples.n2 = y_mua_ripples.n2 / mean(y_mua_ripples.n2(x_mua<-0.5e4));

y_mua_sham.n2 = mean(MatMUA.n2.sham,1);
y_mua_sham.n2 = Smooth(y_mua_sham.n2 ,1);
y_mua_sham.n2 = y_mua_sham.n2 / mean(y_mua_sham.n2(x_mua<-0.5e4));

%mean response in N3
y_mua_ripples.n3 = mean(MatMUA.n3.ripples,1);
y_mua_ripples.n3 = Smooth(y_mua_ripples.n3 ,1);
y_mua_ripples.n3 = y_mua_ripples.n3 / mean(y_mua_ripples.n3(x_mua<-0.5e4));

y_mua_sham.n3 = mean(MatMUA.n3.sham,1);
y_mua_sham.n3 = Smooth(y_mua_sham.n3 ,1);
y_mua_sham.n3 = y_mua_sham.n3 / mean(y_mua_sham.n3(x_mua<-0.5e4));

%mean response in NREM
y_mua_ripples.nrem = mean(MatMUA.nrem.ripples,1);
y_mua_ripples.nrem = Smooth(y_mua_ripples.nrem ,1);
y_mua_ripples.nrem = y_mua_ripples.nrem / mean(y_mua_ripples.nrem(x_mua<-0.5e4));

y_mua_sham.nrem = mean(MatMUA.nrem.sham,1);
y_mua_sham.nrem = Smooth(y_mua_sham.nrem ,1);
y_mua_sham.nrem = y_mua_sham.nrem / mean(y_mua_sham.nrem(x_mua<-0.5e4));



%% PLOT
sz=25;
gap = [0.10 0.04];
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
imagesc(x_mua/10, 1:size(MatMUA.n2.ripples,1), MatMUA.n2.ripples), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n2.ripples,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to ripples (s)'), ylabel('#ripples'),
title('Ripples inside up states - N2')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n2.sham,1), MatMUA.n2.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n2.sham,1)], 'ytick',0:1e4:2e4, 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to random (ms)'), ylabel('#random'),
title('Random inside up states - N2')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_ripples.n2, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.n2, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
xlabel('time from ripples (ms)'),
title('Mean MUA on ripples/random - N2'),


%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.n2.ripples proba.n2.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('probability of transition Up>Down'),


%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.n2.ripples, Smooth(d_before.n2.ripples, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.n2.ripples, Smooth(d_after.n2.ripples, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.n2.sham, Smooth(d_before.n2.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.n2.sham, Smooth(d_after.n2.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'),
title('occurence of start/end of up - N2'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.n2.ripples, Smooth(d_norm.n2.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.n2.sham, Smooth(d_norm.n2.sham, smoothing), 'color', 'r', 'linewidth',2);
hs(1) = shadedErrorBar(x_norm.n2.ripples, Smooth(d_norm.n2.ripples, smoothing), Smooth(std_norm.n2.ripples, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.n2.sham, Smooth(d_norm.n2.sham, smoothing), Smooth(std_norm.n2.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
title({'Occurence of ripples/random', 'in Up state (normalized) - N2'}),


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
imagesc(x_mua/10, 1:size(MatMUA.n3.ripples,1), MatMUA.n3.ripples), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n3.ripples,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to ripples (ms)'), ylabel('#ripples'),
title('Ripples inside up states - N3')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.n3.sham,1), MatMUA.n3.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.n3.sham,1)], 'ytick',0:1e4:2e4, 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to random (ms)'), ylabel('#random'),
title('Random inside up states - N3')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_ripples.n3, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.n3, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
% lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
xlabel('time from ripples (ms)'),
title('Mean MUA on ripples/sham - N3'),

%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.n3.ripples proba.n3.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('probability of transition Up>Down'),

%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.n3.ripples, Smooth(d_before.n3.ripples, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.n3.ripples, Smooth(d_after.n3.ripples, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.n3.sham, Smooth(d_before.n3.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.n3.sham, Smooth(d_after.n3.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'),
title('occurence of start/end of up - N3'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.n3.ripples, Smooth(d_norm.n3.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.n3.sham, Smooth(d_norm.n3.sham, smoothing), 'color', 'r', 'linewidth',2);
hs(1) = shadedErrorBar(x_norm.n3.ripples, Smooth(d_norm.n3.ripples, smoothing), Smooth(std_norm.n3.ripples, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.n3.sham, Smooth(d_norm.n3.sham, smoothing), Smooth(std_norm.n3.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
% lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
title({'Occurence of ripples/random', 'in Up state (normalized) - N3'}),


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
imagesc(x_mua/10, 1:size(MatMUA.nrem.ripples,1), MatMUA.nrem.ripples), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.ripples,1)], 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to ripples (ms)'), ylabel('#ripples'),
title('Ripples inside up states - NREM')


%SHAM - raster plot
subtightplot(4,4,5,gap), hold on
imagesc(x_mua/10, 1:size(MatMUA.nrem.sham,1), MatMUA.nrem.sham), hold on
axis xy, hold on
line([0 0], ylim,'linewidth',2,'color','w'), hold on
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
set(gca,'YLim', [0 size(MatMUA.nrem.sham,1)], 'ytick',0:1e4:2e4, 'XLim',[-400 400],'Fontsize',fontsize);
xlabel('time relative to random (ms)'), ylabel('#random'),
title('Random inside up states - NREM')

% MUA
clear h
subtightplot(4,4,[2 6],gap), hold on
h(1) = plot(x_mua/10, y_mua_ripples.nrem, 'color', 'b', 'linewidth', 2);
h(2) = plot(x_mua/10, y_mua_sham.nrem, 'color', 'r', 'linewidth', 2);
set(gca,'YLim', [0 2],'xlim',[-400 400],'Fontsize',fontsize);
line([0 0],get(gca,'ylim'),'linewidth',2,'color',[0.7 0.7 0.7]);
line([40 40], ylim,'linewidth',1,'color',[0.7 0.7 0.7]), hold on
% lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
xlabel('time from ripples (ms)'),
title('Mean MUA on ripples/sham - NREM'),

%Transition probability
subtightplot(4,4,3,gap), hold on
PlotErrorBarN_KJ({proba.nrem.ripples proba.nrem.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('probability of transition Up>Down'),

%Distrib of start and end of Up states
clear h
subtightplot(4,4,7,gap), hold on

h(1) = plot(x_before.nrem.ripples, Smooth(d_before.nrem.ripples, 0), 'color', 'b', 'linewidth',1);
hh(1) = plot(x_after.nrem.ripples, Smooth(d_after.nrem.ripples, 0), 'color', 'b', 'linewidth',2);
h(2) = plot(x_before.nrem.sham, Smooth(d_before.nrem.sham, 0), 'color', 'r', 'linewidth',1);
hh(2) = plot(x_after.nrem.sham, Smooth(d_after.nrem.sham, 0), 'color', 'r', 'linewidth',2);

set(gca,'ylim', [0 0.06], 'ytick',0:0.02:0.1, 'Fontsize',fontsize),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
xlabel('time from ripples (ms)'),
title('occurence of start/end of up - NREM'),


%Distrib occurence norm
clear h
subtightplot(4,4,[4 8],gap), hold on
h(1) = plot(x_norm.nrem.ripples, Smooth(d_norm.nrem.ripples, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), 'color', 'r', 'linewidth',2);
hs(1) = shadedErrorBar(x_norm.nrem.ripples, Smooth(d_norm.nrem.ripples, smoothing), Smooth(std_norm.nrem.ripples, smoothing), 'b');
hs(2) = shadedErrorBar(x_norm.nrem.sham, Smooth(d_norm.nrem.sham, smoothing), Smooth(std_norm.nrem.sham, smoothing), 'r');
xlabel('normalized time'), ylabel('probability'),
set(gca, 'ytick',0:0.02:0.08, 'Fontsize',fontsize),
% lgd = legend(h, 'ripples', 'random'); lgd.Location='northwest';
title({'Occurence of ripples/random', 'in Up state (normalized) - NREM'}),




%% PLOT Bar Transition probability

figure, hold on 
fontsize = 20;

%NREM
subtightplot(2,3,4,gap), hold on
PlotErrorBarN_KJ({proba.nrem.ripples proba.nrem.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 0.25], 'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('Ripples in NREM')

%N2
subtightplot(2,3,5,gap), hold on
PlotErrorBarN_KJ({proba.n2.ripples proba.n2.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 0.25], 'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('Ripples in N2')

%N3
subtightplot(2,3,6,gap), hold on
PlotErrorBarN_KJ({proba.n3.ripples proba.n3.sham}, 'newfig',0, 'barcolors',{'b','r'}, 'paired',paired, 'optiontest',optiontest, 'showPoints',1,'ShowSigstar','sig');
set(gca,'ylim',[0 0.25], 'xtick',1:2,'XtickLabel',{'ripples','random'},'Fontsize',fontsize),
title('Ripples in N3')










