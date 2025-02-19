
%% input dir saline mCherry
%1
% Dir_1 = PathForExperiments_DREADD_AD ('mCherry_CRH_VLPO_SalineInjection_10am');
% Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1566 1580 1581 1635]);
% Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1566 1581 1635]);
% Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1635]);
% %%2
% Dir_2 = PathForExperiments_SleepPostSD_AD ('SleepPostSD_mCherry_CRH_VLPO_SalineInjection_10am');
% Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1566 1580 1581 1635]);
% Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1566 1581 1635]);
% Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1635]);

%% input dir cno mCherry
%1
Dir_1 = PathForExperiments_DREADD_AD ('mCherry_CRH_VLPO_CNOInjection_10am');
% Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1568 1569 1578 1579 1636 1637]);
Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1568 1569 1636 1637]);
% Dir_1 = RestrictPathForExperiment (Dir_1, 'nMice', [1637]);
%%2
Dir_2 = PathForExperiments_SleepPostSD_AD ('SleepPostSD_mCherry_CRH_VLPO_CNOInjection_10am');
% Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1568 1569 1578 1579 1636 1637]);
Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1568 1569 1636 1637]);
% Dir_2 = RestrictPathForExperiment (Dir_2, 'nMice', [1637]);

%% parameters

tempbin = 3600; %bin size to plot variables overtime
% tempbin = 1800; %bin size to plot variables overtime
% tempbin = 7200; %bin size to plot variables overtime

time_st = 0*3600*1e4; %begining of the sleep session
time_end=3*1e8;  %end of the sleep session

time_mid_end_first_period = 1.5*3600*1e4;
% time_mid_end_first_period = 2.5*3600*1e4;
% time_mid_end_first_period = 8*3600*1e4;
time_mid_begin_snd_period = 3.3*3600*1e4;
% time_mid_begin_snd_period = 5*3600*1e4;
% time_mid_begin_snd_period = 5.5*3605,[20]0*1e4;
% time_mid_begin_snd_period = 8.1*3600*1e4;

lim_short_rem_1 = 25; %25 take all rem bouts shorter than limit
lim_short_rem_2 = 15;
lim_short_rem_3 = 20;

lim_long_rem = 25; %25 take all rem bouts longer than limit

mindurSWS = 60;
mindurREM = 25;

%%
% load('B_High_Spectrum.mat');
% load('PFCx_deep_Low_Spectrum.mat');
% load('Bulb_deep_Low_Spectrum.mat');
% load('H_Low_Spectrum.mat');
% load('PFCx_deep_High_Spectrum.mat');
spectro = 'B_High_Spectrum.mat';

%% GET DATA - 1st group

for i=1:length(Dir_1.path)
    cd(Dir_1.path{i}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_1{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Info');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_1{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Info');
    else
    end
    
    %%Define different periods of time for quantifications
    same_epoch_all_sess_1{i} = intervalSet(0,time_end); %all session
    same_epoch_begin_1{i} = intervalSet(time_st,time_mid_end_first_period); %beginning of the session (period of insomnia)
    same_epoch_end_1{i} = intervalSet(time_mid_begin_snd_period,time_end); %late phase of the session (rem frag)
    same_epoch_interPeriod_1{i} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period); %inter period
    
    if exist(spectro)==2
        load(spectro);
        spectre_1 = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_1 = Spectro{3};
        temps_1 = Spectro{2};
        sp_1{i}  = spectre_1;
        freq_1{i}  = frequence_1;
        tps_1{i} = temps_1;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
    
end

