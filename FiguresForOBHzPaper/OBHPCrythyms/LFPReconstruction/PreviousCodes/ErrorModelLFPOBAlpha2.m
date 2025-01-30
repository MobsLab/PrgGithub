function y=ErrorModelLFPOBAlpha2(x,varargin)
%keyboard
amp1=x(1);
n1=x(2);
tau1=x(3);
n2=x(4);
tau2=x(5);

global dataB dataP dataH dt

t=[0:dt:3];
Alpha1=amp1*(t).^n1.*exp(-(t)./tau1)+(t).^n2.*exp(-(t)./tau2);

y1=conv(dataB,Alpha1);
y1=y1(1:length(dataP))/max(y1);


sumY=std(dataP).*(y1)./std(y1);
y=min([sum((sumY(floor(2/dt):end)-dataP(floor(2/dt):end)).^2),...
    sum((-sumY(floor(2/dt):end)-dataP(floor(2/dt):end)).^2)]);

end