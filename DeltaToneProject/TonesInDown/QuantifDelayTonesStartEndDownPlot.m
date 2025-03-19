%%QuantifDelayTonesStartEndDownPlot
% 18.05.2018 KJ
%
%
% see
%   QuantifDelayTonesStartEndDown
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'QuantifDelayTonesStartEndDown.mat'))


%params
hstep = 5;
max_edge_in = 200;
edges_in = 0:hstep:max_edge_in;
max_edge_out = 600;
edges_out = 0:hstep:max_edge_out;

smoothing=2;


%% POOL

%Tones in up
tones.outside.delay = [];
for p=1:length(delay_res.path)
    tones.outside.delay = [tones.outside.delay ; delay_res.tones.outside{p}];
end
tones.outside.delay = tones.outside.delay / 10; %in ms

tones.outside.medians = median(tones.outside.delay(tones.outside.delay<max_edge_in));
tones.outside.modes_delay = mode(tones.outside.delay(tones.outside.delay<max_edge_in));
[tones.outside.y_distrib, tones.outside.x_distrib] = histcounts(tones.outside.delay, edges_out,'Normalization','probability');
tones.outside.x_distrib = tones.outside.x_distrib(1:end-1) + diff(tones.outside.x_distrib);

%Tones in down
tones.inside.delay = [];
for p=1:length(delay_res.path)
    tones.inside.delay = [tones.inside.delay ; delay_res.tones.inside{p}];
end
tones.inside.delay = tones.inside.delay / 10; %in ms

tones.inside.medians = median(tones.inside.delay(tones.inside.delay<max_edge_in));
tones.inside.modes_delay = mode(tones.inside.delay(tones.inside.delay<max_edge_in));
[tones.inside.y_distrib, tones.inside.x_distrib] = histcounts(tones.inside.delay, edges_in,'Normalization','probability');
tones.inside.x_distrib = tones.inside.x_distrib(1:end-1) + diff(tones.inside.x_distrib);

%Sham in up
sham.outside.delay = [];
for p=1:length(delay_res.path)
    sham.outside.delay = [sham.outside.delay ; delay_res.sham.outside{p}];
end
sham.outside.delay = sham.outside.delay / 10; %in ms

sham.outside.medians = median(sham.outside.delay(sham.outside.delay<max_edge_in));
sham.outside.modes_delay = mode(sham.outside.delay(sham.outside.delay<max_edge_in));
[sham.outside.y_distrib, sham.outside.x_distrib] = histcounts(sham.outside.delay, edges_out,'Normalization','probability');
sham.outside.x_distrib = sham.outside.x_distrib(1:end-1) + diff(sham.outside.x_distrib);

%Sham in down
sham.inside.delay = [];
for p=1:length(delay_res.path)
    sham.inside.delay = [sham.inside.delay ; delay_res.sham.inside{p}];
end
sham.inside.delay = sham.inside.delay / 10; %in ms

sham.inside.medians = median(sham.inside.delay(sham.inside.delay<max_edge_in));
sham.inside.modes_delay = mode(sham.inside.delay(sham.inside.delay<max_edge_in));
[sham.inside.y_distrib, sham.inside.x_distrib] = histcounts(sham.inside.delay, edges_in,'Normalization','probability');
sham.inside.x_distrib = sham.inside.x_distrib(1:end-1) + diff(sham.inside.x_distrib);


%data to plot - stairs
[tones.outside.x_plot,tones.outside.y_plot] = stairs(tones.outside.x_distrib, tones.outside.y_distrib);
[tones.inside.x_plot,tones.inside.y_plot] = stairs(tones.inside.x_distrib, tones.inside.y_distrib);
[sham.outside.x_plot,sham.outside.y_plot] = stairs(sham.outside.x_distrib, sham.outside.y_distrib);
[sham.inside.x_plot,sham.inside.y_plot] = stairs(sham.inside.x_distrib, sham.inside.y_distrib);


%% PLOT
figure, hold on

%In down
subplot(1,5,1:2), hold on
h(1) = plot(tones.inside.x_plot, tones.inside.y_plot, 'color', 'k', 'LineWidth',2); hold on,
h(2) = plot(sham.inside.x_plot, sham.inside.y_plot, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,
xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge_in,'XLim',[0 max_edge_in],'FontName','Times'), hold on,
title('between tones/sham (in down) and down->up transition')
legend(h,'Tones','Sham')


%In up
subplot(1,5,3:5), hold on
h(1) = plot(tones.outside.x_plot, tones.outside.y_plot, 'color', 'k', 'LineWidth',2); hold on,
h(2) = plot(sham.outside.x_plot, sham.outside.y_plot, 'color', [0.6 0.6 0.6], 'LineWidth',2); hold on,
xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge_out,'XLim',[0 max_edge_out],'FontName','Times'), hold on,
title('between tones/sham (in Up) and up->down transition')
legend(h,'Tones','Sham')

suplabel('Distribution of the delays ','t');






