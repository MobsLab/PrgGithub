%%QuantifHomeostasisPFCsupFakeDeltaPlot2
% 03.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    ParcoursHomeostasisSleepCyclePlot QuantifHomeostasisPFCsupFakeDelta


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCsupFakeDelta.mat'))

%colors
animals = unique(homeo_res.name);
color_animals = distinguishable_colors(length(animals));
for p=1:length(homeo_res.path)
    colori{p} = color_animals(strcmpi(animals,homeo_res.name{p}),:);
end


for p=1:length(homeo_res.path)
    
    
    x_intervals = homeo_res.good.x_intervals{p};
    y_density = homeo_res.good.y_density{p};
    x_peaks = homeo_res.good.x_peaks{p};
    y_peaks = homeo_res.good.y_peaks{p};
    p1 = homeo_res.good.p1{p};
    reg1 = homeo_res.good.reg1{p};
    
    
    %polyfit 2nd order
    [p2,~] = polyfit(x_peaks, y_peaks, 2);
    reg2 = polyval(p2,x_intervals);
    
    
    %
    smooth_peaks = smooth(y_peaks,1);
    derivative_peaks = diff(smooth_peaks) ./ diff(x_peaks);
    x_deriv = x_peaks(1:end-1);
    
    %plot
    figure, hold on,
    
    subplot(3,1,[1 2]), hold on
    plot(x_intervals,y_density,'r')
    hold on, scatter(x_peaks, y_peaks,25,'r')
    
    plot(x_intervals, reg1, 'k'),
    plot(x_intervals, reg2, 'b'),
    
    x_lim = get(gca, 'xlim');
    
    subplot(3,1,3), hold on
    plot(x_deriv, derivative_peaks, 'k', 'linewidth',2)
    xlim(x_lim)
end




