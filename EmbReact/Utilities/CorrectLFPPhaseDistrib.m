function     PhaseLFPCorr = CorrectLFPPhaseDistrib(PhaseLFP)
% This code uses hibert transform to get the instantaneous phase of a
% filtered LFP signal

    % Get correction function
    [fedf,xedf]=ecdf(Data(PhaseLFP));
    Funct=2*pi*(fedf);
    
    % Correct phases of LFP
    bins = discretize(Data(PhaseLFP), xedf);
    TransPh=Funct(bins);
    
    PhaseLFPCorr.Nontransf=PhaseLFP;
    PhaseLFPCorr.Transf=tsd(Range(PhaseLFP),TransPh);
    PhaseLFPCorr.Funct=Funct;
    PhaseLFPCorr.xedf=xedf;

end