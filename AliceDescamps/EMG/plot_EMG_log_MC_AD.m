res = pwd;
nam = 'EMG';
eval(['tempchEMG=load([res,''/ChannelsToAnalyse/',nam,'''],''channel'');'])
chEMG = tempchEMG.channel;
eval(['load(''',res,'','/LFPData/LFP',num2str(chEMG),'.mat'');'])
LFP_emg = LFP;
% resample + square signal
SqurdEMG = ResampleTSD(tsd(Range(LFP_emg), Data(LFP_emg).^2),10);
load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','SmoothTheta','Info');



%%
figure, hold on,
plot(Range(SqurdEMG)/1E4, runmean(10*log10(Data(SqurdEMG)),10))

plot(Range(Restrict(SqurdEMG,Wake))/1E4, 10*log10(Data(Restrict(SqurdEMG,Wake))),'color',[.5 .5 .5])
plot(Range(Restrict(SqurdEMG,SWSEpoch))/1E4, 10*log10(Data(Restrict(SqurdEMG,SWSEpoch))),'b')
plot(Range(Restrict(SqurdEMG,REMEpoch))/1E4, 10*log10(Data(Restrict(SqurdEMG,REMEpoch))),'r')

ru=100;
figure, hold on,
plot(Range(SqurdEMG)/1E4, runmean(10*log10(Data(SqurdEMG)),ru))
plot(Range(Restrict(SqurdEMG,SWSEpoch))/1E4, runmean(10*log10(Data(Restrict(SqurdEMG,SWSEpoch))),ru),'k.')
plot(Range(Restrict(SqurdEMG,REMEpoch))/1E4, runmean(10*log10(Data(Restrict(SqurdEMG,REMEpoch))),ru),'r.')


[counts_wake, centers_wake]=hist(real(runmean(10*log10(Data(Restrict(SqurdEMG,Wake))),ru)),100);
[counts_sws, centers_sws]=hist(real(runmean(10*log10(Data(Restrict(SqurdEMG,SWSEpoch))),ru)),100);
[counts_rem, centers_rem]=hist(real(runmean(10*log10(Data(Restrict(SqurdEMG,REMEpoch))),ru)),100);


figure, hold on
plot(counts_wake)
plot(counts_sws,'k')
plot(counts_rem,'r')
makepretty
