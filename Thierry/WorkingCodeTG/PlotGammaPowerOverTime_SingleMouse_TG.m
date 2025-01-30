function [SpectroREMG,SpectroSWSG,SpectroWakeG,temps] = PlotGammaPowerOverTime_SingleMouse_TG(WakeWiNoise, REMEpochWiNoise, SWSEpochWiNoise,plo)

try
    plo;
catch
    plo=0;
end

%load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');
REMEp = mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load('B_High_Spectrum');
%load('Bulb_deep_High_Spectrum');
SpectroG=Spectro;
freqG=Spectro{3};
sptsdG= tsd(SpectroG{2}*1e4, SpectroG{1});

% to find optogenetic stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
events=Stim;


% %average spectro Start/End stims
% [MG_wake,SG_wake,tps]=AverageSpectrogram(sptsdG,freqG,ts(Start(WakeEp)),500,500,0);
% [MG_REM,SG_REM,tps]=AverageSpectrogram(sptsdG,freqG,ts(End(REMEp)),500,500,0);
% [MG_SWS,SG_SWS,tps]=AverageSpectrogram(sptsdG,freqG,ts(End(SWSEp)),500,500,0);

% [MG_wake,SG_wake,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(Start(WakeEp)),WakeEp),500,500,0);
% [MG_REM,SG_REM,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(End(REMEp)),REMEp),500,500,0);
% [MG_SWS,SG_SWS,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(End(SWSEp)),SWSEp),500,500,0);

% SpREM=MH_REM;
% SpSWS=MH_SWS;
% SpWake=MH_wake;



%average spectro accross stims
[MG_wake,SG_wake,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events),WakeWiNoise), 500,500,0);%ne pas multiplier par 1E4 car déja fait dans "FindOptoStim"
[MG_REM,SG_REM,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events),REMEpochWiNoise),500,500,0);
[MG_SWS,SG_SWS,tps]=AverageSpectrogram(sptsdG,freqG,Restrict(ts(events),SWSEpochWiNoise),500,500,0);

runfac=4;
temps=tps/1E3;

freq=freqG;
freqS=freqG;
freqW=freqG;

idx1_gamma=find(freq>40&freq<60);
tpsidx_gamma=find(temps>-15&temps<0);

facnormwake=mean(MG_wake(idx1_gamma,:),1);

%Normalisation
SpectroREMG=MG_REM/median(facnormwake(:));
SpectroSWSG=MG_SWS/median(facnormwake(:));
SpectroWakeG=MG_wake/median(facnormwake(:));

% SpectroREMG=MG_REM/median(MG_REM(:));
% SpectroSWSG=MG_SWS/median(MG_SWS(:));
% SpectroWakeG=MG_wake/median(MG_wake(:));

freqG=[1:size(SpectroREMG,1)]/size(SpectroREMG,1)*100;


% SpectroREMG=MG_REM;
% SpectroSWSG=MG_SWS;
% SpectroWakeG=MG_wake;

valGammaREMG=mean(SpectroREMG(idx1_gamma,:),1);
valGammaSWSG=mean(SpectroSWSG(idx1_gamma,:),1);
valGammaWakeG=mean(SpectroWakeG(idx1_gamma,:),1);

%   valGammaWakeG=valGammaWakeG/median(valGammaWakeG);
%   valGammaSWSG=valGammaSWSG/median(valGammaWakeG);
%   valGammaREMG=valGammaREMG/median(valGammaWakeG);

facREMG=mean(valGammaREMG(tpsidx_gamma));
facSWSG=mean(valGammaSWSG(tpsidx_gamma));
facWakeG=mean(valGammaWakeG(tpsidx_gamma));

stdfacREMG=std(valGammaREMG(tpsidx_gamma));
stdfacSWSG=std(valGammaSWSG(tpsidx_gamma));
stdfacWakeG=std(valGammaWakeG(tpsidx_gamma));


if plo
    figure,
    subplot(321), imagesc(temps,freqG, SpectroREMG), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    set(gca,'FontSize', 14)

    subplot(323), imagesc(temps,freqG, SpectroSWSG), axis xy,  colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    set(gca,'FontSize', 14)

    
    subplot(325), imagesc(temps,freqG, SpectroWakeG), axis xy, colormap(jet), caxis([0 2])
    line([0 0], ylim,'color','w','linestyle',':')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    set(gca,'FontSize', 14)

    
    subplot(322),plot(temps,mean(SpectroREMG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroREMG(idx1_gamma,:),1),runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREMG facREMG],'linewidth',1)
%     line([temps(1) temps(end)],[facREMG+stdfacREMG facREMG+stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREMG-stdfacREMG facREMG-stdfacREMG],facWakeW,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(324),plot(temps,mean(SpectroSWSG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroSWSG(idx1_gamma,:),1),runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facSWSG facSWSG]/facSWSG,'linewidth',1)
%     line([temps(1) temps(end)],[facSWSG+stdfacSWSG facSWSG+stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facSWSG-stdfacSWSG facWakeG-stdfacSWSG]/,facWakeS,'linestyle',':','linewidth',1)
    xlim([-10 +30])
    xlabel('time (s)')
    ylim([0 1.5])
    ylabel('Gamma power')
    line([0 0], ylim,'color','w','linestyle',':')
    set(gca,'FontSize', 14)
    
    subplot(326),plot(temps,mean(SpectroWakeG(idx1_gamma,:),1),'k','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroWakeG(idx1_gamma,:),1),runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
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
