%PlotBilanPredictionPF

cd /Users/karimbenchenane/Documents/Data/DataEnCours/ProjetCentral/
N=4;

figure('color',[1 1 1]), 

cd PlaceFiledsFr3Si10Nb50
load Analysis

H1=h;
Er1=errAbs;

load DataTsd
subplot(1,N,1), hold on
p=1;
plot(Data(X), Data(Y),'color',[0.7 0.7 0.7])
z=0;
    while z<length(S)
try

z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'g.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'b.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'k.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'y.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'r.')


end

    end


title('PlaceFiledsFr3Si10Nb50')

cd ..




cd PlaceFiledsFr1Si10Nb50
load Analysis
H2=h;
Er2=errAbs;

load DataTsd
subplot(1,N,2), hold on
p=1;
plot(Data(X), Data(Y),'color',[0.7 0.7 0.7])
z=0;
    while z<length(S)
try

z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'g.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'b.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'k.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'y.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'r.')


end

    end

title('PlaceFiledsFr1Si10Nb50')

cd ..





cd PlaceFiledsFr05Si10Nb50
load Analysis
H3=h;
Er3=errAbs;

load DataTsd
subplot(1,N,3), hold on
p=1;
plot(Data(X), Data(Y),'color',[0.7 0.7 0.7])
z=0;
    while z<length(S)
try

z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'g.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'b.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'k.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'y.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'r.')


end

    end

title('PlaceFiledsFr01Si10Nb50')

cd ..











cd PlaceFiledsFr3Si10Nb50Noise1

load Analysis
H4=h;
Er4=errAbs;

load DataTsd
subplot(1,N,4), hold on
p=1;
plot(Data(X), Data(Y),'color',[0.7 0.7 0.7])
z=0;
    while z<length(S)
try

z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'g.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'b.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'k.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'y.')
z=z+p; hold on, plot(Data(Restrict(X,S{z})),Data(Restrict(Y,S{z})),'r.')


end

    end

title('PlaceFiledsFr3Si10Nb50Noise1')

cd ..





%----------------------------------------------------------------------
%----------------------------------------------------------------------
%----------------------------------------------------------------------


figure('color',[1 1 1]), 

subplot(2,1,1), hold on
plot(bin,H1,'k','linewidth',2)
plot(bin,H2,'b','linewidth',2)
plot(bin,H3,'r','linewidth',2)
plot(bin,H4,'color',[0.6 0.6 0.6],'linewidth',2)
xlim([0 65])
subplot(2,1,2), hold on
plot(bin,H1/max(H1),'k','linewidth',2)
plot(bin,H2/max(H2),'b','linewidth',2)
plot(bin,H3/max(H3),'r','linewidth',2)
plot(bin,H4/max(H4),'color',[0.6 0.6 0.6],'linewidth',2)
xlim([0 65])
ylim([0 1.1])
xlabel('Erreur between true and predicted position')
title('Prediction error vs Firing rate (black: 3Hz, gray: 3Hz with noise, blue: 1Hz, red: 0.1Hz)')

