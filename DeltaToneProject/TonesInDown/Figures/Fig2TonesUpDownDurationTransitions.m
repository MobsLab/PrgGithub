%%Fig2TonesUpDownDurationTransitions
% 25.05.2018 KJ
%
% effect of tones/sham on transitions and up&down durations
%
%   see 
%       CompareInducedVsEndogeneousDown 
%


%load
clear


%% params

%durations
hstep = 2;
max_edge_down = 200;
edges_down = 0:hstep:max_edge_down;
max_edge_up = 800;
edges_up = 0:hstep:max_edge_up;

%transition times
hstep = 2;
max_edge_in = 200;
edges_in = 0:hstep:max_edge_in;
max_edge_out = 800;
edges_out = 0:hstep:max_edge_out;

%probability
delay_down = 40:20:200;
delay_up = 50:50:800;
x_down = delay_down(1:end-1) + diff(delay_down);
x_up = delay_up(1:end-1) + diff(delay_up);

%plot type
stairsplot = 0;
smoothing = 1;

normalization1 = 'probability'; % count  probability
normalization2 = 'probability'; % count  probability


%% DURATIONS (UpDownDurations)

load(fullfile(FolderDeltaDataKJ,'UpDownDurations.mat')) %durations

animals = unique(duration_res.name);
% animals = animals(7);

%POOL and average per mouse
durations.down.y_distrib = [];
durations.up.y_distrib = [];
for m=1:length(animals)
    
    dur_down_mouse = [];
    dur_up_mouse   = [];
    for p=1:length(duration_res.path)
        if strcmpi(duration_res.name{p},animals{m})
            dur_down_mouse = [dur_down_mouse ; duration_res.down{p}/10];
            dur_up_mouse   = [dur_up_mouse ; duration_res.up{p}/10];
        end
    end
    
    %distrib mouse Down duration
    [y_distribDown_mouse, x_distribDown_mouse] = histcounts(dur_down_mouse, edges_down,'Normalization',normalization1);
    x_distribDown_mouse = x_distribDown_mouse(1:end-1) + diff(x_distribDown_mouse);
    %distrib mouse Up duration
    [y_distribUp_mouse, x_distribUp_mouse] = histcounts(dur_up_mouse, edges_up,'Normalization',normalization1);
    x_distribUp_mouse = x_distribUp_mouse(1:end-1) + diff(x_distribUp_mouse);
    
    durations.down.y_distrib = [durations.down.y_distrib ; y_distribDown_mouse];
    durations.up.y_distrib = [durations.up.y_distrib ; y_distribUp_mouse];  
end


%average and x
durations.down.y_distrib = mean(durations.down.y_distrib,1);
durations.up.y_distrib = mean(durations.up.y_distrib,1); 
    
durations.down.x_distrib = x_distribDown_mouse;
durations.up.x_distrib = x_distribUp_mouse;


%% TRANSITIONS for Tones (QuantifDelayTonesStartEndDown)

load(fullfile(FolderDeltaDataKJ,'QuantifDelayTonesStartEndDown.mat')) %transition after tones/sham


%POOL and average per mouse
tones.outside.y_distrib = [];
tones.inside.y_distrib = [];
for m=1:length(animals)
    
    delay_outside_mouse = [];
    delay_inside_mouse   = [];
    for p=1:length(delay_res.path)
        if strcmpi(delay_res.name{p},animals{m})
            delay_outside_mouse = [delay_outside_mouse ; delay_res.tones.outside{p}/10];
            delay_inside_mouse  = [delay_inside_mouse ; delay_res.tones.inside{p}/10];
        end
    end
    
    %tones in up
    y_data = delay_outside_mouse(delay_outside_mouse<max_edge_out);
    [y_distribOut_mouse, x_distribOut_mouse] = histcounts(y_data, edges_out,'Normalization',normalization2);
    x_distribOut_mouse = x_distribOut_mouse(1:end-1) + diff(x_distribOut_mouse);
    %tones in down
    y_data = delay_inside_mouse(delay_inside_mouse<max_edge_in);
    [y_distribIn_mouse, x_distribIn_mouse] = histcounts(y_data, edges_in,'Normalization',normalization2);
    x_distribIn_mouse = x_distribIn_mouse(1:end-1) + diff(x_distribIn_mouse);
    
    %concatenate
    tones.outside.y_distrib = [tones.outside.y_distrib ; y_distribOut_mouse];
    tones.inside.y_distrib = [tones.inside.y_distrib ; y_distribIn_mouse];  
end

%average and x
tones.outside.y_distrib = mean(tones.outside.y_distrib,1);
tones.inside.y_distrib = mean(tones.inside.y_distrib,1); 
    
