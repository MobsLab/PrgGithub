
function [ph,mu, Kappa, pval,B,C]=ModulationTheta(tsa,EEGf,Epoch,nmbBin,plo)

% INPUT
% tsa : ts array containing the spike times of 1 neuron ex : S{1}
% EEGf: filtered LFP (tsd) in a given frequency band
% Epoch : intervalset containing the epoch of interest
% nmbBin : nb bin for the histogram of nbspike=f(phase of the oscillation)
% plo : if 1 new figure if 0 plot into existent figure

% OUTPUT
% ph: a tsdArray of firing phases for the spike trains in tsa
% mu : average phase of the neuron
% kappa : give the strencth of the modulation
% pval : 
% B : abscissae of the histogram (from 0 ot 2pi)
% C : histogram of spikes (for the different phases from 0 ot 2pi)

try
    plo;
catch
    plo=0;
end

try
   nmbBin;
catch
    nmbBin=25;
end

try
    [phaseTsd, ph] = firingPhaseHilbert(EEGf, Restrict(tsa, Epoch)) ;
catch
    [phaseTsd, ph] = firingPhaseHilbert(EEGf, Restrict(tsdArray(tsa), Epoch)) ;
end


%  [ph, thpeaks] = TethaPhase2(tsa, EEGf);
%  Ph=Data(Restrict(ph,Epoch));
%  Ph=Ph(:,1);
%  [mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] = CircularMean(2*pi*Ph);


try
[mu, Kappa, pval, Rmean, delta, sigma,confDw,confUp] = CircularMean(Data(ph{1}));
catch
[mu, Kappa, pval] = CircularMean(Data(ph{1}));   
end


	modRatio=Kappa;
	P=pval;
	dB = 2*pi/nmbBin;
	B = [dB/2:dB:2*pi-dB/2];

%  	C = hist(2*pi*Ph,B);

	C = hist(Data(Restrict(ph{1},Epoch)),B);


	t=mu;
	t = mod(t+pi,2*pi)-pi;
	vm = von_mises_pdf(B-pi,t+pi,modRatio);
	modT = sprintf('%.2f',modRatio);	
	probaT = sprintf('%.2f',P);

if plo
    figure('color',[1 1 1])
end


hold on
	bar(B,2*nmbBin*C/sum(C),1)
	bar(B+2*pi,2*nmbBin*C/sum(C),1)

    try
    
    plot([0 B 2*pi],2*nmbBin*dB*[vm(1) vm vm(end)],'lineWidth',2,'Color','r');
	plot([0 B 2*pi]+2*pi,2*nmbBin*dB*[vm(end) vm vm(1)],'lineWidth',2,'Color','r');
%     catch
%         keyboard
    end
	ylabel('Percentage of spikes');
	xlabel('Phase (rad)');
	xlim([-0.1 4*pi+0.1])

%  	title(['K : ' modT ', p = ' probaT,', Ph ',num2str(mu), ', n ',num2str(length(Ph))]);
	title(['K : ' modT ', p = ' probaT,', Ph ',sprintf('%.2f',mu), ', n ',sprintf('%.0f',length(Data(Restrict(ph{1},Epoch))))]);
%  catch
%      keyboard
%  end