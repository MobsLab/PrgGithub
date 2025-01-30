%%StatIsiBasalCloseLoop
% 20.10.2019 KJ
%
% Look at the effect of tones/sham on the Intervals between down states

%
%   see 
%       CompareIsiBasalCloseLoopPlot
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'CompareIsiBasalCloseLoop.mat'))

animals = unique(basal_res.name);

%% TONES - Pool by mouse

for k=1:3
    tones_success{k} = [];
    tones_failed{k}  = [];
    basal_isi{k}     = [];
end

for m=1:length(animals)
    
    for k=1:3
        %basal
        mouse_basal{k} = [];
        for p=1:length(basal_res.path)
            if strcmpi(animals{m}, basal_res.name{p})
                mouse_basal{k} = [mouse_basal{k} ; nanmean(basal_res.isi_basal{p}{k})];
            end
        end
        
        %tones
        mouse_success{k} = [];
        mouse_failed{k}  = [];
        for p=1:length(bci_res.path)
            if strcmpi(animals{m},bci_res.name{p})
                mouse_success{k} = [mouse_success{k} ; nanmean(bci_res.isi_success{p}{k})];
                mouse_failed{k}  = [mouse_failed{k} ; nanmean(bci_res.isi_failed{p}{k})];
            end
        end
        
        %concatenate
        basal_isi{k}     = [basal_isi{k} ; nanmean(mouse_basal{k})/10];
        tones_success{k} = [tones_success{k} ; nanmean(mouse_success{k})/10];
        tones_failed{k}  = [tones_failed{k} ; nanmean(mouse_failed{k})/10];
    end
    
    
end


%% Stat

for k=1:3
    [pval_success{k}, h_success{k}, stat_success{k}] = signrank(tones_success{k}, basal_isi{k});

    [pval_failed{k}, h_failed{k}, stat_failed{k}] = signrank(tones_failed{k}, basal_isi{k});
end


















