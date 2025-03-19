% ClinicStatSlowWavesPlot1
% 06.07.2017 KJ
%
% Delta Stat
% 
% 
%   see ClinicStatSlowWaves ClinicStatSlowWavesPlot2 ClinicStatSlowWavesPlot3
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'b','k','g'};
device_name = {'Dreem', 'Actiwave'};

show_sig = 'sig';
show_points = 1;
paired = 0;


%% format data
for p=1:length(quantity_res.filename)
        data.auc(p) = nanmean(quantity_res.slowwaves.auc{p});
        data.amplitude(p) = nanmean(quantity_res.slowwaves.amplitude{p});
        data.slope(p) = nanmean(quantity_res.slowwaves.slope{p});
        data.density(p) = quantity_res.slowwaves.total{p}/quantity_res.night_duration{p};
end



%% data
for cond=1:length(conditions)
    %selected record 
    path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));

    %data
    slowwaves_cond{cond} = cell2mat(quantity_res.slowwaves.total(path_cond));

    auc_sw{cond} = data.auc(path_cond);
    amplitude_sw{cond} = data.amplitude(path_cond);
    slope_sw{cond} = data.slope(path_cond) / 1E4;
    density_cond{cond} = data.density(path_cond) * 60E4;
end





%% Number of slow waves
figure, hold on
[~,eb] = PlotErrorBarN_KJ(slowwaves_cond,'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'showPoints',show_points,'paired',paired);
set(eb,'Linewidth',2); %bold error bar
title('Number of Slow waves'),
ylabel('Number of slow waves'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,

%% Density of slow waves
figure, hold on
[~,eb] = PlotErrorBarN_KJ(density_cond,'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'showPoints',show_points,'paired',paired);
set(eb,'Linewidth',2); %bold error bar
title('Density of Slow waves'),
ylabel('slow waves per min'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,

%% AUC of slow waves
figure, hold on
[~,eb] = PlotErrorBarN_KJ(auc_sw,'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'showPoints',show_points,'paired',paired);
set(eb,'Linewidth',2); %bold error bar
title('AUC of Slow waves'),
ylabel('AUC'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,

%% Amplitude of slow waves
figure, hold on
[~,eb] = PlotErrorBarN_KJ(amplitude_sw,'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'showPoints',show_points,'paired',paired);
set(eb,'Linewidth',2); %bold error bar
title('Amplitude of Slow waves' ),
ylabel('µV'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,

%% Slope of slow waves
figure, hold on
[~,eb] = PlotErrorBarN_KJ(slope_sw,'newfig',0,'barcolors',colori,'ShowSigstar',show_sig,'showPoints',show_points,'paired',paired);
set(eb,'Linewidth',2); %bold error bar
title('Slope of Slow waves'),
ylabel('µV/s'),
set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,



