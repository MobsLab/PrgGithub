% QuantifRefractoryPeriod_bis
% 15.02.2017 KJ
%
% Format data to analyse the delays and refractory period with random tones
% 
% 
%   see  
%       QuantifRefractoryPeriod


clear
load([FolderProjetDelta 'Data/QuantifRefractoryPeriod.mat']) 

%params
thresh_delay_tone = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster

animals = refractory_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
substage_ind = 1:5;

for m=1:length(animals)
    delta_delay = [];
    for p=1:length(refractory_res.path)
        if strcmpi(refractory_res.name{p},animals{m})
            if isempty(delta_delay)
                delta_delay = refractory_res.delta.delay{p};
                delta_induced = refractory_res.delta.induced{p};
                delta_substage = refractory_res.substage_tone{p}';
            else
                delta_delay = [delta_delay;refractory_res.delta.delay{p}];
                delta_induced = [delta_induced;refractory_res.delta.induced{p}];
                delta_substage = [delta_substage;refractory_res.substage_tone{p}'];
            end
        end
    end
    
    
    [sort_delay,idx_delta_delay] = sort(delta_delay,'ascend');
    idx_delta_delay(sort_delay>thresh_delay_tone)=[];

    result.delay{m} = sort_delay(sort_delay<=thresh_delay_tone);
    result.induce{m} = delta_induced(idx_delta_delay);
    result.substage{m} = delta_substage(idx_delta_delay);
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save QuantifRefractoryPeriod_bis.mat -v7.3 result animals substage_ind