cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_BodyTuningCurves
clear all
figure
load('BRTuning_Wake_Explo_PFC.mat')
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
FreqLims = FreqLims(1:22);
AllSpk = AllSpk(:,1:22);
AllSpkAn = AllSpkAn(:,1:22);

plim = 0.05/(length(AllPAnova));
ZScSp = smooth2a(nanzscore(AllSpkAn(AllPAnova<plim,:)')',0,2)';

[val,ind]= max(ZScSp);
[~,ind]= sort(ind);
Data_Wake_1 = ZScSp(:,ind);

ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,2)';
Data_Wake = ZScSp(:,ind);

subplot(131)
imagesc(FreqLims,1:length(ind),ZScSp(:,ind)')
colormap parula
ylabel('# SU ordered by preferred frequency')
% axis square
% axis xy


load('BRTuning_Freezing_PFC.mat')
AllSpk = [];
AllSpkAn = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
MiceToKeep = find(ismember([490,507,508,509,510,512,514],MiceNumber));
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
for mm=1:length(MiceNumber)
    AllSpk=[AllSpk;(MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:))];
    AllSpkAn=[AllSpkAn;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
end
FreqLims = FreqLims(1:22);
AllSpk = AllSpk(:,1:22);
AllSpkAn = AllSpkAn(:,1:22);

ZScSp = smooth2a(nanzscore(AllSpkAn(AllPAnova<plim,:)')',0,3)';
Data_Freezing_1 = ZScSp(:,ind);
ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,3)';
Data_Freezing = ZScSp(:,ind);

subplot(132)
imagesc(FreqLims,1:length(ind),Data_Freezing')
colormap parula
ylabel('# SU ordered by preferred frequency')
% axis xy
% axis square

load('BRTuning_Sleep_PFC.mat')
AllSpk = [];
AllSpkAn = [];
load('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/Firing_Hab_NewRandomisation.mat')
MiceToKeep = find(ismember([490,507,508,509,510,512,514],MiceNumber));
IsPFCNeuron = IsPFCNeuron(MiceToKeep);
for mm=1:length(MiceNumber)
    AllSpk=[AllSpk;(MeanSpk_Half{mm}(find(IsPFCNeuron{mm}),:))];
    AllSpkAn=[AllSpkAn;(MeanSpk_HalfAn{mm}(find(IsPFCNeuron{mm}),:))];
end
FreqLims = FreqLims(1:22);
AllSpk = AllSpk(:,1:22);
AllSpkAn = AllSpkAn(:,1:22);

ZScSp = smooth2a(nanzscore(AllSpkAn(AllPAnova<plim,:)')',0,3)';
Data_Sleep_1 = ZScSp(:,ind);

ZScSp = smooth2a(nanzscore(AllSpk(AllPAnova<plim,:)')',0,3)';
Data_Sleep = ZScSp(:,ind);

subplot(133)
imagesc(FreqLims,1:length(ind),Data_Sleep')
colormap parula
ylabel('# SU ordered by preferred frequency')
axis xy
axis square

figure
subplot(131)
errorbar(FreqLims,nanmean(Data_Wake(:,1:40)'),stdError(Data_Wake(:,1:40)'))
hold on
errorbar(FreqLims,nanmean(Data_Wake(:,end-40:end)'),stdError(Data_Wake(:,end-40:end)'))
title('Exploration')
legend('Low tuned (explo)','High tuned (explo)')
makepretty
ylim([-1.5 1.5])
axis square
xlabel('Breathing rate (Hz)')
subplot(132)
errorbar(FreqLims,nanmean(Data_Freezing(:,1:40)'),stdError(Data_Freezing(:,1:40)'))
hold on
errorbar(FreqLims,nanmean(Data_Freezing(:,end-40:end)'),stdError(Data_Freezing(:,end-40:end)'))
title('Freezing')
makepretty
ylim([-0.7 0.7])
axis square
xlabel('Breathing rate (Hz)')
subplot(133)
errorbar(FreqLims,nanmean(Data_Sleep(:,1:40)'),stdError(Data_Sleep(:,1:40)'))
hold on
errorbar(FreqLims,nanmean(Data_Sleep(:,end-40:end)'),stdError(Data_Sleep(:,end-40:end)'))
xlabel('Breathing rate (Hz)')
title('Sleep')
makepretty
ylim([-0.7 0.7])
axis square

figure
subplot(2,2,1)
imagesc(FreqLims,FreqLims,corr(Data_Wake_1',Data_Freezing_1')')
axis square
axis xy
xlim([3 8 ]),ylim([3 8])
hold on,plot(1:9,1:9)
caxis([-0.5 0.5])
title('Active vs Freeze')

subplot(2,2,2)
imagesc(FreqLims,FreqLims,corr(Data_Wake',Data_Sleep')')
axis square
axis xy
xlim([3 8 ]),ylim([3 8])
hold on,plot(1:9,1:9)
caxis([-0.5 0.5])
title('Active vs Sleep')

subplot(2,3,4)
imagesc(FreqLims,FreqLims,corr(Data_Sleep',Data_Sleep_1'))
axis square
axis xy
xlim([3 8 ]),ylim([3 8])
hold on,plot(1:9,1:9)
caxis([-1 1])
title('Sleep vs Sleep')

subplot(2,3,5)
imagesc(FreqLims,FreqLims,corr(Data_Wake',Data_Wake_1')')
axis square
axis xy
xlim([3 8 ]),ylim([3 8])
hold on,plot(1:9,1:9)
caxis([-1 1])
title('Wake vs Wake')

subplot(2,3,6)
imagesc(FreqLims,FreqLims,corr(Data_Freezing',Data_Freezing_1')')
axis square
axis xy
xlim([3 8 ]),ylim([3 8])
hold on,plot(1:9,1:9)
caxis([-1 1])
title('Fz vs Fz')

clear A
for perm = 1:100
    PermNeur = randi(size(Data_Wake,2),1,size(Data_Wake,2));
    DW_W = diag(corr(Data_Wake(:,PermNeur)',Data_Wake_1(:,PermNeur)')');
    
    DF_F = diag(corr(Data_Freezing(:,PermNeur)',Data_Freezing_1(:,PermNeur)')');
    DF_W = diag(corr(Data_Freezing(:,PermNeur)',Data_Wake(:,PermNeur)')');
    
    DS_S = diag(corr(Data_Sleep_1(:,PermNeur)',Data_Sleep(:,PermNeur)')');
    DS_W = diag(corr(Data_Sleep(:,PermNeur)',Data_Wake(:,PermNeur)')');
    
    % Randomize cell order
    shuf_cel = randperm(size(Data_Wake,2));
    DF_W_sh = diag(corr(Data_Freezing(:,PermNeur(shuf_cel))',Data_Wake(:,PermNeur)')');
    DS_W_sh = diag(corr(Data_Sleep(:,PermNeur(shuf_cel))',Data_Wake(:,PermNeur)')');

    A{1}(perm) = nanmean(DF_W_sh./(sqrt(abs(DF_F).*abs(DW_W))));
    A{2}(perm) = nanmean(DF_W./(sqrt(abs(DF_F).*abs(DW_W))));
%     A{3}(perm) = nanmean(DS_W_sh./(sqrt(abs(DS_S).*abs(DW_W))));
    A{3}(perm) = nanmean(DS_W./(sqrt(abs(DS_S).*abs(DW_W))));
end


figure
MakeSpreadAndBoxPlot_BM(A,{},[1,2,3],{'Shuf','ActvsFz','ActvsSlp'},10)
ylabel('Reproducibility')
 

 
 
 


