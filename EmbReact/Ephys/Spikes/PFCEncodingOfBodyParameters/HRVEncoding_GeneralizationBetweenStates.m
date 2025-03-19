cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves
clear all
figure
load('HRVTuning_Wake_PFC.mat')
AllSpk = [];
AllPAnova= [];
AllSpkAn = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
MiceToKeep = find(ismember([490,507,508,509,510,512,514],MiceNumber));
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
for mm=1:length(MiceNumber)
    
    AllSpk=[AllSpk;(MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:))];
    AllPAnova = [AllPAnova,(PvalAnovaInfo{mm}(find(IsPFCNeuron{mm})))];
    AllSpkAn=[AllSpkAn;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
end
FreqLims = FreqLims(1:16);
AllSpk = AllSpk(:,1:16);

subplot(131)
plim = 0.05/(length(AllPAnova));
ZScSp = smooth2a(nanzscore(AllSpkAn(AllPAnova<plim,:)')',0,2);
[val,ind]= max(ZScSp');
[~,ind]= sort(ind);
ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,2)';
imagesc(FreqLims,1:length(ind),ZScSp(:,ind)')
Data_Wake = ZScSp(:,ind);
colormap parula
ylabel('# SU ordered by preferred frequency')
axis square
axis xy


load('HRVTuning_Freezing_PFC.mat')
AllSpk = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
MiceToKeep = find(ismember([490,507,508,509,510,512,514],MiceNumber));
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
for mm=1:length(MiceNumber)
    AllSpk=[AllSpk;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
end
FreqLims = FreqLims(3:16);
AllSpk = AllSpk(:,3:16);

subplot(132)
ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,2)';
imagesc(FreqLims,1:length(ind),ZScSp(:,ind)')
Data_Freezing = ZScSp(:,ind);
colormap parula
ylabel('# SU ordered by preferred frequency')
axis xy
axis square


load('HRVTuning_Sleep_PFC.mat')
AllSpk = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
MiceToKeep = find(ismember([490,507,508,509,510,512,514],MiceNumber));
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
for mm=1:length(MiceNumber)
    AllSpk=[AllSpk;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
    
end
 FreqLims = FreqLims(1:16); 
 AllSpk = AllSpk(:,1:16);
subplot(133)
ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,2)';
imagesc(FreqLims,1:length(ind),ZScSp(:,ind)')
Data_Sleep = ZScSp(:,ind);
colormap parula
ylabel('# SU ordered by preferred frequency')
axis xy
axis square

figure
subplot(2,2,1)
imagesc(FreqLims,FreqLims,corr(Data_Sleep',Data_Freezing'))
axis square
axis xy
% xlim([3 9 ]),ylim([3 9])
subplot(2,2,2)
imagesc(FreqLims,FreqLims,corr(Data_Wake',Data_Freezing')')
axis square
axis xy
% xlim([3 9 ]),ylim([3 9 ])
% hold on,plot(1:9,1:9)

subplot(2,2,3)
imagesc(FreqLims,FreqLims,corr(Data_Wake',Data_Sleep')')
axis square
axis xy
% xlim([3 9 ]),ylim([3 9 ])
% hold on,plot(1:9,1:9)


plot(diag(corr(Data_Wake',Data_Sleep')'),diag(corr(Data_Wake',Data_Wake')'))




