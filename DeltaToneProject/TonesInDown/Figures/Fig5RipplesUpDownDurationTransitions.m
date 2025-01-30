%%Fig5RipplesUpDownDurationTransitions
% 31.05.2018 KJ
%
% effect of ripples/sham on transitions and up&down durations
%
%   see 
%       CompareInducedVsEndogeneousDown 
%


%load
clear


%% params

%durations
hstep = 2;
max_edge_down = 300;
edges_down = 0:hstep:max_edge_down;
max_edge_up = 800;
edges_up = 0:hstep:max_edge_up;

%transition times
hstep = 2;
max_edge_in = 150;
edges_in = 0:hstep:max_edge_in;
max_edge_out = 300;
edges_out = 0:hstep:max_edge_out;

%probability
delay_down = 40:20:280;
delay_up = 0:50:800;
x_down = delay_down(1:end-1) + diff(delay_down);
x_up = delay_up(1:end-1) + diff(delay_up);

%plot type
stairsplot = 0;
smoothing = 1;


%% DURATIONS (UpDownDurations)

load(fullfile(FolderDeltaDataKJ,'UpDownDurations.mat')) %durations

%POOL
durations_down = [];
durations_up = [];
for p=1:length(duration_res.path)
    durations_down = [durations_down ; duration_res.down{p}/10];
    durations_up   = [durations_up ; duration_res.up{p}/10];
end

%distrib
[durations.down.y_distrib, durations.down.x_distrib] = histcounts(durations_down, edges_down,'Normalization','probability');
durations.down.x_distrib = durations.down.x_distrib(1:end-1) + diff(durations.down.x_distrib);

[durations.up.y_distrib, durations.up.x_distrib] = histcounts(durations_up, edges_up,'Normalization','probability');
durations.up.x_distrib = durations.up.x_distrib(1:end-1) + diff(durations.up.x_distrib);


%% TRANSITIONS (QuantifDelayRipplesStartEndDown)

load(fullfile(FolderDeltaDataKJ,'QuantifDelayRipplesStartEndDown.mat')) %transition after ripples/sham

%POOL & distrib
%Ripples in up
ripples.outside.delay = [];
for p=1:length(delay_res.path)
    ripples.outside.delay = [ripples.outside.delay ; delay_res.ripples.outside{p}];
end
ripples.outside.delay = ripples.outside.delay / 10; %in ms
y_data = ripples.outside.delay(ripples.outside.delay<max_edge_out);

[ripples.outside.y_distrib, ripples.outside.x_distrib] = histcounts(y_data, edges_out,'Normalization','probability');
ripples.outside.x_distrib = ripples.outside.x_distrib(1:end-1) + diff(ripples.outside.x_distrib);

%Ripples in down
ripples.inside.delay = [];
for p=1:length(delay_res.path)
    ripples.inside.delay = [ripples.inside.delay ; delay_res.ripples.inside{p}];
end
ripples.inside.delay = ripples.inside.delay / 10; %in ms
y_data = ripples.inside.delay(ripples.inside.delay<max_edge_in);

[ripples.inside.y_distrib, ripples.inside.x_distrib] = histcounts(y_data, edges_in,'Normalization','probability');
ripples.inside.x_distrib = ripples.inside.x_distrib(1:end-1) + diff(ripples.inside.x_distrib);

%Sham in up
sham.outside.delay = [];
for p=1:length(delay_res.path)
    sham.outside.delay = [sham.outside.delay ; delay_res.sham.outside{p}];
end
sham.outside.delay = sham.outside.delay / 10; %in ms
y_data = sham.outside.delay(sham.outside.delay<max_edge_out);

[sham.outside.y_distrib, sham.outside.x_distrib] = histcounts(y_data, edges_out,'Normalization','probability');
sham.outside.x_distrib = sham.outside.x_distrib(1:end-1) + diff(sham.outside.x_distrib);

%Sham in down
sham.inside.delay = [];
for p=1:length(delay_res.path)
    sham.inside.delay = [sham.inside.delay ; delay_res.sham.inside{p}];
end
sham.inside.delay = sham.inside.delay / 10; %in ms
y_data = sham.inside.delay(sham.inside.delay<max_edge_in);

[sham.inside.y_distrib, sham.inside.x_distrib] = histcounts(y_data, edges_in,'Normalization','probability');
sham.inside.x_distrib = sham.inside.x_distrib(1:end-1) + diff(sham.inside.x_distrib);


%% PROBABILITY OF TRANSITION (ProbabilityRipplesUpDownTransition)

load(fullfile(FolderDeltaDataKJ,'ProbabilityRipplesUpDownTransition.mat')) %probability of transitions after ripples/sham

%Ripples in up
all_delay = [];
all_success = [];
for p=1:length(transit_res.path)
    all_delay   = [all_delay ; transit_res.ripples.up.delay{p}/10];
    all_success = [all_success ; transit_res.ripples.up.success{p}];
end
for i=1:length(delay_up)-1
    ripples.up.induce{i} = all_success(all_delay>=delay_up(i) & all_delay<delay_up(i+1))*100;
end

%Ripples in down
all_delay = [];
all_success = [];
for p=1:length(transit_res.path)
    all_delay   = [all_delay ; transit_res.ripples.down.delay{p}/10];
    all_success = [all_success ; transit_res.ripples.down.success{p}];
end
for i=1:length(delay_down)-1
    ripples.down.induce{i} = all_success(all_delay>=delay_down(i) & all_delay<delay_down(i+1))*100;
end

%Sham in up
all_delay = [];
all_success = [];
for p=1:length(transit_res.path)
    all_delay   = [all_delay ; transit_res.sham.up.delay{p}/10];
    all_success = [all_success ; transit_res.sham.up.success{p}];
