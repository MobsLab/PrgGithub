%% input dir : inhi DREADD in PFC
%baseline sleep
%%input dir BASELINE (get basal directories from all experiments)
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');

DirBasal = MergePathForExperiment(DirMyBasal,DirLabBasal);

%saline PFC experiment
DirSaline_dreadd_PFC = PathForExperiments_DREADD_MC('dreadd_PFC_Nacl');
%saline VLPO experiment
DirSaline_dreadd_VLPO = PathForExperiments_DREADD_MC('OneInject_Nacl');
% DirSaline_dreadd_VLPO = RestrictPathForExperiment(DirSaline_dreadd_VLPO,'nMice',[1105 1106 1148 1149]);
%merge saline path
DirSaline = MergePathForExperiment(DirSaline_dreadd_PFC,DirSaline_dreadd_VLPO);
%cno
% DirCNO = PathForExperiments_DREADD_MC('dreadd_PFC_CNO');
DirCNO = PathForExperimentsAtropine_MC('Atropine');

% injection parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% BASELINE
for i=1:length(DirBasal.path)
    cd(DirBasal.path{i}{1});
    if exist('SleepSubstages.mat')==2
        a{i} = load('SleepSubstages.mat','Epoch');
        %%rename epoch
        SWSEpoch{i} = a{i}.Epoch{7}; Wake{i} = a{i}.Epoch{4}; REMEpoch{i} = a{i}.Epoch{5};
        N1{i} = a{i}.Epoch{1}; N2{i} = a{i}.Epoch{2}; N3{i} = a{i}.Epoch{3};
        
        %%separate day in different periods
        durtotal{i} = max([max(End(Wake{i})),max(End(SWSEpoch{i}))]);
        %pre injection
        epoch_PreInj_basal{i} = intervalSet(0, en_epoch_preInj);
        %     epoch_PreInj_sal{i} = intervalSet(0, durtotal{i}/2);
        %post injection
        epoch_PostInj_basal{i} = intervalSet(st_epoch_postInj,durtotal{i});
        %     epoch_PostInj_sal{i} = intervalSet(durtotal{i}/2,durtotal{i});
        %3h post injection
        epoch_3hPostInj_basal{i}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
        
        %%Number of bouts pre injection
        numN1_basal_pre(i)=length(length(and(N1{i},epoch_PreInj_basal{i}))); numN1_basal_pre(numN1_basal_pre==0)=NaN;
        numN2_basal_pre(i)=length(length(and(N2{i},epoch_PreInj_basal{i}))); numN2_basal_pre(numN2_basal_pre==0)=NaN;
        numN3_basal_pre(i)=length(length(and(N3{i},epoch_PreInj_basal{i}))); numN3_basal_pre(numN3_basal_pre==0)=NaN;
        numREM_basal_pre(i)=length(length(and(REMEpoch{i},epoch_PreInj_basal{i}))); numREM_basal_pre(numREM_basal_pre==0)=NaN;
        numWAKE_basal_pre(i)=length(length(and(Wake{i},epoch_PreInj_basal{i}))); numWAKE_basal_pre(numWAKE_basal_pre==0)=NaN;
        %%Number of bouts post injection
        numN1_basal_post(i)=length(length(and(N1{i},epoch_PostInj_basal{i}))); numN1_basal_post(numN1_basal_post==0)=NaN;
        numN2_basal_post(i)=length(length(and(N2{i},epoch_PostInj_basal{i}))); numN2_basal_post(numN2_basal_post==0)=NaN;
        numN3_basal_post(i)=length(length(and(N3{i},epoch_PostInj_basal{i}))); numN3_basal_post(numN3_basal_post==0)=NaN;
        numREM_basal_post(i)=length(length(and(REMEpoch{i},epoch_PostInj_basal{i}))); numREM_basal_post(numREM_basal_post==0)=NaN;
        numWAKE_basal_post(i)=length(length(and(Wake{i},epoch_PostInj_basal{i}))); numREM_basal_post(numREM_basal_post==0)=NaN;
        %%Number of bouts 3h post injection
        numN1_basal_3hPost(i)=length(length(and(N1{i},epoch_3hPostInj_basal{i}))); numN1_basal_3hPost(numN1_basal_3hPost==0)=NaN;
        numN2_basal_3hPost(i)=length(length(and(N2{i},epoch_3hPostInj_basal{i}))); numN2_basal_3hPost(numN2_basal_3hPost==0)=NaN;
        numN3_basal_3hPost(i)=length(length(and(N3{i},epoch_3hPostInj_basal{i}))); numN3_basal_3hPost(numN3_basal_3hPost==0)=NaN;
        numREM_basal_3hPost(i)=length(length(and(REMEpoch{i},epoch_3hPostInj_basal{i}))); numREM_basal_3hPost(numREM_basal_3hPost==0)=NaN;
        numWAKE_basal_3hPost(i)=length(length(and(Wake{i},epoch_3hPostInj_basal{i}))); numWAKE_basal_3hPost(numWAKE_basal_3hPost==0)=NaN;
        
        %%Mean duration of bouts pre injection
        durN1_basal_pre(i)=mean(End(and(N1{i},epoch_PreInj_basal{i}))-Start(and(N1{i},epoch_PreInj_basal{i})))/1E4; durN1_basal_pre(durN1_basal_pre==0)=NaN;
        durN2_basal_pre(i)=mean(End(and(N2{i},epoch_PreInj_basal{i}))-Start(and(N2{i},epoch_PreInj_basal{i})))/1E4; durN2_basal_pre(durN2_basal_pre==0)=NaN;
        durN3_basal_pre(i)=mean(End(and(N3{i},epoch_PreInj_basal{i}))-Start(and(N3{i},epoch_PreInj_basal{i})))/1E4; durN3_basal_pre(durN3_basal_pre==0)=NaN;
        durREM_basal_pre(i)=mean(End(and(REMEpoch{i},epoch_PreInj_basal{i}))-Start(and(REMEpoch{i},epoch_PreInj_basal{i})))/1E4; durREM_basal_pre(durREM_basal_pre==0)=NaN;
        durWAKE_basal_pre(i)=mean(End(and(Wake{i},epoch_PreInj_basal{i}))-Start(and(Wake{i},epoch_PreInj_basal{i})))/1E4; durWAKE_basal_pre(durWAKE_basal_pre==0)=NaN;
        %%Mean duration of bouts post injection
        durN1_basal_post(i)=mean(End(and(N1{i},epoch_PostInj_basal{i}))-Start(and(N1{i},epoch_PostInj_basal{i})))/1E4; durN1_basal_post(durN1_basal_post==0)=NaN;
        durN2_basal_post(i)=mean(End(and(N2{i},epoch_PostInj_basal{i}))-Start(and(N2{i},epoch_PostInj_basal{i})))/1E4; durN2_basal_post(durN2_basal_post==0)=NaN;
        durN3_basal_post(i)=mean(End(and(N3{i},epoch_PostInj_basal{i}))-Start(and(N3{i},epoch_PostInj_basal{i})))/1E4; durN3_basal_post(durN3_basal_post==0)=NaN;
        durREM_basal_post(i)=mean(End(and(REMEpoch{i},epoch_PostInj_basal{i}))-Start(and(REMEpoch{i},epoch_PostInj_basal{i})))/1E4; durREM_basal_post(durREM_basal_post==0)=NaN;
        durWAKE_basal_post(i)=mean(End(and(Wake{i},epoch_PostInj_basal{i}))-Start(and(Wake{i},epoch_PostInj_basal{i})))/1E4; durWAKE_basal_post(durWAKE_basal_post==0)=NaN;
        %%Mean duration of bouts 3h post injection
        durN1_basal_3hPost(i)=mean(End(and(N1{i},epoch_3hPostInj_basal{i}))-Start(and(N1{i},epoch_3hPostInj_basal{i})))/1E4; durN1_basal_3hPost(durN1_basal_3hPost==0)=NaN;
        durN2_basal_3hPost(i)=mean(End(and(N2{i},epoch_3hPostInj_basal{i}))-Start(and(N2{i},epoch_3hPostInj_basal{i})))/1E4; durN2_basal_3hPost(durN2_basal_3hPost==0)=NaN;
        durN3_basal_3hPost(i)=mean(End(and(N3{i},epoch_3hPostInj_basal{i}))-Start(and(N3{i},epoch_3hPostInj_basal{i})))/1E4; durN3_basal_3hPost(durN3_basal_3hPost==0)=NaN;
        durREM_basal_3hPost(i)=mean(End(and(REMEpoch{i},epoch_3hPostInj_basal{i}))-Start(and(REMEpoch{i},epoch_3hPostInj_basal{i})))/1E4; durREM_basal_3hPost(durREM_basal_3hPost==0)=NaN;
        durWAKE_basal_3hPost(i)=mean(End(and(Wake{i},epoch_3hPostInj_basal{i}))-Start(and(Wake{i},epoch_3hPostInj_basal{i})))/1E4; durWAKE_basal_3hPost(durWAKE_basal_3hPost==0)=NaN;
        
        %%Percentage - total session
        Restemp_basal{i}=ComputeSleepSubStagesPercentagesMC(a{i}.Epoch,0);
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
        percWAKE_basal_pre(i) = Restemp_basal{i}(4,2); percWAKE_basal_pre(percWAKE_basal_pre==0)=NaN;
        percREM_basal_pre(i) = Restemp_basal{i}(5,2); percREM_basal_pre(percREM_basal_pre==0)=NaN;
        %%percentage post injection
        percN1_basal_post(i) = Restemp_basal{i}(1,3); percN1_basal_post(percN1_basal_post==0)=NaN;
        percN2_basal_post(i) = Restemp_basal{i}(2,3); percN2_basal_post(percN2_basal_post==0)=NaN;
        percN3_basal_post(i) = Restemp_basal{i}(3,3); percN3_basal_post(percN3_basal_post==0)=NaN;
        percWAKE_basal_post(i) = Restemp_basal{i}(4,3); percWAKE_basal_post(percWAKE_basal_post==0)=NaN;
        percREM_basal_post(i) = Restemp_basal{i}(5,3); percREM_basal_post(percREM_basal_post==0)=NaN;
        %%percentage 3h post injection
        percN1_basal_3hPost(i) = Restemp_basal{i}(1,4); percN1_basal_3hPost(percN1_basal_3hPost==0)=NaN;
        percN2_basal_3hPost(i) = Restemp_basal{i}(2,4); percN2_basal_3hPost(percN2_basal_3hPost==0)=NaN;
        percN3_basal_3hPost(i) = Restemp_basal{i}(3,4); percN3_basal_3hPost(percN3_basal_3hPost==0)=NaN;
        percWAKE_basal_3hPost(i) = Restemp_basal{i}(4,4); percWAKE_basal_3hPost(percWAKE_basal_3hPost==0)=NaN;
        percREM_basal_3hPost(i) = Restemp_basal{i}(5,4); percREM_basal_3hPost(percREM_basal_3hPost==0)=NaN;
        
        %%percentage of sleep ststaes - total sleep
        Restemp_totsleep_basal{i}=ComputeSleepSubStagesPercentagesWithoutWake_MC(a{i}.Epoch,0);
    %%percentage pre injection
    percN1_totsleep_basal_pre(i) = Restemp_totsleep_basal{i}(1,2); percN1_totsleep_basal_pre(percN1_totsleep_basal_pre==0)=NaN;
    percN2_totsleep_basal_pre(i) = Restemp_totsleep_basal{i}(2,2); percN2_totsleep_basal_pre(percN2_totsleep_basal_pre==0)=NaN;
    percN3_totsleep_basal_pre(i) = Restemp_totsleep_basal{i}(3,2); percN3_totsleep_basal_pre(percN3_totsleep_basal_pre==0)=NaN;
    percREM_totsleep_basal_pre(i) = Restemp_totsleep_basal{i}(5,2); percREM_totsleep_basal_pre(percREM_totsleep_basal_pre==0)=NaN;
    %%percentage post injection
    percN1_totsleep_basal_post(i) = Restemp_totsleep_basal{i}(1,3); percN1_totsleep_basal_post(percN1_totsleep_basal_post==0)=NaN;
    percN2_totsleep_basal_post(i) = Restemp_totsleep_basal{i}(2,3); percN2_totsleep_basal_post(percN2_totsleep_basal_post==0)=NaN;
    percN3_totsleep_basal_post(i) = Restemp_totsleep_basal{i}(3,3); percN3_totsleep_basal_post(percN3_totsleep_basal_post==0)=NaN;
    percREM_totsleep_basal_post(i) = Restemp_totsleep_basal{i}(5,3); percREM_totsleep_basal_post(percREM_totsleep_basal_post==0)=NaN;
       %%percentage 3h post injection
    percN1_totsleep_basal_3hPost(i) = Restemp_totsleep_basal{i}(1,4); percN1_totsleep_basal_3hPost(percN1_totsleep_basal_3hPost==0)=NaN;
    percN2_totsleep_basal_3hPost(i) = Restemp_totsleep_basal{i}(2,4); percN2_totsleep_basal_3hPost(percN2_totsleep_basal_3hPost==0)=NaN;
    percN3_totsleep_basal_3hPost(i) = Restemp_totsleep_basal{i}(3,4); percN3_totsleep_basal_3hPost(percN3_totsleep_basal_3hPost==0)=NaN;
    percREM_totsleep_basal_3hPost(i) = Restemp_totsleep_basal{i}(5,4); percREM_totsleep_basal_3hPost(percREM_totsleep_basal_3hPost==0)=NaN;
    
    
        
    else
    end
