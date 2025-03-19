%% input dir : social defeat
%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');

DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);

%%dir PFC inhibition
Dir_inhibPFC = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
Dir_inhibPFC=RestrictPathForExperiment(Dir_inhibPFC,'nMice',[1196 1197 1198 1236 1237 1238]);

%%dir social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112 1148 1149 1150 1218 1219 1220]);

%%dir social defeat + PFC inhibition 
Dir_inhibPFC_SD = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get the data
%% baseline sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_Basal{i}=intervalSet(0,3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_Basal{i}=intervalSet(End(epoch_3hPostSD_Basal{i}),durtotal_basal{i});
    
    %%load ripples
    if exist('DeltaWaves.mat')
        delt_basal{i}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_basal{i}=[];
    end
    
    if isempty(delt_basal{i})==0
        %get deltas density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_basal{i}.alldeltas_PFCx);
        deltDensity_basal{i} = Deltas_tsd; %store it for all mice
        deltDensitySWS_basal{i} = Restrict(deltDensity_basal{i}, a{i}.SWSEpoch);
        deltDensityWake_basal{i} = Restrict(deltDensity_basal{i}, a{i}.Wake);
        deltDensityREM_basal{i} = Restrict(deltDensity_basal{i}, a{i}.REMEpoch);
        %'3h following SD'
        deltDensitySWS_3hPostSD_basal{i} = Restrict(deltDensity_basal{i}, and(a{i}.SWSEpoch, epoch_3hPostSD_Basal{i}));
        deltDensityWake_3hPostSD_basal{i} = Restrict(deltDensity_basal{i}, and(a{i}.Wake, epoch_3hPostSD_Basal{i}));
        deltDensityREM_3hPostSD_basal{i} = Restrict(deltDensity_basal{i}, and(a{i}.REMEpoch, epoch_3hPostSD_Basal{i}));
    else
    end
end

%% social defeat
for j=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{j}{1});
    b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_SD{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_SD{j}=intervalSet(0,3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_SD{j}=intervalSet(End(epoch_3hPostSD_SD{j}),durtotal_SD{j});
    
    %%load ripples
    if exist('DeltaWaves.mat')
        delt_SD{j}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_SD{j}=[];
    end
    if isempty(delt_SD{j})==0
        %%get deltas density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_SD{j}.alldeltas_PFCx);
        deltDensity_SD{j} = Deltas_tsd;
        deltDensitySWS_SD{j} = Restrict(deltDensity_SD{j}, b{j}.SWSEpoch);
        deltDensityWake_SD{j} = Restrict(deltDensity_SD{j}, b{j}.Wake);
        deltDensityREM_SD{j} = Restrict(deltDensity_SD{j}, b{j}.REMEpoch);
        
        %3h following SD
        deltDensitySWS_3hPostSD_SD{j} = Restrict(deltDensity_SD{j}, and(b{j}.SWSEpoch, epoch_3hPostSD_SD{j}));
        deltDensityWake_3hPostSD_SD{j} = Restrict(deltDensity_SD{j}, and(b{j}.Wake, epoch_3hPostSD_SD{j}));
        deltDensityREM_3hPostSD_SD{j} = Restrict(deltDensity_SD{j}, and(b{j}.REMEpoch, epoch_3hPostSD_SD{j}));
    else
    end
end

%% PFC inhibition
for k=1:length(Dir_inhibPFC.path)
    cd(Dir_inhibPFC.path{k}{1});
    c{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_inhibPFC{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_inhibPFC{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_inhibPFC{k}=intervalSet(End(epoch_3hPostSD_inhibPFC{k}),durtotal_inhibPFC{k});
    
    %%load ripples
    if exist('DeltaWaves.mat')
        delt_inhibPFC{k}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_inhibPFC{k}=[];
    end
    if isempty(delt_inhibPFC{k})==0
        %%get ripples density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_inhibPFC{k}.alldeltas_PFCx);
        deltDensity_inhibPFC{k} = Deltas_tsd;
        deltDensitySWS_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, c{k}.SWSEpoch);
        deltDensityWake_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, c{k}.Wake);
        deltDensityREM_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, c{k}.REMEpoch);
        
        %3h following SD
        deltDensitySWS_3hPostSD_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, and(c{k}.SWSEpoch, epoch_3hPostSD_inhibPFC{k}));
        deltDensityWake_3hPostSD_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, and(c{k}.Wake, epoch_3hPostSD_inhibPFC{k}));
        deltDensityREM_3hPostSD_inhibPFC{k} = Restrict(deltDensity_inhibPFC{k}, and(c{k}.REMEpoch, epoch_3hPostSD_inhibPFC{k}));
    else
    end
