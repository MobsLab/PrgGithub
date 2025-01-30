
function PlotMod(Ph,nBins)

% Plot Phase diagram (between 0 and 4pi)
% 
% to be used with the command figure before
% 
% INPUTS:
% Ph: phases of spikes in rad (between 0 and 2pi)
% nBins: number of Bin of the histogram
% 
% 
% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html

[mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] = CircularMean(Ph);



	modRatio=Kappa;
	P=pval;
	dB = 2*pi/nBins;;
	B = [dB/2:dB:2*pi-dB/2];
	C = hist(Ph,B);
	t=mu;
	t = mod(t+pi,2*pi)-pi;
	vm = von_mises_pdf(B-pi,t+pi,modRatio);
	modT = num2str(modRatio);	
	probaT = num2str(P);
	

hold on
	bar(B,2*nBins*C/sum(C),1)
	bar(B+2*pi,2*nBins*C/sum(C),1)
    plot([B B+2*pi],2*nBins*dB*[vm vm],'r','lineWidth',3)
	ylabel('Percentage');
	xlabel('Phase (rad)');
	xlim([-0.1 4*pi+0.1])
	title(['K : ' modT ', p = ' probaT,', Ph ',num2str(mu), ', n ',num2str(length(Ph))]);
