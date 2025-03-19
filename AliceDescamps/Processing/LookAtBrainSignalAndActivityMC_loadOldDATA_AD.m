%% Section 1 : Load data
%%get the EMG channel
res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFP_emg = LFP;
% resample + square signal
SqurdEMG = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);

%%get sleep scoring60000000
load('SleepScoring_Accelero.mat','Wake_old','SWSEpoch_old','REMEpoch_old','SmoothTheta','Info');
% load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info');

load('behavResources.mat','Vtsd','MovAcctsd');

load('SleepScoring_OBGamma.mat','SmoothGamma');

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
figure,
%spectro OB low
subplot(811),imagesc(Range(sptsdOBlow)/1E4, freqOBlow, 10*log10(SpectroOBlow.Spectro{1}')), axis xy, colorbar, ylabel('OB lo'), caxis([20 60])
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,16);
%spectro OB high
subplot(812), imagesc(Range(sptsdOBhi)/1E4, freqOBhi, 10*log10(SpectroOBhi.Spectro{1}')), axis xy, colorbar, ylabel('OB hi'), caxis([10 40])
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,75);
%spectro PFC + deltas
subplot(813),imagesc(Range(sptsdP)/1E4, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar, ylabel('PFC'), caxis([20 50])
hold on,
% plot([Start(alldeltas_PFCx)/1e4 Stop(deltas_PFCx)/1e4]',[Start(alldeltas_PFCx)/1e4 Stop(alldeltas_PFCx)/1e4]'*0+j+20,'k*')
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,10);
%spectro HPC
subplot(814),imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar, ylabel('HPC'), caxis([20 60])
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,10);
%accelero (lineaire)
subplot(815), plot(Range(MovAcctsd)/1E4, (Data(MovAcctsd))),ylim([0 7e8]),ylabel('Accelero'),colorbar
line(xlim,[Info.mov_threshold Info.mov_threshold],'color','r')
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,[1e8 1e8]);
%EMG
subplot(816), plot(Range(SqurdEMG)/1E4, 10*log10(Data(SqurdEMG))),ylim([0 120]),colorbar
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,[80 4]);
%smooth theta
subplot(817),plot(Range(SmoothTheta)/1E4,Data(SmoothTheta)),ylim([0 6]), ylabel('Smooth theta'),colorbar
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,[3,0.5]);
line(xlim,[Info.theta_thresh Info.theta_thresh],'color','r')
%smooth gamma
subplot(818), plot(Range(SmoothGamma)/1E4,Data(SmoothGamma)), ylabel('Smooth gamma'),colorbar
SleepStages=PlotSleepStage(Wake_old,SWSEpoch_old,REMEpoch_old,0,[400,100]);


%% Section 4 : assess general quality of the sleep scoring 
a=500; %define time window
%move forward in time 
a=a+500; subplot(811),xlim([a a+500]),subplot(812), xlim([a a+500]),subplot(813), xlim([a a+500]),subplot(814), xlim([a a+500]),subplot(815), xlim([a a+500]),subplot(816), xlim([a a+500]),subplot(817), xlim([a a+500]),subplot(818), xlim([a a+500])

%% Section 5 : define variables (keep the old ones and the updated ones)
%create new ones (containing the modifications)
REMEpoch2_AD=REMEpoch;
SWSEpoch2_AD=SWSEpoch;
Wake2_AD=Wake;

%% Section 6 : Parameters
st = Start(REMEpoch)/1E4;
k=1;
len=300;

%% Section 7 : to move forward (next episode)
k=k+1;
subplot(811),xlim([st(k)-20 st(k)+len]),subplot(812),xlim([st(k)-20 st(k)+len]),subplot(813),xlim([st(k)-20 st(k)+len]),subplot(814),xlim([st(k)-20 st(k)+len]),subplot(815),xlim([st(k)-20 st(k)+len]),...
    subplot(816),xlim([st(k)-20 st(k)+len]),subplot(817),xlim([st(k)-20 st(k)+len]),subplot(818),xlim([st(k)-20 st(k)+len])
k

%% Section 8 :
%%correct REM
%%if not REM : get rid of the epoch (and put it either in SWS or WAKE)
epoch=subset(REMEpoch,k);REMEpoch2_AD=REMEpoch2_AD-epoch; Wake2_AD=or(Wake2_AD,epoch); %if it is wake
epoch=subset(REMEpoch,k);REMEpoch2_AD=REMEpoch2_AD-epoch; SWSEpoch2_AD=or(SWSEpoch2_AD,epoch); %if it is sws

SleepStages=PlotSleepStage(Wake2_AD,SWSEpoch2_AD,REMEpoch2_AD,0,[400,100]);

%% correct WAKE
epoch=subset(Wake,k);Wake2_AD=Wake2_AD-epoch;REMEpoch2_AD=or(REMEpoch2_AD,epoch); %if it is REM
epoch=subset(Wake,k);Wake2_AD=Wake2_AD-epoch;SWSEpoch2_AD=or(SWSEpoch2_AD,epoch); %if it is SWS

%% correct SWS
epoch=subset(SWSEpoch,k);SWSEpoch2_AD=SWSEpoch2_AD-epoch;Wake2_AD=or(Wake2_AD,epoch); %if it is Wake
epoch=subset(SWSEpoch,k);SWSEpoch2_AD=SWSEpoch2_AD-epoch;REMEpoch2_AD=or(REMEpoch2_AD,epoch); %if it is REM


%% Section 9 : Save acc
% clear REMEpoch SWSEpoch Wake
% REMEpoch=REMEpoch2; SWSEpoch=SWSEpoch2; Wake=Wake2;

% REMEpoch=mergeCloseIntervals(REMEpoch,1*1e4); SWSEpoch=SWSEpoch-REMEpoch; Wake=Wake-REMEpoch;
% SWSEpoch=mergeCloseIntervals(SWSEpoch,1*1e4); REMEpoch=REMEpoch-SWSEpoch; Wake=Wake-SWSEpoch;

% save('SleepScoring_Accelero.mat','REMEpoch_old','SWSEpoch_old','Wake_old','REMEpoch','SWSEpoch','Wake','-append')
% save('SleepScoring_Accelero.mat','REMEpoch','SWSEpoch','Wake','-append')


%%

% save('SleepScoring_Accelero.mat','REMEpoch2','SWSEpoch2','Wake2','-append')
% REMEpoch2=mergeCloseIntervals(REMEpoch2,1*1e4); SWSEpoch2=SWSEpoch2-REMEpoch2; Wake2=Wake2-REMEpoch2;

GUI_StepOne_ExperimentInfo









%% save OB
% REMEpoch=REMEpoch2; SWSEpoch=SWSEpoch2; Wake=Wake2;
% save('SleepScoring_OBGamma.mat','REMEpoch_old','SWSEpoch_old','Wake_old','REMEpoch','SWSEpoch','Wake','-append')
% save('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake','-append')
