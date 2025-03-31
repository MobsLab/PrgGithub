clear all
JustLowFreq = 1;
MiceNumber=[490,507,508,509,510,512,514];

load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis
Fz = load('PFCUnitFiringOnOBFrequency.mat');
FreqLimsFz=[2.5:0.15:6];
%% Just the sig units
GoodNeur = [];
PNeur = [];
RNeur = [];

for mm=1:length(MiceNumber)
    for sp=1:length(Fz.RSpk{mm})
        if IsPFCNeuron{mm}(sp)==1
            
            if Fz.RSpk{mm}(sp)>prctile(Fz.RSpk_btstrp{mm}(sp,:),97.5)
                GoodNeur = [GoodNeur,1];
            elseif Fz.RSpk{mm}(sp)<prctile(Fz.RSpk_btstrp{mm}(sp,:),2.5);
                GoodNeur = [GoodNeur,-1];
            else
                GoodNeur = [GoodNeur,0];
            end
            PNeur = [PNeur,Fz.PSpk{mm}(sp)];
            RNeur = [RNeur,Fz.RSpk{mm}(sp)];
            
        end
    end
end

% for mm=1:8
% a = nanzscore((Fz.MeanSpk{mm}(find(IsPFCNeuron{mm}),:))')';
% b = nanzscore((MeanSpk{mm}(find(IsPFCNeuron{mm}),5:27))')';
% >> imagesc(corr(a,b))
% >> clim([-0.4 0.4])
% 
% pause
% end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFC_Neurons_TwoTypesOfFreezing
%load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreq.mat')
load('PFCUnitFiringOnOBFrequencyAllSessSpeedCorrBroadFreqNoSleep.mat')
% load('PFCUnitFiringOnOBFrequencyAllSessBroadFreq.mat')
%  load('PFCUnitFiringOnOBFrequencyAllSessBroadFreqNoSleep.mat')
% load('PFCUnitFiringOnOBFrequencyAllSessBroadFreqSubSample.mat')
%  load('PFCUnitFiringOnOBFrequencyAllSessBroadFreqNoSleepSubSample.mat')
% 

if size(MeanSpk{1},2) == 60
    FreqLims=[2:0.15:11];
else
    FreqLims=[2:0.25:11];
end



AllSpk=[];
AllSpkFz=[];
RFz=[];
RNoFz=[];
for mm=1:length(MiceNumber)
    AllSpkFz =[AllSpkFz;(Fz.MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
    RFz=[RFz;(Fz.RSpk{mm}(find(IsPFCNeuron{mm})))'];
    RNoFz=[RNoFz;(RSpk{mm}(find(IsPFCNeuron{mm})))'];
    AllSpk =[AllSpk;(MeanSpk{mm}(find(IsPFCNeuron{mm}),:))];
end
DelUnit = unique([find(sum(isnan((nanzscore(AllSpk(:,4:23)'))))),find(sum(isnan((nanzscore(AllSpkFz')))))]);
AllSpkFz(DelUnit,:) = [];
AllSpk(DelUnit,:) = [];
RFz(DelUnit) = [];
RNoFz(DelUnit) = [];
GoodNeur(DelUnit) = [];

if JustLowFreq
    AllSpk = AllSpk(:,4:27);
    FreqLims = FreqLims(:,4:28);
end

Dat=nanzscore(AllSpk(abs(GoodNeur)>0,:)')';
[EigVect,EigVals]=PerformPCA(Dat);
figure(2)
clf
for k=1:3
    subplot(4,3,k)
    ToPlot=EigVect(:,k)'*Dat;
    plot(FreqLims(1:end-1),ToPlot), hold on
    ylabel(['Comp' num2str(k)])
    title(num2str(round(100*EigVals(k)/sum(EigVals))))
    xlabel('OB freq')
    subplot(4,3,k+3)
    tempmat=sortrows([EigVect(:,k),Dat]);
    imagesc(FreqLims(1:end-1),1:size(tempmat,1),(tempmat(:,2:end)))
    clim([-3 3])
    title('ordered firing mat')
    xlabel('OB freq'), ylabel('Neuron number')
    subplot(4,3,k+6)
    tempmat=sortrows([EigVect(:,k),SmoothDec(nanzscore(AllSpkFz(abs(GoodNeur)>0,:)')',[1 1])]);
    imagesc(FreqLimsFz(1:end-1),1:size(tempmat,1),(tempmat(:,2:end)))
    clim([-2 2])
    xlabel('OB freq'), ylabel('Neuron number')
    
    
    subplot(4,3,k+9)
    imagesc(corr(tempmat(:,2:end)')),clim([-1 1]),clim([-1 1]);
    title('corr mat')
    xlabel('Neuron number'), ylabel('Neuron number')
end

figure(1)
clf
plot(RFz,RNoFz,'.','MarkerSize',20)
hold on
plot(RFz(abs(GoodNeur)>0),RNoFz(abs(GoodNeur)>0),'.','MarkerSize',20)
[R,P]=corrcoef(RFz(abs(GoodNeur)>0),RNoFz(abs(GoodNeur)>0));
xlabel('R - All data')
ylabel('R - Fz only')
title(['Corr: R=' num2str(R(1,2)) ' P=' num2str(P(1,2))])
set(gca,'LineWidth',2,'FontSize',15), box off

cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/PFCUnitsOBFrequency/CompFzvsAllData

figure
subplot(231)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpk(:,4:23)')',nanzscore(AllSpk(:,4:23)')'))
colormap redblue
clim([-1 1])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
colorbar
axis square
title('All Data')

subplot(234)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpk(find(abs(GoodNeur)>0),4:23)')',nanzscore(AllSpk(find(abs(GoodNeur)>0),4:23)')'))
colormap redblue
clim([-1 1])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
axis square
colorbar
title('All Data')

subplot(232)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpkFz')',nanzscore(AllSpkFz')'))
colormap redblue
clim([-1 1])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
colorbar
axis square
title('Just freezing')

subplot(235)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpkFz(find(abs(GoodNeur)>0),:)')',nanzscore(AllSpkFz(find(abs(GoodNeur)>0),:)')'))
colormap redblue
clim([-1 1])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
axis square
colorbar
title('Just freezing')

subplot(233)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpk(:,4:23)')',nanzscore(AllSpkFz')'))
colormap redblue
clim([-0.15 0.15])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
colorbar
axis square
title('All data vs just freezing')

subplot(236)
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),corr(nanzscore(AllSpk(find(abs(GoodNeur)>0),4:23)')',nanzscore(AllSpkFz(find(abs(GoodNeur)>0),:)')'))
colormap redblue
clim([-0.2 0.2])
set(gca,'LineWidth',2,'FontSize',15), box off
xlabel('OB Frequency - All Data')
ylabel('OB Frequency - All Data')
axis square
colorbar
title('All data vs just freezing')


figure
imagesc(FreqLims(1:end-1),FreqLims(1:end-1),SmoothDec(corr(nanzscore(AllSpk(:,4:23)')',nanzscore(AllSpkFz')'),[0.5 0.5]))

A = nanzscore(AllSpk(:,4:23)')';
B= nanzscore(AllSpkFz')';
OutFz = nanmean(A(:,1:find(FreqLims>3,1,'first'))') - nanmean(A(:,find(FreqLims>4,1,'first')+1:end)');
InFz = nanmean(B(:,1:find(FreqLims>3,1,'first'))') - nanmean(B(:,find(FreqLims>4,1,'first')+1:end)');
[R,P] = corrcoef(OutFz,InFz)

