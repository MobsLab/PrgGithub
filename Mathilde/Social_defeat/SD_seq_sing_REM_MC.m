%% input dir basal sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1109]);%1076
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('BaselineSleep');
Dir_dreadd2 = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
Dir_dreadd_final = MergePathForExperiment(Dir_dreadd,Dir_dreadd2);
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd_final);

% DirMyBasal = RestrictPathForExperiment(DirMyBasal,'nMice',[1075 1107 1112]);

%% input dir SD
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% DirSocialDefeat = RestrictPathForExperiment(DirSocialDefeat,'nMice',[1075 1107 1112]);
% DirSocialDefeat = RestrictPathForExperiment(DirSocialDefeat,'nMice',[1148 1149 1150 1217 1218 1219 1220]);

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
        epoch_PostInj_basal{i} = intervalSet(0.55*1E8,durtotal_basal{i});

        %%get single and sequential REM epoch
        [Seq_REM_basal{i},Single_REM_basal{i}] = Find_single_sequential_REM_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    else
    end
    
    Num_total_REM_basal_post(i)=length(length(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i})));
    Num_seq_REM_basal_post(i)=length(length(and(Seq_REM_basal{i},epoch_PostInj_basal{i})));
    Num_sing_REM_basal_post(i)=length(length(and(Single_REM_basal{i},epoch_PostInj_basal{i})));
    
    %%mean duration post
    mean_dur_total_REM_basal_post(i)=mean(End(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(stages_basal{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
    mean_dur_seq_REM_basal_post(i)=mean(End(and(Seq_REM_basal{i},epoch_PostInj_basal{i}))-Start(and(Seq_REM_basal{i},epoch_PostInj_basal{i})))/1E4;
    mean_dur_sing_REM_basal_post(i)=mean(End(and(Single_REM_basal{i},epoch_PostInj_basal{i}))-Start(and(Single_REM_basal{i},epoch_PostInj_basal{i})))/1E4;
    
 
    %%percentage
    Res_totalSleep_basal{i}=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(stages_basal{i}.Wake,stages_basal{i}.SWSEpoch,stages_basal{i}.REMEpoch,param);
    % Res(1,:) all recording
    % Res(2,:) pre injection
    % Res(3,:) post injection
    
    % Res(x,1) total rem
    % Res(x,2) sequential rem
    % Res(x,3) single rem
   
    %%percentage post
    percREM_total_basal_post(i) = Res_totalSleep_basal{i}(3,1);
    percREM_seq_basal_post(i) = Res_totalSleep_basal{i}(3,2);
    percREM_sing_basal_post(i) = Res_totalSleep_basal{i}(3,3);
    
end

%% get data CNO
for k=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{k}{1});
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
        epoch_PostInj_cno{k} = intervalSet(0.55*1E8,durtotal_cno{k});
        
        %%get single and sequential REM epoch
        [Seq_REM_cno{k},Single_REM_cno{k}] = Find_single_sequential_REM_MC(stages_cno{k}.Wake,stages_cno{k}.SWSEpoch,stages_cno{k}.REMEpoch,param);
    else
    end
    
    %%number post
    Num_total_REM_cno_post(k)=length(length(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k})));
    Num_seq_REM_cno_post(k)=length(length(and(Seq_REM_cno{k},epoch_PostInj_cno{k})));
    Num_sing_REM_cno_post(k)=length(length(and(Single_REM_cno{k},epoch_PostInj_cno{k})));

    %%mean duration post
    mean_dur_total_REM_cno_post(k)=mean(End(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k}))-Start(and(stages_cno{k}.REMEpoch,epoch_PostInj_cno{k})))/1E4;
    mean_dur_seq_REM_cno_post(k)=mean(End(and(Seq_REM_cno{k},epoch_PostInj_cno{k}))-Start(and(Seq_REM_cno{k},epoch_PostInj_cno{k})))/1E4;
    mean_dur_sing_REM_cno_post(k)=mean(End(and(Single_REM_cno{k},epoch_PostInj_cno{k}))-Start(and(Single_REM_cno{k},epoch_PostInj_cno{k})))/1E4;
    
    
    %%percentage
    Res_totalSleep_cno{k}=Compute_Seq_Single_REM_Percentages_SocialDefeat_MC(stages_cno{k}.Wake,stages_cno{k}.SWSEpoch,stages_cno{k}.REMEpoch,param);
    
    
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

