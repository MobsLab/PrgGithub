%%DeltaThresholdStdDetectionFiringPlot
% 20.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at the firing rate in function of the threshold
%   -> here we plot  
%
% see
%   DeltaThresholdStdDetectionFiring DeltaThresholdStdDetectionFiringPlot_bis
%   DeltaThresholdStdDetectionFiringPlot2
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DeltaThresholdStdDetectionFiring.mat'))
animals = unique(thresh_res.name);

smoothing = 1;
edges = 0:0.05:1; 
path_exclude = [5 12 28 29];
path_exclude = [];


%% histogram

fr2SD.diff = []; fr2SD.deep = []; fr2SD.sup  = [];
density2SD.diff = []; density2SD.deep = []; density2SD.sup  = [];

for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    
    % firing rate at 2 SD
    fr2SD.diff = [fr2SD.diff ; thresh_res.diff.firing_rate_norm{p}(thD_list==2)];
    fr2SD.deep = [fr2SD.deep ; thresh_res.deep.firing_rate_norm{p}(thD_list==2)];
    if ~isempty(thresh_res.sup.firing_rate_norm{p})
        fr2SD.sup  = [fr2SD.sup ; thresh_res.sup.firing_rate_norm{p}(thD_list==2)];
    end
    
    %density of delta waves at 2 SD
    density2SD.diff = [density2SD.diff ; thresh_res.diff.delta_density{p}(thD_list==2)];
    density2SD.deep = [density2SD.deep ; thresh_res.deep.delta_density{p}(thD_list==2)];
    if ~isempty(thresh_res.sup.delta_density{p})
        density2SD.sup  = [density2SD.sup ; thresh_res.sup.delta_density{p}(thD_list==2)];
    end
    
end

%diff
[histo.fr.diff.y, histo.fr.diff.x] = histcounts(fr2SD.diff, edges, 'Normalization','probability');
histo.fr.diff.x = histo.fr.diff.x(1:end-1) + diff(histo.fr.diff.x);
%deep
[histo.fr.deep.y, histo.fr.deep.x] = histcounts(fr2SD.deep, edges, 'Normalization','probability');
histo.fr.deep.x = histo.fr.deep.x(1:end-1) + diff(histo.fr.deep.x);
%sup
[histo.fr.sup.y, histo.fr.sup.x] = histcounts(fr2SD.sup, edges, 'Normalization','probability');
histo.fr.sup.x = histo.fr.sup.x(1:end-1) + diff(histo.fr.sup.x);


%diff
[histo.dens.diff.y, histo.dens.diff.x] = histcounts(density2SD.diff, edges, 'Normalization','probability');
histo.dens.diff.x = histo.dens.diff.x(1:end-1) + diff(histo.dens.diff.x);
%deep
[histo.dens.deep.y, histo.dens.deep.x] = histcounts(density2SD.deep, edges, 'Normalization','probability');
histo.dens.deep.x = histo.dens.deep.x(1:end-1) + diff(histo.dens.deep.x);
%sup
[histo.dens.sup.y, histo.dens.sup.x] = histcounts(density2SD.sup, edges, 'Normalization','probability');
histo.dens.sup.x = histo.dens.sup.x(1:end-1) + diff(histo.dens.sup.x);


if 1
    [histo.fr.diff.x, histo.fr.diff.y] = stairs(histo.fr.diff.x, Smooth(histo.fr.diff.y,smoothing));
    [histo.fr.deep.x, histo.fr.deep.y] = stairs(histo.fr.deep.x, Smooth(histo.fr.deep.y,smoothing));
    [histo.fr.sup.x, histo.fr.sup.y] = stairs(histo.fr.sup.x, Smooth(histo.fr.sup.y,smoothing));
    
    [histo.dens.diff.x, histo.dens.diff.y] = stairs(histo.dens.diff.x, Smooth(histo.dens.diff.y,smoothing));
    [histo.dens.deep.x, histo.dens.deep.y] = stairs(histo.dens.deep.x, Smooth(histo.dens.deep.y,smoothing));
    [histo.dens.sup.x, histo.dens.sup.y] = stairs(histo.dens.sup.x, Smooth(histo.dens.sup.y,smoothing));
end


