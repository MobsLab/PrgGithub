




Fil=FilterLFP(LFP,[5 10],1024);

zr = hilbert(Data(Fil));
phzr = atan2(imag(zr), real(zr));
phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
zrTheta = hilbert(Data(Fil));

power=abs(zrTheta);
powerTsd=tsd(Range(Fil),power);
th=percentile(power,50);

ThetaEpoch = thresholdIntervals(Restrict(powerTsd,Wake), th);

for i=1:length(S)
    try
figure('Color',[1 1 1])
[PH,mu(i), Kappa(i), pval(i)]=ModulationTheta(S{i},Fil,ThetaEpoch,10);
    ph{i}=PH{1};
    catch
mu(i)=0; Kappa(i)=0; pval(i)=0;
    end
 
end

for i=1:length(S)
figure('Color',[1 1 1])
try
    subplot(1,2,1),JustPoltMod(Data(ph{i}),15);
end
try
    subplot(1,2,2),rose(Data(ph{i}));title('Modulation Theta -RestrictedEpoch-');
end
end
