%load LFP PFC
load SleepScoring_OBGamma.mat
figure(1)
subplot(4,2,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM without Noise')
subplot(4,2,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
title('SWS without Noise')
subplot(4,2,5)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
title('Wake without Noise')
subplot(4,2,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM with Noise')
subplot(4,2,4)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on, plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
title('SWS with Noise')
subplot(4,2,6)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('Wake with Noise')
subplot(4,2,7)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on, 
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on 
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(4,2,8)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on, plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')
%suptitle('M1052 200527')
saveas(gcf,'PFCStates_with_withoutNoise.png')
saveas(gcf,'PFCStates_with_withoutNoise.fig')

%%%%
figure
subplot(2,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(2,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')
suptitle('M1055 200602 PFC')


%%%
WakeWiNoNoise=WakeWiNoise-TotalNoiseEpoch
SWSWiNoNoise=SWSEpochWiNoise-TotalNoiseEpoch
REMWiNoNoise=REMEpochWiNoise-TotalNoiseEpoch

figure(3)
subplot(3,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')

subplot(3,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')

subplot(3,1,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSWiNoNoise), 's'),Data(Restrict(LFP, SWSWiNoNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMWiNoNoise), 's'),Data(Restrict(LFP, REMWiNoNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with No Noise')
%suptitle('M1052 200527')
saveas(gcf,'PFCStates_with_without_NoNoise.png')
saveas(gcf,'PFCStates_with_without_NoNoise.fig')


%%%%%%
figure(4)
subplot(3,1,1)
plot(Range(Restrict(LFP, TotalNoiseEpoch), 's'),Data(Restrict(LFP, TotalNoiseEpoch)),'k.','markersize', 3)
title('TotalNoiseEpoch')
%xlim([1.5E4 2E4])

subplot(3,1,2)
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
title('WakeWiNoNoise')
%xlim([1.5E4 2E4])
%xlim([0 0.5E4])

subplot(3,1,3)
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('WakeWiNoise')
%xlim([1.5E4 2E4])
%suptitle('M1075 200728')
saveas(gcf,'PFCStates_TotalNoise_WakeWith_WithoitNoise.png')
saveas(gcf,'PFCStates_TotalNoise_WakeWith_WithoitNoise.fig')

%%%%%%%%%%%%%%%%%%%%%%%%%%%Hippocampus%%%%%%%%%%%%%%%%%%%%%%%
%load LFP HPC
load SleepScoring_OBGamma.mat
figure
subplot(4,2,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM without Noise')
subplot(4,2,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
title('SWS without Noise')
subplot(4,2,5)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
title('Wake without Noise')
subplot(4,2,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM with Noise')
subplot(4,2,4)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on, plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
title('SWS with Noise')
subplot(4,2,6)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('Wake with Noise')
subplot(4,2,7)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on, 
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on 
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(4,2,8)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on, plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')
%suptitle('M1052 200527 HPC')
saveas(gcf,'HPCStates_with_withoutNoise.png')
saveas(gcf,'HPCStates_with_withoutNoise.fig')

%%%%
figure
subplot(2,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(2,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')

%%%
WakeWiNoNoise=WakeWiNoise-TotalNoiseEpoch
SWSWiNoNoise=SWSEpochWiNoise-TotalNoiseEpoch
REMWiNoNoise=REMEpochWiNoise-TotalNoiseEpoch

figure
subplot(3,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')

subplot(3,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')

subplot(3,1,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSWiNoNoise), 's'),Data(Restrict(LFP, SWSWiNoNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMWiNoNoise), 's'),Data(Restrict(LFP, REMWiNoNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with No Noise')
%suptitle('M1075 200728')
saveas(gcf,'HPCStates_with_without_NoNoise.png')
saveas(gcf,'HPCStates_with_without_NoNoise.fig')


%%%%%%
figure
subplot(3,1,1)
plot(Range(Restrict(LFP, TotalNoiseEpoch), 's'),Data(Restrict(LFP, TotalNoiseEpoch)),'k.','markersize', 3)
title('TotalNoiseEpoch')
%xlim([1.5E4 2E4])

subplot(3,1,2)
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
title('WakeWiNoNoise')
%xlim([1.5E4 2E4])

subplot(3,1,3)
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('WakeWiNoise')
%xlim([1.5E4 2E4])
%suptitle('M1075 200728')
saveas(gcf,'PFCStates_TotalNoise_WakeWith_WithoitNoise.png')
saveas(gcf,'PFCStates_TotalNoise_WakeWith_WithoitNoise.fig')

%%%%%%%%%%%%%%%%%%Olfactory Bulb%%%%%%%%%%%%%%%%%%%%%%%%

%load LFP OB
load SleepScoring_OBGamma.mat
figure
subplot(4,2,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM without Noise')
subplot(4,2,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
title('SWS without Noise')
subplot(4,2,5)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
title('Wake without Noise')
subplot(4,2,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM with Noise')
subplot(4,2,4)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on, plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
title('SWS with Noise')
subplot(4,2,6)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('Wake with Noise')
subplot(4,2,7)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on, 
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on 
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(4,2,8)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on, plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')
%suptitle('M1075 200527 OB')
saveas(gcf,'OBStates_with_withoutNoise.png')
%saveas(gcf,'OBStates_with_withoutNoise.fig')

%%%%
figure
subplot(2,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')
subplot(2,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')

%%%
WakeWiNoNoise=WakeWiNoise-TotalNoiseEpoch
SWSWiNoNoise=SWSEpochWiNoise-TotalNoiseEpoch
REMWiNoNoise=REMEpochWiNoise-TotalNoiseEpoch

figure
subplot(3,1,1)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, Wake), 's'),Data(Restrict(LFP, Wake)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpoch), 's'),Data(Restrict(LFP, SWSEpoch)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpoch), 's'),Data(Restrict(LFP, REMEpoch)),'g.','markersize', 3)
title('REM, SWS, Wake without Noise')

subplot(3,1,2)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSEpochWiNoise), 's'),Data(Restrict(LFP, SWSEpochWiNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMEpochWiNoise), 's'),Data(Restrict(LFP, REMEpochWiNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with Noise')

subplot(3,1,3)
plot(Range(LFP,'s'),Data(LFP),'k')
hold on
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
hold on
plot(Range(Restrict(LFP, SWSWiNoNoise), 's'),Data(Restrict(LFP, SWSWiNoNoise)),'r.','markersize', 3)
hold on
plot(Range(Restrict(LFP, REMWiNoNoise), 's'),Data(Restrict(LFP, REMWiNoNoise)),'g.','markersize', 3)
title('REM, SWS, Wake with No Noise')
%suptitle('M1075 200728')
saveas(gcf,'OBStates_with_without_NoNoise.png')
saveas(gcf,'OBStates_with_without_NoNoise.fig')


%%%%%%
figure
subplot(3,1,1)
plot(Range(Restrict(LFP, TotalNoiseEpoch), 's'),Data(Restrict(LFP, TotalNoiseEpoch)),'k.','markersize', 3)
title('TotalNoiseEpoch')
%xlim([1.5E4 2E4])

subplot(3,1,2)
plot(Range(Restrict(LFP, WakeWiNoNoise), 's'),Data(Restrict(LFP, WakeWiNoNoise)),'b.','markersize', 3)
title('WakeWiNoNoise')
%xlim([1.5E4 2E4])

subplot(3,1,3)
plot(Range(Restrict(LFP, WakeWiNoise), 's'),Data(Restrict(LFP, WakeWiNoise)),'b.','markersize', 3)
title('WakeWiNoise')
%xlim([1.5E4 2E4])
%suptitle('M1075 200728')
saveas(gcf,'OBStates_TotalNoise_WakeWith_WithoitNoise.png')
saveas(gcf,'OBStates_TotalNoise_WakeWith_WithoitNoise.fig')