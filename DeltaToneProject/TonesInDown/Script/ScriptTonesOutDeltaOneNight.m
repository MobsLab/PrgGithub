%%ScriptTonesOutDeltaOneNight
% 14.05.2019 KJ
%
%
%   see 
%       ScriptTonesInUpOneNight ScriptTonesInDeltaOneNight ScriptLoadDeltaTonesOneNight


clearvars -except all_deltas_PFCx PFC PFCdeep PFCsup NREM ToneEvent channels Dir p

%params
maxDuration = 30e4;

sham_distrib = 0;
t_start      =  -1e4; %1s
t_end        = 1e4; %1s

binsize_met = 10;
nbBins_met  = 80;

edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;

delay_detections = GetDelayBetweenDeltaDown(Dir);


%% Deltas

%Deltas
deltas_PFCx = intervalSet(Start(all_deltas_PFCx), End(all_deltas_PFCx));
deltas_PFCx = dropShortIntervals(deltas_PFCx, 750);
st_deltas = Start(deltas_PFCx);
end_deltas = End(deltas_PFCx);

%Up
load('IdFigureData2.mat', 'night_duration')
AllNight = intervalSet(0,night_duration);
up_PFCx = CleanUpEpoch(AllNight - deltas_PFCx,1);

up_PFCx = intervalSet(end_deltas(1:end-1), st_deltas(2:end));
up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
st_up = Start(up_PFCx);
end_up = End(up_PFCx);

% Tones out of deltas
ToneIn = Restrict(ToneEvent, up_PFCx);
nb_tones = length(ToneIn);
tones_tmp = Range(ToneIn);


%% Delay between tones and up

tones_bef = nan(length(tones_tmp), 1);
tones_aft = nan(length(tones_tmp), 1);
tones_post = nan(length(tones_tmp), 1);
for i=1:length(tones_tmp)
    st_bef = st_up(find(st_up<tones_tmp(i),1,'last'));
    tones_bef(i) = tones_tmp(i) - st_bef;

    end_aft = end_up(find(end_up>tones_tmp(i),1));
    tones_aft(i) = end_aft - tones_tmp(i);

    up_post = st_up(find(st_up>tones_tmp(i),1));
    tones_post(i) = up_post - tones_tmp(i);
end
    
    
%% Create Sham 
nb_sham = 2000;
idx = randsample(length(st_up), nb_sham);
sham_tmp = [];

if sham_distrib %same distribution as tones for delay(start_down,sham)

    %distribution
    edges_delay = 0:50:4000;
    [y_distrib, x_distrib] = histcounts(tones_bef, edges_delay, 'Normalization','probability');
    x_distrib = x_distrib(1:end-1) + diff(x_distrib);
    delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree  = end_up(idx(i))-st_up(idx(i));
        delays = randsample(delay_generated,1);

        if delays<duree
            sham_tmp = [sham_tmp min_tmp+delays];
        end
    end

else %uniform sham
    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end
end

shamin_tmp = sort(sham_tmp);
ShamIn = ts(shamin_tmp);


%% Delay between sham and down
sham_bef = nan(length(shamin_tmp), 1);
sham_aft = nan(length(shamin_tmp), 1);
sham_post = nan(length(shamin_tmp), 1);
for i=1:length(shamin_tmp)
    st_bef = st_up(find(st_up<shamin_tmp(i),1,'last'));
    sham_bef(i) = shamin_tmp(i) - st_bef;

    end_aft = end_up(find(end_up>shamin_tmp(i),1));
    sham_aft(i) = end_aft - shamin_tmp(i);

    up_post = st_up(find(st_up>shamin_tmp(i),1));
    try
        sham_post(i) = up_post - shamin_tmp(i);
    end
end



%% distributions of delays

%tones
[d_before.tones, x_before.tones] = histcounts(-tones_bef/10, edges_delay, 'Normalization','probability');
x_before.tones = x_before.tones(1:end-1) + diff(x_before.tones);

[d_after.tones, x_after.tones] = histcounts(tones_aft/10, edges_delay, 'Normalization','probability');
x_after.tones = x_after.tones(1:end-1) + diff(x_after.tones);

[d_postup.tones, x_postup.tones] = histcounts(tones_post/10, edges_delay, 'Normalization','probability');
x_postup.tones = x_postup.tones(1:end-1) + diff(x_postup.tones);

norm_tones = tones_bef ./ (tones_bef + tones_aft);
[d_norm.tones, x_norm.tones] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
x_norm.tones = x_norm.tones(1:end-1) + diff(x_norm.tones);

%ratio    
ratio_inup = abs(tones_bef ./ tones_aft);
[y_ratio.tones, x_ratio.tones] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
x_ratio.tones= x_ratio.tones(1:end-1) + diff(x_ratio.tones);

%sham
[d_before.sham, x_before.sham] = histcounts(-sham_bef/10, edges_delay, 'Normalization','probability');
x_before.sham = x_before.sham(1:end-1) + diff(x_before.sham);

[d_after.sham, x_after.sham] = histcounts(sham_aft/10, edges_delay, 'Normalization','probability');
x_after.sham = x_after.sham(1:end-1) + diff(x_after.sham);

