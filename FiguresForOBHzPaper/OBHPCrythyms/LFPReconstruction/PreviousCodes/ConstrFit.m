function [x,fval,exitflag,output,lambda,grad,hessian] = ConstrFit(x0,MaxFunEvals_Data,MaxIter_Data)
% This is an auto generated MATLAB file from Optimization Tool.

% Start with the default options
options = optimset;
% Modify options setting
options = optimset(options,'Display', 'off');
options = optimset(options,'MaxFunEvals', MaxFunEvals_Data);
options = optimset(options,'MaxIter', MaxIter_Data);
options = optimset(options,'PlotFcns', { @optimplotfval });
options = optimset(options,'Algorithm', 'interior-point');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@ErrorModelLFP,x0,[],[],[],[],[],[],@nonlconstr,options);
