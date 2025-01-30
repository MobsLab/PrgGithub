function [r,p,var]=PlotCorrDensitySpike(tsa,S,noNeuron,tailleBin, facteurImage,lg)

%tsa=FiltGauss(tsa,100,10);



%tailleBin=500; %pour 50ms;
Q = MakeQfromS(S,tailleBin*10);
Q=FiltGauss(Q,10,2);
Q=Restrict(Q,tsa);

ratio=length(Data(tsa))/length(Q);

tsa = FiltGauss(tsa,5,ratio);
ratek = Restrict(Q,tsa);
rate = Data(ratek);
ratek = tsd(Range(ratek),rate(:,noNeuron));

fig=get(0,'children');

fig=sort(fig);

try fig(end);
catch
fig=1;
end

if length(lg)==3&lg=='log'

	
%  		keyboard
		
		binnedR=Bin(full(log(Data(tsa))),[min(log(full(Data(tsa)))) max(log(full(Data(tsa))))],200);
		binnedC=Bin(full(Data(ratek)),[0 max(Data(ratek))],80);
		
		accumulated = Accumulate([binnedC binnedR]);
		
		clear binnedC
		clear binnedR
		
		[r,p]=corrcoef(full(log(Data(tsa))),full(Data(ratek)));
		var=polyfit(full(log(Data(tsa))),full(Data(ratek)),1);
		r=r(1,2);
		p=p(1,2);
		

		figure(fig(end)+1), subplot(4,1,[3,4]), plotColorMapKB(accumulated,1,[[min(log(full(Data(tsa)))) max(log(full(Data(tsa))))],[0 max(Data(ratek))]] ,'bar','on','cutoffs',[0 max(max(accumulated))/facteurImage]);
		
		
		subplot(4,1,[1;2]), hold on, plot(log(Data(tsa)),Data(ratek),'o','MarkerFaceColor','b'), plot([min(log(Data(tsa))):(max(log(Data(tsa)))-min(log(Data(tsa))))/20:max(log(Data(tsa)))],var(1).*[min(log(Data(tsa))):(max(log(Data(tsa)))-min(log(Data(tsa))))/20:max(log(Data(tsa)))]+var(2),'r', 'lineWidth',2), title(num2str(['r=',num2str(r), '    p=',num2str(p), '      y=ax+b   a=',num2str(var(1)),'  b=',num2str(var(2))]))
		
		clear accumulated


else 

binnedR=Bin(full(Data(tsa)),[min(Data(tsa)) max(Data(tsa))],200);
binnedC=Bin(full(Data(ratek)),[0 max(Data(ratek))],80);

accumulated = Accumulate([binnedC binnedR]);

clear binnedC
clear binnedR

[r,p]=corrcoef(full(Data(tsa)),full(Data(ratek)));
var=polyfit(full(Data(tsa)),full(Data(ratek)),1);
r=r(1,2);
p=p(1,2);

figure(fig(end)+1), subplot(4,1,[3,4]), plotColorMapKB(accumulated,1,[[min(Data(tsa)) max(Data(tsa))],[0 max(Data(ratek))]],'bar','on','cutoffs',[0 max(max(accumulated))/facteurImage]);


subplot(4,1,[1;2]), hold on, plot(Data(tsa),Data(ratek),'o','MarkerFaceColor','b'), plot([min(Data(tsa)):(max(Data(tsa))-min(Data(tsa)))/20:max(Data(tsa))],var(1).*[min(Data(tsa)):(max(Data(tsa))-min(Data(tsa)))/20:max(Data(tsa))]+var(2),'r', 'lineWidth',2), title(num2str(['r=',num2str(r), '    p=',num2str(p), '      y=ax+b   a=',num2str(var(1)),'  b=',num2str(var(2))]))

clear accumulated

end