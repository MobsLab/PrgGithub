% GoodDeltaVersusBadDalta

chPFCxsup=input('Choose the number of LFP PFCx superficial: ');
chPFCxdeep=input('Choose the number of LFP PFCx deep: ');
chHpc=input('Choose the number of LFP Hpc rip: ');

clear LFPs
clear LFP
clear S

res=pwd;
disp(pwd)

try
load StateEpochSB Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch;
catch
load SleepScoring_OBGamma Wake REMEpoch SWSEpoch TotalNoiseEpoch
Wake=Wake-TotalNoiseEpoch;
REMEpoch=REMEpoch-TotalNoiseEpoch;
SWSEpoch=SWSEpoch-TotalNoiseEpoch;
WakeEpoch=Wake-TotalNoiseEpoch; 
end


load SleepSubstages
N1=Epoch{1};
N2=Epoch{2};
N3=Epoch{3};
REM=Epoch{4};
WAKE=Epoch{5};

EpochForDelta=SWSEpoch;
EpochForDelta=or(N2,N3);

try
load('Ripples.mat')
rip=ts(Ripples(:,2)*10);
Rip=Ripples;
Rip(:,1:3)=Rip(:,1:3)/1E3;
end

load('Spindles.mat')
spi=ts(spindles_PFCx(:,2)*1E4);
spi=Restrict(spi,EpochForDelta);
Spi=spindles_PFCx;

load('SpikeData.mat')
try
S=tsdArray(S);
end
numNeurons=GetSpikesFromStructure('PFCx');
S=S(numNeurons);

LFPs=LoadLFPsCajal([chPFCxsup chPFCxdeep chHpc]);
try
    LFPs=tsdArray(LFPs);
end

nsup=1;
ndeep=2;

rg=Range(LFPs{1},'s');

Delta=FindDeltaCajal(chPFCxdeep,chPFCxsup,EpochForDelta,2);
DeltaDeep=FindDeltaCajal(chPFCxdeep,[],EpochForDelta,2);
DeltaSup=FindDeltaCajal([],chPFCxsup,EpochForDelta,2);

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


