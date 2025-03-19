%%ScriptRefractoryPeriodOneNight
% 17.07.2019 KJ
%
%
%   see 
%       ProbabilityTonesUpDownTransition DeltaToneRefractoryPeriodAnalysis


clearvars -except Dir p

effectperiod  = GetEffectPeriodDeltaTone(Dir);

%params
minDurationDown = 0.05e4;
minDurationUp = 0.1e4;
maxDurationUp = 30e4;

range_up = [30 110]*10;
delay_up = 0:20:500;
x_up = delay_up(1:end-1) + diff(delay_up);

hstep = 10;
max_edge = 500;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay = 200;
proba_max = 0.046;


%% load

%tones
load('behavResources.mat', 'ToneEvent')
%Delta waves
delta_PFCx = GetDeltaWaves;
start_deltas = Start(delta_PFCx);
end_deltas = End(delta_PFCx);

%substages
load('SleepSubstages.mat')
NREM = CleanUpEpoch(or(Epoch{2},Epoch{3}));

%Down
load('DownState.mat', 'down_PFCx')
down_PFCx = dropShortIntervals(down_PFCx, minDurationDown); %sec
down_PFCx = and(down_PFCx, NREM);
st_down   = Start(down_PFCx);
end_down  = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropShortIntervals(up_PFCx, minDurationUp); %sec
up_PFCx = and(up_PFCx, NREM);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);

%% Tones in or out
ToneUp      = Restrict(ToneEvent, up_PFCx);
tonesup_tmp = Range(ToneUp);
IntvToneUp  = intervalSet(tonesup_tmp+range_up(1),tonesup_tmp+range_up(2)); 
tone_intv_post = intervalSet(tonesup_tmp+effectperiod(p,1), tonesup_tmp+effectperiod(p,2));  % Tone and its window where an effect could be observed
nb_tones  = length(tonesup_tmp);



%% Sound and delay    

%delta
delay_nextdelta = nan(nb_tones, 1);
for i=1:nb_tones
    idx_nextdelta = find(start_deltas > tonesup_tmp(i), 1);
    delay_nextdelta(i) = (start_deltas(idx_nextdelta) - tonesup_tmp(i))/10;    
end
[nextdelta.histo.y, nextdelta.histo.x] = histcounts(delay_nextdelta, edges, 'Normalization','probability');
nextdelta.histo.x = nextdelta.histo.x(1:end-1) + diff(nextdelta.histo.x);

%down
delay_nextdown = nan(nb_tones, 1);
for i=1:nb_tones
    idx_nextdown = find(st_down > tonesup_tmp(i), 1);
    delay_nextdown(i) = (st_down(idx_nextdown) - tonesup_tmp(i))/10;    
end
[nextdown.histo.y, nextdown.histo.x] = histcounts(delay_nextdown, edges, 'Normalization','probability');
nextdown.histo.x = nextdown.histo.x(1:end-1) + diff(nextdown.histo.x);


%% Transitions for Down State
%Tones in Up
transit_res.tones.up.nb = length(ToneUp);
delay_mouse = nan(length(tonesup_tmp), 1);

%delay
for i=1:length(tonesup_tmp)
    try
        idx_bef = find(st_up < tonesup_tmp(i), 1,'last');
        delay_mouse(i) = (tonesup_tmp(i) - st_up(idx_bef)) / 10; %ms    
    end
end

%success
success_mouse = zeros(length(tonesup_tmp), 1);
[~,intervals,~] = InIntervals(st_down, [Start(IntvToneUp) End(IntvToneUp)]);
intervals = unique(intervals);
success_mouse(intervals(2:end)) = 1;

for i=1:length(delay_up)-1
    mouse_induce_up(i) = mean(success_mouse(delay_mouse>=delay_up(i) & delay_mouse<delay_up(i+1))*100);
end


%% Transitions for Delta waves
%delay
delay_delta_tone = zeros(nb_tones, 1);
for i=1:nb_tones
    idx_delta_before = find(end_deltas < tonesup_tmp(i), 1,'last');
    delay_delta_tone(i) = (tonesup_tmp(i) - end_deltas(idx_delta_before))/10;    
end        

% INDUCE a delta waves ?
induce_delta = zeros(nb_tones, 1);
[~,interval,~] = InIntervals(start_deltas, [Start(tone_intv_post) End(tone_intv_post)]);
tone_success = unique(interval);
induce_delta(tone_success(2:end)) = 1;  %do not consider the first nul element

for i=1:length(delay_up)-1
    mouse_induce_delta(i) = mean(induce_delta(delay_delta_tone>=delay_up(i) & delay_delta_tone<delay_up(i+1))*100);
end


%% DATA to plot
binsize = 0.01;

[nextdelta.plot.x, nextdelta.plot.y] = stairs(nextdelta.histo.x, nextdelta.histo.y);
[nextdown.plot.x, nextdown.plot.y] = stairs(nextdown.histo.x, nextdown.histo.y);


%% PLOT
figure, hold on
fontsize = 12;

%Delta delay distribution
subplot(2,2,1), hold on
plot(nextdelta.plot.x, nextdelta.plot.y, 'b', 'LineWidth',4); hold on,

%Down delay distribution
subplot(2,2,2), hold on
plot(nextdown.plot.x, nextdown.plot.y, 'r', 'LineWidth',4); hold on,


%Probability delta waves
subplot(2,2,3), hold on
[~,h(1)]=PlotErrorLineN_KJ(mouse_induce_delta,'x_data',x_up,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Up start and tones/sham'), ylabel('%')
set(gca,'XTick',0:200:max(delay_up),'XLim',[0 max(delay_up)],'Ylim', [0 100], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of delta waves induced')

%Probability transitions up>down
subplot(2,2,4), hold on
[~,h(1)]=PlotErrorLineN_KJ(mouse_induce_up,'x_data',x_up,'newfig',0,'linecolor','b','ShowSigstar','none','errorbars',1,'linespec','-.');
xlabel('delay (ms) between Up start and tones/sham'), ylabel('%')
set(gca,'XTick',0:200:max(delay_up),'XLim',[0 max(delay_up)],'Ylim', [0 100], 'FontName','Times','Fontsize',fontsize), hold on,
title('Probability of up>down transition')




