%% Input dir
% DirCtrl=PathForExperiments_Opto_TG('PFC_Control_20Hz');
% DirOpto=PathForExperiments_Opto_TG('PFC_Stim_20Hz');
DirOpto=PathForExperiments_Opto_TG('Septum_Stim_20Hz');
DirCtrl=PathForExperiments_Opto_TG('Septum_Sham_20Hz');

% DirOpto=RestrictPathForExperiment(DirOpto, 'nMice', [648 675 733 1076 1109 1136 1137]);

timeWindow = 10;
timeWindow15 = 15;
timeWindow20 = 20;

%% get the data
number=1;
for i=1:length(DirCtrl.path)
    cd(DirCtrl.path{i}{1});
    stage{i} = load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
    [SpectroREMG,SpectroSWSG,SpectroWakeG,temps]=PlotGammaPowerOverTime_SingleMouse_TG(stage{i}.WakeWiNoise, stage{i}.SWSEpochWiNoise, stage{i}.REMEpochWiNoise,0);
    SpectroREM_Ctrl{i}=SpectroREMG;
    SpectroSWS_Ctrl{i}=SpectroSWSG;
    SpectroWake_Ctrl{i}=SpectroWakeG;
    tps{i} = temps;
    beforeidx{i}=find(tps{i}>-timeWindow&tps{i}<0); % to restrict time to the time window (defined above)
    duringidx{i}=find(tps{i}>0&tps{i}<timeWindow);
    
    freq{i}=[1:size(SpectroREM_Ctrl{i},1)]/size(SpectroREM_Ctrl{i},1)*100;
    idxfreq{i}=find(freq{i}>40&freq{i}<60); % to restrict frequencies to the theta band
    
    % get the theta band in the time window of interest
    thetaBandREM_ctrl{i} = SpectroREM_Ctrl{i}(idxfreq{i},:);
    thetaBandWake_ctrl{i} = SpectroWake_Ctrl{i}(idxfreq{i},:);
    thetaBandSWS_ctrl{i} = SpectroSWS_Ctrl{i}(idxfreq{i},:);
    SpthetaBandREM_Before{i} = SpectroREM_Ctrl{i}(idxfreq{i},beforeidx{i}');
    SpthetaBandREM_During{i} = SpectroREM_Ctrl{i}(idxfreq{i},duringidx{i}');
    SpthetaBandWake_Before{i} = SpectroWake_Ctrl{i}(idxfreq{i},beforeidx{i}');
    SpthetaBandWake_During{i} = SpectroWake_Ctrl{i}(idxfreq{i},duringidx{i}');
    SpthetaBandSWS_Before{i} = SpectroSWS_Ctrl{i}(idxfreq{i},beforeidx{i}');
    SpthetaBandSWS_During{i} = SpectroSWS_Ctrl{i}(idxfreq{i},duringidx{i}');
    
    % calculate average power in theta band across mice
    for ii=1:length(thetaBandREM_ctrl)
        AvThetaREMctrl(ii,:)=nanmean(thetaBandREM_ctrl{ii});
    end
    for ii=1:length(thetaBandWake_ctrl)
        AvThetaWakectrl(ii,:)=nanmean(thetaBandWake_ctrl{ii});
    end
    for ii=1:length(thetaBandSWS_ctrl)
        AvThetaSWSctrl(ii,:)=nanmean(thetaBandSWS_ctrl{ii});
    end
    for ii=1:length(SpthetaBandREM_Before)
        AvThetaREMBefore(ii,:)=nanmean(nanmean(SpthetaBandREM_Before{ii}));
    end
    for ii=1:length(SpthetaBandREM_During)
        AvThetaREMDuring(ii,:)=nanmean(nanmean(SpthetaBandREM_During{ii}));
    end
    for ii=1:length(SpthetaBandSWS_Before)
        AvThetaSWSBefore(ii,:)=nanmean(nanmean(SpthetaBandSWS_Before{ii}));
    end
    for ii=1:length(SpthetaBandSWS_During)
        AvThetaSWSDuring(ii,:)=nanmean(nanmean(SpthetaBandSWS_During{ii}));
    end
    for ii=1:length(SpthetaBandWake_Before)
        AvThetaWakeBefore(ii,:)=nanmean(nanmean(SpthetaBandWake_Before{ii}));
    end
    for ii=1:length(SpthetaBandWake_During)
        AvThetaWakeDuring(ii,:)=nanmean(nanmean(SpthetaBandWake_During{ii}));
    end
end

clear SpectroREMG SpectroWakeG SpectroSWSG temps
%%
numberOpto=1;
for j=1:length(DirOpto.path)
    cd(DirOpto.path{j}{1});
    stage{i} = load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise');
    [SpectroREMG,SpectroSWSG,SpectroWakeG,temps]=PlotGammaPowerOverTime_SingleMouse_TG(stage{i}.WakeWiNoise, stage{i}.SWSEpochWiNoise, stage{i}.REMEpochWiNoise,0);
    SpectroREM_Opto{j}=SpectroREMG;
    SpectroSWS_Opto{j}=SpectroSWSG;
    SpectroWake_Opto{j}=SpectroWakeG;
    tps_Opto{j} = temps;
    
    beforeidx{j}=find(tps_Opto{j}>-timeWindow&tps_Opto{j}<0); % to restrict time to the time window (defined above)
    duringidx{j}=find(tps_Opto{j}>0&tps_Opto{j}<timeWindow);
    
    freq{j}=[1:size(SpectroREM_Opto{j},1)]/size(SpectroREM_Opto{j},1)*100;
    idxfreq{j}=find(freq{j}>40&freq{j}<60); % to restrict frequencies to the gamma band
    
    % get the theta band in the time window of interest
    thetaBandREM_opto{j} = SpectroREM_Opto{j}(idxfreq{j},:);
    thetaBandWake_opto{j} = SpectroWake_Opto{j}(idxfreq{j},:);
    thetaBandSWS_opto{j} = SpectroSWS_Opto{j}(idxfreq{j},:);

    ThetaBandREM_Opto_Before{j} = SpectroREM_Opto{j}(idxfreq{j},beforeidx{j}');
    ThetaBandREM_Opto_During{j} = SpectroREM_Opto{j}(idxfreq{j},duringidx{j}');
    ThetaBandSWS_Opto_Before{j} = SpectroSWS_Opto{j}(idxfreq{j},beforeidx{j}');
    ThetaBandSWS_Opto_During{j} = SpectroSWS_Opto{j}(idxfreq{j},duringidx{j}');
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
    for jj=1:length(thetaBandSWS_opto)
        AvThetaSWSopto(jj,:)=nanmean(thetaBandSWS_opto{jj});
    end
    for jj=1:length(ThetaBandREM_Opto_Before)
        AvThetaREMoptoBefore(jj,:)=nanmean(nanmean(ThetaBandREM_Opto_Before{jj}));
    end
    for jj=1:length(ThetaBandREM_Opto_During)
        AvThetaREMOptoDuring(jj,:)=nanmean(nanmean(ThetaBandREM_Opto_During{jj}));
    end
    for jj=1:length(ThetaBandSWS_Opto_Before)
        AvThetaSWSoptoBefore(jj,:)=nanmean(nanmean(ThetaBandSWS_Opto_Before{jj}));
    end
    for jj=1:length(ThetaBandSWS_Opto_During)
        AvThetaSWSOptoDuring(jj,:)=nanmean(nanmean(ThetaBandSWS_Opto_During{jj}));
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

dataSpSWS=cat(3,SpectroSWS_Ctrl{:});
avdataSpSWS=nanmean(dataSpSWS,3);
dataSpSWSopto=cat(3,SpectroSWS_Opto{:});
avdataSpSWSopto=nanmean(dataSpSWSopto,3);


%% figures
%% panel pour le REM (spectro + barplot)
% freq=[1:size(SpectroREMG,1)]/size(SpectroREMG,1)*100;
freq=[40:80];

figure('color',[1 1 1]), subplot(2,4,[1:2]), imagesc(temps,freq, avdataSpREMopto),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM opto')
set(gca,'FontSize', 20)

subplot(2,4,[5:6]), imagesc(temps,freq, avdataSpREM),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([40 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB REM control')
set(gca,'FontSize', 20)

subplot(2,4,[3,7]),PlotErrorBarN_KJ({AvThetaREMoptoBefore, AvThetaREMOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM opto')
set(gca,'FontSize', 20)

subplot(2,4,[4,8]),PlotErrorBarN_KJ({AvThetaREMBefore, AvThetaREMDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM control')
set(gca,'FontSize', 20)


%% panel pour le SWS (spectro + barplot)
% freq=[1:size(SpectroSWSG,1)]/size(SpectroSWSG,1)*80;

figure('color',[1 1 1]), subplot(2,4,[1:2]), imagesc(temps,freq, avdataSpSWSopto),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([20 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB NREM opto')
set(gca,'FontSize', 20)

subplot(2,4,[5:6]), imagesc(temps,freq, avdataSpSWS),axis xy, caxis([0 2.5]), colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([20 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB NREM control')
set(gca,'FontSize', 20)

subplot(2,4,[3,7]),PlotErrorBarN_KJ({AvThetaSWSoptoBefore, AvThetaSWSOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM opto')
set(gca,'FontSize', 20)

subplot(2,4,[4,8]),PlotErrorBarN_KJ({AvThetaSWSBefore, AvThetaSWSDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM control')
set(gca,'FontSize', 20)


%% panel pour le Wake (spectro + barplot)
figure('color',[1 1 1]), subplot(2,4,[1:2]), imagesc(temps,freq, avdataSpWakeOpto),caxis([0 2.5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([20 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake opto')
set(gca,'FontSize', 20)

subplot(2,4,[5:6]), imagesc(temps,freq, avdataSpWake),caxis([0 2.5]),axis xy, colormap(jet)
line([0 0], ylim,'color','w','linestyle','-')
xlim([-30 30])
ylim([20 +80])
xlabel('Time (s)')
ylabel('Frequency (Hz)')
colorbar
title('OB Wake control')
set(gca,'FontSize', 20)

subplot(2,4,[3,7]),PlotErrorBarN_KJ({AvThetaWakeOptoBefore AvThetaWakeOptoDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.2])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake opto')
set(gca,'FontSize', 20)

subplot(2,4,[4,8]),PlotErrorBarN_KJ({AvThetaWakeBefore AvThetaWakeDuring},'newfig',0,'paired',1,'ShowSigstar','sig');
ylim([0 1.2])
ylabel('Gamma power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake control')
set(gca,'FontSize', 20)

%% gamma power overtime (for REM SWS and wakefulness)
figure, hold on,
shadedErrorBar(temps,AvThetaREMctrl,{@mean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaREMopto,{@mean,@stdError},'-g',1);
xlim([-30 +30])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power during REM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 20)

figure, hold on,
shadedErrorBar(temps,AvThetaSWSctrl,{@nanmean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaSWSopto,{@nanmean,@stdError},'-r',1);
xlim([-30 +30])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power during NREM')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 20)

figure, hold on,
shadedErrorBar(temps,AvThetaWakectrl,{@nanmean,@stdError},'-k',1);
shadedErrorBar(temps,AvThetaWakeopto,{@nanmean,@stdError},'-b',1);
xlim([-30 +30])
ylim([0 1.5])
xlabel('Time (s)')
ylabel('normalized gamma power')
title('gamma power during wakefulness')
line([0 0], ylim,'color','k','linestyle',':')
set(gca,'FontSize', 20)

%% spectro log
% figure
% subplot(211)
% imagesc(temps,freq, log(avdataSpREMopto)),axis xy
% caxis([6.7 9.98])
% caxis([7 9.9])
% ylim([10 30])
% line([0 0],ylim,'color','w','linestyle','-')
% title('opto')
% subplot(212)
% imagesc(temps,freq, log(avdataSpREM)),axis xy
% caxis([6.7 9.98])
% caxis([7 9.9])
% ylim([10 30])
% line([0 0],ylim,'color','w','linestyle','-')
% title('ctrl')
