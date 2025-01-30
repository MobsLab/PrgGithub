
Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
%     REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
%     SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
%     WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);
    
    load SleepSubstages
    N1=Epoch{1};
    N2=Epoch{2};
    N3=Epoch{3};
    REMEpoch=Epoch{4};
    Wake=Epoch{5};
    SWSEpoch=Epoch{7};
    SleepSubStage=PlotSleepSubStage_MC(N1,N2,N3,REMEpochWiNoise,WakeWiNoise,SWSEpochWiNoise,1); close
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    
    [hREM,rgREM,vecREM]=HistoSleepStagesTransitionsMathildeKB_MC(SleepSubStage,Restrict(ts(Stim*1E4),REMEpochWiNoise),-60:60,2);close
    H_REM{i}=hREM;
    perc_Wake(:,i)=H_REM{i}(:,1);
    perc_REM(:,i)=H_REM{i}(:,2);
    perc_N1(:,i)=H_REM{i}(:,3);
    perc_N2(:,i)=H_REM{i}(:,4);
    perc_N3(:,i)=H_REM{i}(:,5);
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

%%
numberOpto=1;
for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
%     REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
%     SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
%     WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);
%     
    load SleepSubstages
 N1=Epoch{1};
    N2=Epoch{2};
    N3=Epoch{3};
    REMEpoch=Epoch{4};
    Wake=Epoch{5};
    SWSEpoch=Epoch{7};
    SleepSubStage=PlotSleepSubStage_MC(N1,N2,N3,REMEpochWiNoise,WakeWiNoise,SWSEpochWiNoise,1); close

    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    
    [hREM,rgREM,vecREM]=HistoSleepStagesTransitionsMathildeKB_MC(SleepSubStage,Restrict(ts(Stim*1E4),REMEpochWiNoise),-60:60,2);close
    H_REMopto{j}=hREM;
    perc_WakeOpto(:,j)=H_REMopto{j}(:,1);
    perc_REMopto(:,j)=H_REMopto{j}(:,2);
    perc_N1opto(:,j)=H_REMopto{j}(:,3);
    perc_N2opto(:,j)=H_REMopto{j}(:,4);
    perc_N3opto(:,j)=H_REMopto{j}(:,5);
 
    MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end



%% figures

vec=-60:1:60;
% vec=-60:1:200;

% calculs des SEM
SEMperc_REM=std(perc_REM')/sqrt(length(perc_REM'));
SEMperc_Wake=std(perc_Wake')/sqrt(length(perc_Wake'));

SEMperc_N1=std(perc_N1')/sqrt(length(perc_N1'));
SEMperc_N2=std(perc_N2')/sqrt(length(perc_N2'));
SEMperc_N3=std(perc_N3')/sqrt(length(perc_N3'));


SEMperc_REMopto=std(perc_REMopto')/sqrt(length(perc_REMopto'));
SEMperc_WakeOpto=std(perc_WakeOpto')/sqrt(length(perc_WakeOpto'));

SEMperc_N1opto=std(perc_N1opto')/sqrt(length(perc_N1opto'));
SEMperc_N2opto=std(perc_N2opto')/sqrt(length(perc_N2opto'));
SEMperc_N3opto=std(perc_N3opto')/sqrt(length(perc_N3opto'));


%%
figure,subplot(151),shadedErrorBar(vec,mean(perc_REMopto,2),SEMperc_REMopto,'g',1), hold on,
shadedErrorBar(vec,mean(perc_REM,2),SEMperc_REM,'k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-30 30])
ylabel('percentage of REM (%)')
xlabel('Time (s)')

subplot(152),shadedErrorBar(vec,mean(perc_N1opto,2),SEMperc_N1opto,'r',1), hold on,
shadedErrorBar(vec,mean(perc_N1,2),SEMperc_N1,'k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-30 30])
ylabel('percentage of N1 (%)')
xlabel('Time (s)')

subplot(153),shadedErrorBar(vec,mean(perc_N2opto,2),SEMperc_N2opto,'r',1), hold on,
shadedErrorBar(vec,mean(perc_N2,2),SEMperc_N2,'k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-30 30])
ylabel('percentage of N2 (%)')
xlabel('Time (s)')

subplot(154),shadedErrorBar(vec,mean(perc_N3opto,2),SEMperc_N3opto,'r',1), hold on,
shadedErrorBar(vec,mean(perc_N3,2),SEMperc_N3,'k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-30 30])
ylabel('percentage of N3 (%)')
xlabel('Time (s)')

subplot(155),shadedErrorBar(vec,mean(perc_WakeOpto,2),SEMperc_WakeOpto,'b',1), hold on,
shadedErrorBar(vec,mean(perc_Wake,2),SEMperc_Wake,'k',1)
line([0 0],[0 100],'color','k','linestyle',':','linewidth',2)
ylim([0 100])
xlim([-30 30])
ylabel('percentage of wakefulness (%)')
xlabel('Time (s)')
suptitle('states percentage before and during opto stim during *REM SLEEP*')

%%
figure,subplot(1,10,1),
PlotErrorBarN_KJ({mean(perc_REM(30:61,:)) mean(perc_REMopto(30:61,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})
ylabel('Percentage of REM (%)')
subplot(1,10,2),PlotErrorBarN_KJ({mean(perc_REM(61:91,:)) mean(perc_REMopto(61:91,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})

subplot(1,10,3),
PlotErrorBarN_KJ({mean(perc_N1(30:61,:)) mean(perc_N1opto(30:61,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})
ylabel('Percentage of N1 (%)')
subplot(1,10,4),PlotErrorBarN_KJ({mean(perc_N1(61:91,:)) mean(perc_N1opto(61:91,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})

subplot(1,10,5),
PlotErrorBarN_KJ({mean(perc_N2(30:61,:)) mean(perc_N2opto(30:61,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})
ylabel('Percentage of N2 (%)')
subplot(1,10,6),PlotErrorBarN_KJ({mean(perc_N2(61:91,:)) mean(perc_N2opto(61:91,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})


subplot(1,10,7),
PlotErrorBarN_KJ({mean(perc_N3(30:61,:)) mean(perc_N3opto(30:61,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})
ylabel('Percentage of N3 (%)')
subplot(1,10,8),PlotErrorBarN_KJ({mean(perc_N3(61:91,:)) mean(perc_N3opto(61:91,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})

subplot(1,10,9),
PlotErrorBarN_KJ({mean(perc_Wake(30:61,:)) mean(perc_WakeOpto(30:61,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})
ylabel('Percentage of N3 (%)')
subplot(1,10,10),PlotErrorBarN_KJ({mean(perc_Wake(61:91,:)) mean(perc_WakeOpto(61:91,:))},'newfig',0,'paired',0,'ShowSigstar','sig');
ylim([0 100])
xticks([1 2])
xticklabels({'control','otpo'})