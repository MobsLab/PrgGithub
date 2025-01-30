%%QuantifHomeostasisDownInterAreaPlot
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     QuantifHomeostasisDownInterArea
%    

% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisDownInterArea.mat'))

animals = unique(local_res.name);
list_mouse = local_res.name;
%exclude
list_mouse{3} = 'NoName';
list_mouse{6} = 'NoName';

color_pfc = 'k';
color_pa = 'r';
color_mo = [1 0.6 0];


%% quantif quantity

perc_intra.pfc = [];
perc_intra.pa  = [];
perc_intra.mo  = [];

perc_among.intra = [];
perc_among.area2 = [];
perc_among.area3 = [];

nb_delta.area3.pfc = []; nb_delta.area3.pa = []; nb_delta.area3.mo = [];
nb_delta.area2.pfc = []; nb_delta.area2.pa = []; nb_delta.area2.mo = [];
nb_delta.intra.pfc = []; nb_delta.intra.pa = []; nb_delta.intra.mo = [];


for p=1:length(local_res.path)
    if strcmpi(local_res.date{p},'01042015')
        continue
    end
    
    %intra
    perc_intra.pfc = [perc_intra.pfc ; local_res.intra_pfc.nb{p}/local_res.all_pfc.nb{p}];
    perc_intra.pa  = [perc_intra.pa ; local_res.intra_pa.nb{p}/local_res.all_pa.nb{p}];
    perc_intra.mo  = [perc_intra.mo ; local_res.intra_mo.nb{p}/local_res.all_mo.nb{p}];
    
    
    %intra, 2 or 3 area
    nb_all   = local_res.all_deltas.nb{p};
    nb_3area = local_res.inter_all.nb{p};
    nb_2area = local_res.pfc_mo.nb{p} + local_res.pfc_pa.nb{p} + local_res.mo_pa.nb{p}; 
    nb_intra = local_res.intra_pfc.nb{p} + local_res.intra_pa.nb{p} + local_res.intra_mo.nb{p};
    
    perc_among.intra = [perc_among.intra ; nb_intra/nb_all];
    perc_among.area2 = [perc_among.area2 ; nb_2area/nb_all];
    perc_among.area3 = [perc_among.area3 ; nb_3area/nb_all];
    
    
    %amount of delta
    nb_delta.area3.pfc = [nb_delta.area3.pfc ; local_res.inter_all.nb{p}];
    nb_delta.area3.pa  = [nb_delta.area3.pa ; local_res.inter_all.nb{p}];
    nb_delta.area3.mo  = [nb_delta.area3.mo ; local_res.inter_all.nb{p}];
    
    nb_delta.area2.pfc = [nb_delta.area2.pfc ; local_res.pfc_mo.nb{p}+local_res.pfc_pa.nb{p}];
    nb_delta.area2.pa  = [nb_delta.area2.pa ; local_res.pfc_pa.nb{p}+local_res.mo_pa.nb{p}];
    nb_delta.area2.mo  = [nb_delta.area2.mo ; local_res.pfc_mo.nb{p}+local_res.mo_pa.nb{p}];
    
    nb_delta.intra.pfc = [nb_delta.intra.pfc ; local_res.intra_pfc.nb{p}];
    nb_delta.intra.pa  = [nb_delta.intra.pa  ; local_res.intra_pa.nb{p}];
    nb_delta.intra.mo  = [nb_delta.intra.mo  ; local_res.intra_mo.nb{p}];

end

%percentage
perc_intra.pfc = perc_intra.pfc * 100;
perc_intra.pa  = perc_intra.pa * 100;
perc_intra.mo  = perc_intra.mo * 100;

perc_among.intra = perc_among.intra * 100 ;
perc_among.area2 = perc_among.area2 * 100;
perc_among.area3 = perc_among.area3 * 100;

%data to plot
data_intra  = 100-[perc_intra.pfc perc_intra.pa perc_intra.mo];
data_among  = [perc_among.intra perc_among.area2 perc_among.area3];

data_nbdelta = 



%% Crossed table
%PFC, Pa, Mo

