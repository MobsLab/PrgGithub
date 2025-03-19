%%OccurenceRipplesFakeDeltaSup
% 09.09.2019 KJ
%
% Infos
%   quantify occurence of ripples in relation to fake/real delta sup
%
% see
%     OccurenceRipplesFakeDeltaSupPlot
%    



Dir = PathForExperimentsFakeSlowWave('sup');


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
    load('RasterLFPDeltaWaves.mat','deltasup', 'ch_sup', 'deltasup_tmp') 

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

    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    up_PFCx = intervalSet(0,night_duration) - down_PFCx;
    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    %deltas channel
    deltasup_tmp = Range(deltasup_tmp);
    %Ripples  
    [tRipples, ~] = GetRipples;
    RipplesUpNREM = Restrict(Restrict(tRipples, up_PFCx),NREM);
    
%     %LFP PFCx
%     load(['LFPData/LFP' num2str(ch_sup) '.mat'])
%     PFCsup = LFP;
%     clear LFP
    
    
    %% Fake and real delta
    
    %delta sup>PFCdeep
    nb_sample = round(length(deltasup_tmp)/4);

    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
    if strcmpi(Dir.name{p},'Mouse451')
        vmean2 = mean(Mat(:,x_tmp>-0.2e4&x_tmp<0),2);
    end
    [~, idxMat2] = sort(vmean2);
    
    good_sup = sort(deltasup_tmp(idxMat2(end-nb_sample+1:end)));%good
    fake_sup = sort(deltasup_tmp(idxMat2(1:nb_sample)));%fake
    
    
    %% cross-corr with ripples
    
    %good delta sup
    [ripples_res.cc.deltas{p}(:,2), ripples_res.cc.deltas{p}(:,1)] = CrossCorr(Range(tRipples), st_deltas, binsize_cc, nb_binscc);
    %good delta sup
    [ripples_res.cc.good{p}(:,2), ripples_res.cc.good{p}(:,1)] = CrossCorr(Range(tRipples), good_sup, binsize_cc, nb_binscc);
    %fake delta sup
    [ripples_res.cc.fake{p}(:,2), ripples_res.cc.fake{p}(:,1)] = CrossCorr(Range(tRipples), fake_sup, binsize_cc, nb_binscc);
    %with down
    [ripples_res.cc.down{p}(:,2), ripples_res.cc.down{p}(:,1)] = CrossCorr(Range(tRipples), st_down, binsize_cc, nb_binscc);
    
    
    
    %% save
    ripples_res.nb.ripples{p} = length(Range(tRipples));
    ripples_res.nb.deltas{p}  = length(st_deltas);
    ripples_res.nb.good{p}    = length(good_sup);
    ripples_res.nb.fake{p}    = length(fake_sup);
    ripples_res.nb.down{p}    = length(st_down);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save OccurenceRipplesFakeDeltaSup.mat ripples_res

