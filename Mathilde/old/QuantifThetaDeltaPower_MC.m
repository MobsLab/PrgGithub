
Dir{2}=PathForExperiments_Opto('Stim_20Hz');
number = 1;
for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    epREM{i}=REMEpoch;
    epWake{i}=Wake;
    epSWS{i}=SWSEpoch;
    load H_Low_Spectrum
    SpectroH{i}=Spectro;
    sptsdH(i)= tsd(SpectroH{i}{2}*1e4, SpectroH{i}{1});
    
    [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
    events{i}=Stim;
    eventsSWS{i}=StimSWS;
    eventsREM{i}=StimREM;
    eventsWake{i}=StimWake;

    % compute average spectrograms for each mouse
    [Mrem{i},Srem{i},TPS]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1e4),epREM{i}),500,500,0);
    [Msws{i},Ssws{i},TPS]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1e4),epSWS{i}),500,500,0);
    [Mwake{i},Swake{i},TPS]=AverageSpectrogram(sptsdH(i),SpectroH{i}{3},Restrict(ts(events{i}*1e4),epWake{i}),500,500,0);

    dataMwake=cat(3,Mwake{:});   % convert cell arrays in 3D arrays (third dimension being mice)              
    dataMrem=cat(3,Mrem{:});
    dataMsws=cat(3,Msws{:});
    avdataMwake=nanmean(dataMwake,3);   % compute average spectro across the third dimension
    avdataMsws=nanmean(dataMsws,3);
    avdataMrem=nanmean(dataMrem,3);
       
    % trigger each line (frequencies) of the spectro on events(=stims)
    for f=1:length(SpectroH{i}{3})
        for evS=1:length(eventsSWS{i})
            [MatSWS{number}(f,evS,:),S_SWS{number}(f,evS,:),tps]=mETAverage(eventsSWS{i}(evS),Range(sptsdH(i)),SpectroH{i}{1}(:,f),500,500);
        end
        for evR=1:length(eventsREM{i})
            [MatREM{number}(f,evR,:),S_REM{number}(f,evR,:),tps]=mETAverage(eventsREM{i}(evR),Range(sptsdH(i)),SpectroH{i}{1}(:,f),500,500); % trigger each line (frequency) of the spectrum on events
        end
        for evW=1:length(eventsWake{i})
            [MatWake{number}(f,evW,:),S_Wake{number}(f,evW,:),tps]=mETAverage(eventsWake{i}(evW),Range(sptsdH(i)),SpectroH{i}{1}(:,f),500,500);
        end
    end
         
    % average across frequencies bands (theta & delta) and events to get the average signal for each mouse
    for matS=1:length(MatSWS)
        ThetaSWS(matS,:)=squeeze(nanmean(nanmean(MatSWS{matS}(find(SpectroH{i}{3}<10&SpectroH{i}{3}>5),:,:),1)));   % frequency band average to get the theta
        DeltaSWS(matS,:)=squeeze(nanmean(nanmean(MatSWS{matS}(find(SpectroH{i}{3}<4&SpectroH{i}{3}>1),:,:),1)));    % frequency band average to get the delta
        
    end
    for matR=1:length(MatREM)
        ThetaREM(matR,:)=squeeze(nanmean(nanmean(MatREM{matR}(find(SpectroH{i}{3}<10&SpectroH{i}{3}>5),:,:),1)));
        DeltaREM(matR,:)=squeeze(nanmean(nanmean(MatREM{matR}(find(SpectroH{i}{3}<4&SpectroH{i}{3}>1),:,:),1)));

    end
    for matW=1:length(MatWake)
        ThetaWake(matW,:)=squeeze(nanmean(nanmean(MatWake{matW}(find(SpectroH{i}{3}<10&SpectroH{i}{3}>5),:,:),1)));   
        DeltaWake(matW,:)=squeeze(nanmean(nanmean(MatWake{matW}(find(SpectroH{i}{3}<4&SpectroH{i}{3}>1),:,:),1)));
    end
    
RatioSWS=ThetaSWS./DeltaSWS;     % compute average theta / delta RATIO
RatioREM=ThetaREM./DeltaREM;        
RatioWake=ThetaWake./DeltaWake;

sousSWS=ThetaSWS-DeltaSWS;      % compute average theta power - delta power
sousREM=ThetaREM-DeltaREM;
sousWake=ThetaWake-DeltaWake;


T=tps/1E3;                       % to define time window before and during the stim
BeforeStim=find(T>-10&T<0);
DuringStim=find(T>0&T<10);


MouseId(number) = Dir{2}.nMice{i} ;
number=number+1;

end

%% plots

