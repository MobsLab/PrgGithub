


function [x,fval,exitflag,output,lambda,grad,hessian] = Find_Optimum2_BM(cost)

global InputInfo
global options
global TotalArray

[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(cost, InputInfo.x0 , [], [], [], [], [1 1 1 2 2 100 0.01], [8 8 1000 8 8 6000 1], [], options)

end





