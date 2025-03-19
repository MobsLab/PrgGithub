cd /media/mobschapeau/DataMOBS165/OPTO_1341_BaselineSleep_1332_opto20Hz30s_220721_090119/1332/
cd /media/mobschapeau/DataMOBS165/OPTO_1340_BaselineSleep_1333_opto20Hz30s_220719_091042/1333/
cd /media/mobschapeau/DataMOBS165/OPTO_1332_BaselineSleep_1340_opto20Hz30s_220720_092548/1340/
cd /media/mobschapeau/DataMOBS165/OPTO_1341_opto20Hz30s_220722_091429/

cd /media/mobschapeau/DataMOBS165/OPTO_1332_sham_220726_085614/
cd /media/mobschapeau/DataMOBS165/OPTO_1333_sham_220727_085052/
cd /media/mobschapeau/DataMOBS165/OPTO_1340_sham_220728_085506/
cd /media/mobschapeau/DataMOBS165/OPTO_1341_sham_220729_090030/


    
    %%
load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','SmoothTheta')
[Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise);
StimW=Range(Restrict(Stimts,WakeWiNoise))/1E4;
StimS=Range(Restrict(Stimts,SWSEpochWiNoise))/1E4;
StimR=Range(Restrict(Stimts,REMEpochWiNoise))/1E4;

[MatRemThet,TpsRemThet] = PlotRipRaw(SmoothTheta, StimR, 60000, 0, 0);
[MatWakeThet,TpsWakeThet] = PlotRipRaw(SmoothTheta, StimW, 60000, 0, 0);
[MatSwsThet,TpsSwsThet] = PlotRipRaw(SmoothTheta, StimS, 60000, 0, 0);

load('dHPC_deep_Low_Spectrum');
% load('PFCx_deep_Low_Spectrum');
SpectroH=Spectro;
sptsdH= tsd(SpectroH{2}*1e4, SpectroH{1});


load('VLPO_Low_Spectrum');
SpectroV=Spectro;
sptsdV= tsd(SpectroV{2}*1e4, SpectroV{1});
[MH,SH,tH]=AverageSpectrogram(tsd(SpectroV{2}*1E4,10*log10(SpectroV{1})),SpectroV{3},ts(Stim),500,300);


%%
figure
for tps = 1:length(StimR)
    subplot(2,1,2)
    hold on
    plot(MatRemThet(:,1),TpsRemThet(tps,:),'r','linewidth',2)
    line([0 0],ylim,'color','k','linewidth',2)
    xlim([-60 60])
    ylabel('theta')
    
    subplot(2,1,1)   
%     imagesc(Range(Restrict(sptsdV,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdV,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
    imagesc(Range(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdH,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
    line([0 0],ylim,'color','w','linewidth',2)
    xlim([-60 60])
    axis xy
    pause
    clf
end


%%
figure
for tps = 1:length(StimR)
 
    imagesc(Range(Restrict(sptsdV,intervalSet(StimR(tps)*1E4-60*1E4,StimR(tps)*1E4+60*1E4)),'s')-StimR(tps),Spectro{3},log(Data(Restrict(sptsdV,intervalSet(StimR(tps)*1E4-30*1E4,StimR(tps)*1E4+30*1E4))))')
    line([0 0],ylim,'color','w','linewidth',2)
    xlim([-60 60])
    axis xy
    pause
    clf
end