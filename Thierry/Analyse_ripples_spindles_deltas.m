%% Plot hypnogram and accelero
load('behavResources.mat')
load SleepScoring_OBGamma.mat
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch);
hold on, plot(Range(MovAcctsd,'s'),rescale(Data(MovAcctsd),-2,0),'r');
hold on, plot(Range(MovAcctsd,'s'),rescale(Data(MovAcctsd),-2,2),'r');

%% Plot SleepScoring Gamma/theta
figure, plot(10*log10(downsample(Data(SmoothGamma),100)),10*log10(downsample(Data(SmoothTheta),100)),'k.','markersize',1)
figure, hist2(10*log10(Data(SmoothGamma)),10*log10(Data(SmoothTheta)),100,100), axis xy
caxis([0 25000])

%% Histogram movement event
[h1,b1]=hist(Data(Restrict(MovAcctsd,Wake)),1000);
[h2,b2]=hist(Data(Restrict(MovAcctsd,SWSEpoch)),1000);
[h3,b3]=hist(Data(Restrict(MovAcctsd,REMEpoch)),1000);
figure, hold on, stairs(b1,h1,'k'), stairs(b2,h2,'b'), stairs(b3,h3,'r')
figure, hold on, stairs(b1,log(h1),'k'), stairs(b2,log(h2),'b'), stairs(b3,log(h3),'r')
figure, hold on, stairs(b1,runmean(log(h1)),'k'), stairs(b2,runmean(log(h2)),'b'), stairs(b3,runmean(log(h3),3),'r')
figure, hold on, stairs(b1,runmean(log(h1),3),'k'), stairs(b2,runmean(log(h2),3),'b'), stairs(b3,runmean(log(h3),3),'r')
figure, hold on, stairs(b1,log(h1),'k'), stairs(b2,log(h2),'b'), stairs(b3,log(h3),'r')


%% Spectral power before and after atropine
%HPC theta
load('H_Low_Spectrum.mat')
Sptsd = tsd(Spectro{2}*1E4,log(Spectro{1}))
ThetaEpoch = thresholdIntervals(SmoothTheta, exp(1), 'Direction','Above'); %seuil du theta/Delta > 1
figure
Atropine = intervalSet(0,2*60*60*1e4);% temps pendant atropine (de 0 à 2h)
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(ThetaEpoch,Atropine))))),hold on
Atropine = intervalSet(3*60*60*1e4,4*60*60*1e4);
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(ThetaEpoch,Atropine))))),hold on
legend('before atropine','after atropine')
ylabel('Power')
xlabel('Frequency')
title('HPC spectral power Before and after Atropine (M929)')
set(gca,'FontSize',14)

%Bulb Gamma
load('B_High_Spectrum.mat')
Sptsd = tsd(Spectro{2}*1E4,log(Spectro{1}))
GammaEpoch = thresholdIntervals(SmoothGamma, exp(1), 'Direction','Above');
figure
Atropine = intervalSet(0,2*60*60*1e4);
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(GammaEpoch,Atropine))))),hold on
Atropine = intervalSet(3*60*60*1e4,4*60*60*1e4);
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(GammaEpoch,Atropine))))),hold on
legend('before atropine','after atropine')
ylabel('Power')
xlabel('Frequency')
title('Bulb spectral power Before and after Atropine (M929)')
set(gca,'FontSize',14)


%% Ripples
load('Ripples.mat')
load('/media/nas5/Thierry_DATA/M929_processed/929_CNO_atropine_05092019_190905_095055_BIS/LFPData/LFP30.mat')

%Afficher la moyenne des ripples
[M,T]=PlotRipRaw(LFP,Range(tRipples,'s'),90000,0,0);
[M,T]=PlotRipRaw(LFP,Range(tRipples,'s'),1000,0,0);
plot(M(:,1),M(:,2))

%Distribution des ripples
hist(Range(tRipples,'s'),100)
figure
hist(Range(tRipples,'s'),1000)
legend('Ripples')
ylabel('events')
xlabel('time (s)')
title('Ripples distribution (M929)')
set(gca,'FontSize',14)

%Raster ripples
raster_tsd = RasterMatrixKJ(LFP, tRipples, -0.4e4, 0.6e4);
MatRaster = Data(raster_tsd);
x_Raster = Range(raster_tsd);
imagesc(MatRaster')
figure, plot(x_Raster, MatRaster(:,500))
imagesc(x_Raster, 1:length(tRipples),MatRaster')
caxis([-2000 2000])

%Raster Deltas (à mofifier)
raster_tsd = RasterMatrixKJ(LFP, alldeltas_PFCX, -0.4e4, 0.6e4);
MatRaster = Data(raster_tsd);
x_Raster = Range(raster_tsd);
imagesc(MatRaster')
figure, plot(x_Raster, alldeltas_PFCX(:,500))
imagesc(x_Raster, 1:length(alldeltas_PFCX),MatRaster')
caxis([-2000 2000])

%Raster spindles
figure
raster_tsd = RasterMatrixKJ(LFP, tSpindles_PFCx, -0.4e4, 0.6e4);
MatRaster = Data(raster_tsd);
x_Raster = Range(raster_tsd);
imagesc(MatRaster')
figure, plot(x_Raster, MatRaster(:,500))
imagesc(x_Raster, 1:length(tSpindles_PFCx),MatRaster')
caxis([-2000 2000])


%% Deltas
load('DeltaWaves.mat')
hist(Start(alldeltas_PFCx,'s'),1000)
legend('Deltas')
ylabel('events')
xlabel('time (s)')
title('Delta distribution (M929)')
set(gca,'FontSize',14)

%% Superposer Accelero
yyaxis right
plot(Range(MovAcctsd,'s'),Data(MovAcctsd))
ylim([-3 3]*1e9)



%% Selectionner les nuages pour restreindre les analyses
ThetaEpoch = thresholdIntervals(SmoothTheta, exp(1), 'Direction','Above');
Atropine = intervalSet(0,2*60*60*1e4); %intervalle de temps sous atropine (0sec à 2h)


%% superposer ripples / deltas
figure
hist(Start(alldeltas_PFCx,'s'),1000)
ylabel('events delta')
hold on
yyaxis right
hist(Range(tRipples,'s'),5000)
ylabel('events ripples')
xlabel('time (s)')
title('Delta & Ripples distribution (M929)')
set(gca,'FontSize',14)

%% superposer spindles / deltas
figure
hist(Start(alldeltas_PFCx,'s'),1000)
ylabel('events delta')
hold on
yyaxis right
hist(Range(tSpindles_PFCx,'s'),1000)
ylim([0 16])
ylabel('events spindles')
xlabel('time (s)')
title('Delta & spindles distribution (M929)')
set(gca,'FontSize',14)

%% Correlations ripples / Deltas
figure
[Y,X] = hist(Start(alldeltas_PFCx,'s'),5000);
[Y2,X] = hist(Range(tRipples,'s'),5000);
plot(Y,Y2,'.')
hist2(Y,Y2)
% hist2(Y,Y2,[50 50])
hist2(Y,Y2,50,50)
hist2(Y,Y2,10,10)