%% input dir
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');
% % DirSocialDefeat=RestrictPathForExperiment(DirSocialDefeat,'nMice',[1148 1149 1150]);
% DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD_inhibitionPFC');
% 
% DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
% DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
% DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
% DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
% 
% Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
% 
% DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);
% 
% DirLabBasal=PathForExperiments_BaselineSleep_MC('BaselineSleep');
% DirBasal=MergePathForExperiment(DirMyBasal,DirLabBasal);


%% input dir
DirSocialDefeat = PathForExperimentsSD_MC('SleepPostSD');


%%dir baseline sleep
DirBasal_opto = PathForExperiments_Opto_MC('PFC_Baseline');
DirBasal_opto=RestrictPathForExperiment(DirBasal_opto,'nMice',[1076 1109]);
DirBasal_SD = PathForExperimentsSD_MC('BaselineSleep');
DirMyBasal = MergePathForExperiment(DirBasal_opto,DirBasal_SD);
Dir_dreadd = PathForExperiments_DREADD_MC('OneInject_Nacl');
DirMyBasal = MergePathForExperiment(DirMyBasal,Dir_dreadd);

%% get the data

%%lab baseline
for i=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{i}{1});
    
    if exist('SleepScoring_OBGamma.mat')
        a{i} = load('SleepScoring_OBGamma', 'REMEpoch', 'SWSEpoch', 'Wake');
    elseif exist('SleepScoring_Accelero.mat')
        a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
    else
    end

if exist('SleepScoring_OBGamma.mat') || exist('SleepScoring_Accelero.mat')
    
    
%     if exist('SleepScoring_Accelero.mat')
%         a{i} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        
        durtotal_basal{i} = max([max(End(a{i}.Wake)),max(End(a{i}.SWSEpoch))]);        
        
        %3 hours following first sleep episode
[tpsFirstREM, tpsFirstSWS]= FindLatencySleep_v2_MC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch,5,20); tpsFirstSleep{i}=tpsFirstSWS;
% epoch_2hSleepy{i}=intervalSet(tpsFirstSleep{i}*1e4,tpsFirstSleep{i}*1e4+2*3600*1E4);
%         epoch_3hPostSD_LabBasal{i}=intervalSet(tpsFirstSleep{i}*1e4,tpsFirstSleep{i}*1e4+3*3600*1E4);
        
        %3h post injection
        epoch_3hPostSD_LabBasal{i}=intervalSet(0,3*3600*1E4);
        % end of the 3h post SD up to the end of the session
%         epoch_endPostSD_LabBasal{i}=intervalSet(End(epoch_3hPostSD_LabBasal{i}),durtotal_basal{i});

        
        % Res(1,:) donne le Wake
        % Res(2,:) donne le SWS
        % Res(3,:) donne le REM
        % Res(x,1) total
        % Res(x,2) première moitié
        % Res(x,3) deuxième moitié
        % Res(x,4) 3h post injection
        % Res(x,5) les 3 première heures
        % Res(x,6) des 3h premières heures à la fin
        
        if isempty(a{i})==0
            %percentage all sleep session
            SleepStagePerc_totSess_LabBasal1{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
            percWAKE_totSess_LabBasal(i) = SleepStagePerc_totSess_LabBasal1{i}(1,1); percWAKE_totSess_LabBasal(percWAKE_totSess_LabBasal==0)=NaN;
            percSWS_totSess_LabBasal(i) = SleepStagePerc_totSess_LabBasal1{i}(2,1); percSWS_totSess_LabBasal(percSWS_totSess_LabBasal==0)=NaN;
            percREM_totSess_LabBasal(i) = SleepStagePerc_totSess_LabBasal1{i}(3,1); percREM_totSess_LabBasal(percREM_totSess_LabBasal==0)=NaN;
            %percentage 3h after SD
            SleepStagePerc_totSess_LabBasal2{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
            percWAKE_totSess_LabBasal_3hPostSD(i) = SleepStagePerc_totSess_LabBasal2{i}(1,5); percWAKE_totSess_LabBasal_3hPostSD(percWAKE_totSess_LabBasal_3hPostSD==0)=NaN;
            percSWS_totSess_LabBasal_3hPostSD(i) = SleepStagePerc_totSess_LabBasal2{i}(2,5); percSWS_totSess_LabBasal_3hPostSD(percSWS_totSess_LabBasal_3hPostSD==0)=NaN;
            percREM_totSess_LabBasal_3hPostSD(i) = SleepStagePerc_totSess_LabBasal2{i}(3,5); percREM_totSess_LabBasal_3hPostSD(percREM_totSess_LabBasal_3hPostSD==0)=NaN;
            
            
            %percentage all sleep session
            SleepStagePerc_totSleep_LabBasal1{i} = ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
            percWAKE_totSleep_LabBasal(i) = SleepStagePerc_totSleep_LabBasal1{i}(1,1); percWAKE_totSleep_LabBasal(percWAKE_totSleep_LabBasal==0)=NaN;
            percSWS_totSleep_LabBasal(i) = SleepStagePerc_totSleep_LabBasal1{i}(2,1); percSWS_totSleep_LabBasal(percSWS_totSleep_LabBasal==0)=NaN;
            percREM_totSleep_LabBasal(i) = SleepStagePerc_totSleep_LabBasal1{i}(3,1); percREM_totSleep_LabBasal(percREM_totSleep_LabBasal==0)=NaN;
            %percentage 3h after SD
            SleepStagePerc_totSleep_LabBasal2{i} = ComputeSleepStagesPercentagesWithoutWakeMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
            percWAKE_totSleep_LabBasal_3hPostSD(i) = SleepStagePerc_totSleep_LabBasal2{i}(1,5); percWAKE_totSleep_LabBasal_3hPostSD(percWAKE_totSleep_LabBasal_3hPostSD==0)=NaN;
            percSWS_totSleep_LabBasal_3hPostSD(i) = SleepStagePerc_totSleep_LabBasal2{i}(2,5); percSWS_totSleep_LabBasal_3hPostSD(percSWS_totSleep_LabBasal_3hPostSD==0)=NaN;
            percREM_totSleep_LabBasal_3hPostSD(i) = SleepStagePerc_totSleep_LabBasal2{i}(3,5); percREM_totSleep_LabBasal_3hPostSD(percREM_totSleep_LabBasal_3hPostSD==0)=NaN;
            
            
            
            
%             %percentage end of the 3h post SD up to the end of the session
%             SleepStagePerc_LabBasal3{i} = ComputeSleepStagesPercentagesMC(a{i}.Wake,a{i}.SWSEpoch,a{i}.REMEpoch);
%             percWAKE_LabBasal_end(i) = SleepStagePerc_LabBasal3{i}(1,6); %percWAKE_LabBasal_end(percWAKE_LabBasal_end==0)=NaN;
%             percSWS_LabBasal_end(i) = SleepStagePerc_LabBasal3{i}(2,6); %percSWS_LabBasal_end(percSWS_LabBasal_end==0)=NaN;
%             percREM_LabBasal_end(i) = SleepStagePerc_LabBasal3{i}(3,6); %percREM_LabBasal_end(percREM_LabBasal_end==0)=NaN;
            
            %number of  bouts all sleep session
            NumWAKE_LabBasal(i) = length(length(a{i}.Wake)); NumWAKE_LabBasal(NumWAKE_LabBasal==0)=NaN;
            NumSWS_LabBasal(i) = length(length(a{i}.SWSEpoch)); NumSWS_LabBasal(NumSWS_LabBasal==0)=NaN;
            NumREM_LabBasal(i) = length(length(a{i}.REMEpoch)); NumREM_LabBasal(NumREM_LabBasal==0)=NaN;
            %number of  bouts 3h post SD
            NumWAKE_LabBasal_3hPostSD(i) = length(length(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}))); NumWAKE_LabBasal_3hPostSD(NumWAKE_LabBasal_3hPostSD==0)=NaN;
            NumSWS_LabBasal_3hPostSD(i) = length(length(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}))); NumSWS_LabBasal_3hPostSD(NumSWS_LabBasal_3hPostSD==0)=NaN;
            NumREM_LabBasal_3hPostSD(i) = length(length(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}))); NumREM_LabBasal_3hPostSD(NumREM_LabBasal_3hPostSD==0)=NaN;
