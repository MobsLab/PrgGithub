%%MeanCurvesMUAFakeDeltaSup
% 05.09.2019 KJ
%
% Infos
%   meancurves on fake delta waves of sup PFC
%
% see
%    ParcoursHomeostasisSleepCycle MeanCurvesMUAFakeDeltaSupPlot
%    MeanCurvesMUAFakeDeltaDeep    
%


clear
Dir = PathForExperimentsFakeSlowWave('allsup');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p muadelta_res
    
    muadelta_res.path{p}   = Dir.path{p};
    muadelta_res.manipe{p} = Dir.manipe{p};
    muadelta_res.name{p}   = Dir.name{p};
    muadelta_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 10;
    binsize_met = 10;
    nbBins_met  = 160;

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
        
    %MUA
    MUA = GetMuaNeurons_KJ(['PFCx' hsp], 'binsize',binsize_mua); 
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    muadelta_res.nb_down{p} = length(st_down);
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
    
    
    %% MUA response
    
    %all sup
    [m,~,tps] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.all{p}(:,1) = tps; muadelta_res.met_mua.all{p}(:,2) = m;
    %good delta sup
    [m,~,tps] = mETAverage(good_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.good{p}(:,1) = tps; muadelta_res.met_mua.good{p}(:,2) = m;
    %fake delta sup
    [m,~,tps] = mETAverage(fake_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.fake{p}(:,1) = tps; muadelta_res.met_mua.fake{p}(:,2) = m;
    
    
    %% number of down linked to deltas
    
    %all sup
    intv = [deltasup_tmp-1500 deltasup_tmp];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.all.nb_down{p} = length(intervals);
    muadelta_res.all.nb{p} = length(deltasup_tmp);
    
    %good sup
    intv = [good_sup-1500 good_sup];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.good.nb_down{p} = length(intervals);
    muadelta_res.good.nb{p} = length(good_sup);
    
    %fake sup
    intv = [fake_sup-1500 fake_sup];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.fake.nb_down{p} = length(intervals);
    muadelta_res.fake.nb{p} = length(fake_sup);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save MeanCurvesMUAFakeDeltaSup.mat muadelta_res


