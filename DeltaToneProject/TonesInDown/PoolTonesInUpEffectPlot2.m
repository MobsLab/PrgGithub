%%PoolTonesInUpEffectPlot2
% 17.04.2018 KJ
%
% effect of tones around down states
% mean of each night distrib
%
%   see 
%       FiguresTonesInUpPerRecord PoolTonesIndownEffectPlot
%       PoolTonesIndownEffectPlot2
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInUpPerRecord_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInUpPerRecord.mat'))
end

%params
edges_delay = -3000:5:3000;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% distrib
for p=1:4
    
    %tones
    [mouse.d_before.tones{p}, mouse.x_before.tones{p}] = histcounts(-figure_res.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_before.tones{p} = mouse.x_before.tones{p}(1:end-1) + diff(mouse.x_before.tones{p});
    
    [mouse.d_after.tones{p}, mouse.x_after.tones{p}] = histcounts(figure_res.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_after.tones{p} = mouse.x_after.tones{p}(1:end-1) + diff(mouse.x_after.tones{p});
    
    [mouse.d_postup.tones{p}, mouse.x_postup.tones{p}] = histcounts(figure_res.tones_post{p}/10, edges_delay, 'Normalization','probability');
    mouse.x_postup.tones{p} = mouse.x_postup.tones{p}(1:end-1) + diff(mouse.x_postup.tones{p});
    
    norm_tones = figure_res.tones_bef{p} ./ (figure_res.tones_bef{p} + figure_res.tones_aft{p});
    [mouse.d_norm.tones{p}, mouse.x_norm.tones{p}] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
    mouse.x_norm.tones{p} = mouse.x_norm.tones{p}(1:end-1) + diff(mouse.x_norm.tones{p});
    
    
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
    ratio_indown = abs(figure_res.tones_bef{p} ./ figure_res.tones_aft{p});
    [mouse.y_ratio.tones{p}, mouse.x_ratio.tones{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.tones{p}= mouse.x_ratio.tones{p}(1:end-1) + diff(mouse.x_ratio.tones{p});
    
    ratio_indown = abs(figure_res.sham_bef{p} ./ figure_res.sham_aft{p});
    [mouse.y_ratio.sham{p}, mouse.x_ratio.sham{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    mouse.x_ratio.sham{p}= mouse.x_ratio.sham{p}(1:end-1) + diff(mouse.x_ratio.sham{p});
end



%% average distributions

d_before.tones = [];
d_after.tones  = [];
d_postup.tones = [];
d_norm.tones   = [];
y_ratio.tones  = []; 

x_before.tones = mouse.x_before.tones{1};
x_after.tones  = mouse.x_after.tones{1};
x_postup.tones = mouse.x_postup.tones{1};
x_norm.tones   = mouse.x_norm.tones{1};
x_ratio.tones  = mouse.x_ratio.tones{1};

d_before.sham = [];
d_after.sham  = [];
d_postup.sham = [];
d_norm.sham   = [];
y_ratio.sham  = []; 

x_before.sham = mouse.x_before.sham{1};
x_after.sham  = mouse.x_after.sham{1};
x_postup.sham = mouse.x_postup.sham{1};
x_norm.sham   = mouse.x_norm.sham{1};
x_ratio.sham  = mouse.x_ratio.sham{1};


for p=1:4
    d_before.tones = [d_before.tones ; mouse.d_before.tones{p}];
    d_after.tones  = [d_after.tones ; mouse.d_after.tones{p}];
    d_postup.tones = [d_postup.tones ; mouse.d_postup.tones{p}];
    d_norm.tones   = [d_norm.tones ; mouse.d_norm.tones{p}];
    y_ratio.tones  = [y_ratio.tones ; mouse.y_ratio.tones{p}];
    
    d_before.sham = [d_before.sham ; mouse.d_before.sham{p}];
    d_after.sham  = [d_after.sham ; mouse.d_after.sham{p}];
    d_postup.sham = [d_postup.sham ; mouse.d_postup.sham{p}];
    d_norm.sham   = [d_norm.sham ; mouse.d_norm.sham{p}];
    y_ratio.sham  = [y_ratio.sham ; mouse.y_ratio.sham{p}];
    
end

%mean
d_before.tones = mean(d_before.tones,1);
d_after.tones  = mean(d_after.tones,1);
d_postup.tones = mean(d_postup.tones,1);
d_norm.tones   = mean(d_norm.tones,1);
y_ratio.tones  = mean(y_ratio.tones,1);

d_before.sham = mean(d_before.sham,1);
d_after.sham  = mean(d_after.sham,1);
d_postup.sham = mean(d_postup.sham,1);
d_norm.sham   = mean(d_norm.sham,1);
y_ratio.sham  = mean(y_ratio.sham,1);


%% pool data
ibefore.tones = [];
iafter.tones = [];
ipostup.tones = [];
ibefore.sham = [];
iafter.sham = [];
ipostup.sham = [];

for p=1:4
    ibefore.tones   = [ibefore.tones ; figure_res.tones_bef{p}/10];
    iafter.tones    = [iafter.tones ; figure_res.tones_aft{p}/10];
    ipostup.tones = [ipostup.tones ; figure_res.tones_post{p}/10];
    
    ibefore.sham   = [ibefore.sham ; figure_res.sham_bef{p}/10];
    iafter.sham    = [iafter.sham ; figure_res.sham_aft{p}/10];
    ipostup.sham = [ipostup.sham ; figure_res.sham_post{p}/10];
    
end

%order tones
idx = ibefore.tones>0;
ibefore.tones   = ibefore.tones(idx);
iafter.tones    = iafter.tones(idx);
ipostup.tones = ipostup.tones(idx);

[o_before.tones, idx] = sort(ibefore.tones);
o_after.tones         = iafter.tones(idx);
o_postup.tones      = ipostup.tones(idx);

%order sham
idx = ibefore.sham>0;
ibefore.sham   = ibefore.sham(idx);
iafter.sham    = iafter.sham(idx);
ipostup.sham = ipostup.sham(idx);

[o_before.sham, idx] = sort(ibefore.sham);
o_after.sham         = iafter.sham(idx);
o_postup.sham      = ipostup.sham(idx);



%% PLOT
figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;


%TONES - scatter plot
subtightplot(2,3,1,gap), hold on
h(1) = scatter(-o_before.tones, 1:length(o_before.tones), sz,'r','filled');
% h(3) = scatter(o_postup.tones, 1:length(o_postup.tones), sz,[0 0.8 0],'filled');
h(2) = scatter(o_after.tones, 1:length(o_after.tones), sz,[0.1 0.1 0.44],'filled');

xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([min(edges_delay) max(edges_delay)]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
lgd = legend(h, 'start', 'end'); lgd.Location='Southwest';
title('Tones inside up states')


%SHAM - scatter plot
subtightplot(2,3,2,gap), hold on
h(1) = scatter(-o_before.sham, 1:length(o_before.sham), sz,'r','filled');
% h(3) = scatter(o_postup.sham, 1:length(o_postup.sham), sz,[0 0.8 0],'filled');
h(2) = scatter(o_after.sham, 1:length(o_after.sham), sz,[0.1 0.1 0.44],'filled');

xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([min(edges_delay) max(edges_delay)]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
lgd = legend(h, 'start', 'end'); lgd.Location='Southwest';
title('Sham inside up states')

%Distrib occurence norm
clear h
subtightplot(2,3,3,gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
lgd = legend(h, 'tones', 'sham'); lgd.Location = 'northwest';
title('Occurence of tones/sham in Up state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(2,3,4,gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.tones, Smooth(d_postup.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
legend(h, 'start', 'end', 'up post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(2,3,5,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.sham, Smooth(d_postup.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.05]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


%Distrib log-ratio
clear h
subtightplot(2,3,6,gap), hold on
h(1) = plot(x_ratio.tones, Smooth(y_ratio.tones,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'tones', 'sham'),