%             %number of  bouts end of the 3h post SD up to the end of the session
%             NumWAKE_LabBasal_end(i) = length(length(and(a{i}.Wake,epoch_endPostSD_LabBasal{i}))); NumWAKE_LabBasal_end(NumWAKE_LabBasal_end==0)=NaN;
%             NumSWS_LabBasal_end(i) = length(length(and(a{i}.SWSEpoch,epoch_endPostSD_LabBasal{i}))); NumSWS_LabBasal_end(NumSWS_LabBasal_end==0)=NaN;
%             NumREM_LabBasal_end(i) = length(length(and(a{i}.REMEpoch,epoch_endPostSD_LabBasal{i}))); NumREM_LabBasal_end(NumREM_LabBasal_end==0)=NaN;
            
            %duration of bouts all sleep session
            durWAKE_LabBasal(i) = mean(End(a{i}.Wake)-Start(a{i}.Wake))/1E4; durWAKE_LabBasal(durWAKE_LabBasal==0)=NaN;
            durSWS_LabBasal(i) = mean(End(a{i}.SWSEpoch)-Start(a{i}.SWSEpoch))/1E4; durSWS_LabBasal(durSWS_LabBasal==0)=NaN;
            durREM_LabBasal(i) = mean(End(a{i}.REMEpoch)-Start(a{i}.REMEpoch))/1E4; durREM_LabBasal(durREM_LabBasal==0)=NaN;
            %duration of bouts 3h post SD
            durWAKE_LabBasal_3hPostSD(i) = mean(End(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i}))-Start(and(a{i}.Wake,epoch_3hPostSD_LabBasal{i})))/1E4; durWAKE_LabBasal_3hPostSD(durWAKE_LabBasal_3hPostSD==0)=NaN;
            durSWS_LabBasal_3hPostSD(i) = mean(End(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i}))-Start(and(a{i}.SWSEpoch,epoch_3hPostSD_LabBasal{i})))/1E4; durSWS_LabBasal_3hPostSD(durSWS_LabBasal_3hPostSD==0)=NaN;
            durREM_LabBasal_3hPostSD(i) = mean(End(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i}))-Start(and(a{i}.REMEpoch,epoch_3hPostSD_LabBasal{i})))/1E4; durREM_LabBasal_3hPostSD(durREM_LabBasal_3hPostSD==0)=NaN;
%             %duration of bouts end of the 3h post SD up to the end of the session
%             durWAKE_LabBasal_end(i) = mean(End(and(a{i}.Wake,epoch_endPostSD_LabBasal{i}))-Start(and(a{i}.Wake,epoch_endPostSD_LabBasal{i})))/1E4; durWAKE_LabBasal_end(durWAKE_LabBasal_end==0)=NaN;
%             durSWS_LabBasal_end(i) = mean(End(and(a{i}.SWSEpoch,epoch_endPostSD_LabBasal{i}))-Start(and(a{i}.SWSEpoch,epoch_endPostSD_LabBasal{i})))/1E4; durSWS_LabBasal_end(durSWS_LabBasal_end==0)=NaN;
%             durREM_LabBasal_end(i) = mean(End(and(a{i}.REMEpoch,epoch_endPostSD_LabBasal{i}))-Start(and(a{i}.REMEpoch,epoch_endPostSD_LabBasal{i})))/1E4; durREM_LabBasal_end(durREM_LabBasal_end==0)=NaN;
        else
        end
    else
    end
    
    %         else
    %         end
    
end


