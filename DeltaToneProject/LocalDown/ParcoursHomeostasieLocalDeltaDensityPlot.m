%%ParcoursHomeostasieLocalDeltaDensityPlot
% 06.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensity QuantifHomeostasisPFCsupFakeDeltaPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaDensity.mat'))

rescaleslope = 0;

%% concatenate
down.global.slope  = [];
down.local.slope   = [];
delta.global.slope = [];
delta.local.slope  = [];
delta.fake.slope   = [];

tt = 2;

for p=1:length(homeo_res.path)
    
    if rescaleslope
        %down
        x_peaks = homeo_res.down.x_peaks{p};
        y_peaks = rescaleslope(homeo_res.down.y_peaks{p});
        [p1,~] = polyfit(x_peaks, y_peaks, 1);
        down.slope(p,1) = p1(1);
        
    else
        down.global.slope(p,1)  = homeo_res.down.global.p2{p}(1);
        down.local.slope(p,1)   = homeo_res.down.local.p2{p,tt}(1);
        delta.global.slope(p,1) = homeo_res.delta.global.p2{p,tt}(1);
        delta.local.slope(p,1)  = homeo_res.delta.local.p2{p,tt}(1);
        delta.fake.slope(p,1)   = homeo_res.delta.fake.p2{p,tt}(1);
    end

end


figure, hold on 
fontsize = 15;

%down local vs global
subplot(1,2,1), hold on
PlotErrorBarN_KJ([down.global.slope down.local.slope], 'newfig',0, 'barcolors',{'k','b'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:2,'XtickLabel',{'global down','local down'},'Fontsize',fontsize),
ylabel('slopes value (delta/min/h)');

%delta waves
subplot(1,2,2), hold on
PlotErrorBarN_KJ([delta.global.slope delta.local.slope delta.fake.slope], 'newfig',0, 'barcolors',{'k','b','r'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
set(gca,'xtick',1:3,'XtickLabel',{'global delta','local delta', 'fake delta'},'Fontsize',fontsize),
ylabel('slopes value (delta/min/h)');


