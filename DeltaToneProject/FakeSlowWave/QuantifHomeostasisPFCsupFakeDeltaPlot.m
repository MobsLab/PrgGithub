%%QuantifHomeostasisPFCsupFakeDeltaPlot
% 03.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    ParcoursHomeostasisSleepCyclePlot QuantifHomeostasisPFCsupFakeDelta
%    QuantifHomeostasisPFCsupFakeDeltaPlot2
% 


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisPFCsupFakeDelta.mat'))

%colors
animals = unique(homeo_res.name);
color_animals = distinguishable_colors(length(animals));
for p=1:length(homeo_res.path)
    colori{p} = color_animals(strcmpi(animals,homeo_res.name{p}),:);
end


down.slopes = [];
good.slopes = [];
fake.slopes = [];

for p=1:length(homeo_res.path)
    
    %down
    x_peaks = homeo_res.down.x_peaks{p};
    y_peaks = homeo_res.down.y_peaks{p};
    [p1,~] = polyfit(x_peaks, y_peaks, 1);
    down.slope(p,1) = p1(1);
    
    %good delta
    x_peaks = homeo_res.good.x_peaks{p};
    y_peaks = homeo_res.good.y_peaks{p};
    [p1,~] = polyfit(x_peaks, y_peaks, 1);
    good.slope(p,1) = p1(1);
    
    %fake delta
    x_peaks = homeo_res.fake.x_peaks{p};
    y_peaks = homeo_res.fake.y_peaks{p};
    [p1,~] = polyfit(x_peaks, y_peaks, 1);
    fake.slope(p,1) = p1(1);
    
%     
%     down.slope(p,1)  = -homeo_res.down.p1{p}(1);
%     good.slope(p,1)  = -homeo_res.good.p1{p}(1);
%     fake.slope(p,1)  = -homeo_res.fake.p1{p}(1);
end


figure, hold on 
fontsize = 20;

PlotErrorBarN_KJ([-down.slope -good.slope -fake.slope], 'newfig',0, 'barcolors',{'k','b','r'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:3,'XtickLabel',{'down states','good delta','fake delta'},'Fontsize',fontsize),
ylabel('slopes value (delta/min/h)');
title('Slopes')




