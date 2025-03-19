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

%% input dir : exci dreadd CRH VLPO
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirSaline = RestrictPathForExperiment(DirSaline, 'nMice', [1105 1106 1149]);
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

%% input dir ATROPINE
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);

DirCNO = PathForExperimentsAtropine_MC('Atropine');


%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%%


for k=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{k}{1});
    if exist('DeltaWaves.mat')
        delt{k}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
%         delt{i}=[];
    end
    
    c{k}=load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch');
    
     %%periods of time
            durtotal_basal{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_basal{k} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_basal{k} = intervalSet(st_epoch_postInj,durtotal_basal{k});
            

    %restrict ripp epoch to each state
    %wake
delt_wake_basal_pre{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.Wake,epoch_PreInj_basal{k}));
delt_wake_basal_post{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.Wake,epoch_PostInj_basal{k}));
%sws
delt_SWS_basal_pre{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.SWSEpoch,epoch_PreInj_basal{k}));
delt_SWS_basal_post{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.SWSEpoch,epoch_PostInj_basal{k}));
%rem
delt_REM_basal_pre{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.REMEpoch,epoch_PreInj_basal{k}));
delt_REM_basal_post{k} = and(delt{k}.alldeltas_PFCx,and(c{k}.REMEpoch,epoch_PostInj_basal{k}));
    
%duration of ripples in each states
%wake
dur_delt_wake_basal_pre{k} = End(delt_wake_basal_pre{k},'ms')-Start(delt_wake_basal_pre{k},'ms');
dur_delt_wake_basal_post{k} = End(delt_wake_basal_post{k},'ms')-Start(delt_wake_basal_post{k},'ms');
%sws
dur_delt_SWS_basal_pre{k} = End(delt_SWS_basal_pre{k},'ms')-Start(delt_SWS_basal_pre{k},'ms');
dur_delt_SWS_basal_post{k} = End(delt_SWS_basal_post{k},'ms')-Start(delt_SWS_basal_post{k},'ms');
%rem
dur_delt_REM_basal_pre{k} = End(delt_REM_basal_pre{k},'ms')-Start(delt_REM_basal_pre{k},'ms');
dur_delt_REM_basal_post{k} = End(delt_REM_basal_post{k},'ms')-Start(delt_REM_basal_post{k},'ms');

%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
    dur_delt_basal{k} = End(delt{k}.alldeltas_PFCx)/1E4-Start(delt{k}.alldeltas_PFCx)/1E4;
end
%mean
for ii=1:length(dur_delt_wake_basal_pre)
    dur_delt_wake_basal_pre_mean(ii,:)=nanmean(dur_delt_wake_basal_pre{ii});
    dur_delt_wake_basal_post_mean(ii,:)=nanmean(dur_delt_wake_basal_post{ii});
    
        dur_delt_SWS_basal_pre_mean(ii,:)=nanmean(dur_delt_SWS_basal_pre{ii});
    dur_delt_SWS_basal_post_mean(ii,:)=nanmean(dur_delt_SWS_basal_post{ii});
    
        dur_delt_REM_basal_pre_mean(ii,:)=nanmean(dur_delt_REM_basal_pre{ii});
    dur_delt_REM_basal_post_mean(ii,:)=nanmean(dur_delt_REM_basal_post{ii});
    
        dur_delt_basal_mean(ii,:)=nanmean(dur_delt_basal{ii});

end

%%

for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    if exist('DeltaWaves.mat')
        delt_sal{i}=load('DeltaWaves.mat','alldeltas_PFCx');
    else
%         delt{i}=[];
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
delt_wake_sal_pre{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.Wake,epoch_PreInj_sal{i}));
delt_wake_sal_post{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.Wake,epoch_PostInj_sal{i}));
%sws
delt_SWS_sal_pre{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.SWSEpoch,epoch_PreInj_sal{i}));
delt_SWS_sal_post{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.SWSEpoch,epoch_PostInj_sal{i}));
%rem
delt_REM_sal_pre{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.REMEpoch,epoch_PreInj_sal{i}));
delt_REM_sal_post{i} = and(delt_sal{i}.alldeltas_PFCx,and(a{i}.REMEpoch,epoch_PostInj_sal{i}));
    
