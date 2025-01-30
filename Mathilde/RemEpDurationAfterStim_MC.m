Dir{1}=PathForExperiments_Opto_MC('PFC_Baseline_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number = 1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    REMdurSimu = GetRemEpDurAfterSimulStim_MC(Wake, SWSEpoch, REMEpoch);
    RemDurSimu{i}=REMdurSimu;
    
    for k=1:length(RemDurSimu)
        avRemDurSimu(k,:)=nanmean(nanmean(RemDurSimu{k}(:,:)));
    end
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end

%%

for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
REMdurOpto = GetRemEpDurAfterStim_MC(Wake, SWSEpoch, REMEpoch);
    RemDurOpto{j}=REMdurOpto;
    
    for k=1:length(RemDurOpto)
        avRemDurOpto(k,:)=nanmean(nanmean(RemDurOpto{k}(:,:)));
    end
    
    MouseId(number) = Dir{2}.nMice{j} ;
    number=number+1;
end


%%
figure
PlotErrorBarN_KJ({avRemDurSimu, avRemDurOpto},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks(1:2)
xticklabels({'simulated stims ','stims opto'});
ylim([0 80])
ylabel('duration (s)')

%%
REMdurOpto = GetRemEpDurAfterStim_MC(Wake, SWSEpoch, REMEpoch);

% load SimulatedStims WakeStim RemStim SwsStim
% StimREM=Range(Restrict(RemStim,REMEpoch))./1E4;


REMend=End(REMEpoch)./(1e4); % matrix with end times of all REM ep

[Stim, StimREM] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to get the times of every stim during REM sleep
StimREM = StimREM./1E4;


for k=1:length(StimREM)
    RemEpDur=REMend-StimREM(k); % duration of REM ep after the stim 
    %(smallest positive difference between the end of the REM ep and the time of the stim)
    if sum(RemEpDur>0)==0
        REMdurOpto(k)=NaN;
    else
        REMdurOpto(k)=min(RemEpDur(RemEpDur>0));
    end
    
end




