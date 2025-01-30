%%MeanCurvesMUAFakeDeltaDeep
% 05.09.2019 KJ
%
% Infos
%   meancurves mua on fake delta waves of deep PFC
%
% see
%    MeanCurvesMUAFakeDeltaSup MeanCurvesMUAFakeDeltaDeepPlot
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
    load('RasterLFPDeltaWaves.mat','deltadeep', 'ch_deep', 'deltadeep_tmp') 

    %hemisphere
    if strcmpi(Dir.name{p},'Mouse508')
        hsp='_r';
    elseif strcmpi(Dir.name{p},'Mouse509')
        hsp='_l';
    else
        hsp='';
    end

    %MUA
    MUA = GetMuaNeurons_KJ(['PFCx' hsp], 'binsize',binsize_mua); 
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    muadelta_res.nb_down{p} = length(st_down);
    %deltas channel
    deltadeep_tmp = Range(deltadeep_tmp);
    
    
    %% Quantification good and fake

    %delta deep>PFCsup
    nb_sample = round(length(deltadeep_tmp)/4);

    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
    [~, idxMat] = sort(vmean);
    
    fake_deep = sort(deltadeep_tmp(idxMat(end-nb_sample+1:end)));%good
    good_deep = sort(deltadeep_tmp(idxMat(1:nb_sample)));%fake
    
    
    %% MUA response
    
    %all sup
    [m,~,tps] = mETAverage(deltadeep_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.all{p}(:,1) = tps; muadelta_res.met_mua.all{p}(:,2) = m;
    %good delta sup
    [m,~,tps] = mETAverage(good_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.good{p}(:,1) = tps; muadelta_res.met_mua.good{p}(:,2) = m;
    %fake delta sup
    [m,~,tps] = mETAverage(fake_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    muadelta_res.met_mua.fake{p}(:,1) = tps; muadelta_res.met_mua.fake{p}(:,2) = m;
    
    
    %% number of down linked to deltas
    
    %all deep
    intv = [deltadeep_tmp-1500 deltadeep_tmp];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.all.nb_down{p} = length(intervals);
    muadelta_res.all.nb{p} = length(deltadeep_tmp);
    
    %good deep
    intv = [good_deep-1500 good_deep];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.good.nb_down{p} = length(intervals);
    muadelta_res.good.nb{p} = length(good_deep);
    
    %fake deep
    intv = [fake_deep-1500 fake_deep];
    [~,intervals,~] = InIntervals(st_down, intv);
    intervals(intervals==0)=[];
    intervals = unique(intervals);
    muadelta_res.fake.nb_down{p} = length(intervals);
    muadelta_res.fake.nb{p} = length(fake_deep);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save MeanCurvesMUAFakeDeltaDeep.mat muadelta_res


