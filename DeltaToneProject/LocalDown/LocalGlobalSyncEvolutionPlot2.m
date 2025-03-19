%%LocalGlobalSyncEvolutionPlot2
% 20.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    QuantifHomeostasieLocalSyncPlot QuantifHomeostasisLocalGlobalDown 
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisLocalGlobalDown.mat'))

% %animals
animals = unique(homeo_res.name);
list_mouse = homeo_res.name;

% exclude
list_mouse{2} = 'NoName';
list_mouse{5} = 'NoName';
list_mouse{12} = 'NoName';
list_mouse{13} = 'NoName';

list_mouse{16} = 'NoName';
list_mouse{17} = 'NoName';
list_mouse{18} = 'NoName';
% list_mouse{19} = 'NoName';


%% concatenate
globalDw.slope0  = []; globalDw.slope1  = []; globalDw.slope2  = []; globalDw.expB = [];
localDw.slope0 = []; localDw.slope1 = []; localDw.slope2 = []; localDw.expB = [];
tetAll.slope0 = []; tetAll.slope1 = []; tetAll.slope2 = []; tetAll.expB = [];
unionDw.slope0 = []; unionDw.slope1 = []; unionDw.slope2 = []; unionDw.expB = [];

globalDw.pv0  = []; globalDw.pv1  = []; globalDw.pv2  = []; globalDw.pv_b  = [];
localDw.pv0 = []; localDw.pv1 = []; localDw.pv2 = []; localDw.pv_b  = [];
tetAll.pv0 = []; tetAll.pv1 = []; tetAll.pv2 = []; tetAll.pv_b  = [];
unionDw.pv0 = []; unionDw.pv1 = []; unionDw.pv2 = []; unionDw.pv_b  = [];


