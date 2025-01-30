% FastAnalysisCajal

loadSubstageCajal

%LFPs=LoadLFPsCajal(voies);

nsup=2;
ndeep=3;
nhpc=4;
%nsup=4;chPFCxdeep=57;
%ndeep=3;chPFCxsup=47;
%chPFCxsup=chPFCxsp;

plotLFP(LFPs,[2:length(LFPs)],2500,1)


Delta=FindDeltaCajal(chPFCxdeep,chPFCxsup,SWSEpoch,2);
DeltaDeep=FindDeltaCajal(chPFCxdeep,[],SWSEpoch,2);
DeltaSup=FindDeltaCajal([],chPFCxsup,SWSEpoch,2);

yl=ylim;
line([Delta(:,2) Delta(:,2)],yl,'color','r')
line([DeltaSup(:,2) DeltaSup(:,2)],yl,'color','g')
line([DeltaDeep(:,2) DeltaDeep(:,2)],yl,'color','b')
line([Spi(:,2) Spi(:,2)],yl,'color','k','linewidth',2)

a=a+5; xlim([Delta(a,1)-3 Delta(a,3)+3])

try
a=a+1; xlim([Delta(a,1)-3 Delta(a,3)+3]), yl=ylim; hold on, line([Delta(a,2) Delta(a,2)],yl,'color','r','linewidth',2)
end
try
a=a+1; xlim([Spi(a,1)-3 Spi(a,3)+3]), yl=ylim; hold on, line([Spi(a,2) Spi(a,2)],yl,'color','b','linewidth',2)
end
try
a=a+1; xlim([Rip(a,1)-3 Rip(a,3)+3]), yl=ylim; hold on, line([Rip(a,2) Rip(a,2)],yl,'color','k','linewidth',2)
end


[C,B]=CrossCorr(Spi(:,2)*1E4,Delta(:,2)*1E4,50,100);
[m,s,tps]=mETAverage(Spi(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,5000);
figure, plot(B/1E3,runmean(C,2),'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Delta vs Spindles ')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])

