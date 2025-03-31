function [MatRemPFC,MatWakePFC,MatSwsPFC,MatAllPFC] = GetEvokedPotentialPFC_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,LowThetaEpochMC,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
% load LFPData/LFP0 LFP

% load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
% REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
% SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
% WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

res=pwd;
nam='PFCx_deep';
eval(['tempchPFC=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chPFC=tempchPFC.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFC),'.mat'');'])


LFPpfc=LFP;
[EEGf]=FilterLFP(LFPpfc,[1 100]);

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
% StimW=Range(Restrict(Stimts,Wake))/1E4;
% StimS=Range(Restrict(Stimts,SWSEpoch))/1E4;
% StimR=Range(Restrict(Stimts,REMEpoch))/1E4;

StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

[MatRemPFC] = PlotRipRaw_MC(LFPpfc, StimR, 500, 0, 0);
[MatWakePFC] = PlotRipRaw_MC(LFPpfc, StimW, 500, 0, 0);
[MatSwsPFC] = PlotRipRaw_MC(LFPpfc, StimS, 500, 0, 0);
[MatAllPFC] = PlotRipRaw_MC(LFPpfc, Stim, 500, 0, 0);

[MatRemVLPO,MatWakeVLPO,MatSwsVLPO,MatAllVLPO] = GetEvokedPotentialVLPO_MC(0);


if plo
%     figure, subplot(411), plot(MatRemPFC(:,1),MatRemPFC(:,2),'g')
%     hold on, plot(MatRemVLPO(:,1),1000+MatRemVLPO(:,2),'k')
%     xlim([-0.1 +0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('REM')
%     subplot(412), plot(MatSwsPFC(:,1),MatSwsPFC(:,2),'r')
%     hold on, plot(MatSwsVLPO(:,1),1000+MatSwsVLPO(:,2),'k')
%     xlim([-0.1 +0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('NREM')
%     subplot(413), plot(MatWakePFC(:,1),MatWakePFC(:,2),'b')
%     hold on, plot(MatWakeVLPO(:,1),1000+MatWakeVLPO(:,2),'k')
%     xlim([-0.1 +0.5])
%     line([0 0], ylim,'color','k','linestyle',':')
%     title('Wake')
    
   figure, plot(MatAllPFC(:,1),MatAllPFC(:,2),'b')
    hold on, plot(MatAllVLPO(:,1),1000+MatAllVLPO(:,2),'k')
    xlim([-0.1 +0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    legend({'PFC','VLPO'})

makepretty    
    
    
    suptitle(['Evoked potentials PFC',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end