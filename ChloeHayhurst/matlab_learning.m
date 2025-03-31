% speech on range/data, restrict, and: basic functions
load('HeartBeatInfo.mat', 'EKG')
figure
plot(EKG.HBShape)

r=Range(EKG.HBRate);
d=Data(EKG.HBRate);

d2=Data(MovAcctsd);


plot(Range(EKG.HBRate,'s') , runmean(Data(EKG.HBRate)*1e7,30))
hold on
plot(Range(MovAcctsd,'s') , runmean(Data(MovAcctsd),30))
xlim([0 6e3])

plot(d*1e7)
hold on
plot(d2)

EKG_Wake = Restrict(EKG.HBRate , Wake);
Acc_Wake = Restrict(MovAcctsd , Wake);

figure
plot(Range(EKG_Wake,'s') , Data(EKG_Wake))

load('StateEpochSB.mat', 'smooth_ghi')
figure
plot(Range(Restrict(smooth_ghi, and(ThetaEpoch, Wake)),'s') , Data(Restrict(smooth_ghi, and(ThetaEpoch, Wake))))
plot(Range(Restrict(smooth_ghi, or(ThetaEpoch, Wake)),'s') , Data(Restrict(smooth_ghi, or(ThetaEpoch, Wake)))+500)
plot(Range(Restrict(smooth_ghi, ThetaEpoch - Wake),'s') , Data(Restrict(smooth_ghi, ThetaEpoch - Wake))+1000)

% correlations
load('behavResources.mat', 'Xtsd', 'Ytsd')

figure
plot(Data(Xtsd) , Data(Ytsd))

PlotCorrelations_BM(Data(Xtsd) , Data(Ytsd))

% spectro
load('B_Low_Spectrum.mat')
Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});

figure
imagesc(linspace(20,40,100) , Spectro{3} , Spectro{1}(100:200 ,:)'); axis xy
xlabel('time (s)')
ylabel('Frequency (Hz)')
colorbar
caxis([0 3e5])
makepretty
colormap(jet)

% spectre moyen

SpectroHlow = load('H_Low_Spectrum.mat', 'Spectro') ;
Sp_tsd_Hlow = tsd(Spectro{2}*1e4 , Spectro{1});
freqHlow = SpectroHlow.Spectro{3} ;
figure
plot(freqHlow, mean(Data(Restrict(Sp_tsd_Hlow, REMEpoch))))
xlabel('mean frequency')
ylabel('power')
title('Mean Spectrum Hlow')

SpectroBhigh = load('B_Low_Spectrum.mat' , 'Spectro')
Sp_tsd_Bhigh = tsd(Spectro{2}*1e4 , Spectro{1});
freqBhigh = SpectroBhigh.Spectro{3} ;
figure
plot(freqBhigh, mean(Data(Restrict(Sp_tsd_Bhigh, REMEpoch))))
xlabel('mean frequency')
ylabel('power')
title('Mean Spectrum Blow')

%% Spectre moyen

SpectroHlow = load('H_Low_Spectrum.mat', 'Spectro') ;
SpectroBhigh = load('B_High_Spectrum.mat', 'Spectro') ;

freqHlow = SpectroHlow.Spectro{3} ;
freqBhigh = SpectroBhigh.Spectro{3} ;
Sp_tsd_Hlow = tsd(SpectroHlow.Spectro{2}*1e4 , SpectroHlow.Spectro{1});
Sp_tsd_Bhigh = tsd(SpectroBhigh.Spectro{2}*1e4 , SpectroBhigh.Spectro{1});

figure
plot(freqHlow, mean(Data(Restrict(Sp_tsd_Hlow , REMEpoch))))
xlabel('mean frequency')
ylabel('power')
title('Mean Spectrum Hlow REM')
makepretty
figure
plot(freqBhigh, mean(Data(Restrict(Sp_tsd_Bhigh , REMEpoch))))
xlabel('mean frequency')
ylabel('power')
title('Mean Spectrum Bhigh REM')
makepretty

% Spectrogramme moyen

AverageSpectrogram(Sp_tsd_Hlow , freqHlow , ts(Stop(REMEpoch) , 500 , 500 , 1))

% Somnogramme

[dur , durT] = DurationEpoch(REMEpoch , 's')

hist(dur , 50)