%%
%%my baseline
for j=1:length(DirMyBasal.path)
    cd(DirMyBasal.path{j}{1});
    if exist('SleepScoring_Accelero.mat')
        b{j} = load('SleepScoring_Accelero', 'REMEpoch', 'SWSEpoch', 'Wake');
        durtotal_MyBasal{j} = max([max(End(b{j}.Wake)),max(End(b{j}.SWSEpoch))]);
        %3h post injection
        epoch_3hPostSD_MyBasal{j}=intervalSet(0,3*3600*1E4);
        % end of the 3h post SD up to the end of the session
        epoch_3hPostSDEnd_MyBasal{j}=intervalSet(End(epoch_3hPostSD_MyBasal{j}),durtotal_MyBasal{j});
        %3h starting from first first sleep episode
        [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch,5,70); tpsFirstSleep_MyBasal{j}=tpsFirstSWS;
        epoch_2hSleepy_MyBasal{j}=intervalSet(tpsFirstSleep_MyBasal{j}*1e4,tpsFirstSleep_MyBasal{j}*1e4+2*3600*1E4);
        % from the end of the 3h starting from first long sleep episode to
        % the end of the session
%         epoch_2hSleepyEnd_MyBasal{j}=intervalSet(End(epoch_2hSleepy_MyBasal{j}),durtotal_MyBasal{j});

        if isempty(b{j})==0
            %percentage
            SleepStagePerc_MyBasal1{j} = ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
            percWAKE_MyBasal(j) = SleepStagePerc_MyBasal1{j}(1,1);
            percSWS_MyBasal(j) = SleepStagePerc_MyBasal1{j}(2,1);
            percREM_MyBasal(j) = SleepStagePerc_MyBasal1{j}(3,1);
            %percentage 3h after SD
            SleepStagePerc_MyBasal2{j} = ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
            percWAKE_3hPostSD_MyBasal(j) = SleepStagePerc_MyBasal2{j}(1,5);
            percSWS_3hPostSD_MyBasal(j) = SleepStagePerc_MyBasal2{j}(2,5);
            percREM_3hPostSD_MyBasal(j) = SleepStagePerc_MyBasal2{j}(3,5);
            %percentage 3h after SD
            SleepStagePerc_MyBasal3{j} = ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
            percWAKE_3hPostSDEnd_MyBasal(j) = SleepStagePerc_MyBasal3{j}(1,6);
            percSWS_3hPostSDEnd_MyBasal(j) = SleepStagePerc_MyBasal3{j}(2,6);
            percREM_3hPostSDEnd_MyBasal(j) = SleepStagePerc_MyBasal3{j}(3,6);
            %percentage 3h starting from first sleep
%             SleepStagePerc_MyBasal4{j} = ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
%             percWAKE_3hSleepy_MyBasal(j) = SleepStagePerc_MyBasal4{j}(1,7);
%             percSWS_3hSleepy_MyBasal(j) = SleepStagePerc_MyBasal4{j}(2,7);
%             percREM_3hSleepy_MyBasal(j) = SleepStagePerc_MyBasal4{j}(3,7);
%             %percentage end of the 3 hours after the first sleep to the end of the session
%             SleepStagePerc_MyBasal5{j} = ComputeSleepStagesPercentagesMC(b{j}.Wake,b{j}.SWSEpoch,b{j}.REMEpoch);
%             percWAKE_3hSleepyEnd_MyBasal(j) = SleepStagePerc_MyBasal5{j}(1,8);
%             percSWS_3hSleepyEnd_MyBasal(j) = SleepStagePerc_MyBasal5{j}(2,8);
%             percREM_3hSleepyEnd_MyBasal(j) = SleepStagePerc_MyBasal5{j}(3,8);
            
            %number of bouts
            NumWake_MyBasal(j) = length(length(b{j}.Wake));
            NumSWS_MyBasal(j) = length(length(b{j}.SWSEpoch));
            NumREM_MyBasal(j) = length(length(b{j}.REMEpoch));
            %number of  bouts 3h post SD
            NumWAKE_3hPostSD_MyBasal(j) = length(length(and(b{j}.Wake,epoch_3hPostSD_MyBasal{j})));
            NumSWS_3hPostSD_MyBasal(j) = length(length(and(b{j}.SWSEpoch,epoch_3hPostSD_MyBasal{j})));
            NumREM_3hPostSD_MyBasal(j) = length(length(and(b{j}.REMEpoch,epoch_3hPostSD_MyBasal{j})));
            %number of  bouts end of the 3h post SD up to the end of the session
            NumWAKE_3hPostSDEnd_MyBasal(j) = length(length(and(b{j}.Wake,epoch_3hPostSDEnd_MyBasal{j})));
            NumSWS_3hPostSDEnd_MyBasal(j) = length(length(and(b{j}.SWSEpoch,epoch_3hPostSDEnd_MyBasal{j})));
            NumREM_3hPostSDEnd_MyBasal(j) = length(length(and(b{j}.REMEpoch,epoch_3hPostSDEnd_MyBasal{j})));
            %number of  bouts 3h following first sleep
