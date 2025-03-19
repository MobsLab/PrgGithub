

load SleepScoring_Accelero SmoothTheta tsdMovement
%plot(Data(Restrict(tsdMovement,SmoothTheta)),Data(SmoothTheta),'k.','Markersize',1)


tps=Range(SmoothTheta);
tps=ts(tps(1:500:end));

% figure, hold on
% plot(Data(Restrict(tsdMovement, Restrict(tps,Wake))),Data(Restrict(SmoothTheta,Restrict(tps,Wake))),'b.','Markersize',1)
% plot(Data(Restrict(tsdMovement, Restrict(tps,SWSEpoch))),Data(Restrict(SmoothTheta,Restrict(tps,SWSEpoch))),'r.','Markersize',1)
% plot(Data(Restrict(tsdMovement, Restrict(tps,REMEpoch))),Data(Restrict(SmoothTheta,Restrict(tps,REMEpoch))),'g.','Markersize',1)
% set(gca,'xscale','log')
% set(gca,'yscale','log')

% plot mouvement pendant wake / NREM / REM 
figure, hold on
plot(Range(Restrict(tsdMovement,Wake),'s'),Data(Restrict(tsdMovement,Wake)),'b')
plot(Range(Restrict(tsdMovement,SWSEpoch),'s'),Data(Restrict(tsdMovement,SWSEpoch)),'r')
plot(Range(Restrict(tsdMovement,REMEpoch),'s'),Data(Restrict(tsdMovement,REMEpoch)),'g')

%mettre une ligne "tag" sur le graphe
line([8280 8280],ylim,'color','k','linewidth',2)

%929
%BeforeDrug=intervalSet(0,8400*1E4); 
%AfterDrug=intervalSet(8460*1E4,31200*1E4); 
%927
BeforeDrug=intervalSet(0,8280*1E4); 
AfterDrug=intervalSet(8340*1E4,29040*1E4); 


load('H_Low_Spectrum.mat')
%load('B_High_Spectrum.mat')

%% variables
Pf = Spectro{1};
freq = Spectro{3};
t_spec = Spectro{2}*1e4;

Stsd_log = tsd(t_spec,log10(Pf));
Stsd_norm = tsd(t_spec,freq*Pf);
%load('H_Low_Spectrum.mat')
%Stsd=tsd(Spectro{2}*1E4,Spectro{1});
%freq=Spectro{3};

