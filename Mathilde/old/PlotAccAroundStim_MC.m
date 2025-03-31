function [MStartSWS,TStartSWS,MStartREM,TStartREM,MStartWake,TStartWake,MEndSWS,TEndSWS,MEndREM,TEndREM,MEndWake,TEndWake,Mstim,Tstim] = PlotAccAroundStim_MC(plo)

try
    plo;
catch
    plo=0;
end

if exist('SleepScoring_OBGamma.mat')
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
    REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    Wake =  mergeCloseIntervals(WakeWiNoise,1E4);
else
    load SleepScoring_Accelero REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
    REMEpoch  =mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEpoch = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    Wake =  mergeCloseIntervals(WakeWiNoise,1E4);
end
    load('behavResources.mat')
    % figure,plot(Range(MovAcctsd),Data(MovAcctsd))
    
 [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
 StimW=Range(Restrict(Stimts,Wake))/1E4;
    StimS=Range(Restrict(Stimts,SWSEpoch))/1E4;
    StimR=Range(Restrict(Stimts,REMEpoch))/1E4;
    

    SqurdAccTsd=tsd(Range(MovAcctsd),Data(MovAcctsd).^2);
    
    [MStartSWS,TStartSWS] = PlotRipRaw_MC(SqurdAccTsd, Start(SWSEpoch)/1e4, 60000, 0, 0);
    [MStartREM,TStartREM] = PlotRipRaw_MC(SqurdAccTsd, Start(REMEpoch)/1e4, 60000, 0, 0);
    [MStartWake,TStartWake] = PlotRipRaw_MC(SqurdAccTsd, Start(Wake)/1e4, 60000, 0, 0);
    
    [MEndSWS,TEndSWS] = PlotRipRaw_MC(SqurdAccTsd, End(SWSEpoch)/1e4, 60000, 0, 0);
    [MEndREM,TEndREM] = PlotRipRaw_MC(SqurdAccTsd, End(REMEpoch)/1e4, 60000, 0, 0);
    [MEndWake,TEndWake] = PlotRipRaw_MC(SqurdAccTsd, End(Wake)/1e4, 60000, 0, 0);
    
    [Mstim,Tstim] = PlotRipRaw_MC(SqurdAccTsd, StimR, 60000, 0, 0);
    
    if plo
        figure,
        subplot(231),plot(MStartSWS(:,1),mean(TStartSWS))
        ylim([0e16 3.5e16])
        line([0 0], ylim,'color','k','linestyle',':')
        title('NREM start')
        subplot(232),plot(MStartREM(:,1),mean(TStartREM))
        ylim([0e16 3.5e16])
        line([0 0], ylim,'color','k','linestyle',':')
        title('REM start')
        % subplot(233),plot(Mwake(:,1),mean(TStartWake))
        % ylim([0e16 3.5e16])
        % line([0 0], ylim,'color','k','linestyle',':')
        % title('Wake start')
        
        subplot(234),plot(MEndSWS(:,1),mean(TEndSWS))
        ylim([0e16 3.5e16])
        line([0 0], ylim,'color','k','linestyle',':')
        title('NREM end')
        subplot(235),plot(MEndREM(:,1),mean(TEndREM))
        ylim([0e16 3.5e16])
        line([0 0], ylim,'color','k','linestyle',':')
        title('REM end')
        % subplot(236),plot(MEndWake(:,1),mean(TEndWake))
        % ylim([0e16 3.5e16])
        % line([0 0], ylim,'color','k','linestyle',':')
        % title('Wake end')
        
        figure,plot(Mstim(:,1),mean(Tstim))
        
    end
    



end
