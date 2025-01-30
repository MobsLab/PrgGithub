

load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta SmoothGamma
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
StimR=Range(Restrict(Stimts,REMEp))/1E4;

load Bulb_deep_Low_Spectrum
SpectroB=Spectro;
sptsdB= tsd(SpectroB{2}*1e4, SpectroB{1});



%% whole OB spectro with stim and REM ep
figure,imagesc(Spectro{2},Spectro{3},log(Spectro{1}')), axis xy
caxis([4 15])
hold on
line([Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]',[Start(REMEpochWiNoise)/3600e4 Stop(REMEpochWiNoise)/3600e4]'*0+20,'color','k','linewidth',10)
plot(StimREM/3600e4,20,'r*')


%% OB spectro stim per stim
figure
for tps = 1:length(StimR)
    imagesc(Range(Restrict(sptsdB,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdB,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
    axis xy
    line([0 0],ylim,'color','w','linestyle','-')
    ylim([10 30])
    xlim([-60 60])
    colormap(jet)
%     caxis([7 9.5])
    pause
    clf
end


%%

