%% input dir : exci dreadd CRH VLPO
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149]);
DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1105 1106 1149 1150]);
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1217 1218 1219 1220]);

%% input dir : inhibition PFC
% %saline PFC experiment
% DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
% % DirSaline_dreadd_PFC = RestrictPathForExperiment(DirSaline_dreadd_PFC, 'nMice', [1196 1197]);
% 
% %saline VLPO experiment
% DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO, 'nMice', [1105 1106 1148 1149 1150]);
% %merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
% %cno
% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = RestrictPathForExperiment(DirCNO, 'nMice', [1196 1197]);

%% input dir basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');

DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[]);

DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%% input dir ATROPINE
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

% DirCNO = PathForExperimentsAtropine_MC('Atropine');
% % DirBaseline_atropine = PathForExperimentsAtropine_MC('BaselineSleep');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;


%% baseline mice

%%
for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    if exist('SWR.mat')
        ripp_basal{k}=load('SWR.mat','ripples','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_basal{k}=load('Ripples.mat','ripples','RipplesEpoch');
    else
        ripp_basal{k}=[];
    end
    
    c{k}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    
     %%periods of time
            durtotal_basal{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_basal{k} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_basal{k} = intervalSet(st_epoch_postInj,durtotal_basal{k});
            
if isempty(ripp_basal{k})==0
    %restrict ripp epoch to each state
    %wake
ripp_wake_basal_pre{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.Wake,epoch_PreInj_basal{k}));
ripp_wake_basal_post{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.Wake,epoch_PostInj_basal{k}));
%sws
ripp_SWS_basal_pre{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.SWSEpoch,epoch_PreInj_basal{k}));
ripp_SWS_basal_post{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.SWSEpoch,epoch_PostInj_basal{k}));
%rem
ripp_REM_basal_pre{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.REMEpoch,epoch_PreInj_basal{k}));
ripp_REM_basal_post{k} = and(ripp_basal{k}.RipplesEpoch,and(c{k}.REMEpoch,epoch_PostInj_basal{k}));
    
%duration of ripples in each states
%wake
dur_ripp_wake_basal_pre{k} = End(ripp_wake_basal_pre{k},'ms')-Start(ripp_wake_basal_pre{k},'ms');
dur_ripp_wake_basal_post{k} = End(ripp_wake_basal_post{k},'ms')-Start(ripp_wake_basal_post{k},'ms');
%sws
dur_ripp_SWS_basal_pre{k} = End(ripp_SWS_basal_pre{k},'ms')-Start(ripp_SWS_basal_pre{k},'ms');
dur_ripp_SWS_basal_post{k} = End(ripp_SWS_basal_post{k},'ms')-Start(ripp_SWS_basal_post{k},'ms');
%rem
dur_ripp_REM_basal_pre{k} = End(ripp_REM_basal_pre{k},'ms')-Start(ripp_REM_basal_pre{k},'ms');
dur_ripp_REM_basal_post{k} = End(ripp_REM_basal_post{k},'ms')-Start(ripp_REM_basal_post{k},'ms');


peak2peak_basal{k} = ripp_basal{k}.ripples(:,6);
freq_ripp_basal{k} = ripp_basal{k}.ripples(:,5);


%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
    dur_ripp{k} = End(ripp_basal{k}.RipplesEpoch)/1E4-Start(ripp_basal{k}.RipplesEpoch)/1E4;
else
end
end
%mean
for ii=1:length(dur_ripp_wake_basal_pre)
    dur_ripp_wake_basal_pre_mean(ii,:)=nanmean(dur_ripp_wake_basal_pre{ii});
    dur_ripp_wake_basal_post_mean(ii,:)=nanmean(dur_ripp_wake_basal_post{ii});
    
        dur_ripp_SWS_basal_pre_mean(ii,:)=nanmean(dur_ripp_SWS_basal_pre{ii});
    dur_ripp_SWS_basal_post_mean(ii,:)=nanmean(dur_ripp_SWS_basal_post{ii});
    
        dur_ripp_REM_basal_pre_mean(ii,:)=nanmean(dur_ripp_REM_basal_pre{ii});
    dur_ripp_REM_basal_post_mean(ii,:)=nanmean(dur_ripp_REM_basal_post{ii});
    
        dur_ripp_basal_mean(ii,:)=nanmean(dur_ripp{ii});

        
        peak2peak_basal_mean(ii,:)=nanmean(peak2peak_basal{ii});
        freq_ripp_basal_mean(ii,:)=nanmean(freq_ripp_basal{ii});

end



%% saline mice
for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    if exist('SWR.mat')
        ripp_sal{i}=load('SWR.mat','ripples','RipplesEpoch');
    else
        ripp_sal{i}=load('Ripples.mat','ripples','RipplesEpoch');
    end
    
    a{i}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    
     %%periods of time
            durtotal_sal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_sal{i} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_sal{i} = intervalSet(st_epoch_postInj,durtotal_sal{i});
            

    %restrict ripp epoch to each state
    %wake
