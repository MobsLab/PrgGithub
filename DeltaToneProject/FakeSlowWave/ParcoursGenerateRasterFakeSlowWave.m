%ParcoursGenerateRasterFakeSlowWave
% 23.06.2019 KJ
%
%
% see FakeSlowWaveOneNight2
%


clear

Dir = PathForExperimentsFakeSlowWave('allsup');

for p=12:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except fake_res Dir p
    
    %params
    t_before = -1E4; %in 1E-4s
    t_after = 1E4; %in 1E-4s
    
%     if exist('RasterLFPDeltaWaves.mat','file')==2
%         continue
%     end

    %% load

    %channels
    load('ChannelsToAnalyse/PFCx_deep.mat')
    ch_deep = channel;
    load('ChannelsToAnalyse/PFCx_sup.mat')
    ch_sup = channel;
    
    %LFP
    load(['LFPData/LFP' num2str(ch_deep) '.mat'])
    PFCdeep = LFP;
    clear LFP
    load(['LFPData/LFP' num2str(ch_sup) '.mat'])
    PFCsup = LFP;
    clear LFP
    
    %SWS
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
    
    %generate delta
    MakeDeltaOnChannelsEvent(ch_deep,'positive',1,'recompute',0);
    MakeDeltaOnChannelsEvent(ch_sup,'positive',0,'recompute',0);
    
    %local detection
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
    eval(['delta_deep = delta_ch_' num2str(ch_deep) ';'])
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
    eval(['delta_sup = delta_ch_' num2str(ch_sup) ';'])

    deltadeep_tmp = Restrict(ts(Start(delta_deep)), NREM);
    deltasup_tmp = Restrict(ts(Start(delta_sup)), NREM);


    %% Raster
    deltadeep.sup = RasterMatrixKJ(PFCsup, deltadeep_tmp, t_before, t_after);
    deltadeep.deep = RasterMatrixKJ(PFCdeep, deltadeep_tmp, t_before, t_after);
    deltasup.deep = RasterMatrixKJ(PFCdeep, deltasup_tmp, t_before, t_after);
    deltasup.sup = RasterMatrixKJ(PFCsup, deltasup_tmp, t_before, t_after);
    
    %save
    save RasterLFPDeltaWaves.mat deltadeep deltasup ch_deep ch_sup deltadeep_tmp deltasup_tmp
    
end




