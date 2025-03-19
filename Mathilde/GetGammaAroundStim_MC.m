function [MREMGam,MStartREMGam,MEndREMGam,MWakeGam,MStartWakeGam,MEndWakeGam] = GetGammaAroundStim_MC

load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothGamma
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);


%to get opto stimulations
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC; %to get opto stimulations
StimW=Range(Restrict(Stimts,WakeEp))/1E4;
StimS=Range(Restrict(Stimts,SWSEp))/1E4;
StimR=Range(Restrict(Stimts,REMEp))/1E4;


%to get gamma OB signal around the stims
[MREMGam,TREMGam] = PlotRipRaw_MC(SmoothGamma, StimR, 60000, 0, 0);
[MStartREMGam,TStartREMGam] = PlotRipRaw_MC(SmoothGamma, Start(REMEp)/1E4, 60000, 0, 0);
[MEndREMGam,TEndREMGam] = PlotRipRaw_MC(SmoothGamma, End(REMEp)/1E4, 60000, 0, 0);

[MWakeGam,TWakeGam] = PlotRipRaw_MC(SmoothGamma, StimW, 60000, 0, 0);
[MStartWakeGam,TStartWakeGam] = PlotRipRaw_MC(SmoothGamma, Start(WakeEp)/1E4, 60000, 0, 0);
[MEndWakeGam,TEndWakeGam] = PlotRipRaw_MC(SmoothGamma, End(WakeEp)/1E4, 60000, 0, 0);



% if plo
%     figure
%     for tps = 1:length(StimR)
%    
% 
%         hold on
%         plot(MatRemGam(:,1),TpsRemGam(tps,:),'r','linewidth',2)
%         line(xlim,[1 1]*MeanGamWake,'color','k','linewidth',2)
%         line(xlim,[1 1]*MeanGamSWS,'color','b','linewidth',2)
%         ylabel('gamma')
%     
%         xlim([-30 30])
%         axis xy
%         pause
%         clf
%     end
% end


    end