%%ParcoursHomeostasisSleepCycle
% 02.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%    FakeSlowWaveOneNight1 FakeSlowWaveOneNightHomeostasis
%    ParcoursHomeostasisSleepCyclePlot



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
    limREM=60;
    deltadensityfactor=60;
        
    %raster
    load('RasterLFPDeltaWaves.mat','deltadeep', 'ch_deep', 'deltadeep_tmp')
    deltadeep_tmp = Range(deltadeep_tmp);
%     load('RasterLFPDeltaWaves.mat','deltasup', 'ch_sup','deltasup_tmp') 
%     deltasup_tmp = Range(deltasup_tmp);

    %hemisphere
    if strcmpi(Dir.name{p},'Mouse508')
        hsp='_r';
    elseif strcmpi(Dir.name{p},'Mouse509')
        hsp='_l';
    else
        hsp='';
    end

    %NREM
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;
        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = ts(Start(down_PFCx));
    %delta waves
    load('DeltaWaves.mat', 'deltas_PFCx')
    st_deltas = ts(Start(deltas_PFCx));
    %night duration and tsd zt
    load('behavResources.mat', 'NewtsdZT')
    load('IdFigureData2.mat', 'night_duration')
    
    
    %% Quantification good and fake

    %delta deep>PFCsup
    nb_sample = round(length(deltadeep_tmp)/4);

    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
    [~, idx1] = sort(vmean1);
    
    good_deep = ts(sort(deltadeep_tmp(idx1(1:nb_sample))));%good
    fake_deep = ts(sort(deltadeep_tmp(idx1(end-nb_sample+1:end))));%fake

    
