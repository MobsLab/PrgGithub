

% EMG analysis
load('ChannelsToAnalyse/EMG.mat')
load(['LFPData/LFP' num2str(channel) '.mat'])
FilLFP=FilterLFP(LFP,[50 300],1024);
EMGData=tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(1/median(diff(Range(FilLFP,'s'))))));

thresh = GetGammaThresh(Data(EMGData) , 1 , 1);

low_emg = thresholdIntervals(EMGData,10^(thresh),'Direction','Below');
try
    load('StateEpochSB.mat', 'Sleep','Wake')
catch
    load('SleepScoring_Accelero.mat','Sleep', 'Wake')
end

figure
[Y,X]=hist(log10(Data(EMGData)),1000); Y=Y/sum(Y);
plot(X,Y,'k')
hold on
[Y,X]=hist(log10(Data(Restrict(EMGData,Wake))),1000); Y=Y/sum(Y);
plot(X,Y,'b')
[Y,X]=hist(log10(Data(Restrict(EMGData,SWSEpoch))),1000); Y=Y/sum(Y);
plot(X,Y,'r')
[Y,X]=hist(log10(Data(Restrict(EMGData,REMEpoch))),1000); Y=Y/sum(Y);
plot(X,Y,'g')


EMGData_new = Restrict(EMGData , smooth_ghi);
clear D1 D2
D1 = log(Data(EMGData_new));
D2 = log(Data(smooth_ghi));

subplot(121)
plot(D2(1:500:end) , D1(1:500:end) , '.k')
ylabel('EMG power (log scale)')
xlabel('Gamma power (log scale)')
title('Gamma/EMG power correlations, sleep session, Saline')


load('behavResources.mat', 'MovAcctsd')

EMGData_new = Restrict(EMGData , MovAcctsd);
clear D1 D2
D1 = log(Data(EMGData_new));
D2 = log(Data(MovAcctsd));

subplot(122)
plot(D2(1:50:end) , D1(1:50:end) , '.k')
ylabel('EMG power (log scale)')
xlabel('Accelero (a.u.)')


% best for splitting REM/NREM
load('LFPData/LFP19.mat')
LFP_Sleep = Restrict(LFP , Sleep);

clear X Y FilLFP EMGData EMGData_new

FilLFP=FilterLFP(LFP_Sleep,[.1 .5],1024);
[Y,~] = envelope(Data(FilLFP),ceil(10/median(diff(Range(FilLFP,'s')))),'rms');
EMGData = tsd(Range(LFP_Sleep) , Y);

clear X Y

figure
[Y,X]=hist(Data(EMGData),1000);
Y=Y/sum(Y);

plot(X,Y)

load('StateEpochSB.mat', 'smooth_01_05')
smooth_01_05_Sleep = Restrict(smooth_01_05 , Sleep);
EMGData_new = Restrict(EMGData , smooth_01_05_Sleep);


clear D1 D2
D1 = log(Data(smooth_01_05_Sleep));
D2 = log(Data(EMGData_new));

figure
plot(D2(1:500:end) , D1(1:500:end) , '.k')
xlabel('EMG power (enveloppe, filtered signal .1-.5 Hz)')
ylabel('0.1-0.5 Hz OB power (log scale)')
title('.1-.5 OB/EMG power correlations, sleep epoch, Saline')


