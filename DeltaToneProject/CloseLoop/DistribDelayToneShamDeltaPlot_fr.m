% DistribDelayToneShamDeltaPlot_fr
% 30.09.2019 KJ
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
max_edge = 320;
edges = 0:hstep:max_edge;
smoothing=2;
thresh_delay = 130;
proba_max = 0.05;

substages_hist = 1:3;

%load
load(fullfile(FolderDeltaDataKJ,'DistribDelayToneShamDelta.mat'))

animals = unique(tones_res.name)';
animals([2 7])=[];

%% SHAM

%Pool by animal
delay_sham = [];
for m=1:length(animals)
    
    mouse_sham = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            for sub=substages_hist
                mouse_sham = [mouse_sham ; sham_res.delay_sham{p,sub}];
            end
        end
    end
    mouse_sham = mouse_sham / 10; %in ms

    %sham bci
    [sham.mouse.y, sham.mouse.x] = histcounts(mouse_sham, edges, 'Normalization','probability');
    sham.mouse.x = sham.mouse.x(1:end-1) + diff(sham.mouse.x)/2;
    
    delay_sham    = [delay_sham ; sham.mouse.y ];
end

%average and x
sham.histo.y = mean(delay_sham,1);
sham.histo.x = sham.mouse.x;


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
[random.plot.x, random.plot.y] = stairs(random.histo.x, random.histo.y);
[deltas.plot.x, deltas.plot.y] = stairs(deltas.histo.x, deltas.histo.y);


%% plot
color_sham = [0.3 0.3 0.3];
color_rdm = [0 0 1];
color_bci = [0 0.5 0];

%Delta delay distribution
figure, hold on

y_rec1 = [0 0 proba_max proba_max];
x_rec1 = [0 thresh_delay thresh_delay 0];
hold on, patch(x_rec1, y_rec1, 'b', 'EdgeColor', 'None', 'FaceAlpha', 0.06);
y_rec2 = [0 0 proba_max proba_max];
x_rec2 = [thresh_delay max_edge max_edge thresh_delay];
hold on, patch(x_rec2, y_rec2, 'r', 'EdgeColor', 'None', 'FaceAlpha', 0.06);

h(1) = plot(deltas.plot.x, deltas.plot.y, 'color',color_bci, 'LineWidth',4); hold on,
h(2) = plot(random.plot.x, random.plot.y, 'color',color_rdm, 'LineWidth',4); hold on,
h(3) = plot(sham.plot.x, sham.plot.y, 'color',color_sham, 'LineWidth',4); hold on,


xlabel('temps depuis stim ou sham (ms)'), ylabel({'Probabilité d''observer', 'une delta wave'})
line([thresh_delay thresh_delay],get(gca,'YLim'), 'color',[0.5 0.5 0.5],'linestyle','--'), hold on
set(gca,'XTick',[0 100 130 200],'XLim',[0 max_edge],'Ytick',0:0.02:proba_max, 'ylim',[0 proba_max], 'FontName','Times','fontsize',32), hold on,

legend(h,' Stim en boucle fermée',' Stim aléatoire',' Sham')




set(gca,'XTick',[0 100 130 200])










