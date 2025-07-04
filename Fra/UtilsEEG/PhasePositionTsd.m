function PP = PhasePositionTsd(S, X, CRtheta, ThStart, ThEnd)
% PP = PhasePositionTsd(S, X, CRtheta, ThStart, ThEnd)
%
% computes the phase and the position for each spike for a group of cells
% 
% INPUTS:
% S:              cell array of ts objects containing the spike trains
% X:              tsd containing a position coordinate
% CRtheta:        EEG tsd object filtered for theta
% ThStart, Thend: arrays containig the start and stop times of the valid
%                 theta epochs
% 
% OUTPUTS:
% PP:             a tsd with data containing two columns, position and phase

% batta 2000
% status: alpha


[ph, thpeaks] = ThetaPhase(S, CRtheta, ThStart, ThEnd);

for i = 1:length(S)
  S{i} = Restrict(S{i}, ThStart, ThEnd);
  SP = Restrict(X, Data(S{i}));

  PP{i} = tsd(Data(S{i}), [Data(SP), Data(ph{i})]);
end
  

