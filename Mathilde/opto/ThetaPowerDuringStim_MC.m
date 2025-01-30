%% Input dir
DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% % DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
% 
DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1137 1136 648 1074]);%1109



% % DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [675 733 1137 1136 648 1076]);%   %1109 1136
% 
% DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1074 1076 1109 1137]);%   % 1136

% % DirCtrl=PathForExperiments_Opto_MC('PFC_Control_20Hz');
% % DirCtrl = RestrictPathForExperiment(DirCtrl, 'nMice', [1075 1111 1112 1180 1181]);
% % DirOpto=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
% % DirOpto = RestrictPathForExperiment(DirOpto, 'nMice', [733 1076 1109 1136 1137]);

% DirCtrl=PathForExperiments_Opto_MC('SST_Sham_20Hz');
% DirOpto=PathForExperiments_Opto_MC('SST_Stim_20Hz');

% DirCtrl=PathForExperiments_Opto_MC('sham_wake');
% DirOpto=PathForExperiments_Opto_MC('stim_wake');

%% input dir (stimulation PFC-Sepctum)
% DirCtrl=PathForExperiments_Opto_MC('Septum_Sham_20Hz');
% DirOpto=PathForExperiments_Opto_MC('Septum_Stim_20Hz');

%% parameters
timeWindow = 20;
timeWindow15 = 15;
timeWindow20 = 20;

state='rem';
MinDurBeforeStim=1;

%% get the data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    %load sleep scoring
    if exist('SleepScoring_OBGamma.mat')
        stage{i} = load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','LowThetaEpochMC');
    else
        stage{i} = load('SleepScoring_Accelero.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','LowThetaEpochMC');
    end
    %get opto stim
    %     stim{i} = load('StimOpto_new.mat');
        [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise);
    %     stim{i}=Stim;
    
    stim_rem{i} = FindOptoStimWithLongBout_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,'rem', MinDurBeforeStim);
    stim_wake{i} = FindOptoStimWithLongBout_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,'wake', MinDurBeforeStim);
    
    % get sp triggered on START of REM ep (to compare with transition
    % induced by opto stim)
    [SpREM_start,SpSWS,SpWake, temps] = PlotThetaPowerAtTransitions_SingleMouse_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,'start');
    SpectroREMstart{i}=SpREM_start;
    % get sp triggered on END of REM ep
    [SpREM_end,SpSWS,SpWake, temps] = PlotThetaPowerAtTransitions_SingleMouse_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,'end');
    SpectroREMend{i}=SpREM_end;
    % get sp triggered on Stimulations during REM ep
    [SpREM,SpSWS,SpWake,temps]=PlotThetaPowerAroundStim_SingleMouse_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,stage{i}.LowThetaEpochMC,stim_rem{i});
    SpectroREM_Ctrl{i}=SpREM;
    
    [SpREM,SpSWS,SpWake,temps]=PlotThetaPowerAroundStim_SingleMouse_MC(stage{i}.WakeWiNoise,stage{i}.SWSEpochWiNoise,stage{i}.REMEpochWiNoise,stage{i}.LowThetaEpochMC,stim_wake{i});
    SpectroWake_Ctrl{i}=SpWake;
    
    tps{i} = temps;
    beforeidx{i}=find(tps{i}>-timeWindow&tps{i}<0); % to restrict time to the time window (defined above)
    duringidx{i}=find(tps{i}>0&tps{i}<timeWindow);
    
    freq{i}=[1:size(SpectroREM_Ctrl{i},1)]/size(SpectroREM_Ctrl{i},1)*20;