%duration of ripples in each states
%wake
dur_delt_wake_sal_pre{i} = End(delt_wake_sal_pre{i},'ms')-Start(delt_wake_sal_pre{i},'ms');
dur_delt_wake_sal_post{i} = End(delt_wake_sal_post{i},'ms')-Start(delt_wake_sal_post{i},'ms');
%sws
dur_delt_SWS_sal_pre{i} = End(delt_SWS_sal_pre{i},'ms')-Start(delt_SWS_sal_pre{i},'ms');
dur_delt_SWS_sal_post{i} = End(delt_SWS_sal_post{i},'ms')-Start(delt_SWS_sal_post{i},'ms');
%rem
dur_delt_REM_sal_pre{i} = End(delt_REM_sal_pre{i},'ms')-Start(delt_REM_sal_pre{i},'ms');
dur_delt_REM_sal_post{i} = End(delt_REM_sal_post{i},'ms')-Start(delt_REM_sal_post{i},'ms');

%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
    dur_delt_sal{i} = End(delt_sal{i}.alldeltas_PFCx)/1E4-Start(delt_sal{i}.alldeltas_PFCx)/1E4;
end
%mean
for ii=1:length(dur_delt_wake_sal_pre)
    dur_delt_wake_sal_pre_mean(ii,:)=nanmean(dur_delt_wake_sal_pre{ii});
    dur_delt_wake_sal_post_mean(ii,:)=nanmean(dur_delt_wake_sal_post{ii});
    
        dur_delt_SWS_sal_pre_mean(ii,:)=nanmean(dur_delt_SWS_sal_pre{ii});
    dur_delt_SWS_sal_post_mean(ii,:)=nanmean(dur_delt_SWS_sal_post{ii});
    
        dur_delt_REM_sal_pre_mean(ii,:)=nanmean(dur_delt_REM_sal_pre{ii});
    dur_delt_REM_sal_post_mean(ii,:)=nanmean(dur_delt_REM_sal_post{ii});
    
        dur_delt_sal_mean(ii,:)=nanmean(dur_delt_sal{ii});

end


%%


for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    if exist('DeltaWaves.mat')
        deltCNO{j}=load('DeltaWaves.mat','alldeltas_PFCx');

    else
%         deltCNO{j}=[];
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
            
           if isempty(deltCNO{j})==0

    
%duration of ripples in each states
    %restrict ripp epoch to each state
    %wake
delt_wake_cno_pre{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.Wake,epoch_PreInj_cno{j}));
delt_wake_cno_post{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.Wake,epoch_PostInj_cno{j}));
%sws
delt_SWS_cno_pre{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.SWSEpoch,epoch_PreInj_cno{j}));
delt_SWS_cno_post{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.SWSEpoch,epoch_PostInj_cno{j}));
%rem
delt_REM_cno_pre{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.REMEpoch,epoch_PreInj_cno{j}));
delt_REM_cno_post{j} = and(deltCNO{j}.alldeltas_PFCx,and(b{j}.REMEpoch,epoch_PostInj_cno{j}));

%%%%%%
dur_delt_wake_cno_pre{j} = End(delt_wake_cno_pre{j},'ms')-Start(delt_wake_cno_pre{j},'ms');
dur_delt_wake_cno_post{j} = End(delt_wake_cno_post{j},'ms')-Start(delt_wake_cno_post{j},'ms');
%sws
dur_delt_SWS_cno_pre{j} = End(delt_SWS_cno_pre{j},'ms')-Start(delt_SWS_cno_pre{j},'ms');
dur_delt_SWS_cno_post{j} = End(delt_SWS_cno_post{j},'ms')-Start(delt_SWS_cno_post{j},'ms');
%rem
dur_delt_REM_cno_pre{j} = End(delt_REM_cno_pre{j},'ms')-Start(delt_REM_cno_pre{j},'ms');
dur_delt_REM_cno_post{j} = End(delt_REM_cno_post{j},'ms')-Start(delt_REM_cno_post{j},'ms');


%     st_ripp{i} = Restrict(ripp{1,i}.ripples(:,1),stage{i}.Wake);
%     en_ripp{i} = ripp{1,i}.ripples(:,3);
%     dur_ripp{i} = en_ripp{i}-st_ripp{i};
           else
           end
end



