%% input dir : exi DREADD VLPO CRH-neurons
% DirSaline = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');

%% input dir : CONTROL exi DREADD VLPO CRH-neurons (control mice = no dreadd)
% DirSaline = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_Nacl');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CtrlMouse_CNO');

%% input dir : inhi DREADD in PFC
%baseline sleep
DirBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
%cno
DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.6*1E8;

%% get data BASELINE sleep
percWAKE_basal_pre=[];
percSWS_basal_pre=[];
percREM_basal_pre=[];
percWAKE_basal_post=[];
percSWS_basal_post=[];
percREM_basal_post=[];
percWAKE_basal_3hPostInj=[];
percSWS_basal_3hPostInj=[];
percREM_basal_3hPostInj=[];

for i=1:length(DirBasal.path)
    cd(DirBasal.path{i}{1});
    if exist('SleepScoring_Accelero.mat')
        b{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        
        if isempty(b{i})==0
            %%periods of time
            durtotal_basal{i} = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
            %pre injection
            epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
            %     epoch_PreInj_basal{i} = intervalSet(0, durtotal_basal{i}/2);
            %post injection
            epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal_basal{i});
            %     epoch_PostInj_basal{i} = intervalSet(durtotal_basal{i}/2,durtotal_basal{i});
            %3h post injection
            epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
            
            %%percentage
            Restemp_basal=ComputeSleepStagesPercentagesMC(b{i}.Wake,b{i}.SWSEpoch,b{i}.REMEpoch);
            %percentage pre injection
            percWAKE_basal_pre=[percWAKE_basal_pre;Restemp_basal(1,2)];
            percSWS_basal_pre=[percSWS_basal_pre;Restemp_basal(2,2)];
            percREM_basal_pre=[percREM_basal_pre;Restemp_basal(3,2)];
            %percentage post injection
            percWAKE_basal_post=[percWAKE_basal_post;Restemp_basal(1,3)];
            percSWS_basal_post=[percSWS_basal_post;Restemp_basal(2,3)];
            percREM_basal_post=[percREM_basal_post;Restemp_basal(3,3)];
            %percentage 3h post injection
            percWAKE_basal_3hPostInj=[percWAKE_basal_3hPostInj;Restemp_basal(1,4)];
            percSWS_basal_3hPostInj=[percSWS_basal_3hPostInj;Restemp_basal(2,4)];
            percREM_basal_3hPostInj=[percREM_basal_3hPostInj;Restemp_basal(3,4)];
            
            %number of bouts pre injection
            NumSWS_basal_pre(i)=length(length(and(b{i}.SWSEpoch,epoch_PreInj_basal{i})));
            NumWAKE_basal_pre(i)=length(length(and(b{i}.Wake,epoch_PreInj_basal{i})));
            NumREM_basal_pre(i)=length(length(and(b{i}.REMEpoch,epoch_PreInj_basal{i})));
            %number of bouts post injection
            NumSWS_basal_post(i)=length(length(and(b{i}.SWSEpoch,epoch_PostInj_basal{i})));
            NumWAKE_basal_post(i)=length(length(and(b{i}.Wake,epoch_PostInj_basal{i})));
            NumREM_basal_post(i)=length(length(and(b{i}.REMEpoch,epoch_PostInj_basal{i})));
            %number of bouts 3h post injection
            NumSWS_basal_3hPostInj(i)=length(length(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i})));
            NumWAKE_basal_3hPostInj(i)=length(length(and(b{i}.Wake,epoch_3hPostInj_basal{i})));
            NumREM_basal_3hPostInj(i)=length(length(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i})));
            
            %duration of bouts pre injection
            durWAKE_basal_pre(i)=mean(End(and(b{i}.Wake,epoch_PreInj_basal{i}))-Start(and(b{i}.Wake,epoch_PreInj_basal{i})))/1E4;
            durSWS_basal_pre(i)=mean(End(and(b{i}.SWSEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PreInj_basal{i})))/1E4;
            durREM_basal_pre(i)=mean(End(and(b{i}.REMEpoch,epoch_PreInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PreInj_basal{i})))/1E4;
            %duration of bouts post injection
            durWAKE_basal_post(i)=mean(End(and(b{i}.Wake,epoch_PostInj_basal{i}))-Start(and(b{i}.Wake,epoch_PostInj_basal{i})))/1E4;
            durSWS_basal_post(i)=mean(End(and(b{i}.SWSEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_PostInj_basal{i})))/1E4;
            durREM_basal_post(i)=mean(End(and(b{i}.REMEpoch,epoch_PostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_PostInj_basal{i})))/1E4;
            %duration of bouts 3h post injection
            durWAKE_sal_3hPostInj(i)=mean(End(and(b{i}.Wake,epoch_3hPostInj_basal{i}))-Start(and(b{i}.Wake,epoch_3hPostInj_basal{i})))/1E4;
            durSWS_sal_3hPostInj(i)=mean(End(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.SWSEpoch,epoch_3hPostInj_basal{i})))/1E4;
            durREM_sal_3hPostInj(i)=mean(End(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i}))-Start(and(b{i}.REMEpoch,epoch_3hPostInj_basal{i})))/1E4;
        else
        end
    else
    end
