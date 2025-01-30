%%StatMeanCurvesMUAFakeDelta
% 19.10.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    MeanCurvesMUAFakeDeltaDeepPlot MeanCurvesMUAFakeDeltaSupPlot


%% Deep
clear
load(fullfile(FolderDeltaDataKJ,'MeanCurvesMUAFakeDeltaDeep.mat'))

animals = unique(muadelta_res.name);
nb_animals_deep = length(animals);

precision_deep.good = [];
precision_deep.fake = [];
for m=1:length(animals)
    precision_mouse.good = [];
    precision_mouse.fake = [];
    
    for p=1:length(muadelta_res.path)
        if strcmpi(muadelta_res.name{p},animals{m})    
            precision_mouse.good = [precision_mouse.good muadelta_res.good.nb_down{p}/muadelta_res.good.nb{p}];
            precision_mouse.fake = [precision_mouse.fake muadelta_res.fake.nb_down{p}/muadelta_res.fake.nb{p}];
        end
    end
    
    precision_deep.good(m,1) = 1-mean(precision_mouse.good);
    precision_deep.fake(m,1) = 1-mean(precision_mouse.fake);
end

precision_deep.good = precision_deep.good * 100;
precision_deep.fake = precision_deep.fake * 100;


%% Sup
clearvars -except precision_deep nb_animals_deep

load(fullfile(FolderDeltaDataKJ,'MeanCurvesMUAFakeDeltaSup.mat'))

animals = unique(muadelta_res.name);
nb_animals_sup = length(animals);

precision_sup.good = [];
precision_sup.fake = [];
for m=1:length(animals)
    precision_mouse.good = [];
    precision_mouse.fake = [];
    
    for p=1:length(muadelta_res.path)
        if strcmpi(muadelta_res.name{p},animals{m})    
            precision_mouse.good = [precision_mouse.good muadelta_res.good.nb_down{p}/muadelta_res.good.nb{p}];
            precision_mouse.fake = [precision_mouse.fake muadelta_res.fake.nb_down{p}/muadelta_res.fake.nb{p}];
        end
    end
    
    precision_sup.good(m,1) = 1-mean(precision_mouse.good);
    precision_sup.fake(m,1) = 1-mean(precision_mouse.fake);
end
   
precision_sup.good = precision_sup.good * 100;
precision_sup.fake = precision_sup.fake * 100;



%% Stat

%Deep paired signrank
[pval_deep,h_deep,stat_deep] = signrank(precision_deep.good, precision_deep.fake);
% [pval_deep,h_deep,stat_deep] = signrank(precision_deep.good, precision_deep.fake,'method','approximate');


%Sup paired signrank
[pval_sup,h_sup,stat_sup] = signrank(precision_sup.good, precision_sup.fake);
% [pval_sup,h_sup,stat_sup] = signrank(precision_sup.good, precision_sup.fake,'method','approximate');







