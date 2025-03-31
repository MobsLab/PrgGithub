%%OccurenceRipplesFakeDeltaDeep_bis
% 09.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaSup OccurenceRipplesFakeDeltaDeep
%    



Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p ripples_res
    
    ripples_res.path{p}   = Dir.path{p};
    ripples_res.manipe{p} = Dir.manipe{p};
    ripples_res.name{p}   = Dir.name{p};
    ripples_res.date{p}   = Dir.date{p};
    
    %params
    binsize_mua = 10;
    binsize_cc = 10; %10ms
    nb_binscc = 200;
    
    %night duration
    load('IdFigureData2.mat', 'night_duration')
    
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
    
    
    %NREM
    [NREM, ~, ~, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;

    %MUA
    MUA = GetMuaNeurons_KJ(['PFCx' hsp], 'binsize',binsize_mua); 
        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    up_PFCx = intervalSet(0,night_duration) - down_PFCx;
    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    %deltas channel
    deltadeep_tmp = Range(deltadeep_tmp);
    %Ripples  
    [tRipples, ~] = GetRipples;
    RipplesUpNREM = Restrict(Restrict(tRipples, up_PFCx),NREM);
    
    
    
%     %LFP PFCx
%     load(['LFPData/LFP' num2str(ch_deep) '.mat'])
%     PFCdeep = LFP;
%     clear LFP
    
    
    %% Fake and real delta
    
    %delta sup>PFCdeep
    nb_sample = round(length(deltadeep_tmp)/4);

    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
    if strcmpi(Dir.name{p},'Mouse451')
        vmean = mean(Mat(:,x_tmp>-0.2e4&x_tmp<0),2);
    end
    [~, idxMat] = sort(vmean);
     
    fake_deep = sort(deltadeep_tmp(idxMat(end-nb_sample+1:end)));%fake
    good_deep = sort(deltadeep_tmp(idxMat(1:nb_sample)));%good
    
    
    %% cross-corr with ripples
    
    %good delta deep
    [ripples_res.cc.deltas{p}(:,2), ripples_res.cc.deltas{p}(:,1)] = CrossCorr(Range(RipplesUpNREM), st_deltas, binsize_cc, nb_binscc);
    %good delta deep
    [ripples_res.cc.good{p}(:,2), ripples_res.cc.good{p}(:,1)] = CrossCorr(Range(RipplesUpNREM), good_deep, binsize_cc, nb_binscc);
    %fake delta deep
    [ripples_res.cc.fake{p}(:,2), ripples_res.cc.fake{p}(:,1)] = CrossCorr(Range(RipplesUpNREM), fake_deep, binsize_cc, nb_binscc);
    %with down
    [ripples_res.cc.down{p}(:,2), ripples_res.cc.down{p}(:,1)] = CrossCorr(Range(RipplesUpNREM), st_down, binsize_cc, nb_binscc);
    
    
    
    %% save
    ripples_res.nb.ripples{p} = length(Range(RipplesUpNREM));
    ripples_res.nb.deltas{p}  = length(st_deltas);
    ripples_res.nb.good{p}    = length(good_deep);
    ripples_res.nb.fake{p}    = length(fake_deep);
    ripples_res.nb.down{p}    = length(st_down);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesFakeDeltaDeep.mat ripples_res

