% %% input dir basal sleep
% DirBasal_dreadd = PathForExperiments_DREADD_MC('dreadd_PFC_BaselineSleep');
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirBasal_atrop = PathForExperimentsAtropine_MC('BaselineSleep');
% DirBasal1 = MergePathForExperiment(DirBasal_dreadd,DirBasal_opto);
% DirBasal2 = MergePathForExperiment(DirBasal_SD,DirBasal_atrop);
% DirMyBasal = MergePathForExperiment(DirBasal1,DirBasal2);
% 
%% parameters
% en_epoch_preInj = 1.5*1E8;
% st_epoch_postInj = 1.65*1E8;

%% get data BASELINE sleep
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    
    sleep_stages_basal{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
%     sleep_stages_basal{i}.SWSEpoch = mergeCloseIntervals(sleep_stages_basal{i}.SWSEpoch, 1e4);
%     sleep_stages_basal{i}.REMEpoch = mergeCloseIntervals(sleep_stages_basal{i}.REMEpoch, 1e4);
%     sleep_stages_basal{i}.Wake = mergeCloseIntervals(sleep_stages_basal{i}.Wake, 1e4);
    
    durtotal_basal{i} = max([max(End(sleep_stages_basal{i}.Wake)),max(End(sleep_stages_basal{i}.SWSEpoch))]);
    epoch_10_end_basal{i} = intervalSet(0.5*1e8,3*1e8);

    %%load substages
%     if exist('SleepSubstages.mat')==2
%         substage_basal{i} = load('SleepSubstages.mat'); %%SWS : 7, WAKE : 4, REM : 5, N1 : 1, N2 : 2, N3 : 3
        %%periods of time
        durtotal_basal{i} = max([max(End(sleep_stages_basal{i}.Wake)),max(End(sleep_stages_basal{i}.SWSEpoch))]);
        %10am to 1pm
%         epoch_10_13_basal{i} = intervalSet(0.5*1E8, 0.5*1E8+3*3600*1E4);
%         epoch_10_13_basal{i} = intervalSet(0.5*1E8, 1.5*1E8);
        epoch_10_13_basal{i} = intervalSet(0.5*1E8, 1.5*1E8);
        %10am to end
        epoch_10_end_basal{i} = intervalSet(0.5*1e8,durtotal_basal{i});
%         epoch_10_end_basal{i} = intervalSet(0.55*1E8,durtotal_basal{i});

        
        
        %1pm to 4pm
        epoch_13_16_basal{i} = intervalSet(1.5*1E8,2.5*1E8);
        %1pm to end
        epoch_13_end_basal{i} = intervalSet(1.5*1E8,durtotal_basal{i});
        %4pm to end
        epoch_16_end_basal{i}=intervalSet(2.5*1E8,durtotal_basal{i});

        
        
        
        %%duration stages
        %10-end
        [durWake_10_end_basal{i},durTWake_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i}),'s');
        [durSWS_10_end_basal{i},durTSWS_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i}),'s');
        [durREM_10_end_basal{i},durTREM_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}),'s');
%         [durTOTsleep_10_end_basal{i},durTTOTsleep_10_end_basal(i)]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_10_end_basal{i}),'s');
        %10-13
        [durWake_10_13_basal{i},durTWake_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}),'s');
        [durSWS_10_13_basal{i},durTSWS_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}),'s');
        [durREM_10_13_basal{i},durTREM_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}),'s');
%         [durTOTsleep_10_13_basal{i},durTTOTsleep_10_13_basal(i)]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_10_13_basal{i}),'s');
        %13-16
        [durWake_13_16_basal{i},durTWake_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}),'s');
        [durSWS_13_16_basal{i},durTSWS_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}),'s');
        [durREM_13_16_basal{i},durTREM_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}),'s');
%         [durTOTsleep_13_16_basal{i},durTTOTsleep_13_16_basal(i)]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_13_16_basal{i}),'s');
        %13-end
        [durWake_13_end_basal{i},durTWake_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i}),'s');
        [durSWS_13_end_basal{i},durTSWS_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}),'s');
        [durREM_13_end_basal{i},durTREM_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}),'s');
%         [durTOTsleep_16_en_basal{i},durTTOTsleep_13_end_basal(i)]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_13_end_basal{i}),'s');
       
        %16-end
        [durWake_16_end_basal{i},durTWake_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i}),'s');
        [durSWS_16_end_basal{i},durTSWS_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i}),'s');
        [durREM_16_end_basal{i},durTREM_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i}),'s');
