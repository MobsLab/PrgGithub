%%AssessToneEffectTransitionsPlot
% 24.07.2018 KJ
%
%
%   Look at the effect of tones on transitions dynamics, in function of the occurence of deltas around the tone 
%
% see
%   AssessToneEffectTransitions
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'AssessToneEffectTransitions.mat'))

%params
hstep = 250;
max_edge = 10e3;
edges = -max_edge:hstep:max_edge;

normalization = 'count'; % 'count'probability

stairsplot = 0;
smoothing = 0;


%% POOL
delays.updown.down = [];
delays.updown.up   = [];
delays.upup.down = [];
delays.upup.up   = [];
delays.downup.down = [];
delays.downup.up   = [];
delays.downdown.down = [];
delays.downdown.up   = [];

for p=1:4%length(assess_res.path)
    
    %up>down
    nb_tones.up_down = length(assess_res.nb_tone.up_down);
    for i=1:nb_tones.up_down
        delays.updown.down = [delays.updown.down ; assess_res.delays.updown.down{p,i}/10];
        delays.updown.up = [delays.updown.up ; assess_res.delays.updown.up{p,i}/10];
    end
    
    %up>up
    nb_tones.up_up = length(assess_res.nb_tone.up_up);
    for i=1:nb_tones.up_up
        delays.upup.down = [delays.upup.down ; assess_res.delays.upup.down{p,i}/10];
        delays.upup.up = [delays.upup.up ; assess_res.delays.upup.up{p,i}/10];
    end
    
    %down>up
    nb_tones.down_up = length(assess_res.nb_tone.down_up);
    for i=1:nb_tones.down_up
        delays.downup.down = [delays.downup.down ; assess_res.delays.downup.down{p,i}/10];
        delays.downup.up = [delays.downup.up ; assess_res.delays.downup.up{p,i}/10];
    end
    
    %down>down
    nb_tones.down_down = length(assess_res.nb_tone.down_down);
    for i=1:nb_tones.down_down
        delays.downdown.down = [delays.downdown.down ; assess_res.delays.downdown.down{p,i}/10];
        delays.downdown.up = [delays.downdown.up ; assess_res.delays.downdown.up{p,i}/10];
    end
end


%% Distrib

%up>down
[tones.updown.down.y_distrib, tones.updown.down.x_distrib] = histcounts(delays.updown.down, edges,'Normalization',normalization);
tones.updown.down.x_distrib = tones.updown.down.x_distrib(1:end-1) + diff(tones.updown.down.x_distrib);

[tones.updown.up.y_distrib, tones.updown.up.x_distrib] = histcounts(delays.updown.up, edges,'Normalization',normalization);
tones.updown.up.x_distrib = tones.updown.up.x_distrib(1:end-1) + diff(tones.updown.up.x_distrib);

%up>up
[tones.upup.down.y_distrib, tones.upup.down.x_distrib] = histcounts(delays.upup.down, edges,'Normalization',normalization);
tones.upup.down.x_distrib = tones.upup.down.x_distrib(1:end-1) + diff(tones.upup.down.x_distrib);

[tones.upup.up.y_distrib, tones.upup.up.x_distrib] = histcounts(delays.upup.up, edges,'Normalization',normalization);
tones.upup.up.x_distrib = tones.upup.up.x_distrib(1:end-1) + diff(tones.upup.up.x_distrib);

%down>up
[tones.downup.down.y_distrib, tones.downup.down.x_distrib] = histcounts(delays.downup.down, edges,'Normalization',normalization);
tones.downup.down.x_distrib = tones.downup.down.x_distrib(1:end-1) + diff(tones.downup.down.x_distrib);

[tones.downup.up.y_distrib, tones.downup.up.x_distrib] = histcounts(delays.downup.up, edges,'Normalization',normalization);
tones.downup.up.x_distrib = tones.downup.up.x_distrib(1:end-1) + diff(tones.downup.up.x_distrib);

%down>down
[tones.downdown.down.y_distrib, tones.downdown.down.x_distrib] = histcounts(delays.downdown.down, edges,'Normalization',normalization);
tones.downdown.down.x_distrib = tones.downdown.down.x_distrib(1:end-1) + diff(tones.downdown.down.x_distrib);

[tones.downdown.up.y_distrib, tones.downdown.up.x_distrib] = histcounts(delays.downdown.up, edges,'Normalization',normalization);
tones.downdown.up.x_distrib = tones.downdown.up.x_distrib(1:end-1) + diff(tones.downdown.up.x_distrib);


