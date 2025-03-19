load('SleepScoring_OBGamma.mat', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise');

SleepStages = PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0); %close

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
% StimWithLongBout = FindOptoStimWithLongBout_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,'rem', 0);

SpectroV = load('PFCx_deep_Low_Spectrum.mat');
SpectroH = load('dHPC_deep_Low_Spectrum.mat');

[MV_wake,SV_wake,tV_wake]=AverageSpectrogram(tsd(SpectroV.Spectro{2}*1E4,10*log10(SpectroV.Spectro{1})),SpectroV.Spectro{3},ts(StimWake),500,300,0);
[MV_sws,SV_sws,tV_sws]=AverageSpectrogram(tsd(SpectroV.Spectro{2}*1E4,10*log10(SpectroV.Spectro{1})),SpectroV.Spectro{3},ts(StimSWS),500,300,0);
[MV_rem,SV_rem,tV_rem]=AverageSpectrogram(tsd(SpectroV.Spectro{2}*1E4,10*log10(SpectroV.Spectro{1})),SpectroV.Spectro{3},ts(StimREM),500,300,0);

[MH_wake,SH_wake,tH_wake]=AverageSpectrogram(tsd(SpectroH.Spectro{2}*1E4,10*log10(SpectroH.Spectro{1})),SpectroH.Spectro{3},ts(StimWake),500,300,0);
[MH_sws,SH_sws,tH_sws]=AverageSpectrogram(tsd(SpectroH.Spectro{2}*1E4,10*log10(SpectroH.Spectro{1})),SpectroH.Spectro{3},ts(StimSWS),500,300,0);
[MH_rem,SH_rem,tH_rem]=AverageSpectrogram(tsd(SpectroH.Spectro{2}*1E4,10*log10(SpectroH.Spectro{1})),SpectroH.Spectro{3},ts(StimREM),500,300,0);

[h_wake,rg_wake,vec_wake] = HistoSleepStagesTransitionsMathilde_MC(SleepStages, ts(StimWake), -60:60, 0);
[h_sws,rg_sws,vec_sws] = HistoSleepStagesTransitionsMathilde_MC(SleepStages, ts(StimSWS), -60:60, 0);
[h_rem,rg_rem,vec_rem] = HistoSleepStagesTransitionsMathilde_MC(SleepStages, ts(StimREM), -60:60, 0);



%%
figure,

subplot(4,3,[1,2,3]), SleepStages = PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0);
hold on, 
plot([StimSWS/1e4 StimSWS/1e4], [4.5 4.5], 'b*')
if isempty(StimWake)==0
plot([StimWake/1e4 StimWake/1e4], [4.5 4.5], 'k*')
else
end
if isempty(StimREM)==0
plot([StimREM/1e4 StimREM/1e4], [4.5 4.5], 'r*')
else
end
title(['stim Wake =', num2str(length(StimWake)), 'stim NREM =', num2str(length(StimSWS)),'stim REM =', num2str(length(StimREM))])

subplot(434), imagesc(tV_wake/1e3,[1:20],MV_wake), axis xy, title(['stim Wake =', num2str(length(StimWake))]), line([0 0],ylim,'color','w'),ylabel('VLPO')
subplot(435), imagesc(tV_sws/1e3,[1:20],MV_sws), axis xy, title(['stim NREM =', num2str(length(StimSWS))]), line([0 0],ylim,'color','w')
subplot(436), imagesc(tV_rem/1e3,[1:20],MV_rem), axis xy, title(['stim REM =', num2str(length(StimREM))]), line([0 0],ylim,'color','w')


subplot(437), imagesc(tH_wake/1e3,[1:20],MH_wake), axis xy, title(['stim Wake =', num2str(length(StimWake))]), line([0 0],ylim,'color','w'),ylabel('HPC')
subplot(438), imagesc(tH_sws/1e3,[1:20],MH_sws), axis xy, title(['stim NREM =', num2str(length(StimSWS))]), line([0 0],ylim,'color','w')
subplot(439), imagesc(tH_rem/1e3,[1:20],MH_rem), axis xy, title(['stim REM =', num2str(length(StimREM))]), line([0 0],ylim,'color','w')

subplot(4,3,10), hold on
plot(vec_wake, h_wake(:,1))
plot(vec_wake, h_wake(:,2))
plot(vec_wake, h_wake(:,3)), line([0 0],ylim,'color','k')

subplot(4,3,11), hold on
plot(vec_sws, h_sws(:,1))
plot(vec_sws, h_sws(:,2))
plot(vec_sws, h_sws(:,3)), line([0 0],ylim,'color','k')

subplot(4,3,12), hold on
plot(vec_rem, h_rem(:,1))
plot(vec_rem, h_rem(:,2))
plot(vec_rem, h_rem(:,3)), line([0 0],ylim,'color','k')
legend({'WAKE','REM','NREM'})