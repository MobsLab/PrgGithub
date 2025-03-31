function [MatRemThet,MatRemGam,MatRemDel,MatRemRip,MatRemRipStart,MatRemRipEnd,MatRemBet,MatRemBetStart,MatRemBetEnd] = PlotMultipleParamDuringStim_MC_SB(plo)

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

load LFPData/LFP1 LFP
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
load('Ripples.mat')
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
MnDelRem= nanmean(Data(Restrict(Delta_tsd,RemEp)));


MnRipWake = nanmean(Data(Restrict(Ripples_tsd,WakeEp)));
MnRipSWS= nanmean(Data(Restrict(Ripples_tsd,SWSEp)));

MenThetWake = nanmean(Data(Restrict(SmoothTheta,WakeEp)));
MenThetSWS = nanmean(Data(Restrict(SmoothTheta,SWSEp)));

MeanEMGWake = nanmean(Data(Restrict(LFPemg,WakeEp)));
MeanEMGSWS =nanmean(Data(Restrict(LFPemg,SWSEp)));

MeanGamWake = nanmean(Data(Restrict(SmoothGamma,WakeEp)));
MeanGamSWS = nanmean(Data(Restrict(SmoothGamma,SWSEp)));
MeanBetWake = nanmean(Data(Restrict(SmoothBeta,WakeEp)));
MeanBetSWS = nanmean(Data(Restrict(SmoothBeta,SWSEp)));

%%Stim during REM 
if plo
    figure
    for tps = 1:length(StimS)
        subplot(7,1,1)
        hold on
        plot(MatRemDel(:,1),TpsRemDel(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MnDelWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MnDelSWS,'color','b','linewidth',2)
        ylabel('delta density')
        
        subplot(7,1,2)
        hold on
        plot(MatRemThet(:,1),TpsRemThet(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MenThetWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MenThetSWS,'color','b','linewidth',2)
        ylabel('theta')
        
        subplot(7,1,3)
        hold on
        plot(MatRemEMG(:,1),TpsRemEMG(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MeanEMGWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MeanEMGSWS,'color','b','linewidth',2)
        ylabel('EMG')
        
        subplot(7,1,4)
        hold on
        plot(MatRemGam(:,1),TpsRemGam(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MeanGamWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MeanGamSWS,'color','b','linewidth',2)
        ylabel('gamma')
        
        subplot(7,1,5)
        hold on
        plot(MatRemBet(:,1),TpsRemBet(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MeanBetWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MeanBetSWS,'color','b','linewidth',2)
        ylabel('beta')
        
        
        subplot(7,1,6)
        hold on
        plot(MatRemRip(:,1),TpsRemRip(tps,:),'r','linewidth',2)
        line(xlim,[1 1]*MnRipWake,'color','k','linewidth',2)
        line(xlim,[1 1]*MnRipSWS,'color','b','linewidth',2)
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

