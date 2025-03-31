% Figure3PowerDensityPlot
% 04.12.2016 KJ
%
% Collect data to plot the figures from the Figure3.pdf of Gaetan PhD
% 
% 
%   see Figure3PowerDensity
%


clear
load([FolderProjetDelta 'Data/Figure3PowerDensity.mat']) 

animals = figure3_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
ColorsAnimals = {'k','b','r','g','m',[0.75 0.75 0.75],'c','y', [0.1 0.6 0.5]};

%% All mice
figure, hold on

% graphs A left
subplot(2,2,1), hold on
mean_sopower_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure3_res.name{p})};
        try
            so_power = figure3_res.graphA.so_power_hours{p};
            if any(so_power>16E8)
                so_power = nan(length(so_power));
            end
            plot(hours_expe, so_power,'color',color_plot), hold on
            mean_sopower_hours = [mean_sopower_hours;so_power];
        end
    end
end
for i=1:size(mean_sopower_hours,2)
    A{i}=mean_sopower_hours(:,i);
end
R=[];
E=[];
for i=1:length(A)
    [Ri,~,Ei]=MeanDifNan(A{i});
    R=[R,Ri];
    E=[E,Ei];
end
h1 = bar(hours_expe,R,'k');
h2 = errorbar(hours_expe,R,E,'+','Color','k');
uistack(h1,'bottom');uistack(h2,'bottom');
xlim([9 21]);ylim([0 1.8E9]);
xlabel('h'); ylabel('Slow Oscillation Power (2-4 Hz)');

% graphs A right
subplot(2,2,2), hold on
mean_sopower = [];
labels = {'12-14h','17-19h'};
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure3_res.name{p})};
        try
            mean_sopower = [mean_sopower;figure3_res.graphA.so_power_noonevening{p}];
        end
    end
end
PlotErrorBarN_KJ(mean_sopower, 'newfig',0,'y_lim',[0 3E9]);
xlabel('time of the day'), ylabel(['Slow Oscillation Power (2-4 Hz) (n=' num2str(length(figure3_res.path)) ')']),
ylim([0 3E9]);
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,




% graphs B left
subplot(2,2,3), hold on
mean_density_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure3_res.name{p})};
        try
            density = figure3_res.graphB.delta_density{p};
            density(density==0) = nan;
            plot(hours_expe, density,'color',color_plot), hold on
            mean_density_hours = [mean_density_hours;density];
        end
    end
end
for i=1:size(mean_density_hours,2)
    A{i}=mean_density_hours(:,i);
end
R=[];
E=[];
for i=1:length(A)
    [Ri,~,Ei]=MeanDifNan(A{i});
    R=[R,Ri];
    E=[E,Ei];
end
h1 = bar(hours_expe,R,'k');
h2 = errorbar(hours_expe,R,E,'+','Color','k');
uistack(h1,'bottom');uistack(h2,'bottom');
xlim([9 21])
xlabel('h'); ylabel('Delta waves Frequency');


% graphs B left
subplot(2,2,4), hold on
mean_swsratio_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        color_plot = ColorsAnimals{ismember(animals, figure3_res.name{p})};
        try
            ratio = figure3_res.graphB.sws_ratio{p};
            ratio(ratio==0)=nan;
            plot(hours_expe, ratio,'color',color_plot), hold on
            mean_swsratio_hours = [mean_swsratio_hours;ratio];
        end
    end
end
for i=1:size(mean_swsratio_hours,2)
    A{i}=mean_swsratio_hours(:,i);
end
R=[];
E=[];
for i=1:length(A)
    [Ri,~,Ei]=MeanDifNan(A{i});
    R=[R,Ri];
    E=[E,Ei];
end
h1 = bar(hours_expe,R,'k');
h2 = errorbar(hours_expe,R,E,'+','Color','k');
uistack(h1,'bottom');uistack(h2,'bottom');
xlim([9 21])
xlabel('h'); ylabel('SWS ratio');