end

%% SALINE
for k=1:length(DirSaline.path)
    cd(DirSaline.path{k}{1});
    b{k} = load('SleepSubstages.mat','Epoch');
    %rename epoch
    SWSEpoch{k} = b{k}.Epoch{7}; Wake{k} = b{k}.Epoch{4}; REMEpoch{k} = b{k}.Epoch{5};
    N1{k} = b{k}.Epoch{1}; N2{k} = b{k}.Epoch{2}; N3{k} = b{k}.Epoch{3};
    
    %separate day in different periods
    durtotal{k} = max([max(End(Wake{k})),max(End(SWSEpoch{k}))]);
    %pre injection
    epoch_PreInj_sal{k} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_sal{k} = intervalSet(st_epoch_postInj,durtotal{k});
    %3h post injection
    epoch_3hPostInj{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    %Number of bouts pre injection
    numN1_sal_pre(k)=length(length(and(N1{k},epoch_PreInj_sal{k})));
    numN2_sal_pre(k)=length(length(and(N2{k},epoch_PreInj_sal{k})));
    numN3_sal_pre(k)=length(length(and(N3{k},epoch_PreInj_sal{k})));
    numREM_sal_pre(k)=length(length(and(REMEpoch{k},epoch_PreInj_sal{k})));
    numWAKE_sal_pre(k)=length(length(and(Wake{k},epoch_PreInj_sal{k})));
    %Number of bouts post injection
    numN1_sal_post(k)=length(length(and(N1{k},epoch_PostInj_sal{k})));
    numN2_sal_post(k)=length(length(and(N2{k},epoch_PostInj_sal{k})));
    numN3_sal_post(k)=length(length(and(N3{k},epoch_PostInj_sal{k})));
    numREM_sal_post(k)=length(length(and(REMEpoch{k},epoch_PostInj_sal{k})));
    numWAKE_sal_post(k)=length(length(and(Wake{k},epoch_PostInj_sal{k})));
    %Number of bouts 3h post injection
    numN1_sal_3hPost(k)=length(length(and(N1{k},epoch_3hPostInj{k})));
    numN2_sal_3hPost(k)=length(length(and(N2{k},epoch_3hPostInj{k})));
    numN3_sal_3hPost(k)=length(length(and(N3{k},epoch_3hPostInj{k})));
    numREM_sal_3hPost(k)=length(length(and(REMEpoch{k},epoch_3hPostInj{k})));
    numWAKE_sal_3hPost(k)=length(length(and(Wake{k},epoch_3hPostInj{k})));
    
    %Mean duration of bouts pre injection
    durN1_sal_pre(k)=mean(End(and(N1{k},epoch_PreInj_sal{k}))-Start(and(N1{k},epoch_PreInj_sal{k})))/1E4;
    durN2_sal_pre(k)=mean(End(and(N2{k},epoch_PreInj_sal{k}))-Start(and(N2{k},epoch_PreInj_sal{k})))/1E4;
    durN3_sal_pre(k)=mean(End(and(N3{k},epoch_PreInj_sal{k}))-Start(and(N3{k},epoch_PreInj_sal{k})))/1E4;
    durREM_sal_pre(k)=mean(End(and(REMEpoch{k},epoch_PreInj_sal{k}))-Start(and(REMEpoch{k},epoch_PreInj_sal{k})))/1E4;
    durWAKE_sal_pre(k)=mean(End(and(Wake{k},epoch_PreInj_sal{k}))-Start(and(Wake{k},epoch_PreInj_sal{k})))/1E4;
    %Mean duration of bouts post injection
    durN1_sal_post(k)=mean(End(and(N1{k},epoch_PostInj_sal{k}))-Start(and(N1{k},epoch_PostInj_sal{k})))/1E4;
    durN2_sal_post(k)=mean(End(and(N2{k},epoch_PostInj_sal{k}))-Start(and(N2{k},epoch_PostInj_sal{k})))/1E4;
    durN3_sal_post(k)=mean(End(and(N3{k},epoch_PostInj_sal{k}))-Start(and(N3{k},epoch_PostInj_sal{k})))/1E4;
    durREM_sal_post(k)=mean(End(and(REMEpoch{k},epoch_PostInj_sal{k}))-Start(and(REMEpoch{k},epoch_PostInj_sal{k})))/1E4;
    durWAKE_sal_post(k)=mean(End(and(Wake{k},epoch_PostInj_sal{k}))-Start(and(Wake{k},epoch_PostInj_sal{k})))/1E4;
    %Mean duration of bouts 3h post injection
    durN1_sal_3hPost(k)=mean(End(and(N1{k},epoch_3hPostInj{k}))-Start(and(N1{k},epoch_3hPostInj{k})))/1E4;
    durN2_sal_3hPost(k)=mean(End(and(N2{k},epoch_3hPostInj{k}))-Start(and(N2{k},epoch_3hPostInj{k})))/1E4;
    durN3_sal_3hPost(k)=mean(End(and(N3{k},epoch_3hPostInj{k}))-Start(and(N3{k},epoch_3hPostInj{k})))/1E4;
    durREM_sal_3hPost(k)=mean(End(and(REMEpoch{k},epoch_3hPostInj{k}))-Start(and(REMEpoch{k},epoch_3hPostInj{k})))/1E4;
    durWAKE_sal_3hPost(k)=mean(End(and(Wake{k},epoch_3hPostInj{k}))-Start(and(Wake{k},epoch_3hPostInj{k})))/1E4;
    
    %Percentage
    Restemp_sal{k}=ComputeSleepSubStagesPercentagesMC(b{k}.Epoch,0);
    %Res(1,:) donne le N1
    %Res(2,:) donne le N2
    %Res(3,:) donne le N3
    %Res(4,:) donne le WAKE
    %Res(5,:) donne le REM
    
    %Res(x,1) all recording
    %Res(x,2) first half / pre injection
    %Res(x,3) second half / post injection
    %Res(x,4) restricted to 3 hours post injection
    
    %percentage pre injection
    percN1_sal_pre(k) = Restemp_sal{k}(1,2);
    percN2_sal_pre(k) = Restemp_sal{k}(2,2);
    percN3_sal_pre(k) = Restemp_sal{k}(3,2);
    percWAKE_sal_pre(k) = Restemp_sal{k}(4,2);
    percREM_sal_pre(k) = Restemp_sal{k}(5,2);
    %percentage post injection
    percN1_sal_post(k) = Restemp_sal{k}(1,3);
    percN2_sal_post(k) = Restemp_sal{k}(2,3);
    percN3_sal_post(k) = Restemp_sal{k}(3,3);
    percWAKE_sal_post(k) = Restemp_sal{k}(4,3);
    percREM_sal_post(k) = Restemp_sal{k}(5,3);
    %percentage 3h post injection
    percN1_sal_3hPost(k) = Restemp_sal{k}(1,4);
    percN2_sal_3hPost(k) = Restemp_sal{k}(2,4);
    percN3_sal_3hPost(k) = Restemp_sal{k}(3,4);
    percWAKE_sal_3hPost(k) = Restemp_sal{k}(4,4);
    percREM_sal_3hPost(k) = Restemp_sal{k}(5,4);
    
    
            %percentage of sleep ststaes - total sleep
        Restemp_totsleep_sal{k}=ComputeSleepSubStagesPercentagesWithoutWake_MC(b{k}.Epoch,0);
    %percentage pre injection
    percN1_totsleep_sal_pre(k) = Restemp_totsleep_sal{k}(1,2); 
    percN2_totsleep_sal_pre(k) = Restemp_totsleep_sal{k}(2,2);
    percN3_totsleep_sal_pre(k) = Restemp_totsleep_sal{k}(3,2);
    percREM_totsleep_sal_pre(k) = Restemp_totsleep_sal{k}(5,2);
    %percentage post injection
    percN1_totsleep_sal_post(k) = Restemp_totsleep_sal{k}(1,3);
    percN2_totsleep_sal_post(k) = Restemp_totsleep_sal{k}(2,3);
    percN3_totsleep_sal_post(k) = Restemp_totsleep_sal{k}(3,3);
    percREM_totsleep_sal_post(k) = Restemp_totsleep_sal{k}(5,3);
       %percentage 3h post injection
    percN1_totsleep_sal_3hPost(k) = Restemp_totsleep_sal{k}(1,4); 
    percN2_totsleep_sal_3hPost(k) = Restemp_totsleep_sal{k}(2,4);
    percN3_totsleep_sal_3hPost(k) = Restemp_totsleep_sal{k}(3,4);
    percREM_totsleep_sal_3hPost(k) = Restemp_totsleep_sal{k}(5,4); 
    
end


%% CNO
for k=1:length(DirCNO.path)
    cd(DirCNO.path{k}{1});
    c{k} = load('SleepSubstages.mat','Epoch');
    %%rename epoch
    SWSEpoch{k} = c{k}.Epoch{7}; Wake{k} = c{k}.Epoch{4}; REMEpoch{k} = c{k}.Epoch{5};
    N1{k} = c{k}.Epoch{1}; N2{k} = c{k}.Epoch{2}; N3{k} = c{k}.Epoch{3};
    
    %%separate day in different periods
    durtotal{k} = max([max(End(Wake{k})),max(End(SWSEpoch{k}))]);
    %pre injection
    epoch_PreInj_cno{k} = intervalSet(0, en_epoch_preInj);
    %post injection
    epoch_PostInj_cno{k} = intervalSet(st_epoch_postInj,durtotal{k});
    %3h post injection
    epoch_3hPostInj_cno{k}=intervalSet(st_epoch_postInj,st_epoch_postInj+3*3600*1e4); %to get the 3h post injection
    
    %%Number of bouts pre injection
    numN1_cno_pre(k)=length(length(and(N1{k},epoch_PreInj_cno{k})));
    numN2_cno_pre(k)=length(length(and(N2{k},epoch_PreInj_cno{k})));
    numN3_cno_pre(k)=length(length(and(N3{k},epoch_PreInj_cno{k})));
    numREM_cno_pre(k)=length(length(and(REMEpoch{k},epoch_PreInj_cno{k})));
    numWAKE_cno_pre(k)=length(length(and(Wake{k},epoch_PreInj_cno{k})));
    %%Number of bouts post injection
    numN1_cno_post(k)=length(length(and(N1{k},epoch_PostInj_cno{k})));
    numN2_cno_post(k)=length(length(and(N2{k},epoch_PostInj_cno{k})));
    numN3_cno_post(k)=length(length(and(N3{k},epoch_PostInj_cno{k})));
    numREM_cno_post(k)=length(length(and(REMEpoch{k},epoch_PostInj_cno{k})));
    numWAKE_cno_post(k)=length(length(and(Wake{k},epoch_PostInj_cno{k})));
    %%Number of bouts 3h post injection
    numN1_cno_3hPost(k)=length(length(and(N1{k},epoch_3hPostInj_cno{k})));
    numN2_cno_3hPost(k)=length(length(and(N2{k},epoch_3hPostInj_cno{k})));
    numN3_cno_3hPost(k)=length(length(and(N3{k},epoch_3hPostInj_cno{k})));
    numREM_cno_3hPost(k)=length(length(and(REMEpoch{k},epoch_3hPostInj_cno{k})));
    numWAKE_cno_3hPost(k)=length(length(and(Wake{k},epoch_3hPostInj_cno{k})));
    
    %%Mean duration of bouts pre injection
    durN1_cno_pre(k)=mean(End(and(N1{k},epoch_PreInj_cno{k}))-Start(and(N1{k},epoch_PreInj_cno{k})))/1E4;
    durN2_cno_pre(k)=mean(End(and(N2{k},epoch_PreInj_cno{k}))-Start(and(N2{k},epoch_PreInj_cno{k})))/1E4;
    durN3_cno_pre(k)=mean(End(and(N3{k},epoch_PreInj_cno{k}))-Start(and(N3{k},epoch_PreInj_cno{k})))/1E4;
    durREM_cno_pre(k)=mean(End(and(REMEpoch{k},epoch_PreInj_cno{k}))-Start(and(REMEpoch{k},epoch_PreInj_cno{k})))/1E4;
    durWAKE_cno_pre(k)=mean(End(and(Wake{k},epoch_PreInj_cno{k}))-Start(and(Wake{k},epoch_PreInj_cno{k})))/1E4;
    %%Mean duration of bouts post injection
    durN1_cno_post(k)=mean(End(and(N1{k},epoch_PostInj_cno{k}))-Start(and(N1{k},epoch_PostInj_cno{k})))/1E4;
    durN2_cno_post(k)=mean(End(and(N2{k},epoch_PostInj_cno{k}))-Start(and(N2{k},epoch_PostInj_cno{k})))/1E4;
    durN3_cno_post(k)=mean(End(and(N3{k},epoch_PostInj_cno{k}))-Start(and(N3{k},epoch_PostInj_cno{k})))/1E4;
    durREM_cno_post(k)=mean(End(and(REMEpoch{k},epoch_PostInj_cno{k}))-Start(and(REMEpoch{k},epoch_PostInj_cno{k})))/1E4;
    durWAKE_cno_post(k)=mean(End(and(Wake{k},epoch_PostInj_cno{k}))-Start(and(Wake{k},epoch_PostInj_cno{k})))/1E4;
    %%Mean duration of bouts 3h post injection
    durN1_cno_3hPost(k)=mean(End(and(N1{k},epoch_3hPostInj_cno{k}))-Start(and(N1{k},epoch_3hPostInj_cno{k})))/1E4;
    durN2_cno_3hPost(k)=mean(End(and(N2{k},epoch_3hPostInj_cno{k}))-Start(and(N2{k},epoch_3hPostInj_cno{k})))/1E4;
    durN3_cno_3hPost(k)=mean(End(and(N3{k},epoch_3hPostInj_cno{k}))-Start(and(N3{k},epoch_3hPostInj_cno{k})))/1E4;
    durREM_cno_3hPost(k)=mean(End(and(REMEpoch{k},epoch_3hPostInj_cno{k}))-Start(and(REMEpoch{k},epoch_3hPostInj_cno{k})))/1E4;
    durWAKE_cno_3hPost(k)=mean(End(and(Wake{k},epoch_3hPostInj_cno{k}))-Start(and(Wake{k},epoch_3hPostInj_cno{k})))/1E4;
    
    %%percentage
    Restemp_cno{k}=ComputeSleepSubStagesPercentagesMC(c{k}.Epoch,0);
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
    percWAKE_cno_pre(k) = Restemp_cno{k}(4,2);
    percREM_cno_pre(k) = Restemp_cno{k}(5,2);
    %%percentage post injection
    percN1_cno_post(k) = Restemp_cno{k}(1,3);
    percN2_cno_post(k) = Restemp_cno{k}(2,3);
    percN3_cno_post(k) = Restemp_cno{k}(3,3);
    percWAKE_cno_post(k) = Restemp_cno{k}(4,3);
    percREM_cno_post(k) = Restemp_cno{k}(5,3);
    %%percentage 3h post injection
    percN1_cno_3hPost(k) = Restemp_cno{k}(1,4);
    percN2_cno_3hPost(k) = Restemp_cno{k}(2,4);
    percN3_cno_3hPost(k) = Restemp_cno{k}(3,4);
    percWAKE_cno_3hPost(k) = Restemp_cno{k}(4,4);
    percREM_cno_3hPost(k) = Restemp_cno{k}(5,4);
    
    
    
        
            %%percentage of sleep ststaes - total sleep
        Restemp_totsleep_cno{k}=ComputeSleepSubStagesPercentagesWithoutWake_MC(a{k}.Epoch,0);
    %%percentage pre injection
    percN1_totsleep_cno_pre(k) = Restemp_totsleep_cno{k}(1,2); 
    percN2_totsleep_cno_pre(k) = Restemp_totsleep_cno{k}(2,2);
    percN3_totsleep_cno_pre(k) = Restemp_totsleep_cno{k}(3,2);
    percREM_totsleep_cno_pre(k) = Restemp_totsleep_cno{k}(5,2);
    %%percentage post injection
    percN1_totsleep_cno_post(k) = Restemp_totsleep_cno{k}(1,3);
    percN2_totsleep_cno_post(k) = Restemp_totsleep_cno{k}(2,3);
    percN3_totsleep_cno_post(k) = Restemp_totsleep_cno{k}(3,3);
    percREM_totsleep_cno_post(k) = Restemp_totsleep_cno{k}(5,3);
       %%percentage 3h post injection
    percN1_totsleep_cno_3hPost(k) = Restemp_totsleep_cno{k}(1,4); 
    percN2_totsleep_cno_3hPost(k) = Restemp_totsleep_cno{k}(2,4);
    percN3_totsleep_cno_3hPost(k) = Restemp_totsleep_cno{k}(3,4);
    percREM_totsleep_cno_3hPost(k) = Restemp_totsleep_cno{k}(5,4); 
    
    
end



%% figures
%% percentage - total session
figure,
ax1(1)=subplot(251),
PlotErrorBarN_KJ({percN1_basal_pre percN1_sal_pre percN1_cno_pre percN1_basal_post percN1_sal_post percN1_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N1 (%)')
ax1(2)=subplot(252),
PlotErrorBarN_KJ({percN2_basal_pre percN2_sal_pre percN2_cno_pre percN2_basal_post percN2_sal_post percN2_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N2 (%)')
ax1(3)=subplot(253),
PlotErrorBarN_KJ({percN3_basal_pre percN3_sal_pre percN3_cno_pre percN3_basal_post percN3_sal_post percN3_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N3 (%)')
ax1(4)=subplot(254),
PlotErrorBarN_KJ({percREM_basal_pre percREM_sal_pre percREM_cno_pre percREM_basal_post percREM_sal_post percREM_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of REM (%)')
ax1(5)=subplot(255),
PlotErrorBarN_KJ({percWAKE_basal_pre percWAKE_sal_pre percWAKE_cno_pre percWAKE_basal_post percWAKE_sal_post percWAKE_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of WAKE (%)')
% set(ax,'ylim',[0 50])

set(ax1,'Xticklabels',[])

%%percentage : 3h post
ax(6)=subplot(256),
PlotErrorBarN_KJ({percN1_basal_pre percN1_sal_pre percN1_cno_pre percN1_basal_3hPost percN1_sal_3hPost percN1_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N1 (%)')
ax(7)=subplot(257),
PlotErrorBarN_KJ({percN2_basal_pre percN2_sal_pre percN2_cno_pre percN2_basal_3hPost percN2_sal_3hPost percN2_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N2 (%)')
ax(8)=subplot(258),
PlotErrorBarN_KJ({percN3_basal_pre percN3_sal_pre percN3_cno_pre percN3_basal_3hPost percN3_sal_3hPost percN3_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N3 (%)')
ax(9)=subplot(259),
PlotErrorBarN_KJ({percREM_basal_pre percREM_sal_pre percREM_cno_pre percREM_basal_3hPost percREM_sal_3hPost percREM_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of REM (%)')
ax(10)=subplot(2,5,10),
PlotErrorBarN_KJ({percWAKE_basal_pre percWAKE_sal_pre percWAKE_cno_pre percWAKE_basal_3hPost percWAKE_sal_3hPost percWAKE_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of WAKE (%)')

% set(ax,'ylim',[0 100])




%% percentage - total sleep
%% percentage
figure,
ax1(1)=subplot(241),
PlotErrorBarN_KJ({percN1_totsleep_basal_pre percN1_totsleep_sal_pre percN1_totsleep_cno_pre percN1_totsleep_basal_post percN1_totsleep_sal_post percN1_totsleep_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N1 (%)')
ax1(2)=subplot(242),
PlotErrorBarN_KJ({percN2_totsleep_basal_pre percN2_totsleep_sal_pre percN2_totsleep_cno_pre percN2_totsleep_basal_post percN2_totsleep_sal_post percN2_totsleep_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N2 (%)')
ax1(3)=subplot(243),
PlotErrorBarN_KJ({percN3_totsleep_basal_pre percN3_totsleep_sal_pre percN3_totsleep_cno_pre percN3_totsleep_basal_post percN3_totsleep_sal_post percN3_totsleep_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of N3 (%)')
ax1(4)=subplot(244),
PlotErrorBarN_KJ({percREM_totsleep_basal_pre percREM_totsleep_sal_pre percREM_totsleep_cno_pre percREM_totsleep_basal_post percREM_totsleep_sal_post percREM_totsleep_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Percentage of REM (%)')

set(ax1,'Xticklabels',[])

%%percentage : 3h post
ax2(6)=subplot(245),
PlotErrorBarN_KJ({percN1_totsleep_basal_pre percN1_totsleep_sal_pre percN1_totsleep_cno_pre percN1_totsleep_basal_3hPost percN1_totsleep_sal_3hPost percN1_totsleep_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N1 (%)')
ax2(7)=subplot(246),
PlotErrorBarN_KJ({percN2_totsleep_basal_pre percN2_totsleep_sal_pre percN2_totsleep_cno_pre percN2_totsleep_basal_3hPost percN2_totsleep_sal_3hPost percN2_totsleep_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N2 (%)')
ax2(8)=subplot(247),
PlotErrorBarN_KJ({percN3_totsleep_basal_pre percN3_totsleep_sal_pre percN3_totsleep_cno_pre percN3_totsleep_basal_3hPost percN3_totsleep_sal_3hPost percN3_totsleep_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of N3 (%)')
ax2(9)=subplot(248),
PlotErrorBarN_KJ({percREM_totsleep_basal_pre percREM_totsleep_sal_pre percREM_totsleep_cno_pre percREM_totsleep_basal_3hPost percREM_totsleep_sal_3hPost percREM_totsleep_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Percentage of REM (%)')


% set(ax,'ylim',[0 100])









%% Number
figure,
ax(1)=subplot(251),
PlotErrorBarN_KJ({numN1_basal_pre numN1_sal_pre numN1_cno_pre numN1_basal_post numN1_sal_post numN1_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Number of N1 bouts')
ax(2)=subplot(252),
PlotErrorBarN_KJ({numN2_basal_pre numN2_sal_pre numN2_cno_pre numN2_basal_post numN2_sal_post numN2_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Number of N2 bouts')
ax(3)=subplot(253),
PlotErrorBarN_KJ({numN3_basal_pre numN3_sal_pre numN3_cno_pre numN3_basal_post numN3_sal_post numN3_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Number of N3 bouts')
ax(4)=subplot(254),
PlotErrorBarN_KJ({numREM_basal_pre numREM_sal_pre numREM_cno_pre numREM_basal_post numREM_sal_post numREM_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Number of REM bouts')
ax(5)=subplot(255),
PlotErrorBarN_KJ({numWAKE_basal_pre numWAKE_sal_pre numWAKE_cno_pre numWAKE_basal_post numWAKE_sal_post numWAKE_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Number of WAKE bouts')
% set(ax,'ylim',[0 50])

%%number : 3h post
ax(6)=subplot(256),
PlotErrorBarN_KJ({numN1_basal_pre numN1_sal_pre numN1_cno_pre numN1_basal_3hPost numN1_sal_3hPost numN1_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Number of N1 bouts')
ax(7)=subplot(257),
PlotErrorBarN_KJ({numN2_basal_pre numN2_sal_pre numN2_cno_pre numN2_basal_3hPost numN2_sal_3hPost numN2_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Number of N2 bouts')
ax(8)=subplot(258),
PlotErrorBarN_KJ({numN3_basal_pre numN3_sal_pre numN3_cno_pre numN3_basal_3hPost numN3_sal_3hPost numN3_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Number of N3 bouts')
ax(9)=subplot(259),
PlotErrorBarN_KJ({numREM_basal_pre numREM_sal_pre numREM_cno_pre numREM_basal_3hPost numREM_sal_3hPost numREM_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Number of REM bouts')
ax(10)=subplot(2,5,10),
PlotErrorBarN_KJ({numWAKE_basal_pre numWAKE_sal_pre numWAKE_cno_pre numWAKE_basal_3hPost numWAKE_sal_3hPost numWAKE_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Number of WAKE bouts')

set(ax,'ylim',[0 1600])


%% duration
figure,
ax(1)=subplot(251),
PlotErrorBarN_KJ({durN1_basal_pre durN1_sal_pre durN1_cno_pre durN1_basal_post durN1_sal_post durN1_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Mean duration of N1 bouts (s)')
ax(2)=subplot(252),
PlotErrorBarN_KJ({durN2_basal_pre durN2_sal_pre durN2_cno_pre durN2_basal_post durN2_sal_post durN2_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Mean duration of N2 bouts (s)')
ax(3)=subplot(253),
PlotErrorBarN_KJ({durN3_basal_pre durN3_sal_pre durN3_cno_pre durN3_basal_post durN3_sal_post durN3_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Mean duration of N3 bouts (s)')
ax(4)=subplot(254),
PlotErrorBarN_KJ({durREM_basal_pre durREM_sal_pre durREM_cno_pre durREM_basal_post durREM_sal_post durREM_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Mean duration of REM bouts (s)')
ax(5)=subplot(255),
PlotErrorBarN_KJ({durWAKE_basal_pre durWAKE_sal_pre durWAKE_cno_pre durWAKE_basal_post durWAKE_sal_post durWAKE_cno_post},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','post baseline','post saline','post CNO'});xtickangle(45)
makepretty
ylabel('Mean duration of WAKE bouts (s)')
% set(ax,'ylim',[0 50])

%%duration : 3h post
ax(6)=subplot(256),
PlotErrorBarN_KJ({durN1_basal_pre durN1_sal_pre durN1_cno_pre durN1_basal_3hPost durN1_sal_3hPost durN1_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Mean duration of N1 bouts (s)')
ax(7)=subplot(257),
PlotErrorBarN_KJ({durN2_basal_pre durN2_sal_pre durN2_cno_pre durN2_basal_3hPost durN2_sal_3hPost durN2_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Mean duration of N2 bouts (s)')
ax(8)=subplot(258),
PlotErrorBarN_KJ({durN3_basal_pre durN3_sal_pre durN3_cno_pre durN3_basal_3hPost durN3_sal_3hPost durN3_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Mean duration of N3 bouts (s)')
ax(9)=subplot(259),
PlotErrorBarN_KJ({durREM_basal_pre durREM_sal_pre durREM_cno_pre durREM_basal_3hPost durREM_sal_3hPost durREM_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Mean duration of REM bouts (s)')
ax(10)=subplot(2,5,10),
PlotErrorBarN_KJ({durWAKE_basal_pre durWAKE_sal_pre durWAKE_cno_pre durWAKE_basal_3hPost durWAKE_sal_3hPost durWAKE_cno_3hPost},'newfig',0,'paired',0);
xticks([1:6]); xticklabels({'pre baseline','pre saline','pre CNO','3h post baseline','3h post saline','3h post CNO'}); xtickangle(45)
makepretty
ylabel('Mean duration of WAKE bouts (s)')

set(ax,'ylim',[0 150])
