

%% input dir : inhi DREADD in PFC
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

% DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
% DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
Dir_sal = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
DirSaline_retoCre = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_Nacl');
DirSaline = MergePathForExperiment(Dir_sal,DirSaline_retoCre);

% %cno
% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO = PathForExperiments_DREADD_MC('OneInject_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1105 1106 1148 1149 1150]);
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1217 1218 1219 1220]);

% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
% DirCNO=RestrictPathForExperiment(DirCNO,'nMice',[1196 1197 1198 1235 1236 1238]);

DirCNO = PathForExperimentsAtropine_MC('Atropine');

% DirCNO = PathForExperiments_DREADD_MC('retroCre_PFC_VLPO_CNO');


%%injection parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% BASELINE
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});

    if exist('SleepSubstages.mat')==2
        a{i} = load('SleepSubstages.mat','Epoch');
    %%rename epoch
    SWSEpoch{i} = a{i}.Epoch{7}; Wake{i} = a{i}.Epoch{4}; REMEpoch{i} = a{i}.Epoch{5};
    N1{i} = a{i}.Epoch{1}; N2{i} = a{i}.Epoch{2}; N3{i} = a{i}.Epoch{3}; %TOTsleep{i} = a{i}.Epoch{10};
    
    TOTsleep{i} = or(REMEpoch{i},SWSEpoch{i});
    
    %%separate day in different periods
    durtotal{i} = max([max(End(Wake{i})),max(End(SWSEpoch{i}))]);
    %pre injection
    epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal{i});
    %3h post injection
    epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    %%Number of bouts pre injection
    numN1_basal_pre(i)=length(length(and(N1{i},and(epoch_PreInj_basal{i},TOTsleep{i}))));
    numN2_basal_pre(i)=length(length(and(N2{i},and(epoch_PreInj_basal{i},TOTsleep{i}))));
    numN3_basal_pre(i)=length(length(and(N3{i},and(epoch_PreInj_basal{i},TOTsleep{i}))));
    numREM_basal_pre(i)=length(length(and(REMEpoch{i},and(epoch_PreInj_basal{i},TOTsleep{i}))));
    %%Number of bouts post injection
    numN1_basal_post(i)=length(length(and(N1{i},and(epoch_PostInj_basal{i},TOTsleep{i}))));
    numN2_basal_post(i)=length(length(and(N2{i},and(epoch_PostInj_basal{i},TOTsleep{i}))));
    numN3_basal_post(i)=length(length(and(N3{i},and(epoch_PostInj_basal{i},TOTsleep{i}))));
    numREM_basal_post(i)=length(length(and(REMEpoch{i},and(epoch_PostInj_basal{i},TOTsleep{i}))));
    %%Number of bouts 3h post injection
    numN1_basal_3hPost(i)=length(length(and(N1{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))));
    numN2_basal_3hPost(i)=length(length(and(N2{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))));
    numN3_basal_3hPost(i)=length(length(and(N3{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))));
    numREM_basal_3hPost(i)=length(length(and(REMEpoch{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))));

    %%Mean duration of bouts pre injection
    durN1_basal_pre(i)=mean(End(and(N1{i},and(epoch_PreInj_basal{i},TOTsleep{i})))-Start(and(N1{i},and(epoch_PreInj_basal{i},TOTsleep{i}))))/1E4;
    durN2_basal_pre(i)=mean(End(and(N2{i},and(epoch_PreInj_basal{i},TOTsleep{i})))-Start(and(N2{i},and(epoch_PreInj_basal{i},TOTsleep{i}))))/1E4;
    durN3_basal_pre(i)=mean(End(and(N3{i},and(epoch_PreInj_basal{i},TOTsleep{i})))-Start(and(N3{i},and(epoch_PreInj_basal{i},TOTsleep{i}))))/1E4;
    durREM_basal_pre(i)=mean(End(and(REMEpoch{i},and(epoch_PreInj_basal{i},TOTsleep{i})))-Start(and(REMEpoch{i},and(epoch_PreInj_basal{i},TOTsleep{i}))))/1E4;
    %%Mean duration of bouts post injection
    durN1_basal_post(i)=mean(End(and(N1{i},and(epoch_PostInj_basal{i},TOTsleep{i})))-Start(and(N1{i},and(epoch_PostInj_basal{i},TOTsleep{i}))))/1E4;
    durN2_basal_post(i)=mean(End(and(N2{i},and(epoch_PostInj_basal{i},TOTsleep{i})))-Start(and(N2{i},and(epoch_PostInj_basal{i},TOTsleep{i}))))/1E4;
    durN3_basal_post(i)=mean(End(and(N3{i},and(epoch_PostInj_basal{i},TOTsleep{i})))-Start(and(N3{i},and(epoch_PostInj_basal{i},TOTsleep{i}))))/1E4;
    durREM_basal_post(i)=mean(End(and(REMEpoch{i},and(epoch_PostInj_basal{i},TOTsleep{i})))-Start(and(REMEpoch{i},and(epoch_PostInj_basal{i},TOTsleep{i}))))/1E4;
    %%Mean duration of bouts 3h post injection
    durN1_basal_3hPost(i)=mean(End(and(N1{i},and(epoch_3hPostInj_basal{i},TOTsleep{i})))-Start(and(N1{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))))/1E4;
    durN2_basal_3hPost(i)=mean(End(and(N2{i},and(epoch_3hPostInj_basal{i},TOTsleep{i})))-Start(and(N2{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))))/1E4;
    durN3_basal_3hPost(i)=mean(End(and(N3{i},and(epoch_3hPostInj_basal{i},TOTsleep{i})))-Start(and(N3{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))))/1E4;
    durREM_basal_3hPost(i)=mean(End(and(REMEpoch{i},and(epoch_3hPostInj_basal{i},TOTsleep{i})))-Start(and(REMEpoch{i},and(epoch_3hPostInj_basal{i},TOTsleep{i}))))/1E4;
        
    
            path_mice_to_check{i} = DirMyBasal.path{i}{1};
    Restemp_basal{i}=ComputeSleepSubStagesPercentagesWithoutWake_MC(a{i}.Epoch,0);
    % Res(1,:) donne le N1
    % Res(2,:) donne le N2
    % Res(3,:) donne le N3
    % Res(4,:) donne le WAKE
    % Res(5,:) donne le REM
    %
    % Res(x,1) all recording
    % Res(x,2) first half / pre injection
    % Res(x,3) second half / post injection
    % Res(x,4) restricted to 3 hours post injection
    
    %%percentage pre injection
    percN1_basal_pre(i) = Restemp_basal{i}(1,2); percN1_basal_pre(percN1_basal_pre==0)=NaN;
    percN2_basal_pre(i) = Restemp_basal{i}(2,2); percN2_basal_pre(percN2_basal_pre==0)=NaN;
    percN3_basal_pre(i) = Restemp_basal{i}(3,2); percN3_basal_pre(percN3_basal_pre==0)=NaN;
    percREM_basal_pre(i) = Restemp_basal{i}(5,2); percREM_basal_pre(percREM_basal_pre==0)=NaN;

    %%percentage post injection
    percN1_basal_post(i) = Restemp_basal{i}(1,3); percN1_basal_post(percN1_basal_post==0)=NaN;
    percN2_basal_post(i) = Restemp_basal{i}(2,3); percN2_basal_post(percN2_basal_post==0)=NaN;
    percN3_basal_post(i) = Restemp_basal{i}(3,3); percN3_basal_post(percN3_basal_post==0)=NaN;
    percREM_basal_post(i) = Restemp_basal{i}(5,3); percREM_basal_post(percREM_basal_post==0)=NaN;
    
       %%percentage 3h post injection
    percN1_basal_3hPost(i) = Restemp_basal{i}(1,4); percN1_basal_3hPost(percN1_basal_3hPost==0)=NaN;
    percN2_basal_3hPost(i) = Restemp_basal{i}(2,4); percN2_basal_3hPost(percN2_basal_3hPost==0)=NaN;
    percN3_basal_3hPost(i) = Restemp_basal{i}(3,4); percN3_basal_3hPost(percN3_basal_3hPost==0)=NaN;
    percREM_basal_3hPost(i) = Restemp_basal{i}(5,4); percREM_basal_3hPost(percREM_basal_3hPost==0)=NaN;
    else
        
        
        %%Number of bouts pre injection
    numN1_basal_pre(i)=NaN;
    numN2_basal_pre(i)=NaN;
    numN3_basal_pre(i)=NaN;
    numREM_basal_pre(i)=NaN;
    %%Number of bouts post injection
    numN1_basal_post(i)=NaN;
    numN2_basal_post(i)=NaN;
    numN3_basal_post(i)=NaN;
    numREM_basal_post(i)=NaN;
    %%Number of bouts 3h post injection
    numN1_basal_3hPost(i)=NaN;
    numN2_basal_3hPost(i)=NaN;
    numN3_basal_3hPost(i)=NaN;
    numREM_basal_3hPost(i)=NaN;

    %%Mean duration of bouts pre injection
    durN1_basal_pre(i)=NaN;
    durN2_basal_pre(i)=NaN;
    durN3_basal_pre(i)=NaN;
    durREM_basal_pre(i)=NaN;
    %%Mean duration of bouts post injection
    durN1_basal_post(i)=NaN;
    durN2_basal_post(i)=NaN;
    durN3_basal_post(i)=NaN;
    durREM_basal_post(i)=NaN;
    %%Mean duration of bouts 3h post injection
    durN1_basal_3hPost(i)=NaN;
    durN2_basal_3hPost(i)=NaN;
    durN3_basal_3hPost(i)=NaN;
    durREM_basal_3hPost(i)=NaN;
        
        
    
    
    end    
