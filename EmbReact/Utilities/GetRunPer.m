function [RunningEpoch,RunSpeed]=GetRunPer(Xtsd,Ytsd,SpeedThresh,plo)

tps=Range(Xtsd);
RunSpeed=tsd(tps(1:end-1),runmean((abs(diff(Data(Xtsd)))+abs(diff(Data(Ytsd))))./diff(Range(Xtsd,'s')),3));
RunningEpoch=thresholdIntervals(RunSpeed,SpeedThresh,'Direction','Above');
RunningEpoch=mergeCloseIntervals(RunningEpoch,1*1e4);
RunningEpoch=dropShortIntervals(RunningEpoch,2*1e4);

if plo==1
    figure,
    plot(Range(RunSpeed),Data(RunSpeed)), hold on
    line(xlim,[SpeedThresh SpeedThresh])
    plot(Range(Restrict(RunSpeed,RunningEpoch)),Data(Restrict(RunSpeed,RunningEpoch)))
end
end