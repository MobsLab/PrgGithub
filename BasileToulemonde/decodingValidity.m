% In this script we want to check whether or not the decoding is valid
% In order to do that, we will :
% - train the decoder on the habituation (DONE)
% - use the decoder on all the data (except sleep for now) (DONE)

LinearTrueTsd=LinearTrueTsd200;
LinearPredTsd=LinearPredTsd200;
LinearPredPostSleepTsd=LinearPredPostSleepTsd200;
GoodEpoch=GoodEpoch200;
BadEpoch=BadEpoch200;
TimeStepsPred=TimeStepsPred200;

%% Predicted loss part
stim=ts(Start(StimEpoch));


% Plotting the decoded position at each point of predicted loss
% Blue : Good     ;      Green : Bad
figure, 
subplot(3,1,1), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
% Adding the ripples : high certainty along with a ripple is good sign of a
% reactivation
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

% Only good
subplot(3,1,2), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
%plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

% Only bad
subplot(3,1,3), hold on, 
plot(Range(Restrict(LinearTrueTsd, tot),'s'), Data(Restrict(LinearTrueTsd, tot)),'r','linewidth',2)
plot(Range(Restrict(LinearPredTsd, tot),'s'), Data(Restrict(LinearPredTsd, tot)),'k.','markersize',5)
plot(Range(Restrict(LinearPredTsd, BadEpoch),'s'), Data(Restrict(LinearPredTsd, BadEpoch)),'g.','markersize',15)
%plot(Range(Restrict(LinearPredTsd, GoodEpoch),'s'), Data(Restrict(LinearPredTsd, GoodEpoch)),'b.','markersize',15)
line([Range(stim,'s') Range(stim,'s')],ylim,'color','k')
line([Range(tRipples,'s') Range(tRipples,'s')],ylim/2,'color','b')

% Histogram to see the repartition of the distances between the decoded 
% position and the true position, separating points with good certainty and
% points with a bad one. The objective is to find the right treshold that
% will allow us to say that all points with good certainty far from the
% true position correspond for sure to reactivations (especially the ones
% with -0.8 of distance, which correspond to the shock zone.
[hBad,bBad]=hist(Data(Restrict(LinearPredTsd, BadEpoch))-Data(Restrict(LinearTrueTsd, BadEpoch)),70);
[hGood,bGood]=hist(Data(Restrict(LinearPredTsd, GoodEpoch))-Data(Restrict(LinearTrueTsd, GoodEpoch)),70);
figure, hold on, plot(bBad,hBad), plot(bGood,hGood,'r')
%%
% We need to find PC whose PF are clearly defined DURING PRETEST : to find
% them we plot the observed spikes of each place cells during pretest, by 
% plotting red dots at the locations of the maze where the mouse was when the 
% spike took place. We do that with a speed treshold otherwise the spikes 
% might be linked to a reactivation rather than to the actual location of
% the mouse
SpeedEpoch=thresholdIntervals(V,5,'Direction','Above');
% You need to go over all place fields during testPre thanks to the
% PlaceField function : 
% PlaceField(Restrict(Stsd{k},and(testPre,SpeedEpoch)),Restrict(X,and(testPre,SpeedEpoch)),Restrict(Y,and(testPre,SpeedEpoch)));
k=0;
k=k+1;PlaceField(Restrict(Stsd{k},and(hab,SpeedEpoch)),Restrict(X,and(hab,SpeedEpoch)),Restrict(Y,and(hab,SpeedEpoch)));
% Plotting the spikes of the selected PC and the decoded postion with the
% true one : we want to see two things :
% - first we check decoding when the mouse is moving since we have ground
% truth (take screenshots)
% - during pretest, when the mouse is not moving, we check if the decoded
% position is coherent with the observed spikes of place cells whose PF is
% clearly defined
epochTest = cond
id=[1,2,3,4,5]
figure,
hold on;
subplot(5,1,1:4), RasterPlotid(Restrict(Stsd,epochTest),id,0);
% subplot(5,1,4), plot(Range(Restrict(LFP,tot),'sec'),Data(Restrict(LFP,tot)),'k'), ylim([-6000 6000]);hold on, plot(Range(tRipples,'sec'), 5000,'r*')
subplot(5,1,5), hold on, plot(Range(Restrict(LinearTrueTsd, epochTest),'s'), Data(Restrict(LinearTrueTsd, epochTest)),'r'),
% hold on, plot(Range(tRipples,'sec'), 0.9,'r*'), ylim([0 1]);
subplot(5,1,5), hold on, plot(Range(Restrict(LinearPredTsd,epochTest),'s'),Data(Restrict(LinearPredTsd,epochTest)),'b');
t=Range(Restrict(LinearPredTsd,epochTest),'sec');
a=t(1)
l=10; a=a+l; subplot(5,1,1:4), xlim([a*1E3 a*1E3+l*1E3]), subplot(5,1,5), xlim([a a+l])
subplot(5,1,1:4), xlabel('Time'), ylabel('Spikes of the Selected Place Cells')
subplot(5,1,5), xlabel('Time'), ylabel('Linearized Position')