tones.outside.x_distrib = x_distribOut_mouse;
tones.inside.x_distrib = x_distribIn_mouse;


%% TRANSITIONS for Sham (QuantifDelayShamStartEndDown)

load(fullfile(FolderDeltaDataKJ,'QuantifDelayShamStartEndDown.mat')) %transition after tones/sham

%POOL and average per mouse
sham.outside.y_distrib = [];
sham.inside.y_distrib = [];
for m=1:length(animals)
    
    delay_outside_mouse = [];
    delay_inside_mouse   = [];
    for p=1:length(delaysham_res.path)
        if strcmpi(delaysham_res.name{p},animals{m})
            delay_outside_mouse = [delay_outside_mouse ; delaysham_res.sham.outside{p}/10];
            delay_inside_mouse  = [delay_inside_mouse ; delaysham_res.sham.inside{p}/10];
        end
    end
    
    %tones in up
    y_data = delay_outside_mouse(delay_outside_mouse<max_edge_out);
    [y_distribOut_mouse, x_distribOut_mouse] = histcounts(y_data, edges_out,'Normalization',normalization2);
    x_distribOut_mouse = x_distribOut_mouse(1:end-1) + diff(x_distribOut_mouse);
    %tones in down
    y_data = delay_inside_mouse(delay_inside_mouse<max_edge_in);
    [y_distribIn_mouse, x_distribIn_mouse] = histcounts(y_data, edges_in,'Normalization',normalization2);
    x_distribIn_mouse = x_distribIn_mouse(1:end-1) + diff(x_distribIn_mouse);
    
    %concatenate
    sham.outside.y_distrib = [sham.outside.y_distrib ; y_distribOut_mouse];
    sham.inside.y_distrib = [sham.inside.y_distrib ; y_distribIn_mouse];  
end

%average and x
sham.outside.y_distrib = mean(sham.outside.y_distrib,1);
sham.inside.y_distrib = mean(sham.inside.y_distrib,1); 
    
sham.outside.x_distrib = x_distribOut_mouse;
sham.inside.x_distrib = x_distribIn_mouse;


%% PROBABILITY OF TRANSITION for Tones

load(fullfile(FolderDeltaDataKJ,'ProbabilityTonesUpDownTransition.mat')) %probability of transitions after tones

%Tones in Up
tones.up.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    success_mouse = [];
    for p=1:length(transit_res.path)
        if strcmpi(transit_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; transit_res.tones.up.delay{p}/10];
            success_mouse = [success_mouse ; transit_res.tones.up.success{p}];
        end
    end
    
    for i=1:length(delay_up)-1
        tones.up.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_up(i) & delay_mouse<delay_up(i+1))*100);
    end
end

%Tones in Down
tones.down.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    success_mouse = [];
    for p=1:length(transit_res.path)
        if strcmpi(transit_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; transit_res.tones.down.delay{p}/10];
            success_mouse = [success_mouse ; transit_res.tones.down.success{p}];
        end
    end
    
    for i=1:length(delay_down)-1
        tones.down.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_down(i) & delay_mouse<delay_down(i+1))*100);
    end
end


%% PROBABILITY OF TRANSITION for Sham

load(fullfile(FolderDeltaDataKJ,'ProbabilityShamUpDownTransition.mat')) %probability of transitions after sham

%Sham in up
sham.up.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    success_mouse = [];
    for p=1:length(transitsham_res.path)
        if strcmpi(transitsham_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; transitsham_res.sham.up.delay{p}/10];
            success_mouse = [success_mouse ; transitsham_res.sham.up.success{p}];
        end
    end
    
    for i=1:length(delay_up)-1
        sham.up.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_up(i) & delay_mouse<delay_up(i+1))*100);
    end
end

%Sham in down
sham.down.induce = cell(0);
for m=1:length(animals)
    
    delay_mouse   = [];
    success_mouse = [];
    for p=1:length(transitsham_res.path)
        if strcmpi(transitsham_res.name{p},animals{m})
            delay_mouse   = [delay_mouse ; transitsham_res.sham.down.delay{p}/10];
            success_mouse = [success_mouse ; transitsham_res.sham.down.success{p}];
        end
    end
    
    for i=1:length(delay_down)-1
        sham.down.induce{i}(1,m) = mean(success_mouse(delay_mouse>=delay_down(i) & delay_mouse<delay_down(i+1))*100);
    end
end


