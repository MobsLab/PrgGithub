function [c,ceq] = nonlconstrOBAlpha2(x)

global dt
amp1=x(1);
n1=x(2);
tau1=x(3);
n2=x(4);
tau2=x(5);

t=[0:dt:3];
Alpha1=amp1*(t).^n1.*exp(-(t)./tau1)+(t).^n2.*exp(-(t)./tau2);
Alpha1=Alpha1./max(Alpha1);

c = [-n1;
    -n2;
    -tau1;
    -tau2;
    n1-2;
    n2-2;
    abs(amp1)-10];
ceq = [max(abs(Alpha1))==length(Alpha1)];

end