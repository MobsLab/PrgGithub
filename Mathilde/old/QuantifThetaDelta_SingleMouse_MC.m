
load ExpeInfo
load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
[Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch);
% load H_Low_Spectrum
load PFCx_deep_Low_Spectrum
SpectroP= Spectro;

freq=SpectroP{3};
sptsd= tsd(SpectroP{2}*1e4, SpectroP{1});

[MSws,SSws,TPS]=AverageSpectrogram(sptsd,freq,(Restrict(ts(Stim*1E4),SWSEpoch)),500,500,0);
[MRem,SRem,TPS]=AverageSpectrogram(sptsd,freq,(Restrict(ts(Stim*1E4),REMEpoch)),500,500,0);
[MWake,SWake,TPS]=AverageSpectrogram(sptsd,freq,(Restrict(ts(Stim*1E4),Wake)),500,500,0);

% 
% for f=1:length(freq)
%     for evS=1:length(StimSWS)
%         [MatSWS(f,evS,:),S_SWS(f,evS,:),tps]=mETAverage(StimSWS(evS),Range(sptsd),SpectroH{1}(:,f),1000,1000);
%     end
%     for evR=1:length(StimREM)
%         [MatREM(f,evR,:),S_REM(f,evR,:),tps]=mETAverage(StimREM(evR),Range(sptsd),SpectroH{1}(:,f),1000,1000); % trigger each line (frequency) of the spectrum on events
%     end
%     for evW=1:length(StimWake)
%         [MatWake(f,evW,:),S_wake(f,evW,:),tps]=mETAverage(StimWake(evW),Range(sptsd),SpectroH{1}(:,f),1000,1000);
%     end
%     
% end
% 
% ThetaSWS=squeeze(nanmean(MatSWS(find(freq<10&freq>5),:,:),1));   % frequency band average to get the theta
% ThetaREM=squeeze(nanmean(MatREM(find(freq<10&freq>5),:,:),1));
% ThetaWake=squeeze(nanmean(MatWake(find(freq<10&freq>5),:,:),1));
% 
% DeltaSWS=squeeze(nanmean(MatSWS(find(freq<4&freq>1),:,:)));      % frequency band average  to get the delta
% DeltaREM=squeeze(nanmean(MatREM(find(freq<4&freq>1),:,:)));
% DeltaWake=squeeze(nanmean(MatWake(find(freq<4&freq>1),:,:)));      % frequency band average  to get the delta
% 
% RatioSWS=ThetaSWS./DeltaSWS;        % compute average theta / delta RATIO
% RatioREM=ThetaREM./DeltaREM;        
% RatioWake=ThetaWake./DeltaWake;
% 
% sousSWS=ThetaSWS-DeltaSWS;           % compute average theta power - delta power
% sousREM=ThetaREM-DeltaREM;
% souWake=ThetaWake-DeltaWake;
% 
% 
% T=tps/1E3;                              % to define time window before and during the stim
% BeforeStim=find(T>-10&T<0);
% DuringStim=find(T>0&T<10);


%% Plot theta power and theta/delta power during the stim
% Average spectro of the HPC during REM sleep and Wake
figure, subplot(311),imagesc(TPS/1E3,freq,MRem), axis xy
colormap(jet)
caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-50 +50])
ylim([0 +20])
title('HPC REM')

subplot(312), imagesc(TPS/1E3,freq,MSws), axis xy
colormap(jet)
caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-50 +50])
ylim([0 +20])
title('HPC NREM')

