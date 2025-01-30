% FigureEvolutionSWA1
% 14.12.2016 KJ
%
% Collect data to plot the figures from the Figure3.pdf of Gaetan PhD
% 
% 
%   see Figure3PowerDensityPlot Figure3PowerDensity
%


clear
load([FolderProjetDelta 'Data/Figure3PowerDensity.mat']) 

animals = figure3_res.name;
animals = unique(animals(~cellfun('isempty',animals)));


%% All mice

% graphs A left
mean_sopower_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        try
            so_power = figure3_res.graphA.so_power_hours{p};
            so_power = so_power / max(so_power);
            mean_sopower_hours = [mean_sopower_hours;so_power];
        end
    end
end



%line delta density
mean_density_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        try
            density = figure3_res.graphB.delta_density{p};
            density(density==0) = nan;
            mean_density_hours = [mean_density_hours;density];
        end
    end
end

%line ratio sws
mean_swsratio_hours = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        try
            ratio = figure3_res.graphB.sws_ratio{p};
            ratio(ratio==0)=nan;
            mean_swsratio_hours = [mean_swsratio_hours;ratio];
        end
    end
end

% Bar plot : midday vs evening
mean_sopower = [];
for p=1:length(figure3_res.path)
    if ~isempty(figure3_res.path{p})
        try
            mean_sopower = [mean_sopower;figure3_res.graphA.so_power_noonevening{p}];
        end
    end
end

%% remove artefact
[~,i]=max(mean_sopower(:,2)-mean_sopower(:,1));
mean_sopower(i,:)=[];
[~,i]=max(mean_sopower(:,1)-mean_sopower(:,2));
mean_sopower(i,:)=[];

%% restrict to 10h 19h
idx_plot = hours_expe<19;
hours_expe_plot = hours_expe(idx_plot);
mean_sopower_hours = mean_sopower_hours(:,idx_plot);
mean_density_hours = mean_density_hours(:,idx_plot);
mean_swsratio_hours = mean_swsratio_hours(:,idx_plot);


%% PLOT

% graphs A left
figure, hold on
[~,h(1)] = PlotErrorLineN_KJ(mean_sopower_hours, 'x_data',hours_expe_plot, 'newfig',0,'linecolor','b','ShowSigstar','none'); hold on
[~,h(2)] = PlotErrorLineN_KJ(mean_density_hours, 'x_data',hours_expe_plot, 'newfig',0,'linecolor','k','ShowSigstar','none'); hold on
[~,h(3)] = PlotErrorLineN_KJ(mean_swsratio_hours, 'x_data',hours_expe_plot, 'newfig',0,'linecolor','r','ShowSigstar','none'); hold on
h_leg = legend(h,{' SWA (norm): Power 2-4 Hz', ' Delta waves per sec', ' SWS ratio'});
set(h_leg,'FontSize',20);
set(gca, 'XTick',10:19,'XLim',[9 19],'YLim',[0.3 1],'YTick',0:0.2:1,'FontName','Times','fontsize',14);
xlabel('time of the day (h)','fontsize',18);

% graphs A right
barcolor='k';

figure, hold on
labels = {'12-14h','17-19h'};
PlotErrorBarN_KJ(mean_sopower, 'newfig',0,'y_lim',[0 3E9],'barcolors',barcolor);
xlabel('time of the day'), ylabel(['Slow Oscillation Power (2-4 Hz) (n=' num2str(length(figure3_res.path)) ')']),
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',20), hold on,







