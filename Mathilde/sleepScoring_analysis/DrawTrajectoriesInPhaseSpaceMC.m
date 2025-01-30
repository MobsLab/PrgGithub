function DrawTrajectoriesInPhaseSpaceMC(Wake,SWSEpoch,REMEpoch,SmoothGamma,SmoothTheta,Epoch,events)

% INPUT : 
% events : can be Start(Epoch), End(Epoch) to look at transitions or
% stimulations onset...

% gamma and theta power : restrict to non-noisy epoch
SmoothGammaNew = Restrict(SmoothGamma,Epoch);
SmoothThetaNew = Restrict(SmoothTheta,Epoch);

% gamma and theta power : subsample to same bins
t = Range(SmoothThetaNew);
ti = t(5:1200:end);
SmoothGammaNew = (Restrict(SmoothGammaNew,ts(ti)));
SmoothThetaNew = (Restrict(SmoothThetaNew,ts(ti)));

% REM
SmoothThetaREM  =  (Restrict(SmoothThetaNew,REMEpoch));
SmoothGammaREM  =  Restrict(SmoothGammaNew,ts(Range(SmoothThetaREM)));
% SWS
SmoothThetaSWS  =  (Restrict(SmoothThetaNew,SWSEpoch));
SmoothGammaSWS = Restrict(SmoothGammaNew,ts(Range(SmoothThetaSWS)));
% Wake
SmoothThetaWake = (Restrict(SmoothThetaNew,Wake));
SmoothGammaWake = Restrict(SmoothGammaNew,ts(Range(SmoothThetaWake)));

%% figure
TimeWindow = 150; % 15 sec will be displayed before/after the event

for a=1:length(events)
    figure(1),
    for i=-TimeWindow:TimeWindow
        clf, hold on
        % plot brain state clouds (from sleep scoring)
        plot(log(Data(SmoothGammaREM)),log(Data(SmoothThetaREM)),'g.','MarkerSize',1);
        plot(log(Data(SmoothGammaSWS)),log(Data(SmoothThetaSWS)),'r.','MarkerSize',1);
        plot(log(Data(SmoothGammaWake)),log(Data(SmoothThetaWake)),'b.','MarkerSize',1);
        
        epch = intervalSet(events(a)-4E4+i*1E3, events(a)+i*1E3);
        plot(log(Data(Restrict(SmoothGamma,epch))),log(Data(Restrict(SmoothTheta,epch))),'k.','MarkerSize',2) % to draw the 'worm'
        plot(log(Data(Restrict(SmoothGamma,ts(events(a)+i*1E3)))),log(Data(Restrict(SmoothTheta,ts(events(a)+i*1E3)))),'ko','markerfacecolor','k') % worm's head
        if i==0
            title([num2str(a), ', EVENT']) % display 'EVENT' at the onset
            pause(1)
        else
            title([num2str(a), ', tps=', num2str(i*0.1)]) % show countdown before/after the event onset
        end
        pause(0)
    end
    pause(1)
end

end
