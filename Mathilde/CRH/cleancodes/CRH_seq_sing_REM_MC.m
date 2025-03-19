%% input dir basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

%% input dir Saline
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% % DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
% %merge saline path
% Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

DirCNO = PathForExperimentsAtropine_MC('Atropine');

%%

% DirCNO = PathForExperimentsSD_MC('SleepPostSD');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1075 1112 1148 1149 1150 1217 1219 1220 1218]);% %1107

%%
% DirSaline=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
% DirCNO=PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

param = 'after';

%% get data BASELINE sleep
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
        %pre injection
        epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
        %post injection
        epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});

        %3h post injection
        epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_basal{i},Single_REM_basal{i}] = Find_single_sequential_REM_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    else
    end
    
    %%number pre
    Num_total_REM_basal_pre(i)=length(length(and(stages_basal{i}.REMEpoch,epoch_PreInj_basal{i})));
    Num_seq_REM_basal_pre(i)=length(length(and(Seq_REM_basal{i},epoch_PreInj_basal{i}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_basal_pre(i)=length(length(and(Single_REM_basal{i},epoch_PreInj_basal{i}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number post
    Num_total_REM_basal_post(i)=length(length(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i})));
    Num_seq_REM_basal_post(i)=length(length(and(Seq_REM_basal{i},epoch_PostInj_basal{i})));
    Num_sing_REM_basal_post(i)=length(length(and(Single_REM_basal{i},epoch_PostInj_basal{i})));
    
    %%mean duration pre
    mean_dur_total_REM_basal_pre(i)=mean(End(and(stages_basal{i}.REMEpoch,epoch_PreInj_basal{i}))-Start(and(stages_basal{i}.REMEpoch,epoch_PreInj_basal{i})))/1E4;
    mean_dur_seq_REM_basal_pre(i)=mean(End(and(Seq_REM_basal{i},epoch_PreInj_basal{i}))-Start(and(Seq_REM_basal{i},epoch_PreInj_basal{i})))/1E4;
    mean_dur_sing_REM_basal_pre(i)=mean(End(and(Single_REM_basal{i},epoch_PreInj_basal{i}))-Start(and(Single_REM_basal{i},epoch_PreInj_basal{i})))/1E4;
    %%mean duration post
    mean_dur_total_REM_basal_post(i)=mean(End(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
    mean_dur_seq_REM_basal_post(i)=mean(End(and(Seq_REM_basal{i},epoch_PostInj_basal{i}))-Start(and(Seq_REM_basal{i},epoch_PostInj_basal{i})))/1E4;
    mean_dur_sing_REM_basal_post(i)=mean(End(and(Single_REM_basal{i},epoch_PostInj_basal{i}))-Start(and(Single_REM_basal{i},epoch_PostInj_basal{i})))/1E4;
    
 
    %%percentage
    Res_totalSleep_basal{i}=Compute_Seq_Single_REM_Percentages_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    % Res(1,:) all recording
    % Res(2,:) pre injection
    % Res(3,:) post injection
    
    % Res(x,1) total rem
    % Res(x,2) sequential rem
    % Res(x,3) single rem
    
    %%percentage pre
    percREM_total_basal_pre(i) = Res_totalSleep_basal{i}(2,1);
    percREM_seq_basal_pre(i) = Res_totalSleep_basal{i}(2,2);
    percREM_sing_basal_pre(i) = Res_totalSleep_basal{i}(2,3);
    
    %%percentage post
    percREM_total_basal_post(i) = Res_totalSleep_basal{i}(3,1);
    percREM_seq_basal_post(i) = Res_totalSleep_basal{i}(3,2);
    percREM_sing_basal_post(i) = Res_totalSleep_basal{i}(3,3);
    
end

%% get data SALINE sleep
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

%% get data CNO
for k=1:length(DirCNO.path)
    cd(DirCNO.path{k}{1});
    if exist('SleepScoring_Accelero.mat')
        stages_cno{k} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        stages_cno{k}.SWSEpoch = mergeCloseIntervals(stages_cno{k}.SWSEpoch, 1e4);
        stages_cno{k}.REMEpoch = mergeCloseIntervals(stages_cno{k}.REMEpoch, 1e4);
        stages_cno{k}.Wake = mergeCloseIntervals(stages_cno{k}.Wake, 1e4);
    else
    end
    
    if exist('SleepScoring_Accelero.mat')
        %%periods of time
        durtotal_cno{k} = max([max(End(stages_cno{k}.Wake)),max(End(stages_cno{k}.SWSEpoch))]);
        %pre injection
        epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
        %post injection
        epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal_cno{k});
        %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
        %3h post injection
        epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
        
        %%get single and sequential REM epoch
        [Seq_REM_cno{k},Single_REM_cno{k}] = Find_single_sequential_REM_MC(stages_cno{k}.Wake,stages_cno{k}.SWSEpoch,stages_cno{k}.REMEpoch,param);
    else
    end
    
    %%number pre
    Num_total_REM_cno_pre(k)=length(length(and(stages_cno{k}.REMEpoch,epoch_PreInj_cno{k})));
    Num_seq_REM_cno_pre(k)=length(length(and(Seq_REM_cno{k},epoch_PreInj_cno{k}))); %Num_seq_REM_basal_pre(Num_seq_REM_basal_pre==0)=NaN;
    Num_sing_REM_cno_pre(k)=length(length(and(Single_REM_cno{k},epoch_PreInj_cno{k}))); %Num_sing_REM_basal_pre(Num_sing_REM_basal_pre==0)=NaN;
    %%number post
    Num_total_REM_cno_post(k)=length(length(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k})));
    Num_seq_REM_cno_post(k)=length(length(and(Seq_REM_cno{k},epoch_PostInj_cno{k})));
    Num_sing_REM_cno_post(k)=length(length(and(Single_REM_cno{k},epoch_PostInj_cno{k})));
    
    %%mean duration pre
    mean_dur_total_REM_cno_pre(k)=mean(End(and(stages_cno{k}.REMEpoch,epoch_PreInj_cno{k}))-Start(and(stages_cno{k}.REMEpoch,epoch_PreInj_cno{k})))/1E4;
    mean_dur_seq_REM_cno_pre(k)=mean(End(and(Seq_REM_cno{k},epoch_PreInj_cno{k}))-Start(and(Seq_REM_cno{k},epoch_PreInj_cno{k})))/1E4;
    mean_dur_sing_REM_cno_pre(k)=mean(End(and(Single_REM_cno{k},epoch_PreInj_cno{k}))-Start(and(Single_REM_cno{k},epoch_PreInj_cno{k})))/1E4;
    %%mean duration post
    mean_dur_total_REM_cno_post(k)=mean(End(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k}))-Start(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k})))/1E4;
    mean_dur_seq_REM_cno_post(k)=mean(End(and(Seq_REM_cno{k},epoch_PostInj_cno{k}))-Start(and(Seq_REM_cno{k},epoch_PostInj_cno{k})))/1E4;
    mean_dur_sing_REM_cno_post(k)=mean(End(and(Single_REM_cno{k},epoch_PostInj_cno{k}))-Start(and(Single_REM_cno{k},epoch_PostInj_cno{k})))/1E4;
    
    
    %%percentage
    Res_totalSleep_cno{k}=Compute_Seq_Single_REM_Percentages_MC(stages_cno{k}.Wake,stages_cno{k}.SWSEpoch,stages_cno{k}.REMEpoch,param);
    
    %%percentage pre
    percREM_total_cno_pre(k) = Res_totalSleep_cno{k}(2,1);
    percREM_seq_cno_pre(k) = Res_totalSleep_cno{k}(2,2);
    percREM_sing_cno_pre(k) = Res_totalSleep_cno{k}(2,3);
    
    %%percentage post
    percREM_total_cno_post(k) = Res_totalSleep_cno{k}(3,1);
    percREM_seq_cno_post(k) = Res_totalSleep_cno{k}(3,2);
    percREM_sing_cno_post(k) = Res_totalSleep_cno{k}(3,3);
    
