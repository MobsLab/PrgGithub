Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
number = 1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    [MSws,MRem,MWake,ThetaSWS,ThetaREM,ThetaWake,DeltaSWS, DeltaREM, DeltaWake,freqH,tps]=QuantifThetaDelta_FalseStim_SingleMouse_MC(Wake,REMEpoch,SWSEpoch);
    
    SpSWS{i}=MSws; % cell array with spectro values for each mouse
    SpREM{i}=MRem;
    SpWake{i}=MWake;
    
    ThetaBandSWS{i}=ThetaSWS;
    ThetaBandREM{i}=ThetaREM;
    ThetaBandWake{i}=ThetaWake;
    
    DeltaBandSWS{i}=DeltaSWS;
    DeltaBandREM{i}=DeltaREM;
    DeltaBandWake{i}=DeltaWake;
    
    for evS=1:length(ThetaBandSWS) % loop to average beta power across events/stims
        AvThetaSWS(evS,:)=nanmean(ThetaBandSWS{evS}(:,:,:),1);
        AvDeltaSWS(evS,:)=nanmean(DeltaBandSWS{evS}(:,:,:),1);
    end
    for evR=1:length(ThetaBandREM)
        AvThetaREM(evR,:)=nanmean(ThetaBandREM{evR}(:,:,:),1);
        AvDeltaREM(evR,:)=nanmean(DeltaBandREM{evR}(:,:,:),1);
        
    end
    for evW=1:length(ThetaBandWake)
        AvThetaWake(evW,:)=nanmean(ThetaBandWake{evW}(:,:,:),1);
        AvDeltaWake(evW,:)=nanmean(DeltaBandWake{evW}(:,:,:),1);
        
    end
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

%%
RatioSWS=AvThetaSWS./AvDeltaSWS;
RatioREM=AvThetaREM./AvDeltaREM;
RatioWake=AvThetaWake./AvDeltaWake;

subsSWS=AvThetaSWS-AvDeltaSWS;
subsREM=AvThetaREM-AvDeltaREM;
subsWake=AvThetaWake-AvDeltaWake;

T=tps/1E3;  % to define time window before and during the stim
BeforeStim=find(T>-10&T<0);
DuringStim=find(T>0&T<10);

%%
dataSpWake=cat(3,SpWake{:}); % convert cell arrays in 3D arrays (third dimension being mice)
dataSpRem=cat(3,SpREM{:});
dataSpSws=cat(3,SpSWS{:});
avdataSpWake=nanmean(dataSpWake,3); % compute average spectro across the third dimension
avdataSpSws=nanmean(dataSpSws,3);
avdataSpRem=nanmean(dataSpRem,3);

%% plot

% Average spectro of the HPC during REM sleep and Wake
figure, subplot(6,5,[2,4]), imagesc(tps/1E3,freqH,zscore(avdataSpRem')'), axis xy
% figure, subplot(6,5,[2,4]), imagesc(tps/1E3,freqH,avdataSpRem), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
colorbar
title('HPC REM')

subplot(6,5,[7,9]), imagesc(tps/1E3,freqH,zscore(avdataSpSws')'), axis xy
% subplot(6,5,[7,9]), imagesc(tps/1E3,freqH,avdataSpSws), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
colorbar
title('HPC NREM')

subplot(6,5,[12,14]), imagesc(tps/1E3,freqH,zscore(avdataSpWake')'), axis xy
% subplot(6,5,[12,14]), imagesc(tps/1E3,freqH,avdataSpWake), axis xy
colormap(jet)
% caxis([-2 2])
% caxis([0 5e04])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([0 +20])
colorbar
title('HPC Wake')


% theta quantifications during the stims
subplot(6,5,[16,17]), shadedErrorBar(tps/1E3,AvThetaSWS,{@mean,@stdError},'-r',1);
hold on
shadedErrorBar(tps/1E3,AvThetaWake,{@mean,@stdError},'-b',1);
shadedErrorBar(tps/1E3,AvThetaREM,{@mean,@stdError},'-g',1);
line([0 0], ylim,'color','k','linestyle',':')
ylim([1e+04 3.7e+04])
ylabel('Theta power')
xlim([-10 +10])
xlabel('Times (s)')
subplot(6,5,[21,22]), shadedErrorBar(tps/1E3,2*log(RatioSWS),{@mean,@stdError},'-r',1);
hold on
shadedErrorBar(tps/1E3,2*log(RatioWake),{@mean,@stdError},'-b',1);
shadedErrorBar(tps/1E3,2*log(RatioREM),{@mean,@stdError},'-g',1);
ylim([-3 +4])
line([0 0], ylim,'color','k','linestyle',':')
ylabel('Theta/Delta (log)')
xlim([-10 +10])
xlabel('Times (s)')
subplot(6,5,[26,27]), shadedErrorBar(tps/1E3,subsSWS,{@mean,@stdError},'-r',1);
hold on
shadedErrorBar(tps/1E3,subsWake,{@mean,@stdError},'-b',1);
shadedErrorBar(tps/1E3,subsREM,{@mean,@stdError},'-g',1);
% ylim([-3 +4])
ylim([-4e+04 +4e+04])
line([0 0], ylim,'color','k','linestyle',':')
ylabel('Theta/Delta (log)')
xlim([-10 +10])
xlabel('Times (s)')

% bar plot theta power before VS during the stim
subplot(6,5,18),PlotErrorBarN_KJ({mean(AvThetaREM(:,BeforeStim),2), mean(AvThetaREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvThetaREM(:,BeforeStim),2),mean(AvThetaREM(:,DuringStim),2),0);
ylim([0 4e+04])
ylabel('Theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(6,5,19),PlotErrorBarN_KJ({mean(AvThetaSWS(:,BeforeStim),2), mean(AvThetaSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvThetaSWS(:,BeforeStim),2),mean(AvThetaSWS(:,DuringStim),2),0);
ylim([0 4e+04])
ylabel('Theta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(6,5,20),PlotErrorBarN_KJ({mean(AvThetaWake(:,BeforeStim),2), mean(AvThetaWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvThetaWake(:,BeforeStim),2),mean(AvThetaWake(:,DuringStim),2),0);
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

% bar plot of (theta/delta) power before VS during the stim
subplot(6,5,28), PlotErrorBarN_KJ({mean(subsREM(:,BeforeStim),2), mean(subsREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(subsREM(:,BeforeStim),2),mean(subsREM(:,DuringStim),2),0);
% ylim([0 5])
ylim([-4e+04 +4e+04])
ylabel('Theta-Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
subplot(6,5,29), PlotErrorBarN_KJ({mean(subsSWS(:,BeforeStim),2), mean(subsSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(subsSWS(:,BeforeStim),2),mean(subsSWS(:,DuringStim),2),0);
% ylim([0 5])
ylim([-4e+04 +4e+04])
ylabel('Theta-Delta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
subplot(6,5,30), PlotErrorBarN_KJ({mean(subsWake(:,BeforeStim),2), mean(subsWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(subsWake(:,BeforeStim),2),mean(subsWake(:,DuringStim),2),0);
% ylim([0 5])
ylim([-4e+04 +4e+04])
ylabel('Theta-Delta')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')