for p=1:length(homeo_res.path)
    
    %Global down
    Hstat = homeo_res.global.rescaled.Hstat{p};
    globalDw.slope0(p,1) = Hstat.p0(1);
    globalDw.pv0(p,1)    = mean(Hstat.pv0<0.05);
    globalDw.slope1(p,1) = Hstat.p1(1);
    globalDw.pv1(p,1)    = mean(Hstat.pv1<0.05);
    globalDw.slope2(p,1) = Hstat.p2(1);
    globalDw.pv2(p,1)    = mean(Hstat.pv2<0.05);
    globalDw.expB(p,1)   = Hstat.exp_b(1);
    globalDw.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    
    %Union
    Hstat = homeo_res.union.rescaled.Hstat{p};
    unionDw.slope0(p,1) = Hstat.p0(1);
    unionDw.pv0(p,1)    = mean(Hstat.pv0<0.05);
    unionDw.slope1(p,1) = Hstat.p1(1);
    unionDw.pv1(p,1)    = mean(Hstat.pv1<0.05);
    unionDw.slope2(p,1) = Hstat.p2(1);
    unionDw.pv2(p,1)    = mean(Hstat.pv2<0.05);
    unionDw.expB(p,1)   = Hstat.exp_b(1);
    unionDw.pv_b(p,1)   = mean(Hstat.pv_b<0.05);
    
    %for LocalDw
    slope0 = []; slope1 = []; slope2 = []; expB = [];
    pv0 = []; pv1 = []; pv2 = []; pv_b = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
        slope0 = [slope0 Hstat.p0(1)];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        pv_b = [pv_b Hstat.pv_b];
    end
    localDw.slope0(p,1) = median(slope0);
    localDw.pv0(p,1)    = mean(pv0<0.5);
    localDw.slope1(p,1) = median(slope1);
    localDw.pv1(p,1)    = mean(pv1<0.05);
    localDw.slope2(p,1) = median(slope2);
    localDw.pv2(p,1)    = mean(pv2<0.05);
    localDw.expB(p,1)   = median(expB);
    localDw.pv_b(p,1)   = mean(pv_b<0.05);
    
    %for TetAll
    slope0 = []; slope1 = []; slope2 = []; expB = [];
    pv0 = []; pv1 = []; pv2 = []; pv_b = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.all_local.rescaled.Hstat{p,tt};
        slope0 = [slope0 Hstat.p0(1)];
        pv0 = [pv0 Hstat.pv0];
        slope1 = [slope1 Hstat.p1(1)];
        pv1 = [pv1 Hstat.pv1];
        slope2 = [slope2 Hstat.p2(1)];
        pv2 = [pv2 Hstat.pv2];
        expB = [expB Hstat.exp_b];
        pv_b = [pv_b Hstat.pv_b];
    end
    tetAll.slope0(p,1) = median(slope0);
    tetAll.pv0(p,1)    = mean(pv0<0.5);
    tetAll.slope1(p,1) = median(slope1);
    tetAll.pv1(p,1)    = mean(pv1<0.05);
    tetAll.slope2(p,1) = median(slope2);
    tetAll.pv2(p,1)    = mean(pv2<0.05);
    tetAll.expB(p,1)   = median(expB);
    tetAll.pv_b(p,1)   = mean(pv_b<0.05);
    
    
    %% union, global and ratio
    union.x_intervals = homeo_res.union.absolut.Hstat{p}.x_intervals;
    union.y_density = homeo_res.union.absolut.Hstat{p}.y_density;
    
    downglobal.x_intervals = homeo_res.global.absolut.Hstat{p}.x_intervals;
    downglobal.y_density = homeo_res.global.absolut.Hstat{p}.y_density;

    ratio.x_density = union.x_intervals;
    ratio.y_density = downglobal.y_density ./ (union.y_density+0.1);
    ratio.y_density(union.y_density==0) = 0; 
    
    
    Hstat = HomestasisStat_KJ(ratio.x_density*3600e4, ratio.y_density, intervalSet(0,max(ratio.x_density)), 4);
    
    
    %% Comparison start and end of night
    
    %start and end
    Hstat = homeo_res.global.absolut.Hstat{p};
    homeo_start = Hstat.x_peaks(1);
    homeo_end = Hstat.x_peaks(end);    
    
    %beginning and end of sleep
    firstEpoch = [homeo_start, homeo_start+2];
    lastEpoch = [homeo_end-2, homeo_end];
    firstEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>firstEpoch(1) & ratio.x_density<=firstEpoch(2)));
    lastEp_ratio(p,1) = nanmean(ratio.y_density(ratio.x_density>lastEpoch(1) & ratio.x_density<=lastEpoch(2)));
    
    %quarters of night
    nbepoch = 5;
    dur_night = (homeo_end - homeo_start) / nbepoch;
    for i=1:nbepoch
        SubEpoch{i} = homeo_start + [dur_night*(i-1), dur_night*i];
        subEpoch_ratio{i}(p,1) = nanmean(ratio.y_density(ratio.x_density>SubEpoch{i}(1) & ratio.x_density<=SubEpoch{i}(2)));
    end
    
    x_epoch = ((1:nbepoch) - 0.5)/nbepoch;

end


%% animals average

for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(globalDw);
    for k=1:numel(fn)
        datam = globalDw.(fn{k});
        average.globalDw.(fn{k})(m,1) = mean(datam(idm));
        
        datam = unionDw.(fn{k});
        average.unionDw.(fn{k})(m,1) = mean(datam(idm));
        
        datam = localDw.(fn{k});
        average.LocalDw.(fn{k})(m,1) = mean(datam(idm));
        
        datam = tetAll.(fn{k});
        average.tetAll.(fn{k})(m,1) = mean(datam(idm));
    end
    
    
    %ratio comparison
    average.BeginEndEp(m,1) = mean(firstEp_ratio(idm))*100; 
    average.BeginEndEp(m,2) = mean(lastEp_ratio(idm))*100; 
    for i=1:nbepoch
        average.subEpoch_ratio(m,i) = mean(subEpoch_ratio{i}(idm))*100;
    end
    