nbs=floor(length(ids)/4);
[Ca,B]=CrossCorr(DeltaSup(ids(1:nbs),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cb,B]=CrossCorr(DeltaSup(ids(2*nbs:3*nbs),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cc,B]=CrossCorr(DeltaSup(ids(3*nbs:end),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
figure, 
subplot(1,3,1), hold on
plot(B/1E3,runmean(Ca,2),'r')
plot(B/1E3,runmean(Cb,2),'b')
plot(B/1E3,runmean(Cc,2),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on
plot(Ms2(:,1),mean(Ts2(ids(1:nbs),:),1),'r')
plot(Ms2(:,1),mean(Ts2(ids(2*nbs:3*nbs),:),1),'b')
plot(Ms2(:,1),mean(Ts2(ids(3*nbs:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on
plot(Ms3(:,1),mean(Ts3(ids(1:nbs),:),1),'r')
plot(Ms3(:,1),mean(Ts3(ids(2*nbs:3*nbs),:),1),'b')
plot(Ms3(:,1),mean(Ts3(ids(3*nbs:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])


nbd=floor(length(idd)/4);
[Ca,B]=CrossCorr(DeltaDeep(idd(1:nbd),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cb,B]=CrossCorr(DeltaDeep(idd(2*nbd:3*nbd),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
[Cc,B]=CrossCorr(DeltaDeep(idd(3*nbd:end),2)*1E4,Range(PoolNeurons(S,1:length(S))),10,300);
figure, 
subplot(1,3,1), hold on
plot(B/1E3,runmean(Ca,2),'r')
plot(B/1E3,runmean(Cb,2),'b')
plot(B/1E3,runmean(Cc,2),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,2), hold on
plot(Md2(:,1),mean(Td2(idd(1:nbd),:),1),'r')
plot(Md2(:,1),mean(Td2(idd(2*nbd:3*nbd),:),1),'b')
plot(Md2(:,1),mean(Td2(idd(3*nbd:end),:),1),'k')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])

subplot(1,3,3), hold on
plot(Md3(:,1),mean(Td3(idd(1:nbd),:),1),'r')
plot(Md3(:,1),mean(Td3(idd(2*nbd:3*nbd),:),1),'b')
plot(Md3(:,1),mean(Td3(idd(3*nbd:end),:),1),'k')
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



[Cd1,B]=CrossCorr(DeltaDeep(idd(1:nbd),2)*1E4,Range(spi),100,100); 
[Cd2,B]=CrossCorr(DeltaDeep(idd(3*nbd:end),2)*1E4,Range(spi),100,100); 

[Cs1,B]=CrossCorr(DeltaSup(ids(1:nbs),2)*1E4,Range(spi),100,100); 
[Cs2,B]=CrossCorr(DeltaSup(ids(3*nbs:end),2)*1E4,Range(spi),100,100); 

try
[Cd1r,Br]=CrossCorr(DeltaDeep(idd(1:nbd),2)*1E4,Range(rip),10,100); 
[Cd2r,Br]=CrossCorr(DeltaDeep(idd(3*nbd:end),2)*1E4,Range(rip),10,100); 

[Cs1r,Br]=CrossCorr(DeltaSup(ids(1:nbs),2)*1E4,Range(rip),10,100); 
[Cs2r,Br]=CrossCorr(DeltaSup(ids(3*nbs:end),2)*1E4,Range(rip),10,100); 
end

figure, 
subplot(4,3,1), hold on
plot(B/1E3,Cd1,'k')
plot(B/1E3,runmean(Cd1,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
try
    subplot(4,3,2), hold on
plot(Br/1E3,Cd1r,'k')
plot(Br/1E3,runmean(Cd1r,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
subplot(4,3,3), hold on
plot(Md2(:,1),mean(Td2(idd(1:nbd),:),1),'k')
plot(Md3(:,1),mean(Td3(idd(1:nbd),:),1),'r')

subplot(4,3,4), hold on
plot(B/1E3,Cd2,'k')
plot(B/1E3,runmean(Cd2,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
try
    subplot(4,3,5), hold on
plot(Br/1E3,Cd2r,'k')
plot(Br/1E3,runmean(Cd2r,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
subplot(4,3,6), hold on
plot(Md3(:,1),mean(Td2(idd(3*nbd:end),:),1),'k')
plot(Md2(:,1),mean(Td3(idd(3*nbd:end),:),1),'r')

subplot(4,3,7), hold on
plot(B/1E3,Cs1,'k')
plot(B/1E3,runmean(Cs1,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
try
    subplot(4,3,8), hold on
plot(Br/1E3,Cs1r,'k')
plot(Br/1E3,runmean(Cs1r,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
subplot(4,3,9), hold on
plot(Ms2(:,1),mean(Ts2(ids(1:nbs),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(1:nbs),:),1),'r')

subplot(4,3,10), hold on
plot(B/1E3,Cs2,'k')
plot(B/1E3,runmean(Cs2,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
try
    subplot(4,3,11), hold on
plot(Br/1E3,Cs2r,'k')
plot(Br/1E3,runmean(Cs2r,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
end
subplot(4,3,12), hold on
plot(Ms2(:,1),mean(Ts2(ids(3*nbs:end),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(3*nbs:end),:),1),'r')





[Cd1d,B]=CrossCorr(DeltaDeep(idd(1:nbd),2)*1E4,Delta(:,2)*1E4,10,100); 
[Cd2d,B]=CrossCorr(DeltaDeep(idd(3*nbd:end),2)*1E4,Delta(:,2)*1E4,10,100); 

[Cs1d,B]=CrossCorr(DeltaSup(ids(1:nbs),2)*1E4,Delta(:,2)*1E4,10,100); 
[Cs2d,B]=CrossCorr(DeltaSup(ids(3*nbs:end),2)*1E4,Delta(:,2)*1E4,10,100); 

binisto=[0:60:rg(end)];
[h1,b1]=hist(Delta(:,2),binisto);
[h2,b2]=hist(DeltaDeep(idd(1:nbd),2),binisto);
[h3,b3]=hist(DeltaDeep(idd(3*nbd:end),2),binisto);
[h4,b4]=hist(DeltaSup(ids(1:nbs),2),binisto);
[h5,b5]=hist(DeltaSup(ids(3*nbs:end),2),binisto);


figure, 
subplot(4,3,1), hold on
plot(B/1E3,Cd1d,'k')
plot(B/1E3,runmean(Cd1d,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(4,3,2), hold on
plot(Md2(:,1),mean(Td2(idd(1:nbd),:),1),'k')
plot(Md3(:,1),mean(Td3(idd(1:nbd),:),1),'r')
subplot(4,3,3), hold on
plot(binisto,runmean(h1/4,2),'k','linewidth',1)
plot(binisto,runmean(h2,2),'r','linewidth',2)


subplot(4,3,4), hold on
plot(B/1E3,Cd2d,'k')
plot(B/1E3,runmean(Cd2d,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(4,3,5), hold on
plot(Md3(:,1),mean(Td2(idd(3*nbd:end),:),1),'k')
plot(Md2(:,1),mean(Td3(idd(3*nbd:end),:),1),'r')
subplot(4,3,6), hold on
plot(binisto,runmean(h1/4,2),'k','linewidth',1)
plot(binisto,runmean(h3,2),'r','linewidth',2)

subplot(4,3,7), hold on
plot(B/1E3,Cs1d,'k')
plot(B/1E3,runmean(Cs1d,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(4,3,8), hold on
plot(Ms2(:,1),mean(Ts2(ids(1:nbs),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(1:nbs),:),1),'r')
subplot(4,3,9), hold on
plot(binisto,runmean(h1/4,2),'k','linewidth',1)
plot(binisto,runmean(h4,2),'r','linewidth',2)

subplot(4,3,10), hold on
plot(B/1E3,Cs2d,'k')
plot(B/1E3,runmean(Cs2d,2),'r','linewidth',2)
yl=ylim; line([0 0],yl,'color',[0.7 0.7 0.7])
subplot(4,3,11), hold on
plot(Ms2(:,1),mean(Ts2(ids(3*nbs:end),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(3*nbs:end),:),1),'r')
subplot(4,3,12), hold on
plot(binisto,runmean(h1/4,2),'k','linewidth',1)
plot(binisto,runmean(h5,2),'r','linewidth',2)


% rip2=Range(Restrict(rip,or(N2,N3)),'s');
% 
try
[hb,bb]=hist(Range(Restrict(rip,or(N2,N3)),'s'),binisto);

% [MripB,TripB]=PlotRipRaw(LFP,rip2(1:1000),80);close
% [MripI,TripI]=PlotRipRaw(LFP,rip2(1500:2500),80);close
% [MripE,TripE]=PlotRipRaw(LFP,rip2(3000:4000),80);close

% plot(MripB(:,1),MripB(:,2),'k'),%,h,'r','linewidth',2)
% plot(MripI(:,1),MripI(:,2),'b'),%,h,'r','linewidth',2)
% plot(MripE(:,1),MripE(:,2),'r'),%,h,'r','linewidth',2)

EpochRip=or(N2,N3);
ni=length(Start(or(N2,N3)));
[maps,data,stats,maps2,data2,stats2]=CompareRipplesTwoEpochs(LFPs{3},subset(EpochRip,1:floor(ni/4)),subset(EpochRip,3*floor(ni/4):ni));

figure, 
subplot(4,2,1:4), hold on, 
plot(bb,hb,'r','linewidth',2)
subplot(4,2,5), hold on, 
plot(mean(maps.ripples),'k')
plot(mean(maps2.ripples),'r')
subplot(4,2,6), hold on, 
PlotErrorBar2(data.peakFrequency,data2.peakFrequency,0,0);title('Frequency'), ylim([130 180])
subplot(4,2,7), hold on, 
PlotErrorBar2(data.peakAmplitude,data2.peakAmplitude,0,0);title('Amplitude')
subplot(4,2,8), hold on, 
PlotErrorBar2(data.duration,data2.duration,0,0);title('Duration'), ylim([0.02 0.04])

end



for a=1:length(S)
[Ca1s(a,:),B]=CrossCorr(DeltaSup(ids(1:nbs),2)*1E4,Range(S{a}),10,300);
[Cc1s(a,:),B]=CrossCorr(DeltaSup(ids(3*nbs:end),2)*1E4,Range(S{a}),10,300);
[Ca2s(a,:),B]=CrossCorr(DeltaDeep(idd(1:nbd),2)*1E4,Range(S{a}),10,300);
[Cc2s(a,:),B]=CrossCorr(DeltaDeep(idd(3*nbd:end),2)*1E4,Range(S{a}),10,300);
end

figure, 
subplot(2,4,1), imagesc(B/1E3,1:size(Ca1s,1),zscore(Ca1s')'), caxis([-3 3])
subplot(2,4,2), imagesc(B/1E3,1:size(Ca1s,1),zscore(Cc1s')'), caxis([-3 3])
subplot(2,4,3), imagesc(B/1E3,1:size(Ca1s,1),zscore(Ca2s')'), caxis([-3 3])
subplot(2,4,4), imagesc(B/1E3,1:size(Ca1s,1),zscore(Cc2s')'), caxis([-3 3])

subplot(2,4,5), hold on
plot(Ms2(:,1),mean(Ts2(ids(1:nbs),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(1:nbs),:),1),'r')

subplot(2,4,6), hold on
plot(Ms2(:,1),mean(Ts2(ids(3*nbs:end),:),1),'k')
plot(Ms3(:,1),mean(Ts3(ids(3*nbs:end),:),1),'r')

subplot(2,4,7), hold on
plot(Ms2(:,1),mean(Td2(idd(1:nbd),:),1),'k')
plot(Ms3(:,1),mean(Td3(idd(1:nbd),:),1),'r')

subplot(2,4,8), hold on
plot(Ms2(:,1),mean(Td2(idd(3*nbd:end),:),1),'k')
plot(Ms3(:,1),mean(Td3(idd(3*nbd:end),:),1),'r')





DeltaBad=FindDeltaCajal(chPFCxsup,chPFCxdeep,EpochForDelta,2);
for a=1:length(S)
[C(a,:),B]=CrossCorr(DeltaBad(:,2)*1E4,Range(S{a}),10,300);
end
[hbad,bbad]=hist(DeltaBad(:,2),binisto);

[mbad2,sbad2,tpsbad2]=mETAverage(DeltaBad(:,2)*1E4,Range(LFPs{nsup}),Data(LFPs{nsup}),1,1500);
[mbad3,sbad3,tpsbad3]=mETAverage(DeltaBad(:,2)*1E4,Range(LFPs{ndeep}),Data(LFPs{ndeep}),1,1500);


figure,
subplot(1,3,1), hold on
plot(tpsbad2,mbad2,'k')
plot(tpsbad3,mbad3,'r')
subplot(1,3,2), hold on
imagesc(B/1E3,1:size(C,1),zscore(C')'), caxis([-3 3])
subplot(1,3,3), 
plot(bbad,hbad,'r','linewidth',2)


%%
% K complex

[Ma2,Ta2]=PlotRipRaw(LFPs{nsup},Delta(:,2),1000);close
[Ma3,Ta3]=PlotRipRaw(LFPs{ndeep},Delta(:,2),1000);close

[BE,idk]=sort(mean(Ta2(:,1400:1600),2));

nk=floor(length(idk)/4);

[hbad1,bbad1]=hist(Delta(idk(1:nk),2),binisto);
[hbad2,bbad2]=hist(Delta(idk(3*nk:end),2),binisto);

[Cks1,B]=CrossCorr(Delta(idk(1:nbd),2)*1E4,Range(spi),100,100); 
[Cks2,B]=CrossCorr(Delta(idk(3*nbd:end),2)*1E4,Range(spi),100,100); 

try
[Ckr1,Br]=CrossCorr(Delta(idk(1:nbd),2)*1E4,Range(rip),10,100); 
[Ckr2,Br]=CrossCorr(Delta(idk(3*nbd:end),2)*1E4,Range(rip),10,100); 
end


for a=1:length(S)
[Ck1spk(a,:),Bspk]=CrossCorr(Delta(idk(1:nbd),2)*1E4,Range(S{a}),10,300);
[Ck2spk(a,:),Bspk]=CrossCorr(Delta(idk(3*nbd:end),2)*1E4,Range(S{a}),10,300);
end

figure, 

subplot(2,4,1), hold on
plot(Ma2(:,1),mean(Ta2(idk(1:nk),:)),'k')
plot(Ma2(:,1),mean(Ta3(idk(1:nk),:)),'r')
subplot(2,4,2), hold on
plot(Ma2(:,1),mean(Ta2(idk(3*nk:end),:)),'k'), title('K complex')
plot(Ma2(:,1),mean(Ta3(idk(3*nk:end),:)),'r')

subplot(2,4,3), 
imagesc(Bspk/1E3,1:size(Ck1spk,1),zscore(Ck1spk')'), caxis([-3 3])
subplot(2,4,4), 
imagesc(Bspk/1E3,1:size(Ck2spk,1),zscore(Ck2spk')'), caxis([-3 3]), title('K complex')

subplot(2,4,5), hold on
plot(bbad1,hbad1,'k','linewidth',2)
subplot(2,4,6), hold on
plot(bbad2,hbad2,'k','linewidth',2), title('K complex')
subplot(2,4,7), hold on
plot(B/1E3,Cks1,'k','linewidth',1)
plot(B/1E3,Cks2,'r','linewidth',1), title('CC Spindles - K complex (red)')
try
    subplot(2,4,8), hold on
plot(Br/1E3,Ckr1,'k','linewidth',1)
plot(Br/1E3,Ckr2,'r','linewidth',1), title('CC Ripples - K complex (red)')
end
