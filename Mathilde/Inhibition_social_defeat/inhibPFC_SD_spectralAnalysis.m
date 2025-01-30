%% input dir : social defeat
%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%%dir PFC inhibition
% Dir_inhibPFC = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
Dir_inhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');

%%dir social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');

%%dir social defeat + PFC inhibition 
% Dir_inhibPFC_SD = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
Dir_inhibPFC_SD = PathForExperimentsSD_MC('SleepPostSD_retroCre');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%%
spectro = 'Bulb_deep_Low_Spectrum.mat';
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('dHPC_deep_Low_Spectrum.mat');
% load('dHPC_VHigh_Spectrum.mat');

%% get the data
%%baseline sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
        a{i} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
        durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
        %3h post injection
        epoch_3hPostSD_Basal{i}=intervalSet(0,3*3600*1E4);

        if exist(spectro)==2
            load(spectro);
            spectre_baseline = tsd(Spectro{2}*1E4,Spectro{1});
            frequence_baseline = Spectro{3};
            sp_basal{i}  = spectre_baseline;
            freq_basal{i}  = frequence_baseline;
        else
        end
end

%social defeat
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
        b{j} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_SD{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %3h post injection
    epoch_3hPostSD_SD{j}=intervalSet(0,3*3600*1E4);

    if exist(spectro)==2
        load(spectro);
        spectre_SD = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_SD = Spectro{3};
        sp_SD{j} = spectre_SD;
        freq_SD{j} = frequence_SD;
    else
    end
end

%%PFC inhibition
for k=1:length(Dir_inhibPFC.path)
    cd(Dir_inhibPFC.path{k}{1});
        c{k} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_inhibPFC{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %3h post injection
    epoch_3hPostSD_inhibPFC{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1E4);

    if exist(spectro)==2
        load(spectro);
        spectre_inhibPFC = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_inhibPFC = Spectro{3};
        sp_inhibPFC{k} = spectre_inhibPFC;
        freq_inhibPFC{k} = frequence_inhibPFC;
    else
    end
end
% 
%%PFC inhibition + SD
for l=1:length(Dir_inhibPFC_SD.path)
    cd(Dir_inhibPFC_SD.path{l}{1});
        d{l} = load('SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
    durtotal_inhibPFC_SD{l} = max([max(End(d{l}.Wake)),max(End(d{l}.SWSEpoch))]);
    %3h post injection
    epoch_3hPostSD_inhibPFC_SD{l}=intervalSet(0,3*3600*1E4);

    if exist(spectro)==2
        load(spectro);
        spectre_inhibPFC_SD = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_inhibPFC_SD = Spectro{3};
        sp_inhibPFC_SD{l} = spectre_inhibPFC_SD;
        freq_inhibPFC_SD{l} = frequence_inhibPFC_SD;
    else
    end
end


%% calculate mean
%baseline sleep
for ii=1:length(DirMyBasal.path)
    sp_Basal_WAKE_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},a{ii}.Wake))),1);
    sp_Basal_SWS_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},a{ii}.SWSEpoch))),1);
    sp_Basal_REM_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},a{ii}.REMEpoch))),1);
    %restrict to 3h post SD
    sp_Basal_WAKE_3hPostSD_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},and(a{ii}.Wake,epoch_3hPostSD_Basal{ii})))),1);
    sp_Basal_SWS_3hPostSD_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},and(a{ii}.SWSEpoch,epoch_3hPostSD_Basal{ii})))),1);
    sp_Basal_REM_3hPostSD_mean(ii,:)=nanmean(10*(Data(Restrict(sp_basal{ii},and(a{ii}.REMEpoch,epoch_3hPostSD_Basal{ii})))),1);
end

%social defeat
for jj=1:length(DirSocialDefeat.path)
    if isempty(sp_SD{jj})==0
    sp_SD_WAKE_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},b{jj}.Wake))),1);
    sp_SD_SWS_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},b{jj}.SWSEpoch))),1);
    sp_SD_REM_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},b{jj}.REMEpoch))),1);
    %%restrict to 3h post SD
    sp_SD_WAKE_3hPostSD_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},and(b{jj}.Wake,epoch_3hPostSD_SD{jj})))),1);
    sp_SD_SWS_3hPostSD_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},and(b{jj}.SWSEpoch,epoch_3hPostSD_SD{jj})))),1);
    sp_SD_REM_3hPostSD_mean(jj,:)=nanmean(10*(Data(Restrict(sp_SD{jj},and(b{jj}.REMEpoch,epoch_3hPostSD_SD{jj})))),1);
    else
    end
end

%%PFC inhibition
for kk=1:length(Dir_inhibPFC.path)
    if isempty(sp_inhibPFC{kk})==0
    sp_inhibPFC_WAKE_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},c{kk}.Wake))),1);
    sp_inhibPFC_SWS_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},c{kk}.SWSEpoch))),1);
    sp_inhibPFC_REM_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},c{kk}.REMEpoch))),1);
    %%restrict to 3h post SD
    sp_inhibPFC_WAKE_3hPostSD_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},and(c{kk}.Wake,epoch_3hPostSD_inhibPFC{kk})))),1);
    sp_inhibPFC_SWS_3hPostSD_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},and(c{kk}.SWSEpoch,epoch_3hPostSD_inhibPFC{kk})))),1);
    sp_inhibPFC_REM_3hPostSD_mean(kk,:)=nanmean(10*(Data(Restrict(sp_inhibPFC{kk},and(c{kk}.REMEpoch,epoch_3hPostSD_inhibPFC{kk})))),1);
    else
    end