% number of nights above 30%
perc10.fr.diff = sum(fr2SD.diff<0.1)/length(fr2SD.diff);
perc10.fr.deep = sum(fr2SD.deep<0.1)/length(fr2SD.deep);
perc10.fr.sup  = sum(fr2SD.sup<0.1)/length(fr2SD.sup);

perc30.fr.diff = sum(fr2SD.diff<0.2)/length(fr2SD.diff);
perc30.fr.deep = sum(fr2SD.deep<0.2)/length(fr2SD.deep);
perc30.fr.sup  = sum(fr2SD.sup<0.2)/length(fr2SD.sup);


%% All mice
figure, hold on

% meancurves MUA DIFF
subplot(2,4,1), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    plot(thD_list, thresh_res.diff.firing_rate_norm{p}, 'color', 'k'),
end
title('2-layer detection'),
ylim([0 1]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Population firing rate');

% meancurves MUA DEEP
subplot(2,4,2), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    plot(thD_list, thresh_res.deep.firing_rate_norm{p}, 'color', 'r'),
end
title('Deep layer detection'),
ylim([0 1]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Population firing rate');

% meancurves MUA SUP
subplot(2,4,3), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    if ~isempty(thresh_res.sup.firing_rate_norm{p})
        plot(thD_list, thresh_res.sup.firing_rate_norm{p}, 'color', 'b'),
    end
end
title('Sup layer detection'),
ylim([0 1]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Population firing rate');

%histogram of FR at 2SD
subplot(2,4,4), hold on
h(1) = plot(histo.fr.diff.x, histo.fr.diff.y,'k','linewidth',2);
h(2) = plot(histo.fr.deep.x, histo.fr.deep.y,'r','linewidth',2);
h(3) = plot(histo.fr.sup.x, histo.fr.sup.y,'b','linewidth',2);
legend(h,'diff','deep','sup')
xlabel('firing rate with a 2 SD threshold'),


% density of deltas DIFF
subplot(2,4,5), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    plot(thD_list, thresh_res.diff.delta_density{p}, 'color', 'k'),
end
title('2-layer detection');
ylim([0 3.5]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Delta frequency');

% density of deltas DEEP
subplot(2,4,6), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    plot(thD_list, thresh_res.deep.delta_density{p}, 'color', 'r'),
end
title('Deep layer detection');
ylim([0 3.5]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Delta frequency');

% density of deltas SUP
subplot(2,4,7), hold on
for p=1:length(thresh_res.path)
    if ismember(p,path_exclude)
        continue
    end
    if ~isempty(thresh_res.sup.delta_density{p})
        plot(thD_list, thresh_res.sup.delta_density{p}, 'color', 'b'),
    end
end
title('Sup layer detection');
ylim([0 3.5]), xlim([0 4]),
line([2 2], ylim,'Linewidth',1,'color',[0.6 0.6 0.6],'LineStyle','--'), hold on
xlabel('SD threshold'); ylabel('Delta frequency');


%histogram of FR at 2SD
subplot(2,4,8), hold on
barvalue = [perc10.fr.diff perc10.fr.deep perc10.fr.sup; perc30.fr.diff perc30.fr.deep perc30.fr.sup]*100;
b = bar(barvalue,'FaceColor','flat');
b(1).CData = [0 0 0]; 
b(2).CData = [1 0 0];
b(3).CData = [0 0 1];
set(gca,'xtick',1:2,'xticklabel',{'below 10%','below 30%'},'ytick',0:20:100),
ylabel('%'), ylim([0 110])




% for p=1:length(thresh_res.path)
%     x_curve = thD_list;
%     y_curve = thresh_res.diff.firing_rate_norm{p};
%     
%     cond1 = any(y_curve(thD_list==2)>0.4);
%     cond2 = any(y_curve(thD_list==3.6)>0.3);
%     
%     if cond1||cond2
%         disp(thresh_res.path{p})
%         disp(p)
%     end
%     
% end
% 
% 
% for p=1:length(thresh_res.path)
%     x_curve = thD_list;
%     y_curve = thresh_res.diff.firing_rate_norm{p};
%     
%     cond1 = any(y_curve(thD_list==2)>0.25);
% %     cond2 = any(y_curve>2);
%     
%     if cond1
%         disp(thresh_res.path{p})
%         disp([num2str(thresh_res.nb_neuron{p}), ' neurons'])
%         disp([num2str(thresh_res.fr_upstate{p}), ' Hz'])
%     end
%     
% end