%% DATA TO PLOT
if stairsplot
    [durations.down.x_plot,durations.down.y_plot] = stairs(durations.down.x_distrib, durations.down.y_distrib);
    [durations.up.x_plot,durations.up.y_plot]   = stairs(durations.up.x_distrib, durations.up.y_distrib);
    
    [tones.outside.x_plot,tones.outside.y_plot] = stairs(tones.outside.x_distrib, tones.outside.y_distrib);
    [tones.inside.x_plot,tones.inside.y_plot] = stairs(tones.inside.x_distrib, tones.inside.y_distrib);
    [sham.outside.x_plot,sham.outside.y_plot] = stairs(sham.outside.x_distrib, sham.outside.y_distrib);
    [sham.inside.x_plot,sham.inside.y_plot] = stairs(sham.inside.x_distrib, sham.inside.y_distrib);

else
    durations.down.x_plot = durations.down.x_distrib;
    durations.down.y_plot = Smooth(durations.down.y_distrib, smoothing);
    durations.up.x_plot = durations.up.x_distrib;
    durations.up.y_plot = Smooth(durations.up.y_distrib, smoothing);
    
    tones.outside.x_plot = tones.outside.x_distrib;
    tones.outside.y_plot = Smooth(tones.outside.y_distrib, smoothing);
    tones.inside.x_plot = tones.inside.x_distrib;
    tones.inside.y_plot = Smooth(tones.inside.y_distrib, smoothing);
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
plot(durations.down.x_plot, durations.down.y_plot, 'color', 'k', 'LineWidth',2); hold on,
xlabel('duration (ms)'), ylabel(normalization1)
set(gca,'XTick',0:50:max_edge_down,'XLim',[0 max_edge_down],'FontName','Times','Fontsize',fontsize), hold on,
title('Duration of down states (no tones)')

%Up durations
subplot(3,2,2), hold on
plot(durations.up.x_plot, durations.up.y_plot, 'color', 'k', 'LineWidth',2); hold on,
xlabel('duration (ms)'), ylabel(normalization1)
set(gca,'XTick',0:200:max_edge_up,'XLim',[0 max_edge_up],'FontName','Times','Fontsize',fontsize), hold on,
title('Duration of up states (no tones)')

%Transition down>up
subplot(3,2,3), hold on
h(1) = plot(tones.inside.x_plot, tones.inside.y_plot, 'color', 'b', 'LineWidth',2); hold on,
h(2) = plot(sham.inside.x_plot, sham.inside.y_plot, 'color', 'r', 'LineWidth',2); hold on,
xlabel('time (ms) from tones/sham'), ylabel(normalization2)
set(gca,'XTick',0:50:max_edge_in,'XLim',[0 max_edge_in],'FontName','Times','Fontsize',fontsize), hold on,
title('Delay from tones/sham to down->up transition')
%rectange success
y_lim=ylim;
y_rec1 = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)]/10;
x_rec1 = [range_down(1) range_down(2) range_down(2) range_down(1)]/10;
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

legend(h,'Tones','Sham')


%Transition up<down
subplot(3,2,4), hold on
h(1) = plot(tones.outside.x_plot, tones.outside.y_plot, 'color', 'b', 'LineWidth',2); hold on,
h(2) = plot(sham.outside.x_plot, sham.outside.y_plot, 'color', 'r', 'LineWidth',2); hold on,
xlabel('time (ms) from tones/sham'), ylabel(normalization2)
set(gca,'XTick',[0 100 200:200:max_edge_out],'XLim',[0 max_edge_out],'FontName','Times','Fontsize',fontsize), hold on,
title('Delay from tones/sham to up->down transition')
%rectange success
y_lim=ylim;
y_rec2 = [y_lim(1) y_lim(1) y_lim(2) y_lim(2)]/10;
x_rec2 = [range_up(1) range_up(2) range_up(2) range_up(1)]/10;
hold on, patch(x_rec2, y_rec2, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

legend(h,'Tones','Sham')


%Probability transitions down>up
subplot(3,2,5), hold on
[~,h(1)]=PlotErrorLineN_KJ(tones.down.induce,'x_data',x_down,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.down.induce,'x_data',x_down,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Down start and tones/sham'), ylabel('%')
set(gca,'XTick',0:50:200,'XLim',[50 170],'Ylim', [0 110], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of down>up transition')

%Probability transitions up>down
subplot(3,2,6), hold on
[~,h(1)]=PlotErrorLineN_KJ(tones.up.induce,'x_data',x_up,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
[~,h(2)]=PlotErrorLineN_KJ(sham.up.induce,'x_data',x_up,'newfig',0,'linecolor','r','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Up start and tones/sham'), ylabel('%')
set(gca,'XTick',0:200:max(delay_up),'XLim',[50 max(delay_up)],'Ylim', [0 100], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of up>down transition')