end

%%PFC inhibition + SD
for ll=1:length(Dir_inhibPFC_SD.path)
    if isempty(sp_inhibPFC_SD{ll})==0
    sp_inhibPFC_SD_WAKE_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},d{ll}.Wake))),1);
    sp_inhibPFC_SD_SWS_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},d{ll}.SWSEpoch))),1);
    sp_inhibPFC_SD_REM_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},d{ll}.REMEpoch))),1);
    %%restrict to 3h post SD
    sp_inhibPFC_SD_WAKE_3hPostSD_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},and(d{ll}.Wake,epoch_3hPostSD_inhibPFC_SD{ll})))),1);
    sp_inhibPFC_SD_SWS_3hPostSD_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},and(d{ll}.SWSEpoch,epoch_3hPostSD_inhibPFC_SD{ll})))),1);
    sp_inhibPFC_SD_REM_3hPostSD_mean(ll,:)=nanmean(10*(Data(Restrict(sp_inhibPFC_SD{ll},and(d{ll}.REMEpoch,epoch_3hPostSD_inhibPFC_SD{ll})))),1);
    else
    end
end






%% calculate SEM
%%baseline
sp_Basal_WAKE_std=nanstd(sp_Basal_WAKE_mean)/sqrt(size(sp_Basal_WAKE_mean,1));
sp_Basal_SWS_std=nanstd(sp_Basal_SWS_mean)/sqrt(size(sp_Basal_SWS_mean,1));
sp_Basal_REM_std=nanstd(sp_Basal_REM_mean)/sqrt(size(sp_Basal_REM_mean,1));
%restrict to 3h post SD
sp_Basal_WAKE_3hPostSD_std=nanstd(sp_Basal_WAKE_3hPostSD_mean)/sqrt(size(sp_Basal_WAKE_3hPostSD_mean,1));
sp_Basal_SWS_3hPostSD_std=nanstd(sp_Basal_SWS_3hPostSD_mean)/sqrt(size(sp_Basal_SWS_3hPostSD_mean,1));
sp_Basal_REM_3hPostSD_std=nanstd(sp_Basal_REM_3hPostSD_mean)/sqrt(size(sp_Basal_REM_3hPostSD_mean,1));

%%social defeat
sp_SD_WAKE_std=nanstd(sp_SD_WAKE_mean)/sqrt(size(sp_SD_WAKE_mean,1));
sp_SD_SWS_std=nanstd(sp_SD_SWS_mean)/sqrt(size(sp_SD_SWS_mean,1));
sp_SD_REM_std=nanstd(sp_SD_REM_mean)/sqrt(size(sp_SD_REM_mean,1));
%restrict to 3h post SD
sp_SD_WAKE_3hPostSD_std=nanstd(sp_SD_WAKE_3hPostSD_mean)/sqrt(size(sp_SD_WAKE_3hPostSD_mean,1));
sp_SD_SWS_3hPostSD_std=nanstd(sp_SD_SWS_3hPostSD_mean)/sqrt(size(sp_SD_SWS_3hPostSD_mean,1));
sp_SD_REM_3hPostSD_std=nanstd(sp_SD_REM_3hPostSD_mean)/sqrt(size(sp_SD_REM_3hPostSD_mean,1));

% 
%%PFC inhibition
sp_inhibPFC_WAKE_std=nanstd(sp_inhibPFC_WAKE_mean)/sqrt(size(sp_inhibPFC_WAKE_mean,1));
sp_inhibPFC_SWS_std=nanstd(sp_inhibPFC_SWS_mean)/sqrt(size(sp_inhibPFC_SWS_mean,1));
sp_inhibPFC_REM_std=nanstd(sp_inhibPFC_REM_mean)/sqrt(size(sp_inhibPFC_REM_mean,1));
%restrict to 3h post SD
sp_inhibPFC_WAKE_3hPostSD_std=nanstd(sp_inhibPFC_WAKE_3hPostSD_mean)/sqrt(size(sp_inhibPFC_WAKE_3hPostSD_mean,1));
sp_inhibPFC_SWS_3hPostSD_std=nanstd(sp_inhibPFC_SWS_3hPostSD_mean)/sqrt(size(sp_inhibPFC_SWS_3hPostSD_mean,1));
sp_inhibPFC_REM_3hPostSD_std=nanstd(sp_inhibPFC_REM_3hPostSD_mean)/sqrt(size(sp_inhibPFC_REM_3hPostSD_mean,1));