%         [durTOTsleep_16_en_basal{i},durTTOTsleep_16_end_basal(i)]=DurationEpoch(and(substage_basal{i}.Epoch{10},epoch_16_end_basal{i}),'s');        
        
        
        
        
        
        
        
        
        
        
        
        %%compute percentage
        percWAKE_basal_10_end(i) = durTWake_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durTREM_10_end_basal(i))*100; percWAKE_basal_10_end(percWAKE_basal_10_end==0)=NaN;
        percSWS_basal_10_end(i) = durTSWS_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durTREM_10_end_basal(i))*100; percSWS_basal_10_end(percSWS_basal_10_end==0)=NaN;
        percREM_basal_10_end(i) = durTREM_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durTREM_10_end_basal(i))*100; percREM_basal_10_end(percREM_basal_10_end==0)=NaN;
        percREM_totSleep_basal_10_end(i) = durTREM_10_end_basal(i)/(durTSWS_10_end_basal(i)+durTREM_10_end_basal(i))*100; percREM_totSleep_basal_10_end(percREM_totSleep_basal_10_end==0)=NaN;
        %start-10
        percWAKE_basal_10_13(i) = durTWake_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durTREM_10_13_basal(i))*100;  percWAKE_basal_10_13(percWAKE_basal_10_13==0)=NaN;
        percSWS_basal_10_13(i) = durTSWS_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durTREM_10_13_basal(i))*100; percSWS_basal_10_13(percSWS_basal_10_13==0)=NaN;
        percREM_basal_10_13(i) = durTREM_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durTREM_10_13_basal(i))*100; percREM_basal_10_13(percREM_basal_10_13==0)=NaN;
        percREM_totSleep_basal_10_13(i) = durTREM_10_13_basal(i)/(durTSWS_10_13_basal(i)+durTREM_10_13_basal(i))*100; percREM_totSleep_basal_10_13(percREM_totSleep_basal_10_13==0)=NaN;
        %13-16
        percWAKE_basal_13_16(i)=durTWake_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durTREM_13_16_basal(i))*100; percWAKE_basal_13_16(percWAKE_basal_13_16==0)=NaN;
        percSWS_basal_13_16(i)=durTSWS_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durTREM_13_16_basal(i))*100; percSWS_basal_13_16(percSWS_basal_13_16==0)=NaN;
        percREM_basal_13_16(i)=durTREM_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durTREM_13_16_basal(i))*100; percREM_basal_13_16(percREM_basal_13_16==0)=NaN;
        percREM_totSleep_basal_13_16(i)=durTREM_13_16_basal(i)/(durTSWS_13_16_basal(i)+durTREM_13_16_basal(i))*100; percREM_totSleep_basal_13_16(percREM_totSleep_basal_13_16==0)=NaN;
        %16-end
        percWAKE_basal_13_end(i)=durTWake_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durTREM_13_end_basal(i))*100; percWAKE_basal_13_end(percWAKE_basal_13_end==0)=NaN;
        percSWS_basal_13_end(i)=durTSWS_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durTREM_13_end_basal(i))*100; percSWS_basal_13_end(percSWS_basal_13_end==0)=NaN;
        percREM_basal_13_end(i)=durTREM_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durTREM_13_end_basal(i))*100; percREM_basal_13_end(percREM_basal_13_end==0)=NaN;
        percREM_totSleep_basal_13_end(i)=durTREM_13_end_basal(i)/(durTSWS_13_end_basal(i)+durTREM_13_end_basal(i))*100; percREM_totSleep_basal_13_end(percREM_totSleep_basal_13_end==0)=NaN;
        
        
        %%number
        %start-10
        NumSWS_basal_10_end(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i}))); NumSWS_basal_10_end(NumSWS_basal_10_end==0)=NaN;
        NumWAKE_basal_10_end(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i}))); NumWAKE_basal_10_end(NumWAKE_basal_10_end==0)=NaN;
        NumREM_basal_10_end(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}))); NumREM_basal_10_end(NumREM_basal_10_end==0)=NaN;
        %10-13
        NumSWS_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}))); NumSWS_basal_10_13(NumSWS_basal_10_13==0)=NaN;
        NumWAKE_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}))); NumWAKE_basal_10_13(NumWAKE_basal_10_13==0)=NaN;
        NumREM_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}))); NumREM_basal_10_13(NumREM_basal_10_13==0)=NaN;
        %13-16
        NumSWS_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}))); NumSWS_basal_13_16(NumSWS_basal_13_16==0)=NaN;
        NumWAKE_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}))); NumWAKE_basal_13_16(NumWAKE_basal_13_16==0)=NaN;
        NumREM_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}))); NumREM_basal_13_16(NumREM_basal_13_16==0)=NaN;
        %16-end
        NumSWS_basal_13_end(i)=length(length(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}))); NumSWS_basal_13_end(NumSWS_basal_13_end==0)=NaN;
        NumWAKE_basal_13_end(i)=length(length(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i}))); NumWAKE_basal_13_end(NumWAKE_basal_13_end==0)=NaN;
        NumREM_basal_13_end(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}))); NumREM_basal_13_end(NumREM_basal_13_end==0)=NaN;
        
        
        %%mean duration
        durWAKE_basal_10_end(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i})))/1E4;
        durSWS_basal_10_end(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i})))/1E4;
        durREM_basal_10_end(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i})))/1E4;
        durWAKE_basal_10_end(durWAKE_basal_10_end==0)=NaN;
        durSWS_basal_10_end(durSWS_basal_10_end==0)=NaN;
        durREM_basal_10_end(durREM_basal_10_end==0)=NaN;
        %10am 1 pm
        durWAKE_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i})))/1E4;
        durSWS_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i})))/1E4;
        durREM_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i})))/1E4;
        durWAKE_basal_10_13(durWAKE_basal_10_13==0)=NaN;
        durSWS_basal_10_13(durSWS_basal_10_13==0)=NaN;
        durREM_basal_10_13(durREM_basal_10_13==0)=NaN;
  
        %1pm 4pm
        durWAKE_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i})))/1E4;
        durSWS_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i})))/1E4;
        durREM_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i})))/1E4;
        durWAKE_basal_13_16(durWAKE_basal_13_16==0)=NaN;
        durSWS_basal_13_16(durSWS_basal_13_16==0)=NaN;
        durREM_basal_13_16(durREM_basal_13_16==0)=NaN;
 
        %4pm end
        durWAKE_basal_13_end(i)=mean(End(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i}))-Start(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i})))/1E4;
        durSWS_basal_13_end(i)=mean(End(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}))-Start(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i})))/1E4;
        durREM_basal_13_end(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i})))/1E4;
        durWAKE_basal_13_end(durWAKE_basal_13_end==0)=NaN;
        durSWS_basal_13_end(durSWS_basal_13_end==0)=NaN;
        durREM_basal_13_end(durREM_basal_13_end==0)=NaN;

    
%     else
%     end
end

