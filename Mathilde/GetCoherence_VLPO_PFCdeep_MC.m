function [Coh_VLPO_PFCd, Cohtsd_VLPO_PFCd, CohWake, CohREM, CohSWS] = GetCoherence_VLPO_PFCdeep_MC(Wake,SWSEpoch,REMEpoch,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load VLPO_PFCx_deep_Low_Coherence.mat Coherence

Coh_VLPO_PFCd=Coherence;
Cohtsd_VLPO_PFCd = tsd(Coh_VLPO_PFCd{2}*1e4,Coh_VLPO_PFCd{1});

CohWake=nanmean(Data(Restrict(Cohtsd_VLPO_PFCd,Wake)));
CohSWS=nanmean(Data(Restrict(Cohtsd_VLPO_PFCd,SWSEpoch)));
CohREM=nanmean(Data(Restrict(Cohtsd_VLPO_PFCd,REMEpoch)));

if plo
    
    figure, plot(Coh_VLPO_PFCd{3},CohWake,'color','b','linewidth',2)
    hold on
    plot(Coh_VLPO_PFCd{3},CohSWS,'r','linewidth',2)
    plot(Coh_VLPO_PFCd{3},CohREM,'g','linewidth',2)
    ylim([0.4 0.95])
    ylabel('Coherence')
    xlabel('Frequency (Hz')
    legend('Wake','NREM','REM')
    title('VLPO PFC(deep) coherence')
    suptitle([' ',num2str(ExpeInfo.Date),' ','M',num2str(ExpeInfo.nmouse)])
    
end
