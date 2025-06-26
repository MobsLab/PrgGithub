
function CorrPlot_EMG_Gamma_Ferret_Example_BM



cd('/media/nas7/React_Passive_AG/OBG/Tvorozhok/20250508')
load('SleepScoring_OBGamma.mat', 'Epoch', 'Wake', 'Sleep', 'SWSEpoch', 'REMEpoch', 'SmoothGamma', 'SmoothTheta', 'Epoch_S1', 'Epoch_S2')
smootime = 3;


load('ChannelsToAnalyse/EMG.mat', 'channel')
load(['LFPData/LFP' num2str(channel) '.mat'])

Epoch = intervalSet([0 14e7]',[4e7 18e7]');
LFP = Restrict(LFP , Epoch);
FilLFP=FilterLFP(LFP,[50 300],1024);
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
EMGData=Restrict(EMGData,Epoch);

SmoothGamma = Restrict(SmoothGamma , Epoch);
SmoothGamma_intf = Restrict(SmoothGamma,EMGData);


figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=1.5; a.EdgeColor=[0 0 0];
box off
v1=vline(2.3,'-r'); v1.LineWidth=3;
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(EMGData)),1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=1.5; a.EdgeColor=[0 0 0];
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(3.5,'-r'); v2.LineWidth=3;
xlabel('EMG power (log scale)'), xlim([2.5 6.5])

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(SmoothGamma_intf)); Y = log10(Data(EMGData));
plot(X(1:2e3:end) , Y(1:2e3:end) , '.k' , 'MarkerSize' , 3)
axis square
v1=vline(2.3,'-r'); v1.LineWidth=3;
v2=hline(3.5,'-r'); v2.LineWidth=3;
ylim([2.5 6.5])



%% Accelero

load('behavResources.mat', 'MovAcctsd')
AccData=tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
AccData=Restrict(AccData,Epoch);
SmoothGamma_onAcc = Restrict(SmoothGamma,AccData);


figure
subplot(6,6,32:36)
[Y,X] = hist(log10(Data(SmoothGamma)),1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=1.5; a.EdgeColor=[0 0 0];
box off
v1=vline(2.3,'-r'); v1.LineWidth=3;
xlabel('OB gamma power (log scale)');

subplot(6,6,[25 19 13 7 1])
[Y,X] = hist(log10(Data(AccData)),1000);
a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=1.5; a.EdgeColor=[0 0 0]; xlim([5.7 8.5])
set(gca,'XDir','reverse'), camroll(270), box off
v2=vline(7,'-r'); v2.LineWidth=3;
xlabel('Motion (log scale)');

subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
X = log10(Data(SmoothGamma_onAcc)); Y = log10(Data(AccData));
plot(X(1:100:end) , Y(1:100:end) , '.k' , 'MarkerSize' , 3)
axis square
ylim([5.7 8.5])
v1=vline(2.3,'-r'); v1.LineWidth=3;
v2=hline(7,'-r'); v2.LineWidth=3;

% cd('/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20230309_3')
% load('SleepScoring_OBGamma.mat', 'Epoch', 'Wake', 'Sleep', 'SWSEpoch', 'REMEpoch', 'SmoothGamma', 'SmoothTheta', 'Epoch_S1', 'Epoch_S2')
% smootime = 3;
% 
% 
% load('ChannelsToAnalyse/EMG.mat', 'channel')
% load(['LFPData/LFP' num2str(channel) '.mat'])
% 
% Epoch = intervalSet([0 5e7]',[.5e7 6e7]');
% LFP = Restrict(LFP , Epoch);
% FilLFP=FilterLFP(LFP,[50 300],1024);
% EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
% EMGData=Restrict(EMGData,Epoch);
% 
% SmoothGamma = Restrict(SmoothGamma , Epoch);
% SmoothGamma_intf = Restrict(SmoothGamma,EMGData);
% 
% 
% figure
% subplot(6,6,32:36)
% [Y,X] = hist(log10(Data(SmoothGamma)),1000);
% a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
% box off
% v1=vline(2.7,'-r'); v1.LineWidth=5;
% xlabel('OB gamma power (log scale)');
% 
% subplot(6,6,[25 19 13 7 1])
% [Y,X] = hist(log10(Data(EMGData)),1000);
% a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
% set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(3.5,'-r'); v2.LineWidth=5;
% xlabel('EMG power (log scale)');
% 
% subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
% X = log10(Data(SmoothGamma_intf)); Y = log10(Data(EMGData));
% plot(X(1:500:end) , Y(1:500:end) , '.k')
% axis square
% xlim([2.2 3.4])
% v1=vline(2.7,'-r'); v1.LineWidth=5;
% v2=hline(3.5,'-r'); v2.LineWidth=5;
% 
% 
% 
% %% Accelero
% 
% load('behavResources.mat', 'MovAcctsd')
% AccData=tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));
% AccData=Restrict(AccData,Epoch);
% SmoothGamma_onAcc = Restrict(SmoothGamma,AccData);
% 
% 
% figure
% subplot(6,6,32:36)
% [Y,X] = hist(log10(Data(SmoothGamma)),1000);
% a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0];
% box off
% v1=vline(2.7,'-r'); v1.LineWidth=5;
% xlabel('OB gamma power (log scale)');
% 
% subplot(6,6,[25 19 13 7 1])
% [Y,X] = hist(log10(Data(AccData)),1000);
% a = area(X , runmean(Y,10)); a.FaceColor=[.8 .8 .8]; a.LineWidth=3; a.EdgeColor=[0 0 0]; xlim([6 8.5])
% set(gca,'XDir','reverse'), camroll(270), box off
% v2=vline(6.65,'-r'); v2.LineWidth=5;
% xlabel('Motion (log scale)');
% 
% subplot(6,6,[2:6 8:12 14:18 20:24 26:30])
% X = log10(Data(SmoothGamma_onAcc)); Y = log10(Data(AccData));
% plot(X(1:25:end) , Y(1:25:end) , '.k')
% axis square
% xlim([2.2 3.4]), ylim([6 8.5])
% v1=vline(2.7,'-r'); v1.LineWidth=5;
% v2=hline(6.65,'-r'); v2.LineWidth=5;
% 
% 
% 