end
%%

col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

col_pre_saline = [1 0.6 0.6]; %%rose
col_post_saline = [1 0.6 0.6];
col_pre_cno = [1 0 0];%rouge
col_post_cno = [1 0 0];


% col_pre_saline = [0.3 0.3 0.3]; %vert
% col_post_saline = [0.3 0.3 0.3];
% col_pre_cno = [0.4 1 0.2];
% col_post_cno = [0.4 1 0.2];


figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({percREM_total_basal_pre percREM_total_sal_pre percREM_total_cno_pre...
    percREM_total_basal_post percREM_total_sal_post percREM_total_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Total REM percentage (%)')
% title('/ total sleep')
makepretty

subplot(332)
MakeSpreadAndBoxPlot2_SB({percREM_seq_basal_pre percREM_seq_sal_pre percREM_seq_cno_pre...
    percREM_seq_basal_post percREM_seq_sal_post percREM_seq_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Sequential REM percentage (%)')
% title('/ total sleep')
makepretty

subplot(333)
MakeSpreadAndBoxPlot2_SB({percREM_sing_basal_pre percREM_sing_sal_pre percREM_sing_cno_pre...
    percREM_sing_basal_post percREM_sing_sal_post percREM_sing_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Single REM percentage (%)')
% title('/ total sleep')
makepretty

subplot(334)
MakeSpreadAndBoxPlot2_SB({Num_total_REM_basal_pre Num_total_REM_sal_pre Num_total_REM_cno_pre...
    Num_total_REM_basal_post Num_total_REM_sal_post Num_total_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# total REM')
% title('/ total sleep')
makepretty

subplot(335)
MakeSpreadAndBoxPlot2_SB({Num_seq_REM_basal_pre Num_seq_REM_sal_pre Num_seq_REM_cno_pre...
    Num_seq_REM_basal_post Num_seq_REM_sal_post Num_seq_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# sequential REM')
% title('/ total sleep')
makepretty

subplot(336)
MakeSpreadAndBoxPlot2_SB({Num_sing_REM_basal_pre Num_sing_REM_sal_pre Num_sing_REM_cno_pre...
    Num_sing_REM_basal_post Num_sing_REM_sal_post Num_sing_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# single REM')
% title('/ total sleep')
makepretty

subplot(337)
MakeSpreadAndBoxPlot2_SB({mean_dur_total_REM_basal_pre mean_dur_total_REM_sal_pre mean_dur_total_REM_cno_pre...
    mean_dur_total_REM_basal_post mean_dur_total_REM_sal_post mean_dur_total_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration total REM (s)')
% title('/ total sleep')
makepretty

subplot(338)
MakeSpreadAndBoxPlot2_SB({mean_dur_seq_REM_basal_pre mean_dur_seq_REM_sal_pre mean_dur_seq_REM_cno_pre...
    mean_dur_seq_REM_basal_post mean_dur_seq_REM_sal_post mean_dur_seq_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration sequential REM (s)')
% title('/ total sleep')
makepretty

subplot(339)
MakeSpreadAndBoxPlot2_SB({mean_dur_sing_REM_basal_pre mean_dur_sing_REM_sal_pre mean_dur_sing_REM_cno_pre...
    mean_dur_sing_REM_basal_post mean_dur_sing_REM_sal_post mean_dur_sing_REM_cno_post},...
    {col_pre_basal,col_pre_saline,col_pre_cno,col_post_basal,col_post_saline,col_post_cno},[1:6],{},'paired',0,'optiontest','ranksum');
xticks([2 5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration single REM (s)')
% title('/ total sleep')
makepretty


%% W/OUT BASELINE

col_pre_saline = [0.8 0.8 0.8]; 
col_post_saline = [0.8 0.8 0.8];

col_pre_cno = [1 0 0];
col_post_cno = [1 0 0];


figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({percREM_total_sal_pre percREM_total_cno_pre...
     percREM_total_sal_post percREM_total_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Total REM percentage (%)')
% title('/ total sleep')
makepretty
% p_pre=signrank(percREM_total_sal_pre, percREM_total_cno_pre);
[h,p_pre]=ttest(percREM_total_sal_pre, percREM_total_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(percREM_total_sal_post, percREM_total_cno_post);
[h,p_post]=ttest(percREM_total_sal_post, percREM_total_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])



subplot(332)
MakeSpreadAndBoxPlot2_SB({percREM_seq_sal_pre percREM_seq_cno_pre...
     percREM_seq_sal_post percREM_seq_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Sequential REM percentage (%)')
% title('/ total sleep')
makepretty
% p_pre=signrank(percREM_seq_sal_pre, percREM_seq_cno_pre);
[h,p_pre]=ttest(percREM_seq_sal_pre, percREM_seq_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(percREM_seq_sal_post, percREM_seq_cno_post);
[h,p_post]=ttest(percREM_seq_sal_post, percREM_seq_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])




subplot(333)
MakeSpreadAndBoxPlot2_SB({ percREM_sing_sal_pre percREM_sing_cno_pre...
     percREM_sing_sal_post percREM_sing_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('Single REM percentage (%)')
% title('/ total sleep')
makepretty
% p_pre=signrank(percREM_sing_sal_pre, percREM_sing_cno_pre);
[h,p_pre]=ttest(percREM_sing_sal_pre, percREM_sing_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(percREM_sing_sal_post, percREM_sing_cno_post);
[h,p_post]=ttest(percREM_sing_sal_post, percREM_sing_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])



subplot(334)
MakeSpreadAndBoxPlot2_SB({Num_total_REM_sal_pre Num_total_REM_cno_pre Num_total_REM_sal_post Num_total_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# total REM')
% title('/ total sleep')
makepretty
% p_pre=signrank(Num_total_REM_sal_pre, Num_total_REM_cno_pre);
[~,p_pre]=ttest(Num_total_REM_sal_pre, Num_total_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(Num_total_REM_sal_post, Num_total_REM_cno_post);
[h,p_post]=ttest(Num_total_REM_sal_post, Num_total_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])



subplot(335)
MakeSpreadAndBoxPlot2_SB({Num_seq_REM_sal_pre Num_seq_REM_cno_pre...
    Num_seq_REM_sal_post Num_seq_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# sequential REM')
% title('/ total sleep')
makepretty
% p_pre=signrank(Num_seq_REM_sal_pre, Num_seq_REM_cno_pre);
[h,p_pre]=ttest(Num_seq_REM_sal_pre, Num_seq_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(Num_seq_REM_sal_post, Num_seq_REM_cno_post);
[h,p_post]=ttest(Num_seq_REM_sal_post, Num_seq_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])



subplot(336)
MakeSpreadAndBoxPlot2_SB({Num_sing_REM_sal_pre Num_sing_REM_cno_pre...
    Num_sing_REM_sal_post Num_sing_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('# single REM')
% title('/ total sleep')
makepretty
% p_pre=signrank(Num_sing_REM_sal_pre, Num_sing_REM_cno_pre);
[h,p_pre]=ttest(Num_sing_REM_sal_pre, Num_sing_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(Num_sing_REM_sal_post, Num_sing_REM_cno_post);
[h,p_post]=ttest(Num_sing_REM_sal_post, Num_sing_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])

subplot(337)
MakeSpreadAndBoxPlot2_SB({mean_dur_total_REM_sal_pre mean_dur_total_REM_cno_pre...
    mean_dur_total_REM_sal_post mean_dur_total_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration total REM (s)')
% title('/ total sleep')
makepretty
% p_pre=signrank(mean_dur_total_REM_sal_pre, mean_dur_total_REM_cno_pre);
[h,p_pre]=ttest(mean_dur_total_REM_sal_pre, mean_dur_total_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(mean_dur_total_REM_sal_post, mean_dur_total_REM_cno_post);
[h,p_post]=ttest(mean_dur_total_REM_sal_post, mean_dur_total_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])

subplot(338)
MakeSpreadAndBoxPlot2_SB({mean_dur_seq_REM_sal_pre mean_dur_seq_REM_cno_pre...
    mean_dur_seq_REM_sal_post mean_dur_seq_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration sequential REM (s)')
% title('/ total sleep')
makepretty
% p_pre=signrank(mean_dur_seq_REM_sal_pre, mean_dur_seq_REM_cno_pre);
[h,p_pre]=ttest(mean_dur_seq_REM_sal_pre, mean_dur_seq_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(mean_dur_seq_REM_sal_post, mean_dur_seq_REM_cno_post);
[h,p_post]=ttest(mean_dur_seq_REM_sal_post, mean_dur_seq_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])

subplot(339)
MakeSpreadAndBoxPlot2_SB({mean_dur_sing_REM_sal_pre mean_dur_sing_REM_cno_pre...
    mean_dur_sing_REM_sal_post mean_dur_sing_REM_cno_post},...
    {col_pre_saline,col_pre_cno,col_post_saline,col_post_cno},[1:4],{},'paired',1,'optiontest','ranksum','ShowPoints',0,'showsigstar','none');
xticks([1.5 3.5]); xticklabels({'pre','post'}); xtickangle(0)
ylabel('mean duration single REM (s)')
% title('/ total sleep')
makepretty
% p_pre=signrank(mean_dur_sing_REM_sal_pre, mean_dur_sing_REM_cno_pre);
[h,p_pre]=ttest(mean_dur_sing_REM_sal_pre, mean_dur_sing_REM_cno_pre);
if p_pre<0.05
    sigstar_DB({[1 2]},p_pre,0,'LineWigth',16,'StarSize',24);
end
% p_post=signrank(mean_dur_sing_REM_sal_post, mean_dur_sing_REM_cno_post);
[h,p_post]=ttest(mean_dur_sing_REM_sal_post, mean_dur_sing_REM_cno_post);
if p_post<0.05
    sigstar_DB({[3 4]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p pre=', num2str(p_pre), ' p post=', num2str(p_post)])
