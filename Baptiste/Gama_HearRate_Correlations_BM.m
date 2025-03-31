


load('HeartBeatInfo.mat', 'EKG')
load('SleepScoring_OBGamma.mat', 'SmoothGamma', 'Wake' , 'Sleep', 'SWSEpoch')


X = zscore_nan_BM(Data(EKG.HBRate));
Y = zscore_nan_BM(log(interp1(Range(SmoothGamma) , Data(SmoothGamma) , Range(EKG.HBRate))));

X_sleep = zscore_nan_BM(Data(Restrict(EKG.HBRate , Sleep)));
Y_sleep = zscore_nan_BM(log(interp1(Range(Restrict(SmoothGamma , Sleep)) , Data(Restrict(SmoothGamma , Sleep)) , Range(Restrict(EKG.HBRate , Sleep)))));

X_wake = zscore_nan_BM(Data(Restrict(EKG.HBRate , Wake)));
Y_wake = zscore_nan_BM(log(interp1(Range(Restrict(SmoothGamma , Wake)) , Data(Restrict(SmoothGamma , Wake)) , Range(Restrict(EKG.HBRate , Wake)))));

figure
clf
PlotCorrelations_BM(X(1:100:end) , Y(1:100:end) , 10)


figure
clf
PlotCorrelations_BM(X_sleep(1:100:end) , Y_sleep(1:100:end) , 10)


figure
clf
PlotCorrelations_BM(X_wake(1:100:end) , Y_wake(1:100:end) , 10)




