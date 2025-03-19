% FigureDetectionFiringRate2
% 14.12.2016 KJ
%
% Plot the figures from the Figure1.pdf of Gaetan PhD
% - b & c
% 
%   see Figure1Detection FigureDetectionFiringRate1
%



% load
clear
load([FolderProjetDelta 'Data/Figure1Detection.mat'])

animals = figure1_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
ColorsAnimals = {'k','b','k','b',[0.75 0.75 0.75],'g','m','c','y', [0.1 0.6 0.5]};
LinestyleAnimals = {'-','-','-','-','--','--','--','--', '--'};

%% select record with spike
for p=1:length(figure1_res.path)
    figure1_res.with_spike(p)=0;
end
Dir1 = PathForExperimentsDeltaSleepSpikes('Basal');
Dir2 = PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir3 = PathForExperimentsDeltaSleepSpikes('DeltaToneAll');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = MergePathForExperiment(Dir,Dir3);
Dir = RestrictPathForExperiment(Dir,'nMice',[251 252]);

for p=1:length(Dir.path)
    pres = strcmpi(figure1_res.path,Dir.path{p});
    figure1_res.with_spike(pres)=1;
end

clear Dir Dir1 Dir2 Dir3

%% All mice
figure, hold on

% graphs B
subplot(3,3,1), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.diff.x{p}, figure1_res.graphB.diff.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
title('LFP diff', 'FontSize', 15);
ylabel('Firing rate', 'FontSize', 12);



subplot(3,3,2), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.deep.x{p}, figure1_res.graphB.deep.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
title('LFP deep', 'FontSize', 15);

subplot(3,3,3), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.sup.x{p}, figure1_res.graphB.sup.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
title('LFP sup', 'FontSize', 15);


% graphs B - normalized
subplot(3,3,4), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        signal = figure1_res.graphB.diff.y{p} / max(figure1_res.graphB.diff.y{p});
        plot(figure1_res.graphB.diff.x{p}, signal,'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
ylabel('Normalized Firing rate', 'FontSize', 12);



subplot(3,3,5), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        signal = figure1_res.graphB.deep.y{p} / max(figure1_res.graphB.deep.y{p});
        plot(figure1_res.graphB.deep.x{p}, signal,'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on

subplot(3,3,6), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        signal = figure1_res.graphB.sup.y{p} / max(figure1_res.graphB.sup.y{p});
        plot(figure1_res.graphB.sup.x{p}, signal,'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4],'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on


% graphs C
subplot(3,3,7), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.diff.x{p}, figure1_res.graphC.diff.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4], 'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
xlabel('Standard deviation applied to LFP diff', 'FontSize', 12);
ylabel('Delta waves density', 'FontSize', 12);

subplot(3,3,8), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.deep.x{p}, figure1_res.graphC.deep.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4], 'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
xlabel('Standard deviation applied to LFP deep', 'FontSize', 12);

subplot(3,3,9), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p}) & figure1_res.with_spike(p)==1
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        style_plot = LinestyleAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.sup.x{p}, figure1_res.graphC.sup.y{p},'color',color_plot,'Linestyle',style_plot), hold on
    end
end
set(gca, 'XTick',[0 2 4], 'FontName','Times','fontsize',12);
line([2 2],ylim,'color','k','Linestyle','--'), hold on
xlabel('Standard deviation applied to LFP sup', 'FontSize', 12);




