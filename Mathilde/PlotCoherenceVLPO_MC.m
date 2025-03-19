
Dir{2}=PathForExperiments_Opto('Stim_20Hz');
number = 1;
for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    load SleepScoring_OBGamma.mat
    [Coh_VLPO_PFCd,Cohtsd_VLPO_PFCd,CohWake, CohREM, CohSWS] = GetCoherence_VLPO_PFCdeep_MC(Wake, SWSEpoch,REMEpoch);
    
%     coherence{i}=Coh_VLPO_PFCd;
%     coherencetsd{i}=Cohtsd_VLPO_PFCd;
    coherenceWake{i}=CohWake;
    coherenceREM{i}=CohREM;
    coherenceSWS{i}=CohSWS;
    
    MouseId(number) = Dir{2}.nMice{i} ;
    number=number+1;
end

% compute average coherence across mice
dataCohWake=cat(3,coherenceWake{:}); % convert cell arrays in 3D arrays (third dimension being mice)
dataCohSWS=cat(3,coherenceSWS{:});
dataCohREM=cat(3,coherenceREM{:});
AvCohWake=nanmean(dataCohWake,3);   % compute average coherence across the third dimension
AvCohSWS=nanmean(dataCohSWS,3);
AvCohREM=nanmean(dataCohREM,3);

%% plot
figure, plot(Coh_VLPO_PFCd{3},AvCohWake,'b')
hold on
plot(Coh_VLPO_PFCd{3},AvCohSWS,'r')
plot(Coh_VLPO_PFCd{3},AvCohREM,'g')
legend('Wake','NREM','REM')
title('VLPO PFC(deep) coherence')
ylim([0.6 0.9])
