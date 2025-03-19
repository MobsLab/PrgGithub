%%ScriptRipplesPeriodTransition
% 19.07.2019 KJ
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

load(fullfile(FolderDeltaDataKJ,'RipplesInDownN2N3Effect.mat'))

%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;


animals = unique(ripples_res.name);


%% loop all nights
for p=1:length(ripples_res.path)    
    
    %NREM
    y_data = ripples_res.nrem.ripples_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.ripples{p}, nrem.x_before.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.ripples{p} = nrem.x_before.ripples{p}(1:end-1) + diff(nrem.x_before.ripples{p});
    
    y_data = ripples_res.nrem.ripples_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.ripples{p}, nrem.x_after.ripples{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.ripples{p} = nrem.x_after.ripples{p}(1:end-1) + diff(nrem.x_after.ripples{p});
    
    norm_ripples = ripples_res.nrem.ripples_bef{p} ./ (ripples_res.nrem.ripples_bef{p} + ripples_res.nrem.ripples_aft{p});
    [nrem.d_norm.ripples{p}, nrem.x_norm.ripples{p}] = histcounts(norm_ripples, edges_norm, 'Normalization','probability');
    nrem.x_norm.ripples{p} = nrem.x_norm.ripples{p}(1:end-1) + diff(nrem.x_norm.ripples{p});
    
    %NREM
    y_data = ripples_res.nrem.sham_bef{p}/10; y_data = -y_data(y_data<max(edges_delay));
    [nrem.d_before.sham{p}, nrem.x_before.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_before.sham{p} = nrem.x_before.sham{p}(1:end-1) + diff(nrem.x_before.sham{p});

    y_data = ripples_res.nrem.sham_aft{p}/10; y_data = y_data(y_data<max(edges_delay));
    [nrem.d_after.sham{p}, nrem.x_after.sham{p}] = histcounts(y_data, edges_delay, 'Normalization','probability');
    nrem.x_after.sham{p} = nrem.x_after.sham{p}(1:end-1) + diff(nrem.x_after.sham{p});

end

%loop animals
for m=1:length(animals)
    
    %NREM
    d_before.nrem.ripples     = [];
    d_after.nrem.ripples      = [];

    x_before.nrem.ripples     = nrem.x_before.ripples{1};
    x_after.nrem.ripples      = nrem.x_after.ripples{1};

    d_before.nrem.sham      = [];
    d_after.nrem.sham       = [];

    x_before.nrem.sham   = nrem.x_before.sham{1};
    x_after.nrem.sham    = nrem.x_after.sham{1};
    
    
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
        %ripples
        d_before.nrem.ripples   = [d_before.nrem.ripples ; nrem.d_before.ripples{p}];
        d_after.nrem.ripples    = [d_after.nrem.ripples ; nrem.d_after.ripples{p}];

        %sham
        d_before.nrem.sham    = [d_before.nrem.sham ; nrem.d_before.sham{p}];
        d_after.nrem.sham     = [d_after.nrem.sham ; nrem.d_after.sham{p}];
        end
    end
    

    %mean and std NREM
    std_before.nrem.ripples   = std(d_before.nrem.ripples,[],1) / sqrt(size(d_before.nrem.ripples,1));
    std_after.nrem.ripples    = std(d_after.nrem.ripples,[],1) / sqrt(size(d_after.nrem.ripples,1));
    d_before.nrem.ripples     = mean(d_before.nrem.ripples,1);
    d_after.nrem.ripples      = mean(d_after.nrem.ripples,1);

    std_before.nrem.sham   = std(d_before.nrem.sham,[],1) / sqrt(size(d_before.nrem.sham,1));
    std_after.nrem.sham    = std(d_after.nrem.sham,[],1) / sqrt(size(d_after.nrem.sham,1));
    d_before.nrem.sham     = mean(d_before.nrem.sham,1);
    d_after.nrem.sham      = mean(d_after.nrem.sham,1);


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


    %% Plot

    figure, hold on,
    h(1) = plot(x_before.nrem.ripples, Smooth(d_before.nrem.ripples, 0), 'color', 'b', 'linewidth',1);
    hh(1) = plot(x_after.nrem.ripples, Smooth(d_after.nrem.ripples, 0), 'color', 'b', 'linewidth',2);
    h(2) = plot(x_before.nrem.sham, Smooth(d_before.nrem.sham, 0), 'color', 'r', 'linewidth',1);
    hh(2) = plot(x_after.nrem.sham, Smooth(d_after.nrem.sham, 0), 'color', 'r', 'linewidth',2);

    set(gca,'ylim', [0 0.16], 'ytick',0:0.02:0.1),
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
    xlabel('time from ripples (ms)'),
    title(animals{m}),

    
end




