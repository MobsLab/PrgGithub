load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta SmoothGamma

StimWithLongBout = FindOptoStimWithLongBout_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,'rem',15);
StimR=StimWithLongBout/1E4;

% [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
% StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
% StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
% StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;

%to get theta HPC signal around the stims
[MatRemThet,TpsRemThet] = PlotRipRaw(SmoothTheta, StimR, 60000, 0, 0);
% [MatWakeThet,TpsWakeThet] = PlotRipRaw(SmoothTheta, StimW, 60000, 0, 0);
% [MatSwsThet,TpsSwsThet] = PlotRipRaw(SmoothTheta, StimS, 60000, 0, 0);


load H_Low_Spectrum
SpectroH=Spectro;
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});


%%
figure
for tps = 1:length(StimR)
    subplot(2,1,1)
    hold on
    imagesc(Range(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4))))')
    xlim([-60 60])
    axis xy
    line([0 0], ylim,'color','w')
    colorbar
    
    subplot(2,1,2)
    hold on
    plot(MatRemThet(:,1),TpsRemThet(tps,:),'r','linewidth',2)
    ylabel('theta')
    xlim([-60 60])
    line([0 0], ylim,'color','k')
    
    pause
    clf
end
