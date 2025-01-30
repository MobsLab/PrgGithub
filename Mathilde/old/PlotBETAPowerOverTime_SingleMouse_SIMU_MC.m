function [SpectroBREMsimu,SpectroBSWSsimu,SpectroBWAKEsimu,facREM,facSWS,facWake,valBetaREM,valBetaSWS,valBetaWake,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_SIMU_MC(plo)

try
    plo;
catch
    plo=0;
end

load SleepScoring_OBGamma REMEpoch SWSEpoch Wake 
load Bulb_deep_High_Spectrum
% load Bulb_deep_High_Spectrum
SpectroB=Spectro;
freqB=Spectro{3};

clear datOBnew
datOB = Spectro{1};
for k = 1:size(datOB,2)
    datOBnew(:,k) = runmean(datOB(:,k),500); % to smooth the high freq spectro
end

sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd


load SimulatedStims RemStim SwsStim WakeStim % load simulated stimulation (for baseline recording)


% compute average spectrograms for each state
[MB_wake,SB_wake,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(WakeStim,Wake),500,500,0);
[MB_REM,SB_REM,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(RemStim,REMEpoch),500,500,0);
[MB_SWS,SB_SWS,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(SwsStim,SWSEpoch),500,500,0);


SpectroBREMsimu=MB_REM;
SpectroBSWSsimu=MB_SWS;
SpectroBWAKEsimu=MB_wake;

% SpectroBREMsimu=MB_REM/median(MB_REM(:)); % if you want to normalized spectro
% SpectroBSWSsimu=MB_SWS/median(MB_SWS(:));
% SpectroBWAKEsimu=MB_wake/median(MB_wake(:));


runfac=4;
temps=tps/1E3;

idx1=find(freqB>21&freqB<25); % get beta frequancy band
tpsidx=find(temps>-30&temps<0);

valBetaREM=mean(SpectroBREMsimu(idx1,:),1);
valBetaSWS=mean(SpectroBSWSsimu(idx1,:),1);
valBetaWake=mean(SpectroBWAKEsimu(idx1,:),1);

facREM=mean(valBetaREM(tpsidx));
facSWS=mean(valBetaSWS(tpsidx));
facWake=mean(valBetaWake(tpsidx));

stdfacREM=std(valBetaREM(tpsidx));
stdfacSWS=std(valBetaSWS(tpsidx));
stdfacWake=std(valBetaWake(tpsidx));


if plo
    
    figure('color',[1 1 1]),
    subplot(321), imagesc(temps,freqB, SpectroBREMsimu), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    subplot(323), imagesc(temps,freqB, SpectroBSWSsimu), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    subplot(325), imagesc(temps,freqB, SpectroBWAKEsimu), axis xy,colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    
    
    subplot(322),plot(temps,mean(SpectroBREMsimu(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBREMsimu(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(324),plot(temps,mean(SpectroBSWSsimu(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBSWSsimu(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
%     line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(326),plot(temps,mean(SpectroBWAKEsimu(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBWAKEsimu(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
%     line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
end