%%DistributionUpDownRipplesDurationsPlot
% 02.12.2019 KJ
%
%
%   see 
%       DistributionUpDownRipplesDurations 
%


clear

load(fullfile(FolderDeltaDataKJ,'DistributionUpDownDurations.mat')) %durations
animals = unique(distrib_res.name);
animals = animals([1:5 7]);

%durations
hstep = 10;
max_edge_down = 600;
edges_down = 0:hstep:max_edge_down;
max_edge_up = 1200;
edges_up = 0:hstep:max_edge_up;


%% loop and pool
durations.all.down = []; durations.all.up = [];
durRip.all.down = []; durRip.all.up = [];
durations.start.down = []; durations.start.up = [];
durRip.start.down = []; durRip.start.up = [];
durations.end.down = []; durations.end.up = [];
durRip.end.down = []; durRip.end.up = [];
for i=1:5
    durations.epoch.down = [];
    durRip.epoch.down    = [];
    durations.epoch.up   = [];
    durRip.epoch.up      = []; 
end

for m=1:length(animals)
    
    mouse_dur.all.down = []; mouse_dur.all.up = [];
    mouse_rip.all.down = []; mouse_rip.all.up = [];
    mouse_dur.start.down = []; mouse_dur.start.up = [];
    mouse_rip.start.down = []; mouse_rip.start.up = [];
    mouse_dur.end.down = []; mouse_dur.end.up = [];
    mouse_rip.end.down = []; mouse_rip.end.up = [];
    for i=1:5
        mouse_dur.epoch.down{i} = [];
        mouse_rip.epoch.down{i} = [];
        mouse_dur.epoch.up{i}   = [];
        mouse_rip.epoch.up{i}   = []; 
    end
    
    for p=1:length(distrib_res.path)
        if strcmpi(distrib_res.name{p}, animals{m})
            
            %distrib
            [y_distrib, x_down] = histcounts(distrib_res.all.down.duration{p}/10, edges_down,'Normalization','probability');
            mouse_dur.all.down = [mouse_dur.all.down ; y_distrib];
            [y_distrib, x_down] = histcounts(distrib_res.all.down.ripDur{p}/10, edges_down,'Normalization','probability');
            mouse_rip.all.down = [mouse_rip.all.down ; y_distrib];
            [y_distrib, x_up] = histcounts(distrib_res.all.up.duration{p}/10, edges_up,'Normalization','probability');
            mouse_dur.all.up = [mouse_dur.all.up ; y_distrib];
            [y_distrib, x_up] = histcounts(distrib_res.all.up.ripDur{p}/10, edges_up,'Normalization','probability');
            mouse_rip.all.up = [mouse_rip.all.up ; y_distrib];
            
            
            %mean duration
            mouse_dur.start.down = [mouse_dur.start.down mean(distrib_res.first.down.duration{p}/10)];
            mouse_rip.start.down = [mouse_rip.start.down mean(distrib_res.first.down.duration{p}/10)];
            mouse_dur.start.up = [mouse_dur.start.up mean(distrib_res.first.up.duration{p}/10)];
            mouse_rip.start.up = [mouse_rip.start.up mean(distrib_res.first.up.ripDur{p}/10)];
            
            mouse_dur.end.down = [mouse_dur.end.down mean(distrib_res.last.down.duration{p}/10)];
            mouse_rip.end.down = [mouse_rip.end.down mean(distrib_res.last.down.duration{p}/10)];
            mouse_dur.end.up = [mouse_dur.end.up mean(distrib_res.last.up.duration{p}/10)];
            mouse_rip.end.up = [mouse_rip.end.up mean(distrib_res.last.up.ripDur{p}/10)];
            
            for i=1:5
                mouse_dur.epoch.down{i} = [mouse_dur.epoch.down{i} mean(distrib_res.epoch.down.duration{p,i}/10)];
                mouse_rip.epoch.down{i} = [mouse_rip.epoch.down{i} mean(distrib_res.epoch.down.ripDur{p,i}/10)];
                mouse_dur.epoch.up{i}   = [mouse_dur.epoch.up{i} mean(distrib_res.epoch.up.duration{p,i}/10)];
                mouse_rip.epoch.up{i}   = [mouse_rip.epoch.up{i} mean(distrib_res.epoch.up.ripDur{p,i}/10)]; 
            end
            
        end
    end
    
    %mean distrib
    durations.all.down  = [durations.all.down ; mean(mouse_dur.all.down,1)];
    durRip.all.down     = [durRip.all.down ; mean(mouse_rip.all.down,1)];
    durations.all.up    = [durations.all.up ; mean(mouse_dur.all.up,1)];
    durRip.all.up       = [durRip.all.up ; mean(mouse_rip.all.up,1)];
    
    durations.start.down  = [durations.start.down ; mean(mouse_dur.start.down)];
    durRip.start.down     = [durRip.start.down ; mean(mouse_rip.start.down)];
    durations.start.up    = [durations.start.up ; mean(mouse_dur.start.up)];
    durRip.start.up       = [durRip.start.up ; mean(mouse_rip.start.up)];
    
    durations.end.down  = [durations.end.down ; mean(mouse_dur.end.down)];
    durRip.end.down     = [durRip.end.down ; mean(mouse_rip.end.down)];
    durations.end.up    = [durations.end.up ; mean(mouse_dur.end.up)];
    durRip.end.up       = [durRip.end.up ; mean(mouse_rip.end.up)];
    
    for i=1:5
        durations.epoch.down(m,i) = nanmean(mouse_dur.epoch.down{i});
        durRip.epoch.down(m,i)    = nanmean(mouse_rip.epoch.down{i});
        durations.epoch.up(m,i)   = nanmean(mouse_dur.epoch.up{i});
        durRip.epoch.up(m,i)      = nanmean(mouse_rip.epoch.up{i}); 
    end
    
    
