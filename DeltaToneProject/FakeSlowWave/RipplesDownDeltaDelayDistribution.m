%%RipplesDownDeltaDelayDistribution
% 26.08.2019 KJ
%
% Delay between ripples and good/false deltas - down ...
%
%
% see
%   RipplesInDownN2N3Effect FigureExampleFakeSlowWaveRipple1
%   RipplesDownDeltaDelayDistributionPlot
%


clear

Dir=PathForExperimentsFakeSlowWave;
Dir = RestrictPathForExperiment(Dir,'nMice',[243 490 507 508 509]);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res effect_periods
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};

   
    %params
    minDurationDown = 75; %in ms
    minDuration = 0.5e4; %500ms
    maxDuration = 30e4;
    preripples_window = [0 1000]*10 ;
    
    %MUA & Down
    if strcmpi(Dir.name{p},'Mouse508')
        down_PFCx = GetDownStates('area','PFCx_r');
    elseif strcmpi(Dir.name{p},'Mouse509')
        down_PFCx = GetDownStates('area','PFCx_l');
    else
        down_PFCx = GetDownStates;
    end
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDuration);
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %ripples       
    try
        [tRipples, ~] = GetRipples;
        ripples_tmp = Range(tRipples);
    catch
        continue
    end
    
    %ripples without down before
    intvdownripples = [st_down end_down+preripples_window(2)];
    [status,~,~] = InIntervals(ripples_tmp, intvdownripples);
    ripples_alone = ripples_tmp(status==0);
    
    %raster
    load('RasterLFPDeltaWaves.mat','deltadeep', 'ch_deep') 
    %local detection deep 
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
    eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
    delta_deep = Restrict(ts(Start(DeltaDeep)), NREM);
    deltadeep_tmp = Range(delta_deep);
    
%     %local detection sup 
%     load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
%     eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])
%     delta_sup = Restrict(ts(Start(DeltaSup)), NREM);
%     deltasup_tmp = Range(delta_sup);

    
    %% Quantification good and fake

    %delta deep>PFCsup
    nb_sample = round(length(deltadeep_tmp)/4);

    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
    [~, idx1] = sort(vmean1);
    
    good_deep = sort(deltadeep_tmp(idx1(1:nb_sample)));%good
    fake_deep = sort(deltadeep_tmp(idx1(end-nb_sample+1:end)));%fake

%     %delta sup>PFCdeep
%     nb_sample = round(length(deltasup_tmp)/4);
% 
%     raster_tsd = deltasup.deep;
%     Mat = Data(raster_tsd)';
%     x_tmp = Range(raster_tsd);
%     vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
%     [~, idx2] = sort(vmean2);
%     
%     good_sup = sort(deltasup_tmp(idx2(end-nb_sample+1:end)));%good
%     fake_sup = sort(deltasup_tmp(idx2(1:nb_sample)));%fake
    
    
    %% Create sham
    nb_sham = min(4000, length(st_up));
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Ripples in - N2 & N3
    RipplesUpNREM = Restrict(Restrict(tRipples, NREM), up_PFCx);
    ripples_res.nb_ripples{p} = length(RipplesUpNREM);
    
    ripples_alone = Range(Restrict(Restrict(ts(ripples_alone), NREM), up_PFCx));
    
    %% Sham in - N2 & N3 & NREM
    ShamUpNREM = Restrict(Restrict(ShamEvent, NREM), up_PFCx);
    ripples_res.nb_sham{p} = length(ShamUpNREM);
    
    
    %% Delay between ripples and events
    
    %sham
    shamin_tmp = Range(ShamUpNREM);
    ripples_res.sham.before{p} = nan(length(shamin_tmp), 1);
    ripples_res.sham.after{p} = nan(length(shamin_tmp), 1);
    for i=1:length(shamin_tmp)
        down_bef = st_down(find(st_down<shamin_tmp(i),1,'last'));
        try
            ripples_res.sham.before{p}(i) = shamin_tmp(i) - down_bef;
        end
        
        down_aft = st_down(find(st_down>shamin_tmp(i),1));
        try
            ripples_res.sham.after{p}(i) = down_aft - shamin_tmp(i);
        end
    end
    
    %down
    ripplesin_tmp = Range(RipplesUpNREM);
    ripples_res.down.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.down.after{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        down_bef = st_down(find(st_down<ripplesin_tmp(i),1,'last'));
        try
            ripples_res.down.before{p}(i) = ripplesin_tmp(i) - down_bef;
        end
        
        down_aft = st_down(find(st_down>ripplesin_tmp(i),1));
        try
            ripples_res.down.after{p}(i) = down_aft - ripplesin_tmp(i);
        end
    end
    
    
    %all deltas
    ripplesin_tmp = Range(RipplesUpNREM);
    ripples_res.deltas.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.deltas.after{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        down_bef = deltadeep_tmp(find(deltadeep_tmp<ripplesin_tmp(i),1,'last'));
        try
            ripples_res.deltas.before{p}(i) = ripplesin_tmp(i) - down_bef;
        end
        
        down_aft = deltadeep_tmp(find(deltadeep_tmp>ripplesin_tmp(i),1));
        try
            ripples_res.deltas.after{p}(i) = down_aft - ripplesin_tmp(i);
        end
    end
    
    %good deltas
    ripplesin_tmp = Range(RipplesUpNREM);
    ripples_res.good.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.good.after{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        down_bef = good_deep(find(good_deep<ripplesin_tmp(i),1,'last'));
        try
            ripples_res.good.before{p}(i) = ripplesin_tmp(i) - down_bef;
        end
        
        down_aft = good_deep(find(good_deep>ripplesin_tmp(i),1));
        try
            ripples_res.good.after{p}(i) = down_aft - ripplesin_tmp(i);
        end
    end
    
    %false deltas
    ripplesin_tmp = Range(RipplesUpNREM);
    ripples_res.fake.before{p} = nan(length(ripplesin_tmp), 1);
    ripples_res.fake.after{p} = nan(length(ripplesin_tmp), 1);
    for i=1:length(ripplesin_tmp)
        down_bef = fake_deep(find(fake_deep<ripplesin_tmp(i),1,'last'));
        try
            ripples_res.fake.before{p}(i) = ripplesin_tmp(i) - down_bef;
        end
        
        down_aft = fake_deep(find(fake_deep>ripplesin_tmp(i),1));
        try
            ripples_res.fake.after{p}(i) = down_aft - ripplesin_tmp(i);
        end
    end
    
    %false deltas and ripples alone
    ripples_res.fakecorrected.before{p} = nan(length(ripples_alone), 1);
    ripples_res.fakecorrected.after{p} = nan(length(ripples_alone), 1);
    for i=1:length(ripples_alone)
        down_bef = fake_deep(find(fake_deep<ripples_alone(i),1,'last'));
        try
            ripples_res.fakecorrected.before{p}(i) = ripples_alone(i) - down_bef;
        end
        
        down_aft = fake_deep(find(fake_deep>ripples_alone(i),1));
        try
            ripples_res.fakecorrected.after{p}(i) = down_aft - ripples_alone(i);
        end
    end
    
    
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save RipplesDownDeltaDelayDistribution.mat ripples_res  



