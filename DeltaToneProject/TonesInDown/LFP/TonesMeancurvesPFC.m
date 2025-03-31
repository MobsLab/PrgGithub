%%TonesMeancurvesPFC
% 27.08.2019 KJ
%
%
%
%
% see
%   TonesInUpN2N3Effect


clear

Dir = PathForExperimentsRandomTonesSpikes;

%get data for each record
for p=1:length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p tones_res
    
    tones_res.path{p}   = Dir.path{p};
    tones_res.manipe{p} = Dir.manipe{p};
    tones_res.name{p}   = Dir.name{p};
    tones_res.date{p}   = Dir.date{p};

   
    %params
    binsize_met = 10;
    nbBins_met  = 80;
    binsize_mua = 2;
    
    minDurationDown = 40;
    minDurationUp = 0.5e4;
    maxDuration = 30e4;
    
    %MUA & Down
    MUA = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua);
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDurationDown,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropLongIntervals(up_PFCx, maxDuration);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %tones
    load('behavResources.mat', 'ToneEvent')
    
    %LFP
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCdeep = LFP;
    try
        load('ChannelsToAnalyse/PFCx_sup.mat')
    catch
        load('ChannelsToAnalyse/PFCx_deltasup.mat')
    end
    
    load(['LFPData/LFP' num2str(channel) '.mat'])
    PFCsup = LFP;
    clear LFP channel
    
    %substages
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    REM  = REM - TotalNoiseEpoch;
    Wake = Wake - TotalNoiseEpoch;
    
    
    %% Tones in
    
    ToneNREM = Restrict(ToneEvent, NREM);
    ToneREM  = Restrict(ToneEvent, REM);
    ToneWake = Restrict(ToneEvent, Wake);
    
    ToneDown = Restrict(ToneEvent, down_PFCx);
    ToneUp   = Restrict(ToneEvent, down_PFCx);
    
    tones_res.nb_tones.all      = length(ToneEvent);
    tones_res.nb_tones.nrem{p}  = length(ToneNREM);
    tones_res.nb_tones.rem{p}   = length(ToneREM);
    tones_res.nb_tones.wake{p}  = length(ToneWake);
    
    tones_res.nb_tones.down{p}  = length(ToneDown);
    tones_res.nb_tones.up{p}    = length(ToneUp);


    %% LFP and MUA response for tones
    
    %NREM
    [m,~,tps] = mETAverage(Range(ToneNREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_mua.nrem{p}(:,1) = tps; tones_res.met_mua.nrem{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneNREM), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    tones_res.met_deep.nrem{p}(:,1) = tps; tones_res.met_deep.nrem{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneNREM), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    tones_res.met_sup.nrem{p}(:,1) = tps; tones_res.met_sup.nrem{p}(:,2) = m;
    
    %REM
    [m,~,tps] = mETAverage(Range(ToneREM), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_mua.rem{p}(:,1) = tps; tones_res.met_mua.rem{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneREM), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    tones_res.met_deep.rem{p}(:,1) = tps; tones_res.met_deep.rem{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneREM), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    tones_res.met_sup.rem{p}(:,1) = tps; tones_res.met_sup.rem{p}(:,2) = m;
    
    %Wake
    [m,~,tps] = mETAverage(Range(ToneWake), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_mua.wake{p}(:,1) = tps; tones_res.met_mua.wake{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneWake), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    tones_res.met_deep.wake{p}(:,1) = tps; tones_res.met_deep.wake{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneWake), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    tones_res.met_sup.wake{p}(:,1) = tps; tones_res.met_sup.wake{p}(:,2) = m;

    %UP
    [m,~,tps] = mETAverage(Range(ToneUp), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_mua.up{p}(:,1) = tps; tones_res.met_mua.up{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneUp), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    tones_res.met_deep.up{p}(:,1) = tps; tones_res.met_deep.up{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneUp), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    tones_res.met_sup.up{p}(:,1) = tps; tones_res.met_sup.up{p}(:,2) = m;
    
    %Down
    [m,~,tps] = mETAverage(Range(ToneDown), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    tones_res.met_mua.down{p}(:,1) = tps; tones_res.met_mua.down{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneDown), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    tones_res.met_deep.down{p}(:,1) = tps; tones_res.met_deep.down{p}(:,2) = m;
    [m,~,tps] = mETAverage(Range(ToneDown), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    tones_res.met_sup.down{p}(:,1) = tps; tones_res.met_sup.down{p}(:,2) = m;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save TonesMeancurvesPFC.mat tones_res



