
try
    voieLFP;
catch
voieLFP=53;
end

FilRip=FilterLFP(LFP{voieLFP},[130 200],96);
filtered=[Range(FilRip,'s') Data(FilRip)];
if 0
    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[AmplRipLow AmplRipHigh]);
else
%Immob=thresholdIntervals(V,5,'Direction','Below');
%idx=find(End(Immob,'s')-Start(Immob,'s')>20);
%ripples=FindRipplesKarim(LFP{voieLFP},Subset(Immob,idx));

Immob1=intervalSet(0, 1140*1E4);
ripples=FindRipplesKarim(LFP{voieLFP},Immob1);

end

[maps,data,stats] = RippleStats(filtered,ripples);
PlotRippleStats(ripples,maps,data,stats)

figure, ImagePETH(LFP{voieLFP}, ts(ripples(:,2)*1E4), -2000, +2000,'BinSize',10);

for NumNeuron=1:3:length(S)
figure('Color',[1 1 1])
[fh,sq,sweeps] = RasterPETH(S{NumNeuron}, ts(ripples(:,2)*1E4), -2000, +2000,'BinSize',10);
title(cellnames{NumNeuron})
end

