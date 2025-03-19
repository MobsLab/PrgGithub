% Figure1DetectionPlot2
% 04.12.2016 KJ
%
% Plot the figures from the Figure1.pdf of Gaetan PhD
% - b & c
% 
%   see Figure1Detection
%


% load
clear
load([FolderProjetDelta 'Data/Figure1Detection.mat'])

animals = figure1_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
ColorsAnimals = {'k','b','r','g','m',[0.75 0.75 0.75],'c','y', [0.1 0.6 0.5]};

%% All mice
figure, hold on

% graphs B
subplot(2,3,1), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.diff.x{p}, figure1_res.graphB.diff.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPdiff');
ylabel('Firing rate');

subplot(2,3,2), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.deep.x{p}, figure1_res.graphB.deep.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPdeep');
ylabel('Firing rate');

subplot(2,3,3), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphB.sup.x{p}, figure1_res.graphB.sup.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPsup');
ylabel('Firing rate');


% graphs C
subplot(2,3,4), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.diff.x{p}, figure1_res.graphC.diff.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPdiff');
ylabel('Delta waves density');

subplot(2,3,5), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.deep.x{p}, figure1_res.graphC.deep.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPdeep');
ylabel('Delta waves density');

subplot(2,3,6), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphC.sup.x{p}, figure1_res.graphC.sup.y{p},'color',color_plot), hold on
    end
end
xlabel('Standard deviation applied to LFPsup');
ylabel('Delta waves density');


%% For each mice

for m=1:length(animals)
    figure, hold on
    color_plot = ColorsAnimals{m};

    % graphs B
    subplot(2,3,1), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphB.diff.x{p}, figure1_res.graphB.diff.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPdiff');
    ylabel('Firing rate');

    subplot(2,3,2), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphB.deep.x{p}, figure1_res.graphB.deep.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPdeep');
    ylabel('Firing rate');

    subplot(2,3,3), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphB.sup.x{p}, figure1_res.graphB.sup.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPsup');
    ylabel('Firing rate');


    % graphs C
    subplot(2,3,4), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphC.diff.x{p}, figure1_res.graphC.diff.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPdiff');
    ylabel('Delta waves density');

    subplot(2,3,5), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphC.deep.x{p}, figure1_res.graphC.deep.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPdeep');
    ylabel('Delta waves density');

    subplot(2,3,6), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphC.sup.x{p}, figure1_res.graphC.sup.y{p},'color',color_plot), hold on
        end
    end
    set(gca, 'YLim', [0 max(ylim)]);
    xlabel('Standard deviation applied to LFPsup');
    ylabel('Delta waves density');
    
    suplabel(animals{m},'t');

end


