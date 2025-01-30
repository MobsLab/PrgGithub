function [c,ceq] = ErrorModelAlphaFunctionOBFixedHPCResConstr(x)

global TrialSet time InputInfo

amp2=x(1);
n2=x(2);
tau2=x(3);

% c has to be <0
c = [-n2,tau2-InputInfo.MaxKernelDur,-tau2,n2-10];

% ceq has to be 0
ceq =0;

end