figure
subplot(331)
MakeSpreadAndBoxPlot2_SB({...
    percREM_total_basal_post percREM_total_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('Total REM percentage (%)')
% title('/ total sleep')
makepretty
p_post=signrank(percREM_total_basal_post, percREM_total_cno_post);
% [h,p_post]=ttest2(percREM_total_basal_post, percREM_total_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(332)
MakeSpreadAndBoxPlot2_SB({...
    percREM_seq_basal_post percREM_seq_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('Sequential REM percentage (%)')
% title('/ total sleep')
makepretty
p_post=signrank(percREM_seq_basal_post, percREM_seq_cno_post);
% [h,p_post]=ttest2(percREM_seq_basal_post, percREM_seq_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)]) 

subplot(333)
MakeSpreadAndBoxPlot2_SB({...
    percREM_sing_basal_post percREM_sing_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('Single REM percentage (%)')
% title('/ total sleep')
makepretty
p_post=signrank(percREM_sing_basal_post, percREM_sing_cno_post);
% [h,p_post]=ttest2(percREM_sing_basal_post, percREM_sing_cno_post);
if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(334)
MakeSpreadAndBoxPlot2_SB({...
    Num_total_REM_basal_post Num_total_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('# total REM')
% title('/ total sleep')
makepretty
p_post=signrank(Num_total_REM_basal_post, Num_total_REM_cno_post);
% [h,p_post]=ttest2(Num_total_REM_basal_post, Num_total_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(335)
MakeSpreadAndBoxPlot2_SB({...
    Num_seq_REM_basal_post Num_seq_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('# sequential REM')
% title('/ total sleep')
makepretty
p_post=signrank(Num_seq_REM_basal_post, Num_seq_REM_cno_post);
% [h,p_post]=ttest2(Num_seq_REM_basal_post, Num_seq_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(336)
MakeSpreadAndBoxPlot2_SB({...
    Num_sing_REM_basal_post Num_sing_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('# single REM')
% title('/ total sleep')
makepretty
p_post=signrank(Num_sing_REM_basal_post, Num_sing_REM_cno_post);
% [h,p_post]=ttest2(Num_sing_REM_basal_post, Num_sing_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(337)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_total_REM_basal_post mean_dur_total_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('mean duration total REM (s)')
% title('/ total sleep')
makepretty
p_post=signrank(mean_dur_total_REM_basal_post, mean_dur_total_REM_cno_post);
% [h,p_post]=ttest2(mean_dur_total_REM_basal_post, mean_dur_total_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(338)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_seq_REM_basal_post mean_dur_seq_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('mean duration sequential REM (s)')
% title('/ total sleep')
makepretty
p_post=signrank(mean_dur_seq_REM_basal_post, mean_dur_seq_REM_cno_post);
% [h,p_post]=ttest2(mean_dur_seq_REM_basal_post, mean_dur_seq_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])

subplot(339)
MakeSpreadAndBoxPlot2_SB({...
    mean_dur_sing_REM_basal_post mean_dur_sing_REM_cno_post},...
    {col_post_basal,col_post_cno},[1:2],{},'paired',0,'optiontest','ranksum','showsigstar','none');
xticklabels({'baseline','social defeat'}), xtickangle(0)
ylabel('mean duration single REM (s)')
% title('/ total sleep')
makepretty
p_post=signrank(mean_dur_sing_REM_basal_post, mean_dur_sing_REM_cno_post);
% [h,p_post]=ttest2(mean_dur_sing_REM_basal_post, mean_dur_sing_REM_cno_post);

if p_post<0.05
    sigstar_DB({[1 2]},p_post,0,'LineWigth',16,'StarSize',24);
end
title(['p post=', num2str(p_post)])