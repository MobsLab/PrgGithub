%%AnalyzeDeltavsDownDetection
% 20.03.2018 KJ
%
%   Understand difference between delta and down detection 
%
% see
%   
%


clear
%params
binsize_mua = 5;
binsize_met = 5;
nbBins_met = 240;

intvDur_deep = 0; %50ms
intvDur_sup = 2000; %200ms
intvDur = intvDur_deep;

smoothing = 1;
windowsize = 60E4; %60s

foldername = pwd;


%% load
load(fullfile(foldername, 'IdFigureData2.mat'), 'night_duration')

%down
load(fullfile(foldername, 'DownState.mat'), 'down_PFCx')
down_tmp = (Start(down_PFCx)+End(down_PFCx)) / 2;

%MUA
try
    load(fullfile(foldername,'SpikesToAnalyse','PFCx_down.mat'), 'number')
catch
    load(fullfile(foldername,'SpikesToAnalyse','PFCx_Neurons.mat'), 'number')
end
NumNeurons=number;
load(fullfile(foldername,'SpikeData.mat'), 'S')  
if isa(S,'tsdArray')
    MUA = MakeQfromS(S(NumNeurons), binsize_mua*10);
else
    MUA = MakeQfromS(tsdArray(S(NumNeurons)),binsize_mua*10);
end
MUA = tsd(Range(MUA), sum(full(Data(MUA)),2));

%delta
load(fullfile(foldername, 'DeltaWaves.mat'), 'deltas_PFCx')
deltas_tmp = (Start(deltas_PFCx)+End(deltas_PFCx)) / 2;

%Load PFCx LFP
load('ChannelsToAnalyse/PFCx_locations.mat')
Signals = cell(0);
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch))])
    Signals{ch} = LFP; clear LFP
end


%deep
if exist('ChannelsToAnalyse/PFCx_deltadeep','file')==2
    load ChannelsToAnalyse/PFCx_deltadeep
else
    load ChannelsToAnalyse/PFCx_deep
end
id_deep = find(channels==channel);
%sup
if exist('ChannelsToAnalyse/PFCx_deltasup','file')==2
    load ChannelsToAnalyse/PFCx_deltasup
else
    load ChannelsToAnalyse/PFCx_sup
end
id_sup = find(channels==channel);    
%Diff signal
DIFFdeep = Signals{id_deep};
DIFFsup = Signals{id_sup};
k=1;
for i=0.1:0.1:4
    distance(k)=std(Data(DIFFdeep)-i*Data(DIFFsup));
    k=k+1;
end
Factor=find(distance==min(distance))*0.1;
% Difference between EEG deep and EEG sup (*factor)
LFPdiff = tsd(Range(DIFFdeep),Data(DIFFdeep) - Factor*Data(DIFFsup));


%intervals
intervals_start = 0:windowsize:night_duration;    
x_intv = (intervals_start + windowsize/2)/(3600E4);
x_intv = x_intv';

%% Density

%down density
down_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    down_density(t) = length(Restrict(ts(down_tmp),intv))/60; %per sec
end
down_density = Smooth(down_density, smoothing);


%deltas density
delta_density = zeros(length(intervals_start),1);
for t=1:length(intervals_start)
    intv = intervalSet(intervals_start(t),intervals_start(t) + windowsize);
    delta_density(t) = length(Restrict(ts(deltas_tmp),intv))/60; %per sec
end        
delta_density = Smooth(delta_density, smoothing);


%similarity
ratio_decrease   = CompareDecreaseDensity(down_density, delta_density, x_intv);
frechet_distance = DiscreteFrechetDist(down_density, delta_density);


%regression & slope
idx_down = down_density > max(down_density)/8;
idx_delta = delta_density > max(delta_density)/8;

[p_down,~]  = polyfit(x_intv(idx_down), down_density(idx_down), 1);
reg_down    = polyval(p_down,x_intv);
[p_delta,~] = polyfit(x_intv(idx_delta), delta_density(idx_delta), 1);
reg_delta   = polyval(p_delta,x_intv);


%% Recall & precision
larger_delta_epochs = [Start(deltas_PFCx)-intvDur, End(deltas_PFCx)+intvDur];
[status, intervals, ~] = InIntervals(down_tmp,larger_delta_epochs);
intervals = unique(intervals); intervals(intervals==0)=[];

% count
down_delta = sum(status);
down_only = length(down_tmp) - down_delta;
delta_only = length(Start(deltas_PFCx)) - down_delta;


clear both only 
both.deltas.intv = subset(deltas_PFCx, intervals);
both.down.intv = subset(down_PFCx, find(status));
only.deltas.intv = subset(deltas_PFCx, setdiff(1:length(deltas_tmp), intervals));
only.down.intv = subset(down_PFCx, find(~status));


%% Meancurves in both detection vs alone detection