end

%% PFC inhibition + SD
for l=1:length(Dir_inhibPFC_SD.path)
    cd(Dir_inhibPFC_SD.path{l}{1});
    d{l} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_inhibPFC_SD{l} = max([max(End(d{l}.Wake)),max(End(d{l}.SWSEpoch))]);
    %3h post SD (first 3h of recording)
    epoch_3hPostSD_inhibPFC_SD{l}=intervalSet(0,3*3600*1E4);
    % end of the 3h post SD up to the end of the session
    epoch_endPostSD_inhibPFC_SD{l}=intervalSet(End(epoch_3hPostSD_inhibPFC_SD{l}),durtotal_inhibPFC_SD{l});
    
    %%load ripples
    if exist('DeltaWaves.mat')
        delt_inhibPFC_SD{l}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
        delt_inhibPFC_SD{l}=[];
    end
    if isempty(delt_inhibPFC_SD{l})==0
        %%get ripples density
        [Deltas_tsd] = GetDeltasDensityTSD_MC(delt_inhibPFC_SD{l}.alldeltas_PFCx);
        deltDensity_inhibPFC_SD{l} = Deltas_tsd;
        deltDensitySWS_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, d{l}.SWSEpoch);
        deltDensityWake_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, d{l}.Wake);
        deltDensityREM_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, d{l}.REMEpoch);
        
        %3h following SD
        deltDensitySWS_3hPostSD_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, and(d{l}.SWSEpoch, epoch_3hPostSD_inhibPFC_SD{l}));
        deltDensityWake_3hPostSD_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, and(d{l}.Wake, epoch_3hPostSD_inhibPFC_SD{l}));
        deltDensityREM_3hPostSD_inhibPFC_SD{l} = Restrict(deltDensity_inhibPFC_SD{l}, and(d{l}.REMEpoch, epoch_3hPostSD_inhibPFC_SD{l}));
    else
    end
end


%% calculate mean
%% baseline sleep
for ii=1:length(deltDensitySWS_3hPostSD_basal)
    if isempty(deltDensitySWS_3hPostSD_basal{ii})==0
        avDeltDensitySWS_basal(ii,:)=nanmean(Data(deltDensitySWS_basal{ii}(:,:)),1); avDeltDensitySWS_basal(avDeltDensitySWS_basal==0)=NaN;
        avDeltDensityWake_basal(ii,:)=nanmean(Data(deltDensityWake_basal{ii}(:,:)),1); avDeltDensityWake_basal(avDeltDensityWake_basal==0)=NaN;
        avDeltDensityREM_basal(ii,:)=nanmean(Data(deltDensityREM_basal{ii}(:,:)),1); avDeltDensityREM_basal(avDeltDensityREM_basal==0)=NaN;
        %'3h following SD'
        avDeltDensitySWS_3hPostSD_basal(ii,:)=nanmean(Data(deltDensitySWS_3hPostSD_basal{ii}(:,:)),1); avDeltDensitySWS_3hPostSD_basal(avDeltDensitySWS_3hPostSD_basal==0)=NaN;
        avDeltDensityWake_3hPostSD_basal(ii,:)=nanmean(Data(deltDensityWake_3hPostSD_basal{ii}(:,:)),1); avDeltDensityWake_3hPostSD_basal(avDeltDensityWake_3hPostSD_basal==0)=NaN;
        avDeltDensityREM_3hPostSD_basal(ii,:)=nanmean(Data(deltDensityREM_3hPostSD_basal{ii}(:,:)),1); avDeltDensityREM_3hPostSD_basal(avDeltDensityREM_3hPostSD_basal==0)=NaN;
    else
    end
