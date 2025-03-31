%%ScriptTransitionUpDownOneNight
% 08.07.2019 KJ
%
% effect of tones/sham on transitions and up&down durations
%
%   see 
%       Fig2TonesUpDownDurationTransitions 
%


% clear

%% init

%params
binsize_mua = 2; %2ms
minDurationDown = 75;
minDurationUp = 0;
maxDurationUp = 30e4;

range_down = [0 60]*10;   % [0-50ms] after tone in Down
range_up = [30 110]*10;    % [0-100ms] after tone in Up
intv_success = 0.2e4;

%params plot

%durations
hstep = 2;
max_edge_down = 400;
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


%substages
load('SleepSubstages.mat')
NREM = CleanUpEpoch(or(Epoch{1},or(Epoch{2},Epoch{3})));


%% MUA
[MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

%Down
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down   = Start(down_PFCx);
end_down  = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp); %sec
up_PFCx = dropShortIntervals(up_PFCx, minDurationUp); %sec
up_PFCx = and(up_PFCx, NREM);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);


%% Tones
load('behavResources.mat', 'ToneEvent')
tones_tmp = Range(ToneEvent);    

ToneDown      = Restrict(ToneEvent, down_PFCx);
tonesdown_tmp = Range(ToneDown);
IntvToneDown  = intervalSet(tonesdown_tmp+range_down(1),tonesdown_tmp+range_down(2));
    
ToneUp      = Restrict(ToneEvent, up_PFCx);
tonesup_tmp = Range(ToneUp);
IntvToneUp  = intervalSet(tonesup_tmp+range_up(1),tonesup_tmp+range_up(2)); 


%% durations

%Down without tone around
intv_down = [st_down-intv_success end_down];
[~,intervals,~] = InIntervals(tones_tmp, intv_down);
intervals = unique(intervals);
idx_down = setdiff(1:length(st_down), intervals);
DownNotone = intervalSet(st_down(idx_down), end_down(idx_down));

%Up without tone around
intv_up = [st_up-intv_success end_up];
[~,intervals,~] = InIntervals(tones_tmp, intv_up);
intervals = unique(intervals);
idx_up = setdiff(1:length(st_up), intervals);
UpNotone = intervalSet(st_up(idx_up), end_up(idx_up));

durations_down = (End(DownNotone) - Start(DownNotone))/10; 
durations_up   = (End(UpNotone) - Start(UpNotone))/10; 

%distrib
[durations.down.y_distrib, durations.down.x_distrib] = histcounts(durations_down, edges_down,'Normalization',normalization1);
durations.down.x_distrib = durations.down.x_distrib(1:end-1) + diff(durations.down.x_distrib);

[durations.up.y_distrib, durations.up.x_distrib] = histcounts(durations_up, edges_up,'Normalization',normalization1);
durations.up.x_distrib = durations.up.x_distrib(1:end-1) + diff(durations.up.x_distrib);



%% Create Sham 

%down
nb_sham = 1000;
idx = randsample(length(st_down), nb_sham);
shamdown_tmp = [];
for i=1:length(idx)
    min_tmp = st_down(idx(i));
    duree = end_down(idx(i))-st_down(idx(i));
    shamdown_tmp = [shamdown_tmp min_tmp+rand(1)*duree];
end
shamdown_tmp = sort(shamdown_tmp);

ShamDown = ts(shamdown_tmp);
IntvShamDown  = intervalSet(shamdown_tmp+range_down(1),shamdown_tmp+range_down(2));

%up
nb_sham = 2000;
idx = randsample(length(st_up), nb_sham);
shamup_tmp = [];
for i=1:length(idx)
    min_tmp = st_up(idx(i));
    duree = end_up(idx(i))-st_up(idx(i));
    shamup_tmp = [shamup_tmp min_tmp+rand(1)*duree];
end
shamup_tmp = sort(shamup_tmp);
    
ShamUp = ts(shamup_tmp);
IntvShamUp  = intervalSet(shamup_tmp+range_up(1),shamup_tmp+range_up(2));


%% Tones and delay    

%tones in
tonesdown_tmp = Range(ToneDown);
delay_tonedown = zeros(length(tonesdown_tmp), 1);
for i=1:length(tonesdown_tmp)
    idx = find(end_down > tonesdown_tmp(i), 1);
    delay_tonedown(i) = end_down(idx) - tonesdown_tmp(i);
end
tones.inside.delay = delay_tonedown/10;
y_data = tones.inside.delay(tones.inside.delay<max_edge_in);

[tones.inside.y_distrib, tones.inside.x_distrib] = histcounts(y_data, edges_out,'Normalization',normalization2);
tones.inside.x_distrib = tones.inside.x_distrib(1:end-1) + diff(tones.inside.x_distrib);

%tones out
tonesup_tmp = Range(ToneUp);
delay_toneup = zeros(length(tonesup_tmp), 1);
for i=1:length(tonesup_tmp)
    idx = find(st_down > tonesup_tmp(i), 1);
    delay_toneup(i) = st_down(idx) - tonesup_tmp(i);
end
tones.outside.delay = delay_toneup/10;
y_data = tones.outside.delay(tones.outside.delay<max_edge_out);

