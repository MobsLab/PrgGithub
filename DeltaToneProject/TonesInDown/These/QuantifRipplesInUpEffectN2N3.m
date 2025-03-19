%%QuantifRipplesInUpEffectN2N3
% 18.09.2019 KJ
%
% effect of tones in down states
% in N2 and N3
%
%   see 
%       FigRipplesInUpN2N3 QuantifTonesInUpEffectN2N3
% 


%load
clear

load(fullfile(FolderDeltaDataKJ,'RipplesInUpN2N3Effect.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;


animals = unique(ripples_res.name);


%% transitions probability

proba.n2.ripples = [];
proba.n3.ripples = [];
proba.nrem.ripples = [];
proba.n2.sham = [];
proba.n3.sham = [];
proba.nrem.sham = [];
for m=1:length(animals)
    
    probn2_rip = []; probn2_sham = [];
    probn3_rip = []; probn3_sham = [];
    probnrem_rip = []; probnrem_sham = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            probn2_rip = [probn2_rip ripples_res.n2.transit_rate.ripples{p}];
            probn3_rip = [probn3_rip ripples_res.n3.transit_rate.ripples{p}];
            probnrem_rip = [probnrem_rip ripples_res.nrem.transit_rate.ripples{p}];
            
            probn2_sham = [probn2_sham ripples_res.n2.transit_rate.sham{p}];
            probn3_sham = [probn3_sham ripples_res.n3.transit_rate.sham{p}];
            probnrem_sham = [probnrem_sham ripples_res.nrem.transit_rate.sham{p}];
        end
    end
    
    %N2
    proba.n2.ripples = [proba.n2.ripples mean(probn2_rip)];
    proba.n2.sham    = [proba.n2.sham mean(probn2_sham)];
    %N3
    proba.n3.ripples = [proba.n3.ripples mean(probn3_rip)];
    proba.n3.sham    = [proba.n3.sham mean(probn3_sham)];
    %NREM
    proba.nrem.ripples = [proba.nrem.ripples mean(probnrem_rip)];
    proba.nrem.sham    = [proba.nrem.sham mean(probnrem_sham)];
end



%% PLOT Bar Transition probability

figure, hold on 
fontsize = 20;
gap = [0.1 0.05];
paired = 1;
optiontest = 'ranksum';

colors_rip = {[0 0.5 0],[1 1 0.8]};
colors_sham = {[1 0 0],[1 0.5 0.5]};


%params
XL = [0.9 2.1];
Xbar = [1.2 1.8];
YL = [0 0.25];

%NREM
subtightplot(2,4,2,gap), hold on
notBoxPlot(proba.nrem.ripples,Xbar(1), 'patchColors', colors_rip),
notBoxPlot(proba.nrem.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.nrem.ripples)
    line(Xbar, [proba.nrem.ripples(l) proba.nrem.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.15 0.15], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.155, '**', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'SPW-r','sham'},'xlim', XL),
title('NREM'), ylabel({'Up>Down', 'transition probability'}),


%N2
subtightplot(2,4,3,gap), hold on
notBoxPlot(proba.n2.ripples,Xbar(1), 'patchColors', colors_rip),
notBoxPlot(proba.n2.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.n2.ripples)
    line(Xbar, [proba.n2.ripples(l) proba.n2.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.15 0.15], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.155, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'SPW-r','random'},'xlim', XL),
title('N2'), %ylabel('%transition probability'),

%N3
subtightplot(2,4,4,gap), hold on
notBoxPlot(proba.n3.ripples,Xbar(1), 'patchColors', colors_rip),
notBoxPlot(proba.n3.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.n3.ripples)
    line(Xbar, [proba.n3.ripples(l) proba.n3.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.23 0.23], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.235, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'SPW-r','random'},'xlim', XL),
title('N3'), %ylabel('%transition probability'),









