%%StatLocalDownSubstages
% 20.10.2019 KJ
%
% Infos
%
% see
%    QuantifLocalDownSubstagesPlot QuantifHomeostasisDownInterAreaPlot
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


%% stat

%global density
[pval_globaldens12, h_globaldens12, stat_globaldens12] = signrank(data_global.density(:,1), data_global.density(:,2));
[pval_globaldens13, h_globaldens13, stat_globaldens13] = signrank(data_global.density(:,1), data_global.density(:,3));
[pval_globaldens23, h_globaldens23, stat_globaldens23] = signrank(data_global.density(:,2), data_global.density(:,3));
%global occupation
[pval_globalocc12, h_globalocc12, stat_globalocc12] = signrank(data_global.occupancy(:,1), data_global.occupancy(:,2));
[pval_globalocc13, h_globalocc13, stat_globalocc13] = signrank(data_global.occupancy(:,1), data_global.occupancy(:,3));
[pval_globalocc23, h_globalocc23, stat_globalocc23] = signrank(data_global.occupancy(:,2), data_global.occupancy(:,3));

%local density
[pval_localdens12, h_localdens12, stat_localdens12] = signrank(data_local.density(:,1), data_local.density(:,2));
[pval_localdens13, h_localdens13, stat_localdens13] = signrank(data_local.density(:,1), data_local.density(:,3));
[pval_localdens23, h_localdens23, stat_localdens23] = signrank(data_local.density(:,2), data_local.density(:,3));
%local occupation
[pval_localocc12, h_localocc12, stat_localocc12] = signrank(data_local.occupancy(:,1), data_local.occupancy(:,2));
[pval_localocc13, h_localocc13, stat_localocc13] = signrank(data_local.occupancy(:,1), data_local.occupancy(:,3));
[pval_localocc23, h_localocc23, stat_localocc23] = signrank(data_local.occupancy(:,2), data_local.occupancy(:,3));

%union density
[pval_uniondens12, h_uniondens12, stat_uniondens12] = signrank(data_union.density(:,1), data_union.density(:,2));
[pval_uniondens13, h_uniondens13, stat_uniondens13] = signrank(data_union.density(:,1), data_union.density(:,3));
[pval_uniondens23, h_uniondens23, stat_uniondens23] = signrank(data_union.density(:,2), data_union.density(:,3));
%union occupation
[pval_unionocc12, h_unionocc12, stat_unionocc12] = signrank(data_union.occupancy(:,1), data_union.occupancy(:,2));
[pval_unionocc13, h_unionocc13, stat_unionocc13] = signrank(data_union.occupancy(:,1), data_union.occupancy(:,3));
[pval_unionocc23, h_unionocc23, stat_unionocc23] = signrank(data_union.occupancy(:,2), data_union.occupancy(:,3));


%sync
[pval_sync12, h_sync12, stat_sync12] = signrank(data_sync(:,1), data_sync(:,2));
[pval_sync13, h_sync13, stat_sync13] = signrank(data_sync(:,1), data_sync(:,3));
[pval_sync23, h_sync23, stat_sync23] = signrank(data_sync(:,2), data_sync(:,3));