end


%% SALINE
for j=1:length(DirSaline.path)
    cd(DirSaline.path{j}{1});
    b{j} = load('SleepSubstages.mat','Epoch'); 
    %%rename epoch
    SWSEpoch{j} = b{j}.Epoch{7}; Wake{j} = b{j}.Epoch{4}; REMEpoch{j} = b{j}.Epoch{5};
    N1{j} = b{j}.Epoch{1}; N2{j} = b{j}.Epoch{2}; N3{j} = b{j}.Epoch{3}; %TOTsleep{j} = b{j}.Epoch{10};
    TOTsleep{j} = or(REMEpoch{j},SWSEpoch{j});
    
    %%separate day in different periods
    durtotal{j} = max([max(End(Wake{j})),max(End(SWSEpoch{j}))]);
    %pre injection
    epoch_PreInj_sal{j} = intervalSet(0, en_epoch_preInj);
    %     epoch_PreInj_sal{i} = intervalSet(0, durtotal{i}/2);
    %post injection
    epoch_PostInj_sal{j} = intervalSet(st_epoch_postInj,durtotal{j});
    %     epoch_PostInj_sal{i} = intervalSet(durtotal{i}/2,durtotal{i});
    %3h post injection
    epoch_3hPostInj{j}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    %%Number of bouts pre injection
    numN1_sal_pre(j)=length(length(and(N1{j},and(epoch_PreInj_sal{j},TOTsleep{j}))));
    numN2_sal_pre(j)=length(length(and(N2{j},and(epoch_PreInj_sal{j},TOTsleep{j}))));
    numN3_sal_pre(j)=length(length(and(N3{j},and(epoch_PreInj_sal{j},TOTsleep{j}))));
    numREM_sal_pre(j)=length(length(and(REMEpoch{j},and(epoch_PreInj_sal{j},TOTsleep{j}))));
    %%Number of bouts post injection
    numN1_sal_post(j)=length(length(and(N1{j},and(epoch_PostInj_sal{j},TOTsleep{j}))));
    numN2_sal_post(j)=length(length(and(N2{j},and(epoch_PostInj_sal{j},TOTsleep{j}))));
    numN3_sal_post(j)=length(length(and(N3{j},and(epoch_PostInj_sal{j},TOTsleep{j}))));
    numREM_sal_post(j)=length(length(and(REMEpoch{j},and(epoch_PostInj_sal{j},TOTsleep{j}))));
    %%Number of bouts 3h post injection
    numN1_sal_3hPost(j)=length(length(and(N1{j},and(epoch_3hPostInj{j},TOTsleep{j}))));
    numN2_sal_3hPost(j)=length(length(and(N2{j},and(epoch_3hPostInj{j},TOTsleep{j}))));
    numN3_sal_3hPost(j)=length(length(and(N3{j},and(epoch_3hPostInj{j},TOTsleep{j}))));
    numREM_sal_3hPost(j)=length(length(and(REMEpoch{j},and(epoch_3hPostInj{j},TOTsleep{j}))));
    
    %%Mean duration of bouts pre injection
    durN1_sal_pre(j)=mean(End(and(N1{j},and(epoch_PreInj_sal{j},TOTsleep{j})))-Start(and(N1{j},and(epoch_PreInj_sal{j},TOTsleep{j}))))/1E4;
    durN2_sal_pre(j)=mean(End(and(N2{j},and(epoch_PreInj_sal{j},TOTsleep{j})))-Start(and(N2{j},and(epoch_PreInj_sal{j},TOTsleep{j}))))/1E4;
    durN3_sal_pre(j)=mean(End(and(N3{j},and(epoch_PreInj_sal{j},TOTsleep{j})))-Start(and(N3{j},and(epoch_PreInj_sal{j},TOTsleep{j}))))/1E4;
    durREM_sal_pre(j)=mean(End(and(REMEpoch{j},and(epoch_PreInj_sal{j},TOTsleep{j})))-Start(and(REMEpoch{j},and(epoch_PreInj_sal{j},TOTsleep{j}))))/1E4;
    %%Mean duration of bouts post injection
    durN1_sal_post(j)=mean(End(and(N1{j},and(epoch_PostInj_sal{j},TOTsleep{j})))-Start(and(N1{j},and(epoch_PostInj_sal{j},TOTsleep{j}))))/1E4;
    durN2_sal_post(j)=mean(End(and(N2{j},and(epoch_PostInj_sal{j},TOTsleep{j})))-Start(and(N2{j},and(epoch_PostInj_sal{j},TOTsleep{j}))))/1E4;
    durN3_sal_post(j)=mean(End(and(N3{j},and(epoch_PostInj_sal{j},TOTsleep{j})))-Start(and(N3{j},and(epoch_PostInj_sal{j},TOTsleep{j}))))/1E4;
    durREM_sal_post(j)=mean(End(and(REMEpoch{j},and(epoch_PostInj_sal{j},TOTsleep{j})))-Start(and(REMEpoch{j},and(epoch_PostInj_sal{j},TOTsleep{j}))))/1E4;
    %%Mean duration of bouts 3h post injection
    durN1_sal_3hPost(j)=mean(End(and(N1{j},and(epoch_3hPostInj{j},TOTsleep{j})))-Start(and(N1{j},and(epoch_3hPostInj{j},TOTsleep{j}))))/1E4;
    durN2_sal_3hPost(j)=mean(End(and(N2{j},and(epoch_3hPostInj{j},TOTsleep{j})))-Start(and(N2{j},and(epoch_3hPostInj{j},TOTsleep{j}))))/1E4;
    durN3_sal_3hPost(j)=mean(End(and(N3{j},and(epoch_3hPostInj{j},TOTsleep{j})))-Start(and(N3{j},and(epoch_3hPostInj{j},TOTsleep{j}))))/1E4;
    durREM_sal_3hPost(j)=mean(End(and(REMEpoch{j},and(epoch_3hPostInj{j},TOTsleep{j})))-Start(and(REMEpoch{j},and(epoch_3hPostInj{j},TOTsleep{j}))))/1E4;
    
    %%Percentage
    Restemp_sal{j}=ComputeSleepSubStagesPercentagesWithoutWake_MC(b{j}.Epoch,0);
    % Res(1,:) donne le N1
    % Res(2,:) donne le N2
    % Res(3,:) donne le N3
    % Res(4,:) donne le WAKE
    % Res(5,:) donne le REM
    %
    % Res(x,1) all recording
    % Res(x,2) first half / pre injection
    % Res(x,3) second half / post injection
    % Res(x,4) restricted to 3 hours post injection
    
    %%percentage pre injection
    percN1_sal_pre(j) = Restemp_sal{j}(1,2);
    percN2_sal_pre(j) = Restemp_sal{j}(2,2);
    percN3_sal_pre(j) = Restemp_sal{j}(3,2);
    percREM_sal_pre(j) = Restemp_sal{j}(5,2);
    %%percentage post injection
    percN1_sal_post(j) = Restemp_sal{j}(1,3);
    percN2_sal_post(j) = Restemp_sal{j}(2,3);
    percN3_sal_post(j) = Restemp_sal{j}(3,3);
    percREM_sal_post(j) = Restemp_sal{j}(5,3);
    %%percentage 3h post injection
    percN1_sal_3hPost(j) = Restemp_sal{j}(1,4);
    percN2_sal_3hPost(j) = Restemp_sal{j}(2,4);
    percN3_sal_3hPost(j) = Restemp_sal{j}(3,4);
    percREM_sal_3hPost(j) = Restemp_sal{j}(5,4);
