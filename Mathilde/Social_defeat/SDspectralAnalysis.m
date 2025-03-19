%% input dir : social defeat
%% input dir : social defeat
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

DirSocialDefeat = PathForExperimentsSD_MC('SensoryExposureCD1cage');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1148 1149 1150 1217 1218 1219 1220]);

% DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);

Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

%%
spectro = 'Bulb_deep_Low_Spectrum.mat';
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
%load('Bulb_deep_Low_Spectrum.mat');
% load('dHPC_deep_Low_Spectrum.mat');
% load('dHPC_VHigh_Spectrum.mat')

%% get the data
%baseline sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});

    
    a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    
    %3h post injection
%     epoch_3hPostSD_Basal{i}=intervalSet(0*3600*1E4,3*3600*1E4);
    epoch_3hPostSD_Basal{i}=intervalSet(0*3600*1E4,0.3*3600*1E4);
    
    %3 hours following first sleep episode
    [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,5,20); tpsFirstSleep{i}=tpsFirstSWS;
    epoch_3hPostSD_Basal{i}=intervalSet(tpsFirstSleep{i}*1e4,tpsFirstSleep{i}*1e4+3*3600*1E4);
    
        

    if exist(spectro)==2
        load(spectro);
        spectre_baseline = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_baseline = Spectro{3};
        sp_basal{i}  = spectre_baseline;
        freq_basal{i}  = frequence_baseline;
    else
    end
%     
% else
% end

end
%%

%social defeat
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});

    if exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
        
    durtotal_SD{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %3h post injection
%     epoch_3hPostSD_SD{j}=intervalSet(0*3600*1E4,3*3600*1E4);
        epoch_3hPostSD_SD{j}=intervalSet(0*3600*1E4,durtotal_SD{j} );

        else
    end
%                 %3 hours following first sleep episode
% [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,5,20); tpsFirstSleep_SD{j}=tpsFirstSWS;
% epoch_3hPostSD_SD{j}=intervalSet(tpsFirstSleep_SD{j}*1e4,tpsFirstSleep_SD{j}*1e4+3*3600*1E4);




    if exist(spectro)==2
        load(spectro);
        spectre_SD = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_SD = Spectro{3};
        sp_SD{j} = spectre_SD;
        freq_SD{j} = frequence_SD;
    else
    end

end

%% calculate mean
for i=1:length(DirMyBasal.path)
    sp_Basal_WAKE_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},a{i}.Wake))),1);
    sp_Basal_SWS_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},a{i}.SWSEpoch))),1);
    sp_Basal_REM_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},a{i}.REMEpoch))),1);
    
    %restrict to 3h post SD
    sp_Basal_WAKE_3hPostSD_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.Wake,epoch_3hPostSD_Basal{i})))),1);
    sp_Basal_SWS_3hPostSD_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.SWSEpoch,epoch_3hPostSD_Basal{i})))),1);
    sp_Basal_REM_3hPostSD_mean(i,:)=nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.REMEpoch,epoch_3hPostSD_Basal{i})))),1);
end
%%
for j=1:length(DirSocialDefeat.path)
    if isempty(sp_SD{j})==0
    sp_SD_WAKE_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},b{j}.Wake))),1);
    sp_SD_SWS_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},b{j}.SWSEpoch))),1);
    sp_SD_REM_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},b{j}.REMEpoch))),1);
        sp_SD_mean(j,:)=nanmean(10*(Data(sp_SD{j})),1); sp_SD_mean(sp_SD_mean==0)=NaN;
   
    %%restrict to 3h post SD
    sp_SD_WAKE_3hPostSD_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.Wake,epoch_3hPostSD_SD{j})))),1);
    sp_SD_SWS_3hPostSD_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.SWSEpoch,epoch_3hPostSD_SD{j})))),1);
    sp_SD_REM_3hPostSD_mean(j,:)=nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.REMEpoch,epoch_3hPostSD_SD{j})))),1);
    else
    end
end

