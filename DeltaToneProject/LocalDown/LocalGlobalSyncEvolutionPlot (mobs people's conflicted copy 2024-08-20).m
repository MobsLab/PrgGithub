%%LocalGlobalSyncEvolutionPlot
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
data1_slope{1} = [average.globalDw.slope0 average.LocalDw.slope0 average.unionDw.slope0];
data1_slope{2} = [average.globalDw.slope1 average.LocalDw.slope1 average.unionDw.slope1];
data1_slope{3} = [average.globalDw.slope2 average.LocalDw.slope2 average.unionDw.slope2];


data_slope0 = [average.globalDw.slope0 average.unionDw.slope0, average.unionDw.slope1, average.unionDw.slope2];
data_exp = [average.globalDw.expB average.unionDw.expB];



%% Plot

titles = {'1fit','2fit 0-3h','2fit end'};
fontsize = 24;
colors_global = {[0 0.5 0],[1 1 0.8]};
colors_union = {[0.3 0.3 0.3],[0.7 0.7 0.7]};

sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';


figure, hold on 

%exp fit
XL = [0.5 2.5];
Xbar = [1.2 1.8];

subplot(2,3,1), hold on
line(XL,[0 0], 'Linewidth',1,'color',[0.6 0.6 0.6], 'linestyle','--'), hold on
notBoxPlot(data_exp(:,1),Xbar(1), 'patchColors', colors_global),
notBoxPlot(data_exp(:,2),Xbar(2), 'patchColors', colors_union),
for l=1:size(data_slope0,1)
    line(Xbar, [data_exp(l,1) data_exp(l,2)], 'color', [0.7 0.7 0.7]),
end
line(Xbar, [0.02 0.02], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),0.025, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'xlim',XL, 'ylim', [-0.12 0.04]),
set(gca,'xtick',Xbar,'XtickLabel',{'global','union'},'Fontsize',fontsize),
ylabel('exponential decay'),
title('Homeostasis'),

%linear fit slopes
XL = [0.5 3.5];
Xbar = [1.2 1.8 2.4 3];

subplot(2,3,4), hold on
notBoxPlot(data_slope0(:,1),Xbar(1), 'patchColors', colors_global),
notBoxPlot(data_slope0(:,2:4),Xbar(2:4), 'patchColors', colors_union),
for l=1:size(data_slope0,1)
    line(Xbar(1:2), [data_slope0(l,1) data_slope0(l,2)], 'color', [0.7 0.7 0.7]),
end
line(Xbar(1:2), [-0.18 -0.18], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar(1:2)),-0.195, '*', 'HorizontalAlignment','center','fontsize',20)
text(Xbar(2),0.10, '*', 'HorizontalAlignment','center','fontsize',20)
text(Xbar(3),0.11, 'n.s', 'HorizontalAlignment','center','fontsize',16)
text(Xbar(4),0.11, 'n.s', 'HorizontalAlignment','center','fontsize',16)

set(gca,'xlim',XL, 'ylim', [-0.21 0.13], 'ytick', -0.2:0.1:0.1)
set(gca,'xtick',[mean(Xbar(1:2)) Xbar(3:4)],'XtickLabel',{'1 fit', '0-3h', 'End'},'Fontsize',fontsize),
line(XL,[0 0], 'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
ylabel('slopes value (%/min/h)'),


%sync at beggining and end of sleep
XL = [0.5 2.5];
Xbar = [1.2 1.8];

subplot(1,3,2), hold on
notBoxPlot(average.BeginEndEp,Xbar),
for l=1:size(average.BeginEndEp,1)
    line(Xbar, [average.BeginEndEp(l,1) average.BeginEndEp(l,2)], 'color', [0.5 0.5 0.5]),
end
line(Xbar, [37 37], 'color', 'k', 'linewidth', 1.5),
text(mean(Xbar),38, '*', 'HorizontalAlignment','center','fontsize',20)
set(gca,'xlim',XL,'xtick',Xbar,'XtickLabel',{'first 2h','last 2h'}, 'ytick',5:5:35,'Fontsize',fontsize),
xtickangle(20),
ylabel('% intersection / union');
title('Synchronization of down states'),


%sync through the night (subdivision in normalized time)
subplot(1,3,3), hold on
PlotErrorLineN_KJ(average.subEpoch_ratio, 'x_data',x_epoch,'newfig',0,'ShowSigstar','none','errorbars',1,'linespec','-.');
set(gca,'ylim',[14 29],'xtick',[0 1], 'ytick',15:5:30,'Fontsize',fontsize),
ylabel('% intersection / union'), xlabel('normalized time'),





% 
% 
% %% Plot bar
% 
% titles = {'1fit','2fit 0-3h','2fit end'};
% fontsize = 20;
% 
% sigtest = 'ranksum';
% showPoints = 1;
% showsig = 'sig';
% 
% 
% figure, hold on 
% 
% %linear fit slopes
% subplot(2,3,1), hold on
% PlotErrorBarN_KJ(data_slope0, 'newfig',0, 'paired',1, 'optiontest',sigtest, 'showPoints',1,'ShowSigstar',showsig);
% line(xlim,[0 0], 'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
% set(gca,'xtick',1:4,'XtickLabel',{'global','all', '0-3h', 'End'},'Fontsize',fontsize),
% ylabel('slopes value (%/min/h)'),ylim([-0.21 0.13]),
% title('All down states slopes'),
% 
% %exp fit
% subplot(2,3,4), hold on
% PlotErrorBarN_KJ(data_exp, 'newfig',0, 'paired',1, 'optiontest',sigtest, 'showPoints',1,'ShowSigstar',showsig);
% line(xlim,[0 0], 'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
% set(gca,'xtick',1:2,'XtickLabel',{'global','all down'},'Fontsize',fontsize),
% xtickangle(0),ylabel('exponential decrease'),ylim([-0.12 0.04]),
% title('Exponential fit'),
% 
% 
% %sync at beggining and end of sleep
% subplot(1,3,2), hold on
% PlotErrorBarN_KJ(average.BeginEndEp, 'newfig',0, 'paired',1, 'optiontest',sigtest, 'showPoints',1,'ShowSigstar',showsig);
% set(gca,'xtick',1:2,'XtickLabel',{'first 2h','last 2h'},'Fontsize',fontsize),
% ylabel('% intersection/union of all down states');
% title('Sync of down states'),
% 
% %sync through the night (subdivision in normalized time)
% subplot(1,3,3), hold on
% PlotErrorLineN_KJ(average.subEpoch_ratio, 'x_data',x_epoch,'newfig',0,'ShowSigstar','none','errorbars',1,'linespec','-.');
% set(gca,'ylim',[10 30],'xtick',[0 1],'Fontsize',fontsize),
% ylabel('% intersection/union of all down states'), xlabel('normalized time'),
% title('Sync of down states'),
%     











