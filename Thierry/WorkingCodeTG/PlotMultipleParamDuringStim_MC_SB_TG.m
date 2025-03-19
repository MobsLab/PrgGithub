function [MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotMultipleParamDuringStim_MC_SB_TG(plo)

try
    plo;
catch
    plo=0;
end

load ExpeInfo
load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta SmoothGamma
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

load LFPData/LFP24 LFP %selectionner le bon channel EMG
%to get the EMG channel
res=pwd;
nam='EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG=tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFPemg=LFP;

% square signal
LFPemg=tsd(Range(LFPemg),Data(LFPemg).^2);

[EEGf]=FilterLFP(LFPemg,[50 300]);

%to get opto stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC; %to get opto stimulations
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

% to get EMG LFP signal around the stims
[MatRemEMG,TpsRemEMG] = PlotRipRaw_MC(LFPemg, StimR, 60000, 0, 0);
[MatWakeEMG,TpsWakeEMG] = PlotRipRaw_MC(LFPemg, StimW, 60000, 0, 0);
[MatSwsEMG,TpsSwsEMG] = PlotRipRaw_MC(LFPemg, StimS, 60000, 0, 0);

%to get theta HPC signal around the stims
[MatRemThet,TpsRemThet] = PlotRipRaw_MC(SmoothTheta, StimR, 60000, 0, 0);
[MatWakeThet,TpsWakeThet] = PlotRipRaw_MC(SmoothTheta, StimW, 60000, 0, 0);
[MatSwsThet,TpsSwsThet] = PlotRipRaw_MC(SmoothTheta, StimS, 60000, 0, 0);

%to get gamma OB signal around the stims
[MatRemGam,TpsRemGam] = PlotRipRaw_MC(SmoothGamma, StimR, 60000, 0, 0);
[MatWakeGam,TpsWakeGam] = PlotRipRaw_MC(SmoothGamma, StimW, 60000, 0, 0);
[MatSwsGam,TpsSwsEGam] = PlotRipRaw_MC(SmoothGamma, StimS, 60000, 0, 0);

%to get beta OB signal around the stims
SmoothBeta = MakeSmoothBeta_MC;
[MatRemBet,TpsRemBet] = PlotRipRaw_MC(SmoothBeta, StimR, 60000, 0, 0);
[MatRemBetStart,TpsRemBetStart] = PlotRipRaw_MC(SmoothBeta, Start(REMEp)/1e4, 60000, 0, 0);
[MatRemBetEnd,TpsRemBetEnd] = PlotRipRaw_MC(SmoothBeta, End(REMEp)/1e4, 60000, 0, 0);

[MatWakeBet,TpsWakeBet] = PlotRipRaw_MC(SmoothBeta, StimW, 60000, 0, 0);
[MatSwsBet,TpsSwsBet] = PlotRipRaw_MC(SmoothBeta, StimS, 60000, 0, 0);

%to compute triggered delta waves spectro averaged accross stimulations
load('DeltaWaves.mat')
[Y,X] = hist(Start(alldeltas_PFCx,'s'),[0:1:max(Range(LFP,'s'))]);
Delta_tsd = tsd(X*1E4,Y');
[MatRemDel,TpsRemDel] = PlotRipRaw_MC(Delta_tsd, StimR, 60000, 0, 0);
[MatWakeDel,TpsWakeDel] = PlotRipRaw_MC(Delta_tsd, StimW, 60000, 0, 0);
[MatSwsDel,TpsSwsEDel] = PlotRipRaw_MC(Delta_tsd, StimS, 60000, 0, 0);

%to compute triggered ripples spectro averaged accross stimulations
load('SWR.mat')
[Y,X] = hist(Start(RipplesEpoch,'s'),[0:1:max(Range(LFP,'s'))]);
Ripples_tsd = tsd(X*1E4,Y');
[MatRemRip,TpsRemRip] = PlotRipRaw_MC(Ripples_tsd, StimR, 60000, 0, 0);
[MatWakeRip,TpsWakeRip] = PlotRipRaw_MC(Ripples_tsd, StimW, 60000, 0, 0);
[MatSwsRip,TpsSwsERip] = PlotRipRaw_MC(Ripples_tsd, StimS, 60000, 0, 0);
[MatRemRipStart,TpsRemRipStart] = PlotRipRaw_MC(Ripples_tsd, Start(REMEp)/1e4, 60000, 0, 0);
[MatRemRipEnd,TpsRemRipEnd] = PlotRipRaw_MC(Ripples_tsd, End(REMEp)/1e4, 60000, 0, 0);

%to compute HPC spectro averaged accross stimulations
load H_Low_Spectrum
SpectroH=Spectro;
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});

% Calculate average
MnDelWake = nanmean(Data(Restrict(Delta_tsd,WakeEp)));
MnDelSWS= nanmean(Data(Restrict(Delta_tsd,SWSEp)));
MnDelRem= nanmean(Data(Restrict(Delta_tsd,REMEp)));

MnRipWake = nanmean(Data(Restrict(Ripples_tsd,WakeEp)));
MnRipSWS= nanmean(Data(Restrict(Ripples_tsd,SWSEp)));
MnRipRem= nanmean(Data(Restrict(Ripples_tsd,REMEp)));


MenThetWake = nanmean(Data(Restrict(SmoothTheta,WakeEp)));
MenThetSWS = nanmean(Data(Restrict(SmoothTheta,SWSEp)));
MenThetRem = nanmean(Data(Restrict(SmoothTheta,REMEp)));


MeanEMGWake = nanmean(Data(Restrict(LFPemg,WakeEp)));
MeanEMGSWS = nanmean(Data(Restrict(LFPemg,SWSEp)));
MeanEMGRem = nanmean(Data(Restrict(LFPemg,REMEp)));


MeanGamWake = nanmean(Data(Restrict(SmoothGamma,WakeEp)));
MeanGamSWS = nanmean(Data(Restrict(SmoothGamma,SWSEp)));
MeanGamRem = nanmean(Data(Restrict(SmoothGamma,REMEp)));

MeanBetWake = nanmean(Data(Restrict(SmoothBeta,WakeEp)));
MeanBetSWS = nanmean(Data(Restrict(SmoothBeta,SWSEp)));
MeanBetRem = nanmean(Data(Restrict(SmoothBeta,REMEp)));


%%Stim during REM 
if plo
    figure
    for tps = 1:length(StimR)
        subplot(7,1,1)
        hold on
        plot(MatRemDel(:,1),TpsRemDel(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MnDelWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MnDelSWS,'color','r','linewidth',2)
        ylabel('delta density')
        
        subplot(7,1,2)
        hold on
        plot(MatRemThet(:,1),TpsRemThet(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MenThetWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MenThetSWS,'color','r','linewidth',2)
        ylabel('theta')
        
        subplot(7,1,3)
        hold on
        plot(MatRemEMG(:,1),TpsRemEMG(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MeanEMGWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanEMGSWS,'color','r','linewidth',2)
        ylabel('EMG')
        
        subplot(7,1,4)
        hold on
        plot(MatRemGam(:,1),TpsRemGam(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MeanGamWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanGamSWS,'color','r','linewidth',2)
        ylabel('gamma')
        
        subplot(7,1,5)
        hold on
        plot(MatRemBet(:,1),TpsRemBet(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MeanBetWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanBetSWS,'color','r','linewidth',2)
        ylabel('beta')
        
        
        subplot(7,1,6)
        hold on
        plot(MatRemRip(:,1),TpsRemRip(tps,:),'g','linewidth',2)
        line(xlim,[1 1]*MnRipWake,'color','b','linewidth',2)
        line(xlim,[1 1]*MnRipSWS,'color','r','linewidth',2)
        ylabel('ripples density')
        
        subplot(7,1,7)
        imagesc(Range(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
        xlim([-30 30])
        axis xy
        pause
        clf
    end
end

end

%%Stim during Wake 
if plo
    figure
    for tps = 1:length(StimW)
        subplot(7,1,1)
        hold on
        plot(MatWakeDel(:,1),TpsWakeDel(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnDelRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MnDelSWS,'color','r','linewidth',2)
        ylabel('delta density')
        
        subplot(7,1,2)
        hold on
        plot(MatWakeThet(:,1),TpsWakeThet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MenThetRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MenThetSWS,'color','r','linewidth',2)
        ylabel('theta')
        
        subplot(7,1,3)
        hold on
        plot(MatWakeEMG(:,1),TpsWakeEMG(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanEMGSWS,'color','r','linewidth',2)
        line(xlim,[1 1]*MeanEMGRem,'color','g','linewidth',2)
        ylabel('EMG')
        
        subplot(7,1,4)
        hold on
        plot(MatWakeGam(:,1),TpsWakeGam(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanGamRem,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanGamSWS,'color','r','linewidth',2)
        ylabel('gamma')
        
        subplot(7,1,5)
        hold on
        plot(MatWakeBet(:,1),TpsWakeBet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanBetRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MeanBetSWS,'color','r','linewidth',2)
        ylabel('beta')
        
        
        subplot(7,1,6)
        hold on
        plot(MatWakeRip(:,1),TpsWakeRip(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnRipRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MnRipSWS,'color','r','linewidth',2)
        ylabel('ripples density')
        
        subplot(7,1,7)
        imagesc(Range(Restrict(sptsdH,intervalSet(StimW(tps)*1E4-60*1E4,StimW(tps)*1E4+60*1E4)),'s')-StimW(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimW(tps)*1E4-30*1E4,StimW(tps)*1E4+30*1E4))))')
        xlim([-30 30])
        axis xy
        pause
        clf
    end
end

end

%%Stim during SWS 
if plo
 figure
    for tps = 1:length(StimS)
        subplot(7,1,1)
        hold on
        plot(MatSwsDel(:,1),TpsSwsEDel(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnDelWake,'color','g','linewidth',2)
        line(xlim,[1 1]*MnDelRem,'color','r','linewidth',2)
        ylabel('delta density')
        
        subplot(7,1,2)
        hold on
        plot(MatSwsThet(:,1),TpsSwsThet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MenThetRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MenThetWake,'color','r','linewidth',2)
        ylabel('theta')
        
        subplot(7,1,3)
        hold on
        plot(MatSwsEMG(:,1),TpsSwsEMG(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanEMGWake,'color','r','linewidth',2)
        line(xlim,[1 1]*MeanEMGRem,'color','g','linewidth',2)
        ylabel('EMG')
        
        subplot(7,1,4)
        hold on
        plot(MatSwsGam(:,1),TpsSwsEGam(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanGamRem,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanGamWake,'color','r','linewidth',2)
        ylabel('gamma')
        
        subplot(7,1,5)
        hold on
        plot(MatSwsBet(:,1),TpsSwsBet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanBetRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MeanBetWake,'color','r','linewidth',2)
        ylabel('beta')
        
        subplot(7,1,6)
        hold on
        plot(MatSwsRip(:,1),TpsSwsERip(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnRipRem,'color','g','linewidth',2)
        line(xlim,[1 1]*MnRipWake,'color','r','linewidth',2)
        ylabel('ripples density')

        
        subplot(7,1,7)
        imagesc(Range(Restrict(sptsdH,intervalSet(StimS(tps)*1E4-60*1E4,StimS(tps)*1E4+60*1E4)),'s')-StimS(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimS(tps)*1E4-30*1E4,StimS(tps)*1E4+30*1E4))))')
        xlim([-30 30])
        axis xy
        caxis([6 11])
        
        pause
        clf
    end
    
end

end

%%Stim during Rem 
if plo
 figure
    for tps = 1:length(StimR)
        subplot(7,1,1)
        hold on
        plot(MatRemDel(:,1),TpsRemDel(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnDelWake,'color','g','linewidth',2)
        line(xlim,[1 1]*MnDelSWS,'color','r','linewidth',2)
        ylabel('delta density')
        
        subplot(7,1,2)
        hold on
        plot(MatRemThet(:,1),TpsRemThet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MenThetSWS,'color','g','linewidth',2)
        line(xlim,[1 1]*MenThetWake,'color','r','linewidth',2)
        ylabel('theta')
        
        subplot(7,1,3)
        hold on
        plot(MatRemEMG(:,1),TpsRemEMG(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanEMGWake,'color','r','linewidth',2)
        line(xlim,[1 1]*MeanEMGSWS,'color','g','linewidth',2)
        ylabel('EMG')
        
        subplot(7,1,4)
        hold on
        plot(MatRemGam(:,1),TpsRemEGam(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanGamSWS,'color','b','linewidth',2)
        line(xlim,[1 1]*MeanGamWake,'color','r','linewidth',2)
        ylabel('gamma')
        
        subplot(7,1,5)
        hold on
        plot(MatRemBet(:,1),TpsRemBet(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MeanBetSWS,'color','g','linewidth',2)
        line(xlim,[1 1]*MeanBetWake,'color','r','linewidth',2)
        ylabel('beta')
                
        subplot(7,1,6)
        hold on
        plot(MatRemRip(:,1),TpsRemRip(tps,:),'b','linewidth',2)
        line(xlim,[1 1]*MnRipSWS,'color','g','linewidth',2)
        line(xlim,[1 1]*MnRipWake,'color','r','linewidth',2)
        ylabel('ripples density')
        
        subplot(7,1,7)
        imagesc(Range(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
        xlim([-30 30])
        axis xy

       
        pause
        clf
    end
end

end