end

%% social defeat
for jj=1:length(deltDensitySWS_3hPostSD_SD)
    if isempty(deltDensitySWS_3hPostSD_SD{jj})==0
        avDeltDensitySWS_SD(jj,:)=nanmean(Data(deltDensitySWS_SD{jj}(:,:)),1); avDeltDensitySWS_SD(avDeltDensitySWS_SD==0)=NaN;
        avDeltDensityWake_SD(jj,:)=nanmean(Data(deltDensityWake_SD{jj}(:,:)),1); avDeltDensityWake_SD(avDeltDensityWake_SD==0)=NaN;
        avDeltDensityREM_SD(jj,:)=nanmean(Data(deltDensityREM_SD{jj}(:,:)),1); avDeltDensityREM_SD(avDeltDensityREM_SD==0)=NaN;
        %3h following SD
        avDeltDensitySWS_3hPostSD_SD(jj,:)=nanmean(Data(deltDensitySWS_3hPostSD_SD{jj}(:,:)),1); avDeltDensitySWS_3hPostSD_SD(avDeltDensitySWS_3hPostSD_SD==0)=NaN;
        avDeltDensityWake_3hPostSD_SD(jj,:)=nanmean(Data(deltDensityWake_3hPostSD_SD{jj}(:,:)),1); avDeltDensityWake_3hPostSD_SD(avDeltDensityWake_3hPostSD_SD==0)=NaN;
        avDeltDensityREM_3hPostSD_SD(jj,:)=nanmean(Data(deltDensityREM_3hPostSD_SD{jj}(:,:)),1); avDeltDensityREM_3hPostSD_SD(avDeltDensityREM_3hPostSD_SD==0)=NaN;
    else
    end
end

%% PFC inhibition
for kk=1:length(deltDensitySWS_3hPostSD_inhibPFC)
    if isempty(deltDensitySWS_3hPostSD_inhibPFC{kk})==0
        avDeltDensitySWS_inhibPFC(kk,:)=nanmean(Data(deltDensitySWS_inhibPFC{kk}(:,:)),1); avDeltDensitySWS_inhibPFC(avDeltDensitySWS_inhibPFC==0)=NaN;
        avDeltDensityWake_inhibPFC(kk,:)=nanmean(Data(deltDensityWake_inhibPFC{kk}(:,:)),1); avDeltDensityWake_inhibPFC(avDeltDensityWake_inhibPFC==0)=NaN;
        avDeltDensityREM_inhibPFC(kk,:)=nanmean(Data(deltDensityREM_inhibPFC{kk}(:,:)),1); avDeltDensityREM_inhibPFC(avDeltDensityREM_inhibPFC==0)=NaN;
        %3h following SD
        avDeltDensitySWS_3hPostSD_inhibPFC(kk,:)=nanmean(Data(deltDensitySWS_3hPostSD_inhibPFC{kk}(:,:)),1); avDeltDensitySWS_3hPostSD_inhibPFC(avDeltDensitySWS_3hPostSD_inhibPFC==0)=NaN;
        avDeltDensityWake_3hPostSD_inhibPFC(kk,:)=nanmean(Data(deltDensityWake_3hPostSD_inhibPFC{kk}(:,:)),1); avDeltDensityWake_3hPostSD_inhibPFC(avDeltDensityWake_3hPostSD_inhibPFC==0)=NaN;
        avDeltDensityREM_3hPostSD_inhibPFC(kk,:)=nanmean(Data(deltDensityREM_3hPostSD_inhibPFC{kk}(:,:)),1); avDeltDensityREM_3hPostSD_inhibPFC(avDeltDensityREM_3hPostSD_inhibPFC==0)=NaN;
    else
    end
