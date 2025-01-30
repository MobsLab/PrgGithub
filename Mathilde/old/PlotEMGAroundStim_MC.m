function [MEMG_REM,MEMG_REMstart,MEMG_REMend,MEMG_SWS] = PlotEMGAroundStim_MC(plo)

load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

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
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC; % to get opto stimulations
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

% %to get EMG LFP signal around the stims
[MEMG_REMstart,TEMG_REMstart] = PlotRipRaw_MC(LFPemg, Start(REMEp)/1E4, 60000, 0, 0);

[MEMG_REMend,TEMG_REMend] = PlotRipRaw_MC(LFPemg, End(REMEp)/1E4, 60000, 0, 0);

[MEMG_REM,TEMG_REM] = PlotRipRaw_MC(LFPemg, StimR, 60000, 0, 0);

[MatWakeEMG,TpsWakeEMG] = PlotRipRaw_MC(LFPemg, StimW, 60000, 0, 0);
[MEMG_SWS,TEMG_SWS] = PlotRipRaw_MC(LFPemg, Start(SWSEp)/1E4, 60000, 0, 0);

MeanEMGWake = nanmean(Data(Restrict(LFPemg,WakeEp)));
MeanEMGSWS =nanmean(Data(Restrict(LFPemg,SWSEp)));


if plo
            figure,plot(MEMG_REM(:,1),mean(TEMG_REM))

%     figure
%     for tps = 1:length(StimR)
% 
%         hold on
%         plot(MEMG_REM(:,1),TEMG_REM(tps,:),'r','linewidth',2)
%         line(xlim,[1 1]*MeanEMGWake,'color','k','linewidth',2)
%         line(xlim,[1 1]*MeanEMGSWS,'color','b','linewidth',2)
%         ylabel('EMG')
% 
%     end
end

    end