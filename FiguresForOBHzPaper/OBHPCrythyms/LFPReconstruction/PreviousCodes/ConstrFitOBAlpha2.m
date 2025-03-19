function [x,fval,exitflag,output,lambda,grad,hessian] = ConstrFitOBAlpha2(x0,MaxFunEvals_Data,MaxIter_Data)
% This is an auto generated MATLAB file from Optimization Tool.

% Start with the default options
options = optimoptions('fmincon');
% Modify options setting
options = optimset(options,'Display', 'off');
options = optimset(options,'MaxFunEvals', MaxFunEvals_Data);
options = optimset(options,'MaxIter', MaxIter_Data);
options = optimset(options,'PlotFcns', { @optimplotfval });
options = optimset(options,'Algorithm', 'interior-point');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@ErrorModelLFPOBAlpha2,x0,[],[],[],[],[],[],@nonlconstrOBAlpha2,options);