a=0;
crossed_table = nan(3,3,6);
for p=1:length(local_res.path)
    if strcmpi(local_res.date{p},'01042015')
        continue
    end
    a=a+1;
 
    %MoCx | PFCx
    crossed_table(1,2,a) = (local_res.pfc_mo.nb{p} + local_res.inter_all.nb{p}) / local_res.all_pfc.nb{p};
    %PaCx | PFCx
    crossed_table(1,3,a) = (local_res.pfc_pa.nb{p} + local_res.inter_all.nb{p}) / local_res.all_pfc.nb{p};
    
    %PFCx | MoCx
    crossed_table(2,1,a) = (local_res.pfc_mo.nb{p} + local_res.inter_all.nb{p}) / local_res.all_mo.nb{p};
    %PaCx | MoCx
    crossed_table(2,3,a) = (local_res.mo_pa.nb{p} + local_res.inter_all.nb{p}) / local_res.all_mo.nb{p};
    
    %PFCx | PaCx
    crossed_table(3,1,a) = (local_res.pfc_pa.nb{p} + local_res.inter_all.nb{p}) / local_res.all_pa.nb{p};
    %MoCx | PaCx
    crossed_table(3,2,a) = (local_res.mo_pa.nb{p} + local_res.inter_all.nb{p}) / local_res.all_pa.nb{p};
end

mean_cross_table243 = nanmean(crossed_table(:,:,1:3),3) * 100;
mean_cross_table244 = nanmean(crossed_table(:,:,4:6),3) * 100;

mean_crosstable = nanmean(crossed_table,3) * 100; 


%% Quantif N1-N2-N3

for s=1:3
    perc_sub.intra{s} = [];
    perc_sub.area2{s} = [];
    perc_sub.area3{s} = [];
    
    for p=1:length(local_res.path)
        if strcmpi(local_res.date{p},'01042015')
            continue
        end
        %intra, 2 or 3 area
        nb_all   = local_res.all_deltas.substages{p}(s);
        nb_3area = local_res.inter_all.substages{p}(s);
        nb_intra = local_res.intra_pfc.substages{p}(s) + local_res.intra_pa.substages{p}(s) + local_res.intra_mo.substages{p}(s);        
        nb_2area = nb_all - (nb_3area + nb_intra);
        

        perc_sub.intra{s} = [perc_sub.intra{s} ; nb_intra/nb_all];
        perc_sub.area2{s} = [perc_sub.area2{s} ; nb_2area/nb_all];
        perc_sub.area3{s} = [perc_sub.area3{s} ; nb_3area/nb_all];
    end
end

%data to plot
datasub_intra = [perc_sub.intra{1} perc_sub.intra{2} perc_sub.intra{3}]*100;
datasub_2area = [perc_sub.area2{1} perc_sub.area2{2} perc_sub.area2{3}]*100;
datasub_3area = [perc_sub.area3{1} perc_sub.area3{2} perc_sub.area3{3}]*100;


%% Homeostasis quantif

InterAll.slope0  = []; InterAll.slope1  = []; InterAll.slope2  = []; InterAll.expB = [];
Inter2.slope0  = []; Inter2.slope1  = []; Inter2.slope2  = []; Inter2.expB = [];
Intra1.slope0 = []; Intra1.slope1 = []; Intra1.slope2 = []; Intra1.expB = [];

for p=1:length(local_res.path)
    %inter all - 3 area
    Hstat = local_res.inter_all.rescaled.Hstat{p};
    InterAll.slope0(p,1) = Hstat.p0(1);
    InterAll.slope1(p,1) = Hstat.p1(1);
    InterAll.slope2(p,1) = Hstat.p2(1);
    InterAll.expB(p,1)   = Hstat.exp_b;
    
    %2 area
    Hstat1 = local_res.pfc_pa.rescaled.Hstat{p};
    Hstat2 = local_res.pfc_mo.rescaled.Hstat{p};
    Hstat3 = local_res.mo_pa.rescaled.Hstat{p};
    
    Inter2.slope0(p,1) = mean([Hstat1.p0(1) Hstat2.p0(1) Hstat3.p0(1)]);
    Inter2.slope1(p,1) = mean([Hstat1.p1(1) Hstat2.p1(1) Hstat3.p1(1)]);
    Inter2.slope2(p,1) = mean([Hstat1.p2(1) Hstat2.p2(1) Hstat3.p2(1)]);
    Inter2.expB(p,1) = mean([Hstat1.exp_b Hstat2.exp_b Hstat3.exp_b]);
    
    %all intra
    Hstat1 = local_res.intra_pfc.rescaled.Hstat{p};
    Hstat2 = local_res.intra_pa.rescaled.Hstat{p};
    Hstat3 = local_res.intra_mo.rescaled.Hstat{p};
    
    Intra1.slope0(p,1) = mean([Hstat1.p0(1) Hstat2.p0(1) Hstat3.p0(1)]);
    Intra1.slope1(p,1) = mean([Hstat1.p1(1) Hstat2.p1(1) Hstat3.p1(1)]);
    Intra1.slope2(p,1) = mean([Hstat1.p2(1) Hstat2.p2(1) Hstat3.p2(1)]);
    Intra1.expB(p,1) = mean([Hstat1.exp_b Hstat2.exp_b Hstat3.exp_b]);

