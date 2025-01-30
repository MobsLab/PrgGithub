%%FigureExampleFakeSlowWaveRipple1
% 23.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    RipplesDownBimodalPlot 





%% load

% load

Dir = PathForExperimentsFakeSlowWave;
Dir = RestrictPathForExperiment(Dir,'nMice',[243 490 507 508 509]);
effect_periods_down = GetEffectPeriodDownRipples(Dir);
effect_periods_delta = GetEffectPeriodUpDeltaRipples(Dir);

for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p effect_periods_down effect_periods_delta
    
    %params
    binsize_mua = 10;
    minDurationUp = 0.5e4; %500ms
    maxDurationUp = 30e4;
    
    binsize_met = 10;
    nbBins_met  = 200;
    
    binsize_cc = 20; %10ms
    nb_binscc = 100;
    
    t_before = -1E4; %in 1E-4s
    t_after = 1E4; %in 1E-4s
    
    hstep = 10;
    max_edge = 500;
    edges = 0:hstep:max_edge;
    
    range_inducedown = effect_periods_down(p,:);
    range_inducedelta = [0 2500];
    
    
    
    %% load
    
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

    %Ripples
    [tRipples, ~] = GetRipples;
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    center_down = (Start(down_PFCx)+End(down_PFCx))/2;
    end_down = End(down_PFCx);
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
    
    %LFP HPC
    load('ChannelsToAnalyse/dHPC_rip.mat')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    HPC = LFP;
    clear LFP
    
    
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
    
    
    %% Create sham tmp 
    
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    up_PFCx = dropShortIntervals(up_PFCx, minDurationUp);
    up_PFCx = dropLongIntervals(up_PFCx, maxDurationUp);
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    nb_sham = length(st_up)-200;
    idx = randsample(length(st_up), nb_sham);
    sham_tmp = [];

    for i=1:length(idx)
        min_tmp = st_up(idx(i));
        duree = end_up(idx(i))-st_up(idx(i));
        sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
    end    
    ShamEvent = ts(sort(sham_tmp));
    
    
    %% Delay between ripples and next delta waves

    %Random timestamps      
    rdm_tmp = Range(Restrict(Restrict(ShamEvent, up_PFCx),NREM));
    nb_rdm = length(rdm_tmp);
    delay_rdm = nan(nb_rdm, 1);
    for i=1:nb_rdm
        idx_down_after = find(st_down > rdm_tmp(i), 1);
        if ~isempty(idx_down_after)
            delay_rdm(i) = st_down(idx_down_after) - rdm_tmp(i);   
        end
    end
        
    %Ripples  
    RipplesUpNREM = Restrict(Restrict(tRipples, up_PFCx),NREM);
    ripples_tmp = Range(RipplesUpNREM);
    nb_ripples = length(ripples_tmp);
    delay_ripples = nan(nb_ripples, 1);
    for i=1:nb_ripples
        idx_down_after = find(st_down > ripples_tmp(i), 1);
        if ~isempty(idx_down_after)
            delay_ripples(i) = st_down(idx_down_after) - ripples_tmp(i);   
        end
    end
    
    
    %histograms
    delay_rdm = delay_rdm/10;
    delay_rdm(delay_rdm>max_edge)=[];
    [rdmsham.histo.y, rdmsham.histo.x] = histcounts(delay_rdm, edges, 'Normalization','probability');
    rdmsham.histo.x = rdmsham.histo.x(1:end-1) + diff(rdmsham.histo.x)/2;
    
    delay_ripples = delay_ripples/10;
    delay_ripples(delay_ripples>max_edge)=[];
    [ripples.histo.y, ripples.histo.x] = histcounts(delay_ripples, edges, 'Normalization','probability');
    ripples.histo.x = ripples.histo.x(1:end-1) + diff(ripples.histo.x)/2;
    
    [rdmsham.plot.x, rdmsham.plot.y] = stairs(rdmsham.histo.x, rdmsham.histo.y);
    [ripples.plot.x, ripples.plot.y] = stairs(ripples.histo.x, ripples.histo.y);
    
    
    %% Ripples success and failed...
    %Ripples INDUCED a Down ?
    intv_success = [Range(RipplesUpNREM)+range_inducedown(1) Range(RipplesUpNREM)+range_inducedown(2)];
    [~,intervals,~] = InIntervals(st_down, intv_success);
    intervals(intervals==0)=[];
    idx_success = unique(intervals);
    idx_nodown  = setdiff(1:length(RipplesUpNREM),idx_success)'; 
    
    %Ripples followed by a fake delta 
    ripples_nodown = Range(RipplesUpNREM);
    ripples_nodown = ripples_nodown(idx_nodown);
    intv_fake = [ripples_nodown+range_inducedelta(1) ripples_nodown+range_inducedelta(2)]; 
    [~,intervals,~] = InIntervals(fake_deep, intv_fake);
    intervals(intervals==0)=[];
    idx_fake = unique(intervals);
    idx_nofake  = setdiff(1:length(ripples_nodown),idx_fake)';
    
    
    % Quantification of fake delta waves
    ratio_success = length(idx_success)/length(RipplesUpNREM);
    ratio_fake = length(idx_fake)/length(ripples_nodown);
    
    
    %% Raster
    raster_muarip = RasterMatrixKJ(MUA, RipplesUpNREM, t_before, t_after);
    x_mat = Range(raster_muarip)/10;
    Matrip = Data(raster_muarip);
    
    %sort
    mat1 = Matrip(:,idx_nodown);
    mat2 = Matrip(:,idx_success);
    MatMUA = [mat2' ; mat1'];
    
    
    %% meancurves on ripples
    
    %MUA
    [m,~,tps] = mETAverage(Range(tRipples), Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_rip.mua(:,1) = tps; met_rip.mua(:,2) = m;
    %HPC
    [m,~,tps] = mETAverage(Range(tRipples), Range(HPC), Data(HPC), binsize_met, nbBins_met);
    met_rip.hpc(:,1) = tps; met_rip.hpc(:,2) = m;
    %PFC on ripples
    for ch=1:length(PFC)
        [m,~,tps] = mETAverage(Range(tRipples), Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_rip.pfc{ch}(:,1) = tps; met_rip.pfc{ch}(:,2) = m;
    end
    
    %ripples followed by down states
    ripples_down = Range(RipplesUpNREM);
    ripples_down = ripples_down(idx_success);
    for ch=1:length(PFC)
        [m,~,tps] = mETAverage(ripples_down, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_rip.pfcdown{ch}(:,1) = tps; met_rip.pfcdown{ch}(:,2) = m;
    end
    
    %ripples not followed by down
    ripples_fake = ripples_nodown(idx_fake);
    ripples_nofake = ripples_nodown(idx_nofake);
    
    for ch=1:length(PFC)
        [m,~,tps] = mETAverage(ripples_fake, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_rip.pfcfake{ch}(:,1) = tps; met_rip.pfcfake{ch}(:,2) = m;
        
        [m,~,tps] = mETAverage(ripples_nofake, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_rip.pfcnofake{ch}(:,1) = tps; met_rip.pfcnofake{ch}(:,2) = m;
    end
    
    
    %% Cross-correlogram
    
    %all deep
    [crosscorr.deep.all(:,2), crosscorr.deep.all(:,1)]   = CrossCorr(Range(RipplesUpNREM), deltadeep_tmp, binsize_cc, nb_binscc);
    %good delta deep
    [crosscorr.deep.good(:,2), crosscorr.deep.good(:,1)] = CrossCorr(Range(RipplesUpNREM), good_deep, binsize_cc, nb_binscc);
    %good delta deep
    [crosscorr.deep.fake(:,2), crosscorr.deep.fake(:,1)] = CrossCorr(Range(RipplesUpNREM), fake_deep, binsize_cc, nb_binscc);
    
    %all sup
    [crosscorr.sup.all(:,2), crosscorr.sup.all(:,1)]   = CrossCorr(Range(RipplesUpNREM), deltasup_tmp, binsize_cc, nb_binscc);
    %good delta sup
    [crosscorr.sup.good(:,2), crosscorr.sup.good(:,1)] = CrossCorr(Range(RipplesUpNREM), good_sup, binsize_cc, nb_binscc);
    %good delta sup
    [crosscorr.sup.fake(:,2), crosscorr.sup.fake(:,1)] = CrossCorr(Range(RipplesUpNREM), fake_sup, binsize_cc, nb_binscc);
    
    
    %with down
    [crosscorr.down(:,2), crosscorr.down(:,1)] = CrossCorr(Range(RipplesUpNREM), st_down, binsize_cc, nb_binscc);
    
    
    %% Plot
    
    smoothing = 1;
    color_pfc = 'k';
    color_hpc = [0 0.7 0];    
    
    color_all = [0.3 0.3 0.3];
    color_down = 'k';
    color_good = 'b';
    color_fake = 'r';
    
    figure, hold on
    
    % mean LFP and mean MUA on ripples
    clear h lgdc
    subplot(3,2,1), hold on
    hold on, h(1) = plot(met_rip.hpc(:,1), met_rip.hpc(:,2), 'color', color_hpc, 'linewidth', 2); % HPC
    lgdc{1} = 'Hpc';
    for ch=1:length(met_rip.pfc)
        hold on, h(2) = plot(met_rip.pfc{ch}(:,1), met_rip.pfc{ch}(:,2), 'color', color_pfc);
        lgdc{2} = 'PFCx';
    end
    
    xlim([-400 700]), ylim([-800 1300]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    xlabel('time from SPW-ripples (ms)'), ylabel('Mean LFP amplitude')    
    legend(h, lgdc);
    title('mean LFP response on all ripples') 
    
    % delay distribution between ripples and down states
    clear h
    subplot(3,2,3), hold on
    h(1) = plot(ripples.histo.x, ripples.histo.y, 'color','k', 'LineWidth',2); hold on,
    h(2) = plot(rdmsham.histo.x, rdmsham.histo.y, 'color',[0.5 0.5 0.5], 'LineWidth',2); hold on,

    xlabel('time from ripples/random times(ms)'), ylabel('density of down states')
    set(gca,'XTick',0:100:max_edge,'XLim',[0 max_edge]), hold on,
    legend(h,'Ripples in Up', 'Random times in Up')
    
    % MUA raster sorted with mean LFP for each group
    subplot(4,2,[4 6]), hold on
    
    imagesc(x_mat, 1:size(MatMUA,1), MatMUA), hold on
    axis xy, ylabel('# SPW-ripples'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    
    yyaxis left
    set(gca,'YLim', [0 size(MatMUA,1)], 'xlim', [-400 700]);
    % caxis([-2000 2000]),
    % hb = colorbar('location','eastoutside'); hold on
    title('MUA (PFCx)'),
    
    % Mean curves when no down
    clear h lgd
    subplot(4,2,2), hold on
    for ch=1:length(met_rip.pfc)
        hold on, h(1) = plot(met_rip.pfcfake{ch}(:,1), met_rip.pfcfake{ch}(:,2), 'color', color_fake);
    end
    for ch=1:length(met_rip.pfc)
        hold on, h(2) = plot(met_rip.pfcnofake{ch}(:,1), met_rip.pfcnofake{ch}(:,2), 'color', [0.3 0.3 0.3]);
    end
    xlim([-400 700]), ylim([-1500 2200]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    legend(h,['ripples followed by false delta (' num2str(round(ratio_fake*100,2)) '%)'], 'ripples alone'), ylabel('mean LFP amplitude')    
    
    % Mean curves when down
    clear h lgd
    subplot(4,2,8), hold on
    for ch=1:length(met_rip.pfc)
        hold on, h(1) = plot(met_rip.pfcdown{ch}(:,1), met_rip.pfcdown{ch}(:,2), 'color', color_good);
    end
    xlim([-400 700]), ylim([-1500 2200]),
    line([0 0],get(gca,'ylim'),'linewidth',1,'color',[0.6 0.6 0.6]),
    ylabel('mean LFP amplitude'), xlabel('time from ripples peak (ms)'), 
    legend(h, ['ripples followed by down states (' num2str(round(ratio_success*100,2)) '%)'])
    
    % Cross-corr for each group of delta (good vs fake) and down states
    subplot(3,2,5), hold on
    clear h lgd
    hold on, h(1)=plot(crosscorr.down(:,1), Smooth(crosscorr.down(:,2),smoothing), 'color',color_down, 'linewidth',2);
    hold on, h(2)=plot(crosscorr.deep.all(:,1), Smooth(crosscorr.deep.all(:,2),smoothing), 'color',color_all, 'linewidth',2);
    hold on, h(3)=plot(crosscorr.deep.good(:,1), Smooth(crosscorr.deep.good(:,2)*3,smoothing), 'color',color_good, 'linewidth',2);
    hold on, h(4)=plot(crosscorr.deep.fake(:,1), Smooth(crosscorr.deep.fake(:,2)*3,smoothing), 'color',color_fake, 'linewidth',2);
    lgd = {'down states', 'all delta', 'good delta', 'false delta'};
    xlim([-500 500]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,lgd, 'Location','southeast'),
    xlabel('time from ripples (ms)'), ylabel('down/deltas frequency')
    
    %save figure
    filename_fig = ['FigureExampleFakeSlowWaveRippleDeep_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    folderfig = fullfile(FolderFigureDelta,'LabMeeting','20190826','FigureExampleFakeSlowWaveRippleDeep');
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
    
    
    
    
    
    
    
end







