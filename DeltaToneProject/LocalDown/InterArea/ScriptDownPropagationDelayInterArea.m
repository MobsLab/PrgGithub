%%ScriptDownPropagationDelayInterArea
% 29.09.2019 KJ
%
% Infos
%   script about homeostasis for real and fake delta
%
% see
%     AnalyseLocalGlobalInterArea QuantifHomeostasisDownInterArea
%    


clear
Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=[1 5]
    
    if ~strcmpi(Dir.name{p},'Mouse243') && ~strcmpi(Dir.name{p},'Mouse244')
        continue
    end
        
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p local_res

    %params
    binsize_cc = 10; %5ms
    nb_binscc = 200;
    binsize_met = 5;
    nbBins_met  = 400;
    factorLFP = 0.195;

    
    %% load

    %night duration and tsd zt
    load('IdFigureData2.mat', 'night_duration')

    %NREM
    [NREM, REM, Wake, TotalNoiseEpoch] = GetSleepScoring;
    NREM = NREM - TotalNoiseEpoch;

    
    %LFP 
    
    %PFCx
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP' num2str(channel)])
    PFCdeep = LFP;
    ch_PFC = channel;
    load('ChannelsToAnalyse/PFCx_sup.mat')
    load(['LFPData/LFP' num2str(channel)])
    PFCsup = LFP;
    
    %PaCx
    load('ChannelsToAnalyse/PaCx_deep.mat')
    load(['LFPData/LFP' num2str(channel)])
    Padeep = LFP;
    ch_PaCx = channel;
    load('ChannelsToAnalyse/PaCx_sup.mat')
    load(['LFPData/LFP' num2str(channel)])
    Pasup = LFP;
    
    %MoCx
    load('ChannelsToAnalyse/MoCx_deep.mat')
    load(['LFPData/LFP' num2str(channel)])
    Modeep = LFP;
    ch_MoCx = channel;
    load('ChannelsToAnalyse/MoCx_sup.mat')
    load(['LFPData/LFP' num2str(channel)])
    Mosup = LFP;
    
    clear LFP channel
    

    %% Down & deltas
    
    %Down global
    load('DownState.mat', 'down_PFCx')
    GlobalDownPFC = down_PFCx;

    %PaCx
    load('DeltaWaves.mat', 'deltas_PaCx')    
    PaDeltas = deltas_PaCx;
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_PaCx)])
    eval(['PaDeltas = delta_ch_' num2str(ch_PaCx) ';'])

    %MoCx
    load('DeltaWaves.mat', 'deltas_MoCx')
    MoDeltas = deltas_MoCx;
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_MoCx)])
    eval(['MoDeltas = delta_ch_' num2str(ch_MoCx) ';'])


    %PFCx Diff
    load('DeltaWaves.mat', 'deltas_PFCx')
    PFCxDeltas = deltas_PFCx;  
    load('DeltaWavesChannels.mat', ['delta_ch_' num2str(ch_PFC)])
    eval(['PFCxDeltas = delta_ch_' num2str(ch_PFC) ';'])
    
    
    Inter_PfcMoCxRaw = GetIntersectionsEpochs(GlobalDownPFC, MoDeltas);
    Inter_PfcPaCxRaw = GetIntersectionsEpochs(GlobalDownPFC, PaDeltas);
    Inter_All = GetIntersectionsEpochs(Inter_PfcPaCxRaw, Inter_PfcMoCxRaw);
    
    
    %% mean curves on down
    
    %PFCx
    [m,~,tps] = mETAverage(Start(Inter_All), Range(PFCdeep), Data(PFCdeep), binsize_met, nbBins_met);
    met_pfc.deep(:,1) = tps; met_pfc.deep(:,2) = m*factorLFP;
    [m,~,tps] = mETAverage(Start(Inter_All), Range(PFCsup), Data(PFCsup), binsize_met, nbBins_met);
    met_pfc.sup(:,1) = tps; met_pfc.sup(:,2) = m*factorLFP;
    
    %PaCx
    [m,~,tps] = mETAverage(Start(Inter_All), Range(Padeep), Data(Padeep), binsize_met, nbBins_met);
    met_pa.deep(:,1) = tps; met_pa.deep(:,2) = m*factorLFP;
    [m,~,tps] = mETAverage(Start(Inter_All), Range(Pasup), Data(Pasup), binsize_met, nbBins_met);
    met_pa.sup(:,1) = tps; met_pa.sup(:,2) = m*factorLFP;
    
    %MoCx
    [m,~,tps] = mETAverage(Start(Inter_All), Range(Modeep), Data(Modeep), binsize_met, nbBins_met);
    met_mo.deep(:,1) = tps; met_mo.deep(:,2) = m*factorLFP;
    [m,~,tps] = mETAverage(Start(Inter_All), Range(Mosup), Data(Mosup), binsize_met, nbBins_met);
    met_mo.sup(:,1) = tps; met_mo.sup(:,2) = m*factorLFP;
    
    
    %% Cross-Corr
    
    %PFCx
    [y_cc.pfc, x_cc.pfc] = CrossCorr(Start(Inter_All), Start(PFCxDeltas), binsize_cc, nb_binscc);
    
    %PaCx
    [y_cc.pacx, x_cc.pacx] = CrossCorr(Start(Inter_All), Start(PaDeltas), binsize_cc, nb_binscc);
    
    %MoCx
    [y_cc.mocx, x_cc.mocx] = CrossCorr(Start(Inter_All), Start(MoDeltas), binsize_cc, nb_binscc);
    
    
    
    %% PLOT
    fontsize = 16;

    %colors
    color_pfc = 'r';
    color_pa = [1 0.8 0];
    color_mo = [0 0.5 0];
    
    
    figure, hold on
    
    %mean curves
    clear h
    subplot(3,2,1), hold on
    h(1) = plot(met_pfc.deep(:,1), met_pfc.deep(:,2), 'color', color_pfc, 'linewidth',2.5);
    plot(met_pfc.sup(:,1), met_pfc.sup(:,2), 'color', color_pfc, 'linewidth',1);
    %properties
    set(gca,'xlim',[-300 800],'ylim',[-200 450],'Fontsize',fontsize);
    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