end


%% data
%data1
data_slope{1} = [average.globalDw.slope0 average.tetAll.slope0 average.unionDw.slope0 average.LocalDw.slope0];
data_slope{2} = [average.globalDw.slope1 average.tetAll.slope1 average.unionDw.slope1 average.LocalDw.slope1];
data_slope{3} = [average.globalDw.slope2 average.tetAll.slope2 average.unionDw.slope2 average.LocalDw.slope2];
data_slope{4} = [average.globalDw.expB average.tetAll.expB average.unionDw.expB];


data_pv{1} = [average.globalDw.pv0 average.tetAll.pv0]*100;
data_pv{2} = [average.globalDw.pv1 average.tetAll.pv1]*100;
data_pv{3} = [average.globalDw.pv2 average.tetAll.pv2]*100;
data_pv{4} = [average.globalDw.pv_b average.tetAll.pv_b]*100;



%% Plot
fontsize = 26;

colors_global = {[0 0.5 0],[1 1 0.8]};
colors_tetrode = {[0.78 0.08 0.52],[1 0.59 0.94]};
colors_union = {[0.3 0.3 0.3],[0.7 0.7 0.7]};
colors_local  = {[0 0 1],[0 0.5 1]};

bar_y = [0.07 0.31 0.092];
XL = [0.7 3.5];
Xbar = [1.2 1.8 2.4 3];

figure, hold on 
subplot(1,2,1), hold on 
data_s = data_slope{1};
line(XL,[0 0], 'Linewidth',1,'color','k','linestyle','--'), hold on
notBoxPlot(data_s(:,1),Xbar(1), 'patchColors', colors_global),
notBoxPlot(data_s(:,2),Xbar(2), 'patchColors', colors_tetrode),
notBoxPlot(data_s(:,3),Xbar(3), 'patchColors', colors_union),
notBoxPlot(data_s(:,4),Xbar(4), 'patchColors', colors_local),

for l=1:size(data_s,1)
    line(Xbar(1:2), [data_s(l,1) data_s(l,2)], 'color', [0.7 0.7 0.7]),
    line(Xbar(2:3), [data_s(l,2) data_s(l,3)], 'color', [0.7 0.7 0.7]),
    line(Xbar(3:4), [data_s(l,3) data_s(l,4)], 'color', [0.7 0.7 0.7]),
end

set(gca,'xlim',XL,'xtick',Xbar,'XtickLabel',{'Global','Tetrode','Union','Local'},'Fontsize',fontsize),
ylabel('slopes value (%/min/h)');



%% Plot

titles = {'1fit','2fit 0-3h','2fit end','exp fit'};
fontsize = 15;
barcolors = {[0 0.5 0], [0.78 0.08 0.52], [0.3 0.3 0.3], [0 0 1]};

sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';

figure, hold on 

%down1 delta fake
for i=1:3
    subplot(1,4,i), hold on
    PlotErrorBarN_KJ(data_slope{i}, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
    set(gca,'xtick',1:4,'XtickLabel',{'global', 'tetrode','union','local'},'Fontsize',fontsize), xtickangle(30)
    ylabel('slopes value (%/min/h)');
    title(titles{i}),
    
%     
%     subplot(2,4,i+4), hold on
%     PlotErrorBarN_KJ(data_pv{i}, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
%     set(gca,'xtick',1:2,'XtickLabel',{'global', 'tetrode'},'Fontsize',fontsize), xtickangle(30)
%     set(gca,'ylim', [0 120], 'ytick',0:20:100),
%     ylabel('% of pvalues <0.05');
end

subplot(1,4,4), hold on
PlotErrorBarN_KJ(data_slope{4}, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',{'global', 'tetrode', 'union'},'Fontsize',fontsize), xtickangle(30)
ylabel('slopes value (%/min/h)');
title(titles{4}),






