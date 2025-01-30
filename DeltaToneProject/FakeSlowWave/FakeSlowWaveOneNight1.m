%%FakeSlowWaveOneNight1
% 21.06.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight2 FakeSlowWaveOneNight3





%% load

% load

Dir = PathForExperimentsFakeSlowWave;


for p=1:length(Dir.path)
    
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    binsize_mua = 10;
    binsize_met = 10;
    nbBins_met  = 160;
    binsize_cc = 10; %10ms
    nb_binscc = 100;

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
    try
        [tRipples, ~] = GetRipples;
        ripples_tmp = Range(Restrict(tRipples, NREM));
    catch
        ripples_tmp = [];
    end
        
    %down states
    down_PFCx = GetDownStates('area',['PFCx' hsp]);
    st_down = Start(down_PFCx);
    center_down = (Start(down_PFCx)+End(down_PFCx))/2;
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

    %night duration
    load('IdFigureData2.mat', 'night_duration')

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
    [~, idx1] = sort(vmean1);

    sort_deep{1} = sort(deltadeep_tmp(idx1(end-nb_sample+1:end)));%fake
    sort_deep{2} = sort(deltadeep_tmp(idx1(2*nb_sample+1:3*nb_sample)));
    sort_deep{3} = sort(deltadeep_tmp(idx1(nb_sample+1:2*nb_sample)));
    sort_deep{4} = sort(deltadeep_tmp(idx1(1:nb_sample)));%good

    %delta sup>PFCdeep
    nb_sample = round(length(deltasup_tmp)/4);

    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    vmean2 = mean(Mat(:,x_tmp>-0.1e4&x_tmp<0.1e4),2);
    [~, idx2] = sort(vmean2);


    sort_sup{1} = sort(deltasup_tmp(idx2(1:nb_sample)));%good
    sort_sup{2} = sort(deltasup_tmp(idx2(nb_sample+1:2*nb_sample)));
    sort_sup{3} = sort(deltasup_tmp(idx2(2*nb_sample+1:3*nb_sample)));
    sort_sup{4} = sort(deltasup_tmp(idx2(end-nb_sample+1:end)));%fake


    %% PFC response

    for ch=1:length(channels)

        for i=1:length(sort_deep)
            %on delta deep
            [m,~,tps] = mETAverage(sort_deep{i}, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
            lfp_ondeep{ch,i}(:,1) = tps; lfp_ondeep{ch,i}(:,2) = m;

            %on delta sup
            [m,~,tps] = mETAverage(sort_sup{i}, Range(PFC{ch}), Data(PFC{ch}), binsize_met, nbBins_met);
            lfp_onsup{ch,i}(:,1) = tps; lfp_onsup{ch,i}(:,2) = m;
        end
    end


    %% MUA response


    for i=1:length(sort_deep)
        %on delta deep
        [m,~,tps] = mETAverage(sort_deep{i}, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        mua_ondeep{i}(:,1) = tps; mua_ondeep{i}(:,2) = m;

        %on delta sup
        [m,~,tps] = mETAverage(sort_sup{i}, Range(MUA), Data(MUA), binsize_met, nbBins_met);
        mua_onsup{i}(:,1) = tps; mua_onsup{i}(:,2) = m;

    end
    %all deep
    [m,~,tps] = mETAverage(deltadeep_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    mua_alldeep(:,1) = tps; mua_alldeep(:,2) = m;
    %all sup
    [m,~,tps] = mETAverage(deltasup_tmp, Range(MUA), Data(MUA), binsize_met, nbBins_met);
    mua_allsup(:,1) = tps; mua_allsup(:,2) = m;


    %% Cross-corr with down states
    %with deltas
    for i=1:length(sort_deep)
        [crosscorr.down_deep.y{i}, crosscorr.down_deep.x{i}] = CrossCorr(st_down, sort_deep{i}, binsize_cc, nb_binscc);
        [crosscorr.down_sup.y{i}, crosscorr.down_sup.x{i}]   = CrossCorr(st_down, sort_sup{i}, binsize_cc, nb_binscc);
    end


    %% Cross-corr with Ripples

    if ~isempty(ripples_tmp)
        %with down
        [crosscorr.rip_down.y, crosscorr.rip_down.x] = CrossCorr(ripples_tmp, st_down, binsize_cc, nb_binscc);
        %with deltas
        for i=1:length(sort_deep)
            [crosscorr.rip_deep.y{i}, crosscorr.rip_deep.x{i}] = CrossCorr(ripples_tmp, sort_deep{i}, binsize_cc, nb_binscc);
            [crosscorr.rip_sup.y{i}, crosscorr.rip_sup.x{i}]   = CrossCorr(ripples_tmp, sort_sup{i}, binsize_cc, nb_binscc);
        end        
        
    end


    %% homeostasis
    % 
    % 
    % for i=1:length(sort_deep)
    %     [x_density.deltadeep{i}, y_density.deltadeep{i}] = DensityCurves_KJ(ts(sort_deep{i}), 'endtime',night_duration, 'smoothing', 2);
    %     [x_density.deltasup{i}, y_density.deltasup{i}] = DensityCurves_KJ(ts(sort_sup{i}), 'endtime',night_duration, 'smoothing', 2);
    % end
    % 
    % [x_density.down, y_density.down] = DensityCurves_KJ(ts(st_down), 'endtime',night_duration, 'smoothing', 2);
    % [x_density.deltas, y_density.deltas] = DensityCurves_KJ(ts(st_deltas), 'endtime',night_duration, 'smoothing', 2);
    % 

    % %smooth and uniformise
    % y_density.fake.deep = y_density.fake.deep/max(y_density.fake.deep);
    % y_density.good.deep = y_density.good.deep/max(y_density.good.deep);
    % 
    % y_density.fake.sup = y_density.fake.sup/max(y_density.fake.sup);
    % y_density.good.sup = y_density.good.sup/max(y_density.good.sup);
    % 
    % y_density.down = y_density.down/max(y_density.down);
    % y_density.deltas = y_density.deltas/max(y_density.deltas);


    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% PLOT deltas on  DEEP

    %Init
    colori = distinguishable_colors(length(mua_ondeep));
    for i=1:length(mua_ondeep)
        colori_group{i} = colori(i,:);
    end

    figure, hold on

    %deltas deep - pfc sup
    raster_tsd = deltadeep.sup;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    y_meancurves = mean(Mat);
    %sort
    Mat = Mat(idx1,:);

    subplot(2,3,[1 4]), hold on
    imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
    axis xy, ylabel('# deltas detected on deep'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on

    yyaxis right
    y_meancurves = Smooth(y_meancurves ,1);
    % y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
    plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

    yyaxis left
    set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
    caxis([-2000 2000]),
    % hb = colorbar('location','eastoutside'); hold on
    xlabel('time from detection (ms)'), title('LFP sup layer on delta deep')

    %Deltas on deep - for each group
    for i=1:4
        subplot(4,3,2+(i-1)*3), hold on
        for ch=1:length(channels)
            hold on, plot(lfp_ondeep{ch,i}(:,1), lfp_ondeep{ch,i}(:,2), 'color',colori_group{i}, 'linewidth',1)
        end
        xlim([-400 600]), ylim([-1500 2100]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    end
    xlabel('time from detection (ms)'), ylabel('mean LFP amplitude')

    %MUA deep
    subplot(3,3,3), hold on
    hold on, h(1)=plot(mua_alldeep(:,1), mua_alldeep(:,2), 'color',[0.6 0.6 0.6], 'linewidth',2);
    lgd{1} = 'all';
    for i=1:length(mua_ondeep)
        hold on, h(1+i)=plot(mua_ondeep{i}(:,1), mua_ondeep{i}(:,2), 'color',colori_group{i}, 'linewidth',2);
        lgd{1+i} = ['group' num2str(i)];
    end
    ylimax = get(gca,'ylim');
    xlim([-400 600]), ylim([0 ylimax(2)]),
    line([0 0], [0 ylimax(2)],'Linewidth',1,'color','k'), hold on
    legend(h,lgd),
    xlabel('time from detection (ms)'), ylabel('mean MUA amplitude')
    title([Dir.name{p} ' - ' Dir.date{p}]),

    %Cross-corr with down
    subplot(3,3,6), hold on
    for i=1:length(mua_ondeep)
        hold on, h(i)=plot(crosscorr.down_deep.x{i}, crosscorr.down_deep.y{i}, 'color',colori_group{i}, 'linewidth',2);
        lgd_cc{i} = ['group' num2str(i)];
    end
    xlim([-400 600]),
    line([0 0], ylim,'Linewidth',1,'color','k'), hold on
    legend(h,lgd_cc),
    xlabel('time from down state (ms)'), ylabel('deltas frequency')

    %Cross-corr with ripples
    if ~isempty(ripples_tmp)
        subplot(3,3,9), hold on
        hold on, h(1)=plot(crosscorr.rip_down.x, crosscorr.rip_down.y, 'color',[0.5 0.5 0.5], 'linewidth',2);
        lgd_ccr{1} = 'down';
        for i=1:length(mua_ondeep)
            hold on, h(i+1)=plot(crosscorr.rip_deep.x{i}, crosscorr.rip_deep.y{i}*4, 'color',colori_group{i}, 'linewidth',2);
            lgd_ccr{i+1} = ['group' num2str(i)];
        end
        xlim([-400 600]),
        line([0 0], ylim,'Linewidth',1,'color','k'), hold on
        legend(h,lgd_ccr),
        xlabel('time from ripples (ms)'), ylabel('down/deltas frequency')
    end
    
    
    %save figure
    filename_fig = ['FakeSlowWaveOneNightDeep_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    folderfig = '/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Projet_Delta/Figures_DeltaFeedback/LabMeeting/20190826/FakeSlowWaveOneNight1/';
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
    

    %% PLOT deltas on SUP
    figure, hold on

    %deltas sup - pfc deep
    raster_tsd = deltasup.deep;
    Mat = Data(raster_tsd)';
    x_tmp = Range(raster_tsd);
    y_meancurves = mean(Mat);
    %sort
    Mat = Mat(idx2,:);

    subplot(2,3,[1 4]), hold on
    imagesc(x_tmp/1E4, 1:size(Mat,1), Mat), hold on
    axis xy, ylabel('# deltas detected on sup'), hold on
    line([0 0], ylim,'Linewidth',2,'color','k'), hold on

    yyaxis right
    y_meancurves = Smooth(y_meancurves ,1);
    % y_meancurves = y_meancurves / mean(y_meancurves(x_tmp<-0.5e4));
    plot(x_tmp/1E4, y_meancurves, 'color', 'w', 'linewidth', 2);

    yyaxis left
    set(gca,'YLim', [0 size(Mat,1)], 'xlim', [-1 1]);
    caxis([-1500 3000]),
    % hb = colorbar('location','eastoutside'); hold on
    xlabel('time from detection (ms)'), title('LFP deep layer on delta sup')


    %Deltas on deep - for each group
    for i=1:4
        subplot(4,3,2+(i-1)*3), hold on
        for ch=1:length(channels)
            hold on, plot(lfp_ondeep{ch,5-i}(:,1), lfp_ondeep{ch,5-i}(:,2), 'color',colori_group{5-i},'linewidth',1)
        end
        xlim([-400 600]), ylim([-1500 2100]),
        line([0 0], ylim,'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
    end
    xlabel('time from detection (ms)'), ylabel('mean LFP amplitude')


    %MUA deep
    subplot(3,3,3), hold on
    hold on, h(1)=plot(mua_allsup(:,1), mua_allsup(:,2), 'color',[0.6 0.6 0.6], 'linewidth',2);
    lgd{1} = 'all';
    for i=1:length(mua_onsup)
        hold on, h(1+i)=plot(mua_onsup{i}(:,1), mua_onsup{i}(:,2), 'color',colori_group{i}, 'linewidth',2);
        lgd{1+i} = ['group' num2str(i)];
    end
    ylimax = get(gca,'ylim');
    xlim([-400 600]), ylim([0 ylimax(2)]),
    line([0 0], [0 ylimax(2)],'Linewidth',2,'color','k'), hold on
    legend(h,lgd),
    title('mean MUA on detection'),
    xlabel('time from detection (ms)'), ylabel('mean MUA amplitude')
    title([Dir.name{p} ' - ' Dir.date{p}]),

    %Cross-corr with down
    subplot(3,3,6), hold on
    for i=1:length(mua_onsup)
        hold on, h(i)=plot(crosscorr.down_sup.x{i}, crosscorr.down_sup.y{i}, 'color',colori_group{i}, 'linewidth',2);
        lgd_cc{i} = ['group' num2str(i)];
    end
    xlim([-400 600]),
    line([0 0], ylim,'Linewidth',1,'color','k'), hold on
    legend(h,lgd_cc),
    xlabel('time from down state (ms)'), ylabel('deltas frequency')

    %Cross-corr with ripples
    if ~isempty(ripples_tmp)
        subplot(3,3,9), hold on
        hold on, h(1)=plot(crosscorr.rip_down.x, crosscorr.rip_down.y, 'color',[0.5 0.5 0.5], 'linewidth',2);
        lgd_ccr{1} = 'down';
        for i=1:length(mua_ondeep)
            hold on, h(i+1)=plot(crosscorr.rip_sup.x{i}, crosscorr.rip_sup.y{i}*4, 'color',colori_group{i}, 'linewidth',2);
            lgd_ccr{i+1} = ['group' num2str(i)];
        end
        xlim([-400 600]),
        line([0 0], ylim,'Linewidth',1,'color','k'), hold on
        legend(h,lgd_ccr),
        xlabel('time from ripples (ms)'), ylabel('down/deltas frequency')
    end
    
    %save figure
    filename_fig = ['FakeSlowWaveOneNightSup_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    folderfig = '/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Projet_Delta/Figures_DeltaFeedback/LabMeeting/20190826/FakeSlowWaveOneNight1/';
    filename_png = fullfile(folderfig,filename_png);
    saveas(gcf,filename_png,'png')
    close all
end

% %% Homeostasis
% 
% xd = x_density.down/3600e4;
% d_down  = y_density.down;
% d_delta = y_density.deltas;
% f_deep = y_density.fake.deep;
% f_sup = y_density.fake.sup;
% 
% 
% figure, 
% % delta and down
% subplot(3,1,1), hold on
% %distances and similarities
% frechet_distance1 = round(DiscreteFrechetDist(d_down, d_delta),2);
% %regression
% idx_down = d_down > max(d_down)/8;
% idx_delta = d_delta > max(d_delta)/8;
% 
% [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
% reg_down    = polyval(p_down,xd);
% [p_delta,~] = polyfit(xd(idx_delta), d_delta(idx_delta), 1);
% reg_delta   = polyval(p_delta,xd);
% 
% clear h
% h(1) = plot(xd, d_down, 'color', [0.6 0.6 0.6]); hold on
% plot(xd, reg_down, 'color', [0.6 0.6 0.6]), hold on
% h(2) = plot(xd, d_delta, 'color', 'k'); hold on
% plot(xd, reg_delta, 'color', 'k'),
% set(gca, 'XTickLabel',{''}), hold on
% legend(h, 'down', ['diff - distance ' num2str(frechet_distance1)]),
% ylabel('per min'),
% 
% y_lim = get(gca,'ylim'); y_lim(1)=0;
% ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
% title('Homeostasis for Delta (2-layers) and down')
% 
% % good and down
% subplot(3,1,2), hold on
% %distances and similarities
% frechet_distance2 = round(DiscreteFrechetDist(d_down, f_deep),2);
% %regression
% idx_down = d_down > max(d_down)/8;
% idx_good = f_deep > max(f_deep)/8;
% 
% [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
% reg_down    = polyval(p_down,xd);
% [p_good,~] = polyfit(xd(idx_good), f_deep(idx_good), 1);
% reg_good   = polyval(p_good,xd);
% 
% clear h
% h(1) = plot(xd, d_down, 'color', [0.6 0.6 0.6]); hold on
% plot(xd, reg_down, 'color', [0.6 0.6 0.6]), hold on
% h(2) = plot(xd, f_deep, 'color', 'k'); hold on
% plot(xd, reg_good, 'color', 'k'),
% set(gca, 'XTickLabel',{''}), hold on
% legend(h, 'down', ['fake deep - distance ' num2str(frechet_distance2)]),
% ylabel('per min'),
% y_lim = get(gca,'ylim'); y_lim(1)=0;
% ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
% title('fake deep and down')
% 
% 
% % fake and down
% subplot(3,1,3), hold on
% %distances and similarities
% frechet_distance3 = round(DiscreteFrechetDist(d_down, f_sup),2);
% %regression
% idx_down = d_down > max(d_down)/8;
% idx_fake = f_sup > max(f_sup)/8;
% 
% [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
% reg_down    = polyval(p_down,xd);
% [p_fake,~] = polyfit(xd(idx_fake), f_sup(idx_fake), 1);
% reg_fake   = polyval(p_fake,xd);
% 
% clear h
% h(1) = plot(xd, d_down, 'color', [0.6 0.6 0.6]); hold on
% plot(xd, reg_down, 'color', [0.6 0.6 0.6]), hold on
% h(2) = plot(xd, f_sup, 'color', 'k'); hold on
% plot(xd, reg_fake, 'color', 'k'),
% legend(h, 'down', ['fake sup - distance ' num2str(frechet_distance3)]),
% ylabel('per min'),
% y_lim = get(gca,'ylim'); y_lim(1)=0;
% ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
% title('fake sup and down')
% 
