function [c,ceq] = ErrorModelWeightedSumDelayConstr(x)

global TrialSet time InputInfo

amp1=x(1); % amplitude for OB
amp2=x(2); % amplitude for HPC
tau1=x(3); % delay for OB from -InputInfo.MaxDel to InputInfo.MaxDel
tau2=x(4); % delay for HPC from -InputInfo.MaxDel to InputInfo.MaxDel

% c has to be <0
c = [-1];

% ceq has to be 0
ceq = double([abs(amp1)>20,abs(amp2)>20,abs(tau1)>InputInfo.MaxDel,abs(tau2)>InputInfo.MaxDel]);

end