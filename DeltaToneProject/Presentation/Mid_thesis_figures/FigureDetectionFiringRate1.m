% FigureDetectionFiringRate1
% 14.12.2016 KJ
%
% Plot the figures from the Figure1.pdf of Gaetan PhD
% - a
% 
%   see Figure1Detection FigureDetectionFiringRate2
%



% load
clear
load([FolderProjetDelta 'Data/Figure1Detection.mat'])

animals = figure1_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
fr_color = [0.75 0.75 0.75];
thresh_fr = 0.09;


%% All mice
figure, hold on

% graphs A up
subplot(2,3,1), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        if all(figure1_res.graphA1.diff.y{p}<thresh_fr)
            plot(figure1_res.graphA1.diff.x{p}, figure1_res.graphA1.diff.y{p},'color',fr_color), hold on
        end
    end
end
set(gca, 'YTick',[0 0.03 0.06 0.09],'YLim',[0 0.09],'FontName','Times','fontsize',12);
title('LFP diff', 'FontSize', 15);
xlabel('ms', 'FontSize', 12); ylabel('Population firing rate', 'FontSize', 12);

subplot(2,3,2), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        if all(figure1_res.graphA1.deep.y{p}<thresh_fr)
            plot(figure1_res.graphA1.deep.x{p}, figure1_res.graphA1.deep.y{p},'color',fr_color), hold on
    
        end
    end
end
set(gca, 'YTick',[0 0.03 0.06 0.09],'YLim',[0 0.09],'FontName','Times','fontsize',12);
title('LFP deep', 'FontSize', 15);
xlabel('ms', 'FontSize', 12);

subplot(2,3,3), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        if all(figure1_res.graphA1.sup.y{p}<thresh_fr) & all(figure1_res.graphA2.sup.y{p}(figure1_res.graphA2.sup.x{p}==0)<0)
            plot(figure1_res.graphA1.sup.x{p}, figure1_res.graphA1.sup.y{p},'color',fr_color), hold on
        end
    end
end
set(gca, 'YTick',[0 0.03 0.06 0.09],'YLim',[0 0.09],'FontName','Times','fontsize',12);
title('LFP sup', 'FontSize', 15);
xlabel('ms', 'FontSize', 12);

% graphs A down
subplot(2,3,4), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        plot(figure1_res.graphA2.diff.x{p}, figure1_res.graphA2.diff.y{p},'color','k'), hold on
    end
end
set(gca, 'YTick',-2000:1000:2000,'YLim',[-2500 2500],'FontName','Times','fontsize',12);
xlabel('ms', 'FontSize', 12); ylabel('Diff LFP - deep vs sup', 'FontSize', 12);

subplot(2,3,5), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        plot(figure1_res.graphA2.deep.x{p}, figure1_res.graphA2.deep.y{p},'color','b'), hold on
    end
end
set(gca, 'YTick',-2000:1000:2000,'YLim',[-2500 2500],'FontName','Times','fontsize',12);
xlabel('ms', 'FontSize', 12); 

subplot(2,3,6), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        if all(figure1_res.graphA2.sup.y{p}(figure1_res.graphA2.sup.x{p}==0)<0)
            plot(figure1_res.graphA2.sup.x{p}, figure1_res.graphA2.sup.y{p},'color','r'), hold on
        end
    end
end
set(gca, 'YTick',-2000:1000:2000,'YLim',[-2500 2500],'FontName','Times','fontsize',12);
xlabel('ms', 'FontSize', 12);

