function     PhaseLFP = GetPhaseFilteredLFP(FilLFP)
% This code uses hibert transform to get the instantaneous phase of a
% filtered LFP signal

    zr = hilbert(Data(FilLFP));
    phzr = atan2(imag(zr), real(zr));
    phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
    PhaseLFP = tsd(Range(FilLFP),phzr);
        

end