function         PhaseNeuronCorr = GetNeuronPhaseFromLFPPhase(S,PhaseLFPCorr)


PhaseNeuronCorr.Nontransf = Restrict(PhaseLFPCorr.Nontransf, S, 'align', 'closest', 'time', 'align');
PhaseNeuronCorr.Transf = Restrict(PhaseLFPCorr.Transf, S, 'align', 'closest', 'time', 'align');

end