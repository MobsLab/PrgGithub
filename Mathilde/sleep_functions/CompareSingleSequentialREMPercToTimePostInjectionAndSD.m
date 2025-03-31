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
        %10am to 1pm
        epoch_10_13_basal{i} = intervalSet(0.55*1E8, 1.5*1E8);
        %10am to end
        epoch_10_end_basal{i} = intervalSet(0.55*1E8,durtotal_basal{i});
        %1pm to 4pm
        epoch_13_16_basal{i} = intervalSet(1.5*1E8,2.5*1E8);
        %1pm to end
        epoch_13_end_basal{i} = intervalSet(1.5*1E8,durtotal_basal{i});
        %4pm to end
        epoch_16_end_basal{i}=intervalSet(2.5*1E8,durtotal_basal{i});
        
        [Seq_REMEpoch_basal{i},Single_REMEpoch_basal{i}] = Find_single_sequential_REM_MC(sleep_stages_basal{i}.Wake,sleep_stages_basal{i}.SWSEpoch,sleep_stages_basal{i}.REMEpoch);

        %%duration stages
        %10-end
        [durWake_10_end_basal{i},durTWake_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_10_end_basal{i}),'s');
        [durSWS_10_end_basal{i},durTSWS_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_end_basal{i}),'s');
        [dur_total_REM_10_end_basal{i},durT_total_REM_10_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}),'s');
        [dur_seq_REM_10_end_basal{i},durT_seq_REM_10_end_basal(i)]=DurationEpoch(and(Seq_REMEpoch_basal{i},epoch_10_end_basal{i}),'s');
        [dur_sing_REM_10_end_basal{i},durT_sing_REM_10_end_basal(i)]=DurationEpoch(and(Single_REMEpoch_basal{i},epoch_10_end_basal{i}),'s');
        %10-13
        [durWake_10_13_basal{i},durTWake_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_10_13_basal{i}),'s');
        [durSWS_10_13_basal{i},durTSWS_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_10_13_basal{i}),'s');
        [dur_total_REM_10_13_basal{i},durT_total_REM_10_13_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}),'s');
        [dur_seq_REM_10_13_basal{i},durT_seq_REM_10_13_basal(i)]=DurationEpoch(and(Seq_REMEpoch_basal{i},epoch_10_13_basal{i}),'s');
        [dur_sing_REM_10_13_basal{i},durT_sing_REM_10_13_basal(i)]=DurationEpoch(and(Single_REMEpoch_basal{i},epoch_10_13_basal{i}),'s');
        %13-16
        [durWake_13_16_basal{i},durTWake_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_13_16_basal{i}),'s');
        [durSWS_13_16_basal{i},durTSWS_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_16_basal{i}),'s');
        [dur_total_REM_13_16_basal{i},durT_total_REM_13_16_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}),'s');
        [dur_seq_REM_13_16_basal{i},durT_seq_REM_13_16_basal(i)]=DurationEpoch(and(Seq_REMEpoch_basal{i},epoch_13_16_basal{i}),'s');
        [dur_sing_REM_13_16_basal{i},durT_sing_REM_13_16_basal(i)]=DurationEpoch(and(Single_REMEpoch_basal{i},epoch_13_16_basal{i}),'s');
        %13-end
        [durWake_13_end_basal{i},durTWake_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_13_end_basal{i}),'s');
        [durSWS_13_end_basal{i},durTSWS_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_13_end_basal{i}),'s');
        [dur_total_REM_13_end_basal{i},durT_total_REM_13_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}),'s');
        [dur_seq_REM_13_end_basal{i},durT_seq_REM_13_end_basal(i)]=DurationEpoch(and(Seq_REMEpoch_basal{i},epoch_13_end_basal{i}),'s');
        [dur_sing_REM_13_end_basal{i},durT_sing_REM_13_end_basal(i)]=DurationEpoch(and(Single_REMEpoch_basal{i},epoch_13_end_basal{i}),'s');
        %16-end
        [durWake_16_end_basal{i},durTWake_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.Wake,epoch_16_end_basal{i}),'s');
        [durSWS_16_end_basal{i},durTSWS_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.SWSEpoch,epoch_16_end_basal{i}),'s');
        [dur_total_REM_16_end_basal{i},durT_total_REM_16_end_basal(i)]=DurationEpoch(and(sleep_stages_basal{i}.REMEpoch,epoch_16_end_basal{i}),'s');
        [dur_seq_REM_16_end_basal{i},durT_seq_REM_16_end_basal(i)]=DurationEpoch(and(Seq_REMEpoch_basal{i},epoch_16_end_basal{i}),'s');
        [dur_sing_REM_16_end_basal{i},durT_sing_REM_16_end_basal(i)]=DurationEpoch(and(Single_REMEpoch_basal{i},epoch_16_end_basal{i}),'s');
                
        %%compute percentage
        perc_total_REM_basal_10_end(i) = durT_total_REM_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100;
        perc_seq_REM_basal_10_end(i) = durT_seq_REM_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100;
        perc_sing_REM_basal_10_end(i) = durT_sing_REM_10_end_basal(i)/(durTWake_10_end_basal(i)+durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100;
        perc_total_REM_totSleep_basal_10_end(i) = durT_total_REM_10_end_basal(i)/(durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100; 
        perc_seq_REM_totSleep_basal_10_end(i) = durT_seq_REM_10_end_basal(i)/(durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100; 
        perc_sing_REM_totSleep_basal_10_end(i) = durT_sing_REM_10_end_basal(i)/(durTSWS_10_end_basal(i)+durT_total_REM_10_end_basal(i))*100; 
        %start-10
        perc_total_REM_basal_10_13(i) = durT_total_REM_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100; 
        perc_seq_REM_basal_10_13(i) = durT_seq_REM_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100; 
        perc_sing_REM_basal_10_13(i) = durT_sing_REM_10_13_basal(i)/(durTWake_10_13_basal(i)+durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100; 
        perc_total_REM_totSleep_basal_10_13(i) = durT_total_REM_10_13_basal(i)/(durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100;
        perc_seq_REM_totSleep_basal_10_13(i) = durT_seq_REM_10_13_basal(i)/(durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100;
        perc_sing_REM_totSleep_basal_10_13(i) = durT_sing_REM_10_13_basal(i)/(durTSWS_10_13_basal(i)+durT_total_REM_10_13_basal(i))*100;
        %13-16
        perc_total_REM_basal_13_16(i)=durT_total_REM_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100;
        perc_seq_REM_basal_13_16(i)=durT_seq_REM_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100;
        perc_sing_REM_basal_13_16(i)=durT_sing_REM_13_16_basal(i)/(durTWake_13_16_basal(i)+durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100;
        perc_total_REM_totSleep_basal_13_16(i)=durT_total_REM_13_16_basal(i)/(durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100; 
        perc_seq_REM_totSleep_basal_13_16(i)=durT_seq_REM_13_16_basal(i)/(durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100; 
        perc_sing_REM_totSleep_basal_13_16(i)=durT_sing_REM_13_16_basal(i)/(durTSWS_13_16_basal(i)+durT_total_REM_13_16_basal(i))*100; 
        %16-end
        perc_total_REM_basal_13_end(i)=durT_total_REM_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
        perc_seq_REM_basal_13_end(i)=durT_seq_REM_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
        perc_sing_REM_basal_13_end(i)=durT_sing_REM_13_end_basal(i)/(durTWake_13_end_basal(i)+durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
        perc_total_REM_totSleep_basal_13_end(i)=durT_total_REM_13_end_basal(i)/(durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
        perc_seq_REM_totSleep_basal_13_end(i)=durT_seq_REM_13_end_basal(i)/(durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
        perc_sing_REM_totSleep_basal_13_end(i)=durT_sing_REM_13_end_basal(i)/(durTSWS_13_end_basal(i)+durT_total_REM_13_end_basal(i))*100;
      
        
        %%number
        %start-10
        Num_total_REM_basal_10_end(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i})));
        Num_seq_REM_basal_10_end(i)=length(length(and(Seq_REMEpoch_basal{i},epoch_10_end_basal{i})));
        Num_sing_REM_basal_10_end(i)=length(length(and(Single_REMEpoch_basal{i},epoch_10_end_basal{i})));
        %10-13
        Num_total_REM_basal_10_13(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i})));
        Num_seq_REM_basal_10_13(i)=length(length(and(Seq_REMEpoch_basal{i},epoch_10_13_basal{i})));
        Num_sing_REM_basal_10_13(i)=length(length(and(Single_REMEpoch_basal{i},epoch_10_13_basal{i})));
        %13-16
        Num_total_REM_basal_13_16(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i})));
        Num_seq_REM_basal_13_16(i)=length(length(and(Seq_REMEpoch_basal{i},epoch_13_16_basal{i})));
        Num_sing_REM_basal_13_16(i)=length(length(and(Single_REMEpoch_basal{i},epoch_13_16_basal{i})));
        %16-end
        Num_total_REM_basal_13_end(i)=length(length(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i})));
        Num_seq_REM_basal_13_end(i)=length(length(and(Seq_REMEpoch_basal{i},epoch_13_end_basal{i})));
        Num_sing_REM_basal_13_end(i)=length(length(and(Single_REMEpoch_basal{i},epoch_13_end_basal{i})));

        %%mean duration
        dur_total_REM_basal_10_end(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_10_end_basal{i})))/1E4;
        dur_seq_REM_basal_10_end(i)=mean(End(and(Seq_REMEpoch_basal{i},epoch_10_end_basal{i}))-Start(and(Seq_REMEpoch_basal{i},epoch_10_end_basal{i})))/1E4;
        dur_sing_REM_basal_10_end(i)=mean(End(and(Single_REMEpoch_basal{i},epoch_10_end_basal{i}))-Start(and(Single_REMEpoch_basal{i},epoch_10_end_basal{i})))/1E4;
        %10am 1 pm
        dur_total_REM_basal_10_13(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_10_13_basal{i})))/1E4;
        dur_seq_REM_basal_10_13(i)=mean(End(and(Seq_REMEpoch_basal{i},epoch_10_13_basal{i}))-Start(and(Seq_REMEpoch_basal{i},epoch_10_13_basal{i})))/1E4;
        dur_sing_REM_basal_10_13(i)=mean(End(and(Single_REMEpoch_basal{i},epoch_10_13_basal{i}))-Start(and(Single_REMEpoch_basal{i},epoch_10_13_basal{i})))/1E4;
        %1pm 4pm
        dur_total_REM_basal_13_16(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_16_basal{i})))/1E4;
        dur_seq_REM_basal_13_16(i)=mean(End(and(Seq_REMEpoch_basal{i},epoch_13_16_basal{i}))-Start(and(Seq_REMEpoch_basal{i},epoch_13_16_basal{i})))/1E4;
        dur_single_REM_basal_13_16(i)=mean(End(and(Single_REMEpoch_basal{i},epoch_13_16_basal{i}))-Start(and(Single_REMEpoch_basal{i},epoch_13_16_basal{i})))/1E4;
        %4pm end
        dur_total_REM_basal_13_end(i)=mean(End(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i}))-Start(and(sleep_stages_basal{i}.REMEpoch,epoch_13_end_basal{i})))/1E4;
        dur_seq_REM_basal_13_end(i)=mean(End(and(Seq_REMEpoch_basal{i},epoch_13_end_basal{i}))-Start(and(Seq_REMEpoch_basal{i},epoch_13_end_basal{i})))/1E4;
        dur_sing_REM_basal_13_end(i)=mean(End(and(Single_REMEpoch_basal{i},epoch_13_end_basal{i}))-Start(and(Single_REMEpoch_basal{i},epoch_13_end_basal{i})))/1E4;
       
    
    else
    end
end