end


%% CNO
for k=1:length(DirCNO.path)
    cd(DirCNO.path{k}{1});
    c{k} = load('SleepSubstages.mat','Epoch');
    %%rename epoch
    SWSEpoch{k} = c{k}.Epoch{7}; Wake{k} = c{k}.Epoch{4}; REMEpoch{k} = c{k}.Epoch{5};
    N1{k} = c{k}.Epoch{1}; N2{k} = c{k}.Epoch{2}; N3{k} = c{k}.Epoch{3}; %TOTsleep{k} = c{k}.Epoch{10};
    TOTsleep{k} = or(REMEpoch{k},SWSEpoch{k});
    
    %%separate day in different periods
    durtotal{k} = max([max(End(Wake{k})),max(End(SWSEpoch{k}))]);
    %pre injection
    epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal{k});
    %3h post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    %%Number of bouts pre injection
    numN1_cno_pre(k)=length(length(and(N1{k},and(epoch_PreInj_cno{k},TOTsleep{k}))));
    numN2_cno_pre(k)=length(length(and(N2{k},and(epoch_PreInj_cno{k},TOTsleep{k}))));
    numN3_cno_pre(k)=length(length(and(N3{k},and(epoch_PreInj_cno{k},TOTsleep{k}))));
    numREM_cno_pre(k)=length(length(and(REMEpoch{k},and(epoch_PreInj_cno{k},TOTsleep{k}))));

    %%Number of bouts post injection
    numN1_cno_post(k)=length(length(and(N1{k},and(epoch_PostInj_cno{k},TOTsleep{k}))));
    numN2_cno_post(k)=length(length(and(N2{k},and(epoch_PostInj_cno{k},TOTsleep{k}))));
    numN3_cno_post(k)=length(length(and(N3{k},and(epoch_PostInj_cno{k},TOTsleep{k}))));
    numREM_cno_post(k)=length(length(and(REMEpoch{k},and(epoch_PostInj_cno{k},TOTsleep{k}))));
    %%Number of bouts 3h post injection
    numN1_cno_3hPost(k)=length(length(and(N1{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))));
    numN2_cno_3hPost(k)=length(length(and(N2{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))));
    numN3_cno_3hPost(k)=length(length(and(N3{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))));
    numREM_cno_3hPost(k)=length(length(and(REMEpoch{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))));

    %%Mean duration of bouts pre injection
    durN1_cno_pre(k)=mean(End(and(N1{k},and(epoch_PreInj_cno{k},TOTsleep{k})))-Start(and(N1{k},and(epoch_PreInj_cno{k},TOTsleep{k}))))/1E4;
    durN2_cno_pre(k)=mean(End(and(N2{k},and(epoch_PreInj_cno{k},TOTsleep{k})))-Start(and(N2{k},and(epoch_PreInj_cno{k},TOTsleep{k}))))/1E4;
    durN3_cno_pre(k)=mean(End(and(N3{k},and(epoch_PreInj_cno{k},TOTsleep{k})))-Start(and(N3{k},and(epoch_PreInj_cno{k},TOTsleep{k}))))/1E4;
    durREM_cno_pre(k)=mean(End(and(REMEpoch{k},and(epoch_PreInj_cno{k},TOTsleep{k})))-Start(and(REMEpoch{k},and(epoch_PreInj_cno{k},TOTsleep{k}))))/1E4;
    %%Mean duration of bouts post injection
    durN1_cno_post(k)=mean(End(and(N1{k},and(epoch_PostInj_cno{k},TOTsleep{k})))-Start(and(N1{k},and(epoch_PostInj_cno{k},TOTsleep{k}))))/1E4;
    durN2_cno_post(k)=mean(End(and(N2{k},and(epoch_PostInj_cno{k},TOTsleep{k})))-Start(and(N2{k},and(epoch_PostInj_cno{k},TOTsleep{k}))))/1E4;
    durN3_cno_post(k)=mean(End(and(N3{k},and(epoch_PostInj_cno{k},TOTsleep{k})))-Start(and(N3{k},and(epoch_PostInj_cno{k},TOTsleep{k}))))/1E4;
    durREM_cno_post(k)=mean(End(and(REMEpoch{k},and(epoch_PostInj_cno{k},TOTsleep{k})))-Start(and(REMEpoch{k},and(epoch_PostInj_cno{k},TOTsleep{k}))))/1E4;
    %%Mean duration of bouts 3h post injection
    durN1_cno_3hPost(k)=mean(End(and(N1{k},and(epoch_3hPostInj_cno{k},TOTsleep{k})))-Start(and(N1{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))))/1E4;
    durN2_cno_3hPost(k)=mean(End(and(N2{k},and(epoch_3hPostInj_cno{k},TOTsleep{k})))-Start(and(N2{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))))/1E4;
    durN3_cno_3hPost(k)=mean(End(and(N3{k},and(epoch_3hPostInj_cno{k},TOTsleep{k})))-Start(and(N3{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))))/1E4;
    durREM_cno_3hPost(k)=mean(End(and(REMEpoch{k},and(epoch_3hPostInj_cno{k},TOTsleep{k})))-Start(and(REMEpoch{k},and(epoch_3hPostInj_cno{k},TOTsleep{k}))))/1E4;

    %%percentage
    Restemp_cno{k}=ComputeSleepSubStagesPercentagesWithoutWake_MC(c{k}.Epoch,0);
    % Res(1,:) donne le N1
    % Res(2,:) donne le N2
    % Res(3,:) donne le N3
    % Res(4,:) donne le WAKE
    % Res(5,:) donne le REM
    %
    % Res(x,1) all recording
    % Res(x,2) first half / pre injection
    % Res(x,3) second half / post injection
    % Res(x,4) restricted to 3 hours post injection
    
    %%percentage pre injection
    percN1_cno_pre(k) = Restemp_cno{k}(1,2);
    percN2_cno_pre(k) = Restemp_cno{k}(2,2);
    percN3_cno_pre(k) = Restemp_cno{k}(3,2);
    percREM_cno_pre(k) = Restemp_cno{k}(5,2);

    %%percentage post injection
    percN1_cno_post(k) = Restemp_cno{k}(1,3);
    percN2_cno_post(k) = Restemp_cno{k}(2,3);
    percN3_cno_post(k) = Restemp_cno{k}(3,3);
    percREM_cno_post(k) = Restemp_cno{k}(5,3);

    %%percentage 3h post injection
    percN1_cno_3hPost(k) = Restemp_cno{k}(1,4);
    percN2_cno_3hPost(k) = Restemp_cno{k}(2,4);
    percN3_cno_3hPost(k) = Restemp_cno{k}(3,4);
    percREM_cno_3hPost(k) = Restemp_cno{k}(5,4);
