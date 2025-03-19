
Dir{1}=PathForExperiments_Opto_MC('Septum_Sham_20Hz');
Dir{2}=PathForExperiments_Opto_MC('Septum_Stim_20Hz');
% Dir{1}=PathForExperiments_Opto_MC('PFC_Baseline_20Hz');
% Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    load SleepScoring_OBGamma
    
    SleepStages_sham=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
    [Stim_sham] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch);
%     load SimulatedStims RemStim   %to get SIMULATED stimulations
    
%     [hREM,rgREM,vecREM]=HistoSleepStagesTransitionsMathilde(SleepStages_sham,Restrict(RemStim,REMEpochWiNoise),-30:1:30,2); % when you use simulated stim
    
    [hREM_sham,rgREM_sham,vecREM_sham]=HistoSleepStagesTransitionsMathilde(SleepStages_sham,Restrict(ts(Stim_sham*1E4),REMEpochWiNoise),-30:1:30,2); %to get state transition for stim during REM sleep
%     [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages_sham,Restrict(ts(Stim_sham*1E4),SWSEpochWiNoise),-30:1:30,2);
%     [h,rg,vec]=HistoSleepStagesTransitionsMathilde(SleepStages_sham,Restrict(ts(Stim_sham*1E4),WakeWiNoise),-30:1:30,2);
    
    H_REM_sham{i}=hREM_sham;
    RG_REM_sham{i}=rgREM_sham;
    VEC_REM_sham{i}=vecREM_sham;
    
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end


for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    load SleepScoring_OBGamma
    
    SleepStages_opto=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
    [Stim_opto] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch);
    
    [hREM_opto,rgREM_opto,vecREM_opto]=HistoSleepStagesTransitionsMathilde(SleepStages_opto,Restrict(ts(Stim_opto*1E4),REMEpochWiNoise),-30:1:30,2);
%     [hSWS,rgSWS,vecSWS]=HistoSleepStagesTransitionsMathilde(SleepStages_opto,Restrict(ts(Stim_opto*1E4),SWSEpochWiNoise),-30:1:30,2);
%     [hWake,rgWake,vecWake]=HistoSleepStagesTransitionsMathilde(SleepStages_opto,Restrict(ts(Stim_opto*1E4),WakeEpochWiNoise),-30:1:30,2);
    
    H_REM_opto{i}=hREM_opto;
    RG_REM_opto{i}=rgREM_opto;
    VEC_REM_opto{i}=vecREM_opto;
    
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end

%% average across mice
datahREM_sham=cat(3,H_REM_sham{:});
avhREM_sham=nanmean(datahREM_sham,3);

dataVecREM_sham=cat(3,VEC_REM_sham{:});
avVecREM_sham=nanmean(dataVecREM_sham,3);


datahREM_opto=cat(3,H_REM_opto{:});
avhREM_opto=nanmean(datahREM_opto,3);

dataVecREM_opto=cat(3,VEC_REM_opto{:});
avVecREM_opto=nanmean(dataVecREM_opto,3);

%%
figure, subplot(131)
plot(avVecREM_sham, avhREM_sham(:,2),'k','linewidth',2), hold on,
plot(avVecREM_opto, avhREM_opto(:,2),'g','linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':')
xlim([-30 30])
xlabel('time (s)')
ylabel('REM percentage (%)')
title('REM')
legend({'sham','opto'})
subplot(132)
plot(avVecREM_sham, avhREM_sham(:,3),'k','linewidth',2), hold on,
plot(avVecREM_opto, avhREM_opto(:,3),'r','linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':')
xlim([-30 30])
xlabel('time (s)')
ylabel('NREM percentage (%)')
title('NREM')
legend({'sham','opto'})
subplot(133)
plot(avVecREM_sham, avhREM_sham(:,1),'k','linewidth',2), hold on,
plot(avVecREM_opto, avhREM_opto(:,1),'b','linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':')
xlim([-30 30])
xlabel('time (s)')
ylabel('Wake percentage (%)')
title('Wake')
legend({'sham','opto'})
suptitle('transition after opto stim during REM sleep (septum-VLPO)')


figure,plot(avVecREM_sham, avhREM_sham,'linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':')
xlabel('time(s)')
ylabel('Pecentage (%)')
legend({'wake','REM','NREM'})

figure,plot(avVecREM_opto, avhREM_opto,'linewidth',2)
line([0 0],[0 100],'color','k','linestyle',':')
xlabel('time(s)')
ylabel('Pecentage (%)')
legend({'wake','REM','NREM'})
 


% shadedErrorBar(vec,datahREM(:,1),stdError(datahREM(:,1)),1);


