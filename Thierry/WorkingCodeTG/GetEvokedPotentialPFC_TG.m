function [MatRemPFCx,MatWakePFCx,MatSwsPFCx,MatAllPFCx] = GetEvokedPotentialPFC_TG(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise,plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load SleepScoring_OBGamma.mat
load LFPData/LFP15 LFP

res=pwd;
nam='PFCx_deep';
eval(['tempchPFCx=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chPFCx=tempchPFCx.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chPFCx),'.mat'');'])
LFPPFCx=LFP;
[EEGf]=FilterLFP(LFPPFCx,[1 100]);

load LFPData/DigInfo4 DigTSD
digTSD=DigTSD;

TTLEpoch= thresholdIntervals(digTSD,0.99,'Direction','Above');
TTLEpoch_merged= mergeCloseIntervals(TTLEpoch,1e4);
Stim=Start(TTLEpoch_merged)/1E4;
Stimts=ts(Stim*1e4);

StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;

[MatRemPFCx] = PlotRipRaw_MC(LFPPFCx, StimR, 500, 0, 0);
[MatWakePFCx] = PlotRipRaw_MC(LFPPFCx, StimW, 500, 0, 0);
[MatSwsPFCx] = PlotRipRaw_MC(LFPPFCx, StimS, 500, 0, 0);
[MatAllPFCx] = PlotRipRaw_MC(LFPPFCx, Stim, 500, 0, 0);


[MatRemVLPO,MatWakeVLPO,MatSwsVLPO,MatAllVLPO] = GetEvokedPotentialVLPO_TG(WakeWiNoise,REMEpochWiNoise,SWSEpochWiNoise);

if plo
    figure, subplot(411), plot(MatRemPFCx(:,1),MatRemPFCx(:,2),'g'), 
    yyaxis left
    ylim([-1000 500])
    hold on, 
    yyaxis right
    plot(MatRemVLPO(:,1),1000+MatRemVLPO(:,2),'k'), 
    xlim([-0.1 0.5])
    ylim([-1000 2500]), 
    legend('PFCx','VLPO')
    line([0 0], ylim,'color','k','linestyle',':')
    title('REM')
  
    
    subplot(412), plot(MatSwsPFCx(:,1),MatSwsPFCx(:,2),'r')
    yyaxis left
    ylim([-1000 500])
    hold on, 
    yyaxis right
    plot(MatSwsVLPO(:,1),1000+MatSwsVLPO(:,2),'k'), 
    xlim([-0.1 0.5])
    ylim([-1000 2500]), 
    legend('PFCx','VLPO')
    line([0 0], ylim,'color','k','linestyle',':')
    title('NREM')

   
    subplot(413), plot(MatWakePFCx(:,1),MatWakePFCx(:,2),'b')
    yyaxis left
    ylim([-1000 500])
    hold on, 
    yyaxis right
    plot(MatWakeVLPO(:,1),1000+MatWakeVLPO(:,2),'k'), 
    xlim([-0.1 0.5])
    ylim([-1000 2500]), 
    legend('PFCx','VLPO')
    line([0 0], ylim,'color','k','linestyle',':')
    title('Wake')

    
    subplot(414), plot(MatAllPFCx(:,1),MatAllPFCx(:,2),'b')
    yyaxis left
    ylim([-1000 500])
    hold on, 
    yyaxis right
    plot(MatAllVLPO(:,1),1000+MatAllVLPO(:,2),'k')
    xlim([-0.1 0.5])
    ylim([-1000 2500]), 
    legend('PFCx','VLPO')
    line([0 0], ylim,'color','k','linestyle',':')
    title('ALL')

    
       
    suptitle(['Evoked potentials PFCx','20Hz, 30s','M1075','200703'])
    
end