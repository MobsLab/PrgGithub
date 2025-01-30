function LongEpoch=FindLongPeriodsEpoch(Epoch,lim)

% Epoch intervalSet
% lim time in sec lim(1): merge, lim(2): drop


try
    lim;
    lim=lim*1E4;
catch
    lim=[60,60]*1E4;
end

% LongEpoch=mergeCloseIntervals(Epoch,lim(1));
LongEpoch=dropShortIntervals(Epoch,lim(2)/2);
LongEpoch=mergeCloseIntervals(LongEpoch,lim(1));


LongEpoch=dropShortIntervals(LongEpoch,lim(2));
