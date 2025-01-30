Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');

% for i=1:length(Dir)
for j=1:length(Dir{1}.path)
    cd(Dir{1}.path{j}{1});
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    [durREM{j},durTREM{j}]=DurationEpoch(REMEpoch);
    
    for ev=1:length(durREM)
        AvSimu(ev,:)=squeeze(nanmean(nanmean(durREM{ev}(:,:),1)));
    end
end
% end

for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
    
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch);
    
    [durREM{j},durTREM{j}]=DurationEpoch(REMEpoch);
    for ev=1:length(durREM)
        AvOpto(ev,:)=squeeze(nanmean(nanmean(durREM{ev}(:,:),1)));
    end
    
end

        
    
PlotErrorBarN_KJ({mean(avSimu), mean(avOpto)},'newfig',0,'paired',1,'ShowSigstar','sig');

