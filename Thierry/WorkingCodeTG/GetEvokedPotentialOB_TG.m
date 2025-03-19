function [MatRemOB,MatWakeOB,MatSwsOB,MatAllOB] = GetEvokedPotentialOB_MC(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load SleepScoring_OBGamma.mat
load LFPData/LFP2 LFP

res=pwd;
nam='bulb_deep';
eval(['tempchBulb=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chBulb=tempchBulb.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chBulb),'.mat'');'])
LFPob=LFP;
[EEGf]=FilterLFP(LFPob,[1 100]);

load LFPData/DigInfo4 DigTSD
digTSD=DigTSD;

TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4);
Stim=Start(TTLEpoch_merged)/1E4;
Stimts=ts(Stim*1e4);

StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;

[MatRemOB] = PlotRipRaw_MC(LFPob, StimR, 500, 0, 0);
[MatWakeOB] = PlotRipRaw_MC(LFPob, StimW, 500, 0, 0);
[MatSwsOB] = PlotRipRaw_MC(LFPob, StimS, 500, 0, 0);
[MatAllOB] = PlotRipRaw_MC(LFPob, Stim, 500, 0, 0);


[MatRemVLPO,MatWakeVLPO,MatSwsVLPO,MatAllVLPO] = GetEvokedPotentialVLPO_TG(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise);

if plo
    figure, subplot(411), plot(MatRemOB(:,1),MatRemOB(:,2),'g')
    hold on, plot(MatRemVLPO(:,1),1000+MatRemVLPO(:,2),'k')
    xlim([-0.1 0.5])
    line([0 0], ylim,'color','k','linestyle',':')
    title('REM')
    
    subplot(412), plot(MatSwsOB(:,1),MatSwsOB(:,2),'r')
    hold on, plot(MatSwsVLPO(:,1),1000+MatSwsVLPO(:,2),'k')
    line([0 0], ylim,'color','k','linestyle',':')
    title('NREM')
    subplot(413), plot(MatWakeOB(:,1),MatWakeOB(:,2),'b')
    hold on, plot(MatWakeVLPO(:,1),1000+MatWakeVLPO(:,2),'k')
    line([0 0], ylim,'color','k','linestyle',':')
    title('Wake')
    
    subplot(414), plot(MatAllOB(:,1),MatAllOB(:,2),'b')
    hold on, plot(MatAllVLPO(:,1),1000+MatAllVLPO(:,2),'k')
    line([0 0], ylim,'color','k','linestyle',':')
    title('ALL')
    
    
    
    suptitle(['Evoked potentials OB',' ','M',num2str(ExpeInfo.nmouse),' ',num2str(ExpeInfo.Date)])
    
end