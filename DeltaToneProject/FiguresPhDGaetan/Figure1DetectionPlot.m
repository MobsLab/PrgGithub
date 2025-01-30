% Figure1DetectionPlot
% 04.12.2016 KJ
%
% Plot the figures from the Figure1.pdf of Gaetan PhD
% 
% 
%   see Figure1Detection Figure1DetectionPlot2
%


% load
clear
load([FolderProjetDelta 'Data/Figure1Detection.mat'])

animals = figure1_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
ColorsAnimals = {'k','b','r','g','m',[0.75 0.75 0.75],'c','y', [0.1 0.6 0.5]};

%% All mice
figure, hold on

% graphs A up
subplot(2,3,1), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA1.diff.x{p}, figure1_res.graphA1.diff.y{p},'color',color_plot), hold on
    end
end
title('LFPdiff');
xlabel('ms'); ylabel('Population firing rate');

subplot(2,3,2), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA1.deep.x{p}, figure1_res.graphA1.deep.y{p},'color',color_plot), hold on
    end
end
title('LFPdeep');
xlabel('ms'); ylabel('Population firing rate');

subplot(2,3,3), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA1.sup.x{p}, figure1_res.graphA1.sup.y{p},'color',color_plot), hold on
    end
end
title('LFPsup');
xlabel('ms'); ylabel('Population firing rate');

% graphs A down
subplot(2,3,4), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA2.diff.x{p}, figure1_res.graphA2.diff.y{p},'color',color_plot), hold on
    end
end
title('LFPdiff');
xlabel('ms'); ylabel('Diff LFP - deep vs sup');

subplot(2,3,5), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA2.deep.x{p}, figure1_res.graphA2.deep.y{p},'color',color_plot), hold on
    end
end
title('LFPdeep');
xlabel('ms'); ylabel('Diff LFP - deep vs sup');

subplot(2,3,6), hold on
for p=1:length(figure1_res.path)
    if ~isempty(figure1_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure1_res.name{p})};
        plot(figure1_res.graphA2.sup.x{p}, figure1_res.graphA2.sup.y{p},'color',color_plot), hold on
    end
end
title('LFPsup');
xlabel('ms'); ylabel('Diff LFP - deep vs sup');


%% For each mice

for m=1:length(animals)
    figure, hold on
    color_plot = ColorsAnimals{m};

    % graphs A up
    subplot(2,3,1), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA1.diff.x{p}, figure1_res.graphA1.diff.y{p},'color',color_plot), hold on
        end
    end
    title('LFPdiff');
    xlabel('ms'); ylabel('Population firing rate');

    subplot(2,3,2), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA1.deep.x{p}, figure1_res.graphA1.deep.y{p},'color',color_plot), hold on
        end
    end
    title('LFPdeep');
    xlabel('ms'); ylabel('Population firing rate');

    subplot(2,3,3), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA1.sup.x{p}, figure1_res.graphA1.sup.y{p},'color',color_plot), hold on
        end
    end
    title('LFPsup');
    xlabel('ms'); ylabel('Population firing rate');

    % graphs A down
    subplot(2,3,4), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA2.diff.x{p}, figure1_res.graphA2.diff.y{p},'color',color_plot), hold on
        end
    end
    title('LFPdiff');
    xlabel('ms'); ylabel('Diff LFP - deep vs sup');

    subplot(2,3,5), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA2.deep.x{p}, figure1_res.graphA2.deep.y{p},'color',color_plot), hold on
        end
    end
    title('LFPdeep');
    xlabel('ms'); ylabel('Diff LFP - deep vs sup');

    subplot(2,3,6), hold on
    for p=1:length(figure1_res.path)
        if strcmpi(figure1_res.name{p},animals{m})
            plot(figure1_res.graphA2.sup.x{p}, figure1_res.graphA2.sup.y{p},'color',color_plot), hold on
        end
    end
    title('LFPsup');
    xlabel('ms'); ylabel('Diff LFP - deep vs sup');

    
    
    suplabel(animals{m},'t');
end


