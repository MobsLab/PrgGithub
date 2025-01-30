function [SpREM,SpSWS,SpWake,temps] = PlotThetaPowerAroundStim_SingleMouse_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,LowThetaEpochMC,stimulations,plo)

% INPUT
% stim : 

try
    plo;
catch
    plo=0;
end

%% merge close REM epoch
% REMEpochWiNoise = mergeCloseIntervals(REMEpochWiNoise,1E4);
% SWSEpochWiNoise = SWSEpochWiNoise - REMEpochWiNoise;
% WakeWiNoise = WakeWiNoise - REMEpochWiNoise;

%% load HPC sp
load('H_Low_Spectrum');
SpectroH=Spectro;
freqH=Spectro{3};
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});

%compute average sp triggered on stim in each state
[MH_wake,SH_wake,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(stimulations),and(WakeWiNoise,LowThetaEpochMC)),500,500,0);
[MH_REM,SH_REM,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(stimulations),REMEpochWiNoise),500,500,0);
[MH_SWS,SH_SWS,tps]=AverageSpectrogram(sptsdH,freqH,Restrict(ts(stimulations),SWSEpochWiNoise),500,500,0);


% SpREM=MH_REM; 
% SpSWS=MH_SWS;
% SpWake=MH_wake;


% normalisation
SpREM=MH_REM/median(MH_REM(:)); 
SpSWS=MH_SWS/median(MH_SWS(:));
SpWake=MH_wake/median(MH_wake(:));

%% parameters to plot figure
runfac=4;
temps=tps/1E3;

freq=[1:size(SpREM,1)]/size(SpREM,1)*20;

%get theta band
idx1=find(freq>6&freq<9);
%get 15s before stim
tpsidx=find(temps>-15&temps<0);

%get mean value in the theta frequency range 
valThetaREM=mean(SpREM(idx1,:),1);
valThetaSWS=mean(SpSWS(idx1,:),1);
valThetaWake=mean(SpWake(idx1,:),1);
%plot line for average theta (in the time window before stim)
facREM=mean(valThetaREM(tpsidx));
facSWS=mean(valThetaSWS(tpsidx));
facWake=mean(valThetaWake(tpsidx));
%plot std around the mean
stdfacREM=std(valThetaREM(tpsidx));
stdfacSWS=std(valThetaSWS(tpsidx));
stdfacWake=std(valThetaWake(tpsidx));

%% figure
if plo
    figure,
    subplot(321), imagesc(temps,freq, SpREM), axis xy, colormap(jet) %,caxis([0 3])
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
