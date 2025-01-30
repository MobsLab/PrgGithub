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
% Dir_inhibPFC=RestrictPathForExperiment(Dir_inhibPFC,'nMice',[1196 1197 1198 1236 1237 1238]);
Dir_inhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');

%%dir social defeat
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112 1148 1149 1150 1218 1219 1220]);

%%dir social defeat + PFC inhibition 
% Dir_inhibPFC_SD = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
Dir_inhibPFC_SD = PathForExperimentsSD_MC('SleepPostSD_retroCre');


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
    if exist('SWR.mat')
        ripp_basal{i}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_basal{i}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_basal{i}=[];
    end
    
    if isempty(ripp_basal{i})==0
        %get ripples density
        [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_basal{i}.RipplesEpoch);
        RippDensity_basal{i} = Ripples_tsd; %store it for all mice
        rippDensitySWS_basal{i} = Restrict(RippDensity_basal{i}, a{i}.SWSEpoch);
        rippDensityWake_basal{i} = Restrict(RippDensity_basal{i}, a{i}.Wake);
        rippDensityREM_basal{i} = Restrict(RippDensity_basal{i}, a{i}.REMEpoch);
        %'3h following SD'
        rippDensitySWS_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.SWSEpoch, epoch_3hPostSD_Basal{i}));
        rippDensityWake_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.Wake, epoch_3hPostSD_Basal{i}));
        rippDensityREM_3hPostSD_basal{i} = Restrict(RippDensity_basal{i}, and(a{i}.REMEpoch, epoch_3hPostSD_Basal{i}));
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
    if exist('SWR.mat')
        ripp_SD{j}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_SD{j}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_SD{j}=[];
    end
    if isempty(ripp_SD{j})==0
        %%get ripples density
        [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_SD{j}.RipplesEpoch);
        RippDensity_SD{j} = Ripples_tsd;
        rippDensitySWS_SD{j} = Restrict(RippDensity_SD{j}, b{j}.SWSEpoch);
        rippDensityWake_SD{j} = Restrict(RippDensity_SD{j}, b{j}.Wake);
        rippDensityREM_SD{j} = Restrict(RippDensity_SD{j}, b{j}.REMEpoch);
        
        %3h following SD
        rippDensitySWS_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.SWSEpoch, epoch_3hPostSD_SD{j}));
        rippDensityWake_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.Wake, epoch_3hPostSD_SD{j}));
        rippDensityREM_3hPostSD_SD{j} = Restrict(RippDensity_SD{j}, and(b{j}.REMEpoch, epoch_3hPostSD_SD{j}));
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
    if exist('SWR.mat')
        ripp_inhibPFC{k}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_inhibPFC{k}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_inhibPFC{k}=[];
    end
    if isempty(ripp_inhibPFC{k})==0
        %%get ripples density
        [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_inhibPFC{k}.RipplesEpoch);
        RippDensity_inhibPFC{k} = Ripples_tsd;
        rippDensitySWS_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, c{k}.SWSEpoch);
        rippDensityWake_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, c{k}.Wake);
        rippDensityREM_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, c{k}.REMEpoch);
        
        %3h following SD
        rippDensitySWS_3hPostSD_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, and(c{k}.SWSEpoch, epoch_3hPostSD_inhibPFC{k}));
        rippDensityWake_3hPostSD_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, and(c{k}.Wake, epoch_3hPostSD_inhibPFC{k}));
        rippDensityREM_3hPostSD_inhibPFC{k} = Restrict(RippDensity_inhibPFC{k}, and(c{k}.REMEpoch, epoch_3hPostSD_inhibPFC{k}));
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
    if exist('SWR.mat')
        ripp_inhibPFC_SD{l}=load('SWR.mat','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_inhibPFC_SD{l}=load('Ripples.mat','RipplesEpoch');
    else
        ripp_inhibPFC_SD{l}=[];
    end
    if isempty(ripp_inhibPFC_SD{l})==0
        %%get ripples density
        [Ripples_tsd] = GetRipplesDensityTSD_MC(ripp_inhibPFC_SD{l}.RipplesEpoch);
        RippDensity_inhibPFC_SD{l} = Ripples_tsd;
        rippDensitySWS_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, d{l}.SWSEpoch);
        rippDensityWake_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, d{l}.Wake);
        rippDensityREM_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, d{l}.REMEpoch);
        
        %3h following SD
        rippDensitySWS_3hPostSD_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, and(d{l}.SWSEpoch, epoch_3hPostSD_inhibPFC_SD{l}));
        rippDensityWake_3hPostSD_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, and(d{l}.Wake, epoch_3hPostSD_inhibPFC_SD{l}));
        rippDensityREM_3hPostSD_inhibPFC_SD{l} = Restrict(RippDensity_inhibPFC_SD{l}, and(d{l}.REMEpoch, epoch_3hPostSD_inhibPFC_SD{l}));
    else
    end
