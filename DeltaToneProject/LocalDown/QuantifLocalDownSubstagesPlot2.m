%%QuantifLocalDownSubstagesPlot2
% 05.12.2019 KJ
%
% Infos
%   for PhD
%
% see
%    QuantifLocalDownSubstagesPlot 
%    


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifLocalDownSubstages.mat'))

% %animals
animals = unique(local_res.name);
list_mouse = local_res.name;

%exclude
list_mouse{2} = 'NoName';
list_mouse{5} = 'NoName';
list_mouse{12} = 'NoName';
list_mouse{13} = 'NoName';

list_mouse{16} = 'NoName';
list_mouse{17} = 'NoName';
list_mouse{18} = 'NoName';
list_mouse{19} = 'NoName';


%% concatenate

for s=1:3
    %density
    GlobalDw.density{s} = []; LocalDw.density{s} = []; UnionDw.density{s} = [];
    %occupancy
    GlobalDw.occupancy{s} = []; LocalDw.occupancy{s} = []; UnionDw.occupancy{s} = [];
    %sync
    SyncDw{s} = [];
end


for p=1:length(local_res.path)
    for s=1:3
        %Global
        GlobalDw.density{s}(p,1) = local_res.global.density{p}(s);
        GlobalDw.occupancy{s}(p,1) = local_res.global.occupancy{p}(s);        
        %Union
        UnionDw.density{s}(p,1) = local_res.union.density{p}(s);
        UnionDw.occupancy{s}(p,1) = local_res.union.occupancy{p}(s);
        
        %local
        l_density   = []; 
        l_occupancy = []; 
        for tt=1:length(local_res.tetrodes{p})
            l_density   = [l_density local_res.local.density{p,tt}(s)];
            l_occupancy = [l_occupancy local_res.local.occupancy{p,tt}(s)];
        end
        LocalDw.density{s}(p,1) = mean(l_density);
        LocalDw.occupancy{s}(p,1) = mean(l_occupancy);
        
        
        %sync
        SyncDw{s}(p,1) = local_res.sync.meanvalue{p}(s);
        
    end
end


    
%% animals average

for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    fn = fieldnames(GlobalDw);
    
    for s=1:3
        for k=1:numel(fn)
            average.GlobalDw.density{s}(m,1) = mean(GlobalDw.density{s}(idm));
            average.GlobalDw.occupancy{s}(m,1) = mean(GlobalDw.occupancy{s}(idm));
            
            average.LocalDw.density{s}(m,1) = mean(LocalDw.density{s}(idm));
            average.LocalDw.occupancy{s}(m,1) = mean(LocalDw.occupancy{s}(idm));
            
            average.UnionDw.density{s}(m,1) = mean(UnionDw.density{s}(idm));
            average.UnionDw.occupancy{s}(m,1) = mean(UnionDw.occupancy{s}(idm));
            
            average.SyncDw{s}(m,1) = mean(SyncDw{s}(idm));
        end
    end
end


%% data to plot

for s=1:3
    data_global.density(:,s)   = average.GlobalDw.density{s}*1e4;
    data_global.occupancy(:,s) = average.GlobalDw.occupancy{s}*100;
    
    data_local.density(:,s)   = average.LocalDw.density{s}*1e4;
    data_local.occupancy(:,s) = average.LocalDw.occupancy{s}*100;
    
    data_union.density(:,s)   = average.UnionDw.density{s}*1e4;
    data_union.occupancy(:,s) = average.UnionDw.occupancy{s}*100;
    
    data_sync(:,s)   = average.SyncDw{s};
    
end



%% Plot

labels = {'N1','N2','N3'};
colori_sub = {'k', 'b', [0 0.5 0]}; %substage color
gap = [0.1 0.05];

fontsize = 30;

sigtest = 'ranksum';
showPoints = 1;
showsig = 'sig';


figure, hold on 

%global down density
subplot(1,3,1), hold on
PlotErrorBarN_KJ(data_global.occupancy, 'x_data',1:3, 'newfig',0, 'barcolors',colori_sub,'optiontest',sigtest,  'paired',1, 'ShowSigstar',showsig); hold on
set(gca,'XTick',1:3 ,'XTickLabel', labels, 'xlim',[0 4],'fontsize',fontsize)
set(gca,'ytick',0:20:60,'ylim',[0 50]),
title('Global Down occupancy'), ylabel('%')

%local down density
subplot(1,3,2), hold on
PlotErrorBarN_KJ(data_local.occupancy, 'x_data',1:3, 'newfig',0, 'barcolors',colori_sub,'optiontest',sigtest,  'paired',1, 'ShowSigstar',showsig); hold on
set(gca,'XTick',1:3 ,'XTickLabel', labels, 'xlim',[0 4],'fontsize',fontsize)
set(gca,'ytick',0:20:60,'ylim',[0 50]),
title('Local Down occupancy'),

%Sync
subplot(1,3,3), hold on
PlotErrorBarN_KJ(data_sync, 'x_data',1:3, 'newfig',0, 'barcolors',colori_sub,'optiontest',sigtest,  'paired',1, 'ShowSigstar',showsig); hold on
set(gca,'XTick',1:3 ,'XTickLabel', labels, 'xlim',[0 4],'fontsize',fontsize)
set(gca,'ytick',0:20:60),
title('Synchronisation'), ylabel('%')