%             NumWAKE_3hSleepy_MyBasal(j) = length(length(and(b{j}.Wake,epoch_2hSleepy_MyBasal{j})));
%             NumSWS_3hSleepy_MyBasal(j) = length(length(and(b{j}.SWSEpoch,epoch_2hSleepy_MyBasal{j})));
%             NumREM_3hSleepy_MyBasal(j) = length(length(and(b{j}.REMEpoch,epoch_2hSleepy_MyBasal{j})));
%             %number of  bouts from the end of 3h following first sleep to the end of the session
%             NumWAKE_3hSleepyEnd_MyBasal(j) = length(length(and(b{j}.Wake,epoch_2hSleepyEnd_MyBasal{j})));
%             NumSWS_3hSleepyEnd_MyBasal(j) = length(length(and(b{j}.SWSEpoch,epoch_2hSleepyEnd_MyBasal{j})));
%             NumREM_3hSleepyEnd_MyBasal(j) = length(length(and(b{j}.REMEpoch,epoch_2hSleepyEnd_MyBasal{j})));
%             
            %duration of bouts
            durWAKE_MyBasal(j) = mean(End(b{j}.Wake)-Start(b{j}.Wake))/1E4;
            durSWS_MyBasal(j) = mean(End(b{j}.SWSEpoch)-Start(b{j}.SWSEpoch))/1E4;
            durREM_MyBasal(j) = mean(End(b{j}.REMEpoch)-Start(b{j}.REMEpoch))/1E4;
            %duration of bouts 3h post SD
            durWAKE_3hPostSD_MyBasal(j) = mean(End(and(b{j}.Wake,epoch_3hPostSD_MyBasal{j}))-Start(and(b{j}.Wake,epoch_3hPostSD_MyBasal{j})))/1E4;
            durSWS_3hPostSD_MyBasal(j) = mean(End(and(b{j}.SWSEpoch,epoch_3hPostSD_MyBasal{j}))-Start(and(b{j}.SWSEpoch,epoch_3hPostSD_MyBasal{j})))/1E4;
            durREM_3hPostSD_MyBasal(j) = mean(End(and(b{j}.REMEpoch,epoch_3hPostSD_MyBasal{j}))-Start(and(b{j}.REMEpoch,epoch_3hPostSD_MyBasal{j})))/1E4;
            %duration of bouts end of the 3h post SD up to the end of the session
            durWAKE_3hPostSDEnd_MyBasal(j) = mean(End(and(b{j}.Wake,epoch_3hPostSDEnd_MyBasal{j}))-Start(and(b{j}.Wake,epoch_3hPostSDEnd_MyBasal{j})))/1E4;
            durSWS_3hPostSDEnd_MyBasal(j) = mean(End(and(b{j}.SWSEpoch,epoch_3hPostSDEnd_MyBasal{j}))-Start(and(b{j}.SWSEpoch,epoch_3hPostSDEnd_MyBasal{j})))/1E4;
            durREM_3hPostSDEnd_MyBasal(j) = mean(End(and(b{j}.REMEpoch,epoch_3hPostSDEnd_MyBasal{j}))-Start(and(b{j}.REMEpoch,epoch_3hPostSDEnd_MyBasal{j})))/1E4;
            %duration of bouts 3h following first sleep
%             durWAKE_3hSleepy_MyBasal(j) = mean(End(and(b{j}.Wake,epoch_2hSleepy_MyBasal{j}))-Start(and(b{j}.Wake,epoch_2hSleepy_MyBasal{j})))/1E4;
%             durSWS_3hSleepy_MyBasal(j) = mean(End(and(b{j}.SWSEpoch,epoch_2hSleepy_MyBasal{j}))-Start(and(b{j}.SWSEpoch,epoch_2hSleepy_MyBasal{j})))/1E4;
%             durREM_3hSleepy_MyBasal(j) = mean(End(and(b{j}.REMEpoch,epoch_2hSleepy_MyBasal{j}))-Start(and(b{j}.REMEpoch,epoch_2hSleepy_MyBasal{j})))/1E4;
%             %duration of bouts from the end of the 3h following first sleep to the end
%             durWAKE_3hSleepyEnd_MyBasal(j) = mean(End(and(b{j}.Wake,epoch_2hSleepyEnd_MyBasal{j}))-Start(and(b{j}.Wake,epoch_2hSleepyEnd_MyBasal{j})))/1E4;
%             durSWS_3hSleepyEnd_MyBasal(j) = mean(End(and(b{j}.SWSEpoch,epoch_2hSleepyEnd_MyBasal{j}))-Start(and(b{j}.SWSEpoch,epoch_2hSleepyEnd_MyBasal{j})))/1E4;
%             durREM_3hSleepyEnd_MyBasal(j) = mean(End(and(b{j}.REMEpoch,epoch_2hSleepyEnd_MyBasal{j}))-Start(and(b{j}.REMEpoch,epoch_2hSleepyEnd_MyBasal{j})))/1E4;
        
        
        
        else
        end
    else
    end
end
%%
NewMiceWithConcatData = {'Mouse1217','Mouse1218','Mouse1219','Mouse1220'};

%%social defeat
for k=1:length(DirSocialDefeat.path)
    cd(DirSocialDefeat.path{k}{1});
    MiceNum{k} = DirSocialDefeat.name{k};

%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%mice with concatenated data (loading is a bit different)
%     if ismember(MiceNum{k}, NewMiceWithConcatData)==1
%     c{k} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
%     cc{k} = load('behavResources.mat', 'SessionEpoch');
%     
%     c{k}.Wake = and(c{k}.Wake,cc{k}.SessionEpoch.SleepPostSD);
%     c{k}.SWSEpoch = and(c{k}.SWSEpoch,cc{k}.SessionEpoch.SleepPostSD);
%     c{k}.REMEpoch = and(c{k}.REMEpoch,cc{k}.SessionEpoch.SleepPostSD);
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%     else
    c{k} = load( 'SleepScoring_Accelero.mat', 'Wake', 'REMEpoch', 'SWSEpoch');
%     end
    
    durtotal_SD{k} = max([max(End(c{k}.Wake)),max(End(c{k}.SWSEpoch))]);
    
        
            %3 hours following first sleep episode
% [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_v2_MC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch,5,20); tpsFirstSleep_SD{i}=tpsFirstSWS;
% epoch_2hSleepy_SD{k}=intervalSet(tpsFirstSleep_SD{k}*1e4,tpsFirstSleep_SD{k}*1e4+2*3600*1E4);
% epoch_3hPostSD_SD{k}=intervalSet(tpsFirstSleep_SD{k}*1e4,tpsFirstSleep_SD{k}*1e4+3*3600*1E4);


    %3h post SD (from beginning to 3h)
    epoch_3hPostSD_SD{k}=intervalSet(0,3*3600*1E4);
    % from the end of the 3h post SD up to the end of the session
%     epoch_3hPostSDEnd_SD{k}=intervalSet(End(epoch_3hPostSD_SD{k}),durtotal_SD{k});
    %3h starting from first first sleep episode
%     [tpsFirstREM, tpsFirstSWS]= FindLatencySleep_MC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch,1,1); tpsFirstSleep_SD{k}=tpsFirstSWS;
%     epoch_2hSleepy_SD{k}=intervalSet(tpsFirstSleep_SD{k}*1e4,tpsFirstSleep_SD{k}*1e4+2*3600*1E4);
    % from the end of the 3h starting from first long sleep episode to
    % the end of the session
