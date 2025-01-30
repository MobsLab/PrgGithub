function [q, timefail] =  fzerosolve(muone,  qold, sigoldsq, mm, ll)



xInit = qold + sigoldsq*(mm - ll*exp(muone)*exp(qold)/(1 ... 
                                  + exp(muone)*exp(qold)));



q = fzero(@(x) myfun(x,muone,  qold, sigoldsq, mm, ll),xInit);
timefail = 0;



function f = myfun (x,muone,  qold, sigoldsq, mm, ll)

f = qold + sigoldsq*(mm - ll*exp(muone)*exp(x)/...
                              (1+exp(muone)*exp(x))) - x;