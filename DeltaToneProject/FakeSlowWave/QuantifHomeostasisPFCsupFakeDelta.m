%%QuantifHomeostasisPFCsupFakeDelta
% 05.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    ParcoursHomeostasisSleepCycle 
%    



Dir = PathForExperimentsFakeSlowWave('sup');


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
    windowsize_density = 60e4; %60s  

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
    
    
    %% Homeostasis down
    [x_density, y_density, Hstat] = DensityOccupation_KJ(down_PFCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.down.global.x_intervals{p} = Hstat.x_intervals;
    homeo_res.down.global.y_density{p}   = Hstat.y_density;
    homeo_res.down.global.x_peaks{p}  = Hstat.x_peaks;
    homeo_res.down.global.y_peaks{p}  = Hstat.y_peaks;
    homeo_res.down.global.p0{p}   = Hstat.p0;
    homeo_res.down.global.reg0{p} = Hstat.reg0;
    homeo_res.down.global.p1{p}   = Hstat.p1;
    homeo_res.down.global.reg1{p} = Hstat.reg1; 
    homeo_res.down.global.p2{p}   = Hstat.p2;
    homeo_res.down.global.reg2{p} = Hstat.reg2; 
    homeo_res.down.global.exp_a{p} = Hstat.exp_a; 
    homeo_res.down.global.exp_b{p} = Hstat.exp_b; 
    %correlation
    homeo_res.down.global.pv0{p}    = Hstat.pv0;
    homeo_res.down.global.R2_0{p}   = Hstat.R2_0;
    homeo_res.down.global.pv1{p}    = Hstat.pv1;
    homeo_res.down.global.R2_1{p}   = Hstat.R2_1;
    homeo_res.down.global.pv2{p}    = Hstat.pv2;
    homeo_res.down.global.R2_2{p}   = Hstat.R2_2;
    homeo_res.down.global.exp_R2{p} = Hstat.exp_R2; 
    
    
    %% Homeostasis down
    [x_density, y_density, Hstat] = DensityOccupation_KJ(down_PFCx, 'homeostat',4, 'windowsize',windowsize_density,'endtime', night_duration,'newtsdzt',NewtsdZT,'epoch',NREM);
    homeo_res.down.global.x_intervals{p} = Hstat.x_intervals;
    homeo_res.down.global.y_density{p}   = Hstat.y_density;
    homeo_res.down.global.x_peaks{p}  = Hstat.x_peaks;
    homeo_res.down.global.y_peaks{p}  = Hstat.y_peaks;
    homeo_res.down.global.p0{p}   = Hstat.p0;
    homeo_res.down.global.reg0{p} = Hstat.reg0;
    homeo_res.down.global.p1{p}   = Hstat.p1;
    homeo_res.down.global.reg1{p} = Hstat.reg1; 
    homeo_res.down.global.p2{p}   = Hstat.p2;
    homeo_res.down.global.reg2{p} = Hstat.reg2; 
    homeo_res.down.global.exp_a{p} = Hstat.exp_a; 
    homeo_res.down.global.exp_b{p} = Hstat.exp_b; 
    %correlation
    homeo_res.down.global.pv0{p}    = Hstat.pv0;
    homeo_res.down.global.R2_0{p}   = Hstat.R2_0;
    homeo_res.down.global.pv1{p}    = Hstat.pv1;
    homeo_res.down.global.R2_1{p}   = Hstat.R2_1;
    homeo_res.down.global.pv2{p}    = Hstat.pv2;
    homeo_res.down.global.R2_2{p}   = Hstat.R2_2;
    homeo_res.down.global.exp_R2{p} = Hstat.exp_R2; 
    
    
    
    %% homeostasis down states
    %density
    [x_density, y_density] = DensityCurves_KJ(ts(st_down), 'windowsize',windowsize_density,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks), idx_peaks);
    idx_peaks1 = Data(Restrict(tmp_peaks, NREM)); %only extrema in NREM
    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);
    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);
    
    homeo_res.down.x_intervals{p} = x_intervals;
    homeo_res.down.y_density{p}   = y_density;
    homeo_res.down.x_peaks{p}  = x_intervals(idx_peaks1);
    homeo_res.down.y_peaks{p}  = y_density(idx_peaks1);
    homeo_res.down.p1{p}   = p1;
    homeo_res.down.reg1{p} = reg1;
    homeo_res.nb_down{p} = length(st_down);
    
    
    %% homeostasis Good sup
    %density
    [x_density, y_density] = DensityCurves_KJ(ts(good_sup), 'windowsize',windowsize_density,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks), idx_peaks);
    idx_peaks1 = Data(Restrict(tmp_peaks, NREM)); %only extrema in NREM
    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);
    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);
    
    homeo_res.good.x_intervals{p} = x_intervals;
    homeo_res.good.y_density{p}   = y_density;
    homeo_res.good.x_peaks{p}  = x_intervals(idx_peaks1);
    homeo_res.good.y_peaks{p}  = y_density(idx_peaks1);
    homeo_res.good.p1{p}   = p1;
    homeo_res.good.reg1{p} = reg1;
    homeo_res.nb_good{p} = length(good_sup);
    
    
    %% homeostasis Fake sup
    %density
    [x_density, y_density] = DensityCurves_KJ(ts(fake_sup), 'windowsize',windowsize_density,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks), idx_peaks);
    idx_peaks1 = Data(Restrict(tmp_peaks, NREM)); %only extrema in NREM
    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);
    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);
    
    homeo_res.fake.x_intervals{p} = x_intervals;
    homeo_res.fake.y_density{p}   = y_density;
    homeo_res.fake.x_peaks{p}  = x_intervals(idx_peaks1);
    homeo_res.fake.y_peaks{p}  = y_density(idx_peaks1);
    homeo_res.fake.p1{p}   = p1;
    homeo_res.fake.reg1{p} = reg1;
    homeo_res.nb_fake{p} = length(fake_sup);
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save QuantifHomeostasisPFCsupFakeDelta.mat homeo_res