%% calculate SEM
sp_Basal_WAKE_std=nanstd(sp_Basal_WAKE_mean)/sqrt(size(sp_Basal_WAKE_mean,1));
sp_Basal_SWS_std=nanstd(sp_Basal_SWS_mean)/sqrt(size(sp_Basal_SWS_mean,1));
sp_Basal_REM_std=nanstd(sp_Basal_REM_mean)/sqrt(size(sp_Basal_REM_mean,1));
%restrict to 3h post SD
sp_Basal_WAKE_3hPostSD_std=nanstd(sp_Basal_WAKE_3hPostSD_mean)/sqrt(size(sp_Basal_WAKE_3hPostSD_mean,1));
sp_Basal_SWS_3hPostSD_std=nanstd(sp_Basal_SWS_3hPostSD_mean)/sqrt(size(sp_Basal_SWS_3hPostSD_mean,1));
sp_Basal_REM_3hPostSD_std=nanstd(sp_Basal_REM_3hPostSD_mean)/sqrt(size(sp_Basal_REM_3hPostSD_mean,1));

sp_SD_WAKE_std=nanstd(sp_SD_WAKE_mean)/sqrt(size(sp_SD_WAKE_mean,1));
sp_SD_SWS_std=nanstd(sp_SD_SWS_mean)/sqrt(size(sp_SD_SWS_mean,1));
sp_SD_REM_std=nanstd(sp_SD_REM_mean)/sqrt(size(sp_SD_REM_mean,1));
%restrict to 3h post SD
sp_SD_WAKE_3hPostSD_std=nanstd(sp_SD_WAKE_3hPostSD_mean)/sqrt(size(sp_SD_WAKE_3hPostSD_mean,1));
sp_SD_SWS_3hPostSD_std=nanstd(sp_SD_SWS_3hPostSD_mean)/sqrt(size(sp_SD_SWS_3hPostSD_mean,1));
sp_SD_REM_3hPostSD_std=nanstd(sp_SD_REM_3hPostSD_mean)/sqrt(size(sp_SD_REM_3hPostSD_mean,1));


sp_SD_std=nanstd(sp_SD_mean)/sqrt(size(sp_SD_mean,1)); sp_SD_std(sp_SD_std==0)=NaN;

%% figure
figure,
ax(1)=subplot(231),shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_WAKE_mean), sp_Basal_WAKE_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_WAKE_mean), sp_SD_WAKE_std, 'r',1);
ylabel('all sleep post SD')
title('WAKE')
makepretty
ax(2)=subplot(232),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_SWS_mean), sp_Basal_SWS_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_SWS_mean), sp_SD_SWS_std, 'r',1);
title('NREM')
makepretty
ax(3)=subplot(233),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_REM_mean), sp_Basal_REM_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_REM_mean), sp_SD_REM_std, 'r',1);
title('REM')
makepretty

% set(ax,'xlim',[0 15],'ylim',[0 6e6]);

% figure : 3h post SD
ax(4)=subplot(234),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_WAKE_3hPostSD_mean), sp_Basal_WAKE_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_WAKE_3hPostSD_mean), sp_SD_WAKE_3hPostSD_std, 'r',1);
ylabel('3h post SD')
title('WAKE')
makepretty
ax(5)=subplot(235),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_SWS_3hPostSD_mean), sp_Basal_SWS_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_SWS_3hPostSD_mean), sp_SD_SWS_3hPostSD_std, 'r',1);
title('NREM')
makepretty
ax(6)=subplot(236),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_REM_3hPostSD_mean), sp_Basal_REM_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_REM_3hPostSD_mean), sp_SD_REM_3hPostSD_std, 'r',1);
title('REM')
makepretty

% set(ax,'xlim',[0 15],'ylim',[0 2e6]);


