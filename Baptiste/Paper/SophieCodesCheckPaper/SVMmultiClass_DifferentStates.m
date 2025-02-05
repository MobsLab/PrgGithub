
clear all
% Load the UMaze mice
load('/media/nas7/ProjetEmbReact/DataEmbReact/DataForSVM_AllStates_SB.mat');
% SoundContext = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_SoundTest.mat');

CatData = [];
DATA2  = rmfield(DATA2,'ActiveWake');
AllEpoch = fieldnames(DATA2);
EpType = [];
for ep = 1:length(AllEpoch)
    CatData = cat(2,CatData,DATA2.(AllEpoch{ep}));
    EpType =  [EpType,ones(1,size(DATA2.(AllEpoch{ep}),2))*ep];
end

DatMat = (zscore(CatData(:,find(sum(isnan(CatData))==0))')');
% NO HPC
% DatMat = DatMat(1:5,:);
[EigVect,EigVals]=PerformPCA(DatMat);


figure
subplot(121)
EpType_Red = EpType(find(sum(isnan(CatData))==0));
cols = lines(ep);
for ep = 1:length(AllEpoch)
    plot(nanmean(EigVect(:,1)'*DatMat(:,EpType_Red==ep)),nanmean(EigVect(:,2)'*DatMat(:,EpType_Red==ep)),'.','MarkerSize',50,'color',cols(ep,:))
end

for ep = 1:length(AllEpoch)
    plot(EigVect(:,1)'*DatMat(:,EpType_Red==ep),EigVect(:,2)'*DatMat(:,EpType_Red==ep),'.','MarkerSize',10,'color',cols(ep,:))
    
end
legend(AllEpoch)    
subplot(122)
EpType_Red = EpType(find(sum(isnan(CatData))==0));
cols = lines(ep);
for ep = 1:length(AllEpoch)
    plot(EigVect(:,3)'*DatMat(:,EpType_Red==ep),EigVect(:,4)'*DatMat(:,EpType_Red==ep),'.','MarkerSize',10,'color',cols(ep,:))
    hold on
    plot(nanmean(EigVect(:,3)'*DatMat(:,EpType_Red==ep)),nanmean(EigVect(:,4)'*DatMat(:,EpType_Red==ep)),'.','MarkerSize',50,'color',cols(ep,:))
    
end

%% SVM multiclass

Mdl = fitcecoc(DatMat',EpType_Red);
OutPut = predict(Mdl,DatMat');


for ep = 1:length(AllEpoch)
    for ep2 = 1:length(AllEpoch)
        ConfMat(ep,ep2) = nansum(OutPut==ep & EpType_Red'==ep2) /  nansum(EpType_Red==ep2);
    end
end
figure

imagesc(1:4,1:4,ConfMat)
set(gca,'XTick',[1:4],'YTick',[1:4],'fontsize',20,'XTickLabels',AllEpoch,'YTickLabels',AllEpoch)
for i = 1:4
    for j = 1:4
        text(i,j,num2str(ConfMat(i,j),2),'FontSize',10)
    end
end
colorbar
caxis([0 1])
xtickangle(45)
axis square


