%%QuantifDelayRipplesStartEndDown
% 31.05.2018 KJ
%
%   Delay between tones or sham and next transitions
%
% see
%   QuantifDelayTonesStartEndDown
%



clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451]);

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p delay_res
    
    delay_res.path{p}   = Dir.path{p};
    delay_res.manipe{p} = Dir.manipe{p};
    delay_res.name{p}   = Dir.name{p};
    delay_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 2; %2ms
    minDuration = 40;
    maxDuration = 30e4;
    
    %substages
    load('SleepSubstages.mat')
    NREM = CleanUpEpoch(or(Epoch{1},or(Epoch{2},Epoch{3})));
    
    
    %% MUA
    [MUA, nb_neurons] = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration); %5sec
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    
    %% Ripples    
    load('Ripples.mat', 'Ripples')
    ripples_tmp = Ripples(:,2)*10;
    RipplesEvent = ts(ripples_tmp);
    RipplesIn = Restrict(RipplesEvent, down_PFCx);
    RipplesOut = Restrict(RipplesEvent, up_PFCx);
    
    
    %% Create Sham 
    
    %down
    nb_sham = 3000;
    idx = randsample(length(st_down), nb_sham);
    shamin_tmp = [];
    for i=1:length(idx)
        min_tmp = st_down(idx(i));
        duree = end_down(idx(i))-st_down(idx(i));
        shamin_tmp = [shamin_tmp min_tmp+rand(1)*duree];
    end
    shamin_tmp = sort(shamin_tmp);
    
    %up
    nb_sham = 3000;
    idx = randsample(length(st_up), nb_sham);
    shamout_tmp = [];
    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        shamout_tmp = [shamout_tmp min_tmp+rand(1)*duree];
    end
    shamout_tmp = sort(shamout_tmp);
    
    
    %% Ripples and delay    
    
    %ripples in
    ripplesin_tmp = Range(RipplesIn);
    delay_ripplesin = zeros(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        idx = find(end_down > ripplesin_tmp(i), 1);
        delay_ripplesin(i) = end_down(idx) - ripplesin_tmp(i);
    end
    delay_res.ripples.inside{p} = delay_ripplesin;
    
    %tones out
    ripplesout_tmp = Range(RipplesOut);
    delay_ripplesout = zeros(length(ripplesout_tmp), 1);
    for i=1:length(ripplesout_tmp)
        idx = find(st_down > ripplesout_tmp(i), 1);
        delay_ripplesout(i) = st_down(idx) - ripplesout_tmp(i);
    end
    delay_res.ripples.outside{p} = delay_ripplesout;

    %sham in
    delay_shamin = zeros(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        idx = find(end_down > shamin_tmp(i), 1);
        delay_shamin(i) = end_down(idx) - shamin_tmp(i);
    end
    delay_res.sham.inside{p} = delay_shamin;
    
    %sham out
    delay_shamout = zeros(length(shamout_tmp), 1);
    for i=1:length(shamout_tmp)
        idx = find(st_down > shamout_tmp(i), 1);
        delay_shamout(i) = st_down(idx) - shamout_tmp(i);
    end
    delay_res.sham.outside{p} = delay_shamout;
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifDelayRipplesStartEndDown.mat delay_res binsize_mua minDuration


