%Script_Tones_Nodelay

clear

%params
binsize_met = 5;
nbBins_met  = 160;
binsize_mua = 2;
minDuration = 20;

edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% load
%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);

%tones
load('DeltaSleepEvent.mat', 'TONEtime2')
tones_tmp = sort(TONEtime2);
ToneEvent = ts(tones_tmp);
nb_tones = length(tones_tmp);

%LFP
load('ChannelsToAnalyse/PFCx_clusters.mat')

PFC = cell(0);
for ch=1:length(channels)
    load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
    PFC{ch} = LFP;
    clear LFP
end


%% Tones in or out
intwindow = 4000;
aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

%tones in and out down states
Allnight = intervalSet(0,max(Range(MUA)));
ToneIn = Restrict(ToneEvent, down_PFCx);
ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-down_PFCx));

%% Delay between tones and down

%tones in
tonesin_tmp = Range(ToneIn);

tones_bef = nan(length(tonesin_tmp), 1);
tones_aft = nan(length(tonesin_tmp), 1);
tones_post = nan(length(tonesin_tmp), 1);
for i=1:length(tonesin_tmp)
    st_bef = st_down(find(st_down<tonesin_tmp(i),1,'last'));
    tones_bef(i) = tonesin_tmp(i) - st_bef;

    end_aft = end_down(find(end_down>tonesin_tmp(i),1));
    tones_aft(i) = end_aft - tonesin_tmp(i);

    down_post = st_down(find(st_down>tonesin_tmp(i),1));
    tones_post(i) = down_post - tonesin_tmp(i);
end

%tones
[d_before, x_before] = histcounts(-tones_bef/10, edges_delay, 'Normalization','probability');
x_before = x_before(1:end-1) + diff(x_before);

[d_after, x_after] = histcounts(tones_aft/10, edges_delay, 'Normalization','probability');
x_after = x_after(1:end-1) + diff(x_after);

[d_postdown, x_postdown] = histcounts(tones_post/10, edges_delay, 'Normalization','probability');
x_postdown = x_postdown(1:end-1) + diff(x_postdown);

norm_tones = tones_bef ./ (tones_bef + tones_aft);
[d_norm, x_norm] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
x_norm = x_norm(1:end-1) + diff(x_norm);

%ratio    
ratio_indown = abs(tones_bef ./ tones_aft);
[y_ratio, x_ratio] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
x_ratio= x_ratio(1:end-1) + diff(x_ratio);
    


%% MUA response for tones
    
% In down
[m,~,tps] = mETAverage(Range(ToneIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
mua_inside(:,1) = tps; mua_inside(:,2) = m;
nb_inside = length(ToneIn);
% out of down
[m,~,tps] = mETAverage(Range(ToneOut), Range(MUA), Data(MUA), binsize_met, nbBins_met);
mua_out(:,1) = tps; mua_out(:,2) = m;
nb_out = length(ToneOut);

%% LFP response for tones

for ch=1:length(PFC)
    % In down
    [m,~,tps] = mETAverage(Range(ToneIn), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_inside{ch}(:,1) = tps; lfp_inside{ch}(:,2) = m; 
    % out of down
    [m,~,tps] = mETAverage(Range(ToneOut), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_outside{ch}(:,1) = tps; lfp_outside{ch}(:,2) = m;
end


%% PLOT
figure, hold on
labels_cl = {'1','2','3','4','5'};
colors_cl = {'b', [1 0.27 0], 'g', 'k', [1 0.08 0.58]};
gap = [0.08 0.05];

%MUA in down
subtightplot(2,2,1,gap), hold on
plot(mua_inside(:,1), mua_inside(:,2) , 'color', 'k'); hold on
xlabel('time from tones'), xlim([-400 400]), ylabel('MUA'),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
title('Tones in Down ')

%MUA out of down
subtightplot(2,2,2,gap), hold on
plot(mua_out(:,1), mua_out(:,2) , 'color', 'k'); hold on
xlabel('time from tones'), xlim([-400 400]), ylabel('MUA'),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
title('Tones out of Down ')

%LFP in down
subtightplot(2,2,3,gap), hold on
for ch=1:length(PFC)
    plot(lfp_inside{ch}(:,1), lfp_inside{ch}(:,2) , 'color', 'k'); hold on
    xlabel('time from tones'), xlim([-400 400]), ylabel('LFP'),
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
end

%LFP out of down
subtightplot(2,2,4,gap), hold on
for ch=1:length(PFC)
    plot(lfp_outside{ch}(:,1), lfp_outside{ch}(:,2) , 'color', 'k'); hold on
    xlabel('time from tones'), xlim([-400 400]), ylabel('LFP'),
    line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
end

