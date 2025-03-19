%% input dir
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1112 1148 1149 1150 1217 1219 1220 1218]);% %1107

DirSleepInhibPFC=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');
% DirSleepInhibPFC=PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_retroCre');
% DirSocialDefeat_inhibPFC = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');


%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);%1076
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
Dir_dreadd2 = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
Dir_dreadd_final = MergePathForExperiment(Dir_dreadd,Dir_dreadd2);
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd_final);
DirMyBasal=RestrictPathForExperiment(DirMyBasal,'nMice',[1109 1075 1107 1112 1217 1219 1220 1196 1197 1198 1235 1236 1237 1238]);


% %saline
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get the data for Baseline sleep
%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% run the 'load data' of CompareSingleSequentialREMPercToTimePostInjectionAndSD.m
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CompareSingleSequentialREMPercToTimePostInjectionAndSD

%% get data SALINE 
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_sal{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
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
        %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_sal{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_sal{j},Single_REM_sal{j}] = Find_single_sequential_REM_MC(stages_sal{j}.Wake,stages_sal{j}.SWSEpoch,stages_sal{j}.REMEpoch);
    else
    end
    
    %%number post inj
    Num_total_REM_sal_post(j)=length(length(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_seq_REM_sal_post(j)=length(length(and(Seq_REM_sal{j},epoch_PostInj_sal{j}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_sal_post(j)=length(length(and(Single_REM_sal{j},epoch_PostInj_sal{j}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number 3h post
    Num_total_REM_sal_3hpost(j)=length(length(and(stages_sal{j}.REMEpoch,epoch_3hPostInj_sal{j})));
    Num_seq_REM_sal_3hpost(j)=length(length(and(Seq_REM_sal{j},epoch_3hPostInj_sal{j})));
    Num_sing_REM_sal_3hpost(j)=length(length(and(Single_REM_sal{j},epoch_3hPostInj_sal{j})));
    
    %%mean duration pre
    mean_dur_total_REM_sal_pre(j)=mean(End(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j}))-Start(and(stages_sal{j}.REMEpoch,epoch_PostInj_sal{j})))/1E4;
    mean_dur_seq_REM_sal_pre(j)=mean(End(and(Seq_REM_sal{j},epoch_PostInj_sal{j}))-Start(and(Seq_REM_sal{j},epoch_PostInj_sal{j})))/1E4;
    mean_dur_sing_REM_sal_pre(j)=mean(End(and(Single_REM_sal{j},epoch_PostInj_sal{j}))-Start(and(Single_REM_sal{j},epoch_PostInj_sal{j})))/1E4;
    %%mean duration post
    mean_dur_total_REM_sal_post(j)=mean(End(and(stages_sal{j}.REMEpoch,epoch_3hPostInj_sal{j}))-Start(and(stages_sal{j}.REMEpoch,epoch_3hPostInj_sal{j})))/1E4;
    mean_dur_seq_REM_sal_post(j)=mean(End(and(Seq_REM_sal{j},epoch_3hPostInj_sal{j}))-Start(and(Seq_REM_sal{j},epoch_3hPostInj_sal{j})))/1E4;
    mean_dur_sing_REM_sal_post(j)=mean(End(and(Single_REM_sal{j},epoch_3hPostInj_sal{j}))-Start(and(Single_REM_sal{j},epoch_3hPostInj_sal{j})))/1E4;
    
    %%percentage
    Res_totalSleep_sal{j}=Compute_Seq_Single_REM_Percentages_MC(stages_sal{j}.Wake,stages_sal{j}.SWSEpoch,stages_sal{j}.REMEpoch);
    %%percentage pre
    percREM_total_sal_pre(j) = Res_totalSleep_sal{j}(2,1);
    percREM_seq_sal_pre(j) = Res_totalSleep_sal{j}(2,2);
    percREM_sing_sal_pre(j) = Res_totalSleep_sal{j}(2,3);
    %%percentage post
    percREM_total_sal_post(j) = Res_totalSleep_sal{j}(3,1);
    percREM_seq_sal_post(j) = Res_totalSleep_sal{j}(3,2);
    percREM_sing_sal_post(j) = Res_totalSleep_sal{j}(3,3);
end

%% get data sleepInhib (sleep)
for k=1:length(DirSleepInhibPFC.path)
    cd(DirSleepInhibPFC.path{k}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_sleepInhib{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_sleepInhib{k} = max([max(End(stages_sleepInhib{k}.Wake)),max(End(stages_sleepInhib{k}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_sleepInhib{k} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
        %post injection
        epoch_PostInj_sleepInhib{k} = intervalSet(st_epoch_postInj,durtotal_sleepInhib{k});
        %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_sleepInhib{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_sleepInhib{k},Single_REM_sleepInhib{k}] = Find_single_sequential_REM_MC(stages_sleepInhib{k}.Wake,stages_sleepInhib{k}.SWSEpoch,stages_sleepInhib{k}.REMEpoch);
    else
    end
    
    %%number pre
    Num_total_REM_sleepInhib_post(k)=length(length(and(stages_sleepInhib{k}.REMEpoch,epoch_PostInj_sleepInhib{k})));
    Num_seq_REM_sleepInhib_post(k)=length(length(and(Seq_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_sleepInhib_post(k)=length(length(and(Single_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number post
    Num_total_REM_sleepInhib_3hpost(k)=length(length(and(stages_sleepInhib{k}.REMEpoch,epoch_3hPostInj_sleepInhib{k})));
    Num_seq_REM_sleepInhib_3hpost(k)=length(length(and(Seq_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k})));
    Num_sing_REM_sleepInhib_3hpost(k)=length(length(and(Single_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k})));
    
    %%mean duration pre
    mean_dur_total_REM_sleepInhib_post(k)=mean(End(and(stages_sleepInhib{k}.REMEpoch,epoch_PostInj_sleepInhib{k}))-Start(and(stages_sleepInhib{k}.REMEpoch,epoch_PostInj_sleepInhib{k})))/1E4;
    mean_dur_seq_REM_sleepInhib_post(k)=mean(End(and(Seq_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k}))-Start(and(Seq_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k})))/1E4;
    mean_dur_sing_REM_sleepInhib_post(k)=mean(End(and(Single_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k}))-Start(and(Single_REM_sleepInhib{k},epoch_PostInj_sleepInhib{k})))/1E4;
    %%mean duration post
    mean_dur_total_REM_sleepInhib_3hpost(k)=mean(End(and(stages_sleepInhib{k}.REMEpoch,epoch_3hPostInj_sleepInhib{k}))-Start(and(stages_sleepInhib{k}.REMEpoch,epoch_3hPostInj_sleepInhib{k})))/1E4;
    mean_dur_seq_REM_sleepInhib_3hpost(k)=mean(End(and(Seq_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k}))-Start(and(Seq_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k})))/1E4;
    mean_dur_sing_REM_sleepInhib_3hpost(k)=mean(End(and(Single_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k}))-Start(and(Single_REM_sleepInhib{k},epoch_3hPostInj_sleepInhib{k})))/1E4;
    
    
    %%percentage
    Res_totalSleep_sleepInhib{k}=Compute_Seq_Single_REM_Percentages_MC(stages_sleepInhib{k}.Wake,stages_sleepInhib{k}.SWSEpoch,stages_sleepInhib{k}.REMEpoch);
    
    %%percentage pre
    percREM_total_sleepInhib_pre(k) = Res_totalSleep_sleepInhib{k}(2,1);
    percREM_seq_sleepInhib_pre(k) = Res_totalSleep_sleepInhib{k}(2,2);
    percREM_sing_sleepInhib_pre(k) = Res_totalSleep_sleepInhib{k}(2,3);
    
    %%percentage post
    percREM_total_sleepInhib_post(k) = Res_totalSleep_sleepInhib{k}(3,1);
    percREM_seq_sleepInhib_post(k) = Res_totalSleep_sleepInhib{k}(3,2);
    percREM_sing_sleepInhib_post(k) = Res_totalSleep_sleepInhib{k}(3,3);
    
end

%% get data SD (sleep)
for m=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{m}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_SD{m} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_SD{m} = max([max(End(stages_SD{m}.Wake)),max(End(stages_SD{m}.SWSEpoch))]);
        epoch_3hPost_SD{m}=intervalSet(0,3*3600*1E4);
        
        %%get single and sequential REM epoch
        [Seq_REM_SD{m},Single_REM_SD{m}] = Find_single_sequential_REM_MC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,stages_SD{m}.REMEpoch);
    else
    end
    
    %%number all
    Num_total_REM_SD(m)=length(length(stages_SD{m}.REMEpoch));
    Num_seq_REM_SD(m)=length(length(Seq_REM_SD{m})); 
    Num_sing_REM_SD(m)=length(length(Single_REM_SD{m})); 
    %%number 3h post
    Num_total_REM_SD_3hpost(m)=length(length(and(stages_SD{m}.REMEpoch,epoch_3hPost_SD{m})));
    Num_seq_REM_SD_3hpost(m)=length(length(and(Seq_REM_SD{m},epoch_3hPost_SD{m})));
    Num_sing_REM_SD_3hpost(m)=length(length(and(Single_REM_SD{m},epoch_3hPost_SD{m})));
    
    %%mean duration all
    mean_dur_total_REM_SD(m)=mean(End(stages_SD{m}.REMEpoch)-Start(stages_SD{m}.REMEpoch))/1E4;
    mean_dur_seq_REM_SD(m)=mean(End(Seq_REM_SD{m})-Start(Seq_REM_SD{m}))/1E4;
    mean_dur_sing_REM_SD(m)=mean(End(Single_REM_SD{m})-Start(Single_REM_SD{m}))/1E4;
    %%mean duration 3h post
    mean_dur_total_REM_SD_3hpost(m)=mean(End(and(stages_SD{m}.REMEpoch,epoch_3hPost_SD{m}))-Start(and(stages_SD{m}.REMEpoch,epoch_3hPost_SD{m})))/1E4;
    mean_dur_seq_REM_SD_3hpost(m)=mean(End(and(Seq_REM_SD{m},epoch_3hPost_SD{m}))-Start(and(Seq_REM_SD{m},epoch_3hPost_SD{m})))/1E4;
    mean_dur_sing_REM_SD_3hpost(m)=mean(End(and(Single_REM_SD{m},epoch_3hPost_SD{m}))-Start(and(Single_REM_SD{m},epoch_3hPost_SD{m})))/1E4;
    
    
    %%percentage
%     Res_totalSleep_SD{m}=Compute_Seq_Single_REM_Percentages_MC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,stages_SD{m}.REMEpoch);
%     % Res(1,:) all recording
%     % Res(2,:) pre injection
%     % Res(3,:) post injection
%     
%     % Res(x,1) total rem
%     % Res(x,2) sequential rem
%     % Res(x,3) single rem
% 
%     %%percentage pre
%     percREM_total_SD(m) = Res_totalSleep_SD{m}(1,1);
%     percREM_seq_SD(m) = Res_totalSleep_SD{m}(1,2);
%     percREM_sing_SD(m) = Res_totalSleep_SD{m}(1,3);
%     
% %     %%percentage 3h post
% %     percREM_total_SD_3hPost(m) = Res_totalSleep_SD{m}(3,1);
% %     percREM_seq_SD_3hPost(m) = Res_totalSleep_SD{m}(3,2);
% %     percREM_sing_SD_3hPost(m) = Res_totalSleep_SD{m}(3,3);
%     
SleepStagePerc_SD{m} = ComputeSleepStagesPercentagesMC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,stages_SD{m}.REMEpoch);
percREM_total_SD(m) = SleepStagePerc_SD{m}(3,1);

SleepStagePerc_SD{m} = ComputeSleepStagesPercentagesMC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,Seq_REM_SD{m});
percREM_seq_SD(m) = SleepStagePerc_SD{m}(3,1);

SleepStagePerc_SD{m} = ComputeSleepStagesPercentagesMC(stages_SD{m}.Wake,stages_SD{m}.SWSEpoch,Single_REM_SD{m});
percREM_sing_SD(m) = SleepStagePerc_SD{m}(3,1);

end

%% get data social defeat + inhibition
for n=1:length(DirSocialDefeat_inhibPFC.path)
    cd(DirSocialDefeat_inhibPFC.path{n}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_SD_inhib{n} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_SD_inhib{n} = max([max(End(stages_SD_inhib{n}.Wake)),max(End(stages_SD_inhib{n}.SWSEpoch))]);
        epoch_3hPost_SD_inhib{n}=intervalSet(0,3*3600*1E4);
        
        %%get single and sequential REM epoch
        [Seq_REM_SD_inhib{n},Single_REM_SD_inhib{n}] = Find_single_sequential_REM_MC(stages_SD_inhib{n}.Wake,stages_SD_inhib{n}.SWSEpoch,stages_SD_inhib{n}.REMEpoch);
    else
    end
    
    %%number all
    Num_total_REM_SD_inhib_pre(n)=length(length(stages_SD_inhib{n}.REMEpoch));
    Num_seq_REM_SD_inhib_pre(n)=length(length(Seq_REM_SD_inhib{n})); 
    Num_sing_REM_SD_inhib_pre(n)=length(length(Single_REM_SD_inhib{n})); 
    %%number 3h post
    Num_total_REM_SD_inhib_post(n)=length(length(and(stages_SD_inhib{n}.REMEpoch,epoch_3hPost_SD_inhib{n})));
    Num_seq_REM_SD_inhib_post(n)=length(length(and(Seq_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n})));
    Num_sing_REM_SD_inhib_post(n)=length(length(and(Single_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n})));
    
    %%mean duration all
    mean_dur_total_REM_SD_inhib_pre(n)=mean(End(stages_SD_inhib{n}.REMEpoch)-Start(stages_SD_inhib{n}.REMEpoch))/1E4;
    mean_dur_seq_REM_SD_inhib_pre(n)=mean(End(Seq_REM_SD_inhib{n})-Start(Seq_REM_SD_inhib{n}))/1E4;
    mean_dur_sing_REM_SD_inhib_pre(n)=mean(End(Single_REM_SD_inhib{n})-Start(Single_REM_SD_inhib{n}))/1E4;
    %%mean duration 3h post
    mean_dur_total_REM_SD_inhib_post(n)=mean(End(and(stages_SD_inhib{n}.REMEpoch,epoch_3hPost_SD_inhib{n}))-Start(and(stages_SD_inhib{n}.REMEpoch,epoch_3hPost_SD_inhib{n})))/1E4;
    mean_dur_seq_REM_SD_inhib_post(n)=mean(End(and(Seq_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n}))-Start(and(Seq_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n})))/1E4;
    mean_dur_sing_REM_SD_inhib_post(n)=mean(End(and(Single_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n}))-Start(and(Single_REM_SD_inhib{n},epoch_3hPost_SD_inhib{n})))/1E4;
    
    
    %%percentage
%     Res_totalSleep_SD_inhib{n}=Compute_Seq_Single_REM_Percentages_MC(stages_SD_inhib{n}.Wake,stages_SD_inhib{n}.SWSEpoch,stages_SD_inhib{n}.REMEpoch);
%     % Res(1,:) all recording
%     % Res(2,:) pre injection
%     % Res(3,:) post injection
%     
%     % Res(x,1) total rem
%     % Res(x,2) sequential rem
%     % Res(x,3) single rem
% 
%     %%percentage pre
%     percREM_total_SD_inhib(n) = Res_totalSleep_SD_inhib{n}(1,1);
%     percREM_seq_SD_inhib(n) = Res_totalSleep_SD_inhib{n}(1,2);
%     percREM_sing_SD_inhib(n) = Res_totalSleep_SD_inhib{n}(1,3);
%     
% %     %%percentage 3h post
% %     percREM_total_SD_inhib_3hPost(m) = Res_totalSleep_SD_inhib{m}(3,1);
% %     percREM_seq_SD_inhib_3hPost(m) = Res_totalSleep_SD_inhib{m}(3,2);
% %     percREM_sing_SD_inhib_3hPost(m) = Res_totalSleep_SD_inhib{m}(3,3);

   SleepStagePerc_SD_inhib{n} = ComputeSleepStagesPercentagesMC(stages_SD_inhib{n}.Wake,stages_SD_inhib{n}.SWSEpoch,stages_SD_inhib{n}.REMEpoch);
percREM_total_SD_inhib(n) = SleepStagePerc_SD_inhib{n}(3,1);

SleepStagePerc_SD_inhib{n} = ComputeSleepStagesPercentagesMC(stages_SD_inhib{n}.Wake,stages_SD_inhib{n}.SWSEpoch,Seq_REM_SD_inhib{n});
percREM_seq_SD_inhib(n) = SleepStagePerc_SD_inhib{n}(3,1);

SleepStagePerc_SD_inhib{n} = ComputeSleepStagesPercentagesMC(stages_SD_inhib{n}.Wake,stages_SD_inhib{n}.SWSEpoch,Single_REM_SD_inhib{n});
percREM_sing_SD_inhib(n) = SleepStagePerc_SD_inhib{n}(3,1);

end



%% figure (boxplot)
col_basal = [0.9 0.9 0.9];
col_sal = [0.5 0.5 0.5];
col_PFCinhib = [1 .4 .2];
col_SD = [1 0 0];
col_PFCinhib_SD = [.4 0 0];

figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({perc_total_REM_basal_13_end percREM_total_sal_pre percREM_total_sleepInhib_pre...
    perc_total_REM_basal_10_end percREM_total_SD percREM_total_SD_inhib},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
ylabel('REM percentage (%)')
title('Total REM')

subplot(332)
MakeSpreadAndBoxPlot2_SB({perc_seq_REM_basal_13_end percREM_seq_sal_pre percREM_seq_sleepInhib_pre...
    perc_seq_REM_basal_10_end percREM_seq_SD percREM_seq_SD_inhib},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
title('Sequential REM')

subplot(333)
MakeSpreadAndBoxPlot2_SB({perc_sing_REM_basal_13_end percREM_sing_sal_pre percREM_sing_sleepInhib_pre...
    perc_sing_REM_basal_10_end percREM_sing_SD percREM_sing_SD_inhib},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
title('Single REM')

subplot(334)
MakeSpreadAndBoxPlot2_SB({Num_total_REM_basal_13_end Num_total_REM_sal_post Num_total_REM_sleepInhib_post...
    Num_total_REM_basal_10_end Num_total_REM_SD Num_total_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
ylabel('# REM')

subplot(335)
MakeSpreadAndBoxPlot2_SB({Num_seq_REM_basal_13_end Num_seq_REM_sal_post Num_seq_REM_sleepInhib_post...
    Num_seq_REM_basal_10_end Num_seq_REM_SD Num_seq_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty

subplot(336)
MakeSpreadAndBoxPlot2_SB({Num_sing_REM_basal_13_end Num_sing_REM_sal_post Num_sing_REM_sleepInhib_post...
    Num_sing_REM_basal_10_end Num_sing_REM_SD Num_sing_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty

subplot(337)
MakeSpreadAndBoxPlot2_SB({dur_total_REM_basal_13_end mean_dur_total_REM_sal_pre mean_dur_total_REM_sleepInhib_post...
    dur_total_REM_basal_10_end mean_dur_total_REM_SD mean_dur_total_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition','Baseline (10-end)','SD','SD + inhibition'}); xtickangle(45);
ylabel('Mean duration (s)')

subplot(338)
MakeSpreadAndBoxPlot2_SB({dur_seq_REM_basal_13_end mean_dur_seq_REM_sal_pre mean_dur_seq_REM_sleepInhib_post...
    dur_seq_REM_basal_10_end mean_dur_seq_REM_SD mean_dur_seq_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition','Baseline (10-end)','SD','SD + inhibition'}); xtickangle(45);

subplot(339)
MakeSpreadAndBoxPlot2_SB({dur_sing_REM_basal_13_end mean_dur_sing_REM_sal_pre mean_dur_sing_REM_sleepInhib_post...
    dur_sing_REM_basal_10_end mean_dur_sing_REM_SD mean_dur_sing_REM_SD_inhib_pre},...
    {col_basal,col_sal,col_PFCinhib,col_basal, col_SD,col_PFCinhib_SD},[1:6],{},'ShowPoints',1,'paired',0,'optiontest','ranksum');
makepretty
xticks([1:6]); xticklabels({'Baseline (13-end)','Saline','Inhibition','Baseline (10-end)','SD','SD + inhibition'}); xtickangle(45);

