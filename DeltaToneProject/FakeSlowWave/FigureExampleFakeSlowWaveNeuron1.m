%%FigureExampleFakeSlowWaveNeuron1
% 23.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 





%% load

% load

Dir = PathForExperimentsFakeSlowWave;


for p=9:12%1:length(Dir.path)
    
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
    load('RasterLFPDeltaWaves.mat','deltadeep', 'deltasup', 'ch_deep', 'ch_sup', 'deltadeep_tmp', 'deltasup_tmp') 

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
    %delta waves
    deltas_PFCx = GetDeltaWaves('area',['PFCx' hsp]);
    st_deltas = Start(deltas_PFCx);
    center_deltas = (Start(deltas_PFCx)+End(deltas_PFCx))/2;
    %deltas channel
    deltadeep_tmp = Range(deltadeep_tmp);
    deltasup_tmp = Range(deltasup_tmp);
    
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

    %delta deep>PFCsup
    nb_sample = round(length(deltadeep_tmp)/4);

    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean1 = mean(Mat(:,x_tmp>0&x_tmp<0.2e4),2);
    [~, idxMat1] = sort(vmean1);
    
    good_deep = sort(deltadeep_tmp(idxMat1(1:nb_sample)));%good
    fake_deep = sort(deltadeep_tmp(idxMat1(end-nb_sample+1:end)));%fake

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
    
    %Good deep
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(ts(good_deep), 'windowsize',windowsize,'endtime', night_duration);
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
    
    good.deep.x_intervals = x_intervals;
    good.deep.y_density = y_density;
    good.deep.x_peaks = x_intervals(idx_peaks1);
    good.deep.y_peaks = y_density(idx_peaks1);
    good.deep.p1 = p1;
    good.deep.reg1 = reg1;
    
    
    %Fake deep
    %density
    windowsize = deltadensityfactor*1E4; %60s    
    [x_density, y_density] = DensityCurves_KJ(ts(fake_deep), 'windowsize',windowsize,'endtime', night_duration);
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
    
    fake.deep.x_intervals = x_intervals;
    fake.deep.y_density = y_density;
    fake.deep.x_peaks = x_intervals(idx_peaks1);
    fake.deep.y_peaks = y_density(idx_peaks1);
    fake.deep.p1 = p1;
    fake.deep.reg1 = reg1;
    
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
    
    good.sup.x_intervals = x_intervals;
    good.sup.y_density = y_density;
    good.sup.x_peaks = x_intervals(idx_peaks1);
    good.sup.y_peaks = y_density(idx_peaks1);
    good.sup.p1 = p1;
    good.sup.reg1 = reg1;
    
    
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
    
    fake.sup.x_intervals = x_intervals;
    fake.sup.y_density = y_density;
    fake.sup.x_peaks = x_intervals(idx_peaks1);
    fake.sup.y_peaks = y_density(idx_peaks1);
    fake.sup.p1 = p1;
    fake.sup.reg1 = reg1;
    
    
    %% PFC response
    for ch=1:length(channels)
        %good delta deep
        [m,~,tps] = mETAverage(good_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.deep.good{ch}(:,1) = tps; met_lfp.deep.good{ch}(:,2) = m;
        %fake delta deep
        [m,~,tps] = mETAverage(fake_deep, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.deep.fake{ch}(:,1) = tps; met_lfp.deep.fake{ch}(:,2) = m;

        %good delta sup
        [m,~,tps] = mETAverage(good_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.sup.good{ch}(:,1) = tps; met_lfp.sup.good{ch}(:,2) = m;
        %fake delta sup
        [m,~,tps] = mETAverage(fake_sup, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
        met_lfp.sup.fake{ch}(:,1) = tps; met_lfp.sup.fake{ch}(:,2) = m;
    end
    
    
    %% MUA response
    
    %all deep
    [m,~,tps] = mETAverage(deltadeep_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.deep.all(:,1) = tps; met_mua.deep.all(:,2) = m;
    %good delta deep
    [m,~,tps] = mETAverage(good_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.deep.good(:,1) = tps; met_mua.deep.good(:,2) = m;
    %fake delta deep
    [m,~,tps] = mETAverage(fake_deep, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.deep.fake(:,1) = tps; met_mua.deep.fake(:,2) = m;
    
    %all sup
    [m,~,tps] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.sup.all(:,1) = tps; met_mua.sup.all(:,2) = m;
    %good delta sup
    [m,~,tps] = mETAverage(good_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.sup.good(:,1) = tps; met_mua.sup.good(:,2) = m;
    %fake delta sup
    [m,~,tps] = mETAverage(fake_sup, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    met_mua.sup.fake(:,1) = tps; met_mua.sup.fake(:,2) = m;
    

    %% Cross-corr with down states
    
    %all deep
    [crosscorr.deep.all(:,2), crosscorr.deep.all(:,1)]   = CrossCorr(st_down, deltadeep_tmp, binsize_cc, nb_binscc);
    %good delta deep
    [crosscorr.deep.good(:,2), crosscorr.deep.good(:,1)] = CrossCorr(st_down, good_deep, binsize_cc, nb_binscc);
    crosscorr.deep.good(:,2) = crosscorr.deep.good(:,2)*4; %normalize
    %good delta deep
    [crosscorr.deep.fake(:,2), crosscorr.deep.fake(:,1)] = CrossCorr(st_down, fake_deep, binsize_cc, nb_binscc);
    crosscorr.deep.fake(:,2) = crosscorr.deep.fake(:,2)*4; %normalize
    
    %all sup
    [crosscorr.sup.all(:,2), crosscorr.sup.all(:,1)]   = CrossCorr(st_down, deltasup_tmp, binsize_cc, nb_binscc);
    %good delta sup
    [crosscorr.sup.good(:,2), crosscorr.sup.good(:,1)] = CrossCorr(st_down, good_sup, binsize_cc, nb_binscc);
    crosscorr.sup.good(:,2) = crosscorr.sup.good(:,2)*4; %normalize
    %good delta sup
    [crosscorr.sup.fake(:,2), crosscorr.sup.fake(:,1)] = CrossCorr(st_down, fake_sup, binsize_cc, nb_binscc);
    crosscorr.sup.fake(:,2) = crosscorr.sup.fake(:,2)*4; %normalize
    
    %% cross-corr between deltas 
    %deep
    [crosscorr.deep.between(:,2), crosscorr.deep.between(:,1)] = CrossCorr(good_deep, fake_deep, binsize_cc, nb_binscc);
    %sup
    [crosscorr.sup.between(:,2), crosscorr.sup.between(:,1)] = CrossCorr(good_sup, fake_sup, binsize_cc, nb_binscc);
    
    
    %% PLOT deltas detected on  DEEP
    
    color_all = [0.3 0.3 0.3];
    color_down = 'k';
    color_good = 'b';
    color_fake = 'r';
    
%     figure, hold on
% 
%     
%     %deltas deep - pfc sup
%     raster_tsd = deltadeep.sup;
%     Mat = Data(raster_tsd)';
%     x_tmp = Range(raster_tsd);
%     y_meancurves = mean(Mat);
%     %sort
%     Mat = Mat(idxMat1,:);
% 
%     subplot(4,3,[1 4 7]), hold on
%     imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
%     axis xy, ylabel('# deltas detected on deep'), hold on
%     line([0 0], ylim,'Linewidth',2,'color','k'), hold on
%     set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
%     caxis([-2000 2000]),
%     hb = colorbar('location','eastoutside'); hold on
%     xlabel('time from delta waves detected on deep (ms)'), title('LFP sup layer on delta deep')
%     
%     
%     %Deltas on deep - fake deep
%     subplot(8,3,[2 5 8]), hold on
%     for ch=1:length(channels)
%         hold on, plot(met_lfp.deep.fake{ch}(:,1), met_lfp.deep.fake{ch}(:,2), 'color',color_fake, 'linewidth',1)
%     end
%     xlim([-400 600]), ylim([-1500 2100]),
%     line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
%     ylabel('mean LFP amplitude'), 
%     title('LFP response for each channel (false delta)')
%     %Deltas on deep - good deep
%     subplot(8,3,[11 14 17]), hold on
%     for ch=1:length(channels)
%         hold on, plot(met_lfp.deep.good{ch}(:,1), met_lfp.deep.good{ch}(:,2), 'color',color_good, 'linewidth',1)
%     end
%     xlim([-400 600]), ylim([-1500 2100]),
%     line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
%     xlabel('time from delta waves (ms)'), ylabel('mean LFP amplitude'), 
%     title('LFP response for each channel (good delta)')
%     
%     
%     %MUA deep
%     subplot(4,3,3), hold on
%     hold on, h(1)=plot(met_mua.deep.all(:,1), met_mua.deep.all(:,2), 'color',color_all, 'linewidth',2);
%     hold on, h(2)=plot(met_mua.deep.good(:,1), met_mua.deep.good(:,2), 'color',color_good, 'linewidth',2);
%     hold on, h(3)=plot(met_mua.deep.fake(:,1), met_mua.deep.fake(:,2), 'color',color_fake, 'linewidth',2);
%     lgd = {'all deltas', 'good deltas', 'fake deltas'};
%     ylimax = get(gca,'ylim');
%     xlim([-400 600]), ylim([0 ylimax(2)]),
%     line([0 0], [0 ylimax(2)],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
%     legend(h,lgd, 'Location','southeast'),
%     xlabel('time from delta waves (ms)'), ylabel('mean MUA amplitude')
%     title([Dir.name{p} ' - ' Dir.date{p}]),
%     
%     
%     %Cross-corr with down
%     subplot(4,3,6), hold on
%     hold on, h(1)=plot(crosscorr.deep.all(:,1), crosscorr.deep.all(:,2), 'color',color_all, 'linewidth',2);
%     hold on, h(2)=plot(crosscorr.deep.good(:,1), crosscorr.deep.good(:,2), 'color',color_good, 'linewidth',2);
%     hold on, h(3)=plot(crosscorr.deep.fake(:,1), crosscorr.deep.fake(:,2), 'color',color_fake, 'linewidth',2);
%     xlim([-400 600]),
%     line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
%     legend(h,lgd),
%     xlabel('time from down state (ms)'), ylabel('deltas frequency')
%     
%     %Cross-corr between fake and good
%     subplot(4,3,9), hold on
%     hold on, h(1)=plot(crosscorr.deep.between(:,1), crosscorr.deep.between(:,2), 'color','r', 'linewidth',2);
%     xlim([-1000 1000]),
%     line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
%     legend(h,'fake'),
%     xlabel('time from good delta (ms)'), ylabel('fake deltas frequency')
%     
%     
%     %homeostasis Good slow-waves
%     subplot(4,2,7), hold on
%     hold on, plot(good.deep.x_intervals, good.deep.reg1,'k.')
%     hold on, scatter(good.deep.x_peaks , good.deep.y_peaks,'r')
%     xlabel('h'), ylabel('delta per minute'),
%     title(['Good delta homeostasis (p=' num2str(good.deep.p1) ')'])
%     
%     %homeostasis Fake slow-waves
%     subplot(4,2,8), hold on
%     hold on, plot(fake.deep.x_intervals, fake.deep.reg1,'k.')
%     hold on, scatter(fake.deep.x_peaks , fake.deep.y_peaks,'r')
%     xlabel('h'), ylabel('delta per minute'),
%     title(['Fake delta homeostasis (p=' num2str(fake.deep.p1) ')'])
%     
%     %save figure
%     filename_fig = ['FigureExampleFakeSlowWaveNeuronDeep_' Dir.name{p}  '_' Dir.date{p}];
%     filename_png = [filename_fig  '.png'];
%     folderfig = fullfile(FolderFigureDelta,'LabMeeting','20190826','FigureExampleFakeSlowWaveNeuronDeep');
%     filename_png = fullfile(folderfig,filename_png);
%     saveas(gcf,filename_png,'png')
%     close all
    
    
    %% PLOT deltas detected on  SUP
    
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
        hold on, plot(met_lfp.sup.good{ch}(:,1), met_lfp.sup.good{ch}(:,2), 'color',color_good, 'linewidth',1)
    end
    xlim([-400 600]), ylim([-1500 2100]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    ylabel('mean LFP amplitude'),
    title('LFP response for each channel (good delta)')
    %Deltas on sup - fake sup
    subplot(8,3,[11 14 17]), hold on
    for ch=1:length(channels)
        hold on, plot(met_lfp.sup.fake{ch}(:,1), met_lfp.sup.fake{ch}(:,2), 'color',color_fake, 'linewidth',1)
    end
    xlim([-400 600]), ylim([-1500 2100]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    xlabel('time from delta waves (ms)'), ylabel('mean LFP amplitude'), 
    title('LFP response for each channel (false delta)')
    
    
    %MUA sup
    clear h
    subplot(4,3,3), hold on
    hold on, h(1)=plot(met_mua.sup.all(:,1), met_mua.sup.all(:,2), 'color',color_all, 'linewidth',2);
    hold on, h(2)=plot(met_mua.sup.good(:,1), met_mua.sup.good(:,2), 'color',color_good, 'linewidth',2);
    hold on, h(3)=plot(met_mua.sup.fake(:,1), met_mua.sup.fake(:,2), 'color',color_fake, 'linewidth',2);
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
    hold on, h(1)=plot(crosscorr.sup.all(:,1), crosscorr.sup.all(:,2), 'color',color_all, 'linewidth',2);
    hold on, h(2)=plot(crosscorr.sup.good(:,1), crosscorr.sup.good(:,2), 'color',color_good, 'linewidth',2);
    hold on, h(3)=plot(crosscorr.sup.fake(:,1), crosscorr.sup.fake(:,2), 'color',color_fake, 'linewidth',2);
    xlim([-400 600]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,lgd),
    xlabel('time from down state (ms)'), ylabel('deltas frequency')
    
    %Cross-corr between good and fake
    subplot(4,3,9), hold on
    hold on, h(1)=plot(crosscorr.sup.between(:,1), crosscorr.sup.between(:,2), 'color','r', 'linewidth',2);
    xlim([-1000 1000]),
    line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    legend(h,'fake'),
    xlabel('time from good delta waves (ms)'), ylabel('fake deltas frequency')
    
    %homeostasis Good slow-waves
    subplot(4,2,7), hold on
    hold on, plot(good.sup.x_intervals, good.sup.reg1,'k.')
    hold on, scatter(good.sup.x_peaks , good.sup.y_peaks,'r')
    xlabel('h'), ylabel('delta per minute'),
    title(['Good delta homeostasis (p=' num2str(good.sup.p1) ')'])
    
    %homeostasis Fake slow-waves
    subplot(4,2,8), hold on
    hold on, plot(fake.sup.x_intervals, fake.sup.reg1,'k.')
    hold on, scatter(fake.sup.x_peaks , fake.sup.y_peaks,'r')
    xlabel('h'), ylabel('delta per minute'),
    title(['Fake delta homeostasis (p=' num2str(fake.sup.p1) ')'])
    
    %save figure
    filename_fig = ['FigureExampleFakeSlowWaveNeuronSup_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    folderfig = fullfile(FolderFigureDelta,'LabMeeting','20190826','FigureExampleFakeSlowWaveNeuronSup');
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
    
end







