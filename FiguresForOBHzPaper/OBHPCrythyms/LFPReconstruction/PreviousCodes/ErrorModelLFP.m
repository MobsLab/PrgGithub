function y=ErrorModelLFP(x,varargin)
%parameters
amp1=x(1);
n1=x(2);
tau1=x(3);
n2=x(4);
tau2=x(5);

global dataB dataP dataH dt
% time vector
t=[0:dt:3];
%alphas functions
Alpha1=amp1*(t).^n1.*exp(-(t)./tau1);
Alpha2=(t).^n2.*exp(-(t)./tau2);

% make convolution
y1=conv(dataB,Alpha1);
y2=conv(dataH,Alpha2);
y1=y1(1:length(dataP))/max(y1);
y2=y2(1:length(dataP))/max(y2);

% reconstruction of stim and error 
sumY=std(dataP).*(y1+y2)./std(y1+y2);
y=min([sum((sumY(floor(2/dt):end)-dataP(floor(2/dt):end)).^2),...
    sum((-sumY(floor(2/dt):end)-dataP(floor(2/dt):end)).^2)]);

end