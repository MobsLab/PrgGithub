function [x,fval,exitflag,output,lambda,grad,hessian]=FitTheDataOBHPCPFCxFit(TrialSet,FitFunction,ConstraintFunction)

% InputInfo.subsample : points to skip to subsample data, so 1 is no
% subsampling, 10 subsamples by a factor 10
% InputInfo.SampleRate : sample rate of original data
% InputInfo.x0=[StartingValues];
% InputInfo.MaxFunEvals_Data=10000;
% InputInfo.MaxIter_Data=10000;
% InputInfo.Display=1 to wtach the algorithm converge

global TrialSet time InputInfo

options = optimoptions('fmincon');
options.MaxFunEvals=InputInfo.MaxFunEvals_Data;
options.MaxIter=InputInfo.MaxIter_Data;
options.Display='None';

if InputInfo.Display==1
options.Display='iter';
options.PlotFcns=@optimplotfval;
end

options.OptimalityTolerance=1e-16;
% subsample if necessary
TrialSet.HPC=TrialSet.HPC(:,1:InputInfo.subsample:end);
TrialSet.OB=TrialSet.OB(:,1:InputInfo.subsample:end);
TrialSet.PFCx=TrialSet.PFCx(:,1:InputInfo.subsample:end);
time=[1./InputInfo.SampleRate:1./InputInfo.SampleRate:size(TrialSet.OB,2)/InputInfo.SampleRate]; time=time(1:InputInfo.subsample:end);
% Start with the default InputInfo
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(FitFunction,InputInfo.x0,[],[],[],[],[],[],ConstraintFunction,options);



end