%% GET DATA - 2nd group
for k=1:length(Dir_2.path)
    cd(Dir_2.path{k}{1});
    %%Load sleep scoring
    if exist('SleepScoring_Accelero.mat')
        stages_2{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake','Info');
    elseif exist('SleepScoring_OBGamma.mat')
        stages_2{k} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake','Info');
    else
    end
    
    same_epoch_all_sess_2{k} = intervalSet(0,time_end);
    same_epoch_begin_2{k} = intervalSet(time_st,time_mid_end_first_period);
    same_epoch_end_2{k} = intervalSet(time_mid_begin_snd_period,time_end);
    same_epoch_interPeriod_2{k} = intervalSet(time_mid_end_first_period,time_mid_begin_snd_period);
    
    if exist(spectro)==2
        load(spectro);
        spectre_2 = tsd(Spectro{2}*1E4,Spectro{1});
        frequence_2 = Spectro{3};
        temps_2 = Spectro{2};
        sp_2{k} = spectre_2;
        freq_2{k} = frequence_2;
        tps_2{k} = temps_2;
    else
    end
    clear Wake REMEpoch SWSEpoch Spectro
end
    

%%
% calculate mean spectrum for each mouse in group 1
for i=1:length(sp_1)
    try
    Spectre_Wake_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_all_sess_1{i},stages_1{i}.Wake)))),1);
    Spectre_SWS_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_all_sess_1{i},stages_1{i}.SWSEpoch)))),1);
    Spectre_REM_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_all_sess_1{i},stages_1{i}.REMEpoch)))),1);
    
    Spectre_Wake_begin_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_begin_1{i},stages_1{i}.Wake)))),1);
    Spectre_SWS_begin_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_begin_1{i},stages_1{i}.SWSEpoch)))),1);
    Spectre_REM_begin_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_begin_1{i},stages_1{i}.REMEpoch)))),1);

    Spectre_Wake_interPeriod_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_interPeriod_1{i},stages_1{i}.Wake)))),1);
    Spectre_SWS_interPeriod_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_interPeriod_1{i},stages_1{i}.SWSEpoch)))),1);
    Spectre_REM_interPeriod_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_interPeriod_1{i},stages_1{i}.REMEpoch)))),1);
       
    Spectre_Wake_end_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_end_1{i},stages_1{i}.Wake)))),1);
    Spectre_SWS_end_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_end_1{i},stages_1{i}.SWSEpoch)))),1);
    Spectre_REM_end_1_mean(i,:)= nanmean(10*(Data(Restrict(sp_1{i},and(same_epoch_end_1{i},stages_1{i}.REMEpoch)))),1);
    end 
end

% sem 1
Spectre_Wake_1_SEM = nanstd(Spectre_Wake_1_mean)/sqrt(size(Spectre_Wake_1_mean,1));
Spectre_SWS_1_SEM = nanstd(Spectre_SWS_1_mean)/sqrt(size(Spectre_SWS_1_mean,1));
Spectre_REM_1_SEM = nanstd(Spectre_REM_1_mean)/sqrt(size(Spectre_REM_1_mean,1));

Spectre_Wake_begin_1_SEM = nanstd(Spectre_Wake_begin_1_mean)/sqrt(size(Spectre_Wake_begin_1_mean,1));
Spectre_SWS_begin_1_SEM = nanstd(Spectre_SWS_begin_1_mean)/sqrt(size(Spectre_SWS_begin_1_mean,1));
Spectre_REM_begin_1_SEM = nanstd(Spectre_REM_begin_1_mean)/sqrt(size(Spectre_REM_begin_1_mean,1));

Spectre_Wake_interPeriod_1_SEM = nanstd(Spectre_Wake_interPeriod_1_mean)/sqrt(size(Spectre_Wake_interPeriod_1_mean,1));
Spectre_SWS_interPeriod_1_SEM = nanstd(Spectre_SWS_interPeriod_1_mean)/sqrt(size(Spectre_SWS_interPeriod_1_mean,1));
Spectre_REM_interPeriod_1_SEM = nanstd(Spectre_REM_interPeriod_1_mean)/sqrt(size(Spectre_REM_interPeriod_1_mean,1));