%%%%%%%%%%%%%%
%% figure (PFC inhibition)
figure,
ax(1)=subplot(231),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_WAKE_mean), sp_Basal_WAKE_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},b{1}.Wake))),1), 'r');
ylabel('all sleep post SD')
title('WAKE')
makepretty
ax(2)=subplot(232),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_SWS_mean), sp_Basal_SWS_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},b{1}.SWSEpoch))),1), 'r');
title('NREM')
makepretty
ax(3)=subplot(233),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_REM_mean), sp_Basal_REM_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},b{1}.REMEpoch))),1), 'r');
title('REM')
makepretty

%%3h post SD
ax(4)=subplot(234),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_WAKE_3hPostSD_mean), sp_Basal_WAKE_3hPostSD_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},and(b{1}.Wake,epoch_3hPostSD_SD{1})))),1), 'r');
ylabel('3h post SD')
title('WAKE')
makepretty
ax(5)=subplot(235),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_SWS_3hPostSD_mean), sp_Basal_SWS_3hPostSD_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},and(b{1}.SWSEpoch,epoch_3hPostSD_SD{1})))),1), 'r');
title('NREM')
makepretty
ax(5)=subplot(236),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_REM_3hPostSD_mean), sp_Basal_REM_3hPostSD_std, 'k',1); hold on,
plot(freq_SD{1}, nanmean(10*(Data(Restrict(sp_SD{1},and(b{1}.REMEpoch,epoch_3hPostSD_SD{1})))),1), 'r');
title('REM')
makepretty
set(ax,'xlim',[0 15],'ylim',[0 4e6]);



%%

%% add peak
peak_basal_WAKE_mean=findpeaks(nanmean(sp_Basal_WAKE_3hPostSD_mean));
peak_SD_WAKE_mean=findpeaks(nanmean(sp_SD_WAKE_3hPostSD_mean));

peak_basal_SWS_mean=findpeaks(nanmean(sp_Basal_SWS_3hPostSD_mean));
peak_SD_SWS_mean=findpeaks(nanmean(sp_SD_SWS_3hPostSD_mean));

peak_basal_REM_mean=findpeaks(nanmean(sp_Basal_REM_3hPostSD_mean));
peak_SD_REM_mean=findpeaks(nanmean(sp_SD_REM_3hPostSD_mean));


if peak_basal_WAKE_mean.loc(1)>1
        peak_basal_WAKE_mean=peak_basal_WAKE_mean.loc(1);
    else
        peak_basal_WAKE_mean=peak_basal_WAKE_mean.loc(2);
end
    
if peak_SD_WAKE_mean.loc(1)>1
        peak_SD_WAKE_mean=peak_SD_WAKE_mean.loc(1);
    else
        peak_SD_WAKE_mean=peak_SD_WAKE_mean.loc(1);
end

if peak_basal_SWS_mean.loc(1)>1
        peak_basal_SWS_mean=peak_basal_SWS_mean.loc(1);
    else
        peak_basal_SWS_mean=peak_basal_SWS_mean.loc(2);
end

if peak_SD_SWS_mean.loc(1)>1
        peak_SD_SWS_mean=peak_SD_SWS_mean.loc(1);
    else
        peak_SD_SWS_mean=peak_SD_SWS_mean.loc(2);
end

if peak_basal_REM_mean.loc(1)>1
        peak_basal_REM_mean=peak_basal_REM_mean.loc(1);
    else
        peak_basal_REM_mean=peak_basal_REM_mean.loc(2);
end

if peak_SD_REM_mean.loc(1)>1
        peak_SD_REM_mean=peak_SD_REM_mean.loc(1);
    else
        peak_SD_REM_mean=peak_SD_REM_mean.loc(2);
end

%%
% figure : 3h post SD
figure
ax1(1)=subplot(131),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_WAKE_3hPostSD_mean), sp_Basal_WAKE_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_WAKE_3hPostSD_mean), sp_SD_WAKE_3hPostSD_std, 'r',1);
line([freq_SD{1}(peak_basal_WAKE_mean) freq_SD{1}(peak_basal_WAKE_mean)],ylim,'color','k','linestyle',':')
line([freq_SD{1}(peak_SD_WAKE_mean) freq_SD{1}(peak_SD_WAKE_mean)],ylim,'color','r','linestyle',':')
ylabel('3h post SD')
title('WAKE')
makepretty