%     line([10 10], ylim,'Linewidth',1,'color',color_mo), hold on
%     line([20 20], ylim,'Linewidth',1,'color',color_pfc), hold on
%     line([80 80], ylim,'Linewidth',1,'color',color_pa), hold on
    
    legend(h,'PFCx');
    ylabel('LFP amplitude (mV)'), 
    title([Dir.name{p} ' - ' Dir.date{p}]),
    
    %Pacx
    clear h
    subplot(3,2,3), hold on
    h(1) = plot(met_pa.deep(:,1), met_pa.deep(:,2), 'color', color_pa, 'linewidth',2.5);
    plot(met_pa.sup(:,1), met_pa.sup(:,2), 'color', color_pa, 'linewidth',1);
    %properties
    set(gca,'xlim',[-300 800],'ylim',[-200 450],'Fontsize',fontsize);
    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
%     line([10 10], ylim,'Linewidth',1,'color',color_mo), hold on
%     line([20 20], ylim,'Linewidth',1,'color',color_pfc), hold on
%     line([80 80], ylim,'Linewidth',1,'color',color_pa), hold on
    
    legend(h,'PaCx');
    ylabel('LFP amplitude (mV)'), 
    
    %Mocx
    clear h
    subplot(3,2,5), hold on
    h(1) = plot(met_mo.deep(:,1), met_mo.deep(:,2), 'color', color_mo, 'linewidth',2.5);
    plot(met_mo.sup(:,1), met_mo.sup(:,2), 'color', color_mo, 'linewidth',1);
    %properties
    set(gca,'xlim',[-300 800],'ylim',[-200 450],'Fontsize',fontsize);
    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
%     line([10 10], ylim,'Linewidth',1,'color',color_mo), hold on
%     line([20 20], ylim,'Linewidth',1,'color',color_pfc), hold on
%     line([80 80], ylim,'Linewidth',1,'color',color_pa), hold on
    legend(h,'MoCx');
    xlabel('time from down states start in PFCx (ms)'),
    ylabel('LFP amplitude (mV)'), 
    
    %ALL
    clear h
    subplot(3,2,2), hold on
    h(1) = plot(met_pfc.deep(:,1), met_pfc.deep(:,2), 'color', color_pfc, 'linewidth',2.5);
    h(2) = plot(met_pa.deep(:,1), met_pa.deep(:,2), 'color', color_pa, 'linewidth',2.5);
    h(3) = plot(met_mo.deep(:,1), met_mo.deep(:,2), 'color', color_mo, 'linewidth',2.5);
    %properties
    set(gca,'xlim',[-300 800],'ylim',[-200 450],'Fontsize',fontsize);
    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
%     line([10 10], ylim,'Linewidth',1,'color',color_mo), hold on
%     line([20 20], ylim,'Linewidth',1,'color',color_pfc), hold on
%     line([80 80], ylim,'Linewidth',1,'color',color_pa), hold on
    
    legend(h,'PFCx','PaCx','MoCx');
    ylabel('LFP amplitude (mV)'), 
    
    
    %Cross-corr
    subplot(3,2,[4 6]), hold on
    h(1) = plot(x_cc.pfc, y_cc.pfc, 'color', color_pfc, 'linewidth',2);
    h(2) = plot(x_cc.pacx, y_cc.pacx, 'color', color_pa, 'linewidth',2);
    h(3) = plot(x_cc.mocx, y_cc.mocx, 'color', color_mo, 'linewidth',2);
    %properties
    set(gca,'xlim',[-250 350],'Fontsize',fontsize);
    line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
    legend(h,'PFCx','PaCx','MoCx');
    xlabel('time from down states start in PFCx (ms)'),
    ylabel('Delta occurence'),
    
    
end





