

% Compute Event-triggered average of spiking activity
%DeltaDetectionTh2 - Compute Event-triggered average of spiking activity
%
%  USAGE
%
%    [met_mua, met_mua_deep, met_mua_sup, tmp, met_lfp, met_lfp_deep, met_lfp_sup, tmp2, nb_delta, nb_delta_deep, nb_delta_sup, nb_down1, nb_down2, mnQ_Down1, tmp_down1, mnQ_stDown1, mnQ_enDown1, mnLFP_Down1,mnLFP_stDown1,mnLFP_enDown1,mnQ_Down2,tmp_down2,mnQ_stDown2,mnQ_enDown2,mnLFP_Down2,mnLFP_stDown2,mnLFP_enDown2,nb_neurons] = DeltaDetectionTh2(saving, toPlot)
%
%
%    saving         save the data if equals to 1
%    toPlot         plot curves if equals to 1
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     
%    =========================================================================
%
%  OUTPUT
%   met_mua ('','deep',sup')            mean Event-triggered MUA, synchronized on deltas timestamps, for deep and sup also
%   met_lfp ('','deep',sup')            mean ET LFP signals, sync on deltas
%   tmp                                 timestamps for met curves
%   nb_delta ('','deep',sup')           number of deltas per seconds
%   nb_down (1 & 2)                     number of down states per second
%   mnQ_Down1 (stDown, enDown; 1&2)     mean E-T MUA sync on down states (middle,start, end) 
%   mnLFP_Down1 (stDown, enDown; 1&2)   mean E-T LFP sync on down states (middle,start, end)
%   tmp_down1                           timestamps for mean curves
%
%  SEE
%
%    See also ParcoursDeltaDetection2, FindDown2_KJ

function [met_mua, met_mua_deep, met_mua_sup, tmp, met_lfp, met_lfp_deep, met_lfp_sup, tmp2, nb_delta, nb_delta_deep, nb_delta_sup, nb_down1, nb_down2, mnQ_Down1, tmp_down1, mnQ_stDown1, mnQ_enDown1, mnLFP_Down1,mnLFP_stDown1,mnLFP_enDown1,mnQ_Down2,tmp_down2,mnQ_stDown2,mnQ_enDown2,mnLFP_Down2,mnLFP_stDown2,mnLFP_enDown2,nb_neurons] = DeltaDetectionTh2(saving, toPlot)


%Check for variables
if ~exist('saving','var')
    saving = 0;
end
if ~exist('toPlot','var')
    toPlot = 0;
end


% Check if data are already computed
try
    load DataDeltaDetect met_mua met_mua_deep met_mua_sup tmp met_lfp met_lfp_deep met_lfp_sup tmp2 nb_delta nb_delta_deep nb_delta_sup nb_down1 nb_down2 mnQ_Down1 tmp_down1 mnQ_stDown1 mnQ_enDown1 mnLFP_Down1 mnLFP_stDown1 mnLFP_enDown1 mnQ_Down2 tmp_down2 mnQ_stDown2 mnQ_enDown2 mnLFP_Down2 mnLFP_stDown2 mnLFP_enDown2 nb_neurons
    alreadyComputed = 1;
catch
    alreadyComputed = 0;
end


%% Compute mean ET
if alreadyComputed == 0
    
    %load data
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPd=LFP;
    clear LFP

    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPs=LFP;
    clear LFP

    load SpikeData
    load SpikesToAnalyse/PFCx_Neurons
    NumNeurons=number;
    clear number
    load StateEpochSB SWSEpoch

    
    % Find down
    nb_neurons=length(NumNeurons);
    [Down,Qt,~,~,~,~,~,~,~,~,~]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,1,[0 70],1);close
    [Down2,~,~,~,~,~,~,~,~,~,~]=FindDown(S,NumNeurons,SWSEpoch,10,0.03,1,2,[10 70],1);close

    
    % PFCx    
    a=1;
    for i=0.2:0.2:4
        [tDelta,~] = FindDeltaWavesChanGL('PFCx',SWSEpoch,[],0,i,75,[1 5]);
        [met_mua(a,:),~,tmp]  = mETAverage(tDelta,Range(Qt),Data(Qt),10,200);
        [met_lfp(a,:),~,tmp2] = mETAverage(tDelta,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        nb_delta(a) = length(tDelta);
        a=a+1;
    end

    % PFCx_deep
    a=1;
    for i=0.2:0.2:4
        [tDelta,~] = FindDeltaWavesSingleChanGL('PFCx_deep',SWSEpoch,[],0,i,75,[1 5]);
        de = Range(tDelta);
        [met_mua_deep(a,:),~,~]=mETAverage(de(2:end-1),Range(Qt),Data(Qt),10,200);
        [met_lfp_deep(a,:),~,~]=mETAverage(de(2:end-1),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        nb_delta_deep(a) = length(tDelta);
        a=a+1;
    end

    % PFCx_sup
    a=1;
    for i=0.2:0.2:4
        [tDelta,~] = FindDeltaWavesSingleChanGL('PFCx_sup',SWSEpoch,1,0,i,75,[1 5]);
        de = Range(tDelta);
        [met_mua_sup(a,:),~,~] = mETAverage(de(2:end-1),Range(Qt),Data(Qt),10,200);
        [met_lfp_sup(a,:),~,~] = mETAverage(de(2:end-1),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        nb_delta_sup(a) = length(tDelta);
        a=a+1;
    end
    
    %numbers of event per seconds
    sws_duration  = sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
    nb_delta     = nb_delta / sws_duration;
    nb_delta_deep = nb_delta_deep / sws_duration;
    nb_delta_sup  = nb_delta_sup / sws_duration;
    nb_down1      = length(Start(Down)) / sws_duration;
    nb_down2      = length(Start(Down2)) / sws_duration;

    % mean curves around events
    [mnQ_Down1,~,tmp_down1] = mETAverage((Start(Down)+End(Down))/2,Range(Qt),Data(Qt),10,200);
    [mnQ_stDown1,~,~]   = mETAverage(Start(Down),Range(Qt),Data(Qt),10,200);
    [mnQ_enDown1,~,~]   = mETAverage(End(Down),Range(Qt),Data(Qt),10,200);

    [mnLFP_Down1,~,~] = mETAverage((Start(Down)+End(Down))/2,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
    [mnLFP_stDown1,~,~] = mETAverage(Start(Down),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
    [mnLFP_enDown1,~,~] = mETAverage(End(Down),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);


    [mnQ_Down2,~,tmp_down2] = mETAverage((Start(Down2)+End(Down2))/2,Range(Qt),Data(Qt),10,200);
    [mnQ_stDown2,~,~]    = mETAverage(Start(Down2),Range(Qt),Data(Qt),10,200);
    [mnQ_enDown2,~,~]    = mETAverage(End(Down2),Range(Qt),Data(Qt),10,200);

    [mnLFP_Down2,~,~] = mETAverage((Start(Down2)+End(Down2))/2,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
    [mnLFP_stDown2,~,~] = mETAverage(Start(Down2),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
    [mnLFP_enDown2,~,~] = mETAverage(End(Down2),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);

end


%% Plot data
if toPlot
    figure('color',[1 1 1])
    subplot(2,2,1), plot(tmp,met_mua,'k'), hold on, plot(tmp_down1,mnQ_Down1,'g','linewidth',2), plot(tmp_down1,mnQ_Down2,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,3), plot(tmp,met_lfp,'k'), hold on, plot(tmp_down1,mnLFP_Down1,'g','linewidth',2), plot(tmp_down1,mnLFP_Down2,'m','linewidth',2)
    subplot(2,2,2), plot(0.2:0.2:4,met_mua(:,98),'ko-'), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,4), plot(0.2:0.2:4,nb_delta,'ko-'), xl=xlim; line(xl,[nb_down1 nb_down1],'color','r'),  line(xl,[nb_down2 nb_down2],'color','r')


    figure('color',[1 1 1])
    subplot(2,2,1), plot(tmp,met_mua_deep,'b'), hold on, plot(tmp_down1,mnQ_Down1,'g','linewidth',2), plot(tmp_down1,mnQ_Down2,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,3), plot(tmp,met_lfp_deep,'b'), hold on, plot(tmp_down1,mnLFP_Down1,'g','linewidth',2), plot(tmp_down1,mnLFP_Down2,'m','linewidth',2)
    subplot(2,2,2), plot(0.2:0.2:4,met_mua_deep(:,98),'ko-'), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,4), plot(0.2:0.2:4,nb_delta_deep,'ko-'), xl=xlim; line(xl,[nb_down1 nb_down1],'color','r'),  line(xl,[nb_down2 nb_down2],'color','r')


    figure('color',[1 1 1])
    subplot(2,2,1), plot(tmp,met_mua_sup,'r'), hold on, plot(tmp_down1,mnQ_Down1,'g','linewidth',2), plot(tmp_down1,mnQ_Down2,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,3), plot(tmp,met_lfp_sup,'r'), hold on, plot(tmp_down1,mnLFP_Down1,'g','linewidth',2), plot(tmp_down1,mnLFP_Down2,'m','linewidth',2)
    subplot(2,2,2), plot(0.2:0.2:4,met_mua_sup(:,86),'ko-'), yl=ylim; ylim([0 yl(2)])
    subplot(2,2,4), plot(0.2:0.2:4,nb_delta_sup,'ko-'), xl=xlim; line(xl,[nb_down1 nb_down1],'color','r'),  line(xl,[nb_down2 nb_down2],'color','r')
end 


%% Save all data in DataDeltaDetect 
if saving
    save DataDeltaDetect
end