end

%mean Distrib
MeanDur.all.down = mean(durations.all.down,1);
stdDur.all.down = std(durations.all.down,0,1)/sqrt(size(durations.all.down,1));

MeanRip.all.down = mean(durRip.all.down,1);
stdRip.all.down = std(durRip.all.down,0,1)/sqrt(size(durRip.all.down,1));

MeanDur.all.up = mean(durations.all.up,1);
stdDur.all.up = std(durations.all.up,0,1)/sqrt(size(durations.all.up,1));

MeanRip.all.up = mean(durRip.all.up,1);
stdRip.all.up = std(durRip.all.up,0,1)/sqrt(size(durRip.all.up,1));



%% Plot

color_dur = 'k';
color_rip = 'b';
fontsize = 20;

x_down = x_down(1:end-1);
x_up = x_up(1:end-1);

figure, hold on

%Down
subplot(2,3,1), hold on

errorbar(x_down, MeanDur.all.down, stdDur.all.down, 'color', color_dur,'CapSize',1)
errorbar(x_down, MeanRip.all.down, stdRip.all.down, 'color', color_rip,'CapSize',1)
%mean curves
h(1) = plot(x_down, MeanDur.all.down, 'color', color_dur, 'linewidth',2);
%properties
% set(gca,'YLim', [0 1.8],'XLim',[-600 600],'Fontsize',fontsize);

legend(h,'down');
xlabel('down durations (ms)'),
ylabel('probability'), 

subplot(2,3,2), hold on
PlotErrorBarN_KJ([durations.start.down durations.end.down], 'newfig',0, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'start','end'},'Fontsize',fontsize),
ylabel('mean duration (ms)'),
title('Down')


subplot(2,3,3), hold on
PlotErrorLineN_KJ(durations.epoch.down, 'x_data',1:5,'newfig',0,'ShowSigstar','none','errorbars',1,'linespec','-.');
% set(gca,'ylim',[0 39],'xtick',[0 1], 'ytick',0:10:30,'Fontsize',fontsize),
ylabel('down durations'), xlabel('normalized time'),


%Up
subplot(2,3,4), hold on

errorbar(x_up, MeanDur.all.up, stdDur.all.up, 'color', color_dur,'CapSize',1)
errorbar(x_up, MeanRip.all.up, stdRip.all.up, 'color', color_rip,'CapSize',1)
%mean curves
h(1) = plot(x_up, MeanDur.all.up, 'color', color_dur, 'linewidth',2);
h(2) = plot(x_up, MeanRip.all.up, 'color', color_rip, 'linewidth',2);
%properties
% set(gca,'YLim', [0 1.8],'XLim',[-600 600],'Fontsize',fontsize);

legend(h,'up','up with rip');
xlabel('up durations (ms)'),
ylabel('probability'), 

subplot(2,3,5), hold on
PlotErrorBarN_KJ([durRip.start.up durRip.end.up], 'newfig',0, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'start','end'},'Fontsize',fontsize),
ylabel('mean duration (ms)'),
title('Up')


subplot(2,3,6), hold on
PlotErrorLineN_KJ(durRip.epoch.up, 'x_data',1:5,'newfig',0,'ShowSigstar','none','errorbars',1,'linespec','-.');
% set(gca,'ylim',[0 39],'xtick',[0 1], 'ytick',0:10:30,'Fontsize',fontsize),
ylabel('up durations'), xlabel('normalized time'),