ripp_wake_sal_pre{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.Wake,epoch_PreInj_sal{i}));
ripp_wake_sal_post{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.Wake,epoch_PostInj_sal{i}));
%sws
ripp_SWS_sal_pre{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.SWSEpoch,epoch_PreInj_sal{i}));
ripp_SWS_sal_post{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.SWSEpoch,epoch_PostInj_sal{i}));
%rem
ripp_REM_sal_pre{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.REMEpoch,epoch_PreInj_sal{i}));
ripp_REM_sal_post{i} = and(ripp_sal{i}.RipplesEpoch,and(a{i}.REMEpoch,epoch_PostInj_sal{i}));


    
%duration of ripples in each states
%wake
dur_ripp_wake_sal_pre{i} = End(ripp_wake_sal_pre{i},'ms')-Start(ripp_wake_sal_pre{i},'ms');
dur_ripp_wake_sal_post{i} = End(ripp_wake_sal_post{i},'ms')-Start(ripp_wake_sal_post{i},'ms');
%sws
dur_ripp_SWS_sal_pre{i} = End(ripp_SWS_sal_pre{i},'ms')-Start(ripp_SWS_sal_pre{i},'ms');
dur_ripp_SWS_sal_post{i} = End(ripp_SWS_sal_post{i},'ms')-Start(ripp_SWS_sal_post{i},'ms');
%rem
dur_ripp_REM_sal_pre{i} = End(ripp_REM_sal_pre{i},'ms')-Start(ripp_REM_sal_pre{i},'ms');
dur_ripp_REM_sal_post{i} = End(ripp_REM_sal_post{i},'ms')-Start(ripp_REM_sal_post{i},'ms');

peak2peak_sal{i} = ripp_sal{i}.ripples(:,6);
freq_ripp_sal{i} = ripp_sal{i}.ripples(:,5);

%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
    dur_ripp{i} = End(ripp_sal{i}.RipplesEpoch)/1E4-Start(ripp_sal{i}.RipplesEpoch)/1E4;
end
%mean
for ii=1:length(dur_ripp_wake_sal_pre)
    dur_ripp_wake_sal_pre_mean(ii,:)=nanmean(dur_ripp_wake_sal_pre{ii});
    dur_ripp_wake_sal_post_mean(ii,:)=nanmean(dur_ripp_wake_sal_post{ii});
    
        dur_ripp_SWS_sal_pre_mean(ii,:)=nanmean(dur_ripp_SWS_sal_pre{ii});
    dur_ripp_SWS_sal_post_mean(ii,:)=nanmean(dur_ripp_SWS_sal_post{ii});
    
        dur_ripp_REM_sal_pre_mean(ii,:)=nanmean(dur_ripp_REM_sal_pre{ii});
    dur_ripp_REM_sal_post_mean(ii,:)=nanmean(dur_ripp_REM_sal_post{ii});
    
        dur_ripp_mean(ii,:)=nanmean(dur_ripp{ii});

        peak2peak_sal_mean(ii,:)=nanmean(peak2peak_sal{ii});
        freq_ripp_sal_mean(ii,:)=nanmean(freq_ripp_sal{ii});

end


%%


for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    if exist('SWR.mat')
        ripp_cno{j}=load('SWR.mat','ripples','RipplesEpoch');
    elseif exist('Ripples.mat')
        ripp_cno{j}=load('Ripples.mat','ripples','RipplesEpoch');
    else
        ripp_cno{j}=[];
    end
    
    b{j}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    durtotal_cno{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
    
         %%periods of time
            durtotal_cno{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_cno{j} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_cno{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
            
           if isempty(ripp_cno{j})==0
    %restrict ripp epoch to each state
    %wake
ripp_wake_cno_pre{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.Wake,epoch_PreInj_cno{j}));
ripp_wake_cno_post{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.Wake,epoch_PostInj_cno{j}));
%sws
ripp_SWS_cno_pre{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.SWSEpoch,epoch_PreInj_cno{j}));
ripp_SWS_cno_post{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.SWSEpoch,epoch_PostInj_cno{j}));
%rem
ripp_REM_cno_pre{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.REMEpoch,epoch_PreInj_cno{j}));
ripp_REM_cno_post{j} = and(ripp_cno{j}.RipplesEpoch,and(b{j}.REMEpoch,epoch_PostInj_cno{j}));
    