[d_postup.sham, x_postup.sham] = histcounts(sham_post/10, edges_delay, 'Normalization','probability');
x_postup.sham = x_postup.sham(1:end-1) + diff(x_postup.sham);

norm_sham = sham_bef ./ (sham_bef + sham_aft);
[d_norm.sham, x_norm.sham] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
x_norm.sham = x_norm.sham(1:end-1) + diff(x_norm.sham);


%ratio    
ratio_inup = abs(sham_bef ./ sham_aft);
[y_ratio.sham, x_ratio.sham] = histcounts(ratio_inup, edges_ratio,'Normalization','probability');
x_ratio.sham= x_ratio.sham(1:end-1) + diff(x_ratio.sham);



%% LFP response for tones & sham

for ch=1:length(PFC)
    % Tones in
    [m,~,tps] = mETAverage(Range(ToneIn), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_tones{ch}(:,1) = tps; lfp_tones{ch}(:,2) = m; 
    % sham in
    [m,~,tps] = mETAverage(Range(ShamIn), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
    lfp_sham{ch}(:,1) = tps; lfp_sham{ch}(:,2) = m;
end



%% Tone/Sham Rasters and order
tone.rasters.inside  = RasterMatrixKJ(PFCdeep, ToneIn, t_start, t_end);
sham.rasters.inside  = RasterMatrixKJ(PFCdeep, ShamIn, t_start, t_end);

%order tones in down
tone.inside.before = tones_bef;
tone.inside.after = tones_aft;
tone.inside.postup = tones_post;

%order sham in down
sham.inside.before = sham_bef;
sham.inside.after = sham_aft;
sham.inside.postup = sham_post;


%% pool data

select_tone = 'inside'; %{'inside'}
select_order = 'before'; %{'before','after','postdown'}

MatLFP.tones  = [];
MatLFP.sham   = [];
ibefore.tones = [];
ibefore.sham  = [];


%tones
raster_tsd = tone.rasters.inside;
x_mua_tones = Range(raster_tsd);
MatLFP.tones = Data(raster_tsd)';

ibefore.tones = tone.inside.(select_order);

%sham
raster_tsd = sham.rasters.inside;
x_mua_sham = Range(raster_tsd);
MatLFP.sham = Data(raster_tsd)';

ibefore.sham = sham.inside.(select_order);

%sort raster
[~,idx_order] = sort(ibefore.tones);
MatLFP.tones  = MatLFP.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.sham);
MatLFP.sham  = MatLFP.sham(idx_order, :);



%% PLOT
figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;

% %color map style
% co=jet;
% co(1,:)=[0 0 0]; %silences (M=0) are in black
% colormap(co);


%TONES - raster plot
subtightplot(4,3,[1 4],gap), hold on
imagesc(x_mua_tones/1E4, 1:size(MatLFP.tones,1), MatLFP.tones), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
% caxis([-5000 4000])

yyaxis right
y_mua_tones = mean(MatLFP.tones,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua_tones<-0.5e4));
plot(x_mua_tones/1E4, y_mua_tones, 'color', 'k', 'linewidth', 2);
set(gca,'YLim', [-800 800]);

yyaxis left
set(gca,'YLim', [0 size(MatLFP.tones,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside Up states')


%SHAM - raster plot
subtightplot(4,3,[2 5],gap), hold on
imagesc(x_mua_sham/1E4, 1:size(MatLFP.sham,1), MatLFP.sham), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
% caxis([-5000 4000])

yyaxis right
y_mua_sham = mean(MatLFP.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua_tones<-0.5e4));
hold on, plot(x_mua_sham/1E4, y_mua_sham, 'k', 'linewidth', 2);
hold on, plot(x_mua_tones/1E4, y_mua_tones, 'color', [0.5 0.5 0.5], 'linewidth', 2);
set(gca,'YLim', [-800 800]);

yyaxis left
set(gca,'YLim', [0 size(MatLFP.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'), ylabel('#tones'),
title('Sham inside Up states')

%Distrib occurence norm
clear h
subtightplot(4,3,[3 6],gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
% legend(h, 'tones', 'sham'),
title('Occurence of tones/sham in Up state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(4,3,[7 10],gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.tones, Smooth(d_postup.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
legend(h, 'start', 'end', 'up post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(4,3,[8 11],gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postup.sham, Smooth(d_postup.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


%Plot meancurves on tones
clear h leg
subtightplot(4,3,9,gap), hold on
for ch=1:length(PFC)
    h(ch) = plot(lfp_tones{ch}(:,1), lfp_tones{ch}(:,2)); hold on
    leg{ch} = num2str(channels(ch));
end
xlabel('time from tones'), xlim([-400 400]), ylabel('LFP'),
ylim([-1000 1500]),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on
legend(h,leg),

%Plot meancurves on sham
clear h leg
subtightplot(4,3,12,gap), hold on
for ch=1:length(PFC)
    h(ch) = plot(lfp_sham{ch}(:,1), lfp_sham{ch}(:,2)); hold on
    leg{ch} = num2str(channels(ch));    
end
xlabel('time from sham'), xlim([-400 400]), ylabel('LFP'),
ylim([-1000 1500]),
line([0 0], ylim,'color',[0.7 0.7 0.7],'linewidth',1), hold on



