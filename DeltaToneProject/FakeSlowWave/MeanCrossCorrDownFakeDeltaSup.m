%%MeanCrossCorrDownFakeDeltaSup
% 05.09.2019 KJ
%
% Infos
%   Crosscorr on fake delta waves of sup PFC
%
% see
%    MeanCrossCorrDownFakeDeltaDeep MeanCrossCorrDownFakeDeltaSupPlot
%    



Dir = PathForExperimentsFakeSlowWave('sup');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p cross_res
    
    cross_res.path{p}   = Dir.path{p};
    cross_res.manipe{p} = Dir.manipe{p};
    cross_res.name{p}   = Dir.name{p};
    cross_res.date{p}   = Dir.date{p};
    
    %params
    binsize_cc = 10; %10ms
    nb_binscc = 100;

    %raster
    load('RasterLFPDeltaWaves.mat','deltasup', 'ch_sup', 'deltasup_tmp') 

    %hemisphere
    if strcmpi(Dir.name{p},'Mouse508')
        hsp='_r';
    elseif strcmpi(Dir.name{p},'Mouse509')
        hsp='_l';
    else
        hsp='';
    end
    
    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    center_down = (Start(down_PFCx) + End(down_PFCx) ) /2;
    cross_res.nb_down{p} = length(st_down);
    %deltas channel
    deltasup_tmp = Range(deltasup_tmp);
    
    
    %% Quantification good and fake

    %delta sup>PFCdeep
    nb_sample = round(length(deltasup_tmp)/4);

    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
%     if strcmpi(Dir.name{p},'Mouse451')
%         vmean = mean(Mat(:,x_tmp>-0.2e4&x_tmp<0),2);
%     end
    [~, idxMat] = sort(vmean);
    
    good_sup = sort(deltasup_tmp(idxMat(end-nb_sample+1:end)));%good
    fake_sup = sort(deltasup_tmp(idxMat(1:nb_sample)));%fake
    
    
    %% Cross-corr
    
    %all sup
    [cross_res.ondown.all{p}(:,2), cross_res.ondown.all{p}(:,1)] = CrossCorr(st_down, deltasup_tmp, binsize_cc, nb_binscc);
    [cross_res.ondelta.all{p}(:,2), cross_res.ondelta.all{p}(:,1)] = CrossCorr(deltasup_tmp, st_down, binsize_cc, nb_binscc);
    %good delta sup
    [cross_res.ondown.good{p}(:,2), cross_res.ondown.good{p}(:,1)] = CrossCorr(st_down, good_sup, binsize_cc, nb_binscc);
    [cross_res.ondelta.good{p}(:,2), cross_res.ondelta.good{p}(:,1)] = CrossCorr(good_sup, st_down, binsize_cc, nb_binscc);
    %fake delta sup
    [cross_res.ondown.fake{p}(:,2), cross_res.ondown.fake{p}(:,1)] = CrossCorr(st_down, fake_sup, binsize_cc, nb_binscc);
    [cross_res.ondelta.fake{p}(:,2), cross_res.ondelta.fake{p}(:,1)] = CrossCorr(fake_sup, st_down, binsize_cc, nb_binscc);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save MeanCrossCorrDownFakeDeltaSup.mat cross_res