end


%% calculate mean
%% baseline sleep
for ii=1:length(rippDensitySWS_3hPostSD_basal)
    if isempty(rippDensitySWS_3hPostSD_basal{ii})==0
        avRippDensitySWS_basal(ii,:)=nanmean(Data(rippDensitySWS_basal{ii}(:,:)),1); avRippDensitySWS_basal(avRippDensitySWS_basal==0)=NaN;
        avRippDensityWake_basal(ii,:)=nanmean(Data(rippDensityWake_basal{ii}(:,:)),1); avRippDensityWake_basal(avRippDensityWake_basal==0)=NaN;
        avRippDensityREM_basal(ii,:)=nanmean(Data(rippDensityREM_basal{ii}(:,:)),1); avRippDensityREM_basal(avRippDensityREM_basal==0)=NaN;
        %'3h following SD'
        avRippDensitySWS_3hPostSD_basal(ii,:)=nanmean(Data(rippDensitySWS_3hPostSD_basal{ii}(:,:)),1); avRippDensitySWS_3hPostSD_basal(avRippDensitySWS_3hPostSD_basal==0)=NaN;
        avRippDensityWake_3hPostSD_basal(ii,:)=nanmean(Data(rippDensityWake_3hPostSD_basal{ii}(:,:)),1); avRippDensityWake_3hPostSD_basal(avRippDensityWake_3hPostSD_basal==0)=NaN;
        avRippDensityREM_3hPostSD_basal(ii,:)=nanmean(Data(rippDensityREM_3hPostSD_basal{ii}(:,:)),1); avRippDensityREM_3hPostSD_basal(avRippDensityREM_3hPostSD_basal==0)=NaN;
    else
    end
end

%% social defeat
for jj=1:length(rippDensitySWS_3hPostSD_SD)
    if isempty(rippDensitySWS_3hPostSD_SD{jj})==0
        avRippDensitySWS_SD(jj,:)=nanmean(Data(rippDensitySWS_SD{jj}(:,:)),1); avRippDensitySWS_SD(avRippDensitySWS_SD==0)=NaN;
        avRippDensityWake_SD(jj,:)=nanmean(Data(rippDensityWake_SD{jj}(:,:)),1); avRippDensityWake_SD(avRippDensityWake_SD==0)=NaN;
        avRippDensityREM_SD(jj,:)=nanmean(Data(rippDensityREM_SD{jj}(:,:)),1); avRippDensityREM_SD(avRippDensityREM_SD==0)=NaN;
        %3h following SD
        avRippDensitySWS_3hPostSD_SD(jj,:)=nanmean(Data(rippDensitySWS_3hPostSD_SD{jj}(:,:)),1); avRippDensitySWS_3hPostSD_SD(avRippDensitySWS_3hPostSD_SD==0)=NaN;
        avRippDensityWake_3hPostSD_SD(jj,:)=nanmean(Data(rippDensityWake_3hPostSD_SD{jj}(:,:)),1); avRippDensityWake_3hPostSD_SD(avRippDensityWake_3hPostSD_SD==0)=NaN;
        avRippDensityREM_3hPostSD_SD(jj,:)=nanmean(Data(rippDensityREM_3hPostSD_SD{jj}(:,:)),1); avRippDensityREM_3hPostSD_SD(avRippDensityREM_3hPostSD_SD==0)=NaN;
    else
    end
end

