function [MatRemHPC,MatWakeHPC,MatSwsHPC,MatAllHPC] = GetEvokedPotentialHPC_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,LowThetaEpochMC,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load LFPData/LFP7 LFP
LFPhpc=LFP;
[EEGf]=FilterLFP(LFPhpc,[1 100]);

load LFPData/DigInfo4 DigTSD
digTSD=DigTSD;

TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4);
Stim=Start(TTLEpoch_merged)/1E4;
Stimts=ts(Stim*1e4);

% StimW=Range(Restrict(Stimts,Wake))/1E4;
% StimS=Range(Restrict(Stimts,SWSEpoch))/1E4;
% StimR=Range(Restrict(Stimts,REMEpoch))/1E4;

StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;


[MatRemHPC] = PlotRipRaw_MC(LFPhpc, StimR, 500, 0, 0);
[MatWakeHPC] = PlotRipRaw_MC(LFPhpc, StimW, 500, 0, 0);
[MatSwsHPC] = PlotRipRaw_MC(LFPhpc, StimS, 500, 0, 0);
[MatAllHPC] = PlotRipRaw_MC(LFPhpc, Stim, 500, 0, 0);

[MatRemVLPO,MatWakeVLPO,MatSwsVLPO,MatAllVLPO] = GetEvokedPotentialVLPO_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise);


if plo
       figure, subplot(411), plot(MatRemHPC(:,1),MatRemHPC(:,2),'g')
    hold on, plot(MatRemVLPO(:,1),1000+MatRemVLPO(:,2),'k')
    xlim([-0.1 +0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    title('REM')
    subplot(412), plot(MatSwsHPC(:,1),MatSwsHPC(:,2),'r')
    hold on, plot(MatSwsVLPO(:,1),1000+MatSwsVLPO(:,2),'k')
    xlim([-0.1 +0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    title('NREM')
    subplot(413), plot(MatWakeHPC(:,1),MatWakeHPC(:,2),'b')
    hold on, plot(MatWakeVLPO(:,1),1000+MatWakeVLPO(:,2),'k')
    xlim([-0.1 +0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    title('Wake')
    
    subplot(414), plot(MatAllHPC(:,1),MatAllHPC(:,2),'b')
    hold on, plot(MatAllVLPO(:,1),1000+MatAllVLPO(:,2),'k')
    xlim([-0.1 +0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    title('ALL')
    
    
    suptitle(['Evoked potentials HPC',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end