[C,B]=CrossCorr(Delta(:,2)*1E4,Spi(:,2)*1E4,50,100);
[m,s,tps]=mETAverage(Delta(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,5000);
figure, plot(B/1E3,runmean(C,2),'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Spindles vs Delta ')
line([0 0],yl,'color',[0.7 0.7 0.7])

try
[C,B]=CrossCorr(Spi(:,2)*1E4,Rip(:,2)*1E4,50,100);
[m,s,tps]=mETAverage(Spi(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,5000);
figure, plot(B/1E3,C,'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Ripples vs Spindles ')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
try
[C,B]=CrossCorr(Rip(:,2)*1E4,Spi(:,2)*1E4,50,100);
[m,s,tps]=mETAverage(Rip(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,5000);
figure, plot(B/1E3,C,'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Spindles vs  Ripples')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
try
[C,B]=CrossCorr(Start(down_PFCx),Range(rip),20,100);
[m1,s,tps]=mETAverage(Start(down_PFCx),Range(LFPs{nsup}),Data(LFPs{nsup}),1,2000);
[m2,s,tps]=mETAverage(Start(down_PFCx),Range(LFPs{ndeep}),Data(LFPs{ndeep}),1,2000);
figure, plot(B/1E3,C,'k','linewidth',2), yl=ylim; 
hold on, plot(tps/1E3,rescale(m1,yl(1),yl(2)),'b')
hold on, plot(tps/1E3,rescale(m2,yl(1),yl(2)),'r'), title('Ripples vs Down ')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
try
[C,B]=CrossCorr(Delta(:,2)*1E4,Rip(:,2)*1E4,20,100);
[m,s,tps]=mETAverage(Delta(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,2000);
figure, plot(B/1E3,C,'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Ripples vs Delta ')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
try
[C,B]=CrossCorr(Rip(:,2)*1E4,Delta(:,2)*1E4,20,100);
[m,s,tps]=mETAverage(Rip(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nhpc}),1,2000);
figure, plot(B/1E3,C,'k','linewidth',2), yl=ylim; hold on, plot(tps/1E3,rescale(m,yl(1),yl(2)),'r'), title('Delta vs Ripples ')
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
try
[C1,B]=CrossCorr(DeltaDeep(:,2)*1E4,Rip(:,2)*1E4,20,100);
[C2,B]=CrossCorr(DeltaSup(:,2)*1E4,Rip(:,2)*1E4,20,100);
figure, plot(B/1E3,C1,'b','linewidth',2),hold on, plot(B/1E3,C2,'m','linewidth',2),yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title('Ripples versus Delta sup (m) or deep (b)')
end

[C1,B]=CrossCorr(DeltaDeep(:,2)*1E4,Spi(:,2)*1E4,50,100);
[C2,B]=CrossCorr(DeltaSup(:,2)*1E4,Spi(:,2)*1E4,50,100);
figure, plot(B/1E3,runmean(C1,2),'b','linewidth',2),hold on, plot(B/1E3,runmean(C2,2),'m','linewidth',2),yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title('Spindles versus Delta sup (s) or deep (b)')

[C1,B]=CrossCorr(Delta(:,2)*1E4,DeltaDeep(:,2)*1E4,50,100);
[C2,B]=CrossCorr(Delta(:,2)*1E4,DeltaSup(:,2)*1E4,50,100);
figure, plot(B/1E3,C1,'b','linewidth',2),hold on, plot(B/1E3,C2,'m','linewidth',2),yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
title('Delta versus Delta sup (m) or deep (b)')

[Ca,B]=CrossCorr(DeltaSup(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cb,B]=CrossCorr(DeltaDeep(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cc,B]=CrossCorr(Delta(:,2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
figure, hold on
plot(B/1E3,Ca,'r')
plot(B/1E3,Cb,'b')
plot(B/1E3,Cc,'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])


[Md2,Td2]=PlotRipRaw(LFPs{nsup},DeltaDeep(:,2),1000);close
[Md3,Td3]=PlotRipRaw(LFPs{ndeep},DeltaDeep(:,2),1000);close
nb=floor(size(Td2,2)/2);
[BE,idd]=sort(mean(Td2(:,nb-50:nb+50),2));idd=idd(end:-1:1);
figure, 
subplot(1,3,1), imagesc(Td2(idd,:)), 
subplot(1,3,2), imagesc(Td3(idd,:)), 
subplot(1,3,3), imagesc(Td2(idd,:)-Td3(idd,:))

[Ms2,Ts2]=PlotRipRaw(LFPs{nsup},DeltaSup(:,2),1000);close
[Ms3,Ts3]=PlotRipRaw(LFPs{ndeep},DeltaSup(:,2),1000);close
nb=floor(size(Ts3,2)/2);
[BE,ids]=sort(mean(Ts3(:,nb-50:nb+50),2));
figure, 
subplot(1,3,1), imagesc(Ts2(ids,:)), 
subplot(1,3,2), imagesc(Ts3(ids,:)), 
subplot(1,3,3), imagesc(Ts2(ids,:)-Ts3(ids,:))


nb=floor(length(ids)/4);
[Ca,B]=CrossCorr(DeltaSup(ids(1:nb),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cb,B]=CrossCorr(DeltaSup(ids(2*nb:3*nb),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cc,B]=CrossCorr(DeltaSup(ids(3*nb:end),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
figure, 
subplot(1,3,1), hold on
plot(B/1E3,runmean(Ca,2),'r')
plot(B/1E3,runmean(Cb,2),'b')
plot(B/1E3,runmean(Cc,2),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on
plot(Ms2(:,1),mean(Ts2(ids(1:nb),:),1),'r')
plot(Ms2(:,1),mean(Ts2(ids(2*nb:3*nb),:),1),'b')
plot(Ms2(:,1),mean(Ts2(ids(3*nb:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on
plot(Ms3(:,1),mean(Ts3(ids(1:nb),:),1),'r')
plot(Ms3(:,1),mean(Ts3(ids(2*nb:3*nb),:),1),'b')
plot(Ms3(:,1),mean(Ts3(ids(3*nb:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])


nb=floor(length(idd)/4);
[Ca,B]=CrossCorr(DeltaDeep(idd(1:nb),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cb,B]=CrossCorr(DeltaDeep(idd(2*nb:3*nb),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cc,B]=CrossCorr(DeltaDeep(idd(3*nb:end),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
figure, 
subplot(1,3,1), hold on
plot(B/1E3,runmean(Ca,2),'r')
plot(B/1E3,runmean(Cb,2),'b')
plot(B/1E3,runmean(Cc,2),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on
plot(Md2(:,1),mean(Td2(idd(1:nb),:),1),'r')
plot(Md2(:,1),mean(Td2(idd(2*nb:3*nb),:),1),'b')
plot(Md2(:,1),mean(Td2(idd(3*nb:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on
plot(Md3(:,1),mean(Td3(idd(1:nb),:),1),'r')
plot(Md3(:,1),mean(Td3(idd(2*nb:3*nb),:),1),'b')
plot(Md3(:,1),mean(Td3(idd(3*nb:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])




[m2de,s2,tps2]=mETAverage(Delta(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,1500);
[m3de,s3,tps3]=mETAverage(Delta(:,2)*1E4,Range(LFPs{ndeep}),Data(LFPs{ndeep}),1,1500);
[m2sp,s2,tps2]=mETAverage(Spi(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,1500);
[m3sp,s3,tps3]=mETAverage(Spi(:,2)*1E4,Range(LFPs{ndeep}),Data(LFPs{ndeep}),1,1500);

figure, 
subplot(1,2,1), hold on, 
plot(tps2,m2de,'k'), plot(tps3,m3de,'r'), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(1,2,2), hold on, 
plot(tps2,m2sp,'k'), plot(tps3,m3sp,'r'), 
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])

disp(' ')
disp('----------------')
disp(' ')
disp(pwd)
disp(' ')
try
disp(ti)
end
disp(' ')
disp(listChannel)
disp(' ')
