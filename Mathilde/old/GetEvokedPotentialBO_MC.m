function [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialBO_MC(Wake,REMEpoch,SWSEpoch,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load LFPData/LFP14 LFP
LFPvlpo=LFP;
[EEGf]=FilterLFP(LFPbo,[1 100]);

load LFPData/DigInfo2 DigTSD
digTSD=DigTSD;

TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4);
Stim=Start(TTLEpoch_merged)/1E4;
Stimts=ts(Stim*1e4);

StimW=Range(Restrict(Stimts,Wake))/1E4;
StimS=Range(Restrict(Stimts,SWSEpoch))/1E4;
StimR=Range(Restrict(Stimts,REMEpoch))/1E4;

[Mrem,Trem] = PlotRipRaw_MC(LFPbo, StimR, 500, 0, 0);
[Mwake,Twake] = PlotRipRaw_MC(LFPbo, StimW, 500, 0, 0);
[Msws,Tsws] = PlotRipRaw_MC(LFPbo, StimS, 500, 0, 0);
[Mtot,Ttot] = PlotRipRaw_MC(LFPbo, Stim, 500, 0, 0);


if plo
    figure, subplot(321), plot(Mrem(:,1),Mrem(:,2),'g')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('REM')
    subplot(323), plot(Msws(:,1),Msws(:,2),'r')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('NREM')
    subplot(325), plot(Mwake(:,1),Mwake(:,2),'b')
% ylim([-0.3E4 +0.6E4])
line([0 0], ylim,'color','k','linestyle',':')
    title('Wake')
    
    
    
    subplot(322), plot(Mrem(:,1),zscore(Mrem(:,2)),'g')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('REM (zcore)')
    subplot(324), plot(Msws(:,1),zscore(Msws(:,2)),'r')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('NREM (zscore)')
    subplot(326), plot(Mwake(:,1),zscore(Mwake(:,2)),'b')
    ylim([-6 +6])
    line([0 0], ylim,'color','k','linestyle',':')
    title('Wake (zscore)')
    
    
    suptitle(['Evoked potentials VLPO',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end