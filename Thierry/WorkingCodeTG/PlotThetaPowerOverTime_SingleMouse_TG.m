function [SpREM,SpSWS,SpWake,temps] = PlotThetaPowerOverTime_SingleMouse_MC(plo)

try
    plo;
catch
    plo=0;
end
load SleepScoring_OBGamma.mat
load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise', 'LowThetaEpochMC');
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load('H_Low_Spectrum');
SpectroH=Spectro;
freqH=Spectro{3};
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});

% to find optogenetic stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
events=Stim;

% %average spectro accross stims
%%ChangeThetaThresh_MC pour changer le seuil theta pendant eveil
% [MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),and(WakeWiNoise,LowThetaEpochMC)),500,500,0);
% [MH_REM,SH_REM,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
% [MH_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);

[MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(Start(WakeEp)),and(WakeEp,LowThetaEpochMC)),500,500,0);
[MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(End(WakeEp)),WakeEp),500,500,0);
[MH_REM,SH_REM,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(End(REMEp)),REMEp),500,500,0);
[MH_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(End(SWSEp)),SWSEp),500,500,0);

% SpREM=MH_REM;
% SpSWS=MH_SWS;
% SpWake=MH_wake;

SpREM=MH_REM/median(MH_REM(:)); % normalisation
SpSWS=MH_SWS/median(MH_SWS(:));
SpWake=MH_wake/median(MH_wake(:));

runfac=4;
temps=tps/1E3;

freq=[1:size(SpREM,1)]/size(SpREM,1)*20;
% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;

idx1=find(freq>6&freq<9);
tpsidx=find(temps>-15&temps<0);

valThetaREM=mean(SpREM(idx1,:),1);
valThetaSWS=mean(SpSWS(idx1,:),1);
valThetaWake=mean(SpWake(idx1,:),1);

facREM=mean(valThetaREM(tpsidx));
facSWS=mean(valThetaSWS(tpsidx));
facWake=mean(valThetaWake(tpsidx));

stdfacREM=std(valThetaREM(tpsidx));
stdfacSWS=std(valThetaSWS(tpsidx));
stdfacWake=std(valThetaWake(tpsidx));

if plo
    figure,
    subplot(321), imagesc(temps,freq, SpREM), axis xy, colormap(jet),caxis([0 3])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC REM')
    subplot(323), imagesc(temps,freq, SpSWS), axis xy,  colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC NREM')
    subplot(325), imagesc(temps,freq, SpWake), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('HPC Wake')
    
    subplot(322),plot(temps,mean(SpREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
    line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
    subplot(324),plot(temps,mean(SpSWS(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpSWS(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
    line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
    subplot(326),plot(temps,mean(SpWake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpWake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
    line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
    line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
    line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
    ylim([0.2 1.4])
    ylabel('theta power')
    line([0 0], ylim,'color','k','linestyle',':')
end
