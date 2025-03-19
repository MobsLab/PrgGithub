%% input dir
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112 1148 1149 1150 1217 1219 1220]);%1218

DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');
% DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');

DirSleepInhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirSleepInhibPFC=PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);%1076
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
Dir_dreadd2 = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
Dir_dreadd_final = MergePathForExperiment(Dir_dreadd,Dir_dreadd2);
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd_final);

% %saline
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;
injection_time = 1.5*1E8;

min_dur_sws = 60;
min_dur_rem = 10;

%% get data
%variables pour souris baseline
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    sleep_stages_basal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_basal{i} = max([max(End(sleep_stages_basal{i}.Wake)),max(End(sleep_stages_basal{i}.SWSEpoch))]);
    
    %%periods of time
    durtotal_basal{i} = max([max(End(sleep_stages_basal{i}.Wake)),max(End(sleep_stages_basal{i}.SWSEpoch))]);
    %beginning to 10am
    %     epoch_10_end_basal{i} = intervalSet(0.7*1E8,durtotal_basal{i});
    epoch_10_end_basal{i} = intervalSet(0,durtotal_basal{i});
    %10am to 1pm
    epoch_10_13_basal{i} = intervalSet(0.5*1E8, 1.5*1E8);
    %1pm to 4pm
    epoch_13_16_basal{i} = intervalSet(1.5*1E8,2.5*1E8);
    %4pm to end
    epoch_13_end_basal{i} = intervalSet(1.5*1E8,durtotal_basal{i});
    
    [tpsFirstREM_10_end(i), tpsFirstSWS_10_end(i)]= FindLatencySleep_MC(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i}),and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i}),and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}),min_dur_rem,min_dur_sws);
    first_SWS_basal_10_end(i) = tpsFirstSWS_10_end(i);
    first_REM_basal_10_end(i) = tpsFirstREM_10_end(i);
    
%     [tpsFirstREM_13_end, tpsFirstSWS_13_end]= FindLatencySleep_MC(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i}),and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}),and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}),min_dur_rem,min_dur_sws);
%     first_SWS_basal_13_end(i) = tpsFirstSWS_13_end;
%     first_REM_basal_13_end(i) = tpsFirstREM_13_end;
    
    st_SWS_allPost_basal{i}=Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}));
    first_SWS_basal_13_end(i) = st_SWS_allPost_basal{i}(1)-injection_time;
    
        st_REM_allPost_basal{i}=Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}));
    first_REM_basal_13_end(i) = st_REM_allPost_basal{i}(1)-injection_time;
    
end
%%

%variables pour souris saline
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    sleep_stages_sal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_sal{j} = max([max(End(sleep_stages_sal{j}.Wake)),max(End(sleep_stages_sal{j}.SWSEpoch))]);
    
    %all post
    epoch_allPost_sal{j}=intervalSet(injection_time,durtotal_sal{j});
    
    %     [tpsFirstREM_allPost_sal, tpsFirstSWS_allPost_sal]= FindLatencySleep_MC(and(sleep_stages_sal{j}.Wake,epoch_allPost_sal{j}),and(sleep_stages_sal{j}.SWSEpoch,epoch_allPost_sal{j}),and(sleep_stages_sal{j}.REMEpoch,epoch_allPost_sal{j}),min_dur_rem,min_dur_sws);
    %     first_SWS_allPost_sal(j) = tpsFirstSWS_allPost_sal;
    %     first_REM_allPost_sal(j) = tpsFirstREM_allPost_sal;
    
    st_SWS_allPost_sal{j}=Start(and(sleep_stages_sal{j}.SWSEpoch,epoch_allPost_sal{j}));
    first_SWS_allPost_sal(j) = st_SWS_allPost_sal{j}(1)-injection_time;
    
    st_REM_allPost_sal{j}=Start(and(sleep_stages_sal{j}.REMEpoch,epoch_allPost_sal{j}));
    first_REM_allPost_sal(j) = st_REM_allPost_sal{j}(1)-injection_time;    
end
%%

