%%ScriptTonesInDownOneNight
% 14.05.2019 KJ
%
%
%   see 
%       FiguresTonesInDownPerRecord Fig1TonesInDownEffect ScriptTonesInUpOneNight
 

% clear


%% params
binsize_mua = 2;
minDuration = 20;

sham_distrib = 0;
t_start      =  -1e4; %1s
t_end        = 1e4; %1s

binsize_met = 10;
nbBins_met  = 80;

edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;
edges_ratio = -2:0.1:10;


%% load
%MUA & Down
MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); %2mS
down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
st_down = Start(down_PFCx);
end_down = End(down_PFCx);
down_duration = End(down_PFCx) - Start(down_PFCx);

%tones
load('behavResources.mat', 'ToneEvent')
tones_tmp = Range(ToneEvent);
nb_tones = length(tones_tmp);


%% Tones in or out
intwindow = 1000;
aroundDown = intervalSet(Start(down_PFCx)-intwindow, End(down_PFCx)+intwindow);

%tones in and out down states
Allnight = intervalSet(0,max(Range(MUA)));
ToneIn = Restrict(ToneEvent, down_PFCx);
ToneOut = Restrict(ToneEvent, CleanUpEpoch(Allnight-aroundDown));

%Down with or without
intv_down = [Start(down_PFCx) End(down_PFCx)];
[~,intv_with,~] = InIntervals(tones_tmp, intv_down);
intv_with = unique(intv_with);
intv_with(intv_with==0) = [];

intv_without = setdiff(1:length(Start(down_PFCx)), intv_with);

DownTone = intervalSet(intv_down(intv_with,1),intv_down(intv_with,2));
DownNo   = intervalSet(intv_down(intv_without,1),intv_down(intv_without,2));


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
    
    
%% Create Sham 
nb_sham = max(length(tonesin_tmp),1000);
idx = randsample(length(st_down), nb_sham);
sham_tmp = [];

if sham_distrib %same distribution as tones for delay(start_down,sham)

    %distribution
    edges_delay = 0:50:4000;
    [y_distrib, x_distrib] = histcounts(tones_bef, edges_delay, 'Normalization','probability');
    x_distrib = x_distrib(1:end-1) + diff(x_distrib);
    delay_generated = GenerateNumbersDistribution_KJ(x_distrib, y_distrib, 6000);

    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree  = end_down(idx(i))-st_down(idx(i));
        delays = randsample(delay_generated,1);

        if delays<duree
            sham_tmp = [sham_tmp min_tmp+delays];
        end
    end

else %uniform sham
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
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
    st_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
    sham_bef(i) = shamin_tmp(i) - st_bef;

    end_aft = end_down(find(end_down>shamin_tmp(i),1));
    sham_aft(i) = end_aft - shamin_tmp(i);

    down_post = st_down(find(st_down>shamin_tmp(i),1));
    sham_post(i) = down_post - shamin_tmp(i);
end



%% distributions of delays

%tones
[d_before.tones, x_before.tones] = histcounts(-tones_bef/10, edges_delay, 'Normalization','probability');
x_before.tones = x_before.tones(1:end-1) + diff(x_before.tones);

[d_after.tones, x_after.tones] = histcounts(tones_aft/10, edges_delay, 'Normalization','probability');
x_after.tones = x_after.tones(1:end-1) + diff(x_after.tones);

[d_postdown.tones, x_postdown.tones] = histcounts(tones_post/10, edges_delay, 'Normalization','probability');
x_postdown.tones = x_postdown.tones(1:end-1) + diff(x_postdown.tones);

norm_tones = tones_bef ./ (tones_bef + tones_aft);
[d_norm.tones, x_norm.tones] = histcounts(norm_tones, edges_norm, 'Normalization','probability');
x_norm.tones = x_norm.tones(1:end-1) + diff(x_norm.tones);

%ratio    
ratio_indown = abs(tones_bef ./ tones_aft);
[y_ratio.tones, x_ratio.tones] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
x_ratio.tones= x_ratio.tones(1:end-1) + diff(x_ratio.tones);

%sham
[d_before.sham, x_before.sham] = histcounts(-sham_bef/10, edges_delay, 'Normalization','probability');
x_before.sham = x_before.sham(1:end-1) + diff(x_before.sham);

[d_after.sham, x_after.sham] = histcounts(sham_aft/10, edges_delay, 'Normalization','probability');
x_after.sham = x_after.sham(1:end-1) + diff(x_after.sham);

[d_postdown.sham, x_postdown.sham] = histcounts(sham_post/10, edges_delay, 'Normalization','probability');
x_postdown.sham = x_postdown.sham(1:end-1) + diff(x_postdown.sham);

norm_sham = sham_bef ./ (sham_bef + sham_aft);
[d_norm.sham, x_norm.sham] = histcounts(norm_sham, edges_norm, 'Normalization','probability');
x_norm.sham = x_norm.sham(1:end-1) + diff(x_norm.sham);


%ratio    
ratio_indown = abs(sham_bef ./ sham_aft);
[y_ratio.sham, x_ratio.sham] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
x_ratio.sham= x_ratio.sham(1:end-1) + diff(x_ratio.sham);



%% MUA response for tones & sham

