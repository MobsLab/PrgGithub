


load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
load(strcat('LFPData/LFP',num2str(channel),'.mat'));

load('SleepScoring_OBGamma.mat')
load('B_Middle_Spectrum.mat')

LFP_Bulb_Wake=Restrict(LFP,Wake);
LFP_Bulb_NREM=Restrict(LFP,SWSEpoch);
LFP_Bulb_REM=Restrict(LFP,REMEpoch);

% High OB on Low OB LFP [2 5]
[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_Wake,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
xlim([20 100]); ylim([0 1.7e4])
ylim([20 100]); caxis([0 1.1e4])
a=suptitle('High OB spectro on Low OB phase, Wake'); a.FontSize=20;

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_NREM,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
a=suptitle('High OB spectro on Low OB phase, NREM'); a.FontSize=20;
ylim([20 100]); caxis([0 2.7e3])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_Bulb_REM,Spectro{1},Spectro{2},Spectro{3},[2 5],30)
a=suptitle('High OB spectro on Low OB phase, REM'); a.FontSize=20;
ylim([20 100]); caxis([0 7e3])

xlabel('Frequency (Hz)')
ylabel('Power (a.u.)')

xlabel('Phase (degrees)')
ylabel('Frequency (Hz)')

title('Wake, OB high spectrumon OB low phase')
title('NREM, OB high spectrumon OB low phase')
title('REM, OB high spectrumon OB low phase')



load('ChannelsToAnalyse/dHPC_deep.mat')
channel;
load(strcat('LFPData/LFP',num2str(ch),'.mat'));

load('/media/nas4/ProjetEmbReact/Mouse750/20180702/ProjectEmbReact_M750_20180702_BaselineSleep/LFPData/LFP2.mat')
LFP_HPC_REM=Restrict(LFP,REMEpoch);
LFP_HPC_Wake=Restrict(LFP,Wake);

% High OB on Low OB LFP [2 5]
[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_HPC_REM,Spectro{1},Spectro{2},Spectro{3},[5 10],30)
a=suptitle('High OB spectro on Low HPC phase, REM'); a.FontSize=20;
ylim([20 100]); caxis([0 5e3])

[P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP_HPC_Wake,Spectro{1},Spectro{2},Spectro{3},[5 10],30)
a=suptitle('High OB spectro on Low HPC phase, Wake'); a.FontSize=20;
ylim([20 100]); caxis([0 2e4])








clear channel
load('ChannelsToAnalyse/Bulb_deep.mat')
channel;
MiddleSpectrum_BM([cd filesep],channel,'B')

load('B_Middle_Spectrum.mat')
load('SleepSubstages.mat')

Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
Sptsd_Wake=Restrict(Sptsd,Wake);
Sptsd_NREM=Restrict(Sptsd,SWSEpoch);
Sptsd_REM=Restrict(Sptsd,REMEpoch);

Sptsd_N1=Restrict(Sptsd,Epoch{1});
Sptsd_N2=Restrict(Sptsd,Epoch{2});
Sptsd_N3=Restrict(Sptsd,Epoch{3});



figure
plot(Spectro{3} , nanmean(Data(Sptsd_Wake)),'b')
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_NREM)),'r')
plot(Spectro{3} , nanmean(Data(Sptsd_REM)),'g')
legend('Wake','NREM','REM')
makepretty
ylim([0 3e4])
vline(47,'--b'); vline(80,'--b'); 
vline(22,'--r'); vline(32,'--r'); 
vline(24,'--g'); vline(47,'--g'); 
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')

figure
plot(Spectro{3} , nanmean(Data(Sptsd_N1)),'Color',[1, 0.8, 0.8])
hold on
plot(Spectro{3} , nanmean(Data(Sptsd_N2)),'Color',[1, 0.4, 0.4])
plot(Spectro{3} , nanmean(Data(Sptsd_N3)),'Color',[0.8, 0, 0])
legend('N1','N2','N3')
makepretty
ylim([0 1e4])
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
title('OB oscillations during baseline sleep')



%% Do it on all mice
Mouse=[739 740 750 775 849 829 851 856 857];
[OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','accelero','heartrate','heartratevar','respi','ob_low','ob_high','hpc_low','pfc_low');






