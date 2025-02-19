
cd('/media/nas7/ProjetEmbReact/Mouse1379/20221020')

clear all

load('HeartBeatInfo.mat', 'EKG')
try
    load('SleepScoring_OBGamma.mat', 'SmoothGamma', 'Wake' , 'Sleep', 'SWSEpoch', 'REMEpoch')
catch
    load('StateEpochSB.mat', 'smooth_ghi', 'Wake' , 'Sleep', 'SWSEpoch', 'REMEpoch')
    SmoothGamma = smooth_ghi;
end
load('behavResources.mat', 'MovAcctsd')
smooth_time = 1;


Data_EKG = runmean(Data(EKG.HBRate) , ceil(smooth_time/median(diff(Range(EKG.HBRate,'s')))));
Data_Gamma = interp1(Range(SmoothGamma) , runmean(log(Data(SmoothGamma)) , ceil(smooth_time/median(diff(Range(SmoothGamma,'s'))))) , Range(EKG.HBRate));
Range_EKG = Range(EKG.HBRate);
Data_MovAcctsd = interp1(Range(MovAcctsd) , log(runmean(Data(MovAcctsd) , ceil(smooth_time/median(diff(Range(MovAcctsd,'s')))))) , Range(EKG.HBRate));
bin=20;

EKG_subsamp = tsd(Range_EKG(1:bin:end) , Data_EKG(1:bin:end));
Gamma_subsamp = tsd(Range_EKG(1:bin:end) , Data_Gamma(1:bin:end));
Acc_subsamp = tsd(Range_EKG(1:bin:end) , Data_MovAcctsd(1:bin:end));



X = Data(EKG_subsamp)/nanmean(Data(EKG_subsamp));
Y = Data(Gamma_subsamp)/nanmean(Data(Gamma_subsamp));

X_sleep = Data(Restrict(EKG_subsamp , Sleep))/nanmean(Data(EKG_subsamp));
X_sleep = Data(Restrict(Gamma_subsamp , Sleep))/nanmean(Data(Gamma_subsamp));

X_sws = Data(Restrict(EKG_subsamp , SWSEpoch))/nanmean(Data(EKG_subsamp));
Y_sws = Data(Restrict(Gamma_subsamp , SWSEpoch))/nanmean(Data(Gamma_subsamp));

X_REM = Data(Restrict(EKG_subsamp , REMEpoch))/nanmean(Data(EKG_subsamp));
Y_REM = Data(Restrict(Gamma_subsamp , REMEpoch))/nanmean(Data(Gamma_subsamp));

X_wake = Data(Restrict(EKG_subsamp , Wake))/nanmean(Data(EKG_subsamp));
Y_wake = Data(Restrict(Gamma_subsamp , Wake))/nanmean(Data(Gamma_subsamp));
Z_wake = Data(Restrict(Acc_subsamp , Wake))/nanmean(Data(Acc_subsamp));

figure
clf
PlotCorrelations_BM(X_sws , Y_sws , 10 , 1 , 'r')
PlotCorrelations_BM(X_wake , Y_wake , 10 , 1 , 'b')
PlotCorrelations_BM(X_REM , Y_REM , 10 , 1 , 'g')


figure
PlotCorrelations_BM(X_wake , Z_wake , 10 , 1 , 'k')

figure
PlotCorrelations_BM(Y_wake , Z_wake , 10 , 1 , 'k')


figure
HRAxes=dscatter(X , Y ,'smoothing',7);
xlim([-3.5 3.5]), ylim([-3.5 3.5])
axis square
makepretty
xlabel('Heart rate (a.u.)')
ylabel('Gamma (a.u)')
title('Gamma/Heart rate correlations, head fixed session')


%% other way
% runmean, log on sime time stamps
clear all

load('HeartBeatInfo.mat', 'EKG')
try
    load('SleepScoring_OBGamma.mat', 'SmoothGamma', 'Wake' , 'Sleep', 'SWSEpoch', 'REMEpoch')
catch
    load('StateEpochSB.mat', 'smooth_ghi', 'Wake' , 'Sleep', 'SWSEpoch', 'REMEpoch')
    SmoothGamma = smooth_ghi;
end
load('behavResources.mat', 'MovAcctsd')
smooth_time = 1;

HR_corr = tsd(Range(EKG.HBRate) , runmean(Data(EKG.HBRate) , ceil(smooth_time/median(diff(Range(EKG.HBRate,'s'))))));
Acc_corr = tsd(Range(EKG.HBRate) , runmean(log(Data(Restrict(MovAcctsd , EKG.HBRate))) , ceil(smooth_time/median(diff(Range(EKG.HBRate,'s'))))));
try
    Gamma_corr = tsd(Range(EKG.HBRate) , runmean(log(Data(Restrict(SmoothGamma , EKG.HBRate))) , ceil(smooth_time/median(diff(Range(EKG.HBRate,'s'))))));
catch
    Gamma_corr = tsd(Range(EKG.HBRate) , runmean(log(Data(Restrict(smooth_ghi , EKG.HBRate))) , ceil(smooth_time/median(diff(Range(EKG.HBRate,'s'))))));
end

HR_corr_wake = Restrict(HR_corr,Wake);
Acc_corr_wake = Restrict(Acc_corr,Wake);
Gamma_corr_wake = Restrict(Gamma_corr,Wake);

figure
HRAxes=dscatter(zscore(Data(HR_corr)) , zscore(Data(Gamma_corr)) ,'smoothing',7);
xlim([-3.5 3.5]), ylim([-3.5 3.5])
axis square
makepretty
xlabel('Heart rate (a.u.)')
ylabel('Gamma (a.u)')
title('Gamma/Heart rate correlations, head fixed session')


figure
HRAxes=dscatter(zscore(Data(HR_corr_wake)) , zscore(Data(Gamma_corr_wake)) ,'smoothing',7);
xlim([-3.5 3.5]), ylim([-3.5 3.5])
axis square
makepretty
xlabel('Heart rate (a.u.)')
ylabel('Gamma (a.u)')
title('Gamma/Heart rate correlations, head fixed session')





