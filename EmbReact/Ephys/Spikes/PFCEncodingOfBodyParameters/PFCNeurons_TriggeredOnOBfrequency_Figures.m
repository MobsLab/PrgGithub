%%
% Make basic figure linking PFC firing rate to OB frequency

clear all
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/
load('PFCUnitFiringOnOBFrequencyAllSess.mat')

MiceNumber=[490,507,508,509,510,512,514];
FreqLims=[2.5:0.15:6];

SaveFigsTo = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCOnOBFrequency/';

%% All units
AllSpk=[];
% AllPos = zeros(size(linData{1},1),size(linData{1},2));
AllOB = zeros(size(OBData{1},1),size(OBData{1},2));
for mm=1:length(MiceNumber)
    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    %     AllPos=AllPos+linData{mm};
    AllOB = AllOB+OBData{mm};
end

% Do PCA of all units response
Dat=nanzscore(AllSpk')';
[EigVect,EigVals]=PerformPCA(Dat);
fig=figure;
fig.Position=[680,558,860,820];
for k=1:3
    subplot(3,3,k)
    ToPlot=EigVect(:,k)'*Dat;
    plot(FreqLims(1:end-5),ToPlot), hold on
    ylabel(['Comp' num2str(k)])
    title(num2str(round(100*EigVals(k)/sum(EigVals))))
    %     title(['component',num2str(k)])
    xlabel('OB freq')
    subplot(3,3,k+3)
    tempmat=sortrows([EigVect(:,k),Dat]);
    imagesc(FreqLims(1:end-1),1:size(tempmat,1),(tempmat(:,2:end)))
    clim([-3 3])
    title('ordered firing mat')
    xlabel('OB freq'), ylabel('Neuron number')
    subplot(3,3,k+6)
    imagesc(corr(tempmat(:,2:end)')),clim([-1 1]);
    title('corr mat')
    xlabel('Neuron number'), ylabel('Neuron number')
end
saveas(fig.Number,[SaveFigsTo,'PCAPFCNeuronsTriggeredOnOBFreq.png'])
saveas(fig.Number,[SaveFigsTo,'PCAPFCNeuronsTriggeredOnOBFreq.fig'])


fig=figure;
subplot(3,1,[1,2])
tempmat=sortrows([ind',Dat]);
imagesc(FreqLims(1:end-1),1:size(tempmat,1),SmoothDec((tempmat(:,2:end)),[0.01,2]))

subplot(313)
imagesc(FreqLims,Spectro{3},AllOB'), axis xy
xlabel('classif freq'),ylabel('freq')
fig.Position= [2253 92 516 707];
saveas(fig.Number,[SaveFigsTo,'OBSpecandPosTriggeredOnOBFreq.png'])
saveas(fig.Number,[SaveFigsTo,'OBSpecandPosTriggeredOnOBFreq.fig'])


fig=figure;
subplot(211)
imagesc(FreqLims,Spectro{3},AllOB'), axis xy
xlabel('classif freq'),ylabel('freq')
subplot(212)
imagesc(FreqLims,[1:10],AllPos'), axis xy
set(gca,'YTick',[1 10],'YTickLabel',{'Safe','Shock'})
xlabel('classif freq'),ylabel('Position')
fig.Position= [2253 92 516 707];
saveas(fig.Number,[SaveFigsTo,'OBSpecandPosTriggeredOnOBFreq.png'])
saveas(fig.Number,[SaveFigsTo,'OBSpecandPosTriggeredOnOBFreq.fig'])

%% Just the sig units
GoodNeur = [];
PNeur = [];
RNeur = [];

for mm=1:length(MiceNumber)
    for sp=1:length(RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if RSpk{mm}(sp)>prctile(RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif RSpk{mm}(sp)<prctile(RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,PSpk{mm}(sp)];
            RNeur = [RNeur,RSpk{mm}(sp)];            
            
        end
    end
end

fig=figure;
subplot(121)
pie([sum(GoodNeur<0),sum(GoodNeur==0),sum(GoodNeur>0)])
legend({'Neg','NonSig','Pos'},'Location','NorthWestOutside')
colormap redblue
subplot(122)
histogram(RNeur(find(abs(GoodNeur)==0)),[-0.4:0.01:0.4],'FaceColor',[0.6 0.6 0.6],'Normalization','probability')
hold on
histogram(RNeur(find(abs(GoodNeur)>0)),[-0.4:0.01:0.4],'FaceColor',[0.5 0 0.5],'Normalization','probability')
legend({'NonSig','Sig'})
fig.Position = [2272 174 1153 680];
saveas(fig.Number,[SaveFigsTo,'SigniciantlyCorrelatedPFCUnits.png'])
saveas(fig.Number,[SaveFigsTo,'SigniciantlyCorrelatedPFCUnits.fig'])

Dat=nanzscore(AllSpk(abs(GoodNeur)>0,:)')';
[EigVect,EigVals]=PerformPCA(Dat);
fig=figure;
fig.Position=[680,558,860,820];
for k=1:3
    subplot(3,3,k)
    ToPlot=EigVect(:,k)'*Dat;
    plot(FreqLims(1:end-1),ToPlot), hold on
    ylabel(['Comp' num2str(k)])
    title(num2str(round(100*EigVals(k)/sum(EigVals))))
    title(['component',num2str(k)])
    xlabel('OB freq')
    subplot(3,3,k+3)
    tempmat=sortrows([EigVect(:,k),Dat]);
    imagesc(FreqLims(1:end-1),1:size(tempmat,1),(tempmat(:,2:end)))
    clim([-3 3])
    title('ordered firing mat')
    xlabel('OB freq'), ylabel('Neuron number')
    subplot(3,3,k+6)
    imagesc(corr(tempmat(:,2:end)')),clim([-1 1]);
    title('corr mat')
    xlabel('Neuron number'), ylabel('Neuron number')
end
saveas(fig.Number,[SaveFigsTo,'PCAPFCNeuronsTriggeredOnOBFreqOnlySig.png'])
saveas(fig.Number,[SaveFigsTo,'PCAPFCNeuronsTriggeredOnOBFreqOnlySig.fig'])
close all