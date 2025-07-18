
%go to directory
cd('/media/nas7/ProjetPFCVLPO/M1580/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1580_SD_SalInj_SleepPostSD_240522_100324')

%load data
load('/media/nas7/ProjetPFCVLPO/M1580/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1580_SD_SalInj_SleepPostSD_240522_100324/LFPData/LFP35.mat')
load('SleepScoring_Accelero.mat', 'Info')
load('SleepScoring_Accelero.mat', 'SmoothTheta')
load SleepScoring_Accelero SWSEpoch REMEpoch  Wake
load('H_Low_Spectrum.mat')

%define variables
t=Spectro{2};
f=Spectro{3};
Sp=Spectro{1};
Stsd=tsd(t*1E4,Sp);

%define new gamma
highgamma=tsd(Range(Stsd),mean(Sp(:,find(f>70&f<90)),2));


%plot spectrum
figure, plot(f,f.*mean(Restrict(Stsd,Wake)),'b')
hold on, plot(f,f.*mean(Restrict(Stsd,SWSEpoch)),'k')
hold on, plot(f,f.*mean(Restrict(Stsd,REMEpoch)),'r')


%plot spectro and sleep stages
figure,
subplot(2,1,1), imagesc(t,f,log10(Sp')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(LFP,'s'),Data(LFP)/1E3+10,'k')
subplot(2,1,2), imagesc(t,f,log10(Sp')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(SmoothTheta,'s'),Data(SmoothTheta)/1E2+10,'k')
line(xlim,[Info.theta_thresh Info.theta_thresh]/1E2+10,'color','r')

colormap hot
colormap jet
colormap parula
caxis([0 5])


d=Start(SWSEpoch,'s');
a=1; deb=d(a);xlim([deb-5, deb+10])
a=a+1; deb=d(a);xlim([deb-5, deb+10]), title(num2str(a))


%%
load('H_Low_Spectrum.mat')

t2=Spectro{2};
f2=Spectro{3};
Sp2=Spectro{1};
Stsd2=tsd(t2*1E4,Sp2);

figure, plot(f2,f2.*mean(Restrict(Stsd2,Wake)),'k')
hold on, plot(f2,f2.*mean(Restrict(Stsd2,SWSEpoch)),'b')
hold on, plot(f2,f2.*mean(Restrict(Stsd2,REMEpoch)),'r')


%plot spectro and sleep stages
figure,
subplot(2,1,1), imagesc(t2,f2,log10(Sp2')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(LFP,'s'),Data(LFP)/1E3+10,'k')
subplot(2,1,2), imagesc(t2,f2,log10(Sp2')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(SmoothTheta,'s'),Data(SmoothTheta)/1E2+10,'k')
line(xlim,[Info.theta_thresh Info.theta_thresh]/1E2+10,'color','r')