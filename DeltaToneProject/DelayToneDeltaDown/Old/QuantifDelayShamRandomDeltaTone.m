% QuantifDelayShamRandomDeltaTone
% 15.05.2017 KJ
%
% collect data for the quantification of the delay between a sham a the next delta/down, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE
%
% Here, the data are just collected and saved in 
%
%   see QuantifDelayShamDelta2 QuantifDelayTonevsDelta2

clear

%% params
hstep = 10;
max_edge = 500;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay = 200;
proba_max = 0.022;

substages_hist = 1:3;

%% SHAM

%load
load(fullfile(FolderDeltaDataKJ,'QuantifDelayShamDelta2.mat'))


%sham bci
delay_delta_sham = [];
for sub=substages_hist
    for p=1:length(delay_res.path)
        delay_delta_sham = [delay_delta_sham ; delay_res.delay_delta_sham{p,sub}];
    end
end
delay_delta_sham = delay_delta_sham / 10; %in ms
delay_delta_sham(delay_delta_sham<15)=[];

sham.medians_delay = median(delay_delta_sham(delay_delta_sham<max_edge));
sham.modes_delay = mode(delay_delta_sham(delay_delta_sham<max_edge));
h = histogram(delay_delta_sham, edges);
sham.histo.x = h.BinEdges(2:end) - hstep/2;
sham.histo.y = SmoothDec(h.Values,smoothing); close


%sham random
delay_delta_rdmsham = [];
for sub=substages_hist
    for p=1:length(delay_res.path)
        delay_delta_rdmsham = [delay_delta_rdmsham ; delay_res.delay_delta_rdm{p,sub}];
    end
end
delay_delta_rdmsham = delay_delta_rdmsham / 10; %in ms

rdmsham.medians_delay = median(delay_delta_rdmsham(delay_delta_rdmsham<max_edge));
rdmsham.modes_delay = mode(delay_delta_rdmsham(delay_delta_rdmsham<max_edge));
h = histogram(delay_delta_rdmsham, edges);
rdmsham.histo.x = h.BinEdges(2:end) - hstep/2;
rdmsham.histo.y = SmoothDec(h.Values,smoothing); close

%% RANDOM AND DELTA-TRIGGERED

%load
load(fullfile(FolderDeltaDataKJ,'QuantifDelayTonevsDelta.mat'))

%RANDOM
delay_random_tone = [];
for sub=substages_hist
    for p=1:length(delay_res.path)
        if strcmpi(delay_res.manipe{p},'RdmTone')
            delay_random_tone = [delay_random_tone ; delay_res.delay_delta_tone{p,sub}];
        end
    end
end
delay_random_tone = delay_random_tone / 10; %in ms

random.medians_delay = median(delay_random_tone(delay_random_tone<max_edge));
random.modes_delay = mode(delay_random_tone(delay_random_tone<max_edge));
h = histogram(delay_random_tone, edges);
random.histo.x = h.BinEdges(2:end) - hstep/2;
random.histo.y = SmoothDec(h.Values,smoothing); close


%DELTA Triggered
delay_delta_tone = [];
for sub=substages_hist
    for p=1:length(delay_res.path)
        if strcmpi(delay_res.manipe{p},'DeltaToneAll')
            delay_delta_tone = [delay_delta_tone ; delay_res.delay_delta_tone{p,sub}];
        end
    end
end
delay_delta_tone = delay_delta_tone / 10; %in ms

deltas.medians_delay = median(delay_delta_tone(delay_delta_tone<max_edge));
deltas.modes_delay = mode(delay_delta_tone(delay_delta_tone<max_edge));
h = histogram(delay_delta_tone, edges);
deltas.histo.x = h.BinEdges(2:end) - hstep/2;
deltas.histo.y = SmoothDec(h.Values,smoothing); close


%% DATA to plot
binsize = 0.01;

sham.plot.x = [];
sham.plot.y = [];
for k=1:length(sham.histo.x)
    xk = sham.histo.x(k)-hstep/2:binsize:sham.histo.x(k)+hstep/2;
    sham.plot.x = [sham.plot.x xk];
    sham.plot.y = [sham.plot.y sham.histo.y(k)*ones(1,length(xk))];
end

rdmsham.plot.x = [];
rdmsham.plot.y = [];
for k=1:length(rdmsham.histo.x)
    xk = rdmsham.histo.x(k)-hstep/2:binsize:rdmsham.histo.x(k)+hstep/2;
    rdmsham.plot.x = [rdmsham.plot.x xk];
    rdmsham.plot.y = [rdmsham.plot.y rdmsham.histo.y(k)*ones(1,length(xk))];
end

random.plot.x = [];
random.plot.y = [];
for k=1:length(random.histo.x)
    xk = random.histo.x(k)-hstep/2:binsize:random.histo.x(k)+hstep/2;
    random.plot.x = [random.plot.x xk];
    random.plot.y = [random.plot.y random.histo.y(k)*ones(1,length(xk))];
end

deltas.plot.x = [];
deltas.plot.y = [];
for k=1:length(deltas.histo.x)
    xk = deltas.histo.x(k)-hstep/2:binsize:deltas.histo.x(k)+hstep/2;
    deltas.plot.x = [deltas.plot.x xk];
    deltas.plot.y = [deltas.plot.y deltas.histo.y(k)*ones(1,length(xk))];
end

%% plot

%Delta delay distribution
figure, hold on
h(1) = plot(sham.plot.x, sham.plot.y, 'k', 'LineWidth',4); hold on,
h(2) = plot(random.plot.x, random.plot.y, 'color',[0.85 0.85 0.85], 'LineWidth',4); hold on,
h(3) = plot(deltas.plot.x, deltas.plot.y, 'color',[0.65 0.76 0.46], 'LineWidth',4); hold on,
% h(4) = plot(rdmsham.plot.x, rdmsham.plot.y, 'color','b', 'LineWidth',4); hold on,


y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay thresh_delay 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay max_edge max_edge thresh_delay];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

xlabel('time (ms)'), ylabel('density')
set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge],'Ytick',0:0.02:proba_max,'FontName','Times','fontsize',26), hold on,
line([thresh_delay thresh_delay],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
title('Distribution of the delays between tones and the next delta wave')


legend(h,'Sham','Random tones','Delta-triggered tones ')

