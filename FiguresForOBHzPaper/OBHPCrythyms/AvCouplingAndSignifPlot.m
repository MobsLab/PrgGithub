function AvCouplingAndSignifPlot(mat,FreqRange,Cols,MaxStar,InterStar)

hold on
NumOfSig=sum(mat>0);
for k=1:length(FreqRange)
    for i=1:NumOfSig(k)
        plot(mean(FreqRange(:,k)),MaxStar-(i-1)*InterStar,'*','color',Cols)
    end
end
mat(mat==0)=NaN;
plot(mean(FreqRange),nanmean(mat),'color',Cols*0.7,'linewidth',2)
ToDel=find(sum(isnan(mat))>=(size(mat,1)-1));
FreqRange(:,ToDel)=[];
mat(:,ToDel)=[];

[hl,hp]=boundedline(mean(FreqRange),nanmean(mat),[stdError(mat);stdError(mat)]','alpha');hold on
set(hl,'Color',Cols*0.7,'linewidth',2)
set(hp,'FaceColor',Cols)

end