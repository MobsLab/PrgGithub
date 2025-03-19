%% input dir
%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);%1076
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
Dir_dreadd2 = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
Dir_dreadd_final = MergePathForExperiment(Dir_dreadd,Dir_dreadd2);
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd_final);

DirSaline = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');

Dirsleep_inhib=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirSleepInhibPFC=PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirSleepInhibPFC=RestrictPathForExperiment(DirSleepInhibPFC,'nMice',[1196 1197 1198 1235 1236 1238]);% %1107

DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1112 1148 1149 1150 1217 1219 1220 1218]);% %1107

DirSocialDefeat_inhib = PathForExperimentsSD_MC('SleepPostSD_retroCre');
% DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
% DirSocialDefeat_inhibPFC=RestrictPathForExperiment(DirSocialDefeat_inhibPFC,'nMice',[1196 1197 1238]);% %1107

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

param = 'before';

%%
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_basal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_basal{i}.SWSEpoch = mergeCloseIntervals(stages_basal{i}.SWSEpoch, 1e4);
        stages_basal{i}.REMEpoch = mergeCloseIntervals(stages_basal{i}.REMEpoch, 1e4);
        stages_basal{i}.Wake = mergeCloseIntervals(stages_basal{i}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_basal{i} = max([max(End(stages_basal{i}.Wake)),max(End(stages_basal{i}.SWSEpoch))]);
        epoch_10_end_basal{i} = intervalSet(0.55*1E8,durtotal_basal{i});
        epoch_13_end_basal{i} = intervalSet(1.5*1E8,durtotal_basal{i});

        %%get single and sequential REM epoch
        [Seq_REM_basal{i},Single_REM_basal{i}] = Find_single_sequential_REM_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    else
    end
    
    %%number episodes post injection (13h-end)
    Num_total_REM_basal_13_end(i)=length(length(and(stages_basal{i}.REMEpoch,epoch_13_end_basal{i})));
    Num_seq_REM_basal_13_end(i)=length(length(and(Seq_REM_basal{i},epoch_13_end_basal{i})));
    Num_sing_REM_basal_13_end(i)=length(length(and(Single_REM_basal{i},epoch_13_end_basal{i})));
    %%number episodes post SD (10h-end)
    Num_total_REM_basal_10_end(i)=length(length(and(stages_basal{i}.REMEpoch,epoch_10_end_basal{i})));
    Num_seq_REM_basal_10_end(i)=length(length(and(Seq_REM_basal{i},epoch_10_end_basal{i})));
    Num_sing_REM_basal_10_end(i)=length(length(and(Single_REM_basal{i},epoch_10_end_basal{i})));
    
    %%mean duration post injection
    mean_dur_total_REM_basal_13_end(i)=mean(End(and(stages_basal{i}.REMEpoch,epoch_13_end_basal{i}))-Start(and(stages_basal{i}.REMEpoch,epoch_13_end_basal{i})))/1E4;
    mean_dur_seq_REM_basal_13_end(i)=mean(End(and(Seq_REM_basal{i},epoch_13_end_basal{i}))-Start(and(Seq_REM_basal{i},epoch_13_end_basal{i})))/1E4;
    mean_dur_sing_REM_basal_13_end(i)=mean(End(and(Single_REM_basal{i},epoch_13_end_basal{i}))-Start(and(Single_REM_basal{i},epoch_13_end_basal{i})))/1E4;
    %%mean duration post SD
    mean_dur_total_REM_basal_10_end(i)=mean(End(and(stages_basal{i}.REMEpoch,epoch_10_end_basal{i}))-Start(and(stages_basal{i}.REMEpoch,epoch_10_end_basal{i})))/1E4;
    mean_dur_seq_REM_basal_10_end(i)=mean(End(and(Seq_REM_basal{i},epoch_10_end_basal{i}))-Start(and(Seq_REM_basal{i},epoch_10_end_basal{i})))/1E4;
    mean_dur_sing_REM_basal_10_end(i)=mean(End(and(Single_REM_basal{i},epoch_10_end_basal{i}))-Start(and(Single_REM_basal{i},epoch_10_end_basal{i})))/1E4;
   
    %%percentage
    Res_totalSleep_basal{i}=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    %%percentage post injection
    percREM_total_basal_13_end(i) = Res_totalSleep_basal{i}(2,1);
    percREM_seq_basal_13_end(i) = Res_totalSleep_basal{i}(2,2);
    percREM_sing_basal_13_end(i) = Res_totalSleep_basal{i}(2,3);
    %%percentage post SD
    percREM_total_basal_10_end(i) = Res_totalSleep_basal{i}(3,1);
    percREM_seq_basal_10_end(i) = Res_totalSleep_basal{i}(3,2);
    percREM_sing_basal_10_end(i) = Res_totalSleep_basal{i}(3,3);
    
end

%%
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_sal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_sal{j}.SWSEpoch = mergeCloseIntervals(stages_sal{j}.SWSEpoch, 1e4);
        stages_sal{j}.REMEpoch = mergeCloseIntervals(stages_sal{j}.REMEpoch, 1e4);
        stages_sal{j}.Wake = mergeCloseIntervals(stages_sal{j}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_sal{j} = max([max(End(stages_sal{j}.Wake)),max(End(stages_sal{j}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_sal{j} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
        %post injection
        epoch_PostInj_sal{j} = intervalSet(st_epoch_postInj,durtotal_sal{j});
        %3h post injection
        epoch_3hPostInj_sal{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_sal{j},Single_REM_sal{j}] = Find_single_sequential_REM_MC(stages_sal{j}.Wake,stages_sal{j}.SWSEpoch,stages_sal{j}.REMEpoch,param);
    else
    end
    
    %%number pre
    Num_total_REM_sal_pre(j)=length(length(and(stages_sal{j}.REMEpoch,epoch_PreInj_sal{j}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_seq_REM_sal_pre(j)=length(length(and(Seq_REM_sal{j},epoch_PreInj_sal{j}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_sal_pre(j)=length(length(and(Single_REM_sal{j},epoch_PreInj_sal{j}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number post
    Num_total_REM_sal_post(j)=length(length(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j})));
    Num_seq_REM_sal_post(j)=length(length(and(Seq_REM_sal{j},epoch_PostInj_sal{j})));
    Num_sing_REM_sal_post(j)=length(length(and(Single_REM_sal{j},epoch_PostInj_sal{j})));
    
    %%mean duration pre
    mean_dur_total_REM_sal_pre(j)=mean(End(and(stages_sal{j}.REMEpoch,epoch_PreInj_sal{j}))-Start(and(stages_sal{j}.REMEpoch,epoch_PreInj_sal{j})))/1E4;
    mean_dur_seq_REM_sal_pre(j)=mean(End(and(Seq_REM_sal{j},epoch_PreInj_sal{j}))-Start(and(Seq_REM_sal{j},epoch_PreInj_sal{j})))/1E4;
    mean_dur_sing_REM_sal_pre(j)=mean(End(and(Single_REM_sal{j},epoch_PreInj_sal{j}))-Start(and(Single_REM_sal{j},epoch_PreInj_sal{j})))/1E4;
    %%mean duration post
    mean_dur_total_REM_sal_post(j)=mean(End(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j}))-Start(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j})))/1E4;
    mean_dur_seq_REM_sal_post(j)=mean(End(and(Seq_REM_sal{j},epoch_PostInj_sal{j}))-Start(and(Seq_REM_sal{j},epoch_PostInj_sal{j})))/1E4;
    mean_dur_sing_REM_sal_post(j)=mean(End(and(Single_REM_sal{j},epoch_PostInj_sal{j}))-Start(and(Single_REM_sal{j},epoch_PostInj_sal{j})))/1E4;
   
 
    %%percentage
    Res_totalSleep_sal{j}=Compute_Seq_Single_REM_Percentages_MC(stages_sal{j}.Wake,stages_sal{j}.SWSEpoch,stages_sal{j}.REMEpoch,param);
    
    %%percentage pre
    percREM_total_sal_pre(j) = Res_totalSleep_sal{j}(2,1);
    percREM_seq_sal_pre(j) = Res_totalSleep_sal{j}(2,2);
    percREM_sing_sal_pre(j) = Res_totalSleep_sal{j}(2,3);
    
    %%percentage post
    percREM_total_sal_post(j) = Res_totalSleep_sal{j}(3,1);
    percREM_seq_sal_post(j) = Res_totalSleep_sal{j}(3,2);
    percREM_sing_sal_post(j) = Res_totalSleep_sal{j}(3,3);
    
end

%%
for k=1:length(Dirsleep_inhib.path)
    cd(Dirsleep_inhib.path{k}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_sleep_inhib{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_sleep_inhib{k}.SWSEpoch = mergeCloseIntervals(stages_sleep_inhib{k}.SWSEpoch, 1e4);
        stages_sleep_inhib{k}.REMEpoch = mergeCloseIntervals(stages_sleep_inhib{k}.REMEpoch, 1e4);
        stages_sleep_inhib{k}.Wake = mergeCloseIntervals(stages_sleep_inhib{k}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_sleep_inhib{k} = max([max(End(stages_sleep_inhib{k}.Wake)),max(End(stages_sleep_inhib{k}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_sleep_inhib{k} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
        %post injection
        epoch_PostInj_sleep_inhib{k} = intervalSet(st_epoch_postInj,durtotal_sleep_inhib{k});
        %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_sleep_inhib{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_sleep_inhib{k},Single_REM_sleep_inhib{k}] = Find_single_sequential_REM_MC(stages_sleep_inhib{k}.Wake,stages_sleep_inhib{k}.SWSEpoch,stages_sleep_inhib{k}.REMEpoch,param);
    else
    end
    
    %%number pre
    Num_total_REM_sleep_inhib_pre(k)=length(length(and(stages_sleep_inhib{k}.REMEpoch,epoch_PreInj_sleep_inhib{k})));
    Num_seq_REM_sleep_inhib_pre(k)=length(length(and(Seq_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_sleep_inhib_pre(k)=length(length(and(Single_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number post
    Num_total_REM_sleep_inhib_post(k)=length(length(and(stages_sleep_inhib{k}.REMEpoch,epoch_PostInj_sleep_inhib{k})));
    Num_seq_REM_sleep_inhib_post(k)=length(length(and(Seq_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k})));
    Num_sing_REM_sleep_inhib_post(k)=length(length(and(Single_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k})));
    
    %%mean duration pre
    mean_dur_total_REM_sleep_inhib_pre(k)=mean(End(and(stages_sleep_inhib{k}.REMEpoch,epoch_PreInj_sleep_inhib{k}))-Start(and(stages_sleep_inhib{k}.REMEpoch,epoch_PreInj_sleep_inhib{k})))/1E4;
    mean_dur_seq_REM_sleep_inhib_pre(k)=mean(End(and(Seq_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k}))-Start(and(Seq_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k})))/1E4;
    mean_dur_sing_REM_sleep_inhib_pre(k)=mean(End(and(Single_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k}))-Start(and(Single_REM_sleep_inhib{k},epoch_PreInj_sleep_inhib{k})))/1E4;
    %%mean duration post
    mean_dur_total_REM_sleep_inhib_post(k)=mean(End(and(stages_sleep_inhib{k}.REMEpoch,epoch_PostInj_sleep_inhib{k}))-Start(and(stages_sleep_inhib{k}.REMEpoch,epoch_PostInj_sleep_inhib{k})))/1E4;
    mean_dur_seq_REM_sleep_inhib_post(k)=mean(End(and(Seq_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k}))-Start(and(Seq_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k})))/1E4;
    mean_dur_sing_REM_sleep_inhib_post(k)=mean(End(and(Single_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k}))-Start(and(Single_REM_sleep_inhib{k},epoch_PostInj_sleep_inhib{k})))/1E4;
    
    
    %%percentage
    Res_totalSleep_sleep_inhib{k}=Compute_Seq_Single_REM_Percentages_MC(stages_sleep_inhib{k}.Wake,stages_sleep_inhib{k}.SWSEpoch,stages_sleep_inhib{k}.REMEpoch,param);
    
    %%percentage pre
    percREM_total_sleep_inhib_pre(k) = Res_totalSleep_sleep_inhib{k}(2,1);
    percREM_seq_sleep_inhib_pre(k) = Res_totalSleep_sleep_inhib{k}(2,2);
    percREM_sing_sleep_inhib_pre(k) = Res_totalSleep_sleep_inhib{k}(2,3);
    
    %%percentage post
    percREM_total_sleep_inhib_post(k) = Res_totalSleep_sleep_inhib{k}(3,1);
    percREM_seq_sleep_inhib_post(k) = Res_totalSleep_sleep_inhib{k}(3,2);
    percREM_sing_sleep_inhib_post(k) = Res_totalSleep_sleep_inhib{k}(3,3);
    
end

%%
for m=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{m}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_SD{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_SD{m}.SWSEpoch = mergeCloseIntervals(stages_SD{m}.SWSEpoch, 1e4);
        stages_SD{m}.REMEpoch = mergeCloseIntervals(stages_SD{m}.REMEpoch, 1e4);
        stages_SD{m}.Wake = mergeCloseIntervals(stages_SD{m}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_SD{m} = max([max(End(stages_SD{m}.Wake)),max(End(stages_SD{m}.SWSEpoch))]);
        epoch_PostInj_SD{m} = intervalSet(0.55*1E8,durtotal_SD{m});
        
        %%get single and sequential REM epoch
        [Seq_REM_SD{m},Single_REM_SD{m}] = Find_single_sequential_REM_MC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,stages_SD{m}.REMEpoch,param);
    else
    end
    
    %%number post
    Num_total_REM_SD_post(m)=length(length(and(stages_SD{m}.REMEpoch,epoch_PostInj_SD{m})));
    Num_seq_REM_SD_post(m)=length(length(and(Seq_REM_SD{m},epoch_PostInj_SD{m})));
    Num_sing_REM_SD_post(m)=length(length(and(Single_REM_SD{m},epoch_PostInj_SD{m})));

    %%mean duration post
    mean_dur_total_REM_SD_post(m)=mean(End(and(stages_SD{m}.REMEpoch,epoch_PostInj_SD{m}))-Start(and(stages_SD{m}.REMEpoch,epoch_PostInj_SD{m})))/1E4;
    mean_dur_seq_REM_SD_post(m)=mean(End(and(Seq_REM_SD{m},epoch_PostInj_SD{m}))-Start(and(Seq_REM_SD{m},epoch_PostInj_SD{m})))/1E4;
    mean_dur_sing_REM_SD_post(m)=mean(End(and(Single_REM_SD{m},epoch_PostInj_SD{m}))-Start(and(Single_REM_SD{m},epoch_PostInj_SD{m})))/1E4;
    
    
    %%percentage
    Res_totalSleep_SD{m}=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,stages_SD{m}.REMEpoch,param);
    
    
    %%percentage post
    percREM_total_SD_post(m) = Res_totalSleep_SD{m}(3,1);
    percREM_seq_SD_post(m) = Res_totalSleep_SD{m}(3,2);
    percREM_sing_SD_post(m) = Res_totalSleep_SD{m}(3,3);
    
end

%%
for n=1:length(DirSocialDefeat_inhib.path)
    cd(DirSocialDefeat_inhib.path{n}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_SD_inhb{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_SD_inhb{n}.SWSEpoch = mergeCloseIntervals(stages_SD_inhb{n}.SWSEpoch, 1e4);
        stages_SD_inhb{n}.REMEpoch = mergeCloseIntervals(stages_SD_inhb{n}.REMEpoch, 1e4);
        stages_SD_inhb{n}.Wake = mergeCloseIntervals(stages_SD_inhb{n}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_SD_inhb{n} = max([max(End(stages_SD_inhb{n}.Wake)),max(End(stages_SD_inhb{n}.SWSEpoch))]);
        epoch_PostInj_SD_inhb{n} = intervalSet(0.55*1E8,durtotal_SD_inhb{n});
        
        %%get single and sequential REM epoch
        [Seq_REM_SD_inhb{n},Single_REM_SD_inhb{n}] = Find_single_sequential_REM_MC(stages_SD_inhb{n}.Wake,stages_SD_inhb{n}.SWSEpoch,stages_SD_inhb{n}.REMEpoch,param);
    else
    end
    
    %%number post
    Num_total_REM_SD_inhb_post(n)=length(length(and(stages_SD_inhb{n}.REMEpoch,epoch_PostInj_SD_inhb{n})));
    Num_seq_REM_SD_inhb_post(n)=length(length(and(Seq_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n})));
    Num_sing_REM_SD_inhb_post(n)=length(length(and(Single_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n})));

    %%mean duration post
    mean_dur_total_REM_SD_inhb_post(n)=mean(End(and(stages_SD_inhb{n}.REMEpoch,epoch_PostInj_SD_inhb{n}))-Start(and(stages_SD_inhb{n}.REMEpoch,epoch_PostInj_SD_inhb{n})))/1E4;
    mean_dur_seq_REM_SD_inhb_post(n)=mean(End(and(Seq_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n}))-Start(and(Seq_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n})))/1E4;
    mean_dur_sing_REM_SD_inhb_post(n)=mean(End(and(Single_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n}))-Start(and(Single_REM_SD_inhb{n},epoch_PostInj_SD_inhb{n})))/1E4;
    
    
    %%percentage
    Res_totalSleep_SD_inhb{n}=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(stages_SD_inhb{n}.Wake,stages_SD_inhb{n}.SWSEpoch,stages_SD_inhb{n}.REMEpoch,param);
    
    
    %%percentage post
    percREM_total_SD_inhb_post(n) = Res_totalSleep_SD_inhb{n}(3,1);
    percREM_seq_SD_inhb_post(n) = Res_totalSleep_SD_inhb{n}(3,2);
    percREM_sing_SD_inhb_post(n) = Res_totalSleep_SD_inhb{n}(3,3);
    
end

%% FIGURES

col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_sleep_inhib = [1 .4 .2];
col_SD = [1 0 0];
col_SD_inhib = [.4 0 0];




figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({...
    percREM_total_basal_13_end, percREM_total_sal_post, percREM_total_sleep_inhib_post,...
    percREM_total_basal_10_end, percREM_total_SD_post, percREM_total_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-Social def'}), xtickangle(0)
ylabel('Total REM percentage (%)')
makepretty

subplot(332)
MakeSpreadAndBoxPlot2_SB({...
    percREM_seq_basal_13_end, percREM_seq_sal_post, percREM_seq_sleep_inhib_post,...
    percREM_seq_basal_10_end, percREM_seq_SD_post, percREM_seq_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('seq REM percentage (%)')
makepretty

subplot(333)
MakeSpreadAndBoxPlot2_SB({...
    percREM_sing_basal_13_end, percREM_sing_sal_post, percREM_sing_sleep_inhib_post,...
    percREM_sing_basal_10_end, percREM_sing_SD_post, percREM_sing_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('sing REM percentage (%)')
makepretty


subplot(334)
MakeSpreadAndBoxPlot2_SB({...
    Num_total_REM_basal_13_end, Num_total_REM_sal_post, Num_total_REM_sleep_inhib_post,...
    Num_total_REM_basal_10_end, Num_total_REM_SD_post, Num_total_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('# total REM')
makepretty

subplot(335)
MakeSpreadAndBoxPlot2_SB({...
    Num_seq_REM_basal_13_end, Num_seq_REM_sal_post, Num_seq_REM_sleep_inhib_post,...
    Num_seq_REM_basal_10_end, Num_seq_REM_SD_post, Num_seq_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('# seq REM')
makepretty

subplot(336)
MakeSpreadAndBoxPlot2_SB({...
    Num_sing_REM_basal_13_end, Num_sing_REM_sal_post, Num_sing_REM_sleep_inhib_post,...
    Num_sing_REM_basal_10_end, Num_sing_REM_SD_post, Num_sing_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('# single REM')
makepretty


subplot(337)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_total_REM_basal_13_end, mean_dur_total_REM_sal_post, mean_dur_total_REM_sleep_inhib_post,...
    mean_dur_total_REM_basal_10_end, mean_dur_total_REM_SD_post, mean_dur_total_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('Mean duration total REM (s)')
makepretty

subplot(338)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_seq_REM_basal_13_end, mean_dur_seq_REM_sal_post, mean_dur_seq_REM_sleep_inhib_post,...
    mean_dur_seq_REM_basal_10_end, mean_dur_seq_REM_SD_post, mean_dur_seq_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('Mean duration seq REM (s)')
makepretty

subplot(339)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_sing_REM_basal_13_end, mean_dur_sing_REM_sal_post, mean_dur_sing_REM_sleep_inhib_post,...
    mean_dur_sing_REM_basal_10_end, mean_dur_sing_REM_SD_post, mean_dur_sing_REM_SD_inhb_post},...
    {col_basal,col_sal,col_sleep_inhib,col_basal,col_SD,col_SD_inhib},[1:6],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'Baseline 13-end','Saline','Inhibition-sleep','Baseline 10-end','Social defeat','Inhibition-SD'}), xtickangle(0)
ylabel('Mean duration single REM (s)')
makepretty


%% ADD STATS


subplot(331)
[h,p_basal_sal]=ttest2(percREM_total_basal_13_end, percREM_total_sal_post);
[h,p_sal_sleepInhib]=ttest(percREM_total_sal_post, percREM_total_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(percREM_total_basal_13_end, percREM_total_sleep_inhib_post);

[h,p_basal_SD]=ttest2(percREM_total_basal_10_end, percREM_total_SD_post);
[h,p_SD_SDInhib]=ttest2(percREM_total_SD_post, percREM_total_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(percREM_total_basal_10_end, percREM_total_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



subplot(332)
[h,p_basal_sal]=ttest2(percREM_seq_basal_13_end, percREM_seq_sal_post);
[h,p_sal_sleepInhib]=ttest(percREM_seq_sal_post, percREM_seq_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(percREM_seq_basal_13_end, percREM_seq_sleep_inhib_post);

[h,p_basal_SD]=ttest2(percREM_seq_basal_10_end, percREM_seq_SD_post);
[h,p_SD_SDInhib]=ttest2(percREM_seq_SD_post, percREM_seq_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(percREM_seq_basal_10_end, percREM_seq_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(333)
[h,p_basal_sal]=ttest2(percREM_sing_basal_13_end, percREM_sing_sal_post);
[h,p_sal_sleepInhib]=ttest(percREM_sing_sal_post, percREM_sing_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(percREM_sing_basal_13_end, percREM_sing_sleep_inhib_post);

[h,p_basal_SD]=ttest2(percREM_sing_basal_10_end, percREM_sing_SD_post);
[h,p_SD_SDInhib]=ttest2(percREM_sing_SD_post, percREM_sing_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(percREM_sing_basal_10_end, percREM_sing_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(334)
[h,p_basal_sal]=ttest2(Num_total_REM_basal_13_end, Num_total_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(Num_total_REM_sal_post, Num_total_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(Num_total_REM_basal_13_end, Num_total_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(Num_total_REM_basal_10_end, Num_total_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(Num_total_REM_SD_post, Num_total_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(Num_total_REM_basal_10_end, Num_total_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



subplot(335)
[h,p_basal_sal]=ttest2(Num_seq_REM_basal_13_end, Num_seq_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(Num_seq_REM_sal_post, Num_seq_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(Num_seq_REM_basal_13_end, Num_seq_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(Num_seq_REM_basal_10_end, Num_seq_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(Num_seq_REM_SD_post, Num_seq_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(Num_seq_REM_basal_10_end, Num_seq_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(336)
[h,p_basal_sal]=ttest2(Num_sing_REM_basal_13_end, Num_sing_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(Num_sing_REM_sal_post, Num_sing_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(Num_sing_REM_basal_13_end, Num_sing_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(Num_sing_REM_basal_10_end, Num_sing_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(Num_sing_REM_SD_post, Num_sing_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(Num_sing_REM_basal_10_end, Num_sing_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(337)
[h,p_basal_sal]=ttest2(mean_dur_total_REM_basal_13_end, mean_dur_total_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(mean_dur_total_REM_sal_post, mean_dur_total_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(mean_dur_total_REM_basal_13_end, mean_dur_total_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(mean_dur_total_REM_basal_10_end, mean_dur_total_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(mean_dur_total_REM_SD_post, mean_dur_total_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(mean_dur_total_REM_basal_10_end, mean_dur_total_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end



subplot(338)
[h,p_basal_sal]=ttest2(mean_dur_seq_REM_basal_13_end, mean_dur_seq_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(mean_dur_seq_REM_sal_post, mean_dur_seq_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(mean_dur_seq_REM_basal_13_end, mean_dur_seq_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(mean_dur_seq_REM_basal_10_end, mean_dur_seq_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(mean_dur_seq_REM_SD_post, mean_dur_seq_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(mean_dur_seq_REM_basal_10_end, mean_dur_seq_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end


subplot(339)
[h,p_basal_sal]=ttest2(mean_dur_sing_REM_basal_13_end, mean_dur_sing_REM_sal_post);
[h,p_sal_sleepInhib]=ttest(mean_dur_sing_REM_sal_post, mean_dur_sing_REM_sleep_inhib_post);
[h,p_basal_sleepInhib]=ttest2(mean_dur_sing_REM_basal_13_end, mean_dur_sing_REM_sleep_inhib_post);

[h,p_basal_SD]=ttest2(mean_dur_sing_REM_basal_10_end, mean_dur_sing_REM_SD_post);
[h,p_SD_SDInhib]=ttest2(mean_dur_sing_REM_SD_post, mean_dur_sing_REM_SD_inhb_post);
[h,p_basal_SDInhib]=ttest2(mean_dur_sing_REM_basal_10_end, mean_dur_sing_REM_SD_inhb_post);

if p_basal_sal<0.05; sigstar_DB({[1 2]},p_basal_sal,0,'LineWigth',16,'StarSize',24);end
if p_sal_sleepInhib<0.05; sigstar_DB({[2 3]},p_sal_sleepInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_sleepInhib<0.05; sigstar_DB({[1 3]},p_basal_sleepInhib,0,'LineWigth',16,'StarSize',24);end

if p_basal_SD<0.05; sigstar_DB({[4 5]},p_basal_SD,0,'LineWigth',16,'StarSize',24);end
if p_SD_SDInhib<0.05; sigstar_DB({[5 6]},p_SD_SDInhib,0,'LineWigth',16,'StarSize',24);end
if p_basal_SDInhib<0.05; sigstar_DB({[4 6]},p_basal_SDInhib,0,'LineWigth',16,'StarSize',24);end
