%% input dir basal sleep
DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);

% DirMyBasal = PathForExperimentsSD_MC('SleepPostSD');

%% parameters
en_epoch_preInj = 1.4*1E8;
st_epoch_postInj = 1.65*1E8;

%% get data BASELINE sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    
    sleep_stages_basal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    %%load substages
    if exist('SleepSubstages.mat')==2
        substage_basal{i} = load('SleepSubstages.mat'); %%SWS : 7, WAKE : 4, REM : 5, N1 : 1, N2 : 2, N3 : 3
        %%periods of time
        durtotal_basal{i} = max([max(End(sleep_stages_basal{i}.Wake)),max(End(sleep_stages_basal{i}.SWSEpoch))]);
        %beginning to 10am
        epoch_8_10_basal{i} = intervalSet(0, 0.7*1E8);
        %10am to 1pm
        epoch_10_13_basal{i} = intervalSet(0.5*1E8, 1.5*1E8);
        %1pm to 4pm
        epoch_13_16_basal{i} = intervalSet(1.5*1E8,2.5*1E8);
        %4pm to end
        epoch_16_end_basal{i} = intervalSet(2.5*1E8,durtotal_basal{i});
        
        %%duration stages
        %start-10
        [durWake_8_10_basal{i},durTWake_8_10_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_8_10_basal{i}));
        [durSWS_8_10_basal{i},durTSWS_8_10_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_8_10_basal{i}));
        [durREM_8_10_basal{i},durTREM_8_10_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_8_10_basal{i}));
        [durN1_8_10_basal{i},durTN1_8_10_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{1},epoch_8_10_basal{i}));
        [durN2_8_10_basal{i},durTN2_8_10_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{2},epoch_8_10_basal{i}));
        [durN3_8_10_basal{i},durTN3_8_10_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{3},epoch_8_10_basal{i}));
        [durTOTsleep_8_10_basal{i},durTTOTsleep_8_10_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_8_10_basal{i}));
        %10-13
        [durWake_10_13_basal{i},durTWake_10_13_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}));
        [durSWS_10_13_basal{i},durTSWS_10_13_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}));
        [durREM_10_13_basal{i},durTREM_10_13_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}));
        [durN1_10_13_basal{i},durTN1_10_13_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{1},epoch_10_13_basal{i}));
        [durN2_10_13_basal{i},durTN2_10_13_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{2},epoch_10_13_basal{i}));
        [durN3_10_13_basal{i},durTN3_10_13_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{3},epoch_10_13_basal{i}));
        [durTOTsleep_10_13_basal{i},durTTOTsleep_10_13_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_10_13_basal{i}));
        %13-16
        [durWake_13_16_basal{i},durTWake_13_16_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}));
        [durSWS_13_16_basal{i},durTSWS_13_16_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}));
        [durREM_13_16_basal{i},durTREM_13_16_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}));
        [durN1_13_16_basal{i},durTN1_13_16_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{1},epoch_13_16_basal{i}));
        [durN2_13_16_basal{i},durTN2_13_16_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{2},epoch_13_16_basal{i}));
        [durN3_13_16_basal{i},durTN3_13_16_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{3},epoch_13_16_basal{i}));
        [durTOTsleep_13_16_basal{i},durTTOTsleep_13_16_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_13_16_basal{i}));
        %16-end
        [durWake_16_end_basal{i},durTWake_16_end_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i}));
        [durSWS_16_end_basal{i},durTSWS_16_end_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i}));
        [durREM_16_end_basal{i},durTREM_16_end_basal{i}]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i}));
        [durN1_16_end_basal{i},durTN1_16_end_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{1},epoch_16_end_basal{i}));
        [durN2_16_end_basal{i},durTN2_16_end_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{2},epoch_16_end_basal{i}));
        [durN3_16_end_basal{i},durTN3_16_end_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{3},epoch_16_end_basal{i}));
        [durTOTsleep_16_en_basal{i},durTTOTsleep_16_end_basal{i}]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_16_end_basal{i}));
        
        %%compute percentage
        percWAKE_basal_8_10(i) = durTWake_8_10_basal{i}/(durTWake_8_10_basal{i}+durTSWS_8_10_basal{i}+durTREM_8_10_basal{i})*100;
        percSWS_basal_8_10(i) = durTSWS_8_10_basal{i}/(durTWake_8_10_basal{i}+durTSWS_8_10_basal{i}+durTREM_8_10_basal{i})*100;
        percREM_basal_8_10(i) = durTREM_8_10_basal{i}/(durTWake_8_10_basal{i}+durTSWS_8_10_basal{i}+durTREM_8_10_basal{i})*100;
        percREM_totSleep_basal_8_10(i) = durTREM_8_10_basal{i}/(durTSWS_8_10_basal{i}+durTREM_8_10_basal{i})*100;
        percN1_basal_8_10(i) = durTN1_8_10_basal{i}/(durTTOTsleep_8_10_basal{i})*100;
        percN2_basal_8_10(i) = durTN2_8_10_basal{i}/(durTTOTsleep_8_10_basal{i})*100;
        percN3_basal_8_10(i) = durTN3_8_10_basal{i}/(durTTOTsleep_8_10_basal{i})*100;
        %start-10
        percWAKE_basal_10_13(i) = durTWake_10_13_basal{i}/(durTWake_10_13_basal{i}+durTSWS_10_13_basal{i}+durTREM_10_13_basal{i})*100;
        percSWS_basal_10_13(i) = durTSWS_10_13_basal{i}/(durTWake_10_13_basal{i}+durTSWS_10_13_basal{i}+durTREM_10_13_basal{i})*100;
        percREM_basal_10_13(i) = durTREM_10_13_basal{i}/(durTWake_10_13_basal{i}+durTSWS_10_13_basal{i}+durTREM_10_13_basal{i})*100;
        percREM_totSleep_basal_10_13(i) = durTREM_10_13_basal{i}/(durTSWS_10_13_basal{i}+durTREM_10_13_basal{i})*100;
        percN1_basal_10_13(i) = durTN1_10_13_basal{i}/(durTTOTsleep_10_13_basal{i})*100;
        percN2_basal_10_13(i) = durTN2_10_13_basal{i}/(durTTOTsleep_10_13_basal{i})*100;
        percN3_basal_10_13(i) = durTN3_10_13_basal{i}/(durTTOTsleep_10_13_basal{i})*100;
        %13-16
        percWAKE_basal_13_16(i)=durTWake_13_16_basal{i}/(durTWake_13_16_basal{i}+durTSWS_13_16_basal{i}+durTREM_13_16_basal{i})*100;
        percSWS_basal_13_16(i)=durTSWS_13_16_basal{i}/(durTWake_13_16_basal{i}+durTSWS_13_16_basal{i}+durTREM_13_16_basal{i})*100;
        percREM_basal_13_16(i)=durTREM_13_16_basal{i}/(durTWake_13_16_basal{i}+durTSWS_13_16_basal{i}+durTREM_13_16_basal{i})*100;
        percREM_totSleep_basal_13_16(i)=durTREM_13_16_basal{i}/(durTSWS_13_16_basal{i}+durTREM_13_16_basal{i})*100;
        percN1_basal_13_16(i) = durTN1_13_16_basal{i}/(durTTOTsleep_13_16_basal{i})*100;
        percN2_basal_13_16(i) = durTN2_13_16_basal{i}/(durTTOTsleep_13_16_basal{i})*100;
        percN3_basal_13_16(i) = durTN3_13_16_basal{i}/(durTTOTsleep_13_16_basal{i})*100;
        %16-end
        percWAKE_basal_16_end(i)=durTWake_16_end_basal{i}/(durTWake_16_end_basal{i}+durTSWS_16_end_basal{i}+durTREM_16_end_basal{i})*100;
        percSWS_basal_16_end(i)=durTSWS_16_end_basal{i}/(durTWake_16_end_basal{i}+durTSWS_16_end_basal{i}+durTREM_16_end_basal{i})*100;
        percREM_basal_16_end(i)=durTREM_16_end_basal{i}/(durTWake_16_end_basal{i}+durTSWS_16_end_basal{i}+durTREM_16_end_basal{i})*100;
        percREM_totSleep_basal_16_end(i)=durTREM_16_end_basal{i}/(durTSWS_16_end_basal{i}+durTREM_16_end_basal{i})*100;
        percN1_basal_16_end(i) = durTN1_16_end_basal{i}/(durTTOTsleep_16_end_basal{i})*100;
        percN2_basal_16_end(i) = durTN2_16_end_basal{i}/(durTTOTsleep_16_end_basal{i})*100;
        percN3_basal_16_end(i) = durTN3_16_end_basal{i}/(durTTOTsleep_16_end_basal{i})*100;
        
        
        %%number
        %start-10
        NumSWS_basal_8_10(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_8_10_basal{i}))); NumSWS_basal_8_10(NumSWS_basal_8_10==0)=NaN;
        NumWAKE_basal_8_10(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_8_10_basal{i}))); NumWAKE_basal_8_10(NumWAKE_basal_8_10==0)=NaN;
        NumREM_basal_8_10(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_8_10_basal{i}))); NumREM_basal_8_10(NumREM_basal_8_10==0)=NaN;
        NumN1_basal_8_10(i)=length(length(and(substage_basal{i}.Epoch{1},epoch_8_10_basal{i}))); NumN1_basal_8_10(NumN1_basal_8_10==0)=NaN;
        NumN2_basal_8_10(i)=length(length(and(substage_basal{i}.Epoch{2},epoch_8_10_basal{i}))); NumN2_basal_8_10(NumN2_basal_8_10==0)=NaN;
        NumN3_basal_8_10(i)=length(length(and(substage_basal{i}.Epoch{3},epoch_8_10_basal{i}))); NumN3_basal_8_10(NumN3_basal_8_10==0)=NaN;
        %10-13
        NumSWS_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}))); NumSWS_basal_10_13(NumSWS_basal_10_13==0)=NaN;
        NumWAKE_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}))); NumWAKE_basal_10_13(NumWAKE_basal_10_13==0)=NaN;
        NumREM_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}))); NumREM_basal_10_13(NumREM_basal_10_13==0)=NaN;
        NumN1_basal_10_13(i)=length(length(and(substage_basal{i}.Epoch{1},epoch_10_13_basal{i}))); NumN1_basal_10_13(NumN1_basal_10_13==0)=NaN;
        NumN2_basal_10_13(i)=length(length(and(substage_basal{i}.Epoch{2},epoch_10_13_basal{i}))); NumN2_basal_10_13(NumN2_basal_10_13==0)=NaN;
        NumN3_basal_10_13(i)=length(length(and(substage_basal{i}.Epoch{3},epoch_10_13_basal{i}))); NumN3_basal_10_13(NumN3_basal_10_13==0)=NaN;        
        %13-16
        NumSWS_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}))); NumSWS_basal_13_16(NumSWS_basal_13_16==0)=NaN;
        NumWAKE_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}))); NumWAKE_basal_13_16(NumWAKE_basal_13_16==0)=NaN;
        NumREM_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}))); NumREM_basal_13_16(NumREM_basal_13_16==0)=NaN;
        NumN1_basal_13_16(i)=length(length(and(substage_basal{i}.Epoch{1},epoch_13_16_basal{i}))); NumN1_basal_13_16(NumN1_basal_13_16==0)=NaN;
        NumN2_basal_13_16(i)=length(length(and(substage_basal{i}.Epoch{2},epoch_13_16_basal{i}))); NumN2_basal_13_16(NumN2_basal_13_16==0)=NaN;
        NumN3_basal_13_16(i)=length(length(and(substage_basal{i}.Epoch{3},epoch_13_16_basal{i}))); NumN3_basal_13_16(NumN3_basal_13_16==0)=NaN;
        %16-end
        NumSWS_basal_16_end(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i}))); NumSWS_basal_16_end(NumSWS_basal_16_end==0)=NaN;
        NumWAKE_basal_16_end(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i}))); NumWAKE_basal_16_end(NumWAKE_basal_16_end==0)=NaN;
        NumREM_basal_16_end(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i}))); NumREM_basal_16_end(NumREM_basal_16_end==0)=NaN;
        NumN1_basal_16_end(i)=length(length(and(substage_basal{i}.Epoch{1},epoch_16_end_basal{i}))); NumN1_basal_16_end(NumN1_basal_16_end==0)=NaN;
        NumN2_basal_16_end(i)=length(length(and(substage_basal{i}.Epoch{2},epoch_16_end_basal{i}))); NumN2_basal_16_end(NumN2_basal_16_end==0)=NaN;
        NumN3_basal_16_end(i)=length(length(and(substage_basal{i}.Epoch{3},epoch_16_end_basal{i}))); NumN3_basal_16_end(NumN3_basal_16_end==0)=NaN;        
        
        
        %%mean duration
        durWAKE_basal_8_10(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_8_10_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_8_10_basal{i})))/1E4;
        durSWS_basal_8_10(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_8_10_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_8_10_basal{i})))/1E4;
        durREM_basal_8_10(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_8_10_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_8_10_basal{i})))/1E4;
        durN1_basal_8_10(i)=mean(End(and(substage_basal{i}.Epoch{1},epoch_8_10_basal{i}))-Start(and(substage_basal{i}.Epoch{1},epoch_8_10_basal{i})))/1E4;
        durN2_basal_8_10(i)=mean(End(and(substage_basal{i}.Epoch{2},epoch_8_10_basal{i}))-Start(and(substage_basal{i}.Epoch{2},epoch_8_10_basal{i})))/1E4;
        durN3_basal_8_10(i)=mean(End(and(substage_basal{i}.Epoch{3},epoch_8_10_basal{i}))-Start(and(substage_basal{i}.Epoch{3},epoch_8_10_basal{i})))/1E4;
        durWAKE_basal_8_10(durWAKE_basal_8_10==0)=NaN;
        durSWS_basal_8_10(durSWS_basal_8_10==0)=NaN;
        durREM_basal_8_10(durREM_basal_8_10==0)=NaN;
        durN1_basal_8_10(durN1_basal_8_10==0)=NaN;
        durN2_basal_8_10(durN2_basal_8_10==0)=NaN;
        durN3_basal_8_10(durN3_basal_8_10==0)=NaN;
        %10am 1 pm
        durWAKE_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i})))/1E4;
        durSWS_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i})))/1E4;
        durREM_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i})))/1E4;
        durN1_basal_10_13(i)=mean(End(and(substage_basal{i}.Epoch{1},epoch_10_13_basal{i}))-Start(and(substage_basal{i}.Epoch{1},epoch_10_13_basal{i})))/1E4;
        durN2_basal_10_13(i)=mean(End(and(substage_basal{i}.Epoch{2},epoch_10_13_basal{i}))-Start(and(substage_basal{i}.Epoch{2},epoch_10_13_basal{i})))/1E4;
        durN3_basal_10_13(i)=mean(End(and(substage_basal{i}.Epoch{3},epoch_10_13_basal{i}))-Start(and(substage_basal{i}.Epoch{3},epoch_10_13_basal{i})))/1E4;
        durWAKE_basal_10_13(durWAKE_basal_10_13==0)=NaN;
        durSWS_basal_10_13(durSWS_basal_10_13==0)=NaN;
        durREM_basal_10_13(durREM_basal_10_13==0)=NaN;
        durN1_basal_10_13(durN1_basal_10_13==0)=NaN;
        durN2_basal_10_13(durN2_basal_10_13==0)=NaN;
        durN3_basal_10_13(durN3_basal_10_13==0)=NaN;
        %1pm 4pm
        durWAKE_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i})))/1E4;
        durSWS_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i})))/1E4;
        durREM_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i})))/1E4;
        durN1_basal_13_16(i)=mean(End(and(substage_basal{i}.Epoch{1},epoch_13_16_basal{i}))-Start(and(substage_basal{i}.Epoch{1},epoch_13_16_basal{i})))/1E4;
        durN2_basal_13_16(i)=mean(End(and(substage_basal{i}.Epoch{2},epoch_13_16_basal{i}))-Start(and(substage_basal{i}.Epoch{2},epoch_13_16_basal{i})))/1E4;
        durN3_basal_13_16(i)=mean(End(and(substage_basal{i}.Epoch{3},epoch_13_16_basal{i}))-Start(and(substage_basal{i}.Epoch{3},epoch_13_16_basal{i})))/1E4;
        durWAKE_basal_13_16(durWAKE_basal_13_16==0)=NaN;
        durSWS_basal_13_16(durSWS_basal_13_16==0)=NaN;
        durREM_basal_13_16(durREM_basal_13_16==0)=NaN;
        durN1_basal_13_16(durN1_basal_13_16==0)=NaN;
        durN2_basal_13_16(durN2_basal_13_16==0)=NaN;
        durN3_basal_13_16(durN3_basal_13_16==0)=NaN;
        %4pm end
        durWAKE_basal_16_end(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i})))/1E4;
        durSWS_basal_16_end(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i})))/1E4;
        durREM_basal_16_end(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i})))/1E4;
        durN1_basal_16_end(i)=mean(End(and(substage_basal{i}.Epoch{1},epoch_16_end_basal{i}))-Start(and(substage_basal{i}.Epoch{1},epoch_16_end_basal{i})))/1E4;
        durN2_basal_16_end(i)=mean(End(and(substage_basal{i}.Epoch{2},epoch_16_end_basal{i}))-Start(and(substage_basal{i}.Epoch{2},epoch_16_end_basal{i})))/1E4;
        durN3_basal_16_end(i)=mean(End(and(substage_basal{i}.Epoch{3},epoch_16_end_basal{i}))-Start(and(substage_basal{i}.Epoch{3},epoch_16_end_basal{i})))/1E4;
        durWAKE_basal_16_end(durWAKE_basal_16_end==0)=NaN;
        durSWS_basal_16_end(durSWS_basal_16_end==0)=NaN;
        durREM_basal_16_end(durREM_basal_16_end==0)=NaN;
        durN1_basal_16_end(durN1_basal_16_end==0)=NaN;
        durN2_basal_16_end(durN2_basal_16_end==0)=NaN;
        durN3_basal_16_end(durN3_basal_16_end==0)=NaN;
    
    else
    end
