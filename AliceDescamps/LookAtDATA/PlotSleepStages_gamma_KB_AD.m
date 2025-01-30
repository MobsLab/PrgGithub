
%go to directory
cd('/media/nas7/ProjetPFCVLPO/M1580/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1580_SD_SalInj_SleepPostSD_240522_100324')

%load data
load('/media/nas7/ProjetPFCVLPO/M1580/20240522/SleepPostSD_SalineInjection/mCherry_CRH_1580_SD_SalInj_SleepPostSD_240522_100324/LFPData/LFP27.mat')
load('SleepScoring_OBGamma.mat', 'Info')
load('SleepScoring_OBGamma.mat', 'SmoothTheta')
load('SleepScoring_OBGamma.mat', 'SmoothGamma')
load SleepScoring_OBGamma SWSEpoch REMEpoch  Wake
load('B_High_Spectrum.mat')

%define variables
t=Spectro{2};
f=Spectro{3};
Sp=Spectro{1};
Stsd=tsd(t*1E4,Sp);

%define new gamma
highgamma=tsd(Range(Stsd),mean(Sp(:,find(f>70&f<90)),2));


%plot spectrum
figure, plot(f,f.*mean(Restrict(Stsd,Wake)),'k')
hold on, plot(f,f.*mean(Restrict(Stsd,SWSEpoch)),'b')
hold on, plot(f,f.*mean(Restrict(Stsd,REMEpoch)),'r')


%plot spectro and sleep stages
figure,
subplot(2,1,1), imagesc(t,f,log10(Sp')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[70 4]);
hold on, plot(Range(LFP,'s'),Data(LFP)/1E3+50,'k')
subplot(2,1,2), imagesc(t,f,log10(Sp')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[70 4]);
hold on, plot(Range(SmoothGamma,'s'),Data(SmoothGamma)/1E2+50,'k')
line(xlim,[Info.gamma_thresh Info.gamma_thresh]/1E2+50,'color','r')
hold on, plot(Range(highgamma,'s'),runmean(Data(highgamma)/1E3+30,10000),'b')
line(xlim,[32 32],'color','w')

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

figure, plot(f2,f2.*mean(Restrict(Stsd2,Wake)),'-k')
hold on, plot(f2,f2.*mean(Restrict(Stsd2,SWSEpoch)),'-b')
hold on, plot(f2,f2.*mean(Restrict(Stsd2,REMEpoch)),'-r')


%plot spectro and sleep stages
figure,
subplot(2,1,1), imagesc(t2,f2,log10(Sp2')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(LFP,'s'),Data(LFP)/1E3+10,'k')
subplot(2,1,2), imagesc(t2,f2,log10(Sp2')),axis xy
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[12 1]);
hold on, plot(Range(SmoothTheta,'s'),Data(SmoothTheta)/1E2+10,'k')
line(xlim,[Info.theta_thresh Info.theta_thresh]/1E2+10,'color','r')