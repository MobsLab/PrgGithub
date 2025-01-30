function [c,ceq] = ErrorModelAlphaFunctionConstr(x)

global TrialSet time InputInfo

amp1=x(1);
n1=x(2);
tau1=x(3);
amp2=x(4);
n2=x(5);
tau2=x(6);

% c has to be <0
c = [-n1,tau1-InputInfo.MaxKernelDur,-tau1,n1-10,-n2,tau2-InputInfo.MaxKernelDur,-tau2,n2-10];

% ceq has to be 0
ceq =0;

end