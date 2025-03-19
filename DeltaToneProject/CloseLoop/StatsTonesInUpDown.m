%%StatsTonesInUpDown
% 20.10.2018 KJ
%
% stat of tones in up-down states
% in N2 and N3
%
%   see 
%        FigTonesInDownNREM_fr
%


%load
clear

%% Tones in Up

load(fullfile(FolderDeltaDataKJ,'TonesInUpN2N3Effect.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInUpN2N3Effect.mat'))
animals = unique(tones_res.name);

%tones
proba.inup.tones = [];
for m=1:length(animals)
    probnrem_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse tones_res.nrem.transit_rate{p}];
        end
    end
    
    %NREMinup
    proba.inup.tones = [proba.inup.tones mean(probnrem_mouse)];
end

%sham
proba.inup.sham = [];
for m=1:length(animals)
    probnrem_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse sham_res.nrem.transit_rate{p}];
        end
    end

    %NREM
    proba.inup.sham = [proba.inup.sham mean(probnrem_mouse)];
end


%% Tones in Down

clearvars -except proba

load(fullfile(FolderDeltaDataKJ,'TonesInDownN2N3Effect.mat'))
load(fullfile(FolderDeltaDataKJ,'ShamInDownN2N3Effect.mat'))
animals = unique(tones_res.name);

%tones
proba.indown.tones = [];
for m=1:length(animals)
    probnrem_mouse = [];
    for p=1:length(tones_res.path)
        if strcmpi(tones_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse tones_res.nrem.transit_rate{p}];
        end
    end
    
    %NREM
    proba.indown.tones = [proba.indown.tones mean(probnrem_mouse)];
end


%sham
proba.indown.sham = [];
for m=1:length(animals)
    probnrem_mouse = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            probnrem_mouse = [probnrem_mouse sham_res.nrem.transit_rate{p}];
        end
    end

    %NREM
    proba.indown.sham = [proba.indown.sham mean(probnrem_mouse)];
end


%% Stat

%Tones in Up paired signrank
[pval_inup, h_inup, stat_inup] = signrank(proba.inup.tones, proba.inup.sham);


%Tones in Down paired signrank
[pval_indown, h_indown, stat_indown] = signrank(proba.indown.tones, proba.indown.sham);