%     %delta sup>PFCdeep
%     nb_sample = round(length(deltasup_tmp)/4);
% 
%     raster_tsd = deltasup.deep;
%     Mat = Data(raster_tsd)';
%     x_tmp = Range(raster_tsd);
%     vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
%     [~, idx2] = sort(vmean2);
%     
%     good_sup = ts(sort(deltasup_tmp(idx2(end-nb_sample+1:end))));%good
%     fake_sup = ts(sort(deltasup_tmp(idx2(1:nb_sample))));%fake
    
    
    %% Sleep Cycle
    
    
    SleepStages=CreateSleepStages_tsd({NREM,REM,Wake},'y_value',[1 3 4]);
    
    [REM,WakeC,idbad] = CleanREMEpoch(SleepStages,REM,Wake);
    REMm = mergeCloseIntervals(REM,limREM*1E4);
    Wake  = Wake-REMm; 
    NREM  = NREM-REMm;
    end_rem = End(REMm);
    SleepCycle = intervalSet(end_rem(1:end-1),end_rem(2:end));
    firstSleepCycle = intervalSet(0, end_rem(1));
    SleepCycle = CleanUpEpoch(or(firstSleepCycle,SleepCycle));
    st_cycle = Start(SleepCycle);
    
    for i=1:length(Start(SleepCycle))        
        clear dur_cycle
        dur_cycle = End(and(Wake,subset(SleepCycle,i)),'s')-Start(and(Wake,subset(SleepCycle,i)),'s');
        if ~isempty(dur_cycle)
            for j=1:length(dur_cycle)
                if dur_cycle(j)>10
                    try
                        if dur_cycle(j)>dur_cycle(j-1)
                            st_cycle(i) = End(subset(and(Wake,subset(SleepCycle,i)),j));%st_cycle(i), disp('check 1')
                        end
                    catch
                        st_cycle(i) = End(subset(and(Wake,subset(SleepCycle,i)),j));%st_cycle(i), disp('check 2')
                    end
                end
            end
        end
    end

    SleepCycleOK=intervalSet(st_cycle, End(SleepCycle));
    SleepStagesC=CreateSleepStages_tsd({NREM,REMm,Wake},'y_value',[1 3 4]);
    
    %save
    homeo_res.night_duration{p} = night_duration;
    homeo_res.sleepcycle{p}  = SleepCycleOK;
    homeo_res.sleepstages{p} = SleepStagesC;
    
    
    %% Down density and regression
    
    %density
    windowsize = deltadensityfactor*1E4; %60s
    [x_density, y_density] = DensityCurves_KJ(st_down, 'windowsize',windowsize,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
        
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks),idx_peaks);
    idx_peaks1  = Data(Restrict(tmp_peaks,NREM)); %only extrema in NREM
    idx_peaks2 = Data(Restrict(tmp_peaks,SleepCycleOK));

    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);

    idx2 = y_density(idx_peaks2) > max(y_density(idx_peaks1))/3;
    idx_peaks2 = idx_peaks2(idx2);

    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);

    %save
    homeo_res.down.density.x{p} = x_intervals;
    homeo_res.down.density.y{p} = y_density;
    
    homeo_res.down.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
    homeo_res.down.nrem.peaks.y{p} =  y_density(idx_peaks1);
    homeo_res.down.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
    homeo_res.down.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
    
    homeo_res.down.nrem.p_reg{p} = p1;
    homeo_res.down.nrem.reg{p}   = reg1;
    homeo_res.down.sleepcycle.p_reg{p} = p2;
    homeo_res.down.sleepcycle.reg{p}   = reg2;
    
    
    %% Deltas diff density and regression
    
    %density
    windowsize = deltadensityfactor*1E4; %60s
    [x_density, y_density] = DensityCurves_KJ(st_deltas, 'windowsize',windowsize,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
        
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks),idx_peaks);
    idx_peaks1  = Data(Restrict(tmp_peaks,NREM)); %only extrema in NREM
    idx_peaks2 = Data(Restrict(tmp_peaks,SleepCycleOK));

    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);

    idx2 = y_density(idx_peaks2) > max(y_density(idx_peaks1))/3;
    idx_peaks2 = idx_peaks2(idx2);

    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);

    %save
    homeo_res.delta.density.x{p} = x_intervals;
    homeo_res.delta.density.y{p} = y_density;
    
    homeo_res.delta.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
    homeo_res.delta.nrem.peaks.y{p} =  y_density(idx_peaks1);
    homeo_res.delta.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
    homeo_res.delta.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
    
    homeo_res.delta.nrem.p_reg{p} = p1;
    homeo_res.delta.nrem.reg{p}   = reg1;
    homeo_res.delta.sleepcycle.p_reg{p} = p2;
    homeo_res.delta.sleepcycle.reg{p}   = reg2;
    
    
    %% All deep density and regression
    
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(ts(deltadeep_tmp), 'windowsize',windowsize,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
        
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks),idx_peaks);
    idx_peaks1  = Data(Restrict(tmp_peaks,NREM)); %only extrema in NREM
    idx_peaks2 = Data(Restrict(tmp_peaks,SleepCycleOK));

    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);

    idx2 = y_density(idx_peaks2) > max(y_density(idx_peaks1))/3;
    idx_peaks2 = idx_peaks2(idx2);

    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);

    %save
    homeo_res.deep.density.x{p} = x_intervals;
    homeo_res.deep.density.y{p} = y_density;
    
    homeo_res.deep.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
    homeo_res.deep.nrem.peaks.y{p} =  y_density(idx_peaks1);
    homeo_res.deep.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
    homeo_res.deep.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
    
    homeo_res.deep.nrem.p_reg{p} = p1;
    homeo_res.deep.nrem.reg{p}   = reg1;
    homeo_res.deep.sleepcycle.p_reg{p} = p2;
    homeo_res.deep.sleepcycle.reg{p}   = reg2;
    

    %% Good deltas density and regression
    
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(good_deep, 'windowsize',windowsize,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
        
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks),idx_peaks);
    idx_peaks1  = Data(Restrict(tmp_peaks,NREM)); %only extrema in NREM
    idx_peaks2 = Data(Restrict(tmp_peaks,SleepCycleOK));

    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);

    idx2 = y_density(idx_peaks2) > max(y_density(idx_peaks1))/3;
    idx_peaks2 = idx_peaks2(idx2);

    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    
    %corrected regression
    [p1C,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1)*4, 1);
    reg1C = polyval(p1C,x_intervals);

    [p2C,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2)*4, 1);
    reg2C = polyval(p2C,x_intervals);

    %save
    homeo_res.good.density.x{p} = x_intervals;
    homeo_res.good.density.y{p} = y_density;
    
    homeo_res.good.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
    homeo_res.good.nrem.peaks.y{p} =  y_density(idx_peaks1);
    homeo_res.good.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
    homeo_res.good.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
    
    homeo_res.good.nrem.p_reg{p} = p1;
    homeo_res.good.nrem.reg{p}   = reg1;
    homeo_res.good.sleepcycle.p_reg{p} = p2;
    homeo_res.good.sleepcycle.reg{p}   = reg2;
    
    homeo_res.good.nrem.p_regC{p} = p1C;
    homeo_res.good.nrem.regC{p}   = reg1C;
    homeo_res.good.sleepcycle.p_regC{p} = p2C;
    homeo_res.good.sleepcycle.regC{p}   = reg2C;
    
    %% Fake deltas density and regression
    
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(fake_deep, 'windowsize',windowsize,'endtime', night_duration);
    x_intervals = x_density/3600E4 + min(Data(NewtsdZT))/3600e4;
        
    %peaks
    idx_peaks  = LocalMaxima(y_density);
    tmp_peaks  = tsd(x_density(idx_peaks),idx_peaks);
    idx_peaks1  = Data(Restrict(tmp_peaks,NREM)); %only extrema in NREM
    idx_peaks2 = Data(Restrict(tmp_peaks,SleepCycleOK));

    idx1 = y_density(idx_peaks1) > max(y_density(idx_peaks1))/3;
    idx_peaks1 = idx_peaks1(idx1);

    idx2 = y_density(idx_peaks2) > max(y_density(idx_peaks1))/3;
    idx_peaks2 = idx_peaks2(idx2);

    %regression
    [p1,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1), 1);
    reg1 = polyval(p1,x_intervals);

    [p2,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2), 1);
    reg2 = polyval(p2,x_intervals);
    
    %corrected regression
    [p1C,~] = polyfit(x_intervals(idx_peaks1), y_density(idx_peaks1)*4, 1);
    reg1C = polyval(p1C,x_intervals);

    [p2C,~] = polyfit(x_intervals(idx_peaks2), y_density(idx_peaks2)*4, 1);
    reg2C = polyval(p2C,x_intervals);

    %save
    homeo_res.fake.density.x{p} = x_intervals;
    homeo_res.fake.density.y{p} = y_density;
    
    homeo_res.fake.nrem.peaks.x{p} =  x_intervals(idx_peaks1);
    homeo_res.fake.nrem.peaks.y{p} =  y_density(idx_peaks1);
    homeo_res.fake.sleepcycle.peaks.x{p} =  x_intervals(idx_peaks2);
    homeo_res.fake.sleepcycle.peaks.y{p} =  y_density(idx_peaks2);
    
    homeo_res.fake.nrem.p_reg{p} = p1;
    homeo_res.fake.nrem.reg{p}   = reg1;
    homeo_res.fake.sleepcycle.p_reg{p} = p2;
    homeo_res.fake.sleepcycle.reg{p}   = reg2;
    
    homeo_res.fake.nrem.p_regC{p} = p1C;
    homeo_res.fake.nrem.regC{p}   = reg1C;
    homeo_res.fake.sleepcycle.p_regC{p} = p2C;
    homeo_res.fake.sleepcycle.regC{p}   = reg2C;
    
    
end


%saving data
cd(FolderDeltaDataKJ)
save ParcoursHomeostasisSleepCycle.mat homeo_res


