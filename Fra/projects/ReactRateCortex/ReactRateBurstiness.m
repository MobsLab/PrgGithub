function ReactRateBurstiness
% ReactRateBurstiness 
cd /home/fpbatta/Data/WarpRat

load ReactRate
load SleepBurstiness
n_q = 10; % the number of quantiles


XB_S2S1 = log(FRateBurstSleep2 ./ FRateBurstSleep1);
XNB_S2S1 = log(FRateNoBurstSleep2 ./ FRateNoBurstSleep1);

figure(1)

clf
plot(X_MS1, XB_S2S1, 'r.')
disp('bursty')
nancorrcoef(X_MS1, XB_S2S1)


figure(2)

clf
plot(X_MS1, XNB_S2S1, '.')
disp('nonbursty')
nancorrcoef(X_MS1, XNB_S2S1)

figure(3)

clf
FB_S2S1 = log(BurstFractionSleep2 ./ BurstFractionSleep1);
plot(X_MS1, FB_S2S1, 'b.')
[r, clo, chi] = nancorrcoef(X_MS1, FB_S2S1, 0.05, 'bootstrap')

