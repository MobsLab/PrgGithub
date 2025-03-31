%%
% Make basic figure linking PFC firing rate to OB frequency

clear all
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat');

MiceNumber=[490,507,508,509,510,512,514];
FreqLims=[2:0.15:11];
FreqLims = FreqLims(3:end-2);

SaveFigsTo = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCOnOBFrequency/';

%% All units
AllSpk=[];
AllSpkIn=[];

AllOB = zeros(size(OBData{1},1),size(OBData{1},2));
for mm=1:length(MiceNumber)
    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    AllSpkIn=[AllSpkIn;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];

    AllOB = AllOB+OBData{mm};
end


fig=figure;
subplot(3,1,[1,2])
Dat=nanzscore(AllSpk')';
ToDel = find(sum(isnan(Dat)'))
Dat(ToDel,:) =[];
[val,ind] = max(Dat');
tempmat=sortrows([ind',Dat]);
imagesc(FreqLims(1:end-1),1:size(tempmat,1),SmoothDec((tempmat(:,2:end)),[0.01,2]))

subplot(313)
imagesc(FreqLims,Spectro{3},AllOB'), axis xy
xlabel('classif freq'),ylabel('freq')



% Do PCA of all units response
Dat=nanzscore(AllSpk')';
ToDel = find(sum(isnan(Dat)'));
Dat(ToDel,:) =[];
Dat = SmoothDec(Dat,[0.1,2])
Dat= Dat(:,3:end-2);
[EigVect,EigVals]=PerformPCA(Dat);
% fig=figure;
% fig.Position=[680,558,860,820];
for k=1:2
    subplot(2,2,k)
    ToPlot=EigVect(:,k)'*Dat;
    plot(FreqLims(1:end-1),ToPlot,'linewidth',2,'color','k'), hold on
    ylabel(['Comp' num2str(k)])
    ylim([-15 15])
    title(num2str(round(100*EigVals(k)/sum(EigVals))))
    box off
    set(gca,'FontSize',12,'linewidth',2)
    
    xlim([FreqLims(1) FreqLims(end)])
    %     title(['component',num2str(k)])
    xlabel('OB freq')
    subplot(2,2,k+2)
    tempmat=sortrows([EigVect(:,k),Dat]);
    imagesc(FreqLims(1:end-1),1:size(tempmat,1),(tempmat(:,2:end)))
    clim([-2.5 2.5])
    xlabel('OB freq'), ylabel('Unit - reordered')
    set(gca,'FontSize',12,'linewidth',2)
    box off
end

AllInfoOut = [];
for mm=1:length(MiceNumber)
    AllInfoOut = [AllInfoOut, Infospike{mm}];
end


Dat=nanzscore(AllSpk')';
ToDel = find(sum(isnan(Dat)'));
Dat(ToDel,:) =[];
Dat = SmoothDec(Dat,[0.1,1])
Dat= Dat(:,3:end-2);
Dat2 = SmoothDec(Dat,[0.1,3])
[val,ind] = max(Dat2')
DatSort = sortrows([ind;Dat']');
DatSort = DatSort(:,2:end);
subplot(121)
imagesc(1:316,FreqLims,DatSort)
clim([-2 2])
subplot(222)
nhist(FreqLims(ind),'binfactor',5,'noerror')
subplot(224)
AllInfoOut = [];
for mm=1:length(MiceNumber)
    AllInfoOut = [AllInfoOut, Infospike{mm}(find(IsPFCNeuron{mm}))];
end
AllInfoOut(ToDel) = [];
nhist(AllInfoOut,'binfactor',5,'noerror')



