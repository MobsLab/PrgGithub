function [SpectroREMsimu,SpectroSWSsimu,SpectroWakesimu,facREM,facSWS,facWake,valThetaREM,valThetaSWS,valThetaWake,freq,temps] = PlotThetaPowerOverTime_SingleMouse_SIMU_MC(plo)

try
    plo;
catch
    plo=0;
end

load SleepScoring_OBGamma REMEpoch SWSEpoch Wake LowThetaEpochMC
load H_Low_Spectrum
SpectroH=Spectro;
freqH=Spectro{3};
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});

load SimulatedStims RemStim SwsStim WakeStim % load SIMULATED stims (for baseline recordings)


[MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(WakeStim,and(Wake,LowThetaEpochMC)),500,500,0);
[MH_REM,SH_REM,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(RemStim,REMEpoch),500,500,0);
[MH_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(SwsStim,SWSEpoch),500,500,0);

SpectroREMsimu=MH_REM/median(MH_REM(:));
SpectroWakesimu=MH_wake/median(MH_wake(:));
SpectroSWSsimu=MH_SWS/median(MH_SWS(:));

% other way to normalized spectro
% SpectroREMsimu=MH_REM/mean(MH_REM(1:floor(length(MH_REM))/2))*100;
% SpectroSWSsimu=MH_SWS/mean(MH_SWS(1:floor(length(MH_SWS))/2))*100;
% SpectroWakesimu=MH_wake/mean(MH_wake(1:floor(length(MH_wake))/2))*100;


runfac=4;
temps=tps/1E3;

freq=[1:size(SpectroREMsimu,1)]/size(SpectroREMsimu,1)*20;

idx1=find(freq>6&freq<9);
tpsidx=find(temps>-30&temps<0);

% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
valThetaREM=mean(SpectroREMsimu(idx1,:),1);
valThetaSWS=mean(SpectroSWSsimu(idx1,:),1);
valThetaWake=mean(SpectroWakesimu(idx1,:),1);

facREM=mean(valThetaREM(tpsidx));
facSWS=mean(valThetaSWS(tpsidx));
facWake=mean(valThetaWake(tpsidx));

stdfacREM=std(valThetaREM(tpsidx));
stdfacSWS=std(valThetaSWS(tpsidx));
stdfacWake=std(valThetaWake(tpsidx));

if plo
    
    figure('color',[1 1 1]),
    subplot(321), imagesc(temps,freq, SpectroREMsimu), axis xy, caxis([0 3]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC REM')
    subplot(323), imagesc(temps,freq, SpectroSWSsimu), axis xy, caxis([0 3]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC NREM')
    subplot(325), imagesc(temps,freq, SpectroWakesimu), axis xy, caxis([0 3]), colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC Wake')
    
    
    subplot(322),plot(temps,mean(SpectroREMsimu(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREMsimu(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(324),plot(temps,mean(SpectroSWSsimu(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroSWSsimu(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(326),plot(temps,mean(SpectroWakesimu(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWakesimu(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
end