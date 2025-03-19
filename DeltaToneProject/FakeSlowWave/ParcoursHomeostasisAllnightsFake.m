%%ParcoursHomeostasisAllnightsFake
% 21.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 FakeSlowWaveOneNightHomeostasis




Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p homeo_res
    
    homeo_res.path{p}   = Dir.path{p};
    homeo_res.manipe{p} = Dir.manipe{p};
    homeo_res.name{p}   = Dir.name{p};
    homeo_res.date{p}   = Dir.date{p};
    
    %params
    binsize = 3*60e4;
    
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
%     NREM = NREM - TotalNoiseEpoch;
        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    %local detection
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_deep)])
    eval(['DeltaDeep = delta_ch_' num2str(ch_deep) ';'])
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_sup)])
    eval(['DeltaSup = delta_ch_' num2str(ch_sup) ';'])

    deltadeep_tmp = Range(Restrict(ts(Start(DeltaDeep)), NREM));
    deltasup_tmp = Range(Restrict(ts(Start(DeltaSup)), NREM));

    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    
    %LFP PFCx
    load(['LFPData/LFP' num2str(ch_deep) '.mat'])
    PFCdeep = LFP;
    load(['LFPData/LFP' num2str(ch_sup) '.mat'])
    PFCsup = LFP;
    clear LFP channel

    
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
    
    
    %% Homeostasis curves
    
    homeo_res.Qdensity.deep.good{p} = HomeostasisCurves_KJ(ts(good_deep), 'epoch', NREM, 'newtsdzt', NewtsdZT,'windowsize',binsize);
    homeo_res.Qdensity.deep.fake{p} = HomeostasisCurves_KJ(ts(fake_deep), 'epoch', NREM, 'newtsdzt', NewtsdZT,'windowsize',binsize);
    homeo_res.Qdensity.sup.good{p}  = HomeostasisCurves_KJ(ts(good_sup), 'epoch', NREM, 'newtsdzt', NewtsdZT,'windowsize',binsize);
    homeo_res.Qdensity.sup.fake{p}  = HomeostasisCurves_KJ(ts(fake_sup), 'epoch', NREM, 'newtsdzt', NewtsdZT,'windowsize',binsize);
        
    homeo_res.Qdensity.down{p}      = HomeostasisCurves_KJ(ts(st_down), 'epoch', NREM, 'newtsdzt', NewtsdZT,'windowsize',binsize);

    
end



%saving data
cd(FolderDeltaDataKJ)
save ParcoursHomeostasisAllnightsFake.mat homeo_res



