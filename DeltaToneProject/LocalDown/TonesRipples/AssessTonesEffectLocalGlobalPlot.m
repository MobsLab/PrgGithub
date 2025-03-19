%%AssessTonesEffectLocalGlobalPlot
% 01.12.2019 KJ
%
% effect of tones in down states
% in N2 and N3
%
%   see 
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'AssessTonesEffectLocalGlobal.mat'))
load(fullfile(FolderDeltaDataKJ,'AssessShamEffectLocalGlobal.mat'))


%params
edges_delay = -400:5:400;
edges_norm  = 0:0.05:1;

animals = unique(tones_res.name);
aniamsl = animals([1 2 4]);



%% transitions probability

%tones
proba.up.global.tones = [];
proba.up.local.tones = [];

for m=1:length(animals)
    
    probup_mouse_global = [];
    probup_mouse_local = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probup_mouse_global = [probup_mouse_global tones_res.up.global.transit_rate{p}];
            probup_mouse_local = [probup_mouse_local tones_res.up.local.transit_rate{p}];
        end
    end
    %Up
    proba.up.global.tones = [proba.up.global.tones mean(probup_mouse_global)];
    proba.up.local.tones = [proba.up.local.tones mean(probup_mouse_local)];
end



%sham
proba.up.global.sham = [];
proba.up.local.sham = [];
for m=1:length(animals)
    
    probup_mouse_global = [];
    probup_mouse_local = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})            
            probup_mouse_global = [probup_mouse_global sham_res.up.global.transit_rate{p}];
            probup_mouse_local = [probup_mouse_local sham_res.up.local.transit_rate{p}];
            
        end
    end
    %NREM
    proba.up.global.sham = [proba.up.global.sham mean(probup_mouse_global)];
    proba.up.local.sham = [proba.up.local.sham mean(probup_mouse_local)];
end


%% Sync

sync_tones=[];
for m=1:length(animals)
    
    sync_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})   
            sync_mouse = [sync_mouse nanmean(tones_res.all.sync_after{p}./tones_res.all.sync_before{p})];
        end
    end
    
    sync_tones = [sync_tones mean(sync_mouse)];
    
end
    




%% PLOT
gap = [0.1 0.08];
fontsize = 20;
paired = 1;
optiontest = 'ranksum';
x_impact = 31;
smoothing = 0;
color_tones = [0 0 1];
color_sham  = [0.3 0.3 0.3];
colors_tones = {[0 0 1],[0.53 0.81 0.98]}; 
colors_sham = {[0.3 0.3 0.3],[0.7 0.7 0.7]};


figure, hold on



%Transition probability
subtightplot(6,4,[11 15],gap), hold on
PlotErrorBarN_KJ(data_pv{i}, 'newfig',0, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);








XL = [0.9 2.1];
Xbar = [1.2 1.8];

notBoxPlot(proba.nrem.tones,Xbar(1), 'patchColors', colors_tones),
notBoxPlot(proba.nrem.sham,Xbar(2), 'patchColors', colors_sham),
for l=1:length(proba.nrem.tones)
    line(Xbar, [proba.nrem.tones(l) proba.nrem.sham(l)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.75 0.75], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.77, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'ytick',0:0.25:1, 'ylim',[0 0.87],'Fontsize',fontsize),
set(gca,'xtick',Xbar,'XtickLabel',{'stim','sham'},'xlim', XL),
ylabel({'Taux de transitions', 'Up>Down'}),





