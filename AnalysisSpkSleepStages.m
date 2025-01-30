%AnalysisSpkSleepStages

[op,NamesOp,Dpfc,Epoch]=FindNREMepochsML;
[MATEP,nameEpochs]=DefineSubStages(op);

load SpikeData
[Spfc,neu]=GetSpikesFromStructure('PFCx',S);

for a=1:length(op)
Fr(a)=length(Range(Restrict(PoolNeurons(S,neu),op{a})))/sum(End(op{a},'s')-Start(op{a},'s'))/length(neu);
end

for a=1:length(MATEP)
Fr2(a)=length(Range(Restrict(PoolNeurons(S,neu),MATEP{a})))/sum(End(MATEP{a},'s')-Start(MATEP{a},'s'))/length(neu);
end

for n=1:length(neu)
for a=1:length(op)
FrSpk(a,n)=length(Range(Restrict(S{neu(n)},op{a})))/sum(End(op{a},'s')-Start(op{a},'s'));
end
end

for n=1:length(neu)
for a=1:length(MATEP)
FrSpk2(a,n)=length(Range(Restrict(S{neu(n)},MATEP{a})))/sum(End(MATEP{a},'s')-Start(MATEP{a},'s'));
end
end


figure('color',[1 1 1])
subplot(4,2,1), hold on
plot(mean(FrSpk'),'ro-')
errorbar([1:length(op)],mean(FrSpk'),stdError(FrSpk'),'r')
plot(median(FrSpk'),'ko-')
errorbar([1:length(op)],median(FrSpk'),stdError(FrSpk'),'k')
set(gca,'xtick',[1:length(op)])
set(gca,'xticklabel',NamesOp)
xlim([0 length(op)+1])

subplot(4,2,2), hold on
plot(mean(FrSpk2'),'ro-')
errorbar([1:length(MATEP)],mean(FrSpk2'),stdError(FrSpk2'),'r')
plot(median(FrSpk2'),'ko-')
errorbar([1:length(MATEP)],median(FrSpk2'),stdError(FrSpk2'),'k')
set(gca,'xtick',[1:length(MATEP)])
set(gca,'xticklabel',nameEpochs)
xlim([0 length(MATEP)+1])


subplot(4,2,3), hold on
plot(FrSpk)
set(gca,'xtick',[1:length(op)])
set(gca,'xticklabel',NamesOp)
xlim([0 length(op)+1])

subplot(4,2,4), hold on
plot(FrSpk2)
set(gca,'xtick',[1:length(MATEP)])
set(gca,'xticklabel',nameEpochs)
xlim([0 length(MATEP)+1])

subplot(4,2,5), hold on
plot(nanzscore(FrSpk))
set(gca,'xtick',[1:length(op)])
set(gca,'xticklabel',NamesOp)
xlim([0 length(op)+1])

subplot(4,2,6), hold on
plot(nanzscore(FrSpk2))
set(gca,'xtick',[1:length(MATEP)])
set(gca,'xticklabel',nameEpochs)
xlim([0 length(MATEP)+1])


subplot(4,2,7), hold on
plot(mean(nanzscore(FrSpk)'),'ro-')
errorbar([1:length(op)],mean(nanzscore(FrSpk)'),stdError(nanzscore(FrSpk)'),'r')
plot(median(nanzscore(FrSpk)'),'ko-')
errorbar([1:length(op)],median(nanzscore(FrSpk)'),stdError(nanzscore(FrSpk)'),'k')
set(gca,'xtick',[1:length(op)])
set(gca,'xticklabel',NamesOp)
xlim([0 length(op)+1])

subplot(4,2,8), hold on
plot(mean(nanzscore(FrSpk2)'),'ro-')
errorbar([1:length(MATEP)],mean(nanzscore(FrSpk2)'),stdError(nanzscore(FrSpk2)'),'r')
plot(median(nanzscore(FrSpk2)'),'ko-')
errorbar([1:length(MATEP)],median(nanzscore(FrSpk2)'),stdError(nanzscore(FrSpk2)'),'k')
set(gca,'xtick',[1:length(MATEP)])
set(gca,'xticklabel',nameEpochs)
xlim([0 length(MATEP)+1])

