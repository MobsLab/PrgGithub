%%ScriptTonesOnDeltaWavesEffect
% 03.10.2018 KJ
%
% effect of tones in down states and delta waves
%
%   see 
%       FigTonesInDownN2N3 TonesInDownN2N3Effect
%

clear

% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244
% cd /media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243

%params
binsize_met = 5;
nbBins_met  = 200;
range_down = [0 50]*10;   % [0-50ms] after tone in Down
range_up = [30 100]*10;    % [30-100ms] after tone in Up
binsize_mua = 2;

minDuration = 40;
maxDuration = 30e4;

%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
%Up
up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);


%delta waves
load('DeltaWaves.mat', 'deltas_PFCx')

%tones
load('behavResources.mat', 'ToneEvent')
tones_res.nb_tones = length(ToneEvent);

%substages
load('SleepSubstages.mat','Epoch')
N2 = Epoch{2} ; N3 = Epoch{3};
NREM = or(or(N2,N3), Epoch{1});



%% LFP PFCx

labels_ch = cell(0);
PFC = cell(0);

load('ChannelsToAnalyse/PFCx_locations.mat')
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
    
    labels_ch{ch} = ['Ch ' num2str(channels(ch))];
end

%color
colori = distinguishable_colors(length(labels_ch));
for ch=1:length(labels_ch)
    colori_ch{ch} = colori(ch,:);
end

%% LFP others

labels_ch2 = cell(0);
LFPs = cell(0);
labels_ch2 = {'dHPC_rip', 'dHPC_sup', 'NRT_deep', 'NRT_sup','Bulb_deep','Bulb_sup'};

for ch=1:length(labels_ch2)
    load(['ChannelsToAnalyse/' labels_ch2{ch} '.mat'])
    load(['LFPData/LFP' num2str(channel) '.mat'])
    LFPs{ch} = LFP; clear LFP
end

%color
colori = distinguishable_colors(length(labels_ch2));
for ch=1:length(labels_ch2)
    colori_ch2{ch} = colori(ch,:);
end



%% Tones in down
ToneDown = Restrict(Restrict(ToneEvent, NREM), down_PFCx);
IntvTransitDown  = intervalSet(Range(ToneDown)+range_down(1), Range(ToneDown)+range_down(2));

%transition ?
intv = [Start(IntvTransitDown) End(IntvTransitDown)];
[~,intervals,~] = InIntervals(end_down, intv);
intervals(intervals==0)=[];

success_idx = unique(intervals);
failed_idx = setdiff(1:length(ToneDown), success_idx);

%class of tones
tones_down = Range(ToneDown);
success_down = tones_down(success_idx);
failed_down = tones_down(failed_idx);

%% Tones in up
ToneUp = Restrict(Restrict(ToneEvent, NREM), up_PFCx);
IntvTransitUp = intervalSet(Range(ToneUp)+range_up(1), Range(ToneUp)+range_up(2));

%transition ?
intv = [Start(IntvTransitUp) End(IntvTransitUp)];
[~,intervals,~] = InIntervals(end_up, intv);
intervals(intervals==0)=[];

success_idx = unique(intervals);
failed_idx = setdiff(1:length(ToneUp), success_idx);

%class of tones
tones_up = Range(ToneUp);
success_up = tones_up(success_idx);
failed_up = tones_up(failed_idx);



%% mean curves on delta waves on PFCx

%Success
for ch=1:length(PFC)
    %down
    [m,~,tps] = mETAverage(success_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    x_success.down{ch} = tps; y_success.down{ch} = m; 
    %up
    [m,~,tps] = mETAverage(success_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    x_success.up{ch} = tps; y_success.up{ch} = m; 
    
end

%Failed
for ch=1:length(PFC)
    %down
    [m,~,tps] = mETAverage(failed_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    x_failed.down{ch} = tps; y_failed.down{ch} = m; 
    %up
    [m,~,tps] = mETAverage(failed_up, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    x_failed.up{ch} = tps; y_failed.up{ch} = m; 
end


%% mean curves on delta waves on HPC and NRT

%Success
for ch=1:length(LFPs)
    %down
    [m,~,tps] = mETAverage(success_down, Range(LFPs{ch}), Data(LFPs{ch}), binsize_met, nbBins_met);
    x_success2.down{ch} = tps; y_success2.down{ch} = m; 
    %up
    [m,~,tps] = mETAverage(success_up, Range(LFPs{ch}), Data(LFPs{ch}), binsize_met, nbBins_met);
    x_success2.up{ch} = tps; y_success2.up{ch} = m; 
end

%Failed
for ch=1:length(LFPs)
    %down
    [m,~,tps] = mETAverage(failed_down, Range(LFPs{ch}), Data(LFPs{ch}), binsize_met, nbBins_met);
    x_failed2.down{ch} = tps; y_failed2.down{ch} = m; 
    %up
    [m,~,tps] = mETAverage(failed_up, Range(LFPs{ch}), Data(LFPs{ch}), binsize_met, nbBins_met);
    x_failed2.up{ch} = tps; y_failed2.up{ch} = m; 
end



%% plot
figure, hold on

%PFC down>up
subplot(2,2,1), hold on
for ch=1:length(labels_ch)
    h(ch) = plot(x_success.down{ch}, y_success.down{ch}, 'color', colori_ch{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch);
title('Tones down>up')

%PFC down>down
subplot(2,2,2), hold on
for ch=1:length(labels_ch)
    h(ch) = plot(x_failed.down{ch}, y_failed.down{ch}, 'color', colori_ch{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch);
title('Tones down>down')
 
%PFC up>up
subplot(2,2,3), hold on
for ch=1:length(labels_ch)
    h(ch) = plot(x_failed.up{ch}, y_failed.up{ch}, 'color', colori_ch{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch);
title('Tones up>up')

%PFC up>down
subplot(2,2,4), hold on
for ch=1:length(labels_ch)
    h(ch) = plot(x_success.up{ch}, y_success.up{ch}, 'color', colori_ch{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch);
title('Tones up>down')


suplabel('PFC signals','t');

%% Plot 2
figure, hold on

%down>up
subplot(2,2,1), hold on
for ch=1:length(labels_ch2)
    h(ch) = plot(x_success2.down{ch}, y_success2.down{ch}, 'color', colori_ch2{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch2);
title('Tones down>up')

%down>down
subplot(2,2,2), hold on
for ch=1:length(labels_ch2)
    h(ch) = plot(x_failed2.down{ch}, y_failed2.down{ch}, 'color', colori_ch2{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch2);
title('Tones  down>down')

%up>up
subplot(2,2,3), hold on
for ch=1:length(labels_ch2)
    h(ch) = plot(x_failed2.up{ch}, y_failed2.up{ch}, 'color', colori_ch2{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch2);
title('Tones up>up')

%up>down
subplot(2,2,4), hold on
for ch=1:length(labels_ch2)
    h(ch) = plot(x_success2.up{ch}, y_success2.up{ch}, 'color', colori_ch2{ch}); hold on
end
line([0 0], ylim,'color','k','linewidth',2), hold on
xlabel('time from tones'),
legend(h, labels_ch2);
title('Tones up>down')




