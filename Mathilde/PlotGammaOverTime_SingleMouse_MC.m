function [SpectroREM_start,SpectroREM_stim,SpectroWake_start,temps] = PlotGammaOverTime_SingleMouse_MC(plo)

try
    plo;
catch
    plo=0;
end

%% get data
load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
REMEp = mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load('B_High_Spectrum');
SpectroG=Spectro;
freqOB=Spectro{3};
sptsdOB= tsd(SpectroG{2}*1e4, SpectroG{1});

% to find optogenetic stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
events=Stim;

[M_start_rem,S_start_rem,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(Start(REMEp)),500,500,0);
[M_end_rem,S_end_rem,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(End(REMEp)),500,500,0);
[M_stim_rem,S_stim_rem,tps]=AverageSpectrogram(sptsdOB,freqOB,Restrict(ts(events*1E4),REMEp),500,500,0)

[M_start_sws,S_start_sws,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(Start(SWSEp)),500,500,0);
[M_end_sws,S_end_sws,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(End(SWSEp)),500,500,0);
[M_stim_sws,S_stim_sws,tps]=AverageSpectrogram(sptsdOB,freqOB,Restrict(ts(events*1E4),SWSEp),500,500,0);

[M_start_wake,S_start_wake,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(Start(WakeEp)),500,500,0);
[M_end_wake,S_end_wake,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(End(WakeEp)),500,500,0);
[M_stim_wake,S_stim_wake,tps]=AverageSpectrogram(sptsdOB,freqOB,Restrict(ts(events*1E4),WakeEp),500,500,0);




%%
% % average spectro triggered on
% [MG_wake,SG_wake,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(Start(WakeEp)),500,500,0);
% [MG_REM,SG_REM,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(End(REMEp)),500,500,0);
% [MG_SWS,SG_SWS,tps]=AverageSpectrogram(sptsdOB,freqOB,ts(End(SWSEp)),500,500,0);


% Normalisation
SpectroREMG=MG_REM/median(MG_REM(:));
SpectroSWSG=MG_SWS/median(MG_SWS(:));
SpectroWakeG=MG_wake/median(MG_wake(:));

% average spectro accross stims
% [MG_wake,SG_wake,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),WakeWiNoise),500,500,0);
% [MG_REM,SG_REM,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),REMEpochWiNoise),500,500,0);
% [MG_SWS,SG_SWS,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events*1E4),SWSEpochWiNoise),500,500,0);

runfac=4;
temps=tps/1E3;

idxFreq_gamma=find(freqOB>40&freqOB<60); % find gamma band
idxTps_gamma=find(temps>-15&temps<0); % restrict to speccific time window

facNormWake=mean(M_start_wake(idxFreq_gamma,:),1); % normalisation

SpectroREM_start = M_start_rem/median(facNormWake(:));
SpectroREM_stim = M_stim_rem/median(facNormWake(:));
SpectroWake_start = M_start_wake/median(facNormWake(:));

% SpectroREMG=MG_REM;
% SpectroSWSG=MG_SWS;
% SpectroWakeG=MG_wake;

valGammaREM_start = mean(SpectroREM_start(idxFreq_gamma,:),1);
valGammaREM_stim = mean(SpectroREM_stim(idxFreq_gamma,:),1);
valGammaWake_start = mean(SpectroWake_start(idxFreq_gamma,:),1);

%   valGammaWakeG=valGammaWakeG/median(valGammaWakeG);
%   valGammaSWSG=valGammaSWSG/median(valGammaWakeG);
%   valGammaREMG=valGammaREMG/median(valGammaWakeG);

facREM_start = mean(valGammaREM_start(idxTps_gamma));
facREM_stim = mean(valGammaREM_stim(idxTps_gamma));
facWake_start = mean(valGammaWake_start(idxTps_gamma));

stdfacREM_start = std(valGammaREM_start(idxTps_gamma));
stdfacREM_stim = std(valGammaREM_stim(idxTps_gamma));
stdfacWake_start = std(valGammaWake_start(idxTps_gamma));


if plo
    figure,
    subplot(321), imagesc(temps,freqOB, SpectroREM_start), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    set(gca,'FontSize', 14)

    subplot(323), imagesc(temps,freqOB, SpectroSWSG), axis xy,  colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    set(gca,'FontSize', 14)

    
    subplot(325), imagesc(temps,freqOB, SpectroWakeG), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    set(gca,'FontSize', 14)

    
    subplot(322),plot(temps,mean(SpectroREMG(idxFreq_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREMG(idxFreq_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREMG facREMG],'linewidth',1)
%     line([temps(1) temps(end)],[facREMG+stdfacREMG facREMG+stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREMG-stdfacREMG facREMG-stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(324),plot(temps,mean(SpectroSWSG(idxFreq_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroSWSG(idxFreq_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facSWSG facSWSG]/facSWSG,'linewidth',1)
%     line([temps(1) temps(end)],[facSWSG+stdfacSWSG facSWSG+stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facSWSG-stdfacSWSG facWakeG-stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(326),plot(temps,mean(SpectroWakeG(idxFreq_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWakeG(idxFreq_gamma,:),1),runfac),'k','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facWakeG facWakeG]/facWakeG,'linewidth',1)
%     line([temps(1) temps(end)],[facWakeG+stdfacWakeG facWakeG+stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facWakeG-stdfacWakeG facWakeG-stdfacWakeG]/facWakeG,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 14)
    
end