%     epoch_2hSleepyEnd_SD{k}=intervalSet(End(epoch_2hSleepy_SD{k}),durtotal_SD{k});
    


    
    
    
    
    %percentage aftet SD (all sleep session)
    SleepStagePerc_totSess_SD{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    percWAKE_totSess_SD(k) = SleepStagePerc_totSess_SD{k}(1,1);
    percSWS_totSess_SD(k) = SleepStagePerc_totSess_SD{k}(2,1);
    percREM_totSess_SD(k) = SleepStagePerc_totSess_SD{k}(3,1);
    %percentage 3h after SD
    SleepStagePerc_totSess_SD2{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
    percWAKE_totSess_3hPostSD_SD(k) = SleepStagePerc_totSess_SD2{k}(1,5);
    percSWS_totSess_3hPostSD_SD(k) = SleepStagePerc_totSess_SD2{k}(2,5);
    percREM_totSess_3hPostSD_SD(k) = SleepStagePerc_totSess_SD2{k}(3,5);
    
    
    
    %percentage aftet SD (all sleep session)
    SleepStagePerc_totSleep_SD{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
%     percWAKE_totSleep_SD(k) = SleepStagePerc_totSleep_SD{k}(1,1);
    percSWS_totSleep_SD(k) = SleepStagePerc_totSleep_SD{k}(2,1);
    percREM_totSleep_SD(k) = SleepStagePerc_totSleep_SD{k}(3,1);
    %percentage 3h after SD
    SleepStagePerc_totSleep_SD2{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
%     percWAKE_totSleep_3hPostSD_SD(k) = SleepStagePerc_totSleep_SD2{k}(1,5);
    percSWS_totSleep_3hPostSD_SD(k) = SleepStagePerc_totSleep_SD2{k}(2,5);
    percREM_totSleep_3hPostSD_SD(k) = SleepStagePerc_totSleep_SD2{k}(3,5);
    
    
    
    
%     %percentage from the end of the 3 first hours to the end of the session
%     SleepStagePerc_SD3{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
%     percWAKE_3hPostSDEnd_SD(k) = SleepStagePerc_SD3{k}(1,6);
%     percSWS_3hPostSDEnd_SD(k) = SleepStagePerc_SD3{k}(2,6);
%     percREM_3hPostSDEnd_SD(k) = SleepStagePerc_SD3{k}(3,6);
    %percentage 3h starting from first sleep
%     SleepStagePerc_SD4{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
%     percWAKE_3hSleepy_SD(k) = SleepStagePerc_SD4{k}(1,7);
%     percSWS_3hSleepy_SD(k) = SleepStagePerc_SD4{k}(2,7);
%     percREM_3hSleepy_SD(k) = SleepStagePerc_SD4{k}(3,7);
%     %percentage end of the 3 hours after the first sleep to the end of the session
%     SleepStagePerc_SD5{k} = ComputeSleepStagesPercentagesMC(c{k}.Wake,c{k}.SWSEpoch,c{k}.REMEpoch);
%     percWAKE_3hSleepyEnd_SD(k) = SleepStagePerc_SD5{k}(1,8);
%     percSWS_3hSleepyEnd_SD(k) = SleepStagePerc_SD5{k}(2,8);
%     percREM_3hSleepyEnd_SD(k) = SleepStagePerc_SD5{k}(3,8);
 
    %number of bouts
    NumWAKE_SD(k) = length(length(c{k}.Wake));
    NumSWS_SD(k) = length(length(c{k}.SWSEpoch));
    NumREM_SD(k) = length(length(c{k}.REMEpoch));
    %number of  bouts 3h post SD
    NumWAKE_3hPostSD_SD(k) = length(length(and(c{k}.Wake,epoch_3hPostSD_SD{k})));
    NumSWS_3hPostSD_SD(k) = length(length(and(c{k}.SWSEpoch,epoch_3hPostSD_SD{k})));
    NumREM_3hPostSD_SD(k) = length(length(and(c{k}.REMEpoch,epoch_3hPostSD_SD{k})));
%     %number of  bouts end of the 3 first hours to the end of the session
%     NumWAKE_3hPostSDEnd_SD(k) = length(length(and(c{k}.Wake,epoch_3hPostSDEnd_SD{k})));
%     NumSWS_3hPostSDEnd_SD(k) = length(length(and(c{k}.SWSEpoch,epoch_3hPostSDEnd_SD{k})));
%     NumREM_3hPostSDEnd_SD(k) = length(length(and(c{k}.REMEpoch,epoch_3hPostSDEnd_SD{k})));
    %number of  bouts 3h following first sleep
%     NumWAKE_3hSleepy_SD(k) = length(length(and(c{k}.Wake,epoch_2hSleepy_SD{k})));
%     NumSWS_3hSleepy_SD(k) = length(length(and(c{k}.SWSEpoch,epoch_2hSleepy_SD{k})));
%     NumREM_3hSleepy_SD(k) = length(length(and(c{k}.REMEpoch,epoch_2hSleepy_SD{k})));
%     %number of  bouts from the end of 3h following first sleep to the end of the session
%     NumWAKE_3hSleepyEnd_SD(k) = length(length(and(c{k}.Wake,epoch_2hSleepyEnd_SD{k})));
%     NumSWS_3hSleepyEnd_SD(k) = length(length(and(c{k}.SWSEpoch,epoch_2hSleepyEnd_SD{k})));
%     NumREM_3hSleepyEnd_SD(k) = length(length(and(c{k}.REMEpoch,epoch_2hSleepyEnd_SD{k})));
    
    %duration of bouts all session
    durWAKE_SD(k) = mean(End(c{k}.Wake)-Start(c{k}.Wake))/1E4;
    durSWS_SD(k) = mean(End(c{k}.SWSEpoch)-Start(c{k}.SWSEpoch))/1E4;
    durREM_SD(k) = mean(End(c{k}.REMEpoch)-Start(c{k}.REMEpoch))/1E4;
    %duration of bouts 3h post SD
    durWAKE_3hPostSD_SD(k) = mean(End(and(c{k}.Wake,epoch_3hPostSD_SD{k}))-Start(and(c{k}.Wake,epoch_3hPostSD_SD{k})))/1E4;
    durSWS_3hPostSD_SD(k) = mean(End(and(c{k}.SWSEpoch,epoch_3hPostSD_SD{k}))-Start(and(c{k}.SWSEpoch,epoch_3hPostSD_SD{k})))/1E4;
    durREM_3hPostSD_SD(k) = mean(End(and(c{k}.REMEpoch,epoch_3hPostSD_SD{k}))-Start(and(c{k}.REMEpoch,epoch_3hPostSD_SD{k})))/1E4;
%     %duration of bouts from the end of the 3 hours post SD to the end of the session
%     durWAKE_3hPostSDEnd_SD(k) = mean(End(and(c{k}.Wake,epoch_3hPostSDEnd_SD{k}))-Start(and(c{k}.Wake,epoch_3hPostSDEnd_SD{k})))/1E4;
%     durSWS_3hPostSDEnd_SD(k) = mean(End(and(c{k}.SWSEpoch,epoch_3hPostSDEnd_SD{k}))-Start(and(c{k}.SWSEpoch,epoch_3hPostSDEnd_SD{k})))/1E4;
%     durREM_3hPostSDEnd_SD(k) = mean(End(and(c{k}.REMEpoch,epoch_3hPostSDEnd_SD{k}))-Start(and(c{k}.REMEpoch,epoch_3hPostSDEnd_SD{k})))/1E4;
    %duration of bouts 3h following first sleep
%     durWAKE_3hSleepy_SD(k) = mean(End(and(c{k}.Wake,epoch_2hSleepy_SD{k}))-Start(and(c{k}.Wake,epoch_2hSleepy_SD{k})))/1E4;
%     durSWS_3hSleepy_SD(k) = mean(End(and(c{k}.SWSEpoch,epoch_2hSleepy_SD{k}))-Start(and(c{k}.SWSEpoch,epoch_2hSleepy_SD{k})))/1E4;
%     durREM_3hSleepy_SD(k) = mean(End(and(c{k}.REMEpoch,epoch_2hSleepy_SD{k}))-Start(and(c{k}.REMEpoch,epoch_2hSleepy_SD{k})))/1E4;
%     %duration of bouts from the end of the 3h following first sleep to the end
%     durWAKE_3hSleepyEnd_SD(k) = mean(End(and(c{k}.Wake,epoch_2hSleepyEnd_SD{k}))-Start(and(c{k}.Wake,epoch_2hSleepyEnd_SD{k})))/1E4;
%     durSWS_3hSleepyEnd_SD(k) = mean(End(and(c{k}.SWSEpoch,epoch_2hSleepyEnd_SD{k}))-Start(and(c{k}.SWSEpoch,epoch_2hSleepyEnd_SD{k})))/1E4;
%     durREM_3hSleepyEnd_SD(k) = mean(End(and(c{k}.REMEpoch,epoch_2hSleepyEnd_SD{k}))-Start(and(c{k}.REMEpoch,epoch_2hSleepyEnd_SD{k})))/1E4;
end

%% figures
%% states percentage
figure,subplot(434),PlotErrorBarN_KJ({percWAKE_totSess_LabBasal, percWAKE_totSess_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of WAKE (%)')
makepretty
subplot(435),PlotErrorBarN_KJ({percSWS_totSess_LabBasal, percSWS_totSess_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of NREM (%)')
makepretty
subplot(436),PlotErrorBarN_KJ({percREM_totSess_LabBasal, percREM_totSess_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of REM (%)')
title('total sess')
makepretty

subplot(433),PlotErrorBarN_KJ({percREM_totSleep_LabBasal, percREM_totSleep_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of REM (%)')
% suptitle('States percentage')
makepretty

% Bouts number
subplot(437),PlotErrorBarN_KJ({NumWAKE_LabBasal, NumWAKE_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of WAKE bouts')
makepretty
subplot(438),PlotErrorBarN_KJ({NumSWS_LabBasal, NumSWS_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of NREM bouts')
makepretty
subplot(439),PlotErrorBarN_KJ({NumREM_LabBasal, NumREM_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of REM bouts')
% suptitle('Bouts number')
makepretty

% Bouts duration
subplot(4,3,10),PlotErrorBarN_KJ({durWAKE_LabBasal, durWAKE_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of WAKE (s)')
makepretty
subplot(4,3,11),PlotErrorBarN_KJ({durSWS_LabBasal, durSWS_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of NREM (s)')
makepretty
subplot(4,3,12),PlotErrorBarN_KJ({durREM_LabBasal, durREM_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of REM (s)')
% suptitle('Bouts duration')
makepretty


%% compare to lab baseline + restrict to 3h post SD
%% states percentage
figure,
ax_perc(1)=subplot(434),PlotErrorBarN_KJ({percWAKE_totSess_LabBasal_3hPostSD,percWAKE_totSess_3hPostSD_SD},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of WAKE (%)')
makepretty
ax_perc(2)=subplot(435),PlotErrorBarN_KJ({percSWS_totSess_LabBasal_3hPostSD,percSWS_totSess_3hPostSD_SD},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of NREM (%)')
makepretty
ax_perc(3)=subplot(436),PlotErrorBarN_KJ({percREM_totSess_LabBasal_3hPostSD,percREM_totSess_3hPostSD_SD},'newfig',0,'paired',0);
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Percentage of REM (%)')
% suptitle('3h')
makepretty

subplot(433),PlotErrorBarN_KJ({percREM_totSleep_LabBasal_3hPostSD, percREM_totSleep_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Lab basal', 'SD'}); xtickangle(45)
ylabel('Percentage of REM (%)')
% suptitle('States percentage')
makepretty
% set(ax_perc,'ylim',[0 100])

% Bouts number
ax_num(1)=subplot(437),PlotErrorBarN_KJ({NumWAKE_LabBasal_3hPostSD,NumWAKE_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of WAKE bouts')
makepretty
ax_num(2)=subplot(438),PlotErrorBarN_KJ({NumSWS_LabBasal_3hPostSD,NumSWS_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of NREM bouts')
makepretty
ax_num(3)=subplot(439),PlotErrorBarN_KJ({NumREM_LabBasal_3hPostSD,NumREM_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Number of REM bouts')
% suptitle('3h')
makepretty
% set(ax_num,'ylim',[0 200]) 

% Bouts duration
ax_dur(1)=subplot(4,3,10),PlotErrorBarN_KJ({durWAKE_LabBasal_3hPostSD,durWAKE_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of WAKE (s)')
makepretty
ax_dur(2)=subplot(4,3,11),PlotErrorBarN_KJ({durSWS_LabBasal_3hPostSD,durSWS_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of NREM (s)')
makepretty
ax_dur(3)=subplot(4,3,12),PlotErrorBarN_KJ({durREM_LabBasal_3hPostSD,durREM_3hPostSD_SD},'newfig',0,'paired',0)
set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'}); xtickangle(45)
ylabel('Duration of REM (s)')
% suptitle('Bouts duration')
makepretty
% set(ax_dur,'ylim',[0 200])



% %%%%%%%%%%%%
% %% states percentage (all sleep session)
% figure,
% ax_dur(1)=subplot(231),PlotErrorBarN_KJ({percWAKE_MyBasal,percWAKE_totSess_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Percentage of WAKE (%)')
% makepretty
% ax_dur(2)=subplot(232),PlotErrorBarN_KJ({percSWS_MyBasal,percSWS_totSess_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Percentage of NREM (%)')
% makepretty
% ax_dur(3)=subplot(233),PlotErrorBarN_KJ({percREM_MyBasal,percREM_totSess_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Percentage of REM (%)')
% makepretty
% 
% % states percentage 3H post SD
% ax_dur(4)=subplot(234),PlotErrorBarN_KJ({percWAKE_3hPostSD_MyBasal,percWAKE_totSess_3hPostSD_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'}); xtickangle(45)
% ylim([0 80])
% ylabel('Percentage of WAKE (%)')
% makepretty
% ax_dur(5)=subplot(235),PlotErrorBarN_KJ({percSWS_3hPostSD_MyBasal,percSWS_totSess_3hPostSD_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'});xtickangle(45)
% ylabel('Percentage of NREM (%)')
% makepretty
% ax_dur(6)=subplot(236),PlotErrorBarN_KJ({percREM_3hPostSD_MyBasal,percREM_totSess_3hPostSD_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'});xtickangle(45)
% ylabel('Percentage of REM (%)')
% makepretty
% 
% set(ax_dur,'ylim',[0 80])
% 
% 
% % Bouts number (all sleep session)
% figure,
% ax_dur(1)=subplot(231),PlotErrorBarN_KJ({NumWake_MyBasal,NumWAKE_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'baseline', 'SD'});
% ylabel('Number of WAKE bouts')
% makepretty
% ax_dur(2)=subplot(232),PlotErrorBarN_KJ({NumSWS_MyBasal,NumSWS_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'baseline', 'SD'});
% ylabel('Number of NREM bouts')
% makepretty
% ax_dur(3)=subplot(233),PlotErrorBarN_KJ({NumREM_MyBasal,NumREM_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'baseline', 'SD'});
% ylabel('Number of REM bouts')
% makepretty
% 
% % Bouts number 3H post SD
% ax_dur(4)=subplot(234),PlotErrorBarN_KJ({NumWAKE_3hPostSD_MyBasal,NumWAKE_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'}); xtickangle(45)
% ylabel('Number of WAKE bouts')
% makepretty
% ax_dur(5)=subplot(235),PlotErrorBarN_KJ({NumSWS_3hPostSD_MyBasal,NumSWS_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'}); xtickangle(45)
% ylabel('Number of NREM bouts')
% makepretty
% ax_dur(6)=subplot(236),PlotErrorBarN_KJ({NumREM_3hPostSD_MyBasal,NumREM_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'}); xtickangle(45)
% ylabel('Number of REM bouts')
% makepretty
% 
% set(ax_dur,'ylim',[0 1500])
% 
% % Bouts duration (all sleep session)
% figure,
% ax_dur(1)=subplot(231),PlotErrorBarN_KJ({durWAKE_MyBasal,durWAKE_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Mean duration of WAKE bouts (s)')
% makepretty
% ax_dur(2)=subplot(232),PlotErrorBarN_KJ({durSWS_MyBasal,durSWS_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Mean duration of NREM bouts (s)')
% makepretty
% ax_dur(3)=subplot(233),PlotErrorBarN_KJ({durREM_MyBasal,durREM_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', 'SD'});
% ylabel('Mean duration of REM bouts (s)')
% makepretty
% 
% % Bouts duration 3H post SD
% ax_dur(4)=subplot(234),PlotErrorBarN_KJ({durWAKE_3hPostSD_MyBasal,durWAKE_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'}); xtickangle(45)
% ylabel('Mean duration of WAKE bouts (s)')
% makepretty
% ax_dur(5)=subplot(235),PlotErrorBarN_KJ({durSWS_3hPostSD_MyBasal,durSWS_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'});xtickangle(45)
% ylabel('Mean duration of NREM bouts (s)')
% makepretty
% ax_dur(6)=subplot(236),PlotErrorBarN_KJ({durREM_3hPostSD_MyBasal,durREM_3hPostSD_SD},'newfig',0,'paired',0)
% set(gca,'Xtick',[1:2],'XtickLabel',{'Baseline', '3h post SD'});xtickangle(45)
% ylabel('Mean duration of REM bouts (s)')
% makepretty
% 
% set(ax_dur,'ylim',[0 65])
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %% see if rebound (compare 3h post SD to the end of the session)
% % states percentage 3H post SD up to the end
% figure
% ax_dur(4)=subplot(331),PlotErrorBarN_KJ({percWAKE_3hPostSD_MyBasal,percWAKE_totSess_3hPostSD_SD,percWAKE_3hPostSDEnd_MyBasal,percWAKE_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Percentage of WAKE (%)')
% makepretty
% ax_dur(5)=subplot(332),PlotErrorBarN_KJ({percSWS_3hPostSD_MyBasal,percSWS_totSess_3hPostSD_SD,percSWS_3hPostSDEnd_MyBasal,percSWS_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Percentage of NREM (%)')
% makepretty
% ax_dur(6)=subplot(333),PlotErrorBarN_KJ({percREM_3hPostSD_MyBasal,percREM_totSess_3hPostSD_SD,percREM_3hPostSDEnd_MyBasal,percREM_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Percentage of REM (%)')
% makepretty
% 
% % set(ax,'ylim',[0 80])
% 
% % number 3H post SD up to the end
% 
% ax_dur(4)=subplot(334),PlotErrorBarN_KJ({NumWAKE_3hPostSD_MyBasal,NumWAKE_3hPostSD_SD,NumWAKE_3hPostSDEnd_MyBasal,NumWAKE_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Number of WAKE bouts (#)')
% makepretty
% ax_dur(5)=subplot(335),PlotErrorBarN_KJ({NumSWS_3hPostSD_MyBasal,NumSWS_3hPostSD_SD,NumSWS_3hPostSDEnd_MyBasal,NumSWS_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Number of NREM bouts (#)')
% makepretty
% ax_dur(6)=subplot(336),PlotErrorBarN_KJ({NumREM_3hPostSD_MyBasal,NumREM_3hPostSD_SD,NumREM_3hPostSDEnd_MyBasal,NumREM_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Number of REM bouts (#)')
% makepretty
% 
% % set(ax,'ylim',[0 1500])
% 
% % duration 3H post SD up to the end
% 
% ax_dur(4)=subplot(337),PlotErrorBarN_KJ({durWAKE_3hPostSD_MyBasal,durWAKE_3hPostSD_SD,durWAKE_3hPostSDEnd_MyBasal,durWAKE_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Mean duration of WAKE bouts (#)')
% makepretty
% ax_dur(5)=subplot(338),PlotErrorBarN_KJ({durSWS_3hPostSD_MyBasal,durSWS_3hPostSD_SD,durSWS_3hPostSDEnd_MyBasal,durSWS_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Mean duration of NREM bouts (#)')
% makepretty
% ax_dur(6)=subplot(339),PlotErrorBarN_KJ({durREM_3hPostSD_MyBasal,durREM_3hPostSD_SD,durREM_3hPostSDEnd_MyBasal,durREM_3hPostSDEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline st-3h', 'SD st-3h','Baseline 3h-end','SD 3h-end'}); xtickangle(45)
% ylabel('Mean duration of REM bouts (#)')
% makepretty
% 
% % set(ax,'ylim',[0 1500])
% 
% 
% %%%%%%%%%%%%%%%%%%%%%
% 
% %% 2h following first sleep up to the end
% % states percentage
% figure
% ax_dur(4)=subplot(331),PlotErrorBarN_KJ({percWAKE_3hSleepy_MyBasal,percWAKE_3hSleepy_SD,percWAKE_3hSleepyEnd_MyBasal,percWAKE_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Percentage of WAKE (%)')
% makepretty
% ax_dur(5)=subplot(332),PlotErrorBarN_KJ({percSWS_3hSleepy_MyBasal,percSWS_3hSleepy_SD,percSWS_3hSleepyEnd_MyBasal,percSWS_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Percentage of NREM (%)')
% makepretty
% ax_dur(6)=subplot(333),PlotErrorBarN_KJ({percREM_3hSleepy_MyBasal,percREM_3hSleepy_SD,percREM_3hSleepyEnd_MyBasal,percREM_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Percentage of REM (%)')
% makepretty
% 
% % set(ax,'ylim',[0 80])
% 
% % number 
% 
% ax_dur(4)=subplot(334),PlotErrorBarN_KJ({NumWAKE_3hSleepy_MyBasal,NumWAKE_3hSleepy_SD,NumWAKE_3hSleepyEnd_MyBasal,NumWAKE_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Number of WAKE bouts (#)')
% makepretty
% ax_dur(5)=subplot(335),PlotErrorBarN_KJ({NumSWS_3hSleepy_MyBasal,NumSWS_3hSleepy_SD,NumSWS_3hSleepyEnd_MyBasal,NumSWS_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Number of NREM bouts (#)')
% makepretty
% ax_dur(6)=subplot(336),PlotErrorBarN_KJ({NumREM_3hSleepy_MyBasal,NumREM_3hSleepy_SD,NumREM_3hSleepyEnd_MyBasal,NumREM_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Number of REM bouts (#)')
% makepretty
% 
% % set(ax,'ylim',[0 1500])
% 
% % duration 
% ax_dur(4)=subplot(337),PlotErrorBarN_KJ({durWAKE_3hSleepy_MyBasal,durWAKE_3hSleepy_SD,durWAKE_3hSleepyEnd_MyBasal,durWAKE_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylim([0 80])
% ylabel('Mean duration of WAKE bouts (#)')
% makepretty
% ax_dur(5)=subplot(338),PlotErrorBarN_KJ({durSWS_3hSleepy_MyBasal,durSWS_3hSleepy_SD,durSWS_3hSleepyEnd_MyBasal,durSWS_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Mean duration of NREM bouts (#)')
% makepretty
% ax_dur(6)=subplot(339),PlotErrorBarN_KJ({durREM_3hSleepy_MyBasal,durREM_3hSleepy_SD,durREM_3hSleepyEnd_MyBasal,durREM_3hSleepyEnd_SD},'newfig',0,'paired',0);
% set(gca,'Xtick',[1:4],'XtickLabel',{'Baseline 1st sleep-2h', 'SD 1st sleep-2h','Baseline end','SD end'}); xtickangle(45)
% ylabel('Mean duration of REM bouts (#)')
% makepretty
% 
% % set(ax,'ylim',[0 1500])
% 