% Average spectro of the HPC during REM sleep and Wake
% figure, subplot(6,5,[2,4]), imagesc(TPS/1E3,Spectro{3},zscore(avdataMrem')'), axis xy
figure, subplot(6,5,[2,4]), imagesc(TPS/1E3,Spectro{3},avdataMrem), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
title('HPC REM')
colorbar
% subplot(6,5,[7,9]), imagesc(TPS/1E3,Spectro{3},zscore(avdataMsws')'), axis xy
subplot(6,5,[7,9]), imagesc(TPS/1E3,Spectro{3},avdataMsws), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
title('HPC NREM')
colorbar
% subplot(6,5,[12,14]), imagesc(TPS/1E3,Spectro{3},zscore(avdataMwake')'), axis xy
subplot(6,5,[12,14]), imagesc(TPS/1E3,Spectro{3},avdataMwake), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
title('HPC Wake')
colorbar

% % theta quantifications during the stims
% subplot(6,5,[16,17]), shadedErrorBar(tps/1E3,ThetaSWS,{@mean,@stdError},'-r',1);
% hold on
% shadedErrorBar(tps/1E3,ThetaWake,{@mean,@stdError},'-b',1);
% shadedErrorBar(tps/1E3,ThetaREM,{@mean,@stdError},'-g',1);
% line([0 0], ylim,'color','k','linestyle',':')
% ylim([1e+04 3.7e+04])
% ylabel('Theta power')
% xlim([-10 +10])
% % xlabel('Times (s)')
% subplot(6,5,[21,22]), shadedErrorBar(tps/1E3,2*log(RatioSWS),{@mean,@stdError},'-r',1);
% hold on
% shadedErrorBar(tps/1E3,2*log(RatioWake),{@mean,@stdError},'-b',1);
% shadedErrorBar(tps/1E3,2*log(RatioREM),{@mean,@stdError},'-g',1);
% line([0 0], ylim,'color','k','linestyle',':')
% ylim([-3 +4])
% ylabel('Theta/Delta (log)')
% xlim([-10 +10])
% xlabel('Times (s)')

% figure, shadedErrorBar(tps/1E3,RatioSWS,{@mean,@stdError},'-r',1);
% hold on
% shadedErrorBar(tps/1E3,RatioWake,{@mean,@stdError},'-b',1);
% shadedErrorBar(tps/1E3,RatioREM,{@mean,@stdError},'-g',1);
% line([0 0], ylim,'color','k','linestyle',':')
% % ylim([-3 +4])
% ylabel('Theta/Delta power')
% % xlim([-10 +10])
% xlabel('Times (s)')


figure, shadedErrorBar(tps/1E3,RatioSWS/mean(RatioSWS(1:floor(length(RatioSWS))/2))*100,{@mean,@std},'-r',1);
hold on
shadedErrorBar(tps/1E3,RatioWake/mean(RatioREM(1:floor(length(RatioWake))/2))*100,{@mean,@std},'-b',1);
shadedErrorBar(tps/1E3,RatioREM/mean(RatioREM(1:floor(length(RatioREM))/2))*100,{@mean,@std},'-g',1);
line([0 0], ylim,'color','k','linestyle',':')
% ylim([-3 +4])
ylabel('Theta/Delta power')
xlim([-60 +60])
xlabel('Times (s)')


% subplot(6,5,[26,27]), shadedErrorBar(tps/1E3,sousSWS,{@mean,@stdError},'-r',1);
% hold on
% shadedErrorBar(tps/1E3,sousWake,{@mean,@stdError},'-b',1);
% shadedErrorBar(tps/1E3,sousREM,{@mean,@stdError},'-g',1);
% line([0 0], ylim,'color','k','linestyle',':')
% ylim([-5.5e04 +3.5e04])
% ylabel('Theta - Delta')
% xlim([-10 +10])
% xlabel('Times (s)')
% legend('Wake','','','','REM','','location','northeastoutside')

% bar plot theta power before VS during the stim
subplot(6,5,18),PlotErrorBarN_KJ({mean(ThetaREM(:,BeforeStim),2), mean(ThetaREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(ThetaREM(:,BeforeStim),2),mean(ThetaREM(:,DuringStim),2),0);
ylim([0 4e+04])
ylabel('Theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(6,5,19),PlotErrorBarN_KJ({mean(ThetaSWS(:,BeforeStim),2), mean(ThetaSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(ThetaSWS(:,BeforeStim),2),mean(ThetaSWS(:,DuringStim),2),0);
ylim([0 4e+04])
ylabel('Theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(6,5,20),PlotErrorBarN_KJ({mean(ThetaWake(:,BeforeStim),2), mean(ThetaWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(ThetaWake(:,BeforeStim),2),mean(ThetaWake(:,DuringStim),2),0);
ylim([0 4e+04])
ylabel('Theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

% bar plot of (theta/delta) power before VS during the stim
subplot(6,5,23),PlotErrorBarN_KJ({mean(RatioREM(:,BeforeStim),2), mean(RatioREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(RatioREM(:,BeforeStim),2),mean(RatioREM(:,DuringStim),2),0);
ylim([0 5])
ylabel('Theta/Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(6,5,24),PlotErrorBarN_KJ({mean(RatioSWS(:,BeforeStim),2), mean(RatioSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(RatioSWS(:,BeforeStim),2),mean(RatioSWS(:,DuringStim),2),0);
ylim([0 5])
ylabel('Theta/Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(6,5,25),PlotErrorBarN_KJ({mean(RatioWake(:,BeforeStim),2), mean(RatioWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(RatioWake(:,BeforeStim),2),mean(RatioWake(:,DuringStim),2),0);
ylim([0 5])
ylabel('Theta/Delta')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

% bar plot of(theta - delta) power before VS during the stim
subplot(6,5,28),PlotErrorBarN_KJ({mean(sousREM(:,BeforeStim),2), mean(sousREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2_MC(mean(sousREM(:,BeforeStim),2),mean(sousREM(:,DuringStim),2),0);
ylim([-5e04 3e+04])
ylabel('Theta - Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(6,5,29),PlotErrorBarN_KJ({mean(sousSWS(:,BeforeStim),2), mean(sousSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2_MC(mean(sousSWS(:,BeforeStim),2),mean(sousSWS(:,DuringStim),2),0);
ylim([-5e04 3e+04])
ylabel('Theta - Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(6,5,30),PlotErrorBarN_KJ({mean(sousWake(:,BeforeStim),2), mean(sousWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2_MC(mean(sousWake(:,BeforeStim),2),mean(sousWake(:,DuringStim),2),0);
ylim([-5e04 3e+04])
ylabel('Theta - Delta')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

suptitle('n=3 mice')

