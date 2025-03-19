%%RipplesDownMeancurves
% 26.08.2019 KJ
%
% Meancurves on ripples
%
%
% see
%   FigureExampleFakeSlowWaveRipple1
%


clear

Dir=PathForExperimentsFakeSlowWave;
Dir = RestrictPathForExperiment(Dir,'nMice',[243 490 507 508 509]);
effect_periods_down = GetEffectPeriodDownRipples(Dir);


%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p ripples_res effect_periods_down
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};

   
    %params
    binsize_mua = 10;
    minDurationUp = 0.5e4; %500ms
    maxDurationUp = 30e4;
    
    binsize_met = 10;
    nbBins_met  = 200;
    
    range_inducedown = effect_periods_down(p,:);
    range_inducedelta = [0 2500];
    
    
    %% load
    
    %raster
    load('RasterLFPDeltaWaves.mat','deltadeep', 'deltasup', 'ch_deep', 'ch_sup') 

    %hemisphere
    if strcmpi(Dir.name{p},'Mouse508')
        hsp='_r';
    elseif strcmpi(Dir.name{p},'Mouse509')
        hsp='_l';
    else
        hsp='';
    end

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;

    %MUA
    MUA = GetMuaNeurons_KJ(['PFCx' hsp], 'binsize',binsize_mua); 

    %Ripples
    [tRipples, ~] = GetRipples;
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    center_down = (Start(down_PFCx)+End(down_PFCx))/2;
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp);
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    center_deltas = (Start(deltas_PFCx)+End(deltas_PFCx))/2;
    
    %local detection  
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
    eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
    eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])

    delta_deep = Restrict(ts(Start(DeltaDeep)), NREM);
    delta_sup = Restrict(ts(Start(DeltaSup)), NREM);
    deltadeep_tmp = Range(delta_deep);
    deltasup_tmp = Range(delta_sup);

    %LFP
    load(['LFPData/LFP' num2str(ch_deep) '.mat'])
    PFCdeep = LFP;
    load(['LFPData/LFP' num2str(ch_sup) '.mat'])
    PFCsup = LFP;
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    HPC = LFP;
    clear LFP channel
    
    
    %% Ripples
    RipplesUpNREM = Restrict(Restrict(tRipples, up_PFCx),NREM);
    ripples_tmp = Range(RipplesUpNREM);
    ripples_res.nb_ripples{p} = length(tRipples); 

    %ripples without down before
    preripples_window = [0 1000]*10 ;
    intvdownripples = [st_down end_down+preripples_window(2)];
    [status,~,~] = InIntervals(ripples_tmp, intvdownripples);
    ripples_alone = ripples_tmp(status==0);
    
    
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

    %delta sup>PFCdeep
    nb_sample = round(length(deltasup_tmp)/4);

    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
    [~, idx2] = sort(vmean2);
    
    good_sup = sort(deltasup_tmp(idx2(end-nb_sample+1:end)));%good
    fake_sup = sort(deltasup_tmp(idx2(1:nb_sample)));%fake
    
    
    %% Ripples success and failed...
    %Ripples INDUCED a Down ?
    intv_success = [Range(RipplesUpNREM)+range_inducedown(1) Range(RipplesUpNREM)+range_inducedown(2)];
    [~,intervals,~] = InIntervals(st_down, intv_success);
    intervals(intervals==0)=[];
    idx_success = unique(intervals);
    idx_nodown  = setdiff(1:length(RipplesUpNREM),idx_success)'; 
    
    %Ripples followed by a fake delta 
    ripples_nodown = Range(RipplesUpNREM);
    ripples_nodown = ripples_nodown(idx_nodown);
    intv_fake = [ripples_nodown+range_inducedelta(1) ripples_nodown+range_inducedelta(2)]; 
    [~,intervals,~] = InIntervals(fake_deep, intv_fake);
    intervals(intervals==0)=[];
    idx_fake = unique(intervals);
    idx_nofake  = setdiff(1:length(ripples_nodown),idx_fake)';
    
    % Quantification of fake delta waves
    ratio_success = length(idx_success)/length(RipplesUpNREM);
    ratio_fake = length(idx_fake)/length(ripples_nodown);
    
    %% meancurves on ripples
    
    %all ripples
    %MUA
    [m,~,tps] = mETAverage(Range(tRipples), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.met_rip.mua{p}(:,1) = tps; ripples_res.met_rip.mua{p}(:,2) = m;
    %HPC
    [m,~,tps] = mETAverage(Range(tRipples), Range(HPC), Data(HPC), binsize_met, nbBins_met);
    ripples_res.met_rip.hpc{p}(:,1) = tps; ripples_res.met_rip.hpc{p}(:,2) = m;
    %PFCdeep
    [m,~,tps] = mETAverage(Range(tRipples), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    ripples_res.met_rip.deep{p}(:,1) = tps; ripples_res.met_rip.deep{p}(:,2) = m;
    %PFCsup
    [m,~,tps] = mETAverage(Range(tRipples), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    ripples_res.met_rip.sup{p}(:,1) = tps; ripples_res.met_rip.sup{p}(:,2) = m;
    
    
    %ripples followed by down states
    ripples_down = Range(RipplesUpNREM);
    ripples_down = ripples_down(idx_success);
    %MUA
    [m,~,tps] = mETAverage(ripples_down, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.met_ripdown.mua{p}(:,1) = tps; ripples_res.met_ripdown.mua{p}(:,2) = m;
    %HPC
    [m,~,tps] = mETAverage(ripples_down, Range(HPC), Data(HPC), binsize_met, nbBins_met);
    ripples_res.met_ripdown.hpc{p}(:,1) = tps; ripples_res.met_ripdown.hpc{p}(:,2) = m;
    %PFCdeep
    [m,~,tps] = mETAverage(ripples_down, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    ripples_res.met_ripdown.deep{p}(:,1) = tps; ripples_res.met_ripdown.deep{p}(:,2) = m;
    %PFCsup
    [m,~,tps] = mETAverage(ripples_down, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    ripples_res.met_ripdown.sup{p}(:,1) = tps; ripples_res.met_ripdown.sup{p}(:,2) = m;

    
    %ripples not followed by down and followed by fake
    ripples_fake = ripples_nodown(idx_fake);
    %MUA
    [m,~,tps] = mETAverage(ripples_fake, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.met_ripfake.mua{p}(:,1) = tps; ripples_res.met_ripfake.mua{p}(:,2) = m;
    %HPC
    [m,~,tps] = mETAverage(ripples_fake, Range(HPC), Data(HPC), binsize_met, nbBins_met);
    ripples_res.met_ripfake.hpc{p}(:,1) = tps; ripples_res.met_ripfake.hpc{p}(:,2) = m;
    %PFCdeep
    [m,~,tps] = mETAverage(ripples_fake, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    ripples_res.met_ripfake.deep{p}(:,1) = tps; ripples_res.met_ripfake.deep{p}(:,2) = m;
    %PFCsup
    [m,~,tps] = mETAverage(ripples_fake, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    ripples_res.met_ripfake.sup{p}(:,1) = tps; ripples_res.met_ripfake.sup{p}(:,2) = m;
    
    
    %ripples not followed by down and followed by fake
    ripples_nofake = ripples_nodown(idx_nofake);
    %MUA
    [m,~,tps] = mETAverage(ripples_nofake, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    ripples_res.met_nofake.mua{p}(:,1) = tps; ripples_res.met_nofake.mua{p}(:,2) = m;
    %HPC
    [m,~,tps] = mETAverage(ripples_nofake, Range(HPC), Data(HPC), binsize_met, nbBins_met);
    ripples_res.met_nofake.hpc{p}(:,1) = tps; ripples_res.met_nofake.hpc{p}(:,2) = m;
    %PFCdeep
    [m,~,tps] = mETAverage(ripples_nofake, Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    ripples_res.met_nofake.deep{p}(:,1) = tps; ripples_res.met_nofake.deep{p}(:,2) = m;
    %PFCsup
    [m,~,tps] = mETAverage(ripples_nofake, Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    ripples_res.met_nofake.sup{p}(:,1) = tps; ripples_res.met_nofake.sup{p}(:,2) = m;
    
    
    
end




%saving data
cd(FolderDeltaDataKJ)
save RipplesDownMeancurves.mat ripples_res  











