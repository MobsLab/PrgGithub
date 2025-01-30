Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
number = 1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    
    [MSws,MRem,MWake,BetaSWS,BetaREM,BetaWake,freqB,tps] = QuantifBeta_FalseStim_SingleMouse_MC(Wake,REMEpoch,SWSEpoch);
    SpSWS{i}=MSws; % cell array with spectro values for each mouse
    SpREM{i}=MRem;
    SpWake{i}=MWake;
    BetaBandSWS{i}=BetaSWS; % cell array with beta power for each mouse 
    BetaBandREM{i}=BetaREM;
    BetaBandWake{i}=BetaWake;
    
    for evS=1:length(BetaBandSWS) % loop to average beta power across events/stims
        AvBetaSWS(evS,:)=nanmean(BetaBandSWS{evS}(:,:,:),1);
    end   
    for evR=1:length(BetaBandREM)
        AvBetaREM(evR,:)=nanmean(BetaBandREM{evR}(:,:,:),1);
    end
    for evW=1:length(BetaBandWake)
        AvBetaWake(evW,:)=nanmean(BetaBandWake{evW}(:,:,:),1);
    end
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

T=tps/1E3;  % to define time window before and during the stim
BeforeStim=find(T>-10&T<0);
DuringStim=find(T>0&T<10);

%% compute mean spectro
dataSpWake=cat(3,SpWake{:}); % convert cell arrays in 3D arrays (third dimension being mice)
dataSpRem=cat(3,SpREM{:});
dataSpSws=cat(3,SpSWS{:});
avdataSpWake=nanmean(dataSpWake,3); % compute average spectro across the third dimension
avdataSpSws=nanmean(dataSpSws,3);
avdataSpRem=nanmean(dataSpRem,3);

%% plot 
% average spectro across mice (zscore or not)
% figure, subplot(4,5,[1,5]), imagesc(tps/1E3,freqB,avdataSpRem), axis xy
figure, subplot(4,5,[1,5]), imagesc(tps/1E3,freqB,zscore(avdataSpRem')'), axis xy
colormap(jet)
% caxis([-2 2])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([20 90])
ylabel('Frequency (Hz)')
title('OB REM')
colorbar
% subplot(4,5,[6,10]), imagesc(tps/1E3,freqB,avdataSpSws), axis xy
subplot(4,5,[6,10]), imagesc(tps/1E3,freqB,zscore(avdataSpSws')'), axis xy
colormap(jet)
% caxis([-2 2])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([20 90])
ylabel('Frequency (Hz)')
title('OB NREM')
colorbar
% subplot(4,5,[11,15]), imagesc(tps/1E3,freqB,avdataSpWake), axis xy
subplot(4,5,[11,15]), imagesc(tps/1E3,freqB,zscore(avdataSpWake')'), axis xy
colormap(jet)
% caxis([-2 2])
line([0 0], ylim,'color','w','linestyle',':')
xlim([-60 +60])
ylim([20 90])
ylabel('Frequency (Hz)')
title('OB Wake')
xlabel('Time (s)')
colorbar

% beta power during stim (REM,NREM,Wake)
subplot(4,5,[16,17]),shadedErrorBar(tps/1E3,AvBetaWake,{@mean,@stdError},'-b',1);
hold on
shadedErrorBar(tps/1E3,AvBetaSWS,{@mean,@stdError},'-r',1);
shadedErrorBar(tps/1E3,AvBetaREM,{@mean,@stdError},'-g',1);
line([0 0], ylim,'color','k','linestyle',':')
ylim([0 12000])
ylabel('Beta power')
xlim([-10 +10])
xlabel('Times (s)')

% quantif beta power 10s before stims vs 10s during stims
subplot(4,5,18),PlotErrorBarN_KJ({mean(AvBetaREM(:,BeforeStim),2), mean(AvBetaREM(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvBetaREM(:,BeforeStim),2),mean(AvBetaREM(:,DuringStim),2),0);
ylabel('Beta power')
ylim([0 1e+04])
xticks(1:2)
xticklabels({'Before ','During '});
title('REM')
subplot(4,5,19),PlotErrorBarN_KJ({mean(AvBetaSWS(:,BeforeStim),2), mean(AvBetaSWS(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvBetaSWS(:,BeforeStim),2),mean(AvBetaSWS(:,DuringStim),2),0);
ylabel('Beta power')
ylim([0 1e+04])
xticks(1:2)
xticklabels({'Before ','During '});
title('NREM')
subplot(4,5,20),PlotErrorBarN_KJ({mean(AvBetaWake(:,BeforeStim),2), mean(AvBetaWake(:,DuringStim),2)},'newfig',0,'paired',1,'ShowSigstar','sig');
% PlotErrorBar2(mean(AvBetaWake(:,BeforeStim),2),mean(AvBetaWake(:,DuringStim),2),0);
ylabel('Beta power')
ylim([0 1e+04])
xticks(1:2)
xticklabels({'Before ','During '});
title('Wake')