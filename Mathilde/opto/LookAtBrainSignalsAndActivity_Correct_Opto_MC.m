%% get data
%% get the EMG channel
res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFP_emg = LFP;
% resample + square signal
SqurdEMG = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);

%%get sleep scoring
load('SleepScoring_Accelero.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','SmoothTheta','Info');
% load('SleepScoring_OBGamma.mat','WakeWiNoise','SWSEpochWiNoise','REMEpochWiNoise','SmoothTheta','Info');

load('behavResources.mat','Vtsd','MovAcctsd')

load('SleepScoring_OBGamma.mat','SmoothGamma')
load('SleepScoring_Accelero.mat', 'Info')

%%get spectro
SpectroOBhi = load('B_High_Spectrum','Spectro');% clear REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
% REMEpochWiNoise=REMEpochWiNoise2; SWSEpochWiNoise=SWSEpochWiNoise2; WakeWiNoise=WakeWiNoise2;
% save('SleepScoring_Accelero.mat','REMEpochWiNoise_old','SWSEpochWiNoise_old','WakeWiNoise_old','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise','-append')

SpectroOBlow = load('Bulb_deep_Low_Spectrum','Spectro');
SpectroP = load('PFCx_deep_Low_Spectrum','Spectro');    
SpectroH = load('dHPC_deep_Low_Spectrum','Spectro');

% SpectroH = load('H_Low_Spectrum','Spectro'); 
% SpectroOBhi = load('B_High_Spectrum','Spectro');
% SpectroOBlow = load('B_Low_Spectrum','Spectro');

%%
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

%% figure
figure,
%spectro OB low
subplot(811),imagesc(Range(sptsdOBlow)/1E4, freqOBlow, 10*log10(SpectroOBlow.Spectro{1}')), axis xy, colorbar, ylabel('OB lo'), caxis([20 60])
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,16);
%spectro OB high
subplot(812), imagesc(Range(sptsdOBhi)/1E4, freqOBhi, 10*log10(SpectroOBhi.Spectro{1}')), axis xy, colorbar, ylabel('OB hi'), caxis([10 40])
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,75);
%spectro PFC + deltas
subplot(813),imagesc(Range(sptsdP)/1E4, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar, ylabel('PFC'), caxis([20 50])
hold on,
% plot([Start(alldeltas_PFCx)/1e4 Stop(deltas_PFCx)/1e4]',[Start(alldeltas_PFCx)/1e4 Stop(alldeltas_PFCx)/1e4]'*0+j+20,'k*')
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,10);
%spectro HPC
subplot(814),imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar, ylabel('HPC'), caxis([20 60])
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,10);
%accelero (lineaire)
subplot(815), plot(Range(MovAcctsd)/1E4, (Data(MovAcctsd))),ylim([0 7e8]),ylabel('Accelero'),colorbar
line([0 3.3E4],[Info.mov_threshold Info.mov_threshold],'color','r')
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,[1e8 1e8]);
% % %accelero log
% subplot(815), plot(Range(MovAcctsd)/1E4, 10*log10(Data(MovAcctsd))),ylim([0 7e8]),ylabel('Accelero'),colorbar %mettre accelero en log
% line([0 3.3E4],[10*log10(Info.mov_threshold) 10*log10(Info.mov_threshold)],'color','r')
%EMG
subplot(816), plot(Range(SqurdEMG)/1E4, 10*log10(Data(SqurdEMG))),ylim([0 120]),colorbar
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,[80 4]);
%smooth theta
subplot(817),plot(Range(SmoothTheta)/1E4,Data(SmoothTheta)),ylim([0 6]), ylabel('Smooth theta'),colorbar
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,[3,0.5]);
line([0 3.3E4],[Info.theta_thresh Info.theta_thresh],'color','r')
%smooth gamma
subplot(818), plot(Range(SmoothGamma)/1E4,Data(SmoothGamma)), ylabel('Smooth gamma'),colorbar
SleepStages=PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,0,[400,100]);

%% to simply move forward in time
a=500;
a=a+500; subplot(811), xlim([a a+500]),subplot(812), xlim([a a+500]),subplot(813), xlim([a a+500]),subplot(814), xlim([a a+500]),subplot(815), xlim([a a+500]),subplot(816), xlim([a a+500]),subplot(817), xlim([a a+500]),subplot(818), xlim([a a+500])

%% to correct sleep stages
%% sleep variables
%keep old variables
REMEpochWiNoise_old = REMEpochWiNoise;
SWSEpochWiNoise_old = SWSEpochWiNoise;
WakeWiNoise_old = WakeWiNoise;
%create new ones (containing the modifications)
REMEpochWiNoise2=REMEpochWiNoise;
SWSEpochWiNoise2=SWSEpochWiNoise;
WakeWiNoise2=WakeWiNoise;

%% parameters
st = Start(REMEpochWiNoise)/1E4;
k=1;
len=300;

%% to move forward (next REM episode)
k=k+1;
subplot(811),xlim([st(k)-20 st(k)+len]),subplot(812),xlim([st(k)-20 st(k)+len]),subplot(813),xlim([st(k)-20 st(k)+len]),subplot(814),xlim([st(k)-20 st(k)+len]),subplot(815),xlim([st(k)-20 st(k)+len]),...
    subplot(816),xlim([st(k)-20 st(k)+len]),subplot(817),xlim([st(k)-20 st(k)+len]),subplot(818),xlim([st(k)-20 st(k)+len])
k

%% if not REM : get rid of the epoch (and put it either in SWS or WakeWiNoise)
%%correct REM
epoch=subset(REMEpochWiNoise,k);REMEpochWiNoise2=REMEpochWiNoise2-epoch; WakeWiNoise2=or(WakeWiNoise2,epoch); %if it is WakeWiNoise
epoch=subset(REMEpochWiNoise,k);REMEpochWiNoise2=REMEpochWiNoise2-epoch; SWSEpochWiNoise2=or(SWSEpochWiNoise2,epoch); %if it is sws

%%correct WakeWiNoise
epoch=subset(WakeWiNoise,k);WakeWiNoise2=WakeWiNoise2-epoch;REMEpochWiNoise2=or(REMEpochWiNoise2,epoch); %if it is REM
epoch=subset(WakeWiNoise,k);WakeWiNoise2=WakeWiNoise2-epoch;SWSEpochWiNoise2=or(SWSEpochWiNoise2,epoch);

%%correct SWS
epoch=subset(SWSEpochWiNoise,k);SWSEpochWiNoise2=SWSEpochWiNoise2-epoch;WakeWiNoise2=or(WakeWiNoise2,epoch);
epoch=subset(SWSEpochWiNoise,k);SWSEpochWiNoise2=SWSEpochWiNoise2-epoch;REMEpochWiNoise2=or(REMEpochWiNoise2,epoch);

%% save
% clear REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
% REMEpochWiNoise=REMEpochWiNoise2; SWSEpochWiNoise=SWSEpochWiNoise2; WakeWiNoise=WakeWiNoise2;
% save('SleepScoring_Accelero.mat','REMEpochWiNoise_old','SWSEpochWiNoise_old','WakeWiNoise_old','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise','-append')
% save('SleepScoring_Accelero.mat','REMEpochWiNoise','SWSEpochWiNoise','WakeWiNoise','-append')

%%

