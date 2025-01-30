function [q, timefail] = newtonsolve(muone,  qold, sigoldsq, mm, ll)
    							

%Solve the posterior mode equation using Newtons method
%variable  it(i)     is the estimate of posterior mode

eps_newt = 0.05;
it(1) = qold + sigoldsq*(mm - ll*exp(muone)*exp(qold)/(1 ... 
                                  + exp(muone)*exp(qold)));
q = 10;
for i = 1:100
    
   if abs(q-it(i))>1e-4
       ee = eps_newt;
   else
       ee = 1;
   end
   g(i)     = qold + sigoldsq*(mm - ll*exp(muone)*exp(it(i))/...
                              (1+exp(muone)*exp(it(i)))) - it(i);
   gprime(i)= -ll*sigoldsq*exp(muone)*exp(it(i))/(1+exp(muone)*exp(it(i)))^2 - 1;
   it(i+1)  = it(i) - ee * g(i)/gprime(i);
   q        = it(i+1);
   if abs(q-it(i))<1e-14
      %fprintf(2,'cvrged (1e-14) in %d iters \n', i);
      timefail = 0; 
      return
   end
end
if(i==100) 
%   fprintf(2,'failed to converge\n')
   %abs(q-it(i))
      [q, timefail] = fzerosolve(muone,  qold, sigoldsq, mm, ll);   

   return 
end