subplot(313), imagesc(TPS/1E3,freq,MWake), axis xy
colormap(jet)
caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-50 +50])
ylim([0 +20])
title('HPC Wake')
%%
% theta quantifications during the stims
subplot(6,5,[16,17]), shadedErrorBar(tps/1E3,ThetaWake,{@mean,@stdError},'-b',1);
hold on
shadedErrorBar(tps/1E3,ThetaSWS,{@mean,@stdError},'-r',1);
shadedErrorBar(tps/1E3,ThetaREM,{@mean,@stdError},'-g',1);
line([0 0], ylim,'color','k','linestyle',':')
ylabel('Theta power')
% xlabel('Times (s)')
ylim([4.5e+03 4e+04])
xlim([-10 +10])
subplot(6,5,[21,22]), shadedErrorBar(tps/1E3,2*log(RatioWake),{@mean,@stdError},'-b',1);
hold on
shadedErrorBar(tps/1E3,2*log(RatioREM),{@mean,@stdError},'-g',1);
shadedErrorBar(tps/1E3,2*log(RatioSWS),{@mean,@stdError},'-r',1);
line([0 0], ylim,'color','k','linestyle',':')
ylabel('Theta/Delta (log)')
% xlabel('Times (s)')
xlim([-10 +10])
ylim([-4 +6])
subplot(6,5,[26,27]), shadedErrorBar(tps/1E3,souWake,{@mean,@stdError},'-b',1);
hold on
shadedErrorBar(tps/1E3,sousREM,{@mean,@stdError},'-g',1);
shadedErrorBar(tps/1E3,sousSWS,{@mean,@stdError},'-r',1);
line([0 0], ylim,'color','k','linestyle',':')
ylabel('Theta - Delta')
xlabel('Times (s)')
xlim([-10 +10])
ylim([-7.5e04 +4.5e04])
% legend('Wake','','','','REM','','location','northeastoutside')

% bar plot theta power before VS during the stim
subplot(6,5,18),PlotErrorBar2(mean(ThetaREM(:,BeforeStim),2),mean(ThetaREM(:,DuringStim),2),0);
ylabel('Theta power')
ylim([0 5e+04])
xticks(1:2)
xticklabels({'Before stim','During stim'});
title('REM')
subplot(6,5,19), PlotErrorBar2(mean(ThetaSWS(:,BeforeStim),2),mean(ThetaSWS(:,DuringStim),2),0);
ylabel('Theta power')
ylim([0 5e+04])
xticks(1:2)
xticklabels({'Before stim','During stim'});
title('NREM')
subplot(6,5,20), PlotErrorBar2(mean(ThetaWake(:,BeforeStim),2),mean(ThetaWake(:,DuringStim),2),0);
ylabel('Theta power')
ylim([0 5e+04])
xticks(1:2)
xticklabels({'Before stim','During stim'});
title('Wake')

% bar plot theta/delta power before VS during the stim
subplot(6,5,23),PlotErrorBar2(mean(RatioREM(:,BeforeStim),2),mean(RatioREM(:,DuringStim),2),0);
ylabel('Theta/Delta power')
ylim([0 9])
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('REM')
subplot(6,5,24), PlotErrorBar2(mean(RatioSWS(:,BeforeStim),2),mean(RatioSWS(:,DuringStim),2),0);
ylabel('Theta/Delta power')
ylim([0 9])
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('NREM')
subplot(6,5,25), PlotErrorBar2(mean(RatioWake(:,BeforeStim),2),mean(RatioWake(:,DuringStim),2),0);
ylabel('Theta/Delta power')
ylim([0 9])
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('Wake')

% bar plot theta - delta power before VS during the stim
subplot(6,5,28),PlotErrorBar2(mean(sousREM(:,BeforeStim),2),mean(sousREM(:,DuringStim),2),0);
ylim([-5e04 5e+04])
ylabel('Theta - Delta power')
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('REM')
subplot(6,5,29), PlotErrorBar2(mean(sousSWS(:,BeforeStim),2),mean(sousSWS(:,DuringStim),2),0);
ylabel('Theta - Delta power')
ylim([-5e04 5e+04])
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('NREM')
subplot(6,5,30), PlotErrorBar2(mean(souWake(:,BeforeStim),2),mean(souWake(:,DuringStim),2),0);
ylabel('Theta - Delta power')
ylim([-5e04 5e+04])
xticks(1:2)
xticklabels({'Before stim','During stim'});
% title('Wake')

suptitle([' ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
