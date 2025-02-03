
function [mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] =JustPoltMod(Ph,nBins)


% valeur de phase en radian (0-1)

if max(Ph)<pi
Ph=Ph*2*pi;
end


%  [mu, Kappa, pval] = CircularMean(Ph);
%  
%  	modRatio=Kappa
%  	P=pval
%  
%  	dB = 2*pi/nBins;
%  	B = [0:dB:2*pi];
%  	C = hist(Ph,B);
%  	t=mu;
%  	t = mod(t+pi,2*pi)-pi;
%  	vm = von_mises_pdf(B-pi,t+pi,modRatio);
%  	modT = num2str(modRatio);	
%  	probaT = num2str(P);
%  
%  	
%  %  figure
%  	hold on
%  	bar(B,100*C/sum(C))
%  	plot(B,100*dB*vm,'lineWidth',2,'Color','r');
%  	ylabel('Percentage os spikes');
%  	xlabel('Phase (rad)');
%  	xlim([-0.1 2*pi+0.1])
%  	title(['K : ' modT ', p = ' probaT, ' Ph ', num2str(mu)]);

%---------------------------------------------------------------------------------------------------------------------------------------

%[mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] = CircularMean(Ph);

[mu, Kappa, pval] = CircularMean(Ph);

	modRatio=Kappa;
	P=pval;
	dB = 2*pi/nBins;
	B = [dB/2:dB:2*pi-dB/2];
	C = hist(Ph,B);
	t=mu;
	t = mod(t+pi,2*pi)-pi;
	vm = von_mises_pdf(B-pi,t+pi,modRatio);
	modT = num2str(floor(modRatio*100)/100);	
    probaT=sprintf('%0.2f',P);

    hold on
	bar(B,2*nBins*C/sum(C),1,'k')
	bar(B+2*pi,2*nBins*C/sum(C),1,'k')

    try
	plot([0 B 2*pi],2*nBins*dB*[vm(1) vm vm(end)],'lineWidth',3,'Color','r');
	plot([0 B 2*pi]+2*pi,2*nBins*dB*[vm(end) vm vm(1)],'lineWidth',3,'Color','r');
    end
    
	ylabel('Percentage');
	%xlabel('Phase (rad)');
	xlim([-0.1 4*pi+0.1])
    set(gca,'XTickLabel',[])
	title(['K ' modT ' p ' probaT,' Ph ',sprintf('%0.1f',mu), ]);
    xlabel([' n ',num2str(length(Ph))])