ax1(2)=subplot(132),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_SWS_3hPostSD_mean), sp_Basal_SWS_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_SWS_3hPostSD_mean), sp_SD_SWS_3hPostSD_std, 'r',1);
line([freq_SD{1}(peak_basal_SWS_mean) freq_SD{1}(peak_basal_SWS_mean)],ylim,'color','k','linestyle',':')
line([freq_SD{1}(peak_SD_SWS_mean) freq_SD{1}(peak_SD_SWS_mean)],ylim,'color','r','linestyle',':')
title('NREM')
makepretty


ax1(3)=subplot(133),shadedErrorBar(freq_SD{1}, nanmean(sp_Basal_REM_3hPostSD_mean), sp_Basal_REM_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_REM_3hPostSD_mean), sp_SD_REM_3hPostSD_std, 'r',1);
line([freq_SD{1}(peak_basal_REM_mean) freq_SD{1}(peak_basal_REM_mean)],ylim,'color','k','linestyle',':')
line([freq_SD{1}(peak_SD_REM_mean) freq_SD{1}(peak_SD_REM_mean)],ylim,'color','r','linestyle',':')
title('REM')
makepretty

set(ax1,'xlim',[0 15],'ylim',[0 6e6]);


%%
%%%%%%%%%%%%%%%%%%%%%%

%% quantif peak freq
%%baseline
for i=1:length(DirMyBasal.path)
 pks_WAKE_3hPostSD_basal{i}=findpeaks(nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.Wake,epoch_3hPostSD_Basal{i})))),1));
    pks_SWS_3hPostSD_basal{i}=findpeaks(nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.SWSEpoch,epoch_3hPostSD_Basal{i})))),1));
    pks_REM_3hPostSD_basal{i}=findpeaks(nanmean(10*(Data(Restrict(sp_basal{i},and(a{i}.REMEpoch,epoch_3hPostSD_Basal{i})))),1));
end
for i=1:length(DirMyBasal.path)
    %%rem
    if pks_REM_3hPostSD_basal{i}.loc(1)>1
        pks_REM_3hPostSD_basal{i}=pks_REM_3hPostSD_basal{i}.loc(1);
    else
        pks_REM_3hPostSD_basal{i}=pks_REM_3hPostSD_basal{i}.loc(2);
    end
    
    
    
    %%wake
    if pks_WAKE_3hPostSD_basal{i}.loc(1)>=1
        pks_WAKE_3hPostSD_basal{i}=pks_WAKE_3hPostSD_basal{i}.loc(1);
    else
        pks_WAKE_3hPostSD_basal{i}=pks_WAKE_3hPostSD_basal{i}.loc(2);
    end
    
    
    
    
    %%sws
    if pks_SWS_3hPostSD_basal{i}.loc(1)>=1
        pks_SWS_3hPostSD_basal{i}=pks_SWS_3hPostSD_basal{i}.loc(1);

    else
        pks_SWS_3hPostSD_basal{i}=pks_SWS_3hPostSD_basal{i}.loc(2);
    end
end
for i=1:length(DirMyBasal.path)
    frqPeak_WAKE_3hPostSD_basal(i) = freq_basal{1}(pks_WAKE_3hPostSD_basal{i});
    frqPeak_SWS_3hPostSD_basal(i) = freq_basal{1}(pks_SWS_3hPostSD_basal{i});
    frqPeak_REM_3hPostSD_basal(i) = freq_basal{1}(pks_REM_3hPostSD_basal{i});
end
%%
%%%%%SD
for j=1:length(DirSocialDefeat.path)
    pks_WAKE_3hPostSD_SD{j}=findpeaks(nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.Wake,epoch_3hPostSD_SD{j})))),1));
    pks_SWS_3hPostSD_SD{j}=findpeaks(nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.SWSEpoch,epoch_3hPostSD_SD{j})))),1));
    pks_REM_3hPostSD_SD{j}=findpeaks(nanmean(10*(Data(Restrict(sp_SD{j},and(b{j}.REMEpoch,epoch_3hPostSD_SD{j})))),1));
