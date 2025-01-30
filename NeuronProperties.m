function NeuronProperties(S,W,NumNeuron,cellnames)





[C,B]=CrossCorr(Range(S{NumNeuron}),Range(S{NumNeuron}),1,60);
C(B==0)=0;

[Cl,Bl]=CrossCorr(Range(S{NumNeuron}),Range(S{NumNeuron}),10,100);
Cl(Bl==0)=0;

nu=max(size(W{NumNeuron},2),4);

figure('Color',[1 1 1])
subplot(nu,2,[1,3]), bar(B,C,1,'k'), xlim([-30 30]),title(cellnames{NumNeuron})
subplot(nu,2,[5,7]), bar(Bl,Cl,1,'k'), xlim([-500 500])

for i=1:size(W{NumNeuron},2)
subplot(nu,2,2*i),
try 
hold on
plot(mean(squeeze(W{NumNeuron}(:,i,:))),'k','linewidth',2);plot(mean(squeeze(W{NumNeuron}(:,i,:)))+std(squeeze(W{NumNeuron}(:,i,:))),'Color',[0.7 0.7 0.7]) 
plot(mean(squeeze(W{NumNeuron}(:,i,:)))-std(squeeze(W{NumNeuron}(:,i,:))),'Color',[0.7 0.7 0.7]) 


end
end


subplot(nu,2,2),title(['Neuron ',num2str(NumNeuron)]);