figure, 
subplot(2,2,1), hold on
plot(freq,mean(Data(Restrict(Stsd,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(freq,mean(Data(Restrict(Stsd,and(Wake,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('Wake - HPC')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,3), hold on
plot(freq,mean(Data(Restrict(Stsd,and(SWSEpoch,BeforeDrug)))),'k','linewidth',2)
plot(freq,mean(Data(Restrict(Stsd,and(SWSEpoch,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('SWS - HPC')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,[2,4]), hold on
plot(freq,mean(Data(Restrict(Stsd,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(freq,mean(Data(Restrict(Stsd,and(Wake,AfterDrug)))),'r','linewidth',2)
plot(freq,mean(Data(Restrict(Stsd,and(SWSEpoch,BeforeDrug)))),'b','linewidth',2)
plot(freq,mean(Data(Restrict(Stsd,and(SWSEpoch,AfterDrug)))),'m','linewidth',2)
set(gca,'FontSize',12)


figure, 
subplot(2,1,1), hold on
plot(freq,10*log10(mean(Data(Restrict(Stsd,and(Wake,BeforeDrug))))),'k','linewidth',2)
plot(freq,10*log10(mean(Data(Restrict(Stsd,and(Wake,AfterDrug))))),'r','linewidth',2)
subplot(2,1,2), hold on
plot(freq,10*log10(mean(Data(Restrict(Stsd,and(SWSEpoch,BeforeDrug))))),'k','linewidth',2)
plot(freq,10*log10(mean(Data(Restrict(Stsd,and(SWSEpoch,AfterDrug))))),'r','linewidth',2)

%Spectre du PFC
%spectrogram of different channels
[Spdeep,tdeep,fdeep]=LoadSpectrumML(18,pwd,'low');% for PFC deep
[Spsup,tsup,fsup]=LoadSpectrumML(19,pwd,'low');% for PFC sup

Stsddeep=tsd(tdeep*1E4,Spdeep);
Stsdsup=tsd(tsup*1E4,Spsup);

figure, 
subplot(2,2,1), hold on
plot(fsup,mean(Data(Restrict(Stsdsup,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fsup,mean(Data(Restrict(Stsdsup,and(Wake,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('Wake - PFCsup')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,3), hold on
plot(fsup,mean(Data(Restrict(Stsdsup,and(SWSEpoch,BeforeDrug)))),'k','linewidth',2)
plot(fsup,mean(Data(Restrict(Stsdsup,and(SWSEpoch,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('SWS - PFCsup')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,[2,4]), hold on
plot(fsup,mean(Data(Restrict(Stsdsup,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fsup,mean(Data(Restrict(Stsdsup,and(Wake,AfterDrug)))),'r','linewidth',2)
plot(fsup,mean(Data(Restrict(Stsdsup,and(SWSEpoch,BeforeDrug)))),'b','linewidth',2)
plot(fsup,mean(Data(Restrict(Stsdsup,and(SWSEpoch,AfterDrug)))),'m','linewidth',2)

figure, 
subplot(2,2,1), hold on
plot(fdeep,mean(Data(Restrict(Stsddeep,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fdeep,mean(Data(Restrict(Stsddeep,and(Wake,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('Wake - PFCdeep')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,3), hold on
plot(fdeep,mean(Data(Restrict(Stsddeep,and(SWSEpoch,BeforeDrug)))),'k','linewidth',2)
plot(fdeep,mean(Data(Restrict(Stsddeep,and(SWSEpoch,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('SWS - PFCdeep')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,[2,4]), hold on
plot(fdeep,mean(Data(Restrict(Stsddeep,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fdeep,mean(Data(Restrict(Stsddeep,and(Wake,AfterDrug)))),'r','linewidth',2)
plot(fdeep,mean(Data(Restrict(Stsddeep,and(SWSEpoch,BeforeDrug)))),'b','linewidth',2)
plot(fdeep,mean(Data(Restrict(Stsddeep,and(SWSEpoch,AfterDrug)))),'m','linewidth',2)

%Spectre du OB
load('B_High_Spectrum.mat')

Stsd_logOB=tsd(Spectro{2}*1E4,10*log10(Spectro{1}));
StsdOB=tsd(Spectro{2}*1E4,Spectro{1});
fOB=Spectro{3};

figure, 
subplot(2,2,1), hold on
plot(fOB,mean(Data(Restrict(StsdOB,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fOB,mean(Data(Restrict(StsdOB,and(Wake,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('Wake - OB')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,3), hold on
plot(fOB,mean(Data(Restrict(StsdOB,and(SWSEpoch,BeforeDrug)))),'k','linewidth',2)
plot(fOB,mean(Data(Restrict(StsdOB,and(SWSEpoch,AfterDrug)))),'r','linewidth',2)
ylabel('Power')
xlabel('Freq')
title('SWS - OB')
legend({'Before Atropine','After Atropine'})
set(gca,'FontSize',12)
subplot(2,2,[2,4]), hold on
plot(fOB,mean(Data(Restrict(StsdOB,and(Wake,BeforeDrug)))),'k','linewidth',2)
plot(fOB,mean(Data(Restrict(StsdOB,and(Wake,AfterDrug)))),'r','linewidth',2)
plot(fOB,mean(Data(Restrict(StsdOB,and(SWSEpoch,BeforeDrug)))),'b','linewidth',2)
plot(fOB,mean(Data(Restrict(StsdOB,and(SWSEpoch,AfterDrug)))),'m','linewidth',2)
