% unsupervised clustering
plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'.','color',Colors.Wake,'MarkerSize',1);
A = kmeans([downsample(log(Data(SmoothGamma)),1200),downsample(log(Data(SmoothTheta)),1200)],1);
figure
X = downsample(log(Data(SmoothGamma)),1200);
Y = downsample(log(Data(SmoothTheta)),1200);
plot(X(A==1),Y(A==1),'*')
hold on
plot(X(A==2),Y(A==2),'*')
plot(X(A==3),Y(A==3),'*')

% scatter plot - couleur = accelero
figure
% berfore
subplot(121)
Atropine = intervalSet(0,2*60*60*1e4);
X = downsample(log(Data(Restrict(SmoothGamma,Atropine))),1200);
Y = downsample(log(Data(Restrict(SmoothTheta,Atropine))),1200);
scatter(X,Y,20,log(downsample(Data(Restrict(MovAcctsd,ts(Range(Restrict(SmoothGamma,Atropine))))),1200)),'filled')
xlim([5 7.5])
ylim([-1 2.5])
colormap jet
clim([10 19])
ylabel('Theta//Delta')
xlabel('Gamma')
title('CNO Before Atropine (M929), accelero')
set(gca,'FontSize',14)

% after
subplot(122)
Atropine = intervalSet(3*60*60*1e4,4*60*60*1e4);
X = downsample(log(Data(Restrict(SmoothGamma,Atropine))),1200);
Y = downsample(log(Data(Restrict(SmoothTheta,Atropine))),1200);
scatter(X,Y,20,log(downsample(Data(Restrict(MovAcctsd,ts(Range(Restrict(SmoothGamma,Atropine))))),1200)),'filled')
xlim([5 7.5])
ylim([-1 2.5])
colormap jet
clim([10 19])
ylabel('Theta//Delta')
xlabel('Gamma')
title('CNO After Atropine (M929), accelero')
set(gca,'FontSize',14)


% scatter plot - couleur = time
figure
subplot(121)
Atropine = intervalSet(0,2*60*60*1e4);
X = downsample(log(Data(Restrict(SmoothGamma,Atropine))),1200);
Y = downsample(log(Data(Restrict(SmoothTheta,Atropine))),1200);
scatter(X,Y,20,downsample(Range(Restrict(SmoothGamma,Atropine)),1200),'filled')
xlim([5 7.5])
ylim([-1 2.5])
subplot(122)
colormap jet
ylabel('Theta//Delta')
xlabel('Gamma')
title('CNO Before Atropine (M929), time')
set(gca,'FontSize',14)

subplot(122)
Atropine = intervalSet(2.5*60*60*1e4,4*60*60*1e4);
X = downsample(log(Data(Restrict(SmoothGamma,Atropine))),1200);
Y = downsample(log(Data(Restrict(SmoothTheta,Atropine))),1200);
scatter(X,Y,20,downsample(Range(Restrict(SmoothGamma,Atropine)),1200),'filled')
xlim([5 7.5])
ylim([-1 2.5])
colormap jet
ylabel('Theta//Delta')
xlabel('Gamma')
title('CNO After Atropine (M929), time')
set(gca,'FontSize',14)


% mean HPC spectro
load('H_Low_Spectrum.mat')
Sptsd = tsd(Spectro{2}*1E4,log(Spectro{1}))
ThetaEpoch = thresholdIntervals(SmoothTheta, exp(1), 'Direction','Above');
figure
Atropine = intervalSet(0,2*60*60*1e4);
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(ThetaEpoch,Atropine))))),hold on
Atropine = intervalSet(2.5*60*60*1e4,4*60*60*1e4);
plot(Spectro{3},nanmean(Data(Restrict(Sptsd,and(ThetaEpoch,Atropine))))),hold on
legend('bef','after')
