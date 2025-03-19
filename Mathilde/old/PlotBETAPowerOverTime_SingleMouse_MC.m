function [SpREM,facREM,BetaIdxRem,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_MC(plo)

try
    plo;
catch
    plo=0;
end

load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load Bulb_deep_Low_Spectrum
SpectroB=Spectro;
freqB=Spectro{3};
sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});

% clear datOBnew
% datOB = Spectro{1};
% for k = 1:size(datOB,2)
%     datOBnew(:,k) = runmean(datOB(:,k),500); % to smooth the high freq spectro
% end
% sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd


[Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(WakeEp, SWSEp, REMEp); % to find optogenetic stimulations
events=Stim;

[MB_REM,SB_REM,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),REMEp),500,500,0);
% [MB_SWS,SB_SWS,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),SWSEp),500,500,0);
% [MB_wake,SB_wake,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(events*1E4),WakeEp),500,500,0);

SpREM=MB_REM;
% SpectroBsws=MB_SWS;
% SpectroBwake=MB_wake;

% SpectroBrem=MB_REM/median(MB_REM(:));
% SpectroBsws=MB_SWS/median(MB_SWS(:));
% SpectroBwake=MB_wake/median(MB_wake(:));


% SpectroBrem=MB_REM/mean(MB_REM(1:floor(length(MB_REM))/2))*100;
% SpectroBsws=MB_SWS/mean(MB_SWS(1:floor(length(MB_SWS))/2))*100;
% SpectroBwake=MB_wake/mean(MB_wake(1:floor(length(MB_wake))/2))*100;


runfac=4;
temps=tps/1E3;

% freqS=[1:size(SpectroSWS,1)]/size(SpectroSWS,1)*20;
% freqW=[1:size(SpectroWake,1)]/size(SpectroWake,1)*20;


freqB=[1:size(SpREM,1)]/size(SpREM,1)*20;

% idx1=find(freqB>10&freqB<30);

betaIdx1=find(freqB>10&freqB<15);
betaIdx2=find(freqB>25&freqB<30);
idxBetaREM=betaIdx1+betaIdx2;


betaIdx1=find(freqB>10&freqB<15);
betaIdx2=find(freqB>25&freqB<30);
% idx1=find(freqB>15&freqB<19);

tpsidx=find(temps>-15&temps<0);



% ratio=mean(SpectroREM(idx1,:),1)./mean(SpectroREM(idx2,:),1);
BetaIdxRem=mean(SpREM(idxBetaREM,:),1);
% idxBetaREM2=mean(SpREM(betaIdx2,:),1);
% valBetaSWS=mean(SpectroBsws(idx1,:),1);
% valBetaWake=mean(SpectroBwake(idx1,:),1);

facREM=mean(BetaIdxRem(tpsidx));

% facSWS=mean(valBetaSWS(tpsidx));
% facWake=mean(valBetaWake(tpsidx));

% stdfacREM=std(valBetaREM(tpsidx));
% stdfacSWS=std(valBetaSWS(tpsidx));
% stdfacWake=std(valBetaWake(tpsidx));

if plo
    
    figure('color',[1 1 1]),
    subplot(321), imagesc(temps,freqB, SpREM), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    subplot(323), imagesc(temps,freqB, SpectroBsws), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB NREM')
    subplot(325), imagesc(temps,freqB, SpectroBwake), axis xy,colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-60 +60])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB Wake')
    
    
    subplot(322),plot(temps,mean(SpREM(idx1,:),1)/facREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpREM(idx1,:),1)/facREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facREM facREM]/facREM,'linewidth',1)
%     line([temps(1) temps(end)],[facREM+stdfacREM facREM+stdfacREM]/facREM,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facREM-stdfacREM facREM-stdfacREM]/facREM,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(324),plot(temps,mean(SpectroBsws(idx1,:),1)/facSWS,'r','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBsws(idx1,:),1)/facSWS,runfac),'r','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facSWS facSWS]/facSWS,'linewidth',1)
%     line([temps(1) temps(end)],[facSWS+stdfacSWS facSWS+stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facSWS-stdfacSWS facSWS-stdfacSWS]/facSWS,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
    subplot(326),plot(temps,mean(SpectroBwake(idx1,:),1)/facWake,'b','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(mean(SpectroBwake(idx1,:),1)/facWake,runfac),'b','linewidth',2), xlim([temps(1) temps(end)])
%     line([temps(1) temps(end)],[facWake facWake]/facWake,'linewidth',1)
%     line([temps(1) temps(end)],[facWake+stdfacWake facWake+stdfacWake]/facWake,'linestyle',':','linewidth',1)
%     line([temps(1) temps(end)],[facWake-stdfacWake facWake-stdfacWake]/facWake,'linestyle',':','linewidth',1)
    xlim([-30 +30])
    xlabel('time (s)')
%     ylim([0.4 1.5])
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
    
end