Spectre_Wake_end_1_SEM = nanstd(Spectre_Wake_end_1_mean)/sqrt(size(Spectre_Wake_end_1_mean,1));
Spectre_SWS_end_1_SEM = nanstd(Spectre_SWS_end_1_mean)/sqrt(size(Spectre_SWS_end_1_mean,1));
Spectre_REM_end_1_SEM = nanstd(Spectre_REM_end_1_mean)/sqrt(size(Spectre_REM_end_1_mean,1));



%%
% calculate mean spectrum for each mouse in group 2
for k=1:length(sp_2)
    try
    Spectre_Wake_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_all_sess_2{k},stages_2{k}.Wake)))),1);
    Spectre_SWS_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_all_sess_2{k},stages_2{k}.SWSEpoch)))),1);
    Spectre_REM_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_all_sess_2{k},stages_2{k}.REMEpoch)))),1);
    
    Spectre_Wake_begin_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_begin_2{k},stages_2{k}.Wake)))),1);
    Spectre_SWS_begin_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_begin_2{k},stages_2{k}.SWSEpoch)))),1);
    Spectre_REM_begin_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_begin_2{k},stages_2{k}.REMEpoch)))),1);

    Spectre_Wake_interPeriod_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_interPeriod_2{k},stages_2{k}.Wake)))),1);
    Spectre_SWS_interPeriod_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_interPeriod_2{k},stages_2{k}.SWSEpoch)))),1);
    Spectre_REM_interPeriod_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_interPeriod_2{k},stages_2{k}.REMEpoch)))),1);
       
    Spectre_Wake_end_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_end_2{k},stages_2{k}.Wake)))),1);
    Spectre_SWS_end_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_end_2{k},stages_2{k}.SWSEpoch)))),1);
    Spectre_REM_end_2_mean(k,:)= nanmean(10*(Data(Restrict(sp_2{k},and(same_epoch_end_2{k},stages_2{k}.REMEpoch)))),1);
    end 
end

% sem 2
Spectre_Wake_2_SEM = nanstd(Spectre_Wake_2_mean)/sqrt(size(Spectre_Wake_2_mean,1));
Spectre_SWS_2_SEM = nanstd(Spectre_SWS_2_mean)/sqrt(size(Spectre_SWS_2_mean,1));
Spectre_REM_2_SEM = nanstd(Spectre_REM_2_mean)/sqrt(size(Spectre_REM_2_mean,1));

Spectre_Wake_begin_2_SEM = nanstd(Spectre_Wake_begin_2_mean)/sqrt(size(Spectre_Wake_begin_2_mean,1));
Spectre_SWS_begin_2_SEM = nanstd(Spectre_SWS_begin_2_mean)/sqrt(size(Spectre_SWS_begin_2_mean,1));
Spectre_REM_begin_2_SEM = nanstd(Spectre_REM_begin_2_mean)/sqrt(size(Spectre_REM_begin_2_mean,1));

Spectre_Wake_interPeriod_2_SEM = nanstd(Spectre_Wake_interPeriod_2_mean)/sqrt(size(Spectre_Wake_interPeriod_2_mean,1));
Spectre_SWS_interPeriod_2_SEM = nanstd(Spectre_SWS_interPeriod_2_mean)/sqrt(size(Spectre_SWS_interPeriod_2_mean,1));
Spectre_REM_interPeriod_2_SEM = nanstd(Spectre_REM_interPeriod_2_mean)/sqrt(size(Spectre_REM_interPeriod_2_mean,1));

Spectre_Wake_end_2_SEM = nanstd(Spectre_Wake_end_2_mean)/sqrt(size(Spectre_Wake_end_2_mean,1));
Spectre_SWS_end_2_SEM = nanstd(Spectre_SWS_end_2_mean)/sqrt(size(Spectre_SWS_end_2_mean,1));
Spectre_REM_end_2_SEM = nanstd(Spectre_REM_end_2_mean)/sqrt(size(Spectre_REM_end_2_mean,1));