%duration of ripples in each states
%wake
dur_ripp_wake_cno_pre{j} = End(ripp_wake_cno_pre{j},'ms')-Start(ripp_wake_cno_pre{j},'ms');
dur_ripp_wake_cno_post{j} = End(ripp_wake_cno_post{j},'ms')-Start(ripp_wake_cno_post{j},'ms');
%sws
dur_ripp_SWS_cno_pre{j} = End(ripp_SWS_cno_pre{j},'ms')-Start(ripp_SWS_cno_pre{j},'ms');
dur_ripp_SWS_cno_post{j} = End(ripp_SWS_cno_post{j},'ms')-Start(ripp_SWS_cno_post{j},'ms');
%rem
dur_ripp_REM_cno_pre{j} = End(ripp_REM_cno_pre{j},'ms')-Start(ripp_REM_cno_pre{j},'ms');
dur_ripp_REM_cno_post{j} = End(ripp_REM_cno_post{j},'ms')-Start(ripp_REM_cno_post{j},'ms');

peak2peak_cno{j} = ripp_cno{j}.ripples(:,6);
freq_ripp_cno{j} = ripp_cno{j}.ripples(:,5);

%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
           else
           end
end



for ii=1:length(dur_ripp_wake_cno_pre)
    dur_ripp_wake_cno_pre_mean(ii,:)=nanmean(dur_ripp_wake_cno_pre{ii});
    dur_ripp_wake_cno_post_mean(ii,:)=nanmean(dur_ripp_wake_cno_post{ii});
    
        dur_ripp_SWS_cno_pre_mean(ii,:)=nanmean(dur_ripp_SWS_cno_pre{ii});
    dur_ripp_SWS_cno_post_mean(ii,:)=nanmean(dur_ripp_SWS_cno_post{ii});
    
        dur_ripp_REM_cno_pre_mean(ii,:)=nanmean(dur_ripp_REM_cno_pre{ii});
    dur_ripp_REM_cno_post_mean(ii,:)=nanmean(dur_ripp_REM_cno_post{ii});
                
    peak2peak_cno_mean(ii,:)=nanmean(peak2peak_cno{ii}(:,:));
    freq_ripp_cno_mean(ii,:)=nanmean(freq_ripp_cno{ii});

end




%%





data_wake = {dur_ripp_wake_sal_pre_mean, dur_ripp_wake_cno_pre_mean, dur_ripp_wake_sal_post_mean, dur_ripp_wake_cno_post_mean};
figure, subplot(131), MakeBoxPlot_DB(data_wake,{[0.3 0.3 0.3],[0 .2 .8],[0.3 0.3 0.3],[0 .2 .8]},[1 2 3 4], {'pre SAL','pre CNO','post SAL','post CNO'},1);

data_sws = {dur_ripp_SWS_sal_pre_mean, dur_ripp_SWS_cno_pre_mean, dur_ripp_SWS_sal_post_mean, dur_ripp_SWS_cno_post_mean};
subplot(132), MakeBoxPlot_DB(data_sws,{[0.3 0.3 0.3],[1 0 0],[0.3 0.3 0.3],[1 0 0]},[1 2 3 4], {'pre SAL','pre CNO','post SAL','post CNO'},1);

data_rem = {dur_ripp_REM_sal_pre_mean, dur_ripp_REM_cno_pre_mean, dur_ripp_REM_sal_post_mean, dur_ripp_REM_cno_post_mean};
subplot(133), MakeBoxPlot_DB(data_rem,{[0.3 0.3 0.3],[0 1 0],[0.3 0.3 0.3],[0 1 0]},[1 2 3 4], {'pre SAL','pre CNO','post SAL','post CNO'},1);



%%

col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

col_pre_saline = [1 0.6 0.6]; %%rose
col_post_saline = [1 0.6 0.6];
col_pre_cno = [1 0 0]; %rouge
col_post_cno = [1 0 0];

% col_pre_saline = [0.3 0.3 0.3]; %vert
% col_post_saline = [0.3 0.3 0.3];
% 
% col_pre_cno = [0.6 1 0.4]; %vert
% col_post_cno = [0.6 1 0.4];
% 
% col_pre_cno = [0.4 1 0.2]; %vert
% col_post_cno = [0.4 1 0.2];

