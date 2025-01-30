%% This script plots the behavior of the mouse during conditionning with the stim and after conditioning in order to see if conditionning worked
figure, 
subplot(1,3,1), plot(Data(Restrict(X,hab)),Data(Restrict(Y,hab)));xlim([0 1]),ylim([0 1])
subplot(1,3,2), plot(Data(Restrict(X,condi)),Data(Restrict(Y,condi)));
hold on, plot(Data(Restrict(X,ts(Start(StimEpoch)))), Data(Restrict(Y,ts(Start(StimEpoch)))), 'g.','markersize',10), xlim([0 1]),ylim([0 1])
% title('Mouse with appetitive conditioning')
title('Mouse with appetitive conditioning')
subplot(1,3,3),  plot(Data(Restrict(X,testPost)),Data(Restrict(Y,testPost))),xlim([0 1]),ylim([0 1])


