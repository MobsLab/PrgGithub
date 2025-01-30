function [Mrem,Mwake,Msws,Mtot] = GetEvokedPotentialVLPO_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,LowThetaEpochMC,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
% load LFPData/LFP17 LFP
% load('SleepScoring_OBGamma', 'Wake', 'REMEpoch', 'SWSEpoch');

res=pwd;
nam='VLPO';
eval(['tempchVLPO=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chVLPO=tempchVLPO.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chVLPO),'.mat'');'])


LFPvlpo=LFP;
[EEGf]=FilterLFP(LFPvlpo,[1 100]);

% load LFPData/DigInfo4 DigTSD
% digTSD=DigTSD;
% 
% TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');
% TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4);
% Stim=Start(TTLEpoch_merged)/1E4;
% Stimts=ts(Stim*1e4);


[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;

StimW=Range(Restrict(Stimts,Wake))/1E4;
StimS=Range(Restrict(Stimts,SWSEpoch))/1E4;
StimR=Range(Restrict(Stimts,REMEpoch))/1E4;

% StimW=Range(Restrict(Stimts,WakeEp))/1E4;
% StimS=Range(Restrict(Stimts,SWSEp))/1E4;
% StimR=Range(Restrict(Stimts,REMEp))/1E4;

% [Mrem,Trem] = PlotRipRaw_MC(LFPvlpo, StimR, 500, 0, 0);
% [Mwake,Twake] = PlotRipRaw_MC(LFPvlpo, StimW, 500, 0, 0);
% [Msws,Tsws] = PlotRipRaw_MC(LFPvlpo, StimS, 500, 0, 0);
[Mtot,Ttot] = PlotRipRaw_MC(LFPvlpo, Stim, 500, 0, 0);


if plo
%     figure, subplot(321), plot(Mrem(:,1),Mrem(:,2),'g')
%     % ylim([-0.3E4 +0.6E4])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('REM')
%     subplot(323), plot(Msws(:,1),Msws(:,2),'r')
%     % ylim([-0.3E4 +0.6E4])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('NREM')
%     subplot(325), plot(Mwake(:,1),Mwake(:,2),'b')
%     % ylim([-0.3E4 +0.6E4])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('Wake')
%     
%    
%     subplot(322), plot(Mrem(:,1),zscore(Mrem(:,2)),'g')
%     ylim([-6 +6])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('REM (zcore)')
%     subplot(324), plot(Msws(:,1),zscore(Msws(:,2)),'r')
%     ylim([-6 +6])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('NREM (zscore)')
%     subplot(326), plot(Mwake(:,1),zscore(Mwake(:,2)),'b')
%     ylim([-6 +6])
%     xlim([-0.1 0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('Wake (zscore)')
    
    figure, plot(Mtot(:,1),Mtot(:,2),'k')
%     suptitle(['Evoked potentials VLPO',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end