[tones.outside.y_distrib, tones.outside.x_distrib] = histcounts(y_data, edges_out,'Normalization',normalization2);
tones.outside.x_distrib = tones.outside.x_distrib(1:end-1) + diff(tones.outside.x_distrib);


%sham in
delay_shamdown = zeros(length(shamdown_tmp), 1);
for i=1:length(shamdown_tmp)
    idx = find(end_down > shamdown_tmp(i), 1);
    delay_shamdown(i) = end_down(idx) - shamdown_tmp(i);
end
sham.inside.delay = delay_shamdown/10;
y_data = sham.inside.delay(sham.inside.delay<max_edge_in);

[sham.inside.y_distrib, sham.inside.x_distrib] = histcounts(y_data, edges_out,'Normalization',normalization2);
sham.inside.x_distrib = sham.inside.x_distrib(1:end-1) + diff(sham.inside.x_distrib);


%sham out
delay_shamup = zeros(length(shamup_tmp), 1);
for i=1:length(shamup_tmp)
    idx = find(st_down > shamup_tmp(i), 1);
    delay_shamup(i) = st_down(idx) - shamup_tmp(i);
end
sham.outside.delay = delay_shamup/10;
y_data = sham.outside.delay(sham.outside.delay<max_edge_out);

[sham.outside.y_distrib, sham.outside.x_distrib] = histcounts(y_data, edges_out,'Normalization',normalization2);
sham.outside.x_distrib = sham.outside.x_distrib(1:end-1) + diff(sham.outside.x_distrib);




%% Tones and transitions
    
%Tones in Down
transit_res.tones.down.nb = length(ToneDown);
transit_res.tones.down.delay = nan(length(tonesdown_tmp), 1);
transit_res.tones.down.success = zeros(length(tonesdown_tmp), 1);
%delay
for i=1:length(tonesdown_tmp)
    try
        idx_bef = find(st_down < tonesdown_tmp(i), 1,'last');
        transit_res.tones.down.delay(i) = tonesdown_tmp(i) - st_down(idx_bef);    
    end
end
%success
intv = [Start(IntvToneDown) End(IntvToneDown)];
[~,intervals,~] = InIntervals(end_down, intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
transit_res.tones.down.success(intervals) = 1;
for i=1:length(delay_down)-1
    tones.down.induce{i} = transit_res.tones.down.success(transit_res.tones.down.delay/10>=delay_down(i) & transit_res.tones.down.delay/10<delay_down(i+1))*100;
end


%Tones in Up
transit_res.tones.up.nb = length(ToneUp);
transit_res.tones.up.delay = nan(length(tonesup_tmp), 1);
transit_res.tones.up.success = zeros(length(tonesup_tmp), 1);
%delay
for i=1:length(tonesup_tmp)
    try
        idx_bef = find(st_up < tonesup_tmp(i), 1,'last');
        transit_res.tones.up.delay(i) = tonesup_tmp(i) - st_up(idx_bef);    
    end
end
%success
intv = [Start(IntvToneUp) End(IntvToneUp)];
[~,intervals,~] = InIntervals(st_down, intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
transit_res.tones.up.success(intervals) = 1;
for i=1:length(delay_up)-1
    tones.up.induce{i} = transit_res.tones.up.success(transit_res.tones.up.delay/10>=delay_up(i) & transit_res.tones.up.delay/10<delay_up(i+1))*100;
end


%% Sham and transitions

%Sham in Down
transit_res.sham.down.nb = length(shamdown_tmp);
transit_res.sham.down.delay = nan(length(shamdown_tmp), 1);
transit_res.sham.down.success = zeros(length(shamdown_tmp), 1);

%delay
for i=1:length(shamdown_tmp)
    try
        idx_bef = find(st_down < shamdown_tmp(i), 1,'last');
        transit_res.sham.down.delay(i) = shamdown_tmp(i) - st_down(idx_bef);    
    end
end

%success
intv = [Start(IntvShamDown) End(IntvShamDown)];
[~,intervals,~] = InIntervals(end_down, intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
transit_res.sham.down.success(intervals) = 1;
for i=1:length(delay_down)-1
    sham.down.induce{i} = transit_res.sham.down.success(transit_res.sham.down.delay/10>=delay_down(i) & transit_res.sham.down.delay/10<delay_down(i+1))*100;
end

%Sham in Up
transit_res.sham.up.nb = length(shamup_tmp);
transit_res.sham.up.delay = nan(length(shamup_tmp), 1);
transit_res.sham.up.success = zeros(length(shamup_tmp), 1);

%delay
for i=1:length(shamup_tmp)
    try
        idx_bef = find(st_up < shamup_tmp(i), 1,'last');
        transit_res.sham.up.delay(i) = shamup_tmp(i) - st_up(idx_bef);    
    end
end

%success
intv = [Start(IntvShamUp) End(IntvShamUp)];
[~,intervals,~] = InIntervals(st_down, intv);
intervals(intervals==0)=[];
intervals = unique(intervals);
transit_res.sham.up.success(intervals) = 1;
for i=1:length(delay_up)-1
    sham.up.induce{i} = transit_res.sham.up.success(transit_res.sham.up.delay/10>=delay_up(i) & transit_res.sham.up.delay/10<delay_up(i+1))*100;
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


