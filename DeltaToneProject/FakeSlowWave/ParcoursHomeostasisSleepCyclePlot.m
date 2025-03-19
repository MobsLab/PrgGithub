%%ParcoursHomeostasisSleepCyclePlot
% 03.09.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    ParcoursHomeostasisSleepCycle GlobalSleepHomeostasisSleepCycle


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasisSleepCycle.mat'))

%colors
animals = unique(homeo_res.name);
color_animals = distinguishable_colors(length(animals));
for p=1:length(homeo_res.path)
    colori{p} = color_animals(strcmpi(animals,homeo_res.name{p}),:);
end

%% bar Plot
% 
% down.slope = [];
% good.slope = [];
% fake.slope = [];
% 
% for p=1:length(homeo_res.path)
%     
%     down.slope(p,1)  = -homeo_res.down.sleepcycle.p_reg{p}(1);
%     delta.slope(p,1) = -homeo_res.delta.sleepcycle.p_reg{p}(1);
%     good.slope(p,1)  = -homeo_res.good.sleepcycle.p_regC{p}(1);
%     fake.slope(p,1)  = -homeo_res.fake.sleepcycle.p_regC{p}(1);
%     deep.slope(p,1)  = -homeo_res.deep.sleepcycle.p_reg{p}(1);
% end
% 
% 
% figure, hold on 
% fontsize = 20;
% 
% PlotErrorBarN_KJ([down.slope delta.slope deep.slope], 'newfig',0, 'barcolors',{'k', [0.4 0.4 0.4],'r'}, 'paired',1, 'optiontest','ranksum', 'showPoints',1,'ShowSigstar','sig');
% set(gca,'xtick',1:3,'XtickLabel',{'down','delta diff','all delta deep'},'Fontsize',fontsize),
% title('Slopes')
% 
% 
% figure, hold on
% PlotErrorBarN_KJ([down.slope delta.slope deep.slope good.slope fake.slope], 'newfig',0, 'barcolors',{'k', [0.4 0.4 0.4],'k','r','b'}, 'paired',1, 'optiontest','ranksum', 'showPoints',0,'ShowSigstar','none');
% set(gca,'xtick',1:5,'XtickLabel',{'down','diff','deep','good', 'fake'},'Fontsize',10),
% title('Slopes')
% 


%% slope Plot
figure, hold on

%down states
subplot(2,2,1), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.down.density.x{p}, homeo_res.down.nrem.reg{p}, 'color',colori{p})
    
end
xlabel('h'), ylabel('down per minute'),
title('Down states homeostasis')

%delta waves
subplot(2,2,2), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.delta.density.x{p}, homeo_res.delta.nrem.reg{p}, 'color',colori{p})
end
xlabel('h'), ylabel('delta per minute'),
title('Delta waves (diff) homeostasis')

%good deltas
subplot(2,2,3), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.good.density.x{p}, homeo_res.good.nrem.reg{p}, 'color',colori{p})
end
xlabel('h'), ylabel('delta per minute'),
title('Good slow waves homeostasis')


%fake deltas
subplot(2,2,4), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.fake.density.x{p}, homeo_res.fake.nrem.reg{p}, 'color',colori{p})
end
xlabel('h'), ylabel('delta per minute'),
title('Fake slow waves homeostasis')






%% Density plot

figure, hold on

%down states
subplot(2,2,1), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.down.density.x{p}, homeo_res.down.nrem.reg{p},'k.')
    hold on, scatter(homeo_res.down.nrem.peaks.x{p}, homeo_res.down.nrem.peaks.y{p},'r')
end
xlabel('h'), ylabel('down per minute'),
title('Down states homeostasis')

%delta waves
subplot(2,2,2), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.delta.density.x{p}, homeo_res.delta.nrem.reg{p},'k.')
    hold on, scatter(homeo_res.delta.nrem.peaks.x{p}, homeo_res.delta.nrem.peaks.y{p},'r')
end
xlabel('h'), ylabel('delta per minute'),
title('Delta waves (diff) homeostasis')

%good deltas
subplot(2,2,3), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.good.density.x{p}, homeo_res.good.nrem.reg{p},'k.')
    hold on, scatter(homeo_res.good.nrem.peaks.x{p}, homeo_res.good.nrem.peaks.y{p},'r')
end
xlabel('h'), ylabel('delta per minute'),
title('Good slow waves homeostasis')


%fake deltas
subplot(2,2,4), hold on
for p=1:length(homeo_res.path)
    hold on, plot(homeo_res.fake.density.x{p}, homeo_res.fake.nrem.reg{p},'k.')
    hold on, scatter(homeo_res.fake.nrem.peaks.x{p}, homeo_res.fake.nrem.peaks.y{p},'r')
end
xlabel('h'), ylabel('delta per minute'),
title('Fake slow waves homeostasis')









% %down
% down.x_intervals = [];
% 
% down.nrem.peaks.x = [];
% down.nrem.peaks.y = [];
% down.nrem.reg = [];
% 
% down.sleepcycle.peaks.x = [];
% down.sleepcycle.peaks.y = [];
% down.sleepcycle.reg = [];
% 
% 
% for p=1:length(homeo_res.path)
%     
%     
%     
%     %down
%     down.x_intervals = [down.x_intervals ];
%     down.nrem.reg = [down.nrem.reg ];
%     down.sleepcycle.reg = [down.sleepcycle.reg ];
%     
%     down.nrem.peaks.x = [down.nrem.peaks.x ; homeo_res.down.nrem.peaks.x{p}];
%     down.nrem.peaks.y = [down.nrem.peaks.y ; homeo_res.down.nrem.peaks.y{p}];
%     down.sleepcycle.peaks.x = [down.sleepcycle.peaks.x ; homeo_res.down.sleepcycle.peaks.x{p}];
%     down.sleepcycle.peaks.y = [down.sleepcycle.peaks.y ; homeo_res.down.sleepcycle.peaks.y{p}];
%     
% 
%     
%     %save
%     homeo_res.down.density.x{p} = x_intervals;
%     homeo_res.down.density.y{p} = y_density;
%     
%     homeo_res.down.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
%     homeo_res.down.nrem.peaks.y{p} =  y_density(idx_peaks1);
%     homeo_res.down.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
%     homeo_res.down.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
%     
%     homeo_res.down.nrem.p_reg{p} = p1;
%     homeo_res.down.nrem.reg{p}   = reg1;
%     homeo_res.down.sleepcycle.p_reg{p} = p2;
%     homeo_res.down.sleepcycle.reg{p}   = r2;
%     
%     
%    
%     
%         
%     
% end
% 





