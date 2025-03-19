%%QuantifFakeSlowWaveNeuron
% 23.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 FigureExampleFakeSlowWaveNeuron1





%% load

% load

Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p fake_res
    
    fake_res.path{p}   = Dir.path{p};
    fake_res.manipe{p} = Dir.manipe{p};
    fake_res.name{p}   = Dir.name{p};
    fake_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 10;
    binsize_met = 10;
    nbBins_met  = 160;
    binsize_cc = 10; %10ms
    nb_binscc = 200;

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

        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    center_down = (Start(down_PFCx)+End(down_PFCx))/2;
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

    %night duration
    load('IdFigureData2.mat', 'night_duration')

    %LFP PFCx
    labels_ch = cell(0);
    PFC = cell(0);

    load('ChannelsToAnalyse/PFCx_locations.mat')
    for ch=1:length(channels)
        load(['LFPData/LFP' num2str(channels(ch)) '.mat'])
        PFC{ch} = LFP;
        clear LFP

        labels_ch{ch} = ['Ch ' num2str(channels(ch))];
    end

    PFCdeep = PFC{channels==ch_deep};
    PFCsup = PFC{channels==ch_sup};
    
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

    clear deltadeep deltasup raster_tsd Mat
    
       
    
    %% MUA response
    
    %all deep
    [y_mua,~,x_mua] = mETAverage(deltadeep_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.deep.all{p} = min(y_mua);
    fake_res.mua_decrease.deep.all{p} = min(y_mua)/baseline;
    %good deep
    [y_mua,~,x_mua] = mETAverage(good_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.deep.good{p} = min(y_mua);
    fake_res.mua_decrease.deep.good{p} = min(y_mua)/baseline;
    %fake deep
    [y_mua,~,x_mua] = mETAverage(fake_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.deep.fake{p} = min(y_mua);
    fake_res.mua_decrease.deep.fake{p} = min(y_mua)/baseline;
    
    
    %all sup
    [y_mua,~,x_mua] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.sup.all{p} = min(y_mua);
    fake_res.mua_decrease.sup.all{p} = min(y_mua)/baseline;
    %good sup
    [y_mua,~,x_mua] = mETAverage(good_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.sup.good{p} = min(y_mua);
    fake_res.mua_decrease.sup.good{p} = min(y_mua)/baseline;
    %fake sup
    [y_mua,~,x_mua] = mETAverage(fake_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    baseline = mean(y_mua(x_mua<-400));
    fake_res.mua_min.sup.fake{p} = min(y_mua);
    fake_res.mua_decrease.sup.fake{p} = min(y_mua)/baseline;
    

    %% Cross-corr with down states
    
    %all deep
    [Cc,t] = CrossCorr(st_down, deltadeep_tmp, binsize_cc, nb_binscc);
    fake_res.peakCC.deep.all{p} = max(Cc(t>-100 & t<150));
    %good deep
    [Cc,t] = CrossCorr(st_down, good_deep, binsize_cc, nb_binscc);
    fake_res.peakCC.deep.good{p} = max(Cc(t>-100 & t<150));
    %fake deep
    [Cc,t] = CrossCorr(st_down, fake_deep, binsize_cc, nb_binscc);
    fake_res.peakCC.deep.fake{p} = max(Cc(t>-100 & t<150));
    
    %all sup
    [Cc,t] = CrossCorr(st_down, deltasup_tmp, binsize_cc, nb_binscc);
    fake_res.peakCC.sup.all{p} = max(Cc(t>0 & t<150));
    %good sup
    [Cc,t] = CrossCorr(st_down, good_sup, binsize_cc, nb_binscc);
    fake_res.peakCC.sup.good{p} = max(Cc(t>0 & t<150));
    %fake sup
    [Cc,t] = CrossCorr(st_down, fake_sup, binsize_cc, nb_binscc);
    fake_res.peakCC.sup.fake{p} = max(Cc(t>0 & t<150));
    
    
    %% cross-corr between deltas 
    %deep
    [fake_res.crosscorr.deep.between{p}(:,2), fake_res.crosscorr.deep.between{p}(:,1)] = CrossCorr(good_deep, fake_deep, binsize_cc, nb_binscc);
    %sup
    [fake_res.crosscorr.sup.between{p}(:,2), fake_res.crosscorr.sup.between{p}(:,1)] = CrossCorr(good_sup, fake_sup, binsize_cc, nb_binscc);
    
    
end

%saving data
cd(FolderDeltaDataKJ)
save QuantifFakeSlowWaveNeuron.mat fake_res  






