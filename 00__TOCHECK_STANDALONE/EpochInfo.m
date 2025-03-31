function [av,stan,tot]=EpochInfo(Epoch)
if size(Stop(Epoch),1)~=0
    dur=Stop(Epoch)-Start(Epoch);
    av=mean(dur);
    stan=stdError(dur);
    tot=sum(dur);
else
    av=NaN;
    stan=NaN;
    tot=NaN;
end
end