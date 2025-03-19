% function [SpREM,idxBetaREM,facREM,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_MC2(plo)
function [SpWake,idxBetaWake,facWake,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_MC2(plo)

try
    plo;
catch
    plo=0;
end

%% load data
load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load Bulb_deep_Low_Spectrum
SpectroB=Spectro;
freqB=Spectro{3};
sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});

%to smooth the high freq spectro
% clear datOBnew
% datOB = Spectro{1};
% for k = 1:size(datOB,2)
%     datOBnew(:,k) = runmean(datOB(:,k),500);
% end
% sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd

%% find optogenetic stimulations
Stim=FindOptoStim_MC;

%% compute average spectro
% [MB_REM,SB_REM,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(Stim*1E4),REMEp),500,500,0);
% [MB_SWS,SB_SWS,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(Stim*1E4),SWSEp),500,500,0);
[MB_Wake,SB_Wake,tps]=AverageSpectrogram(sptsdB,freqB,Restrict(ts(Stim*1E4),WakeEp),500,500,0);

% SpREM=MB_REM;

%if you want to normalized the spectro
% SpREM=MB_REM/median(MB_REM(:));
SpWake=MB_Wake/median(MB_Wake(:));

% SpectroBrem=MB_REM/mean(MB_REM(1:floor(length(MB_REM))/2))*100;

%% find indexes to get the frequency band you want
% betaIdx1=nanmean(SpREM(freqB>10&freqB<15,:),1);
% betaIdx2=nanmean(SpREM(freqB>25&freqB<31,:),1);
% idxBetaREM=betaIdx1+betaIdx2;

betaIdx1=nanmean(SpWake(freqB>10&freqB<15,:),1);
betaIdx2=nanmean(SpWake(freqB>25&freqB<31,:),1);
idxBetaWake=betaIdx1+betaIdx2;
%% find index to get the time window you want
runfac=4;
temps=tps/1E3;
tpsidx=find(temps>0&temps<30);
% facREM=mean(idxBetaREM(tpsidx));
facWake=mean(idxBetaWake(tpsidx));

%% plot
if plo
    figure('color',[1 1 1]),
    subplot(211), imagesc(temps,freqB, log(SpREM)), axis xy, colormap(jet)
    line([0 0], ylim,'color','w','linestyle','-')
    xlim([-30 +30])
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    colorbar
    title('OB REM')
    subplot(212),plot(temps,idxBetaREM,'g','linewidth',1,'linestyle',':'), xlim([temps(1) temps(end)])
    plot(temps,runmean(idxBetaREM,runfac),'g','linewidth',2), xlim([temps(1) temps(end)])
    xlim([-30 +30])
    xlabel('time (s)')
    ylabel('beta power')
    line([0 0], ylim,'color','k','linestyle',':')
end
end