end

%animals average
for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(InterAll);
    for a=1:numel(fn)
        datam = InterAll.(fn{a});
        average.InterAll.(fn{a})(m,1) = mean(datam(idm));
        
        datam = Inter2.(fn{a});
        average.Inter2.(fn{a})(m,1) = mean(datam(idm));
        
        datam = Intra1.(fn{a});
        average.Intra1.(fn{a})(m,1) = mean(datam(idm));
    end
end

%data to plot
data_slope{1} = [InterAll.slope0 Inter2.slope0 Intra1.slope0];
data_slope{2} = [InterAll.slope1 Inter2.slope1 Intra1.slope1];
data_slope{3} = [InterAll.slope2 Inter2.slope2 Intra1.slope2];
data_slope{4} = [InterAll.expB Inter2.expB];



%% PLOT Quantif

fontsize = 28;
sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';
barcolors = {color_pfc, color_pa, color_mo};

figure, hold on 

% percentage of area deltas among all areas
subplot(1,2,1), hold on
PlotErrorBarN_KJ(data_intra, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',{'PFCx', 'PaCx','MoCx'},'Fontsize',fontsize),
ylabel('% of intra delta waves');
title(''),

subplot(1,2,2), hold on
PlotErrorBarN_KJ(data_among, 'newfig',0, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',{'Intra', '2 areas', '3 areas'},'Fontsize',fontsize),
% xtickangle(30),
ylabel('% among all delta waves');
title(''),

% subplot(1,3,3), hold on
% PlotErrorBarN_KJ(data_involv, 'newfig',0, 'barcolors',barcolors, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
% set(gca,'xtick',1:3,'XtickLabel',{'PFCx', 'PaCx','MoCx'},'Fontsize',fontsize),
% ylabel('% among 2-areas delta waves');
% title(''),


%% PLOT Substages

fontsize = 28;
sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';
labels = {'N1','N2','N3'};
colori_sub = {'k', 'b', [0 0.5 0]}; %substage color

figure, hold on 

%intra
subplot(1,3,1), hold on
PlotErrorBarN_KJ(datasub_intra, 'newfig',0, 'barcolors',colori_sub, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',labels,'Fontsize',fontsize),
ylabel('% among all delta');
title('Intras (1-area)'),

%2 area
subplot(1,3,2), hold on
PlotErrorBarN_KJ(datasub_2area, 'newfig',0, 'barcolors',colori_sub, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',labels,'Fontsize',fontsize),
ylabel('% among all delta');
title('2-areas'),

%3 area
subplot(1,3,3), hold on
PlotErrorBarN_KJ(datasub_3area, 'newfig',0, 'barcolors',colori_sub, 'paired',1, 'optiontest',sigtest, 'showPoints',showPoints,'ShowSigstar',showsig);
set(gca,'xtick',1:3,'XtickLabel',labels,'Fontsize',fontsize),
ylabel('% among all delta');
title('3-areas'),



%% PLOT Homeostasis

titles = {'1fit','2fit 0-3h','2fit end','exp fit'};
fontsize = 26;
colors_inter3 = {[0 0.5 0],[1 1 0.8]};
colors_inter2 = {[1 0 0],[1 0.5 0.5]};
colors_intra  = {[0 0 1],[0 0.5 1]};
bar_y = [0.07 0.31 0.092];
XL = [0.6 2.9];
Xbar = [1.2 1.8 2.4];

XL = [0 4];
Xbar = 1:3;

figure, hold on 
for i=1:3
    subplot(1,4,i), hold on 
    data_s = data_slope{i};
    
    line(XL,[0 0], 'Linewidth',1,'color','k','linestyle','--'), hold on
    notBoxPlot(data_s(:,1),Xbar(1), 'patchColors', colors_inter3),
    notBoxPlot(data_s(:,2),Xbar(2), 'patchColors', colors_inter2),
    notBoxPlot(data_s(:,3),Xbar(3), 'patchColors', colors_intra),
    for l=1:size(data_s,1)
        line(Xbar(1:2), [data_s(l,1) data_s(l,2)], 'color', [0.7 0.7 0.7]),
        line(Xbar(2:3), [data_s(l,2) data_s(l,3)], 'color', [0.7 0.7 0.7]),
    end
    
    [pval,StatAll] = PlotSigStat_KJ(data_s,'paired',1, 'optiontest','ranksum', 'ShowSigstar','sig');
    
%     line(Xbar, [bar_y(i) bar_y(i)], 'color', 'k', 'linewidth', 1.5),
%     text(1.5,bar_y(i)*1.03, '*', 'HorizontalAlignment','center','fontsize',20)

    set(gca,'xlim',XL,'xtick',Xbar,'XtickLabel',{'3 areas', '2 areas', 'Intra'},'Fontsize',fontsize),
    xtickangle(30),
    
    ylabel('slopes value (%/min/h)');
    title(titles{i}),
    
end

%exp
subplot(1,4,4), hold on 
data_s = data_slope{4};

line(XL,[0 0], 'Linewidth',1,'color','k','linestyle','--'), hold on
notBoxPlot(data_s(:,1),Xbar(1), 'patchColors', colors_inter3),
notBoxPlot(data_s(:,2),Xbar(2), 'patchColors', colors_inter2),
for l=1:size(data_s,1)
    line(Xbar(1:2), [data_s(l,1) data_s(l,2)], 'color', [0.7 0.7 0.7]),
end
[pval,StatAll] = PlotSigStat_KJ(data_s,'paired',1, 'optiontest','ranksum', 'ShowSigstar','sig');

%     line(Xbar, [bar_y(i) bar_y(i)], 'color', 'k', 'linewidth', 1.5),
%     text(1.5,bar_y(i)*1.03, '*', 'HorizontalAlignment','center','fontsize',20)

set(gca,'xlim',[0 3],'xtick',Xbar(1:2),'XtickLabel',{'3 areas', '2 areas'},'Fontsize',fontsize),
xtickangle(30),

ylabel('slopes value (%/min/h)');
title(titles{4}),


%% PLOT all Homeostasis Rescaled

sz = 2;
linewidt = 1.5;
color_peaks = [0.6 0.6 0.6];
color_expfit = 'k';
path_exclude = [3 6];
fontsize = 28;

figure, hold on

%Inter All
subplot(1,3,1), hold on
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    
    Hstat = local_res.inter_all.rescaled.Hstat{p};
    if any(Hstat.reg0*100>350)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks); 
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks); 
    end
end
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = local_res.inter_all.rescaled.Hstat{p};
    %fit
    if any(Hstat.reg0*100>350)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
end
%properties
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
legend(h, 'Delta density', 'linear fit')
ylabel('Delta waves density (% of NREM average)'), 
xlabel('Time (h)'),
title('3-areas')


%Inter 2 area
subplot(1,3,2), hold on
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = local_res.pfc_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
    
    Hstat = local_res.pfc_mo.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
    
    Hstat = local_res.mo_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    %fit
    Hstat = local_res.pfc_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
    
    Hstat = local_res.pfc_mo.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
    
    Hstat = local_res.mo_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
end
%properties
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
xlabel('Time (h)'),
title('2 areas')



%Intras
subplot(1,3,3), hold on
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    Hstat = local_res.intra_pfc.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
    
    Hstat = local_res.intra_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
    
    Hstat = local_res.intra_mo.rescaled.Hstat{p};
    if any(Hstat.reg0*100>290)
        h(1) = plot(Hstat.x_peaks, (Hstat.y_peaks*100)/2,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    else
        h(1) = plot(Hstat.x_peaks, Hstat.y_peaks*100,'o','MarkerSize',sz,'MarkerEdgeColor',color_peaks, 'MarkerFaceColor',color_peaks);
    end
end
for p=1:length(local_res.path)
    if ismember(p,path_exclude)
        continue
    end
    %fit
    Hstat = local_res.intras.rescaled.Hstat{p};
    if any(Hstat.reg0*100>250)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
    
    Hstat = local_res.intra_pa.rescaled.Hstat{p};
    if any(Hstat.reg0*100>250)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
    
    Hstat = local_res.intra_mo.rescaled.Hstat{p};
    if any(Hstat.reg0*100>250)
        h(2) = plot(Hstat.x_intervals, (Hstat.reg0*100)/2,'color',color_expfit,'linewidth',linewidt);
    else
        h(2) = plot(Hstat.x_intervals, Hstat.reg0*100,'color',color_expfit,'linewidth',linewidt);
    end
end
%properties
set(gca, 'xlim',[8 21], 'ylim', [0 350],'fontsize',fontsize),
xlabel('Time (h)'),
title('Intra')