end



%% figures
%% general sleep
pts = 0;
line_pts = 1;
col_basal = [.4 .4 .4];

figure
subplot(433)
MakeBoxPlot_MC({percREM_totSleep_basal_8_10 percREM_totSleep_basal_10_13, percREM_totSleep_basal_13_16 percREM_totSleep_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('REM percentage (%)')
title('/ total sleep')


subplot(434)
MakeBoxPlot_MC({percWAKE_basal_8_10 percWAKE_basal_10_13, percWAKE_basal_13_16 percWAKE_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('Wake percentage (%)')
% p=ranksum(percWAKE_basal_10_13, percWAKE_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(435)
MakeBoxPlot_MC({percSWS_basal_8_10 percSWS_basal_10_13, percSWS_basal_13_16 percSWS_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('NREM percentage (%)')
% p=ranksum(percSWS_basal_10_13, percSWS_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(436)
MakeBoxPlot_MC({percREM_basal_8_10 percREM_basal_10_13, percREM_basal_13_16 percREM_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('REM percentage (%)')
title('/ total session')
% p=ranksum(percREM_basal_10_13, percREM_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(437)
MakeBoxPlot_MC({NumWAKE_basal_8_10 NumWAKE_basal_10_13, NumWAKE_basal_13_16 NumWAKE_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('# Wake bouts')
% p=ranksum(NumWAKE_basal_10_13, NumWAKE_basal_post);
% title(['p=',' ',num2str(p),' '])

subplot(438)
MakeBoxPlot_MC({NumSWS_basal_8_10 NumSWS_basal_10_13, NumSWS_basal_13_16 NumSWS_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('# NREM bouts')
% p=ranksum(NumSWS_basal_10_13, NumSWS_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(439)
MakeBoxPlot_MC({NumREM_basal_8_10 NumREM_basal_10_13, NumREM_basal_13_16 NumREM_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('# REM bouts')
% p=ranksum(NumREM_basal_10_13, NumREM_basal_post);
% title(['p=',' ',num2str(p),' '])

subplot(4,3,10)
MakeBoxPlot_MC({durWAKE_basal_8_10 durWAKE_basal_10_13, durWAKE_basal_13_16 durWAKE_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('Mean duration of Wake (s)')
% p=ranksum(durWAKE_basal_10_13, durWAKE_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(4,3,11)
MakeBoxPlot_MC({durSWS_basal_8_10 durSWS_basal_10_13, durSWS_basal_13_16 durSWS_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('Mean duration of NREM (s)')
% p=ranksum(durSWS_basal_10_13, durSWS_basal_13_16);
% title(['p=',' ',num2str(p),' '])

subplot(4,3,12)
MakeBoxPlot_MC({durREM_basal_8_10 durREM_basal_10_13, durREM_basal_13_16 durREM_basal_16_end},...
    {col_basal col_basal  col_basal col_basal},[1:4],{},pts,line_pts);
xticks([1:4]); xticklabels({'start-10','10-13','13-16','16-end'})
ylabel('Mean duration of REM (s)')

% p=ranksum(durREM_basal_10_13, durREM_basal_13_16);
% title(['p=',' ',num2str(p),' '])


%% substages
figure
subplot(434)
MakeBoxPlot_MC({percN1_basal_8_10 percN1_basal_10_13, percN1_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('N1 percentage (%)')

subplot(435)
MakeBoxPlot_MC({percN2_basal_8_10 percN2_basal_10_13, percN2_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('N2 percentage (%)')


subplot(436)
MakeBoxPlot_MC({percN3_basal_8_10 percN3_basal_10_13, percN3_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('N3 percentage (%)')

subplot(437)
MakeBoxPlot_MC({NumN1_basal_8_10 NumN1_basal_10_13, NumN1_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('# N1 bouts')


subplot(438)
MakeBoxPlot_MC({NumN2_basal_8_10 NumN2_basal_10_13, NumN2_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('# N2 bouts')


subplot(439)
MakeBoxPlot_MC({NumN3_basal_8_10 NumN3_basal_10_13, NumN3_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('# N3 bouts')

subplot(4,3,10)
MakeBoxPlot_MC({durN1_basal_8_10 durN1_basal_10_13, durN1_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('Mean duration of N1 (s)')


subplot(4,3,11)
MakeBoxPlot_MC({durN2_basal_8_10 durN2_basal_10_13, durN2_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('Mean duration of N2 (s)')


subplot(4,3,12)
MakeBoxPlot_MC({durN3_basal_8_10 durN3_basal_10_13, durN3_basal_13_16},...
    {col_basal col_basal  col_basal },[1:3],{},1,0);
xticks([1:3]); xticklabels({'start-10','10-13','13-16'})
ylabel('Mean duration of N3 (s)')
