% AnalysePascalData
% 18.07.2017 KJ
%
% Pascal stat
% 
%   see ReadPascalData
%


clear

%params
colori = {'k','b','r'};
digits = [-1 -1 0 -1 2 4];

%% load
load([FolderPrecomputeDreem 'ReadPascalData.mat']) 

for i=1:length(parameters)
    data_param = data{i};
    
    
    %% Anova
    [p,tbl,stats] = Anova1Data_KJ(data_param, conditions);
    title(parameters{i}),
    set(gca, 'XTickLabel', conditions,'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    %save
    cd([FolderClinicFigures 'Stat_Pascal'])
    %title
    filename_png = [parameters{i} '_anova' '.png'];
    %save figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
    if p<0.05
        show_sig = 'sig';
    else
        show_sig = 'none';
    end
    
    %% stat
    tblfig = statdisptable(tbl, parameters{i}, parameters{i}, digits);

    %save
    cd([FolderClinicFigures 'Stat_Pascal'])
    %title
    filename_png = [parameters{i} '_tablestat' '.png'];
    %save figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
    
    %% Bar plot
    PlotErrorBarN_KJ(data_param, 'newfig',1,'paired',1,'showPoints',0,'ShowSigstar',show_sig,'optiontest','ranksum','barcolors',colori);
    title(parameters{i}),
    set(gca, 'XTickLabel', conditions,'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    %save
    cd([FolderClinicFigures 'Stat_Pascal'])
    %title
    filename_png = [parameters{i} '_barplot' '.png'];
    %save figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
    
    
    
end






