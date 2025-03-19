% QuantifSlowWaveSlowDynPlot
% 16.09.2018 KJ
%
% Infos
%   for each night :
%       - number of slow waves
%       - density
%       - distribution in substages
%       - slope
%       
%
% SEE 
%   QuantifSlowWaveSlowDyn QuantifSlowWaveSlowDynPlot2
%

clear
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'))

%% init

%params
step=10;
age_range = [20:step:50 90];
show_sig = 'sig';
showPoints = 0;

%colors
colori = [distinguishable_colors(length(age_range)-1)];
for i=1:length(age_range)-1
    colori_cluster{i} = colori(i,:);
end

%labels
for i=1:length(age_range)-2
    labels{i} = [num2str(age_range(i)) '-' num2str(age_range(i+1))]; 
end
labels{length(age_range)-1} = ['>' num2str(age_range(end-1))];


%%  pool

%age
all_ages = cell2mat(quantif_res.age);
%night variable
all_densityslope = cell2mat(quantif_res.density_slope);
all_nbslowwaves  = cell2mat(quantif_res.nb_slowwaves);
all_nightdur     = cell2mat(quantif_res.night_duration);
all_swdensity    = all_nbslowwaves ./ all_nightdur;   

%isi
all_peakIsi = [];
for p=1:length(quantif_res.filename)
    [~,idx] = max(Smooth(quantif_res.y_isi{p},1));
    all_peakIsi(p) = quantif_res.x_isi{p}(idx);
end

%others
all_slopes = [];
all_durations = [];
for p=1:length(quantif_res.filename)
    all_slopes(p) = median(quantif_res.slopes{p});
    all_durations(p) = median(quantif_res.durations{p});
    all_peak(p) = median(quantif_res.amplitude.peak{p});
    all_trough(p) = median(quantif_res.amplitude.trough{p});
    
end


%% data by range
for i=1:length(age_range)-1
    idx = all_ages>=age_range(i)&all_ages<age_range(i+1);
    
    density_slope_data{i} = all_densityslope(idx);
    nbslowwaves_data{i}   = all_nbslowwaves(idx);
    density_sw_data{i}    = all_swdensity(idx); 
    peak_isi_data{i}      = all_peakIsi(idx); 
    
    slopes_data{i}    = all_slopes(idx);
    durations_data{i} = all_durations(idx);
    peak_data{i}      = all_peak(idx);
    trough_data{i}    = all_trough(idx);
    
end



%% Plot
figure, hold on

%Density slope
subplot(2,3,1), hold on
PlotErrorBarN_KJ(density_slope_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Slope of SW density'),

%number of slow waves
subplot(2,3,2), hold on
PlotErrorBarN_KJ(nbslowwaves_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Number of slow waves'),

%Trough of slow waves
subplot(2,3,3), hold on
PlotErrorBarN_KJ(trough_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Negative amplitude of slow waves'),

%Slow waves slopes
subplot(2,3,4), hold on
PlotErrorBarN_KJ(slopes_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Slopes of slow waves'),

%Slow waves density
subplot(2,3,5), hold on
PlotErrorBarN_KJ(density_sw_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Density of slow waves'),

%Slow waves peak amplitude
subplot(2,3,6), hold on
PlotErrorBarN_KJ(peak_data, 'newfig',0, 'barcolors',colori_cluster, 'paired',0, 'showPoints',showPoints,'ShowSigstar',show_sig);
set(gca,'xtick',1:length(labels),'XtickLabel',labels),
title('Positive amplitude of slow waves'),