%variables pour souris PFC inhibition
for k=1:length(DirSleepInhibPFC.path)
    cd(DirSleepInhibPFC.path{k}{1});
    sleep_stages_sleepInhibPFC{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_sleepInhibPFC{k} = max([max(End(sleep_stages_sleepInhibPFC{k}.Wake)),max(End(sleep_stages_sleepInhibPFC{k}.SWSEpoch))]);
    
    %all post
    epoch_allPost_sleepInhibPFC{k}=intervalSet(injection_time,durtotal_sleepInhibPFC{k});
    
%     [tpsFirstREM_allPost_sleepInhibPFC, tpsFirstSWS_allPost_sleepInhibPFC]= FindLatencySleep_MC(and(sleep_stages_sleepInhibPFC{k}.Wake,epoch_allPost_sleepInhibPFC{k}),and(sleep_stages_sleepInhibPFC{k}.SWSEpoch,epoch_allPost_sleepInhibPFC{k}),and(sleep_stages_sleepInhibPFC{k}.REMEpoch,epoch_allPost_sleepInhibPFC{k}),min_dur_rem,min_dur_sws);
%     first_SWS_sleepInhibPFC(k) = tpsFirstSWS_allPost_sleepInhibPFC;
%     first_REM_sleepInhibPFC(k) = tpsFirstREM_allPost_sleepInhibPFC;
    
    st_SWS_allPost_sleepInhibPFC{k}=Start(and(sleep_stages_sleepInhibPFC{k}.SWSEpoch,epoch_allPost_sleepInhibPFC{k}));
    first_SWS_sleepInhibPFC(k) = st_SWS_allPost_sleepInhibPFC{k}(1)-injection_time;
    
    st_REM_allPost_sleepInhibPFC{k}=Start(and(sleep_stages_sleepInhibPFC{k}.REMEpoch,epoch_allPost_sleepInhibPFC{k}));
    first_REM_sleepInhibPFC(k) = st_REM_allPost_sleepInhibPFC{k}(1)-injection_time;
    
end



%variables pour souris SD
for n=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{n}{1});
    sleep_stages_SD{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_SD{n} = max([max(End(sleep_stages_SD{n}.Wake)),max(End(sleep_stages_SD{n}.SWSEpoch))]);
    
    %all post
    epoch_allPost_SD{n}=intervalSet(0,durtotal_SD{n});
    
    [tpsFirstREM_allPost_SD, tpsFirstSWS_allPost_SD]= FindLatencySleep_MC(and(sleep_stages_SD{n}.Wake,epoch_allPost_SD{n}),and(sleep_stages_SD{n}.SWSEpoch,epoch_allPost_SD{n}),and(sleep_stages_SD{n}.REMEpoch,epoch_allPost_SD{n}),min_dur_rem,min_dur_sws);
    first_SWS_SD(n) = tpsFirstSWS_allPost_SD;
    first_REM_SD(n) = tpsFirstREM_allPost_SD;
end


%variables pour souris PFC inhibition + SD
for o=1:length(DirSocialDefeat_inhibPFC.path)
    cd(DirSocialDefeat_inhibPFC.path{o}{1});
    sleep_stages_SD_inhibPFC{o} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    durtotal_SD_inhibPFC{o} = max([max(End(sleep_stages_SD_inhibPFC{o}.Wake)),max(End(sleep_stages_SD_inhibPFC{o}.SWSEpoch))]);
    
    %all post
    epoch_allPost_SD_inhibPFC{o}=intervalSet(0,durtotal_SD_inhibPFC{o});
    
    [tpsFirstREM_allPost_SD_inhibPFC, tpsFirstSWS_allPost_SD_inhibPFC]= FindLatencySleep_MC(and(sleep_stages_SD_inhibPFC{o}.Wake,epoch_allPost_SD_inhibPFC{o}),and(sleep_stages_SD_inhibPFC{o}.SWSEpoch,epoch_allPost_SD_inhibPFC{o}),and(sleep_stages_SD_inhibPFC{o}.REMEpoch,epoch_allPost_SD_inhibPFC{o}),min_dur_rem,min_dur_sws);
    first_SWS_SD_inhibPFC(o) = tpsFirstSWS_allPost_SD_inhibPFC;
    first_REM_SD_inhibPFC(o) = tpsFirstREM_allPost_SD_inhibPFC;
end

%% convert in hours
first_SWS_basal_10_end=first_SWS_basal_10_end./1e4./3600;
first_SWS_basal_13_end=first_SWS_basal_13_end./1e4./3600;
first_SWS_allPost_sal=first_SWS_allPost_sal./1e4./3600;
first_SWS_sleepInhibPFC=first_SWS_sleepInhibPFC./1e4./3600;
first_SWS_SD=first_SWS_SD./1e4./3600;
first_SWS_SD_inhibPFC=first_SWS_SD_inhibPFC./1e4./3600;

first_REM_basal_10_end=first_REM_basal_10_end./1e4./3600;
first_REM_basal_13_end=first_REM_basal_13_end./1e4./3600;
first_REM_allPost_sal=first_REM_allPost_sal./1e4./3600;
first_REM_sleepInhibPFC=first_REM_sleepInhibPFC./1e4./3600;
first_REM_SD=first_REM_SD./1e4./3600;
first_REM_SD_inhibPFC=first_REM_SD_inhibPFC./1e4./3600;

%% figures
%%PFC inhibition
% name_label = {'Baseline (13-end)','Saline','PFC inhib','Baseline (10-end)','SD','SD + PFC inhib'};
%%PFC-VLPO inhibirion
name_label = {'Baseline (13-end)','Saline','PFC-VLPO inhib','Baseline (10-end)','SD','SD + PFC-VLPO inhib'};

col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({first_SWS_basal_13_end first_SWS_allPost_sal first_SWS_sleepInhibPFC first_SWS_basal_10_end first_SWS_SD first_SWS_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels(name_label);% xtickangle(45);
ylabel('Latency to NREM (hours)')


subplot(122)
MakeSpreadAndBoxPlot2_SB({first_REM_basal_13_end first_REM_allPost_sal first_REM_sleepInhibPFC first_REM_basal_10_end first_REM_SD first_REM_SD_inhibPFC},...
    {col_basal,col_sal,col_PFCinhib,col_basal,col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
xticks([1:6]); xticklabels(name_label);% xtickangle(45);
ylabel('Latency to REM (hours)')
