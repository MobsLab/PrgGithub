function [c,ceq] = ErrorModelWeightedSumConstr(x)

global TrialSet time InputInfo

amp1=x(1);
amp2=x(2);

% c has to be <0
c = [-1];

% ceq has to be 0
ceq = double([abs(amp1)>20,abs(amp2)>20]);

end