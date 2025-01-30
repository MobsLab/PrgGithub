function Spi=ObservationSpindlesSingle(LFP,EpochSpiDetect,freq,Spi) 


sp=3000;
rg=Range(LFP,'s');

try
    Spi;
catch
    Spi = FindSpindlesKJ(LFP, EpochSpiDetect, 'frequency_band',freq);
end

SpindlesEpoch=intervalSet(Spi(:,1)*1E4,Spi(:,3)*1E4);

Filsp = FilterLFP(LFP,freq,1024);
squaredSignal = Data(Filsp).^2;

windowLength = 11;
%windowLength=1/median(diff(Range(Filsp,'s')))/1250*11;

window = ones(windowLength,1)/windowLength;
[normalizedSquaredSignal] = unity(Filter0(window,sum(squaredSignal,2)));
temp = tsd(Range(Filsp),smooth(normalizedSquaredSignal,10));
t = FindLocalMax(temp);
normalizedSquaredSignal = Data(Restrict(t,temp));
squaretsd=tsd(Range(Filsp),runmean(rescale(normalizedSquaredSignal,0,2.5*max(Data(Filsp))),100));


variance_sig = (2/3) * std(Data(Restrict(Filsp,EpochSpiDetect)));
threshold=3*variance_sig;


figure, hold on
plot(Range(LFP,'s'),Data(LFP),'k')

for i=1:length(Start(SpindlesEpoch))
    plot(Range(Restrict(LFP,subset(SpindlesEpoch,i)),'s'),Data(Restrict(LFP,subset(SpindlesEpoch,i))),'r')

end
plot(Range(LFP,'s'),-2*sp+Data(LFP),'k')
plot(Range(Filsp,'s'),-2*sp+Data(Filsp),'r','linewidth',2)
plot(Range(squaretsd,'s'),-2*sp+Data(squaretsd),'m','linewidth',1)
line([rg(1),rg(end)],[threshold threshold]-2*sp,'color',[0.7 0.7 0.7])

  