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
load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info');
% load('SleepScoring_Accelero_KB_corrections.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info','tsdMovement');

% load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info');

load('behavResources.mat','Vtsd','MovAcctsd')

load('SleepScoring_OBGamma.mat','SmoothGamma')

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
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,16);
set(gca,'xticklabel',[])
%spectro OB high
subplot(812), imagesc(Range(sptsdOBhi)/1E4, freqOBhi, 10*log10(SpectroOBhi.Spectro{1}')), axis xy, colorbar, ylabel('OB hi'), caxis([10 40])
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,75);
set(gca,'xticklabel',[])
%spectro PFC + deltas
subplot(813),imagesc(Range(sptsdP)/1E4, freqP, 10*log10(SpectroP.Spectro{1}')), axis xy, colorbar, ylabel('PFC'), caxis([20 50])
hold on,
% plot([Start(alldeltas_PFCx)/1e4 Stop(deltas_PFCx)/1e4]',[Start(alldeltas_PFCx)/1e4 Stop(alldeltas_PFCx)/1e4]'*0+j+20,'k*')
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,10);
set(gca,'xticklabel',[])
%spectro HPC
subplot(814),imagesc(Range(sptsdH)/1E4, freqH, 10*log10(SpectroH.Spectro{1}')), axis xy, colorbar, ylabel('HPC'), caxis([20 60])
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,10);
set(gca,'xticklabel',[])
%accelero (lineaire)
subplot(815), 
plot(Range(MovAcctsd)/1E4, (Data(MovAcctsd))),ylim([0 7e8]),ylabel('Accelero'),colorbar
% plot(Range(tsdMovement)/1E4, (Data(tsdMovement))),ylim([0 7e8]),ylabel('Accelero'),colorbar
line([0 3.3E4],[Info.mov_threshold Info.mov_threshold],'color','r')
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[1e8 1e8]);
set(gca,'xticklabel',[])
%EMG
subplot(816), plot(Range(SqurdEMG)/1E4, 10*log10(Data(SqurdEMG))),ylim([0 120]),colorbar
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[80 4]);
set(gca,'xticklabel',[])
%smooth theta
subplot(817),plot(Range(SmoothTheta)/1E4,Data(SmoothTheta)),ylim([0 6]), ylabel('Smooth theta'),colorbar
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[3,0.5]);
line([0 4.3E4],[Info.theta_thresh Info.theta_thresh],'color','r')
set(gca,'xticklabel',[])
%smooth gamma
subplot(818), plot(Range(SmoothGamma)/1E4,Data(SmoothGamma)), ylabel('Smooth gamma'),colorbar
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[400,100]);

%% Section 4 : assess general quality of the sleep scoring 
%define time window
a=500; 
%move forward in time 
dur=500;
a=a+dur;subplot(811), xlim([a a+dur]),subplot(812), xlim([a a+dur]),subplot(813), xlim([a a+dur]),subplot(814), xlim([a a+dur]),subplot(815), xlim([a a+dur]),subplot(816), xlim([a a+dur]),subplot(817), xlim([a a+dur]),subplot(818), xlim([a a+dur])

%% Section 5 : define variables (keep the old ones and the updated ones)
%keep old variables
REMEpoch_old = REMEpoch;
SWSEpoch_old = SWSEpoch;
Wake_old = Wake;
%create new ones (containing the modifications)
REMEpoch2=REMEpoch;
SWSEpoch2=SWSEpoch;
Wake2=Wake;

%% Section 6 : Parameters
st = Start(SWSEpoch)/1E4;
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
epoch=subset(REMEpoch,k);REMEpoch2=REMEpoch2-epoch; Wake2=or(Wake2,epoch); %if it is wake
epoch=subset(REMEpoch,k);REMEpoch2=REMEpoch2-epoch; SWSEpoch2=or(SWSEpoch2,epoch); %if it is sws
SleepStages=PlotSleepStage(Wake2,SWSEpoch2,REMEpoch2,0,[400,100]);

%%
%%correct WAKE
epoch=subset(Wake,k);Wake2=Wake2-epoch;REMEpoch2=or(REMEpoch2,epoch); %if it is REM
epoch=subset(Wake,k);Wake2=Wake2-epoch;SWSEpoch2=or(SWSEpoch2,epoch); %if it is SWS

%%
%%correct SWS
epoch=subset(SWSEpoch,k);SWSEpoch2=SWSEpoch2-epoch;Wake2=or(Wake2,epoch); %if it is Wake
epoch=subset(SWSEpoch,k);SWSEpoch2=SWSEpoch2-epoch;REMEpoch2=or(REMEpoch2,epoch); %if it is REM

%% Section 9 : Save acc
% clear REMEpoch SWSEpoch Wake
% REMEpoch=REMEpoch2; SWSEpoch=SWSEpoch2; Wake=Wake2;
% save('SleepScoring_Accelero.mat','REMEpoch_old','SWSEpoch_old','Wake_old','REMEpoch','SWSEpoch','Wake','-append')
% save('SleepScoring_Accelero.mat','REMEpoch','SWSEpoch','Wake','-append')


% 
% limREM=1; 
% REMEpoch = mergeCloseIntervals(REMEpoch, limREM*1e4); SWSEpoch=SWSEpoch-REMEpoch; Wake=Wake-REMEpoch;
% limSWS=1; 
% SWSEpoch = mergeCloseIntervals(SWSEpoch, limSWS*1e4); REMEpoch=REMEpoch-SWSEpoch; Wake=Wake-SWSEpoch;
% limWake=1; 
% Wake = mergeCloseIntervals(Wake, limWake*1e4); SWSEpoch=SWSEpoch-Wake; REMEpoch=REMEpoch-Wake;





%% save OB
% REMEpoch=REMEpoch2; SWSEpoch=SWSEpoch2; Wake=Wake2;
% save('SleepScoring_OBGamma.mat','REMEpoch_old','SWSEpoch_old','Wake_old','REMEpoch','SWSEpoch','Wake','-append')
% save('SleepScoring_OBGamma.mat','REMEpoch','SWSEpoch','Wake','-append')



%%

limREM=3;
REMEpoch = mergeCloseIntervals(REMEpoch,limREM*1e4); SWSEpoch = SWSEpoch - REMEpoch; Wake = Wake - REMEpoch;