% In down
[m,~,tps] = mETAverage(Range(ToneIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_inside(:,1) = tps; met_inside(:,2) = m;
nb_inside = length(ToneIn);
% out of down
[m,~,tps] = mETAverage(Range(ToneOut), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_out(:,1) = tps; met_out(:,2) = m;
nb_out = length(ToneOut);
%sham in
[m,~,tps] = mETAverage(Range(ShamIn), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_shamin(:,1) = tps; met_shamin(:,2) = m;
nb_shamin = length(ToneOut);


%% MUA response to the end of down states
% with
[m,~,tps] = mETAverage(End(DownTone), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_with(:,1) = tps; met_with(:,2) = m;
nb_with = length(End(DownTone));

% without
[m,~,tps] = mETAverage(End(DownNo), Range(MUA), Data(MUA), binsize_met, nbBins_met);
met_without(:,1) = tps; met_without(:,2) = m;
nb_without = length(End(DownNo));


%% Tone/Sham Rasters and order
tone.rasters.inside  = RasterMatrixKJ(MUA, ToneIn, t_start, t_end);
sham.rasters.inside  = RasterMatrixKJ(MUA, ShamIn, t_start, t_end);

%order tones in down
tone.inside.before = tones_bef;
tone.inside.after = tones_aft;
tone.inside.postdown = tones_post;

%order sham in down
sham.inside.before = sham_bef;
sham.inside.after = sham_aft;
sham.inside.postdown = sham_post;


%% pool data

select_tone = 'inside'; %{'inside'}
select_order = 'before'; %{'before','after','postdown'}

MatMUA.tones  = [];
MatMUA.sham   = [];
ibefore.tones = [];
ibefore.sham  = [];


%tones
raster_tsd = tone.rasters.(select_tone);
x_mua_tones = Range(raster_tsd);
MatMUA.tones = Data(raster_tsd)';

ibefore.tones = tone.(select_tone).(select_order);

%sham
raster_tsd = sham.rasters.(select_tone);
x_mua_sham = Range(raster_tsd);
MatMUA.sham = Data(raster_tsd)';

ibefore.sham = sham.(select_tone).(select_order);

%sort raster
[~,idx_order] = sort(ibefore.tones);
MatMUA.tones  = MatMUA.tones(idx_order, :);
        
[~,idx_order] = sort(ibefore.sham);
MatMUA.sham  = MatMUA.sham(idx_order, :);



%% PLOT
figure, hold on
sz=25;
gap = [0.1 0.06];
smoothing = 1;

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


%TONES - raster plot
subtightplot(2,3,1,gap), hold on
imagesc(x_mua_tones/1E4, 1:size(MatMUA.tones,1), MatMUA.tones), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_tones = mean(MatMUA.tones,1);
y_mua_tones = Smooth(y_mua_tones ,1);
y_mua_tones = y_mua_tones / mean(y_mua_tones(x_mua_tones<-0.5e4));
plot(x_mua_tones/1E4, y_mua_tones, 'color', 'w', 'linewidth', 2);
set(gca,'YLim', [0 3]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.tones,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to tones (s)'), ylabel('#tones'),
title('Tones inside down states')


%SHAM - raster plot
subtightplot(2,3,2,gap), hold on
imagesc(x_mua_sham/1E4, 1:size(MatMUA.sham,1), MatMUA.sham), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on

yyaxis right
y_mua_sham = mean(MatMUA.sham,1);
y_mua_sham = Smooth(y_mua_sham ,1);
y_mua_sham = y_mua_sham / mean(y_mua_sham(x_mua_tones<-0.5e4));
hold on, plot(x_mua_tones/1E4, y_mua_tones, 'color', [0.5 0.5 0.5], 'linewidth', 2);
hold on, plot(x_mua_sham/1E4, y_mua_sham, '-w', 'linewidth', 2);
set(gca,'YLim', [0 3]);

yyaxis left
set(gca,'YLim', [0 size(MatMUA.sham,1)], 'XLim',[-0.4 0.4]);
xlabel('time relative to sham (ms)'), ylabel('#tones'),
title('Sham inside down states')

%Distrib occurence norm
clear h
subtightplot(2,3,3,gap), hold on
h(1) = plot(x_norm.tones, Smooth(d_norm.tones, smoothing), 'color', 'b', 'linewidth',2);
h(2) = plot(x_norm.sham, Smooth(d_norm.sham, smoothing), 'color', [0.2 0.2 0.2], 'linewidth',2); 
xlabel('normalized time'), ylabel('probability'), 
legend(h, 'tones', 'sham'),
title('Occurence of tones/sham in Down state (normalized)')


%TONES - Distrib of scatter plot
clear h
subtightplot(2,3,4,gap), hold on
h(1) = plot(x_before.tones, Smooth(d_before.tones, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.tones, Smooth(d_after.tones, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.tones, Smooth(d_postdown.tones, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
legend(h, 'start', 'end', 'down post'); lgd.Location='northwest';


%Distrib end-event (sham and tones)
clear h
subtightplot(2,3,5,gap), hold on
h(1) = plot(x_before.sham, Smooth(d_before.sham, 0), 'color', 'r', 'linewidth',2);
h(2) = plot(x_after.sham, Smooth(d_after.sham, 0), 'color', [0.1 0.1 0.44], 'linewidth',2);
h(3) = plot(x_postdown.sham, Smooth(d_postdown.sham, smoothing), 'color', [0 0.8 0], 'linewidth',2);
ylim([0 0.25]),
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


%Distrib log-ratio
clear h
subtightplot(2,3,6,gap), hold on
h(1) = plot(x_ratio.tones, Smooth(y_ratio.tones,smoothing), 'color','b', 'linewidth',2); hold on
h(2) = plot(x_ratio.sham, Smooth(y_ratio.sham,smoothing), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
line([0 0], get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
xlabel('log(time before/time after)'),
legend(h, 'tones', 'sham'),

res = pwd;
title(res(37:end));