end

%%




%% correlations

change_percREM_basal = ((percREM_basal_post - percREM_basal_pre) ./ percREM_basal_pre).*100;
change_percREM_saline = ((percREM_sal_post - percREM_sal_pre) ./ percREM_sal_pre).*100;
change_percREM_cno = ((percREM_cno_post - percREM_cno_pre) ./ percREM_cno_pre).*100;


change_percN1_basal = ((percN1_basal_post - percN1_basal_pre) ./ percN1_basal_pre).*100;
change_percN1_saline = ((percN1_sal_post - percN1_sal_pre) ./ percN1_sal_pre).*100;
change_percN1_cno = ((percN1_cno_post - percN1_cno_pre) ./ percN1_cno_pre).*100;

change_percN2_basal = ((percN2_basal_post - percN2_basal_pre) ./ percN2_basal_pre).*100;
change_percN2_saline = ((percN2_sal_post - percN2_sal_pre) ./ percN2_sal_pre).*100;
change_percN2_cno = ((percN2_cno_post - percN2_cno_pre) ./ percN2_cno_pre).*100;

change_percN3_basal = ((percN3_basal_post - percN3_basal_pre) ./ percN3_basal_pre).*100;
change_percN3_saline = ((percN3_sal_post - percN3_sal_pre) ./ percN3_sal_pre).*100;
change_percN3_cno = ((percN3_cno_post - percN3_cno_pre) ./ percN3_cno_pre).*100;