end

%% PFC inhibition +SD
for ll=1:length(deltDensitySWS_3hPostSD_inhibPFC_SD)
    if isempty(deltDensitySWS_3hPostSD_inhibPFC_SD{ll})==0
        avDeltDensitySWS_inhibPFC_SD(ll,:)=nanmean(Data(deltDensitySWS_inhibPFC_SD{ll}(:,:)),1); avDeltDensitySWS_inhibPFC_SD(avDeltDensitySWS_inhibPFC_SD==0)=NaN;
        avDeltDensityWake_inhibPFC_SD(ll,:)=nanmean(Data(deltDensityWake_inhibPFC_SD{ll}(:,:)),1); avDeltDensityWake_inhibPFC_SD(avDeltDensityWake_inhibPFC_SD==0)=NaN;
        avDeltDensityREM_inhibPFC_SD(ll,:)=nanmean(Data(deltDensityREM_inhibPFC_SD{ll}(:,:)),1); avDeltDensityREM_inhibPFC_SD(avDeltDensityREM_inhibPFC_SD==0)=NaN;
        %3h following SD
        avDeltDensitySWS_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(deltDensitySWS_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avDeltDensitySWS_3hPostSD_inhibPFC_SD(avDeltDensitySWS_3hPostSD_inhibPFC_SD==0)=NaN;
        avDeltDensityWake_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(deltDensityWake_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avDeltDensityWake_3hPostSD_inhibPFC_SD(avDeltDensityWake_3hPostSD_inhibPFC_SD==0)=NaN;
        avDeltDensityREM_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(deltDensityREM_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avDeltDensityREM_3hPostSD_inhibPFC_SD(avDeltDensityREM_3hPostSD_inhibPFC_SD==0)=NaN;
    else
    end
end


%% figures
col_basal = [0.9 0.9 0.9];
col_SD = [1 0 0];
col_PFCinhib = [1 0.4 0.2];
col_PFCinhib_SD = [0.4 0 0];

figure
ax(1)=subplot(231),MakeBoxPlot_MC({avDeltDensityWake_basal avDeltDensityWake_SD avDeltDensityWake_inhibPFC avDeltDensityWake_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('WAKE - post SD')

ax(2)=subplot(232),MakeBoxPlot_MC({avDeltDensitySWS_basal avDeltDensitySWS_SD avDeltDensitySWS_inhibPFC avDeltDensitySWS_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('NREM - post SD')

ax(3)=subplot(233),MakeBoxPlot_MC({avDeltDensityREM_basal avDeltDensityREM_SD avDeltDensityREM_inhibPFC avDeltDensityREM_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('REM - post SD')

%restricted 3h post SD
ax(4)=subplot(234),MakeBoxPlot_MC({avDeltDensityWake_3hPostSD_basal avDeltDensityWake_3hPostSD_SD avDeltDensityWake_3hPostSD_inhibPFC avDeltDensityWake_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('WAKE - 3h post SD')

ax(5)=subplot(235),MakeBoxPlot_MC({avDeltDensitySWS_3hPostSD_basal avDeltDensitySWS_3hPostSD_SD avDeltDensitySWS_3hPostSD_inhibPFC avDeltDensitySWS_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('NREM - 3h post SD')

ax(6)=subplot(236),MakeBoxPlot_MC({avDeltDensityREM_3hPostSD_basal avDeltDensityREM_3hPostSD_SD avDeltDensityREM_3hPostSD_inhibPFC avDeltDensityREM_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Deltas/s')
title('REM - 3h post SD')


%% figure : ripples density overtime
figure
%%ripples density overtime (saline)
for i=1:length(DirMyBasal.path)
    if isempty(deltDensity_basal{i})==0
        VecTimeDay_WAKE_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_basal{i},a{i}.Wake)), 0);
        VecTimeDay_SWS_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_basal{i},a{i}.SWSEpoch)), 0);
        VecTimeDay_REM_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_basal{i},a{i}.REMEpoch)), 0);
        
        subplot(3,8,[1,2]),
        plot(VecTimeDay_WAKE_basal{i}, runmean(Data(Restrict(deltDensity_basal{i},a{i}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylabel('Deltas/s')
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (baseline)')
        subplot(3,8,[9,10]),
        plot(VecTimeDay_SWS_basal{i}, runmean(Data(Restrict(deltDensity_basal{i},a{i}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        ylabel('Deltas/s')
        title('NREM (baseline)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[17,18]),
        plot(VecTimeDay_REM_basal{i}, runmean(Data(Restrict(deltDensity_basal{i},a{i}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        ylabel('Deltas/s')
        title('REM (baseline)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for j=1:length(DirSocialDefeat.path)
    if isempty(deltDensity_SD{j})==0
        VecTimeDay_WAKE_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_SD{j},b{j}.Wake)), 0);
        VecTimeDay_SWS_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_SD{j},b{j}.SWSEpoch)), 0);
        VecTimeDay_REM_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_SD{j},b{j}.REMEpoch)), 0);
        
        subplot(3,8,[3,4]),
        plot(VecTimeDay_WAKE_SD{j}, runmean(Data(Restrict(deltDensity_SD{j},b{j}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (SD)')
        subplot(3,8,[11,12]),
        plot(VecTimeDay_SWS_SD{j}, runmean(Data(Restrict(deltDensity_SD{j},b{j}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (SD)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[19,20]),
        plot(VecTimeDay_REM_SD{j}, runmean(Data(Restrict(deltDensity_SD{j},b{j}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (SD)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for kk=1:length(Dir_inhibPFC.path)
    if isempty(deltDensity_inhibPFC{kk})==0
        VecTimeDay_WAKE_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC{kk},c{kk}.Wake)), 0);
        VecTimeDay_SWS_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC{kk},c{kk}.SWSEpoch)), 0);
        VecTimeDay_REM_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC{kk},c{kk}.REMEpoch)), 0);
        
        subplot(3,8,[5,6]),
        plot(VecTimeDay_WAKE_inhibPFC{kk}, runmean(Data(Restrict(deltDensity_inhibPFC{kk},c{kk}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (PFC inhibition)')
        subplot(3,8,[13,14]),
        plot(VecTimeDay_SWS_inhibPFC{kk}, runmean(Data(Restrict(deltDensity_inhibPFC{kk},c{kk}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (PFC inhibition)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[21,22]),
        plot(VecTimeDay_REM_inhibPFC{kk}, runmean(Data(Restrict(deltDensity_inhibPFC{kk},c{kk}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (PFC inhibition)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for ll=1:length(Dir_inhibPFC_SD.path)
    if isempty(deltDensity_inhibPFC_SD{ll})==0
        VecTimeDay_WAKE_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.Wake)), 0);
        VecTimeDay_SWS_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.SWSEpoch)), 0);
        VecTimeDay_REM_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.REMEpoch)), 0);
        
        subplot(3,8,[7,8]),
        plot(VecTimeDay_WAKE_inhibPFC_SD{ll}, runmean(Data(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (PFC inhibition + SD)')
        subplot(3,8,[15,16]),
        plot(VecTimeDay_SWS_inhibPFC_SD{ll}, runmean(Data(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (PFC inhibition + SD)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[23,24]),
        plot(VecTimeDay_REM_inhibPFC_SD{ll}, runmean(Data(Restrict(deltDensity_inhibPFC_SD{ll},d{ll}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (PFC inhibition + SD)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