end


%% get data SALINE sleep
percWAKE_sal_pre=[];
percSWS_sal_pre=[];
percREM_sal_pre=[];
percWAKE_sal_post=[];
percSWS_sal_post=[];
percREM_sal_post=[];
percWAKE_sal_3hPostInj=[];
percSWS_sal_3hPostInj=[];
percREM_sal_3hPostInj=[];

for i=1:length(DirSaline.path)
    cd(DirSaline.path{i}{1});
    b{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    
    %%separate day in different periods
    durtotal{i} = max([max(End(b{i}.Wake)),max(End(b{i}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_sal{i} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_sal{i} = intervalSet(0, durtotal{i}/2);
    %post injection
    epoch_PostInj_sal{i} = intervalSet(st_epoch_postInj,durtotal{i});
    %     epoch_PostInj_sal{i} = intervalSet(durtotal{i}/2,durtotal{i});
    %3h post injection
    epoch_3hPostInj{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    Restemp_sal=ComputeSleepStagesPercentagesMC(b{i}.Wake,b{i}.SWSEpoch,b{i}.REMEpoch); %get states percentage
    %percentage pre injection
    percWAKE_sal_pre=[percWAKE_sal_pre;Restemp_sal(1,2)];
    percSWS_sal_pre=[percSWS_sal_pre;Restemp_sal(2,2)];
    percREM_sal_pre=[percREM_sal_pre;Restemp_sal(3,2)];
    %percentage post injection
    percWAKE_sal_post=[percWAKE_sal_post;Restemp_sal(1,3)];
    percSWS_sal_post=[percSWS_sal_post;Restemp_sal(2,3)];
    percREM_sal_post=[percREM_sal_post;Restemp_sal(3,3)];
    %percentage 3h post injection
    percWAKE_sal_3hPostInj=[percWAKE_sal_3hPostInj;Restemp_sal(1,4)];
    percSWS_sal_3hPostInj=[percSWS_sal_3hPostInj;Restemp_sal(2,4)];
    percREM_sal_3hPostInj=[percREM_sal_3hPostInj;Restemp_sal(3,4)];
    
    %number of bouts pre injection
    NumSWS_sal_pre(i)=length(length(and(b{i}.SWSEpoch,epoch_PreInj_sal{i})));
    NumWAKE_sal_pre(i)=length(length(and(b{i}.Wake,epoch_PreInj_sal{i})));
    NumREM_sal_pre(i)=length(length(and(b{i}.REMEpoch,epoch_PreInj_sal{i})));
    %number of bouts post injection
    NumSWS_sal_post(i)=length(length(and(b{i}.SWSEpoch,epoch_PostInj_sal{i})));
    NumWAKE_sal_post(i)=length(length(and(b{i}.Wake,epoch_PostInj_sal{i})));
    NumREM_sal_post(i)=length(length(and(b{i}.REMEpoch,epoch_PostInj_sal{i})));
    %nuumber of bouts 3h post injection
    NumSWS_sal_3hPostInj(i)=length(length(and(b{i}.SWSEpoch,epoch_3hPostInj{i})));
    NumWAKE_sal_3hPostInj(i)=length(length(and(b{i}.Wake,epoch_3hPostInj{i})));
    NumREM_sal_3hPostInj(i)=length(length(and(b{i}.REMEpoch,epoch_3hPostInj{i})));
    
    %duration of bouts pre injection
    durWAKE_sal_pre(i)=mean(End(and(b{i}.Wake,epoch_PreInj_sal{i}))-Start(and(b{i}.Wake,epoch_PreInj_sal{i})))/1E4;
    durSWS_sal_pre(i)=mean(End(and(b{i}.SWSEpoch,epoch_PreInj_sal{i}))-Start(and(b{i}.SWSEpoch,epoch_PreInj_sal{i})))/1E4;
    durREM_sal_pre(i)=mean(End(and(b{i}.REMEpoch,epoch_PreInj_sal{i}))-Start(and(b{i}.REMEpoch,epoch_PreInj_sal{i})))/1E4;
    %duration of bouts post injection
    durWAKE_sal_post(i)=mean(End(and(b{i}.Wake,epoch_PostInj_sal{i}))-Start(and(b{i}.Wake,epoch_PostInj_sal{i})))/1E4;
    durSWS_sal_post(i)=mean(End(and(b{i}.SWSEpoch,epoch_PostInj_sal{i}))-Start(and(b{i}.SWSEpoch,epoch_PostInj_sal{i})))/1E4;
    durREM_sal_post(i)=mean(End(and(b{i}.REMEpoch,epoch_PostInj_sal{i}))-Start(and(b{i}.REMEpoch,epoch_PostInj_sal{i})))/1E4;
    %diration of bouts 3h post injection
    durWAKE_sal_3hPostInj(i)=mean(End(and(b{i}.Wake,epoch_3hPostInj{i}))-Start(and(b{i}.Wake,epoch_3hPostInj{i})))/1E4;
    durSWS_sal_3hPostInj(i)=mean(End(and(b{i}.SWSEpoch,epoch_3hPostInj{i}))-Start(and(b{i}.SWSEpoch,epoch_3hPostInj{i})))/1E4;
    durREM_sal_3hPostInj(i)=mean(End(and(b{i}.REMEpoch,epoch_3hPostInj{i}))-Start(and(b{i}.REMEpoch,epoch_3hPostInj{i})))/1E4;
end


%% CNO
percWAKE_CNO_pre=[];
percSWS_CNO_pre=[];
percREM_CNO_pre=[];
percWAKE_CNO_post=[];
percSWS_CNO_post=[];
percREM_CNO_post=[];
percWAKE_CNO_3hPostInj=[];
percSWS_CNO_3hPostInj=[];
percREM_CNO_3hPostInj=[];

for j=1:length(DirCNO.path)
    cd(DirCNO.path{j}{1});
    c{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');

    %%separate day in different periods
    durtotal_cno{j} = max([max(End(c{j}.Wake)),max(End(c{j}.SWSEpoch))]);
    %pre injection
    epoch_PreInj_cno{j} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_cno{j} = intervalSet(0, durtotal_cno{j}/2);
    %post injection
    epoch_PostInj_cno{j} = intervalSet(st_epoch_postInj,durtotal_cno{j});
    %     epoch_PostInj_cno{j} = intervalSet(durtotal_cno{j}/2,durtotal_cno{j});
    %3h post injection
    epoch_3hPostInj_cno{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4);
   
    Restemp_cno=ComputeSleepStagesPercentagesMC(c{j}.Wake,c{j}.SWSEpoch,c{j}.REMEpoch);
    %percentage pre injection
    percWAKE_CNO_pre = [percWAKE_CNO_pre;Restemp_cno(1,2)];
    percSWS_CNO_pre = [percSWS_CNO_pre;Restemp_cno(2,2)];
    percREM_CNO_pre = [percREM_CNO_pre;Restemp_cno(3,2)];
    %percentage post injection
    percWAKE_CNO_post = [percWAKE_CNO_post;Restemp_cno(1,3)];
    percSWS_CNO_post = [percSWS_CNO_post;Restemp_cno(2,3)];
    percREM_CNO_post = [percREM_CNO_post;Restemp_cno(3,3)];
    %percentage 3h post injection
    percWAKE_CNO_3hPostInj = [percWAKE_CNO_3hPostInj;Restemp_cno(1,4)];
    percSWS_CNO_3hPostInj = [percSWS_CNO_3hPostInj;Restemp_cno(2,4)];
    percREM_CNO_3hPostInj = [percREM_CNO_3hPostInj;Restemp_cno(3,4)];
    
    %number of bouts pre injection
    NumSWS_CNO_pre(j) = length(length(and(c{j}.SWSEpoch,epoch_PreInj_cno{j})));
    NumWAKE_CNO_pre(j) = length(length(and(c{j}.Wake,epoch_PreInj_cno{j})));
    NumREM_CNO_pre(j) = length(length(and(c{j}.REMEpoch,epoch_PreInj_cno{j})));
    %number of bouts post injection
    NumSWS_CNO_post(j) = length(length(and(c{j}.SWSEpoch,epoch_PostInj_cno{j})));
    NumWAKE_CNO_post(j) = length(length(and(c{j}.Wake,epoch_PostInj_cno{j})));
    NumREM_CNO_post(j) = length(length(and(c{j}.REMEpoch,epoch_PostInj_cno{j})));
    %number of bouts 3h post injection
    NumSWS_CNO_3hPostInj(j) = length(length(and(c{j}.SWSEpoch,epoch_3hPostInj_cno{j})));
    NumWAKE_CNO_3hPostInj(j) = length(length(and(c{j}.Wake,epoch_3hPostInj_cno{j})));
    NumREM_CNO_3hPostInj(j) = length(length(and(c{j}.REMEpoch,epoch_3hPostInj_cno{j})));
    
    %duration of bouts pre injection
    durWAKE_CNO_pre(j) = mean(End(and(c{j}.Wake,epoch_PreInj_cno{j}))-Start(and(c{j}.Wake,epoch_PreInj_cno{j})))/1E4;
    durSWS_CNO_pre(j) = mean(End(and(c{j}.SWSEpoch,epoch_PreInj_cno{j}))-Start(and(c{j}.SWSEpoch,epoch_PreInj_cno{j})))/1E4;
    durREM_CNO_pre(j) = mean(End(and(c{j}.REMEpoch,epoch_PreInj_cno{j}))-Start(and(c{j}.REMEpoch,epoch_PreInj_cno{j})))/1E4;
    %duration of bouts post injection
    durWAKE_CNO_post(j) = mean(End(and(c{j}.Wake,epoch_PostInj_cno{j}))-Start(and(c{j}.Wake,epoch_PostInj_cno{j})))/1E4;
    durSWS_CNO_post(j) = mean(End(and(c{j}.SWSEpoch,epoch_PostInj_cno{j}))-Start(and(c{j}.SWSEpoch,epoch_PostInj_cno{j})))/1E4;
    durREM_CNO_post(j) = mean(End(and(c{j}.REMEpoch,epoch_PostInj_cno{j}))-Start(and(c{j}.REMEpoch,epoch_PostInj_cno{j})))/1E4;
    %duration of bouts 3h post injection
    durWAKE_CNO_3hPostInj(j) = mean(End(and(c{j}.Wake,epoch_3hPostInj_cno{j}))-Start(and(c{j}.Wake,epoch_3hPostInj_cno{j})))/1E4;
    durSWS_CNO_3hPostInj(j) = mean(End(and(c{j}.SWSEpoch,epoch_3hPostInj_cno{j}))-Start(and(c{j}.SWSEpoch,epoch_3hPostInj_cno{j})))/1E4;
    durREM_CNO_3hPostInj(j) = mean(End(and(c{j}.REMEpoch,epoch_3hPostInj_cno{j}))-Start(and(c{j}.REMEpoch,epoch_3hPostInj_cno{j})))/1E4;
end

%% figures
%% pourcentage
figure,
ax(1)=subplot(231),PlotErrorBarN_KJ({percWAKE_sal_pre(:,1),percWAKE_CNO_pre(:,1), percWAKE_sal_post(:,1),percWAKE_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Percentage of wakefulness')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({percSWS_sal_pre(:,1),percSWS_CNO_pre(:,1), percSWS_sal_post(:,1),percSWS_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Percentage of NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({percREM_sal_pre(:,1),percREM_CNO_pre(:,1), percREM_sal_post(:,1),percREM_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Percentage of REM')
makepretty

% 3h post CNO
ax(4)=subplot(234),PlotErrorBarN_KJ({percWAKE_sal_pre(:,1),percWAKE_CNO_pre(:,1),percWAKE_sal_3hPostInj(:,1), percWAKE_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Percentage of wakefulness')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({percSWS_sal_pre(:,1),percSWS_CNO_pre(:,1),percSWS_sal_3hPostInj(:,1),percSWS_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Percentage of NREM')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({percREM_sal_pre(:,1),percREM_CNO_pre(:,1), percREM_sal_3hPostInj(:,1),percREM_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Percentage of REM')
makepretty

set(ax,'ylim',[0 100]);




%% number
figure,
ax(1)=subplot(231),PlotErrorBarN_KJ({NumWAKE_sal_pre,NumWAKE_CNO_pre, NumWAKE_sal_post,NumWAKE_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Number of bouts')
title('WAKE')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({NumSWS_sal_pre,NumSWS_CNO_pre, NumSWS_sal_post,NumSWS_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Number of bouts')
title('NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({NumREM_sal_pre,NumREM_CNO_pre, NumREM_sal_post,NumREM_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Number of bouts')
title('REM')
makepretty

% 3h post CNO
ax(4)=subplot(234),PlotErrorBarN_KJ({NumWAKE_sal_pre,NumWAKE_CNO_pre,NumWAKE_sal_3hPostInj, NumWAKE_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Number of bouts')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({NumSWS_sal_pre,NumSWS_CNO_pre,NumSWS_sal_3hPostInj,NumSWS_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Number of bouts')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({NumREM_sal_pre,NumREM_CNO_pre, NumREM_sal_3hPostInj,NumREM_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Number of bouts')
makepretty

set(ax,'ylim',[0 160]);



%% duration
figure,
ax(1)=subplot(231),PlotErrorBarN_KJ({durWAKE_sal_pre,durWAKE_CNO_pre, durWAKE_sal_post,durWAKE_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
title('WAKE')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({durSWS_sal_pre,durSWS_CNO_pre, durSWS_sal_post,durSWS_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
title('NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({durREM_sal_pre,durREM_CNO_pre, durREM_sal_post,durREM_CNO_post},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline post','CNO post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
title('REM')
makepretty

% 3h post CNO
ax(4)=subplot(234),PlotErrorBarN_KJ({durWAKE_sal_pre,durWAKE_CNO_pre,durWAKE_sal_3hPostInj, NumWAKE_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({durSWS_sal_pre,durSWS_CNO_pre,durSWS_sal_3hPostInj,durSWS_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({durREM_sal_pre,durREM_CNO_pre, durREM_sal_3hPostInj,durREM_CNO_3hPostInj},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'saline pre','CNO pre','saline 3h post','CNO 3h post'}); xtickangle(45)
ylabel('Duration of bouts (s)')
makepretty

set(ax,'ylim',[0 160]);



%% figures with BaselineSleep
%% pourcentage
figure
ax(1)=subplot(231),PlotErrorBarN_KJ({percWAKE_basal_pre(:,1),percWAKE_sal_pre(:,1),percWAKE_CNO_pre(:,1), percWAKE_basal_post(:,1),percWAKE_sal_post(:,1),percWAKE_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({percSWS_basal_pre(:,1),percSWS_sal_pre(:,1),percSWS_CNO_pre(:,1), percSWS_basal_post(:,1),percSWS_sal_post(:,1),percSWS_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({percREM_basal_pre(:,1),percREM_sal_pre(:,1),percREM_CNO_pre(:,1), percREM_basal_post(:,1),percREM_sal_post(:,1),percREM_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

ax(4)=subplot(234),PlotErrorBarN_KJ({percWAKE_basal_pre(:,1),percWAKE_sal_pre(:,1),percWAKE_CNO_pre(:,1), percWAKE_basal_3hPostInj(:,1),percWAKE_sal_3hPostInj(:,1), percWAKE_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({percSWS_basal_pre(:,1),percSWS_sal_pre(:,1),percSWS_CNO_pre(:,1), percSWS_basal_3hPostInj(:,1),percSWS_sal_3hPostInj(:,1),percSWS_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({percREM_basal_pre(:,1),percREM_sal_pre(:,1),percREM_CNO_pre(:,1), percREM_basal_3hPostInj(:,1),percREM_sal_3hPostInj(:,1),percREM_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

set(ax,'ylim',[0 100]);

%% number
figure
ax(1)=subplot(231),PlotErrorBarN_KJ({NumWAKE_basal_pre(:,1),NumWAKE_sal_pre(:,1),NumWAKE_CNO_pre(:,1), NumWAKE_basal_post(:,1),NumWAKE_sal_post(:,1),NumWAKE_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({NumSWS_basal_pre(:,1),NumSWS_sal_pre(:,1),NumSWS_CNO_pre(:,1), NumSWS_basal_post(:,1),NumSWS_sal_post(:,1),NumSWS_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({NumREM_basal_pre(:,1),NumREM_sal_pre(:,1),NumREM_CNO_pre(:,1), NumREM_basal_post(:,1),NumREM_sal_post(:,1),NumREM_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

ax(4)=subplot(234),PlotErrorBarN_KJ({NumWAKE_basal_pre(:,1),NumWAKE_sal_pre(:,1),NumWAKE_CNO_pre(:,1), NumWAKE_basal_3hPostInj(:,1),NumWAKE_sal_3hPostInj(:,1), NumWAKE_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({NumSWS_basal_pre(:,1),NumSWS_sal_pre(:,1),NumSWS_CNO_pre(:,1), NumSWS_basal_3hPostInj(:,1),NumSWS_sal_3hPostInj(:,1),NumSWS_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({NumREM_basal_pre(:,1),NumREM_sal_pre(:,1),NumREM_CNO_pre(:,1), NumREM_basal_3hPostInj(:,1),NumREM_sal_3hPostInj(:,1),NumREM_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

set(ax,'ylim',[0 160]);

%% duration
figure
ax(1)=subplot(231),PlotErrorBarN_KJ({durWAKE_basal_pre(:,1),durWAKE_sal_pre(:,1),durWAKE_CNO_pre(:,1), durWAKE_basal_post(:,1),durWAKE_sal_post(:,1),durWAKE_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(2)=subplot(232),PlotErrorBarN_KJ({durSWS_basal_pre(:,1),durSWS_sal_pre(:,1),durSWS_CNO_pre(:,1), durSWS_basal_post(:,1),durSWS_sal_post(:,1),durSWS_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(3)=subplot(233),PlotErrorBarN_KJ({durREM_basal_pre(:,1),durREM_sal_pre(:,1),durREM_CNO_pre(:,1), durREM_basal_post(:,1),durREM_sal_post(:,1),durREM_CNO_post(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

ax(4)=subplot(234),PlotErrorBarN_KJ({durWAKE_basal_pre(:,1),durWAKE_sal_pre(:,1),durWAKE_CNO_pre(:,1), durWAKE_basal_3hPostInj(:,1),durWAKE_sal_3hPostInj(:,1), durWAKE_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'basal pre','saline pre','CNO pre','basal post','saline post','CNO post'})
ylabel('Percentage of wakefulness')
makepretty
ax(5)=subplot(235),PlotErrorBarN_KJ({durSWS_basal_pre(:,1),durSWS_sal_pre(:,1),durSWS_CNO_pre(:,1), durSWS_basal_3hPostInj(:,1),durSWS_sal_3hPostInj(:,1),durSWS_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of NREM')
makepretty
ax(6)=subplot(236),PlotErrorBarN_KJ({durREM_basal_pre(:,1),durREM_sal_pre(:,1),durREM_CNO_pre(:,1), durREM_basal_3hPostInj(:,1),durREM_sal_3hPostInj(:,1),durREM_CNO_3hPostInj(:,1)},'newfig',0,'paired',0);
xticks([1 2 3 4]); xticklabels({'Pre SAL','Pre CNO','Post SAL','Post CNO'})
ylabel('Percentage of REM')
makepretty

set(ax,'ylim',[0 160]);

