function [r,p,var,accumulated,MAP]=PlotCorrelationDensity(tsa1,tsa2,a,opt,siz)

%
% [r,p,var,accumulated,MAP]=PlotCorrelationDensity(tsa1,tsa2,a,opt,siz)
% value a by default 1000
% opt=='log'

try
    a;
catch
    a=1000;
    disp('value a by default 1000')    
end

try
Tsa1t=full(Data(tsa1));
Tsa2t=full(Data(Restrict(tsa2,tsa1)));
catch
Tsa1t=tsa1;
Tsa2t=tsa2;
end

try
siz;
catch
siz=50;
end

try
    opt;
catch
    opt=0;
end


if length(opt)==3

	if opt=='log'

		Tsa1=Tsa1t(find(Tsa1t~=0&Tsa2t~=0));
		Tsa2=Tsa2t(find(Tsa1t~=0&Tsa2t~=0));

		binnedRLog=Bin(log((Tsa1)),[min(log(Tsa1)) max(log(Tsa1))],siz);
		binnedCLog=Bin(log((Tsa2)),[min(log(Tsa2)) max(log(Tsa2))],siz);
		
		accumulatedLog = Accumulate([binnedCLog binnedRLog]);
		accumulated=accumulatedLog;
		
		[r,p]=corrcoef(log(Tsa1),log(Tsa2));
		var=polyfit(log(Tsa1),log(Tsa2),1);
		r=r(1,2);
		p=p(1,2);
		
		figure, subplot(4,1,[3,4]), MAP=PlotColorMapKB(accumulatedLog,1,[[min(log(Tsa1t)) max(log(Tsa1t))],[min(log(Tsa2t)) max(log(Tsa2t))]],'bar','on','cutoffs',[0 max(max(accumulatedLog))/(a/100)]);
		
		subplot(4,1,[1;2]), hold on, plot(log(Tsa1),log(Tsa2),'o','MarkerFaceColor','b'), plot([min(log(Tsa1)):(max(log(Tsa1))-min(log(Tsa1)))/20:max(log(Tsa1))],var(1).*[min(log(Tsa1)):(max(log(Tsa1))-min(log(Tsa1)))/20:max(log(Tsa1))]+var(2),'k'), title(num2str(['version Log  ','r=',num2str(r), '    p=',num2str(p), '      y=ax+b   a=',num2str(var(1)),'  b=',num2str(var(2))]))
		


	else
		
		
		binnedR=Bin((Tsa1t),[min(Tsa1t) max(Tsa1t)],siz);
		binnedC=Bin((Tsa2t),[min(Tsa2t) max(Tsa2t)],siz);
		
		accumulated = Accumulate([binnedC binnedR]);
		
		clear binnedC
		clear binnedR
		
		[r,p]=corrcoef(Tsa1t,Tsa2t);
		var=polyfit(Tsa1t,Tsa2t,1);
		r=r(1,2);
		p=p(1,2);
		
		figure, subplot(4,1,[3,4]), MAP=PlotColorMapKB(accumulated,1,[[min(Tsa1t) max(Tsa1t)],[min(Tsa2t) max(Tsa2t)]],'bar','on','cutoffs',[0 max(max(accumulated))/a]);
		
		subplot(4,1,[1;2]), hold on, plot(Tsa1t,Tsa2t,'o','MarkerFaceColor','b'), plot([min(Tsa1t):(max(Tsa1t)-min(Tsa1t))/20:max(Tsa1t)],var(1).*[min(Tsa1t):(max(Tsa1t)-min(Tsa1t))/20:max(Tsa1t)]+var(2),'r', 'lineWidth',2), title(num2str(['r=',num2str(r), '    p=',num2str(p), '      y=ax+b   a=',num2str(var(1)),'  b=',num2str(var(2))]))
		

		
		
	end

else

binnedR=Bin((Tsa1t),[min(Tsa1t) max(Tsa1t)],siz);
binnedC=Bin((Tsa2t),[min(Tsa2t) max(Tsa2t)],siz);

accumulated = Accumulate([binnedC binnedR]);

clear binnedC
clear binnedR

[r,p]=corrcoef(Tsa1t,Tsa2t);
var=polyfit(Tsa1t,Tsa2t,1);
r=r(1,2);
p=p(1,2);

figure, subplot(4,1,[3,4]), MAP=PlotColorMapKB(accumulated,1,[[min(Tsa1t) max(Tsa1t)],[min(Tsa2t) max(Tsa2t)]],'bar','on','cutoffs',[0 max(max(accumulated))/a]);

subplot(4,1,[1;2]), hold on, plot(Tsa1t,Tsa2t,'o','MarkerFaceColor','b'), plot([min(Tsa1t):(max(Tsa1t)-min(Tsa1t))/20:max(Tsa1t)],var(1).*[min(Tsa1t):(max(Tsa1t)-min(Tsa1t))/20:max(Tsa1t)]+var(2),'r', 'lineWidth',2), title(num2str(['r=',num2str(r), '    p=',num2str(p), '      y=ax+b   a=',num2str(var(1)),'  b=',num2str(var(2))]))




end