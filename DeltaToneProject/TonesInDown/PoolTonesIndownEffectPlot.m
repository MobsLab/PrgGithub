%%PoolTonesIndownEffectPlot
% 17.04.2018 KJ
%
% effect of tones around down states
%
%   see 
%       FiguresTonesInDownPerRecord
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInDownPerRecord_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInDownPerRecord.mat'))
end





%% pool data
ibefore.tones = [];
iafter.tones = [];
ipostdown.tones = [];
ibefore.sham = [];
iafter.sham = [];
ipostdown.sham = [];

for p=1:4
    ibefore.tones   = [ibefore.tones ; figure_res.tones_bef{p}/10];
    iafter.tones    = [iafter.tones ; figure_res.tones_aft{p}/10];
    ipostdown.tones = [ipostdown.tones ; figure_res.tones_post{p}/10];
    
    ibefore.sham   = [ibefore.sham ; figure_res.sham_bef{p}/10];
    iafter.sham    = [iafter.sham ; figure_res.sham_aft{p}/10];
    ipostdown.sham = [ipostdown.sham ; figure_res.sham_post{p}/10];
    
end


%% order and select

%tones
idx = ibefore.tones>0;
ibefore.tones   = ibefore.tones(idx);
iafter.tones    = iafter.tones(idx);
ipostdown.tones = ipostdown.tones(idx);

[o_before.tones, idx] = sort(ibefore.tones);
o_after.tones         = iafter.tones(idx);
o_postdown.tones      = ipostdown.tones(idx);

%sham
idx = ibefore.sham>0;
ibefore.sham   = ibefore.sham(idx);
iafter.sham    = iafter.sham(idx);
ipostdown.sham = ipostdown.sham(idx);

[o_before.sham, idx] = sort(ibefore.sham);
o_after.sham         = iafter.sham(idx);
o_postdown.sham      = ipostdown.sham(idx);


%% distrib

edges_delay = -400:5:400;
edges_norm = 0:0.05:1;
    
%tones
[d_before.tones, x_before.tones] = histcounts(-ibefore.tones, edges_delay, 'Normalization','probability');
x_before.tones = x_before.tones(1:end-1) + diff(x_before.tones);

[d_after.tones, x_after.tones] = histcounts(iafter.tones, edges_delay, 'Normalization','probability');
x_after.tones = x_after.tones(1:end-1) + diff(x_after.tones);

[d_postdown.tones, x_postdown.tones] = histcounts(ipostdown.tones, edges_delay, 'Normalization','probability');
x_postdown.tones = x_postdown.tones(1:end-1) + diff(x_postdown.tones);

norm_tones = ibefore.tones ./ (ibefore.tones + iafter.tones);
[d_norm.tones, x_norm.tones] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
x_norm.tones = x_norm.tones(1:end-1) + diff(x_norm.tones);


%sham
[d_before.sham, x_before.sham] = histcounts(-ibefore.sham, edges_delay, 'Normalization','probability');
x_before.sham = x_before.sham(1:end-1) + diff(x_before.sham);

[d_after.sham, x_after.sham] = histcounts(iafter.sham, edges_delay, 'Normalization','probability');
x_after.sham = x_after.sham(1:end-1) + diff(x_after.sham);

[d_postdown.sham, x_postdown.sham] = histcounts(ipostdown.sham, edges_delay, 'Normalization','probability');
x_postdown.sham = x_postdown.sham(1:end-1) + diff(x_postdown.sham);

norm_sham = ibefore.sham ./ (ibefore.sham + iafter.sham);
[d_norm.sham, x_norm.sham] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
x_norm.sham = x_norm.sham(1:end-1) + diff(x_norm.sham);


%ratio
edges_ratio = -2:0.1:10;

ratio_indown = abs(ibefore.tones ./ iafter.tones);
[y_ratio.tones, x_ratio.tones] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
x_ratio.tones = x_ratio.tones(1:end-1) + diff(x_ratio.tones);

ratio_indown = abs(ibefore.sham ./ iafter.sham);
[y_ratio.sham, x_ratio.sham] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
x_ratio.sham = x_ratio.sham(1:end-1) + diff(x_ratio.sham);


%% PLOT
figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;


%TONES - scatter plot
subtightplot(2,3,1,gap), hold on
h(1) = scatter(-o_before.tones, 1:length(o_before.tones), sz,'r','filled');
h(3) = scatter(o_postdown.tones, 1:length(o_postdown.tones), sz,[0 0.8 0],'filled');
h(2) = scatter(o_after.tones, 1:length(o_after.tones), sz,[0.1 0.1 0.44],'filled');

xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([min(edges_delay) max(edges_delay)]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
lgd = legend(h, 'start', 'end', 'down post'); lgd.Location='Southwest';
title('Tones inside down states')


%SHAM - scatter plot
subtightplot(2,3,2,gap), hold on
h(1) = scatter(-o_before.sham, 1:length(o_before.sham), sz,'r','filled');
h(3) = scatter(o_postdown.sham, 1:length(o_postdown.sham), sz,[0 0.8 0],'filled');
h(2) = scatter(o_after.sham, 1:length(o_after.sham), sz,[0.1 0.1 0.44],'filled');

xlabel('time relative to sham (ms)'), ylabel('#tones'), xlim([min(edges_delay) max(edges_delay)]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
lgd = legend(h, 'start', 'end', 'down post'); lgd.Location='Southwest';
title('Sham inside down states')

%Distrib occurence norm
clear h
subtightplot(2,3,3,gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
title('Occurence of tones/sham in Down state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(2,3,4,gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.tones, Smooth(d_postdown.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.3]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
legend(h, 'start', 'end', 'down post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(2,3,5,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.sham, Smooth(d_postdown.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.3]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


%Distrib log-ratio
clear h
subtightplot(2,3,6,gap), hold on
h(1) = plot(x_ratio.tones, Smooth(y_ratio.tones,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'tones', 'sham'),












% 
% %Distrib start-event (sham and tones)
% clear h
% subtightplot(2,3,2,gap), hold on
% h(1) = plot(x_before.tones, Smooth(d_before.tones, smoothing), 'color', 'b', 'linewidth',2);
% h(2) = plot(x_before.sham, Smooth(d_before.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2);
% legend(h, 'tones', 'sham'),
% xlabel('delay between start of down state and events (ms)'), ylabel('probability'), 
% title('Start of down state and events')
% 
% %Distrib end-event (sham and tones)
% clear h
% subtightplot(2,3,3,gap), hold on
% plot(x_after.tones, Smooth(d_after.tones, smoothing), 'color', 'b', 'linewidth',2);
% plot(x_after.sham, Smooth(d_after.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2);
% set(gca, 'XDir','reverse'),
% xlabel('delay between events and end of down state (ms)'),
% title('Events and end of down state')