figure
subplot(131)
s1=plot(change_percREM_basal, change_percN1_basal,'ko',change_percREM_saline, change_percN1_saline,'bo', change_percREM_cno, change_percN1_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep percentage change (%)')
ylabel('N1 percentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('Baseline','Saline','CNO')
% xlim([-110 110])
% ylim([-100 100])
set(gca,'FontSize',14)

subplot(132)
s1=plot(change_percREM_basal, change_percN2_basal,'ko',change_percREM_saline, change_percN2_saline,'bo', change_percREM_cno, change_percN2_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep percentage change (%)')
ylabel('N2 percentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('Baseline','Saline','CNO')
% xlim([-110 110])
% ylim([-100 100])
set(gca,'FontSize',14)



subplot(133)
s1=plot(change_percREM_basal, change_percN3_basal,'ko',change_percREM_saline, change_percN3_saline,'bo', change_percREM_cno, change_percN3_cno,'ro');
set(s1,'MarkerSize',8,'Linewidth',2.5);
hold on
% l=lsline;
% set(l,'LineWidth',1.5)
xlabel('REM sleep percentage change (%)')
ylabel('N3 percentage change (%)')
% ylim([26 34])
% xlim([0 20])
title('')
legend('Baseline','Saline','CNO')
% xlim([-110 110])
% ylim([-100 100])
set(gca,'FontSize',14)


%% figure (boxplot)
%%
col_pre_basal = [0.8 0.8 0.8];
col_post_basal = [0.8 0.8 0.8];
col_pre_saline = [0.3 0.3 0.3]; %vert
col_post_saline = [0.3 0.3 0.3];
col_pre_cno = [0.4 1 0.2]; %vert
col_post_cno = [0.4 1 0.2];


% col_pre_basal = [0.8 0.8 0.8];
% col_post_basal = [0.8 0.8 0.8];
% col_pre_saline = [1 0.6 0.6]; %%rose
% col_post_saline = [1 0.6 0.6];
% col_pre_cno = [1 0 0]; %rouge
% col_post_cno = [1 0 0];



figure
%%percentage
ax(1)=subplot(331),MakeBoxPlot_MC({percN1_basal_pre percN1_sal_pre percN1_cno_pre percN1_basal_post percN1_sal_post percN1_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('N1 percentage (%)')
ax(2)=subplot(332),MakeBoxPlot_MC({percN2_basal_pre percN2_sal_pre percN2_cno_pre percN2_basal_post percN2_sal_post percN2_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('N2 percentage (%)')
ax(3)=subplot(333),MakeBoxPlot_MC({percN3_basal_pre percN3_sal_pre percN3_cno_pre percN3_basal_post percN3_sal_post percN3_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('N3 percentage (%)')
%%number
ax(4)=subplot(334),MakeBoxPlot_MC({numN1_basal_pre numN1_sal_pre numN1_cno_pre numN1_basal_post numN1_sal_post numN1_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('# N1')
ax(5)=subplot(335),MakeBoxPlot_MC({numN2_basal_pre numN2_sal_pre numN2_cno_pre numN2_basal_post numN2_sal_post numN2_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('# N2')
ax(6)=subplot(336),MakeBoxPlot_MC({numN3_basal_pre numN3_sal_pre numN3_cno_pre numN3_basal_post numN3_sal_post numN3_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('# N3')
%%duration
ax(7)=subplot(337),MakeBoxPlot_MC({durN1_basal_pre durN1_sal_pre durN1_cno_pre durN1_basal_post durN1_sal_post durN1_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Mean duration of N1 (s)')
ax(8)=subplot(338),MakeBoxPlot_MC({durN2_basal_pre durN2_sal_pre durN2_cno_pre durN2_basal_post durN2_sal_post durN2_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Mean duration of N2 (s)')
ax(9)=subplot(339),MakeBoxPlot_MC({durN3_basal_pre durN3_sal_pre durN3_cno_pre durN3_basal_post durN3_sal_post durN3_cno_post},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','post'})
ylabel('Mean duration of N3 (s)')


%% 3h post injection
figure
%%percentage
ax(1)=subplot(331),MakeBoxPlot_MC({percN1_basal_pre percN1_sal_pre percN1_cno_pre percN1_basal_3hPost percN1_sal_3hPost percN1_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Percentage of N1 (%)')
ax(2)=subplot(332),MakeBoxPlot_MC({percN2_basal_pre percN2_sal_pre percN2_cno_pre percN2_basal_3hPost percN2_sal_3hPost percN2_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Percentage of N2 (%)')
ax(3)=subplot(333),MakeBoxPlot_MC({percN3_basal_pre percN3_sal_pre percN3_cno_pre percN3_basal_3hPost percN3_sal_3hPost percN3_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Percentage of N3 (%)')
%%number
ax(4)=subplot(334),MakeBoxPlot_MC({numN1_basal_pre numN1_sal_pre numN1_cno_pre numN1_basal_3hPost numN1_sal_3hPost numN1_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Number of N1 bouts')
ax(5)=subplot(335),MakeBoxPlot_MC({numN2_basal_pre numN2_sal_pre numN2_cno_pre numN2_basal_3hPost numN2_sal_3hPost numN2_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Number of N2 bouts')
ax(6)=subplot(336),MakeBoxPlot_MC({numN3_basal_pre numN3_sal_pre numN3_cno_pre numN3_basal_3hPost numN3_sal_3hPost numN3_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Number of N3 bouts')
%%duration
ax(7)=subplot(337),MakeBoxPlot_MC({durN1_basal_pre durN1_sal_pre durN1_cno_pre durN1_basal_3hPost durN1_sal_3hPost durN1_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of N1 (s)')
ax(8)=subplot(338),MakeBoxPlot_MC({durN2_basal_pre durN2_sal_pre durN2_cno_pre durN2_basal_3hPost durN2_sal_3hPost durN2_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of N2 (s)')
ax(9)=subplot(339),MakeBoxPlot_MC({durN3_basal_pre durN3_sal_pre durN3_cno_pre durN3_basal_3hPost durN3_sal_3hPost durN3_cno_3hPost},...
    {col_pre_basal col_pre_saline col_pre_cno col_post_basal col_post_saline col_post_cno},[1:3,5:7],{},1,0);
xticks([2 6]); xticklabels({'pre','3h post'})
ylabel('Mean duration of N3 (s)')

