%% Section 1 : Load data
%get the EMG channel
res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFP_emg = LFP;
% resample + square signal
SqurdEMG = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);

%%get sleep scoring
Accelero_Scoring = load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info');
OB_Scoring = load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','SmoothGamma','Info');
% load('SleepScoring_OBGamma_newgamma.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','SmoothGamma','Info');

load('behavResources.mat','Vtsd','MovAcctsd')

%%get spectro
SpectroOBhi = load('B_High_Spectrum','Spectro');
SpectroOBlow = load('Bulb_deep_Low_Spectrum','Spectro');
SpectroP = load('PFCx_deep_Low_Spectrum','Spectro');
% SpectroH = load('dHPC_deep_Low_Spectrum','Spectro');

SpectroH = load('H_Low_Spectrum','Spectro'); 
% SpectroOBhi = load('B_High_Spectrum','Spectro');
% SpectroOBlow = load('B_Low_Spectrum','Spectro');

%% Section 2 : Make tsd
% spectro OB low
freqOBlow = SpectroOBlow.Spectro{3};
sptsdOBlow = tsd(SpectroOBlow.Spectro{2}*1e4, SpectroOBlow.Spectro{1});
% spectro OB high
freqOBhi = SpectroOBhi.Spectro{3};
sptsdOBhi = tsd(SpectroOBhi.Spectro{2}*1e4, SpectroOBhi.Spectro{1});
% spectro PFC
freqP = SpectroP.Spectro{3};
sptsdP = tsd(SpectroP.Spectro{2}*1e4, SpectroP.Spectro{1});
% spectro HPC
freqH = SpectroH.Spectro{3};
sptsdH = tsd(SpectroH.Spectro{2}*1e4, SpectroH.Spectro{1});

%% Section 3 : Figure
figure ('color',[1 1 1]),
suptitle(pwd)
%spectro PFC
subplot(611),imagesc(Range(sptsdP)/1E4, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar,xlim([0 3e4]), ylabel('PFC'), caxis([20 50])
set(gca,'xticklabel',[])
%spectro HPC
subplot(612),imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar,xlim([0 3e4]), ylabel('HPC'), caxis([20 60])
SleepStages=PlotSleepStage(OB_Scoring.Wake,OB_Scoring.SWSEpoch,OB_Scoring.REMEpoch,0,10);
set(gca,'xticklabel',[])
%spectro OB high
subplot(613), imagesc(Range(sptsdOBhi)/1E4, freqOBhi, 10*log10(SpectroOBhi.Spectro{1}')), axis xy, colorbar, xlim([0 3e4]),ylabel('OB hi'), caxis([10 40])
SleepStages=PlotSleepStage(OB_Scoring.Wake,OB_Scoring.SWSEpoch,OB_Scoring.REMEpoch,0,75);
set(gca,'xticklabel',[])
%spectro HPC
subplot(614),imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar,xlim([0 3e4]), ylabel('HPC'), caxis([20 60])
SleepStages=PlotSleepStage(Accelero_Scoring.Wake,Accelero_Scoring.SWSEpoch,Accelero_Scoring.REMEpoch,0,10);
set(gca,'xticklabel',[])
%accelero (lineaire)
subplot(615), 
plot(Range(MovAcctsd)/1E4, (Data(MovAcctsd))),xlim([0 3e4]),ylim([0 7e8]),ylabel('Accelero'),colorbar
SleepStages=PlotSleepStage(Accelero_Scoring.Wake,Accelero_Scoring.SWSEpoch,Accelero_Scoring.REMEpoch,0,[1e8 1e8]);
set(gca,'xticklabel',[])
%EMG
subplot(616),
plot(Range(SqurdEMG)/1E4, 10*log10(Data(SqurdEMG))),xlim([0 3e4]),ylim([0 120]),colorbar
SleepStages=PlotSleepStage(Accelero_Scoring.Wake,Accelero_Scoring.SWSEpoch,Accelero_Scoring.REMEpoch,0,[80 4]);
% set(gca,'xticklabel',[])

% %smooth theta
% subplot(817),plot(Range(SmoothTheta)/1E4,Data(SmoothTheta)),ylim([0 6]), ylabel('Smooth theta'),colorbar
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[3,0.5]);
% line([0 4.3E4],[Info.theta_thresh Info.theta_thresh],'color','r')
% set(gca,'xticklabel',[])
% %smooth gamma
% subplot(818), plot(Range(SmoothGamma)/1E4,Data(SmoothGamma)), ylabel('Smooth gamma'),colorbar
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[400,100]);