for ii=1:length(dur_delt_wake_cno_pre)
    dur_delt_wake_cno_pre_mean(ii,:)=nanmean(dur_delt_wake_cno_pre{ii});
    dur_delt_wake_cno_post_mean(ii,:)=nanmean(dur_delt_wake_cno_post{ii});
    
        dur_delt_SWS_cno_pre_mean(ii,:)=nanmean(dur_delt_SWS_cno_pre{ii});
    dur_delt_SWS_cno_post_mean(ii,:)=nanmean(dur_delt_SWS_cno_post{ii});
    
        dur_delt_REM_cno_pre_mean(ii,:)=nanmean(dur_delt_REM_cno_pre{ii});
    dur_delt_REM_cno_post_mean(ii,:)=nanmean(dur_delt_REM_cno_post{ii});
end



%%

col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];

% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];

col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];

figure
subplot(131)
MakeBoxPlot_MC({dur_delt_wake_basal_pre_mean, dur_delt_wake_sal_pre_mean, dur_delt_wake_cno_pre_mean, dur_delt_wake_basal_post_mean, dur_delt_wake_sal_post_mean, dur_delt_wake_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
% ylim([0 0.15])
title('WAKE')

subplot(132)
MakeBoxPlot_MC({dur_delt_SWS_basal_pre_mean, dur_delt_SWS_sal_pre_mean, dur_delt_SWS_cno_pre_mean, dur_delt_SWS_basal_post_mean, dur_delt_SWS_sal_post_mean, dur_delt_SWS_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
% ylim([0 0.15])
title('NREM')

subplot(133)
MakeBoxPlot_MC({dur_delt_REM_basal_pre_mean, dur_delt_REM_sal_pre_mean, dur_delt_REM_cno_pre_mean, dur_delt_REM_basal_post_mean, dur_delt_REM_sal_post_mean, dur_delt_REM_cno_post_mean},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
% ylim([0 0.15])
title('REM')

%%



%%
% 
% for imouse=1:length(DirSaline.path)
%     figure
%     %wake pre
% subplot(321)
% hist(dur_delt_wake_sal_pre{imouse},200)
% xlim([0 0.14])
% ylabel('# events')
% title('WAKE PRE')
% %wake post
% subplot(322)
% hist(dur_delt_wake_sal_post{imouse},200)
% xlim([0 0.14])
% title('WAKE POST')
% %sws pre
% subplot(323)
% hist(dur_delt_SWS_sal_pre{imouse},200)
% xlim([0 0.14])
% ylabel('# events')
% title('NREM PRE')
% %sws post
% subplot(324)
% hist(dur_delt_SWS_sal_post{imouse},200)
% xlim([0 0.14])
% title('NREM POST')
% %rem pre
% subplot(325)
% hist(dur_delt_REM_sal_pre{imouse},200)
% xlim([0 0.14])
% title('REM PRE')
% ylabel('# events')
% xlabel('Duration (s)')
% %rem post
% subplot(326)
% hist(dur_delt_REM_sal_post{imouse},200)
% xlim([0 0.14])
% xlabel('Duration (s)')
% title('REM POST')
% end


%%
% 
% 
% for imouse=1:length(DirCNO.path)
%     figure
%     %wake pre
% subplot(321)
% hist(dur_delt_wake_cno_pre{imouse},200)
% xlim([0 0.14])
% ylabel('# events')
% title('WAKE PRE')
% %wake post
% subplot(322)
% hist(dur_delt_wake_cno_post{imouse},200)
% xlim([0 0.14])
% title('WAKE POST')
% %sws pre
% subplot(323)
% hist(dur_delt_SWS_cno_pre{imouse},200)
% xlim([0 0.14])
% ylabel('# events')
% title('NREM PRE')
% %sws post
% subplot(324)
% hist(dur_delt_SWS_cno_post{imouse},200)
% xlim([0 0.14])
% title('NREM POST')
% %rem pre
% subplot(325)
% hist(dur_delt_REM_cno_pre{imouse},200)
% xlim([0 0.14])
% title('REM PRE')
% ylabel('# events')
% xlabel('Duration (s)')
% %rem post
% subplot(326)
% hist(dur_delt_REM_cno_post{imouse},200)
% xlim([0 0.14])
% xlabel('Duration (s)')
% title('REM POST')
% end
% 
