% RandomPethAnalysis_bis
% 07.12.2016 KJ
%
% Transform data from RandomPethAnalysis (concatenate...)
% 
% 
%   see RandomPethAnalysis RandomPethAnalysis2
%

clear
load(fullfile(FolderDeltaDataKJ,'RandomPethAnalysis.mat'))

%params
thresh_delay_tone = 4E4; %4sec - maximum delay between a delta and the next tone, for the raster

animals = rdmpeth_res.name;
animals = unique(animals(~cellfun('isempty',animals)));
substage_ind = 1:5;

for m=1:length(animals)
    %delta diff
    mouse_raster = [];
    for p=1:length(rdmpeth_res.path)
        if strcmpi(rdmpeth_res.name{p},animals{m})
            raster_tsd = rdmpeth_res.delta.raster.diff{p};
            raster_x = Range(raster_tsd);
            if isempty(mouse_raster)
                mouse_raster = Data(raster_tsd)';
                delta_delay = rdmpeth_res.delta.delay{p};
                delta_induced = rdmpeth_res.delta.induced{p};
                delta_substage = rdmpeth_res.substage_tone{p}';
            else
                mouse_raster = [mouse_raster;Data(raster_tsd)'];
                delta_delay = [delta_delay;rdmpeth_res.delta.delay{p}];
                delta_induced = [delta_induced;rdmpeth_res.delta.induced{p}];
                delta_substage = [delta_substage;rdmpeth_res.substage_tone{p}'];
            end
        end
    end
    
    [sort_delay,idx_delta_delay] = sort(delta_delay,'ascend');
    idx_delta_delay(sort_delay>thresh_delay_tone)=[];
    
    diff.raster_matrix{m} = mouse_raster(idx_delta_delay,:);
    diff.raster_time{m} = raster_x;
    diff.delay{m} = sort_delay(sort_delay<=thresh_delay_tone);
    diff.induce{m} = delta_induced(idx_delta_delay);
    diff.substage{m} = delta_substage(idx_delta_delay);
    
    %delta deep
    mouse_raster = [];
    for p=1:length(rdmpeth_res.path)
        if strcmpi(rdmpeth_res.name{p},animals{m})
            raster_tsd = rdmpeth_res.delta.raster.deep{p};
            raster_x = Range(raster_tsd);
            if isempty(mouse_raster)
                mouse_raster = Data(raster_tsd)';
                delta_delay = rdmpeth_res.delta.delay{p};
                delta_induced = rdmpeth_res.delta.induced{p};
                delta_substage = rdmpeth_res.substage_tone{p}';
            else
                mouse_raster = [mouse_raster;Data(raster_tsd)'];
                delta_delay = [delta_delay;rdmpeth_res.delta.delay{p}];
                delta_induced = [delta_induced;rdmpeth_res.delta.induced{p}];
                delta_substage = [delta_substage;rdmpeth_res.substage_tone{p}'];
            end
        end
    end
    
    [sort_delay,idx_delta_delay] = sort(delta_delay,'ascend');
    idx_delta_delay(sort_delay>thresh_delay_tone)=[];
    
    deep.raster_matrix{m} = mouse_raster(idx_delta_delay,:);
    deep.raster_time{m} = raster_x;
    deep.delay{m} = sort_delay(sort_delay<=thresh_delay_tone);
    deep.induce{m} = delta_induced(idx_delta_delay);
    deep.substage{m} = delta_substage(idx_delta_delay);
    
    %mua and down
    mouse_raster = [];
    for p=1:length(rdmpeth_res.path)
        if strcmpi(rdmpeth_res.name{p},animals{m})
            raster_tsd = rdmpeth_res.down.raster{p};
            raster_x = Range(raster_tsd);
            if isempty(mouse_raster)
                mouse_raster = Data(raster_tsd)';
                down_delay = rdmpeth_res.down.delay{p};
                down_induced = rdmpeth_res.down.induced{p};
                down_substage = rdmpeth_res.substage_tone{p}';
            else
                mouse_raster = [mouse_raster;Data(raster_tsd)'];
                down_delay = [down_delay;rdmpeth_res.down.delay{p}];
                down_induced = [down_induced;rdmpeth_res.down.induced{p}];
                down_substage = [down_substage;rdmpeth_res.substage_tone{p}'];
            end
        end
    end
    
    [sort_delay_down,idx_down_delay] = sort(down_delay,'ascend');
    idx_down_delay(sort_delay_down>thresh_delay_tone)=[];
    sort_delay_down(sort_delay_down>thresh_delay_tone)=[];
    
    mua.raster_matrix{m} = mouse_raster(idx_down_delay,:);
    mua.raster_time{m} = raster_x;
    mua.delay{m} = sort_delay_down;
    mua.induce{m} = down_induced(idx_down_delay);
    mua.substage{m} = down_substage(idx_down_delay);
    
end


%saving data
cd([FolderProjetDelta 'Data/']) 
save RandomPethAnalysis_bis.mat -v7.3 diff deep mua animals substage_ind





