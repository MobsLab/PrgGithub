function [dur,durT]=DurationEpoch(Epoch)

dur=End(Epoch)-Start(Epoch);
durT=sum(End(Epoch)-Start(Epoch));

