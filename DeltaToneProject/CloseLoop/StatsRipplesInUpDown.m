%%StatsRipplesInUpDown
% 20.10.2018 KJ
%
% stat of tones in up-down states
% in N2 and N3
%
%   see 
%        StatsTonesInUpDown
%


%load
clear

%% Ripples in Up
load(fullfile(FolderDeltaDataKJ,'RipplesInUpN2N3Effect.mat'))
animals = unique(ripples_res.name);

proba.inup.ripples = [];
proba.inup.sham = [];
for m=1:length(animals)
    
    probnrem_rip = []; probnrem_sham = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            probnrem_rip = [probnrem_rip ripples_res.nrem.transit_rate.ripples{p}];
            probnrem_sham = [probnrem_sham ripples_res.nrem.transit_rate.sham{p}];
        end
    end
    %NREM
    proba.inup.ripples = [proba.inup.ripples mean(probnrem_rip)];
    proba.inup.sham    = [proba.inup.sham mean(probnrem_sham)];
end



%% Ripples in Down

clearvars -except proba

load(fullfile(FolderDeltaDataKJ,'RipplesInDownN2N3Effect.mat'))
animals = unique(ripples_res.name);

proba.indown.ripples = [];
proba.indown.sham = [];
for m=1:length(animals)
    
    probnrem_rip = []; probnrem_sham = [];
    
    for p=1:length(ripples_res.path)
        if strcmpi(ripples_res.name{p},animals{m})
            probnrem_rip = [probnrem_rip ripples_res.nrem.transit_rate.ripples{p}];
            probnrem_sham = [probnrem_sham ripples_res.nrem.transit_rate.sham{p}];
        end
    end
    %NREM
    proba.indown.ripples = [proba.indown.ripples mean(probnrem_rip)];
    proba.indown.sham    = [proba.indown.sham mean(probnrem_sham)];
end


%% Stat

%Tones in Up paired signrank
[pval_inup, h_inup, stat_inup] = signrank(proba.inup.ripples, proba.inup.sham);


%Tones in Down paired signrank
[pval_indown, h_indown, stat_indown] = signrank(proba.indown.ripples, proba.indown.sham);