end
for j=1:length(DirSocialDefeat.path)
    %%rem
    if isempty(pks_REM_3hPostSD_SD{j}.loc)==0
        
        if pks_REM_3hPostSD_SD{j}.loc(1)>=1
            pks_REM_3hPostSD_SD{j}=pks_REM_3hPostSD_SD{j}.loc(1);
        else
            pks_REM_3hPostSD_SD{j}=pks_REM_3hPostSD_SD{j}.loc(2);
        end
    else
        pks_REM_3hPostSD_SD{j}=NaN;
        
    end
    
    
    %%wake
    if pks_WAKE_3hPostSD_SD{j}.loc(1)>=1
        pks_WAKE_3hPostSD_SD{j}=pks_WAKE_3hPostSD_SD{j}.loc(1);
    else
        pks_WAKE_3hPostSD_SD{j}=pks_WAKE_3hPostSD_SD{j}.loc(2);
    end
   
    
    %%sws
    if isempty(pks_SWS_3hPostSD_SD{j}.loc)==0
        if pks_SWS_3hPostSD_SD{j}.loc(1)>=1
            pks_SWS_3hPostSD_SD{j}=pks_SWS_3hPostSD_SD{j}.loc(1);
        else
            pks_SWS_3hPostSD_SD{j}=pks_SWS_3hPostSD_SD{j}.loc(2);
        end
    else
    end
    
end
%%
for j=1:length(DirSocialDefeat.path)
    
    frqPeak_WAKE_3hPostSD_SD(j) = freq_SD{1}(pks_WAKE_3hPostSD_SD{j});
    
    frqPeak_SWS_3hPostSD_SD(j) = freq_SD{1}(pks_SWS_3hPostSD_SD{j});

    
    if isnan(pks_REM_3hPostSD_SD{j})==0
        frqPeak_REM_3hPostSD_SD(j) = freq_SD{1}(pks_REM_3hPostSD_SD{j});
    else
        frqPeak_REM_3hPostSD_SD(j) = NaN;
    end
end


%%
ax2(1) = axes('Position',[.24 .6 .1 .3]);
box on
MakeBoxPlot_MC({frqPeak_WAKE_3hPostSD_basal,frqPeak_WAKE_3hPostSD_SD},{[0.2 0.2 0.2],[1 0 0]},[1,2],{'Baseline','SD'},1,0)
p = ranksum(frqPeak_WAKE_3hPostSD_basal,frqPeak_WAKE_3hPostSD_SD);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',20);
end
box off
title('','FontSize',18,'FontWeight','bold');
makepretty


ax2(2) = axes('Position',[.52 .6 .1 .3]);
box on
MakeBoxPlot_MC({frqPeak_SWS_3hPostSD_basal,frqPeak_SWS_3hPostSD_SD},{[0.2 0.2 0.2],[1 0 0]},[1,2],{'Baseline','SD'},1,0)
p = ranksum(frqPeak_SWS_3hPostSD_basal,frqPeak_SWS_3hPostSD_SD);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',20);
end
box off
title('','FontSize',18,'FontWeight','bold');
makepretty



ax2(3) = axes('Position',[.8 .6 .1 .3]);
box on
MakeBoxPlot_MC({frqPeak_REM_3hPostSD_basal,frqPeak_REM_3hPostSD_SD},{[0.2 0.2 0.2],[1 0 0]},[1,2],{'Baseline','SD'},1,0)
p = ranksum(frqPeak_REM_3hPostSD_basal,frqPeak_REM_3hPostSD_SD);
if p<0.05
    sigstar_DB({[1 2]},p,0,'LineWigth',16,'StarSize',20);
end
box off
title('','FontSize',18,'FontWeight','bold');
makepretty