%%PFC inhibition + SD
sp_inhibPFC_SD_WAKE_std=nanstd(sp_inhibPFC_SD_WAKE_mean)/sqrt(size(sp_inhibPFC_SD_WAKE_mean,1));
sp_inhibPFC_SD_SWS_std=nanstd(sp_inhibPFC_SD_SWS_mean)/sqrt(size(sp_inhibPFC_SD_SWS_mean,1));
sp_inhibPFC_SD_REM_std=nanstd(sp_inhibPFC_SD_REM_mean)/sqrt(size(sp_inhibPFC_SD_REM_mean,1));
%restrict to 3h post SD
sp_inhibPFC_SD_WAKE_3hPostSD_std=nanstd(sp_inhibPFC_SD_WAKE_3hPostSD_mean)/sqrt(size(sp_inhibPFC_SD_WAKE_3hPostSD_mean,1));
sp_inhibPFC_SD_SWS_3hPostSD_std=nanstd(sp_inhibPFC_SD_SWS_3hPostSD_mean)/sqrt(size(sp_inhibPFC_SD_SWS_3hPostSD_mean,1));
sp_inhibPFC_SD_REM_3hPostSD_std=nanstd(sp_inhibPFC_SD_REM_3hPostSD_mean)/sqrt(size(sp_inhibPFC_SD_REM_3hPostSD_mean,1));








%% figure
% figure,
% ax(1)=subplot(231),
% shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_WAKE_mean), sp_Basal_WAKE_std, 'k',1); hold on,
% shadedErrorBar(freq_SD{1}, nanmean(sp_SD_WAKE_mean), sp_SD_WAKE_std, 'r',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_WAKE_mean), sp_inhibPFC_WAKE_std, 'b',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_SD_WAKE_mean), sp_inhibPFC_SD_WAKE_std, 'g',1);
% ylabel('Power (a.u)')
% title('WAKE - post SD')
% makepretty
% ax(2)=subplot(232),
% shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_SWS_mean), sp_Basal_SWS_std, 'k',1); hold on,
% shadedErrorBar(freq_SD{1}, nanmean(sp_SD_SWS_mean), sp_SD_SWS_std, 'r',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_SWS_mean), sp_inhibPFC_SWS_std, 'b',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_SD_SWS_mean), sp_inhibPFC_SD_SWS_std, 'g',1);
% title('NREM - post SD')
% makepretty
% ax(3)=subplot(233),
% shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_REM_mean), sp_Basal_REM_std, 'k',1); hold on,
% shadedErrorBar(freq_SD{1}, nanmean(sp_SD_REM_mean), sp_SD_REM_std, 'r',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_REM_mean), sp_inhibPFC_REM_std, 'b',1);
% shadedErrorBar(freq_SD{1}, nanmean(sp_inhibPFC_SD_REM_mean), sp_inhibPFC_SD_REM_std, 'g',1);
% title('REM - post SD')
% makepretty

% set(ax,'xlim',[0 15],'ylim',[0 6e6]);

% figure : 3h post SD
figure
ax(4)=subplot(234),
shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_WAKE_3hPostSD_mean), sp_Basal_WAKE_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_WAKE_3hPostSD_mean), sp_SD_WAKE_3hPostSD_std, 'r',1);
shadedErrorBar(freq_inhibPFC{1}, nanmean(sp_inhibPFC_WAKE_3hPostSD_mean), sp_inhibPFC_WAKE_3hPostSD_std, 'b',1);
shadedErrorBar(freq_inhibPFC_SD{1}, nanmean(sp_inhibPFC_SD_WAKE_3hPostSD_mean), sp_inhibPFC_SD_WAKE_3hPostSD_std, 'g',1);
ylabel('Power (a.u)')
title('WAKE - 3h post SD')
makepretty
ax(5)=subplot(235),
shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_SWS_3hPostSD_mean), sp_Basal_SWS_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_SWS_3hPostSD_mean), sp_SD_SWS_3hPostSD_std, 'r',1);
shadedErrorBar(freq_inhibPFC{1}, nanmean(sp_inhibPFC_SWS_3hPostSD_mean), sp_inhibPFC_SWS_3hPostSD_std, 'b',1);
shadedErrorBar(freq_inhibPFC_SD{1}, nanmean(sp_inhibPFC_SD_SWS_3hPostSD_mean), sp_inhibPFC_SD_SWS_3hPostSD_std, 'g',1);
title('NREM - 3h post SD')
makepretty
ax(6)=subplot(236),
shadedErrorBar(freq_basal{1}, nanmean(sp_Basal_REM_3hPostSD_mean), sp_Basal_REM_3hPostSD_std, 'k',1); hold on,
shadedErrorBar(freq_SD{1}, nanmean(sp_SD_REM_3hPostSD_mean), sp_SD_REM_3hPostSD_std, 'r',1);
shadedErrorBar(freq_inhibPFC{1}, nanmean(sp_inhibPFC_REM_3hPostSD_mean), sp_inhibPFC_REM_3hPostSD_std, 'b',1);
shadedErrorBar(freq_inhibPFC_SD{1}, nanmean(sp_inhibPFC_SD_REM_3hPostSD_mean), sp_inhibPFC_SD_REM_3hPostSD_std, 'g',1);
title('REM - 3h post SD')
makepretty

% set(ax,'xlim',[0 15],'ylim',[0 2e6]);