%% PFC inhibition
for kk=1:length(rippDensitySWS_3hPostSD_inhibPFC)
    if isempty(rippDensitySWS_3hPostSD_inhibPFC{kk})==0
        avRippDensitySWS_inhibPFC(kk,:)=nanmean(Data(rippDensitySWS_inhibPFC{kk}(:,:)),1); avRippDensitySWS_inhibPFC(avRippDensitySWS_inhibPFC==0)=NaN;
        avRippDensityWake_inhibPFC(kk,:)=nanmean(Data(rippDensityWake_inhibPFC{kk}(:,:)),1); avRippDensityWake_inhibPFC(avRippDensityWake_inhibPFC==0)=NaN;
        avRippDensityREM_inhibPFC(kk,:)=nanmean(Data(rippDensityREM_inhibPFC{kk}(:,:)),1); avRippDensityREM_inhibPFC(avRippDensityREM_inhibPFC==0)=NaN;
        %3h following SD
        avRippDensitySWS_3hPostSD_inhibPFC(kk,:)=nanmean(Data(rippDensitySWS_3hPostSD_inhibPFC{kk}(:,:)),1); avRippDensitySWS_3hPostSD_inhibPFC(avRippDensitySWS_3hPostSD_inhibPFC==0)=NaN;
        avRippDensityWake_3hPostSD_inhibPFC(kk,:)=nanmean(Data(rippDensityWake_3hPostSD_inhibPFC{kk}(:,:)),1); avRippDensityWake_3hPostSD_inhibPFC(avRippDensityWake_3hPostSD_inhibPFC==0)=NaN;
        avRippDensityREM_3hPostSD_inhibPFC(kk,:)=nanmean(Data(rippDensityREM_3hPostSD_inhibPFC{kk}(:,:)),1); avRippDensityREM_3hPostSD_inhibPFC(avRippDensityREM_3hPostSD_inhibPFC==0)=NaN;
    else
    end
end

