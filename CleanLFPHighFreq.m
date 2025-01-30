function [cLFP,PeriodBad]=CleanLFPHighFreq(LFP,Epoch)

try
    Epoch;
catch
    rg=Range(LFP);
    Epoch=intervalSet(rg(1),rg(end));
end

Fil=FilterLFP(Restrict(LFP,Epoch),[0.000001 240],512);
h=abs(hilbert(Data(Restrict(LFP,Epoch))-Data(Restrict(Fil,Epoch))));
t=FindLocalMax(tsd(Range(Restrict(LFP,Epoch)),h));
t2=tsd(Range(t),SmoothDec(Data(t),3));

PeriodBad=thresholdIntervals(t2,250,'Direction','Above');
PeriodBad=mergeCloseIntervals(PeriodBad,1000);
PeriodBad=dropShortIntervals(PeriodBad,1000);

cLFP=Restrict(LFP,Epoch-PeriodBad);