%mua
event_tmp = Start(both.deltas.intv);
[m,~,tps] = mETAverage(event_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
both.deltas.mua(:,1) = tps; both.deltas.mua(:,2) = m;

event_tmp = Start(both.down.intv);
[m,~,tps] = mETAverage(event_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
both.down.mua(:,1) = tps; both.down.mua(:,2) = m;

event_tmp = Start(only.deltas.intv);
[m,~,tps] = mETAverage(event_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
only.deltas.mua(:,1) = tps; only.deltas.mua(:,2) = m;

event_tmp = Start(only.down.intv);
[m,~,tps] = mETAverage(event_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
only.down.mua(:,1) = tps; only.down.mua(:,2) = m;

%lfp
for ch=1:length(channels)
    ldg_ch{ch} = ['ch ' num2str(channels(ch))];

    event_tmp = Start(both.deltas.intv);
    [m,~,tps] = mETAverage(event_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    both.deltas.pfc{ch}(:,1) = tps; both.deltas.pfc{ch}(:,2) = m;

    event_tmp = Start(only.deltas.intv);
    [m,~,tps] = mETAverage(event_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    only.deltas.pfc{ch}(:,1) = tps; only.deltas.pfc{ch}(:,2) = m;

    event_tmp = Start(only.down.intv);
    [m,~,tps] = mETAverage(event_tmp, Range(Signals{ch}), Data(Signals{ch}), binsize_met, nbBins_met);
    only.down.pfc{ch}(:,1) = tps; only.down.pfc{ch}(:,2) = m;

end



%% Stat on detection

lgd_stat = {'Both', 'deltas alone', 'down alone'};

%duration
duration_events{1} = End(both.down.intv) - Start(both.down.intv);
duration_events{2} = End(only.deltas.intv) - Start(only.deltas.intv);
duration_events{3} = End(only.down.intv) - Start(only.down.intv);

%amplitude
func_max = @(a) measureOnSignal(a,'maximum');
[delta_max{1}, ~, ~] = functionOnEpochs(LFPdiff, both.down.intv, func_max);
[delta_max{2}, ~, ~] = functionOnEpochs(LFPdiff, only.deltas.intv, func_max);
[delta_max{3}, ~, ~] = functionOnEpochs(LFPdiff, only.down.intv, func_max);

func_mean = @(a) measureOnSignal(a,'mean');
[delta_mean{1}, ~, ~] = functionOnEpochs(LFPdiff, both.down.intv, func_mean);
[delta_mean{2}, ~, ~] = functionOnEpochs(LFPdiff, only.deltas.intv, func_mean);
[delta_mean{3}, ~, ~] = functionOnEpochs(LFPdiff, only.down.intv, func_mean);


%% PLOT

%density
figure, hold on
h(1) = plot(x_intv, down_density, 'color', 'b'); hold on
plot(x_intv, reg_down, 'color', 'b'), hold on
h(2) = plot(x_intv, delta_density, 'color', 'r'); hold on
plot(x_intv, reg_delta, 'color', 'r'),

title_fig = [];
title_fig = [title_fig 'down: ' num2str(down_only)];
title_fig = [title_fig ' - delta: ' num2str(delta_only)];
title_fig = [title_fig ' - both: ' num2str(down_delta)];
title_fig = [title_fig ' - Dist: ' num2str(round(frechet_distance,3))];
title(title_fig)


%
figure, hold on
gap=0.03;


%LFP on delta and down together
subtightplot(2,4,1,gap), hold on
for ch=1:length(channels)
    mb(ch) = plot(both.deltas.pfc{ch}(:,1), both.deltas.pfc{ch}(:,2)); hold on
end
xlim([-400 500]), ylim([-1000 2000]), title('LFP on coupled detection'), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
legend(mb, ldg_ch)

%LFP on delta alone
subtightplot(2,4,2,gap), hold on
for ch=1:length(channels)
    mdl(ch) = plot(only.deltas.pfc{ch}(:,1), only.deltas.pfc{ch}(:,2)); hold on
end
xlim([-400 500]), ylim([-1000 2000]), title('LFP on deltas alone'), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
legend(mdl, ldg_ch)

%LFP on down alone
subtightplot(2,4,3,gap), hold on
for ch=1:length(channels)
    mdw(ch) = plot(only.down.pfc{ch}(:,1), only.down.pfc{ch}(:,2)); hold on
end
xlim([-400 500]), ylim([-1000 2000]), title('LFP on down alone'), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
legend(mdw, ldg_ch)


%firing rate - delta alone
subtightplot(2,4,4,gap), hold on
mfr(1) = plot(both.deltas.mua(:,1), both.deltas.mua(:,2), 'color',[0 1 0]); hold on
mfr(2) = plot(only.deltas.mua(:,1), only.deltas.mua(:,2), 'r'); hold on
mfr(3) = plot(only.down.mua(:,1), only.down.mua(:,2), 'b'); hold on

xlim([-400 500]), title('Mean Firing rate on detections'), hold on
line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6])
legend(mfr, {'Both ','deltas alone', 'down alone'})


%durations
subtightplot(2,4,5,gap), hold on
PlotErrorBarN_KJ(duration_events, 'newfig',0, 'barcolors',{[0 1 0],'r','b'}, 'paired',0, 'showpoints',0,'ShowSigstar','sig');
set(gca,'xtick',1:length(lgd_stat),'XtickLabel',lgd_stat)
title('Durations')

%amplitude
subtightplot(2,4,6,gap), hold on
PlotErrorBarN_KJ(delta_max, 'newfig',0, 'barcolors',{[0 1 0],'r','b'}, 'paired',0, 'showpoints',0,'ShowSigstar','sig');
set(gca,'xtick',1:length(lgd_stat),'XtickLabel',lgd_stat)
title('Amplitude max')
%amplitude
subtightplot(2,4,7,gap), hold on
PlotErrorBarN_KJ(delta_mean, 'newfig',0, 'barcolors',{[0 1 0],'r','b'}, 'paired',0, 'showpoints',0,'ShowSigstar','sig');
set(gca,'xtick',1:length(lgd_stat),'XtickLabel',lgd_stat)
title('Amplitude mean')


