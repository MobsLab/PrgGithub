% DistribDelayToneShamDeltaPlot
% 11.07.2019 KJ
%
% quantification of the delay between a tone/sham and the next delta, 
% for different substages
%   - Substages = N1, N2, N3, REM, WAKE, NREM
%
% Here, the data are plotted 
%
%   see DistribDelayToneShamDelta QuantifDelayTonevsDelta QuantifDelayShamDelta QuantifDelayShamRandomDeltaTone
%


clear

%% params
hstep = 10;
max_edge = 500;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay = 200;
proba_max = 0.046;

substages_hist = 1:3;

%load
load(fullfile(FolderDeltaDataKJ,'DistribDelayToneShamDelta.mat'))

animals = unique(tones_res.name)';

%% SHAM

%Pool by animal
delay_sham = [];
delay_rdmsham = [];
for m=1:length(animals)
    
    mouse_sham = [];
    mouse_rdmsham = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            for sub=substages_hist
                mouse_sham = [mouse_sham ; sham_res.delay_sham{p,sub}];
                mouse_rdmsham = [mouse_rdmsham ; sham_res.delay_rdm{p,sub}];
            end
        end
    end
    mouse_sham = mouse_sham / 10; %in ms
    mouse_rdmsham = mouse_rdmsham / 10; %in ms

    %sham bci
    [sham.mouse.y, sham.mouse.x] = histcounts(mouse_sham, edges, 'Normalization','probability');
    sham.mouse.x = sham.mouse.x(1:end-1) + diff(sham.mouse.x)/2;
    %sham random
    [rdmsham.mouse.y, rdmsham.mouse.x] = histcounts(mouse_rdmsham, edges, 'Normalization','probability');
    rdmsham.mouse.x = rdmsham.mouse.x(1:end-1) + diff(rdmsham.mouse.x)/2;
    
    delay_sham    = [delay_sham ; sham.mouse.y ];
    delay_rdmsham = [delay_rdmsham ; rdmsham.mouse.y];
end

%average and x
sham.histo.y = mean(delay_sham,1);
rdmsham.histo.y = mean(delay_rdmsham,1); 
    
sham.histo.x = sham.mouse.x;
rdmsham.histo.x = rdmsham.mouse.x;


%% RANDOM AND DELTA-TRIGGERED

%Pool
delay_randomtone = [];
delay_deltatone = [];
for m=1:length(animals)
    
    mouse_rdmtone = [];
    mouse_deltatone = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            for sub=substages_hist
                if strcmpi(tones_res.manipe{p},'RdmTone')
                    mouse_rdmtone = [mouse_rdmtone ; tones_res.delay_deltatone{p,sub}];
                else
                    mouse_deltatone = [mouse_deltatone ; tones_res.delay_deltatone{p,sub}];
                end
            end
        end
    end
    mouse_rdmtone = mouse_rdmtone / 10; %in ms
    mouse_deltatone = mouse_deltatone / 10; %in ms

    %RANDOM
    [random.mouse.y, random.mouse.x] = histcounts(mouse_rdmtone, edges, 'Normalization','probability');
    random.mouse.x = random.mouse.x(1:end-1) + diff(random.mouse.x)/2;
    %DELTA Triggered
    [deltas.mouse.y, deltas.mouse.x] = histcounts(mouse_deltatone, edges, 'Normalization','probability');
    deltas.mouse.x = deltas.mouse.x(1:end-1) + diff(deltas.mouse.x)/2;
    
    delay_randomtone = [delay_randomtone ; random.mouse.y ];
    delay_deltatone  = [delay_deltatone ; deltas.mouse.y];
end

%average and x
random.histo.y = mean(delay_randomtone,1);
deltas.histo.y = mean(delay_deltatone,1); 
    
random.histo.x = random.mouse.x;
deltas.histo.x = deltas.mouse.x;



%% DATA to plot
binsize = 0.01;

[sham.plot.x, sham.plot.y] = stairs(sham.histo.x, sham.histo.y);
[rdmsham.plot.x, rdmsham.plot.y] = stairs(rdmsham.histo.x, rdmsham.histo.y);
[random.plot.x, random.plot.y] = stairs(random.histo.x, random.histo.y);
[deltas.plot.x, deltas.plot.y] = stairs(deltas.histo.x, deltas.histo.y);


%% plot

%Delta delay distribution
figure, hold on
h(1) = plot(sham.plot.x, sham.plot.y, 'k', 'LineWidth',4); hold on,
h(2) = plot(random.plot.x, random.plot.y, 'color',[0.85 0.85 0.85], 'LineWidth',4); hold on,
h(3) = plot(deltas.plot.x, deltas.plot.y, 'color',[0.65 0.76 0.46], 'LineWidth',4); hold on,
h(4) = plot(rdmsham.plot.x, rdmsham.plot.y, 'color','b', 'LineWidth',4); hold on,


y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay thresh_delay 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.09);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay max_edge max_edge thresh_delay];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.09);

xlabel('time from tones/sham(ms)'), ylabel('density of tones/sham')
line([thresh_delay thresh_delay],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
set(gca,'XTick',0:100:max_edge-100,'XLim',[0 max_edge],'Ytick',0:0.02:proba_max, 'ylim',[0 proba_max], 'FontName','Times','fontsize',26), hold on,
title('Distribution of the delays between tones/sham and the next delta wave')

legend(h,'Sham','Random tones','Delta-triggered tones ', 'Rdm sham')