end
for i=1:length(delay_up)-1
    sham.up.induce{i} = all_success(all_delay>=delay_up(i) & all_delay<delay_up(i+1))*100;
end

%Sham in down
all_delay = [];
all_success = [];
for p=1:length(transit_res.path)
    all_delay   = [all_delay ; transit_res.sham.down.delay{p}/10];
    all_success = [all_success ; transit_res.sham.down.success{p}];
end
for i=1:length(delay_down)-1
    sham.down.induce{i} = all_success(all_delay>=delay_down(i) & all_delay<delay_down(i+1))*100;
end



%% DATA TO PLOT
if stairsplot
    [durations.down.x_plot,durations.down.y_plot] = stairs(durations.down.x_distrib, durations.down.y_distrib);
    [durations.up.x_plot,durations.up.y_plot]   = stairs(durations.up.x_distrib, durations.up.y_distrib);
    
    [ripples.outside.x_plot,ripples.outside.y_plot] = stairs(ripples.outside.x_distrib, ripples.outside.y_distrib);
    [ripples.inside.x_plot,ripples.inside.y_plot] = stairs(ripples.inside.x_distrib, ripples.inside.y_distrib);
    [sham.outside.x_plot,sham.outside.y_plot] = stairs(sham.outside.x_distrib, sham.outside.y_distrib);
    [sham.inside.x_plot,sham.inside.y_plot] = stairs(sham.inside.x_distrib, sham.inside.y_distrib);

else
    durations.down.x_plot = durations.down.x_distrib;
    durations.down.y_plot = Smooth(durations.down.y_distrib, smoothing);
    durations.up.x_plot = durations.up.x_distrib;
    durations.up.y_plot = Smooth(durations.up.y_distrib, smoothing);
    
    ripples.outside.x_plot = ripples.outside.x_distrib;
    ripples.outside.y_plot = Smooth(ripples.outside.y_distrib, smoothing);
    ripples.inside.x_plot = ripples.inside.x_distrib;
    ripples.inside.y_plot = Smooth(ripples.inside.y_distrib, smoothing);
    sham.outside.x_plot = sham.outside.x_distrib;
    sham.outside.y_plot = Smooth(sham.outside.y_distrib, smoothing);
    sham.inside.x_plot = sham.inside.x_distrib;
    sham.inside.y_plot = Smooth(sham.inside.y_distrib, smoothing);

end

%% PLOT
figure, hold on
fontsize = 16;

%Down durations
subplot(3,2,1), hold on
plot(durations.down.x_plot, durations.down.y_plot, 'color', 'b', 'LineWidth',2); hold on,
xlabel('duration (ms)'), ylabel('probability')
set(gca,'XTick',0:50:max_edge_down,'XLim',[0 max_edge_down],'FontName','Times','Fontsize',fontsize), hold on,
title('Duration of down states (no ripples)')

%Up durations
subplot(3,2,2), hold on
plot(durations.up.x_plot, durations.up.y_plot, 'color', 'b', 'LineWidth',2); hold on,
xlabel('duration (ms)'), ylabel('probability')
set(gca,'XTick',0:200:max_edge_up,'XLim',[0 max_edge_up],'FontName','Times','Fontsize',fontsize), hold on,
title('Duration of up states (no ripples)')

%Transition down>up
subplot(3,2,3), hold on
h(1) = plot(ripples.inside.x_plot, ripples.inside.y_plot, 'color', 'b', 'LineWidth',2); hold on,
h(2) = plot(sham.inside.x_plot, sham.inside.y_plot, 'color', 'r', 'LineWidth',2); hold on,
xlabel('time (ms) from ripples/sham'), ylabel('probability')
set(gca,'XTick',0:50:max_edge_in,'XLim',[0 max_edge_in],'FontName','Times','Fontsize',fontsize), hold on,
title('Delay from ripples/sham to down->up transition')
%rectange success
y_lim=ylim;
y_rec1 = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)]/10;
x_rec1 = [range_down(1) range_down(2) range_down(2) range_down(1)]/10;
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

legend(h,'Ripples','Sham')


%Transition up<down
subplot(3,2,4), hold on
h(1) = plot(ripples.outside.x_plot, ripples.outside.y_plot, 'color', 'b', 'LineWidth',2); hold on,
h(2) = plot(sham.outside.x_plot, sham.outside.y_plot, 'color', 'r', 'LineWidth',2); hold on,
xlabel('time (ms) from ripples/sham'), ylabel('probability')
set(gca,'XTick',[0 100 200:200:max_edge_out],'XLim',[0 max_edge_out],'FontName','Times','Fontsize',fontsize), hold on,
title('Delay from ripples/sham to up->down transition')
%rectange success
y_lim=ylim;
y_rec2 = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)]/10;
x_rec2 = [range_up(1) range_up(2) range_up(2) range_up(1)]/10;
hold on, patch(x_rec2, y_rec2, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

legend(h,'Ripples','Sham')


%Probability transitions down>up
subplot(3,2,5), hold on
[~,h(1)]=PlotErrorLineN_KJ(ripples.down.induce,'x_data',x_down,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.down.induce,'x_data',x_down,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Down start and ripples/sham'), ylabel('%')
set(gca,'XTick',0:50:300,'XLim',[0 300],'Ylim', [0 110], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of down>up transition')

%Probability transitions up>down
subplot(3,2,6), hold on
[~,h(1)]=PlotErrorLineN_KJ(ripples.up.induce,'x_data',x_up,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.up.induce,'x_data',x_up,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Up start and ripples/sham'), ylabel('%')
set(gca,'XTick',0:200:max(delay_up),'XLim',[0 max(delay_up)],'Ylim', [0 110], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of up>down transition')




