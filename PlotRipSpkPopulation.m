function [C,tps]=PlotRipSpkPopulation(S,rip,binN,binSize)


for i=1:length(S)
    
    [C(i,:),B]=CrossCorr(Range(S{i}),Range(rip),binN,binSize);
    
end

tps=B/1E3;

figure('color',[1 1 1]), hold on
imagesc(tps,1:length(S),C)
plot(tps,rescale(mean(C),1,length(S)-1),'k','linewidth',2)
xlim([tps(1) tps(end)])
ylim([0.5 length(S)+0.5])
colorbar
title(num2str(length(Range(rip))))