%%StatLocalGlobalSyncEvolution
% 20.09.2019 KJ
%
% Infos
%
% see
%    LocalGlobalSyncEvolutionPlot QuantifHomeostasisLocalGlobalDown 
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


for p=1:length(homeo_res.path)
    
    %Global down
    Hstat = homeo_res.global.rescaled.Hstat{p};
    globalDw.slope0(p,1) = Hstat.p0(1);
    globalDw.slope1(p,1) = Hstat.p1(1);
    globalDw.slope2(p,1) = Hstat.p2(1);
    globalDw.expB(p,1)   = Hstat.exp_b(1);
    
    %Union
    Hstat = homeo_res.union.rescaled.Hstat{p};
    unionDw.slope0(p,1) = Hstat.p0(1);
    unionDw.slope1(p,1) = Hstat.p1(1);
    unionDw.slope2(p,1) = Hstat.p2(1);
    unionDw.expB(p,1)   = Hstat.exp_b(1);
    
    %for LocalDw
    slope0 = []; slope1 = []; slope2 = []; expB = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
        slope0 = [slope0 Hstat.p0(1)];
        slope1 = [slope1 Hstat.p1(1)];
        slope2 = [slope2 Hstat.p2(1)];
        expB = [expB Hstat.exp_b];
    end
    localDw.slope0(p,1) = median(slope0);
    localDw.slope1(p,1) = median(slope1);
    localDw.slope2(p,1) = median(slope2);
    localDw.expB(p,1)   = median(expB);
    
    %for TetAll
    slope0 = []; slope1 = []; slope2 = []; expB = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.all_local.rescaled.Hstat{p,tt};
        slope0 = [slope0 Hstat.p0(1)];
        slope1 = [slope1 Hstat.p1(1)];
        slope2 = [slope2 Hstat.p2(1)];
        expB = [expB Hstat.exp_b];
    end
    tetAll.slope0(p,1) = median(slope0);
    tetAll.slope1(p,1) = median(slope1);
    tetAll.slope2(p,1) = median(slope2);
    tetAll.expB(p,1)   = median(expB);
    
    
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


%% Stat

%exponential decay - global vs union
[pval_exp,h_exp,stat_exp]= signrank(average.globalDw.expB, average.unionDw.expB);

%1 fit - global vs union
[pval_1fit,h_1fit,stat_1fit]= signrank(average.globalDw.slope0, average.unionDw.slope0);

%individual 1fit
[pval_union0, h_union0, stat_union0]= signrank(average.unionDw.slope0);
%individual 1fit
[pval_union1, h_union1, stat_union1]= signrank(average.unionDw.slope1);
[pval_union2, h_union2, stat_union2]= signrank(average.unionDw.slope2);

%Sync beginning vs end
[pval_sync1,h_sync1,stat_sync1] = signrank(average.BeginEndEp(:,1),average.BeginEndEp(:,2));










