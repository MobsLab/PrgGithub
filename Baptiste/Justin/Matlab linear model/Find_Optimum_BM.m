




function [x,fval,exitflag,output,grad,hessian] = Find_Optimum_BM(cost)

global InputInfo
global options

[x,fval,exitflag,output,grad,hessian] = fminunc(cost, InputInfo.x0 , options)

end







