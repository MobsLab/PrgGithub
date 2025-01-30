%%FigureExampleFakeSlowWaveSup
% 23.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FigureExampleFakeSlowWaveNeuron1 FigureExampleFakeSlowWaveDeep





%% load

% load

Dir = PathForExperimentsFakeSlowWave('sup');


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    deltadensityfactor=60;
    binsize_mua = 10;
    binsize_met = 10;
    nbBins_met  = 160;
    binsize_cc = 10; %10ms
    nb_binscc = 200;

    %raster
    load('RasterLFPDeltaWaves.mat','deltasup', 'ch_deep', 'ch_sup', 'deltasup_tmp') 

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
    center_down = (Start(down_PFCx)+End(down_PFCx))/2;
    up_PFCx = intervalSet(0,night_duration) - down_PFCx;
    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    center_deltas = (Start(deltas_PFCx)+End(deltas_PFCx))/2;
    %deltas channel
    deltasup_tmp = Range(deltasup_tmp);
    %Ripples  
    [tRipples, ~] = GetRipples;
    RipplesUpNREM = Restrict(Restrict(tRipples, up_PFCx),NREM);
    
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
    
    
    %% homeostasis 
    
    %Good sup
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(ts(good_sup), 'windowsize',windowsize,'endtime', night_duration);
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
    
    good.x_intervals = x_intervals;
    good.y_density = y_density;
    good.x_peaks = x_intervals(idx_peaks1);
    good.y_peaks = y_density(idx_peaks1);
    good.p1 = p1;
    good.reg1 = reg1;
    
    
    %Fake sup
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(ts(fake_sup), 'windowsize',windowsize,'endtime', night_duration);
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
    
    fake.x_intervals = x_intervals;
    fake.y_density = y_density;
    fake.x_peaks = x_intervals(idx_peaks1);
    fake.y_peaks = y_density(idx_peaks1);
    fake.p1 = p1;
    fake.reg1 = reg1;
    
    
    %% PFC response
    for ch=1:length(channels)
        %good delta sup
        [m,~,tps] = mETAverage(good_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.good{ch}(:,1) = tps; met_lfp.good{ch}(:,2) = m;
        %fake delta sup
        [m,~,tps] = mETAverage(fake_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.fake{ch}(:,1) = tps; met_lfp.fake{ch}(:,2) = m;
    end
    
    
    %% MUA response
    
    %all sup
    [m,~,tps] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.all(:,1) = tps; met_mua.all(:,2) = m;
    %good delta sup
    [m,~,tps] = mETAverage(good_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.good(:,1) = tps; met_mua.good(:,2) = m;
    %fake delta sup
    [m,~,tps] = mETAverage(fake_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.fake(:,1) = tps; met_mua.fake(:,2) = m;
    

    %% Cross-corr with down states
    
    %all sup
    [crosscorr.all(:,2), crosscorr.all(:,1)]   = CrossCorr(st_down, deltasup_tmp, binsize_cc, nb_binscc);
    %good delta sup
    [crosscorr.good(:,2), crosscorr.good(:,1)] = CrossCorr(st_down, good_sup, binsize_cc, nb_binscc);
    crosscorr.good(:,2) = crosscorr.good(:,2)*4; %normalize
    %good delta sup
    [crosscorr.fake(:,2), crosscorr.fake(:,1)] = CrossCorr(st_down, fake_sup, binsize_cc, nb_binscc);
    crosscorr.fake(:,2) = crosscorr.fake(:,2)*4; %normalize
    
    %% cross-corr between deltas 
    %sup
    [crosscorr.between(:,2), crosscorr.between(:,1)] = CrossCorr(good_sup, fake_sup, binsize_cc, nb_binscc);
    
    
    %% cross-corr with ripples
    
    %all sup
    [crosscorr.ripples.all(:,2), crosscorr.ripples.all(:,1)]   = CrossCorr(Range(RipplesUpNREM), deltasup_tmp, binsize_cc, nb_binscc);
    %good delta sup
    [crosscorr.ripples.good(:,2), crosscorr.ripples.good(:,1)] = CrossCorr(Range(RipplesUpNREM), sort([good_sup;good_sup;good_sup;good_sup]), binsize_cc, nb_binscc);
    %fake delta sup
    [crosscorr.ripples.fake(:,2), crosscorr.ripples.fake(:,1)] = CrossCorr(Range(RipplesUpNREM), sort([fake_sup;fake_sup;fake_sup;fake_sup]), binsize_cc, nb_binscc);
    %with down
    [crosscorr.ripples.down(:,2), crosscorr.ripples.down(:,1)] = CrossCorr(Range(RipplesUpNREM), st_down, binsize_cc, nb_binscc);
    
    
    %% PLOT deltas detected on  SUP
    
    color_all = [0.3 0.3 0.3];
    color_down = 'k';
    color_good = 'b';
    color_fake = 'r';
    
    figure, hold on

    
    %deltas sup - pfc deep
    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    y_meancurves = mean(Mat);
    %sort
    Mat = Mat(idxMat2,:);

    subplot(4,3,[1 4 7]), hold on
    imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
    axis xy, ylabel('# deltas detected on sup'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on
    set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
    caxis([-2000 2000]),
    hb = colorbar('location','eastoutside'); hold on
    xlabel('time from delta waves detected on sup (ms)'), title('LFP deep layer on delta sup')
    
    
    %Deltas on sup - good sup
    subplot(8,3,[2 5 8]), hold on
    for ch=1:length(channels)
        if ismember(channels(ch),[ch_deep ch_sup])
            linewidt = 2;
        else
            linewidt = 1;
        end
        hold on, plot(met_lfp.good{ch}(:,1), met_lfp.good{ch}(:,2), 'color',color_good, 'linewidth',linewidt)
    end
    xlim([-400 600]), ylim([-1500 2100]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    ylabel('mean LFP amplitude'), set(gca,'xtick',[]),
    title('LFP response for each channel (good delta)')
    %Deltas on sup - fake sup
    subplot(8,3,[11 14 17]), hold on
    for ch=1:length(channels)
        if ismember(channels(ch),[ch_deep ch_sup])
            linewidt = 2;
        else
            linewidt = 1;
        end
        hold on, plot(met_lfp.fake{ch}(:,1), met_lfp.fake{ch}(:,2), 'color',color_fake, 'linewidth',linewidt)
    end
    xlim([-400 600]), ylim([-1500 2100]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    ylabel('mean LFP amplitude'), 
    title('LFP response for each channel (false delta)')
    
    
    %MUA sup
    clear h
    subplot(4,3,3), hold on
    hold on, h(1)=plot(met_mua.all(:,1), met_mua.all(:,2), 'color',color_all, 'linewidth',2);
    hold on, h(2)=plot(met_mua.good(:,1), met_mua.good(:,2), 'color',color_good, 'linewidth',2);
    hold on, h(3)=plot(met_mua.fake(:,1), met_mua.fake(:,2), 'color',color_fake, 'linewidth',2);
    lgd = {'all deltas', 'good deltas', 'fake deltas'};
    ylimax = get(gca,'ylim');
    xlim([-400 600]), ylim([0 ylimax(2)]),
    line([0 0], [0 ylimax(2)],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,lgd, 'Location','southeast'),
    xlabel('time from delta waves (ms)'), ylabel('mean MUA amplitude')
    title([Dir.name{p} ' - ' Dir.date{p}]),
    
    
    %Cross-corr with down
    clear h
    subplot(4,3,6), hold on
    hold on, h(1)=plot(crosscorr.all(:,1), crosscorr.all(:,2), 'color',color_all, 'linewidth',2);
    hold on, h(2)=plot(crosscorr.good(:,1), crosscorr.good(:,2), 'color',color_good, 'linewidth',2);
    hold on, h(3)=plot(crosscorr.fake(:,1), crosscorr.fake(:,2), 'color',color_fake, 'linewidth',2);
    xlim([-400 600]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    xlabel('time from down state (ms)'), ylabel('deltas frequency')
    
    %Cross-corr between good and fake
    subplot(4,3,9), hold on
    hold on, h(1)=plot(crosscorr.between(:,1), crosscorr.between(:,2), 'color','r', 'linewidth',2);
    xlim([-1000 1000]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,'fake'),
    xlabel('time from good delta waves (ms)'), ylabel('fake deltas frequency')
    
    %homeostasis Good slow-waves
    subplot(4,3,10), hold on
    hold on, plot(good.x_intervals, good.reg1,'k.')
    hold on, scatter(good.x_peaks , good.y_peaks,'r')
    xlabel('h'), ylabel('delta per minute'),
    title(['Good delta homeostasis (p=' num2str(good.p1) ')'])
    
    %homeostasis Fake slow-waves
    subplot(4,3,11), hold on
    hold on, plot(fake.x_intervals, fake.reg1,'k.')
    hold on, scatter(fake.x_peaks , fake.y_peaks,'r')
    xlabel('h'), ylabel('delta per minute'),
    title(['Fake delta homeostasis (p=' num2str(fake.p1) ')'])
    
    %Correlogram with ripples
    smoothing = 1;
    subplot(4,3,12), hold on
    clear h lgd
    hold on, h(1)=plot(crosscorr.ripples.down(:,1), Smooth(crosscorr.ripples.down(:,2),smoothing), 'color',color_down, 'linewidth',2);
    hold on, h(2)=plot(crosscorr.ripples.good(:,1), Smooth(crosscorr.ripples.good(:,2),smoothing), 'color',color_good, 'linewidth',2);
    hold on, h(3)=plot(crosscorr.ripples.fake(:,1), Smooth(crosscorr.ripples.fake(:,2),smoothing), 'color',color_fake, 'linewidth',2);
    lgd = {'down', 'good', 'false'};
    xlim([-500 500]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,lgd, 'Location','northwest'),
    xlabel('time from ripples (ms)'), ylabel('down/deltas frequency')
    
    
    %save figure
    filename_fig = ['FigureExampleFakeSlowWaveNeuronSup_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    folderfig = fullfile(FolderFigureDelta,'LabMeeting','20190826','FigureExampleFakeSlowWaveNeuronSup');
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
    
end







