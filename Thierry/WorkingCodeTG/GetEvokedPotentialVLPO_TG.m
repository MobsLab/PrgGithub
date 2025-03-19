function [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialVLPO_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load SleepScoring_OBGamma.mat
load LFPData/LFP5 LFP
LFPvlpo=LFP;
[EEGf]=FilterLFP(LFPvlpo,[1 100]);

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

[MatRemVLPO,Trem] = PlotRipRaw_MC(LFPvlpo, StimR, 500, 0, 0);
[MatWakeVLPO,Twake] = PlotRipRaw_MC(LFPvlpo, StimW, 500, 0, 0);
[MatSwsVLPO,Tsws] = PlotRipRaw_MC(LFPvlpo, StimS, 500, 0, 0);
[MatAllVLPO,Ttot] = PlotRipRaw_MC(LFPvlpo, Stim, 500, 0, 0);


if plo
    figure, subplot(321), plot(MatRemVLPO(:,1),MatRemVLPO(:,2),'g')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('REM')
    subplot(323), plot(MatSwsVLPO(:,1),MatSwsVLPO(:,2),'r')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('NREM')
    subplot(325), plot(MatWakeVLPO(:,1),MatWakeVLPO(:,2),'b')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('Wake')
    
    
    
    subplot(322), plot(MatRemVLPO(:,1),zscore(MatRemVLPO(:,2)),'g')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('REM (zcore)')
    subplot(324), plot(MatSwsVLPO(:,1),zscore(MatSwsVLPO(:,2)),'r')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('NREM (zscore)')
    subplot(326), plot(MatWakeVLPO(:,1),zscore(MatWakeVLPO(:,2)),'b')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('Wake (zscore)')
    
    
    suptitle(['Evoked potentials VLPO',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end
