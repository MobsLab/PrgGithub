%%QuantifTonesInUpEffectN2N3
% 18.09.2019 KJ
%
% effect of tones in down states
% in N2 and N3
%
%   see 
%       FigTonesInUpN2N3 QuantifTonesInUpEffectN2N3
% 

%load
clear

load(fullfile(FolderDeltaDataKJ,'TonesInUpN2N3Effect.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInUpN2N3Effect.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;

animals = unique(tones_res.name);


%% transitions probability

%tones
proba.n2.tones = [];
proba.n3.tones = [];
proba.nrem.tones = [];

for m=1:length(animals)
    
    probn2_mouse = [];
    probn3_mouse = [];
    probnrem_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probn2_mouse = [probn2_mouse tones_res.n2.transit_rate{p}];
            probn3_mouse = [probn3_mouse tones_res.n3.transit_rate{p}];
            probnrem_mouse = [probnrem_mouse tones_res.nrem.transit_rate{p}];
        end
    end
    
    %N2
    proba.n2.tones(m,1) = mean(probn2_mouse);
    %N3
    proba.n3.tones(m,1) = mean(probn3_mouse);
    %NREM
    proba.nrem.tones(m,1) = mean(probnrem_mouse);
end



%sham
proba.n2.sham = [];
proba.n3.sham = [];
proba.nrem.sham = [];
for m=1:length(animals)
    
    probn2_mouse = [];
    probn3_mouse = [];
    probnrem_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            probn2_mouse = [probn2_mouse sham_res.n2.transit_rate{p}];
            probn3_mouse = [probn3_mouse sham_res.n3.transit_rate{p}];
            probnrem_mouse = [probnrem_mouse sham_res.nrem.transit_rate{p}];
        end
    end
    
    %N2
    proba.n2.sham(m,1) = mean(probn2_mouse);
    %N3
    proba.n3.sham(m,1) = mean(probn3_mouse);
    %NREM
    proba.nrem.sham(m,1) = mean(probnrem_mouse);
end


%% PLOT Bar Transition probability

figure, hold on 
fontsize = 20;
gap = [0.1 0.05];
paired = 1;
optiontest = 'ranksum';

colors_tones = {[0 0 1],[0.53 0.81 0.98]}; 
colors_sham = {[0.3 0.3 0.3],[0.7 0.7 0.7]};

%params
XL = [0.9 2.1];
Xbar = [1.2 1.8];
YL = [0 1.1];

%NREM
subtightplot(2,4,1,gap), hold on
notBoxPlot(proba.nrem.tones,Xbar(1), 'patchColors', colors_tones),
notBoxPlot(proba.nrem.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.nrem.tones)
    line(Xbar, [proba.nrem.tones(l) proba.nrem.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.95 0.95], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.97, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'tones','sham'},'xlim', XL),
title('NREM'), ylabel('%transition probability'),


%N2
subtightplot(2,4,2,gap), hold on
notBoxPlot(proba.n2.tones,Xbar(1), 'patchColors', colors_tones),
notBoxPlot(proba.n2.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.n2.tones)
    line(Xbar, [proba.n2.tones(l) proba.n2.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.95 0.95], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.97, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'tones','sham'},'xlim', XL),
title('N2'), %ylabel('%transition probability'),

%N3
subtightplot(2,4,3,gap), hold on
notBoxPlot(proba.n3.tones,Xbar(1), 'patchColors', colors_tones),
notBoxPlot(proba.n3.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.n3.tones)
    line(Xbar, [proba.n3.tones(l) proba.n3.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.95 0.95], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.97, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ylim',YL,'ytick',0:0.2:1,'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'tones','sham'},'xlim', XL),
title('N3'), %ylabel('%transition probability'),




