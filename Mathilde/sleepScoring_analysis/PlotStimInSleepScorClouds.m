function PlotStimInSleepScorClouds
load('SleepScoring_OBGamma', 'REMEpochWiNoise', 'SWSEpochWiNoise', 'WakeWiNoise', 'SmoothGamma', 'SmoothTheta', 'Epoch');
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);

% [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;

% gamma and theta power : restrict to non-noisy epoch
SmoothGammaNew = Restrict(SmoothGamma,Epoch);
SmoothThetaNew = Restrict(SmoothTheta,Epoch);

% gamma and theta power : subsample to same bins
t = Range(SmoothThetaNew);
ti = t(5:1200:end);
SmoothGammaNew = (Restrict(SmoothGammaNew,ts(ti)));
SmoothThetaNew = (Restrict(SmoothThetaNew,ts(ti)));

% REM
SmoothThetaREM  =  (Restrict(SmoothThetaNew,REMEp));
SmoothGammaREM  =  Restrict(SmoothGammaNew,ts(Range(SmoothThetaREM)));
% SWS
SmoothThetaSWS  =  (Restrict(SmoothThetaNew,SWSEp));
SmoothGammaSWS = Restrict(SmoothGammaNew,ts(Range(SmoothThetaSWS)));
% Wake
SmoothThetaWake = (Restrict(SmoothThetaNew,WakeEp));
SmoothGammaWake = Restrict(SmoothGammaNew,ts(Range(SmoothThetaWake)));

%% figure
timePostStim = linspace(1e4,15e4);
% timePostStim = [5e4, 10e4, 15e4,20e4];

hold on
plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);
xlabel('SmoothGamma')

ylabel('SmoothTheta')

% plot(log(Data(Restrict(SmoothGamma,StimREM))),log(Data(Restrict(SmoothTheta,StimREM))),'ko','linewidth',1,'markerfacecolor',[0 0 0])

% figure
% for i = 1:length(timePostStim)
% plot(log(Data(Restrict(SmoothGamma,StimREM+timePostStim(i)))),log(Data(Restrict(SmoothTheta,StimREM+timePostStim(i)))),'ko','linewidth',2,'markerfacecolor',[1 1 1])
% 
%     pause(0)
% end

% x1 = log(Data(Restrict(SmoothGamma,StimREM)));
% y1 = log(Data(Restrict(SmoothTheta,StimREM)));
% 
% x2 = log(Data(Restrict(SmoothGamma,StimREM+timePostStim)));
% y2 = log(Data(Restrict(SmoothTheta,StimREM+timePostStim)));
% 
% 
% for a=1:length(StimREM)
%     plot([x1 x2], [y1 y2],'k-', 'color', [0.7 0.7 0.7])
%     
% end




%%
% writerObj = VideoWriter('videoStims4.avi');
% writerObj.FrameRate = 5;
% writerObj.Quality = 20;
% open(writerObj);
% % plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
% % plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
% % plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);
% % plot(log(Data(Restrict(SmoothGamma,StimREM+timePostStim(1)))),log(Data(Restrict(SmoothTheta,StimREM+timePostStim(1)))),'ko','linewidth',2,'markerfacecolor',[1 1 1])
% xlabel('SmoothGamma')
% ylabel('SmoothTheta')
% for i = 1:length(timePostStim)
%     plot(log(Data(Restrict(SmoothGamma,StimREM+timePostStim(i)))),log(Data(Restrict(SmoothTheta,StimREM+timePostStim(i)))),'ko','linewidth',2,'markerfacecolor',[1 1 1])
%        ylim([-0.2 0.6])
%     xlim([0.9 1.5])
%     frame = getframe;
%     writeVideo(writerObj,frame);
% end
% close(writerObj);



%%

tim=StimREM;
tim=End(REMEp);

for a=1:length(tim)
figure(20), 
for i=-150:150
    clf, hold on
plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);

Epoch=intervalSet(tim(a)-4E4+i*1E3,tim(a)+i*1E3);
plot(log(Data(Restrict(SmoothGamma,Epoch))),log(Data(Restrict(SmoothTheta,Epoch))),'k.','MarkerSize',2)
plot(log(Data(Restrict(SmoothGamma,ts(tim(a)+i*1E3)))),log(Data(Restrict(SmoothTheta,ts(tim(a)+i*1E3)))),'ko','markerfacecolor','k')
if i==0
    title([num2str(a), ', STIMULATION'])
    pause(1)
else
    title([num2str(a), ', tps=', num2str(i*0.1-4)]) 
end
pause(0)
end
pause(1)
end



end



% figure, subplot(1,2,1), hold on
% plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
% plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
% plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);
% 
% Epoch=intervalSet(StimREM-30E4,StimREM);
% plot(log(Data(Restrict(SmoothGamma,Epoch))),log(Data(Restrict(SmoothTheta,Epoch))),'k.','MarkerSize',1)
% 
%  subplot(1,2,2),  hold on
% plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
% plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
% plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);
% 
% Epoch=intervalSet(StimREM+5E4,StimREM+15E4);
% plot(log(Data(Restrict(SmoothGamma,Epoch))),log(Data(Restrict(SmoothTheta,Epoch))),'k.','MarkerSize',1)





