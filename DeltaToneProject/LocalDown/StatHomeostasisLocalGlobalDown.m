%%StatHomeostasisLocalGlobalDown
% 20.10.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    QuantifHomeostasisLocalGlobalDown
%    QuantifHomeostasisLocalGlobalDownPlot
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifHomeostasisLocalGlobalDown.mat'))

% %animals
animals = unique(homeo_res.name);
list_mouse = homeo_res.name;

%exclude
list_mouse{2} = 'NoName';
list_mouse{5} = 'NoName';
list_mouse{12} = 'NoName';
list_mouse{13} = 'NoName';

list_mouse{16} = 'NoName';
list_mouse{17} = 'NoName';
list_mouse{18} = 'NoName';
% list_mouse{19} = 'NoName';



%% concatenate
globalDw.slope0  = []; globalDw.slope1  = []; globalDw.slope2  = [];
LocalDw.slope0 = []; LocalDw.slope1 = []; LocalDw.slope2 = [];


for p=1:length(homeo_res.path)
    
    %down states 1
    Hstat = homeo_res.global.rescaled.Hstat{p};
    globalDw.slope0(p,1) = Hstat.p0(1);
    globalDw.slope1(p,1) = Hstat.p1(1);
    globalDw.slope2(p,1) = Hstat.p2(1);
    
    %for LocalDw
    slope0 = []; slope1 = []; slope2 = [];
    for tt=1:length(homeo_res.tetrodes{p})
        Hstat = homeo_res.local.rescaled.Hstat{p,tt};
        slope0 = [slope0 Hstat.p0(1)];
        slope1 = [slope1 Hstat.p1(1)];
        slope2 = [slope2 Hstat.p2(1)];
    end
    LocalDw.slope0(p,1) = median(slope0);
    LocalDw.slope1(p,1) = median(slope1);
    LocalDw.slope2(p,1) = median(slope2);

end


%% animals average

for m=1:length(animals)
    idm = strcmpi(list_mouse,animals{m}); %list of record of animals m
    
    fn = fieldnames(globalDw);
    for k=1:numel(fn)
        datam = globalDw.(fn{k});
        average.globalDw.(fn{k})(m,1) = mean(datam(idm));
        
        datam = LocalDw.(fn{k});
        average.LocalDw.(fn{k})(m,1) = mean(datam(idm));
    end
end




%% Stat

[pval_slope0, h_slope0, stat_slope0] = signrank(average.globalDw.slope0, average.LocalDw.slope0);
[pval_slope1, h_slope1, stat_slope1] = signrank(average.globalDw.slope1, average.LocalDw.slope1);
[pval_slope2, h_slope2, stat_slope2] = signrank(average.globalDw.slope2, average.LocalDw.slope2);







