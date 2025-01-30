% DeltaToneRefractoryPeriodAnalysisData
% 11.07.2019 KJ
%
% Format data to analyse the delays and refractory period with random tones
%
%
%   see 
%       QuantifRefractoryPeriod_bis DeltaToneRefractoryPeriodAnalysis
%
%


%load
clear
load(fullfile(FolderDeltaDataKJ,'DeltaToneRefractoryPeriodAnalysis.mat'))

%params
thresh_delay = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster

%animals
animals = unique(refract_res.name);


%%  Random Tones
for m=1:length(animals)
    
    delta_delay     = [];
    delta_induced   = [];
    delta_substage  = [];
    delta_tonein    = [];
    for p=1:length(refract_res.path)
        if strcmpi(refract_res.name{p},animals{m})
            delta_delay     = [delta_delay ; refract_res.delay{p}];
            delta_induced   = [delta_induced ; refract_res.induced{p}];
            delta_substage  = [delta_substage ; refract_res.substage_tone{p}'];
            delta_tonein    = [delta_tonein ; refract_res.tones_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(delta_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    tones.delay{m}     = delta_delay(idx_delay);
    tones.induce{m}    = delta_induced(idx_delay);
    tones.substage{m}  = delta_substage(idx_delay);
    tones.tonein{m}    = delta_tonein(idx_delay);
end

%% Random Sham
for m=1:length(animals)
    
    delta_delay     = [];
    delta_induced   = [];
    delta_substage  = [];
    delta_shamin    = [];
    for p=1:length(sham_res.path)
        if strcmpi(sham_res.name{p},animals{m})
            delta_delay     = [delta_delay ; sham_res.delay{p}];
            delta_induced   = [delta_induced ; sham_res.induced{p}];
            delta_substage  = [delta_substage ; sham_res.substage_sham{p}'];
            delta_shamin    = [delta_shamin ; sham_res.sham_in{p}'];
        end
    end
    
    
    [sort_delay,idx_delay] = sort(delta_delay,'ascend');
    idx_delay(sort_delay>thresh_delay) = [];

    sham.delay{m}     = delta_delay(idx_delay);
    sham.induce{m}    = delta_induced(idx_delay);
    sham.substage{m}  = delta_substage(idx_delay);
    sham.tonein{m}    = delta_shamin(idx_delay);
end


%saving data
cd(FolderDeltaDataKJ)
save DeltaToneRefractoryPeriodAnalysisData.mat -v7.3 tones sham animals substage_ind NamesSubstages