%% PFC inhibition +SD
for ll=1:length(rippDensitySWS_3hPostSD_inhibPFC_SD)
    if isempty(rippDensitySWS_3hPostSD_inhibPFC_SD{ll})==0
        avRippDensitySWS_inhibPFC_SD(ll,:)=nanmean(Data(rippDensitySWS_inhibPFC_SD{ll}(:,:)),1); avRippDensitySWS_inhibPFC_SD(avRippDensitySWS_inhibPFC_SD==0)=NaN;
        avRippDensityWake_inhibPFC_SD(ll,:)=nanmean(Data(rippDensityWake_inhibPFC_SD{ll}(:,:)),1); avRippDensityWake_inhibPFC_SD(avRippDensityWake_inhibPFC_SD==0)=NaN;
        avRippDensityREM_inhibPFC_SD(ll,:)=nanmean(Data(rippDensityREM_inhibPFC_SD{ll}(:,:)),1); avRippDensityREM_inhibPFC_SD(avRippDensityREM_inhibPFC_SD==0)=NaN;
        %3h following SD
        avRippDensitySWS_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(rippDensitySWS_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avRippDensitySWS_3hPostSD_inhibPFC_SD(avRippDensitySWS_3hPostSD_inhibPFC_SD==0)=NaN;
        avRippDensityWake_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(rippDensityWake_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avRippDensityWake_3hPostSD_inhibPFC_SD(avRippDensityWake_3hPostSD_inhibPFC_SD==0)=NaN;
        avRippDensityREM_3hPostSD_inhibPFC_SD(ll,:)=nanmean(Data(rippDensityREM_3hPostSD_inhibPFC_SD{ll}(:,:)),1); avRippDensityREM_3hPostSD_inhibPFC_SD(avRippDensityREM_3hPostSD_inhibPFC_SD==0)=NaN;
    else
    end
end


%% figures
col_basal = [0.9 0.9 0.9];
col_SD = [1 0 0];
col_PFCinhib = [1 0.4 0.2];
col_PFCinhib_SD = [0.4 0 0];

figure
ax(1)=subplot(231),MakeBoxPlot_MC({avRippDensityWake_basal avRippDensityWake_SD avRippDensityWake_inhibPFC avRippDensityWake_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('WAKE - post SD')

ax(2)=subplot(232),MakeBoxPlot_MC({avRippDensitySWS_basal avRippDensitySWS_SD avRippDensitySWS_inhibPFC avRippDensitySWS_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('NREM - post SD')

ax(3)=subplot(233),MakeBoxPlot_MC({avRippDensityREM_basal avRippDensityREM_SD avRippDensityREM_inhibPFC avRippDensityREM_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('REM - post SD')

%restricted 3h post SD
ax(4)=subplot(234),MakeBoxPlot_MC({avRippDensityWake_3hPostSD_basal avRippDensityWake_3hPostSD_SD avRippDensityWake_3hPostSD_inhibPFC avRippDensityWake_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('WAKE - 3h post SD')

ax(5)=subplot(235),MakeBoxPlot_MC({avRippDensitySWS_3hPostSD_basal avRippDensitySWS_3hPostSD_SD avRippDensitySWS_3hPostSD_inhibPFC avRippDensitySWS_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('NREM - 3h post SD')

ax(6)=subplot(236),MakeBoxPlot_MC({avRippDensityREM_3hPostSD_basal avRippDensityREM_3hPostSD_SD avRippDensityREM_3hPostSD_inhibPFC avRippDensityREM_3hPostSD_inhibPFC_SD},...
    {col_basal,col_SD,col_PFCinhib,col_PFCinhib_SD},[1:4],{},1,0);
xticks([1:4]); xticklabels({'Baseline','SD','PFC inhib','PFC inhib + SD'});% xtickangle(45);
ylabel('Ripples/s')
title('REM - 3h post SD')


%% figure : ripples density overtime
figure
%%ripples density overtime (saline)
for i=1:length(DirMyBasal.path)
    if isempty(RippDensity_basal{i})==0
        VecTimeDay_WAKE_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.Wake)), 0);
        VecTimeDay_SWS_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.SWSEpoch)), 0);
        VecTimeDay_REM_basal{i} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_basal{i},a{i}.REMEpoch)), 0);
        
        subplot(3,8,[1,2]),
        plot(VecTimeDay_WAKE_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylabel('Ripples/s')
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (baseline)')
        subplot(3,8,[9,10]),
        plot(VecTimeDay_SWS_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        ylabel('Ripples/s')
        title('NREM (baseline)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[17,18]),
        plot(VecTimeDay_REM_basal{i}, runmean(Data(Restrict(RippDensity_basal{i},a{i}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        ylabel('Ripples/s')
        title('REM (baseline)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for j=1:length(DirSocialDefeat.path)
    if isempty(RippDensity_SD{j})==0
        VecTimeDay_WAKE_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.Wake)), 0);
        VecTimeDay_SWS_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.SWSEpoch)), 0);
        VecTimeDay_REM_SD{j} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_SD{j},b{j}.REMEpoch)), 0);
        
        subplot(3,8,[3,4]),
        plot(VecTimeDay_WAKE_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (SD)')
        subplot(3,8,[11,12]),
        plot(VecTimeDay_SWS_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (SD)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[19,20]),
        plot(VecTimeDay_REM_SD{j}, runmean(Data(Restrict(RippDensity_SD{j},b{j}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (SD)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for kk=1:length(Dir_inhibPFC.path)
    if isempty(RippDensity_inhibPFC{kk})==0
        VecTimeDay_WAKE_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC{kk},c{kk}.Wake)), 0);
        VecTimeDay_SWS_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC{kk},c{kk}.SWSEpoch)), 0);
        VecTimeDay_REM_inhibPFC{kk} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC{kk},c{kk}.REMEpoch)), 0);
        
        subplot(3,8,[5,6]),
        plot(VecTimeDay_WAKE_inhibPFC{kk}, runmean(Data(Restrict(RippDensity_inhibPFC{kk},c{kk}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (PFC inhibition)')
        subplot(3,8,[13,14]),
        plot(VecTimeDay_SWS_inhibPFC{kk}, runmean(Data(Restrict(RippDensity_inhibPFC{kk},c{kk}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (PFC inhibition)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[21,22]),
        plot(VecTimeDay_REM_inhibPFC{kk}, runmean(Data(Restrict(RippDensity_inhibPFC{kk},c{kk}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (PFC inhibition)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

%%ripples density overtime (SD)
for ll=1:length(Dir_inhibPFC_SD.path)
    if isempty(RippDensity_inhibPFC_SD{ll})==0
        VecTimeDay_WAKE_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.Wake)), 0);
        VecTimeDay_SWS_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.SWSEpoch)), 0);
        VecTimeDay_REM_inhibPFC_SD{ll} = GetTimeOfTheDay_MC(Range(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.REMEpoch)), 0);
        
        subplot(3,8,[7,8]),
        plot(VecTimeDay_WAKE_inhibPFC_SD{ll}, runmean(Data(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.Wake)),70),'.','MarkerSize',0.2), hold on
        ylim([0 1.8])
        xlim([9 20])
        title('WAKE (PFC inhibition + SD)')
        subplot(3,8,[15,16]),
        plot(VecTimeDay_SWS_inhibPFC_SD{ll}, runmean(Data(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.SWSEpoch)),70),'.','MarkerSize',0.2), hold on
        title('NREM (PFC inhibition + SD)')
        ylim([0 1.8])
        xlim([9 20])
        subplot(3,8,[23,24]),
        plot(VecTimeDay_REM_inhibPFC_SD{ll}, runmean(Data(Restrict(RippDensity_inhibPFC_SD{ll},d{ll}.REMEpoch)),70),'.','MarkerSize',0.2), hold on
        title('REM (PFC inhibition + SD)')
        ylim([0 1.8])
        xlim([9 20])
        xlabel('Time (hours)')
    else
    end
end

