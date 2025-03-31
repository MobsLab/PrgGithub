
function q=QualityModulation(Ph,nBins)

plo=1;

[mu, Kappa, pval] = CircularMean(Ph);
modRatio=Kappa;
P=pval;
dB = 2*pi/nBins;
B = [dB/2:dB:2*pi-dB/2];
C = hist(Ph,B);
t=mu;
t = mod(t+pi,2*pi)-pi;
vm = von_mises_pdf(B-pi,t+pi,modRatio);

q=sum(((C/sum(C))-(dB*vm)).^2);

if plo
figure, plot(B,nBins*dB*vm,'r','lineWidth',3)
hold on, plot(B,nBins*C/sum(C),'k')
end