%% DATA TO PLOT
if stairsplot
    %up>down
    [tones.updown.down.x_plot, tones.updown.down.y_plot] = stairs(tones.updown.down.x_distrib, tones.updown.down.y_distrib);
    [tones.updown.up.x_plot, tones.updown.up.y_plot] = stairs(tones.updown.up.x_distrib, tones.updown.up.y_distrib);
    
    %up>up
    [tones.upup.down.x_plot, tones.upup.down.y_plot] = stairs(tones.upup.down.x_distrib, tones.upup.down.y_distrib);
    [tones.upup.up.x_plot, tones.upup.up.y_plot] = stairs(tones.upup.up.x_distrib, tones.upup.up.y_distrib);
    
    %down>up
    [tones.downup.down.x_plot, tones.downup.down.y_plot] = stairs(tones.downup.down.x_distrib, tones.downup.down.y_distrib);
    [tones.downup.up.x_plot, tones.downup.up.y_plot] = stairs(tones.downup.up.x_distrib, tones.downup.up.y_distrib);
    
    %down>down
    [tones.downdown.down.x_plot, tones.downdown.down.y_plot] = stairs(tones.downdown.down.x_distrib, tones.downdown.down.y_distrib);
    [tones.downdown.up.x_plot, tones.downdown.up.y_plot] = stairs(tones.downdown.up.x_distrib, tones.downdown.up.y_distrib);
    
else
    %up>down
    tones.updown.down.x_plot = tones.updown.down.x_distrib;
    tones.updown.down.y_plot = Smooth(tones.updown.down.y_distrib, smoothing);
    tones.updown.up.x_plot = tones.updown.up.x_distrib;
    tones.updown.up.y_plot = Smooth(tones.updown.up.y_distrib, smoothing);
    
    %up>up
    tones.upup.down.x_plot = tones.upup.down.x_distrib;
    tones.upup.down.y_plot = Smooth(tones.upup.down.y_distrib, smoothing);
    tones.upup.up.x_plot = tones.upup.up.x_distrib;
    tones.upup.up.y_plot = Smooth(tones.upup.up.y_distrib, smoothing);
    
    %down>up
    tones.downup.down.x_plot = tones.downup.down.x_distrib;
    tones.downup.down.y_plot = Smooth(tones.downup.down.y_distrib, smoothing);
    tones.downup.up.x_plot = tones.downup.up.x_distrib;
    tones.downup.up.y_plot = Smooth(tones.downup.up.y_distrib, smoothing);
    
    %down>down
    tones.downdown.down.x_plot = tones.downdown.down.x_distrib;
    tones.downdown.down.y_plot = Smooth(tones.downdown.down.y_distrib, smoothing);
    tones.downdown.up.x_plot = tones.downdown.up.x_distrib;
    tones.downdown.up.y_plot = Smooth(tones.downdown.up.y_distrib, smoothing);
    
end


%% PLOT
figure, hold on

%UPDOWN Transitions - Down occurence 
subplot(4,2,1), hold on
plot(tones.updown.down.x_plot, tones.updown.down.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Down around up>down')

%UPDOWN Transitions - Up occurence
subplot(4,2,2), hold on
plot(tones.updown.up.x_plot, tones.updown.up.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Up around up>down')

%UPUP - Down occurence 
subplot(4,2,3), hold on
plot(tones.upup.down.x_plot, tones.upup.down.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Down around up>up')

%UPUP - Up occurence
subplot(4,2,4), hold on
plot(tones.upup.up.x_plot, tones.upup.up.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Up around up>up')

%DOWNUP Transitions - Down occurence 
subplot(4,2,5), hold on
plot(tones.downup.down.x_plot, tones.downup.down.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Down around down>up')

%DOWNUP Transitions - Up occurence
subplot(4,2,6), hold on
plot(tones.downup.up.x_plot, tones.downup.up.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Up around down>up')

%DOWNDOWN - Down occurence 
subplot(4,2,7), hold on
plot(tones.downdown.down.x_plot, tones.downdown.down.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Down around down>down')

%DOWNDOWN - Up occurence
subplot(4,2,8), hold on
plot(tones.downdown.up.x_plot, tones.downdown.up.y_plot, 'color', 'k', 'LineWidth',2); hold on,
ylabel(normalization)
set(gca,'XTick',-max_edge:2500:max_edge,'XLim',[-max_edge max_edge],'FontName','Times'), hold on,
line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
title('Up around down>down')