figure
subplot(131)
MakeBoxPlot_MC({dur_ripp_wake_basal_pre_mean, dur_ripp_wake_sal_pre_mean, dur_ripp_wake_cno_pre_mean, dur_ripp_wake_basal_post_mean, dur_ripp_wake_sal_post_mean, dur_ripp_wake_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([22 42])
title('WAKE')
ylabel('Mean ripples duration (ms)')

subplot(132)
MakeBoxPlot_MC({dur_ripp_SWS_basal_pre_mean, dur_ripp_SWS_sal_pre_mean, dur_ripp_SWS_cno_pre_mean, dur_ripp_SWS_basal_post_mean, dur_ripp_SWS_sal_post_mean, dur_ripp_SWS_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([22 42])
title('NREM')
ylabel('Mean ripples duration (ms)')

subplot(133)
MakeBoxPlot_MC({dur_ripp_REM_basal_pre_mean, dur_ripp_REM_sal_pre_mean, dur_ripp_REM_cno_pre_mean, dur_ripp_REM_basal_post_mean, dur_ripp_REM_sal_post_mean, dur_ripp_REM_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylim([22 42])
title('REM')
ylabel('Mean ripples duration (ms)')

%%



%%

imouse=5;
% for imouse=1:length(DirSaline.path)
    figure
    %wake pre
subplot(321)
hist(dur_ripp_wake_sal_pre{imouse},100)
% xlim([0 0.14])
ylabel('# events')
title('WAKE PRE')
%wake post
subplot(322)
hist(dur_ripp_wake_sal_post{imouse},100)
% xlim([0 0.14])
title('WAKE POST')
%sws pre
subplot(323)
hist(dur_ripp_SWS_sal_pre{imouse},100)
% xlim([0 0.14])
ylabel('# events')
title('NREM PRE')
%sws post
subplot(324)
hist(dur_ripp_SWS_sal_post{imouse},100)
% xlim([0 0.14])
title('NREM POST')
%rem pre
subplot(325)
hist(dur_ripp_REM_sal_pre{imouse},100)
% xlim([0 0.14])
title('REM PRE')
ylabel('# events')
xlabel('Duration (s)')
%rem post
subplot(326)
hist(dur_ripp_REM_sal_post{imouse},100)
% xlim([0 0.14])
xlabel('Duration (s)')
title('REM POST')
% end


%%

imouse=3;
% for imouse=1:length(DirCNO.path)
        
        figure
    %wake pre
subplot(321)
hist(dur_ripp_wake_cno_pre{imouse},100)
% xlim([0 0.14])
ylabel('# events')
title('WAKE PRE')
%wake post
subplot(322)
hist(dur_ripp_wake_cno_post{imouse},100)
% xlim([0 0.14])
title('WAKE POST')
%sws pre
subplot(323)
hist(dur_ripp_SWS_cno_pre{imouse},100)
% xlim([0 0.14])
ylabel('# events')
title('NREM PRE')
%sws post
subplot(324)
hist(dur_ripp_SWS_cno_post{imouse},100)
% xlim([0 0.14])
title('NREM POST')
%rem pre
subplot(325)
hist(dur_ripp_REM_cno_pre{imouse},100)
% xlim([0 0.14])
title('REM PRE')
ylabel('# events')
xlabel('Duration (s)')
%rem post
subplot(326)
hist(dur_ripp_REM_cno_post{imouse},100)
% xlim([0 0.14])
xlabel('Duration (s)')
title('REM POST')

% end

%%
% 

figure
MakeBoxPlot_MC({freq_ripp_basal_mean freq_ripp_sal_mean freq_ripp_cno_mean},...
{col_pre_basal col_pre_saline col_pre_cno },[1:3],{},1,0);

figure
MakeBoxPlot_MC({peak2peak_basal_mean peak2peak_sal_mean peak2peak_cno_mean},...
{col_pre_basal col_pre_saline col_pre_cno },[1:3],{},1,0);


%%
% 
% dur_ripp_cum_wake_cno_pre = [dur_ripp_wake_cno_pre{1};dur_ripp_wake_cno_pre{2};dur_ripp_wake_cno_pre{3}];
% dur_ripp_cum_wake_cno_post = [dur_ripp_wake_cno_post{1};dur_ripp_wake_cno_post{2};dur_ripp_wake_cno_post{3}];
% 
% dur_ripp_cum_SWS_cno_pre = [dur_ripp_SWS_cno_pre{1};dur_ripp_SWS_cno_pre{2};dur_ripp_SWS_cno_pre{3}];
% dur_ripp_cum_SWS_cno_post = [dur_ripp_SWS_cno_post{1};dur_ripp_SWS_cno_post{2};dur_ripp_SWS_cno_post{3}];
% 
% dur_ripp_cum_REM_cno_pre = [dur_ripp_REM_cno_pre{1};dur_ripp_REM_cno_pre{2};dur_ripp_REM_cno_pre{3}];
% dur_ripp_cum_REM_cno_post = [dur_ripp_REM_cno_post{1};dur_ripp_REM_cno_post{2};dur_ripp_REM_cno_post{3}];
% 
% 
% 
% figure,
% subplot(321),hist(dur_ripp_cum_wake_cno_pre,150)
% 
% subplot(322),hist(dur_ripp_cum_wake_cno_post,150)
% 
% subplot(323),hist(dur_ripp_cum_SWS_cno_pre,150)
% 
% subplot(324),hist(dur_ripp_cum_SWS_cno_post,150)
% 
% subplot(325),hist(dur_ripp_cum_REM_cno_pre,150)
% 
% subplot(326),hist(dur_ripp_cum_REM_cno_post,150)