function [ph,mu,Kappa, pval,B,C,nmbBin,Cc,dB,vm]=ModulationThetaCorrection(S,fil,epoch,nbin)

% example :
% [ph,mu, Kappa, pval,B,C]=ModulationTheta(S{numNeurons(1)},fil,Epoch{9},30,1);


%% Distribution of phases in fil

zr = hilbert(Data(fil));
phzr = atan2(imag(zr), real(zr));
phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
phtsd=tsd(Range(fil),phzr);

figure('Color',[1 1 1]), 
subplot(1,3,1),hist([Data(Restrict(phtsd,epoch));2 * pi+Data(Restrict(phtsd,epoch))],30)
title('Phase distribution (rad)')
xlabel('Phase (rad)'); ylabel('number of event')
xlim([-0.1 4*pi+0.1])

%% Modulation neuron by fil

subplot(1,3,2),
[ph,mu, Kappa, pval,B,C]=ModulationTheta(S,fil,epoch,nbin,0);


hi=hist(Data(Restrict(phtsd,epoch)),B);
Cc=(C./hi)/max(C./hi)*max(C);

Phc=[];
for i=1:length(B)
    Phc=[Phc,B(i)*ones(1,floor(Cc(i)))];    
end

[mu, Kappa, pval] = CircularMean(Phc);    

nmbBin=length(B);
dB = 2*pi/nmbBin;
    
modRatio=Kappa;
P=pval;
t=mu;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,modRatio);
modT = num2str(modRatio);	
probaT = num2str(P);

%% plot corrected modulation
subplot(1,3,3),
hold on
bar(B,2*nmbBin*Cc/sum(Cc),1)
bar(B+2*pi,2*nmbBin*Cc/sum(Cc),1)
plot([0 B 2*pi],2*nmbBin*dB*[vm(1) vm vm(end)],'lineWidth',2,'Color','r');
plot([0 B 2*pi]+2*pi,2*nmbBin*dB*[vm(end) vm vm(1)],'lineWidth',2,'Color','r');

ylabel('Percentage of spikes');
xlabel('Phase (rad)');
xlim([-0.1 4*pi+0.1])

title(['CORRECTED  K : ' modT ', p = ' probaT,', Ph ',num2str(mu), ', n ',num2str(length(Phc))]);