%     idxfreq{i}=find(freq{i}>6&freq{i}<9); % to restrict frequencies to the theta band
        idxfreq{i}=find(freq{i}>5&freq{i}<9); % to restrict frequencies to the theta band

    % get the theta band in the time window of interest
    thetaBandREM_ctrl{i} = SpectroREM_Ctrl{i}(idxfreq{i},:);
    thetaBandWake_ctrl{i} = SpectroWake_Ctrl{i}(idxfreq{i},:);
    SpthetaBandREM_Before{i} = SpectroREM_Ctrl{i}(idxfreq{i},beforeidx{i}');
    SpthetaBandREM_During{i} = SpectroREM_Ctrl{i}(idxfreq{i},duringidx{i}');
    SpthetaBandWake_Before{i} = SpectroWake_Ctrl{i}(idxfreq{i},beforeidx{i}');
    SpthetaBandWake_During{i} = SpectroWake_Ctrl{i}(idxfreq{i},duringidx{i}');
    
    % calculate average power in theta band across mice
    for ii=1:length(thetaBandREM_ctrl)
        AvThetaREMctrl(ii,:)=nanmean(thetaBandREM_ctrl{ii});
    end
    for ii=1:length(thetaBandWake_ctrl)
        AvThetaWakectrl(ii,:)=nanmean(thetaBandWake_ctrl{ii});
    end
    for ii=1:length(SpthetaBandREM_Before)
        AvThetaREMBefore(ii,:)=nanmean(nanmean(SpthetaBandREM_Before{ii}));
    end
    for ii=1:length(SpthetaBandREM_During)
        AvThetaREMDuring(ii,:)=nanmean(nanmean(SpthetaBandREM_During{ii}));
    end
    for ii=1:length(SpthetaBandWake_Before)
        AvThetaWakeBefore(ii,:)=nanmean(nanmean(SpthetaBandWake_Before{ii}));
    end
    for ii=1:length(SpthetaBandWake_During)
        AvThetaWakeDuring(ii,:)=nanmean(nanmean(SpthetaBandWake_During{ii}));
    end
end

clear SpREM SpWake temps
%%
numberOpto=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    %load sleep scoring
    stageOpto{j} = load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','LowThetaEpochMC');

%     [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(stageOpto{j}.WakeWiNoise,stageOpto{j}.SWSEpochWiNoise,stageOpto{j}.REMEpochWiNoise);
%     stimOpto{j}=Stim;

    stim_rem_opto{j} = FindOptoStimWithLongBout_MC(stageOpto{j}.WakeWiNoise,stageOpto{j}.SWSEpochWiNoise,stageOpto{j}.REMEpochWiNoise,'rem', MinDurBeforeStim);
    stim_wake_opto{j} = FindOptoStimWithLongBout_MC(stageOpto{j}.WakeWiNoise,stageOpto{j}.SWSEpochWiNoise,stageOpto{j}.REMEpochWiNoise,'wake', MinDurBeforeStim);
    
    [SpREM,SpSWS,SpWake,temps]=PlotThetaPowerAroundStim_SingleMouse_MC(stageOpto{j}.WakeWiNoise,stageOpto{j}.SWSEpochWiNoise,stageOpto{j}.REMEpochWiNoise,stageOpto{j}.LowThetaEpochMC,stim_rem_opto{j});
    SpectroREM_Opto{j}=SpREM;
    
    [SpREM,SpSWS,SpWake,temps]=PlotThetaPowerAroundStim_SingleMouse_MC(stageOpto{j}.WakeWiNoise,stageOpto{j}.SWSEpochWiNoise,stageOpto{j}.REMEpochWiNoise,stageOpto{j}.LowThetaEpochMC,stim_wake_opto{j});
    SpectroWake_Opto{j}=SpWake;
    
    tps_Opto{j} = temps;
    beforeidx{j}=find(tps_Opto{j}>-timeWindow&tps_Opto{j}<0); % to restrict time to the time window (defined above)
    duringidx{j}=find(tps_Opto{j}>0&tps_Opto{j}<timeWindow);
    
    freq{j}=[1:size(SpectroREM_Opto{j},1)]/size(SpectroREM_Opto{j},1)*20;
    %     idxfreq{j}=find(freq{j}>6&freq{j}<9); % to restrict frequencies to the theta band
    idxfreq{j}=find(freq{j}>5&freq{j}<9); % to restrict frequencies to the theta band

    % get the theta band in the time window of interest
    thetaBandREM_opto{j} = SpectroREM_Opto{j}(idxfreq{j},:);
    thetaBandWake_opto{j} = SpectroWake_Opto{j}(idxfreq{j},:);
    ThetaBandREM_Opto_Before{j} = SpectroREM_Opto{j}(idxfreq{j},beforeidx{j}');
    ThetaBandREM_Opto_During{j} = SpectroREM_Opto{j}(idxfreq{j},duringidx{j}');
    ThetaBandWake_Opto_Before{j} = SpectroWake_Opto{j}(idxfreq{j},beforeidx{j}');
    ThetaBandWake_Opto_During{j} = SpectroWake_Opto{j}(idxfreq{j},duringidx{j}');
    
    % to try with different time windows
    % ===================================================================================
    %     beforeidx15{j}=find(tps_Opto{j}>-timeWindow15&tps_Opto{j}<0);
    %     duringidx15{j}=find(tps_Opto{j}>0&tps_Opto{j}<timeWindow15);
    %     % get the theta band in the time window of interest
    %     ThetaBandREM_Opto_Before15{j} = SpectroREM_Opto{j}(idxfreq{j},beforeidx15{j}');
    %     ThetaBandREM_Opto_During15{j} = SpectroREM_Opto{j}(idxfreq{j},duringidx15{j}');
    %     ThetaBandWake_Opto_Before15{j} = SpectroWake_Opto{j}(idxfreq{j},beforeidx15{j}');
    %     ThetaBandWake_Opto_During15{j} = SpectroWake_Opto{j}(idxfreq{j},duringidx15{j}');
    %
    %     beforeidx20{j}=find(tps_Opto{j}>-timeWindow20&tps_Opto{j}<0);
    %     duringidx20{j}=find(tps_Opto{j}>0&tps_Opto{j}<timeWindow20);
    %     % get the theta band in the time window of interest
    %     ThetaBandREM_Opto_Before20{j} = SpectroREM_Opto{j}(idxfreq{j},beforeidx20{j}');
    %     ThetaBandREM_Opto_During20{j} = SpectroREM_Opto{j}(idxfreq{j},duringidx20{j}');
    %     ThetaBandWake_Opto_Before20{j} = SpectroWake_Opto{j}(idxfreq{j},beforeidx20{j}');
    %     ThetaBandWake_Opto_During20{j} = SpectroWake_Opto{j}(idxfreq{j},duringidx20{j}');
    %
    %     beforeidx520{j}=find(tps_Opto{j}>-timeWindow20&tps_Opto{j}<5);
    %     duringidx520{j}=find(tps_Opto{j}>5&tps_Opto{j}<timeWindow20);
    %     % get the theta band in the time window of interest
    %     ThetaBandREM_Opto_Before520{j} = SpectroREM_Opto{j}(idxfreq{j},beforeidx520{j}');
    %     ThetaBandREM_Opto_During520{j} = SpectroREM_Opto{j}(idxfreq{j},duringidx520{j}');
    %     ThetaBandWake_Opto_Before520{j} = SpectroWake_Opto{j}(idxfreq{j},beforeidx520{j}');
    %     ThetaBandWake_Opto_During520{j} = SpectroWake_Opto{j}(idxfreq{j},duringidx520{j}');
    % ===================================================================================
    
    % calculate average power in theta band across mice
    for jj=1:length(thetaBandREM_opto)
        AvThetaREMopto(jj,:)=nanmean(thetaBandREM_opto{jj});
    end
    for jj=1:length(thetaBandWake_opto)
        AvThetaWakeopto(jj,:)=nanmean(thetaBandWake_opto{jj});
    end
    for jj=1:length(ThetaBandREM_Opto_Before)
        AvThetaREMoptoBefore(jj,:)=nanmean(nanmean(ThetaBandREM_Opto_Before{jj}));
    end
    for jj=1:length(ThetaBandREM_Opto_During)
        AvThetaREMOptoDuring(jj,:)=nanmean(nanmean(ThetaBandREM_Opto_During{jj}));
    end
    for jj=1:length(ThetaBandWake_Opto_Before)
        AvThetaWakeOptoBefore(jj,:)=nanmean(nanmean(ThetaBandWake_Opto_Before{jj}));
    end
    for jj=1:length(ThetaBandWake_Opto_During)
        AvThetaWakeOptoDuring(jj,:)=nanmean(nanmean(ThetaBandWake_Opto_During{jj}));
    end
end

%% calculate average spectro
dataSpREM=cat(3,SpectroREM_Ctrl{:});
avdataSpREM=nanmean(dataSpREM,3);
dataSpREMopto=cat(3,SpectroREM_Opto{:});
avdataSpREMopto=nanmean(dataSpREMopto,3);
dataSpWake=cat(3,SpectroWake_Ctrl{:});
avdataSpWake=nanmean(dataSpWake,3);
dataSpWakeOpto=cat(3,SpectroWake_Opto{:});
avdataSpWakeOpto=nanmean(dataSpWakeOpto,3);
dataSpREMstart=cat(3,SpectroREMstart{:});
avdataSpREMstart=nanmean(dataSpREMstart,3);
dataSpREMend=cat(3,SpectroREMend{:}); 
avdataSpREMend=nanmean(dataSpREMend,3);

%% figures 
figure, hold on
shadedErrorBar(freq{1},mean(avdataSpREM(:,250:311),2),std(avdataSpREM(:,250:311)'),'-k',1);
shadedErrorBar(freq{1},mean(avdataSpREMopto(:,250:311),2),std(avdataSpREMopto(:,250:311)'),'-b',1);


%% panel pour le REM (spectro + barplot)
freq=[1:size(SpREM,1)]/size(SpREM,1)*20;

figure('color',[1 1 1]), subplot(2,5,[1:3]), imagesc(temps,freq, avdataSpREMopto),axis xy, caxis([0 5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC spectro during stim in REM sleep for ChR2 mice')
set(gca, 'FontSize', 13);

subplot(2,5,[6:8]), imagesc(temps,freq, avdataSpREM),axis xy, caxis([0 5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC spectro during stim in REM sleep for mCherry mice')
set(gca, 'FontSize', 13);

col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .8 1];
col_chr2=[.3 .3 .3];

subplot(2,5,[4,5,9,10]),
MakeSpreadAndBoxPlot2_SB({AvThetaREMBefore AvThetaREMDuring AvThetaREMoptoBefore AvThetaREMOptoDuring},{col_ctrl,col_ctrl,col_chr2,col_chr2},[1:4],{},'ShowPoints',1,'paired',0,'optiontest','ttest');
xticks([1.5, 3.5]); xticklabels({'mCherry','ChR2'});
xtickangle(0)

[h,p1]=ttest(AvThetaREMBefore, AvThetaREMDuring);
% p=signrank(AvThetaREMBefore, AvThetaREMDuring);

if p1<0.05
    sigstar_DB({[1 2]},p1,0,'LineWigth',16,'StarSize',24);
end

[h,p1]=ttest(AvThetaREMoptoBefore, AvThetaREMOptoDuring);
% p=signrank(AvThetaREMoptoBefore, AvThetaREMOptoDuring);

if p1<0.05
    sigstar_DB({[3 4]},p1,0,'LineWigth',16,'StarSize',24);
end



%% panel pour le Wake (spectro + barplot)
figure('color',[1 1 1]), subplot(2,5,[1:3]), imagesc(temps,freq, avdataSpWakeOpto),caxis([0 5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC spectro during stim in WAKE for ChR2 mice')
set(gca, 'FontSize', 13);

subplot(2,5,[6:8]), imagesc(temps,freq, avdataSpWake),caxis([0 5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 +30])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('HPC spectro during stim in WAKE for mCherry mice')
set(gca, 'FontSize', 13);

col_ctrl=[.8 .8 .8];
% col_chr2=[.4 .8 1];
col_chr2=[.4 .4 .4];

subplot(2,5,[4,5,9,10]),
MakeSpreadAndBoxPlot2_SB({AvThetaWakeBefore AvThetaWakeDuring AvThetaWakeOptoBefore AvThetaWakeOptoDuring},{col_ctrl,col_ctrl,col_chr2,col_chr2},[1:4],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1.5, 3.5]); xticklabels({'mCherry','ChR2'});
xtickangle(0)




%% theta power overtime (for REM and wakefulness)
figure, hold on,
shadedErrorBar(temps,AvThetaREMctrl,{@mean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaREMopto,{@mean,@stdError},'-g',1);
xlim([-30 +30])
xlabel('Time (s)')
ylabel('normalized theta power')
title('theta power during REM')
line([0 0], ylim,'color','k','linestyle',':')

%%
figure, hold on,
shadedErrorBar(temps,AvThetaWakectrl,{@nanmean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaWakeopto,{@nanmean,@stdError},'-b',1);
xlim([-30 +30])
xlabel('Time (s)')
ylabel('normalized theta power')
title('theta power during wakefulness')
line([0 0], ylim,'color','k','linestyle',':')

freq=[1:20];
figure
subplot(411)
imagesc(temps,freq, avdataSpREMstart),axis xy, colormap(jet), caxis([0 5])
% caxis([7 9.5])
colorbar
% ylim([10 30])
xlim([-60 +60])
line([0 0],ylim,'color','w','linestyle','-')
title('start (n=5)')
subplot(412)
imagesc(temps,freq, log(avdataSpREMend)),axis xy
% caxis([7 9.5])
colorbar
% ylim([10 30])
xlim([-60 +60])
line([0 0],ylim,'color','w','linestyle','-')
title('end (n=5)')

%% comparaison effet stim avec start et end REM
% freq=[1:size(SpREM,1)]/size(SpREM,1)*20;
% 
% figure('color',[1 1 1]), subplot(4,4,[9,10]), imagesc(temps,freq, avdataSpREMopto),axis xy, caxis([0 5]), colormap(jet)
% line([0 0], ylim,'color','w','linestyle','-')
% xlim([-30 +30])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% colorbar
% title('HPC REM opto')
% 
% subplot(4,4,[13,14]), imagesc(temps,freq, avdataSpREM),axis xy, caxis([0 5]), colormap(jet)
% line([0 0], ylim,'color','w','linestyle','-')
% xlim([-30 +30])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% colorbar
% title('HPC REM control')

%% 
% figure
% subplot(2,4,[1:2]),
% imagesc(temps,freq, avdataSpREMstart),axis xy, caxis([0 5]), colormap(jet)
% line([0 0], ylim,'color','w','linestyle','-')
% xlim([-30 +30])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% colorbar
% title('HPC REM start')
% 
% subplot(2,4,[5:6])
% imagesc(temps,freq, avdataSpREMend),axis xy, caxis([0 5]), colormap(jet)
% line([0 0], ylim,'color','w','linestyle','-')
% xlim([-30 +30])
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% colorbar
% title('HPC REM end')

%%
% subplot(4,4,[11,15]),PlotErrorBarN_KJ({AvThetaREMoptoBefore, AvThetaREMOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
% ylim([0 5])
% ylabel('theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('REM opto')
% 
% subplot(4,4,[12,16]),PlotErrorBarN_KJ({AvThetaREMBefore, AvThetaREMDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
% ylim([0 5])
% ylabel('theta power')
% xticks(1:2)
% xticklabels({'Before','During'});
% title('REM control')

figure, hold on
shadedErrorBar(temps,avdataSpREMopto(idxfreq{1},:),{@mean,@stdError},'-b',1);
shadedErrorBar(temps,avdataSpREM(idxfreq{1},:),{@mean,@stdError},'-k',1);

figure, hold on
shadedErrorBar(temps,avdataSpWakeOpto(idxfreq{1},:),{@mean,@stdError},'-b',1);
shadedErrorBar(temps,avdataSpWake(idxfreq{1},:),{@mean,@stdError},'-k',1);


%%

figure,  imagesc(temps,freq, SpectroREM_Opto{3}),axis xy, caxis([0 5]), colormap(jet)
figure,  imagesc(temps,freq, SpectroREM_Ctrl{5}),axis xy, caxis([0 5]), colormap(jet)


figure,  imagesc(temps,freq, SpectroWake_Opto{4}),axis xy, caxis([0 5]), colormap(jet)
figure,  imagesc(temps,freq, SpectroWake_Ctrl{1}),axis xy, caxis([0 5]), colormap(jet)




%%

figure
subplot(4,2,[1,2])
imagesc(temps,freq, SpectroREM_Opto{3}),axis xy, caxis([0 5]), colormap(jet)
caxis([0 5])
caxis([1 5])
subplot(4,2,[3,4])
imagesc(temps,freq, SpectroREM_Ctrl{5}),axis xy, caxis([0 5]), colormap(jet)
imagesc(temps,freq, SpectroREM_Ctrl{3}),axis xy, caxis([0 5]), colormap(jet)
imagesc(temps,freq, SpectroREM_Ctrl{5}),axis xy, caxis([0 5]), colormap(jet)
caxis([0 5])
caxis([1 5])
imagesc(temps,freq, SpectroREM_Ctrl{3}),axis xy, caxis([0 5]), colormap(jet)
caxis([1 5])
imagesc(temps,freq, SpectroREM_Ctrl{5}),axis xy, caxis([0 5]), colormap(jet)
caxis([1 5])
subplot(4,2,[5,6,7,8])
shadedErrorBar(temps,avdataSpREMopto(idxfreq{1},:),{@mean,@stdError},'-b',1);
shadedErrorBar(temps,avdataSpREM(idxfreq{1},:),{@mean,@stdError},'-k',1);
hold on
shadedErrorBar(temps,avdataSpREMopto(idxfreq{1},:),{@mean,@stdError},'-b',1);
xlim([-60 +60])
xlim([-60 +60])
xlim([-60 +60])
line([0 0], ylim,'color','k','linestyle','-')
line([0 0], ylim,'color','w','linestyle','-')
line([0 0], ylim,'color','w','linestyle','-')



%% PANEL REM

figure, set(gcf,'color',[1 1 1])
subplot(2,3,[1,2])
imagesc(temps,freq, SpectroREM_Opto{3}),axis xy, caxis([0 5]), colormap(jet)
caxis([1 5])
xlim([-60 +60])
line([0 0], ylim,'color','w','linestyle','-')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
set(gca,'FontSize',16)

subplot(2,3,[4,5])
imagesc(temps,freq, SpectroREM_Ctrl{5}),axis xy, caxis([0 5]), colormap(jet)
caxis([1 5])
xlim([-60 +60])
line([0 0], ylim,'color','w','linestyle','-')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
set(gca,'FontSize',16)

subplot(2,3,[3,6])
MakeSpreadAndBoxPlot2_SB({AvThetaREMBefore AvThetaREMDuring AvThetaREMoptoBefore AvThetaREMOptoDuring},{col_ctrl,col_ctrl,col_chr2,col_chr2},[1:4],{},'ShowPoints',1,'paired',0);
xticks([1.5, 3.5]); xticklabels({'mCherry','ChR2'});
xtickangle(0)
makepretty
ylabel('Theta power (a.u)')
set(gca,'FontSize',16)

%%test stats
[h,p1]=ttest(AvThetaREMBefore, AvThetaREMDuring);
% p1=signrank(AvThetaREMBefore, AvThetaREMDuring);
if p1<0.05
    sigstar_DB({[1 2]},p1,0,'LineWigth',16,'StarSize',24);
end

[h,p2]=ttest(AvThetaREMoptoBefore, AvThetaREMOptoDuring);
% p2=signrank(AvThetaREMoptoBefore, AvThetaREMOptoDuring);
if p2<0.05
    sigstar_DB({[3 4]},p2,0,'LineWigth',16,'StarSize',24);
end

title(['mCherry p=', num2str(p1), ' ChR2 p=', num2str(p2)])

%%

clear p1 p2

figure
subplot(2,3,[1,2])
 imagesc(temps,freq, SpectroWake_Opto{4}),axis xy, %caxis([0 5]), colormap(jet)
 caxis([1 5])
xlim([-60 +60])
line([0 0], ylim,'color','w','linestyle','-')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
set(gca,'FontSize',16)

subplot(2,3,[4,5])
imagesc(temps,freq, SpectroWake_Ctrl{1}),axis xy,% caxis([0 5]), colormap(jet)
caxis([1 5])
xlim([-60 +60])
line([0 0], ylim,'color','w','linestyle','-')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
set(gca,'FontSize',16)

subplot(2,3,[3,6])
MakeSpreadAndBoxPlot2_SB({AvThetaWakeBefore AvThetaWakeDuring AvThetaWakeOptoBefore AvThetaWakeOptoDuring},{col_ctrl,col_ctrl,col_chr2,col_chr2},[1:4],{},'ShowPoints',1,'paired',0);
xticks([1.5, 3.5]); xticklabels({'mCherry','ChR2'});
xtickangle(0)
makepretty
ylabel('Theta power (a.u)')
set(gca,'FontSize',16)

%%test stats
[h,p1]=ttest(AvThetaWakeBefore, AvThetaWakeDuring);
% p1=signrank(AvThetaREMBefore, AvThetaREMDuring);
if p1<0.05
    sigstar_DB({[1 2]},p1,0,'LineWigth',16,'StarSize',24);
end

[h,p2]=ttest(AvThetaWakeOptoBefore, AvThetaWakeOptoDuring);
% p2=signrank(AvThetaREMoptoBefore, AvThetaREMOptoDuring);
if p2<0.05
    sigstar_DB({[3 4]},p2,0,'LineWigth',16,'StarSize',24);
end

title(['mCherry p=', num2str(p1), ' ChR2 p=', num2str(p2)])

