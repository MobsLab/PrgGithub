function [x,fval,exitflag,output,lambda,grad,hessian] = Find_Optimum2_BM(cost)

global InputInfo
global options
global TotalArray

[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(cost, InputInfo.x1 , [], [], [], [], [1 1 1 1 1], [8 8 100 8 8], [], options)

end