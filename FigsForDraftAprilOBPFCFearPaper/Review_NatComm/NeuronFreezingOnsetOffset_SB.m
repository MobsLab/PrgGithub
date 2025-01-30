clear all

Dir.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse248_20150326-EXT-24h-envC\20150326-EXT-24h-envC';
Dir.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse244_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{4} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse243_20150507-EXT-24h-envB\20150507-EXT-24h-envB';
Dir.path{5} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse253_20150703-EXT-24h-envC_FEAR-Mouse-253-03072015\FEAR-Mouse-253-03072015';
Dir.path{6} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse254_20150703-EXT-24h-envC\20150703-EXT-24h-envC';
Dir.path{7} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse258_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{8} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse259_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
Dir.path{9} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse299_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
Dir.path{10} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse394_FEAR-Mouse-394-EXT-24-envBraye_161020_163239_\FEAR-Mouse-394-EXT-24-envBraye_161020_163239';
Dir.path{11} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse395_FEAR-Mouse-395-EXT-24-envBraye_161020_155350_\FEAR-Mouse-395-EXT-24-envBraye_161020_155350';
Dir.path{12} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse402_FEAR-Mouse-402-EXT-24-envB_raye_161026_164106_\FEAR-Mouse-402-EXT-24-envB_raye_161026_164106';
Dir.path{13} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse403_FEAR-Mouse-403-EXT-24-envB_raye_161026_171611_\FEAR-Mouse-403-EXT-24-envB_raye_161026_171611';
Dir.path{14} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse450_FEAR-Mouse-450-EXT-24-envB_161026_174952_\FEAR-Mouse-450-EXT-24-envB_161026_174952';
Dir.path{15} ='D:\SophieToCopy\_media_DataMOBsRAIDN_ProjetAversion_DATA-Fear_Mouse451_FEAR-Mouse-451-EXT-24-envB_161026_182307_\FEAR-Mouse-451-EXT-24-envB_161026_182307';

DirB.path{1} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse291_20151204-EXT-24h-envC\20151204-EXT-24h-envC';
DirB.path{2} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse297_20151217-EXT-24h-envC\20151217-EXT-24h-envC';
DirB.path{3} ='D:\SophieToCopy\_media_DataMOBsRAID_ProjetAversion_DATA-Fear_Mouse298_20151217-EXT-24h-envC\20151217-EXT-24h-envC';

neur = 1;
for k = 1:length(Dir.path)
    cd(Dir.path{k})
    
    if exist('SpikeData.mat')>0
        clear FreezeAccEpoch Kappa mu pval S
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        S = S(numNeurons);
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
%                 load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
                load('NeuronLFPCoupling_OB4HzPaper\AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
%         load('NeuronLFPCoupling\FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','pval','Kappa','mu')
%         pval = pval.Real;
%                 Kappa = Kappa.Real;
%         mu = mu.Real;

        for num = 1:length(S)
            [StartResp(neur,:), B] = CrossCorr(Start(FreezeEpoch),Range(S{num}),20,250);
            [StopResp(neur,:), B] = CrossCorr(Stop(FreezeEpoch),Range(S{num}),20,250);
            [~,MeanNoFz(neur)] = FiringRateEpoch(S{num},TotEpoch-FreezeEpoch);
            [~,MeanFz(neur)] = FiringRateEpoch(S{num},FreezeEpoch);
            KappaNeur(neur) = Kappa{num};
            PhaseNeur(neur) = mu{num};
            PValNeur(neur) = pval{num};
            
            neur = neur+1;
        end
        
        
    end
    
end

neur = 1;
for k = 1:length(DirB.path)
    cd(DirB.path{k})
    
    if exist('SpikeData.mat')>0
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx', 'remove_MUA',1);
        load('SpikeData.mat')
        try,S = S(numNeurons);end
        clear FreezeAccEpoch
        load('behavResources.mat')
        if exist('FreezeAccEpoch')
            FreezeEpoch = FreezeAccEpoch;
        end
        TotEpoch = intervalSet(0,max(Range(Movtsd)));
        
        for num = 1:length(S)
            [StartRespB(neur,:), B] = CrossCorr(Start(FreezeEpoch),Range(S{num}),20,250);
            [StopRespB(neur,:), B] = CrossCorr(Stop(FreezeEpoch),Range(S{num}),20,250);
            [~,MeanNoFzB(neur)] = FiringRateEpoch(S{num},TotEpoch-FreezeEpoch);
            [~,MeanFzB(neur)] = FiringRateEpoch(S{num},FreezeEpoch);
            
            neur = neur+1;
        end
    end
    
end

%% Get rid of too low firing neurons

% KappaNeur(find(nanmean(StartResp')<0.1))=[];
% PValNeur(find(nanmean(StartResp')<0.1))=[];
% MeanNoFz(find(nanmean(StartResp')<0.1))=[];
% MeanFz(find(nanmean(StartResp')<0.1))=[];
% PhaseNeur(find(nanmean(StartResp')<0.1))=[];;
% MI = (MeanNoFz-MeanFz)./ (MeanNoFz+MeanFz);
% MIB = (MeanNoFzB-MeanFzB)./ (MeanNoFzB+MeanFzB);

%% Show neuron responses, try to organize with PCA
figure
DatMat = zscore([StartResp,StopResp]')';
MI = nanmean(DatMat(:,150:350)');

% DatMat(find(nanmean(StartResp')<0.1),:) = [];
[EigVect,EigVals]=PerformPCA(DatMat);
[val,ind] = sort(EigVect(:,1));
subplot(3,1,1:2)
imagesc([B;B+5000]/1E3,size(DatMat,2),DatMat(ind,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot([B;B+5000]/1E3,EigVect(:,1)'*zscore(DatMat')')
hold on
plot([B;B+5000]/1E3,EigVect(:,2)'*zscore(DatMat')')
xlim([-2.5 7.5])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')

clear DatMatCl
for neur = 1:size(DatMat,1)
    MeanNoFzNew(neur) = nanmean(DatMat(neur,1:100));
    MeanFzNew(neur) = nanmean(DatMat(neur,150:250));
    Skeletton = [ones(1,125)*MeanNoFzNew(neur),ones(1,252)*MeanFzNew(neur),ones(1,125)*MeanNoFzNew(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end
[EigVect,EigVals]=PerformPCA(zscore(DatMatCl')');
figure(2)
% DatMatCl(find(nanmean(StartResp')<0.1),:) = [];
[EigVect,EigVals]=PerformPCA(DatMatCl);
[val,ind] = sort(EigVect(:,1));
subplot(3,1,1:2)
imagesc([B;B+5000]/1E3,size(DatMatCl,2),DatMatCl(ind,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot([B;B+5000]/1E3,EigVect(:,1)'*zscore(DatMatCl')')
hold on
plot([B;B+5000]/1E3,EigVect(:,2)'*zscore(DatMatCl')')
xlim([-2.5 7.5])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')


figure
DatMatB = zscore([StartRespB,StopRespB]')';
DatMatB(find(nanmean(StartRespB')<0.1),:) = [];
MIB = nanmean(DatMatB(:,150:350)');
[EigVectB,EigValsB]=PerformPCA(DatMatB);
[val,ind] = sort(EigVectB(:,1));
subplot(3,1,1:2)
imagesc([B;B+5000]/1E3,1:size(DatMatB,1),DatMatB(:,:))
caxis([-3 3])
xlabel('Time to Fz onset(s)')
set(gca,'LineWidth',2,'FontSize',12), box off
subplot(3,1,3)
plot([B;B+5000]/1E3,EigVectB(:,1)'*zscore(DatMatB')')
hold on
plot([B;B+5000]/1E3,EigVectB(:,2)'*zscore(DatMatB')')
xlim([-2.5 7.5])
set(gca,'LineWidth',2,'FontSize',12), box off
xlabel('Time to Fz onset(s)')
legend('PC1','PC2')



% look at 3 types of response
clear DatMatCl
for neur = 1:size(DatMat,1)
    MeanNoFzNew(neur) = nanmean(DatMat(neur,1:50));
    MeanFzNew(neur) = nanmean(DatMat(neur,150:250));
    Skeletton = [ones(1,125)*MeanNoFzNew(neur),ones(1,252)*MeanFzNew(neur),ones(1,125)*MeanNoFzNew(neur)];
    DatMatCl(neur,:) =  DatMat(neur,:)-Skeletton;
end


clear DatMatClB
for neur = 1:size(DatMatB,1)
    MeanNoFzNew(neur) = nanmean(DatMatB(neur,1:100));
    MeanFzNew(neur) = nanmean(DatMatB(neur,150:250));
    Skeletton = [ones(1,125)*MeanNoFzNew(neur),ones(1,252)*MeanFzNew(neur),ones(1,125)*MeanNoFzNew(neur)];
    DatMatClB(neur,:) =  DatMatB(neur,:)-Skeletton;
end

DatMatClBZ = zscore(DatMatClB')';
ValsToSort = nanmean(DatMatClBZ(:,375:400)');
[val,ind] = sort(ValsToSort);
% imagesc(DatMatClBZ(ind,:)), caxis([-2 2])

DatMatClZ = zscore(DatMatCl')';
ValsToSort = nanmean(DatMatClZ(:,375:400)');
[val,ind] = sort(ValsToSort);
% imagesc(DatMatClZ(ind,:)), caxis([-2 2])


%%
figure
subplot(131)
hold on
ValsToSort = nanmean(DatMatClZ(:,125:175)');
[Y,X] = hist((ValsToSort),[-2.5:0.1:2.5]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
ValsToSortB = nanmean(DatMatClBZ(:,125:175)');
[Y,X] = hist((ValsToSortB),[-2.5:0.1:2.5]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum((ValsToSort),(ValsToSortB));
xlim([-2 2])
p = round(p*1000)/1000;
title('Onset')
legend('CTRL',['OBX p=' num2str(p)],'box','off')
makepretty

subplot(132)
[Y,X] = hist(abs(MI),[0:0.05:1]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
hold on
[Y,X] = hist(abs(MIB),[0:0.05:1]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum(abs(MIB),abs(MI));
p = round(p*1000)/1000;
title('Sustained')
makepretty
legend('CTRL',['OBX p=' num2str(p)],'box','off')


subplot(133)
hold on
ValsToSort = nanmean(DatMatClZ(:,375:425)');
[Y,X] = hist((ValsToSort),[-2.5:0.1:2.5]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
ValsToSortB = nanmean(DatMatClBZ(:,375:425)');
[Y,X] = hist((ValsToSortB),[-2.5:0.1:2.5]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum((ValsToSort),(ValsToSortB));
xlim([-2 2])
p = round(p*1000)/1000;
makepretty
title('Offset')
legend('CTRL',['OBX p=' num2str(p)],'box','off')

figure
subplot(131)
hold on
ValsToSort = range(DatMatClZ(:,125:175)');
[Y,X] = hist((ValsToSort),[0:0.2:10]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
ValsToSortB = range(DatMatClBZ(:,125:175)');
[Y,X] = hist((ValsToSortB),[0:0.2:10]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum((ValsToSort),(ValsToSortB));
xlim([0 10])
p = round(p*1000)/1000;
title('Onset')
ylabel('Response Size')
legend('CTRL',['OBX p=' num2str(p)],'box','off')
makepretty

subplot(132)
[Y,X] = hist((MI),[-1:0.05:1]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
hold on
[Y,X] = hist((MIB),[-1:0.05:1]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum((MIB),(MI));
p = round(p*1000)/1000;
ylabel('Fz vs NoFz MI')
title('Sustained')
makepretty
legend('CTRL',['OBX p=' num2str(p)],'box','off')


subplot(133)
hold on
ValsToSort = range(DatMatClZ(:,375:425)');
[Y,X] = hist((ValsToSort),[0:0.2:10]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[0.5 0.5 0.5])
ValsToSortB = range(DatMatClBZ(:,375:425)');
[Y,X] = hist((ValsToSortB),[0:0.2:10]);
stairs(X,Y/sum(Y),'linewidth',2,'color',[1 0.4 0.4])
[p,h] = ranksum((ValsToSort),(ValsToSortB));
xlim([0 10])
ylabel('Response Size')
p = round(p*1000)/1000;
makepretty
title('Offset')
legend('CTRL',['OBX p=' num2str(p)],'box','off')


figure
subplot(131)
hold on
ValsToSort = range(DatMatClZ(:,125:175)')/8;
ValsToSortB = range(DatMatClBZ(:,125:175)')/8;
MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSortB},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum((ValsToSort),(ValsToSortB));
sigstar({{1,2}},p)
makepretty
title('Onset')
makepretty

subplot(132)
MakeSpreadAndBoxPlot_SB({abs(MI),abs(MIB)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum(abs(MIB),abs(MI));
sigstar({{1,2}},p)
title('Sustained')
makepretty


subplot(133)
hold on
ValsToSort = range(DatMatClZ(:,375:425)')/8;
ValsToSortB = range(DatMatClBZ(:,375:425)')/8;
MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSortB},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum((ValsToSort),(ValsToSortB));
sigstar({{1,2}},p)
makepretty
title('Offset')


figure
subplot(131)
hold on
ValsToSort = nanmean(DatMatClZ(:,125:175)');
ValsToSortB = nanmean(DatMatClBZ(:,125:175)');
MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSortB},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum((ValsToSort),(ValsToSortB));
p = round(p*1000)/1000;
sigstar({{1,2}},p)
title('Onset')
makepretty

subplot(132)
MakeSpreadAndBoxPlot_SB({MI,MIB},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum((MIB),(MI));
p = round(p*1000)/1000;
sigstar({{1,2}},p)
title('Sustained')
makepretty

subplot(133)
hold on
ValsToSort = nanmean(DatMatClZ(:,375:425)');
ValsToSortB = nanmean(DatMatClBZ(:,375:425)');
MakeSpreadAndBoxPlot_SB({ValsToSort,ValsToSortB},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Ctrl','OBX'},1)
[p,h] = ranksum((ValsToSort),(ValsToSortB));
p = round(p*1000)/1000;
sigstar({{1,2}},p)
title('Offset')
makepretty


%% Does any of this correlate with MI?
OnSetResp = range(DatMatClZ(:,125:175)')/8;
OffSetResp = range(DatMatClZ(:,375:425)')/8;

subplot(2,2,1)
SigDat = DatMat([PValNeur.Transf]<0.05,:);
OffSetResp = sign(MI([PValNeur.Transf]<0.05));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
SigDat = DatMat([PValNeur.Transf]>0.05,:);
OffSetResp = sign(MI([PValNeur.Transf]>0.05));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
makepretty
xlabel('Time to Fz onset(s)')
title('Responses')
legend('Mod','NonMod')
xlim([-2.5 7.5])
ylim([-0.3 0.6])
ylabel('ZScore resp')

subplot(2,2,2)
SigDat = DatMatClZ([PValNeur.Transf]<0.05,:);
OffSetResp = sign(nanmean(SigDat(:,375:425)'));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
SigDat = DatMatClZ([PValNeur.Transf]>0.05,:);
OffSetResp = sign(nanmean(SigDat(:,375:425)'));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
makepretty
xlabel('Time to Fz onset(s)')
title('Onset/Offset responses')
legend('Mod','NonMod')
ylim([-0.4 1])
xlim([-2.5 7.5])
ylabel('ZScore resp')
figure
subplot(1,3,1)
OnSetResp = range(DatMatClZ(:,125:175)')/8;
MakeSpreadAndBoxPlot_SB({OnSetResp([PValNeur.Transf]<0.05),OnSetResp([PValNeur.Transf]>0.05)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(OnSetResp([PValNeur.Transf]<0.05),OnSetResp([PValNeur.Transf]>0.05))
sigstar({{1,2}},p)
title('Onset')
makepretty
ylabel('Response Size')


subplot(1,3,2)
MakeSpreadAndBoxPlot_SB({abs(MI([PValNeur.Transf]<0.05)),abs(MI([PValNeur.Transf]>0.05))},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(abs(MI([PValNeur.Transf]<0.05)),abs(MI([PValNeur.Transf]>0.05)))
sigstar({{1,2}},p)
title('Sustained')
makepretty
ylabel('Fz vs NoFz MI')

subplot(1,3,3)
OffSetResp = range(DatMatClZ(:,375:425)')/8;
MakeSpreadAndBoxPlot_SB({OffSetResp([PValNeur.Transf]<0.05),OffSetResp([PValNeur.Transf]>0.05)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(OffSetResp([PValNeur.Transf]<0.05),OffSetResp([PValNeur.Transf]>0.05))
sigstar({{1,2}},p)
title('Offset')
makepretty
ylabel('Response Size')

%% Resample
% Resample to get same firing rates
NoModNeur = find([PValNeur.Transf]>0.05);
ModNeur = find([PValNeur.Transf]<0.05);
FiringNoMod = (MeanFz([PValNeur.Transf]>0.05));
FiringMod = (MeanFz([PValNeur.Transf]<0.05));
clear MatchedNeuron
for fr = 1:length(FiringNoMod)
    [val,ind] = min(abs(FiringNoMod(fr)-FiringMod));
    MatchedNeuron(fr) = ind;
    FiringMod(ind) = NaN;
end

NeurToKeep = find(isnan(FiringMod));
FiringMod = (MeanFz([PValNeur.Transf]<0.05));
[p,h]=ranksum(FiringNoMod,FiringMod(MatchedNeuron))


figure
OnSetResp = range(DatMatClZ(:,125:175)');
OffSetResp = range(DatMatClZ(:,375:425)');

subplot(2,2,1)
SigDat = DatMat(ModNeur(MatchedNeuron),:);
OffSetResp = abs(sign(MI(ModNeur(MatchedNeuron))));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
SigDat = DatMat(NoModNeur,:);
OffSetResp = abs(sign(MI(NoModNeur)));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
makepretty
xlabel('Time to Fz onset(s)')
title('Responses')
legend('Mod','NonMod')
xlim([-2.5 7.5])
ylim([-0.5 1])
ylabel('ZScore resp')

subplot(2,2,2)
SigDat = DatMatClZ(ModNeur(MatchedNeuron),:);
OffSetResp = (sign(nanmean(SigDat(:,375:425)')));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
SigDat = DatMatClZ(NoModNeur,:);
OffSetResp = (sign(nanmean(SigDat(:,375:425)')));
SigDat = SigDat.*OffSetResp';
plot([B;B+5000]/1E3,smooth(nanmean(SigDat),8),'linewidth',2), hold on
makepretty
xlabel('Time to Fz onset(s)')
title('Onset/Offset responses')
legend('Mod','NonMod')
ylim([-0.4 1])
xlim([-2.5 7.5])
ylabel('ZScore resp')

subplot(2,3,4)
OnSetResp = range(DatMatClZ(:,125:175)');
MakeSpreadAndBoxPlot_SB({OnSetResp(ModNeur(MatchedNeuron)),OnSetResp(NoModNeur)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(OnSetResp(ModNeur(MatchedNeuron)),OnSetResp)
sigstar({{1,2}},p)
title('Onset')
makepretty
ylabel('Response Size')

subplot(2,3,5)
MakeSpreadAndBoxPlot_SB({MI(ModNeur(MatchedNeuron)),MI(NoModNeur)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(MI(ModNeur),MI(NoModNeur))
sigstar({{1,2}},p)
title('Sustained')
makepretty
ylabel('Fz vs NoFz MI')

subplot(2,3,6)
OffSetResp = range(DatMatClZ(:,375:425)');
MakeSpreadAndBoxPlot_SB({OffSetResp(ModNeur(MatchedNeuron)),OffSetResp(NoModNeur)},{[0.5 0.5 0.5],[1 0.4 0.4]},[1,2],{'Mod','NonMod'},1)
[p,h] = ranksum(OffSetResp(ModNeur(MatchedNeuron)),OffSetResp(NoModNeur))
sigstar({{1,2}},p)
title('Offset')
makepretty
ylabel('Response Size')



%%Link with phase
GoodPhase = [PhaseNeur([PValNeur.Transf]<0.05).Transf];
subplot(231)
OnSetResp = range(DatMatClZ(:,125:175)');
plot(OnSetResp([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'*')
title('Onset')
xlabel('Res size')
ylabel('Pref phase')
makepretty

subplot(234)
[n,xedges,yedges, binx, biny] = histcounts2(OnSetResp([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'BinWidth',0.2);
imagesc(xedges,yedges,smooth2a(n,3,3)')
axis xy
title('Onset')
xlabel('Res size')
ylabel('Pref phase')
makepretty
caxis([0 0.8])

subplot(232)
plot(MI([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'*')
title('Onset')
xlabel('Fz NoFz MI')
ylabel('Pref phase')
makepretty

subplot(235)
[n,xedges,yedges, binx, biny] = histcounts2(MI([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'BinWidth',[0.1,0.2]);
imagesc(xedges,yedges,smooth2a(n,3,3)')
axis xy
title('Onset')
xlabel('Fz NoFz MI')
ylabel('Pref phase')
makepretty
caxis([0 0.8])


subplot(233)
OffSetResp = range(DatMatClZ(:,375:425)');
plot(OffSetResp([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'*')
title('Offset')
xlabel('Resp size')
ylabel('Pref phase')
makepretty

subplot(236)
[n,xedges,yedges, binx, biny] = histcounts2(OffSetResp([PValNeur.Transf]<0.05),[PhaseNeur([PValNeur.Transf]<0.05).Transf],'BinWidth',0.2);
imagesc(xedges,yedges,smooth2a(n,3,3)')
axis xy
title('Offset')
xlabel('Res size')
ylabel('Pref phase')
makepretty
caxis([0 0.8])


DatMat = ([StartResp,StopResp]')';
% DatMat(find(nanmean(StartResp')<0.1),:) = [];
MeanNoFzNew = MeanNoFz;
% MeanNoFzNew(find(nanmean(StartResp')<0.1)) = [];
MeanFzNew = MeanFz;
% MeanFzNew(find(nanmean(StartResp')<0.1)) = [];


figure
subplot(221)
imagesc(smooth2a(corr(DatMat(NoModNeur,:)),2,2)), caxis([-0.3 0.3])
subplot(222)
imagesc(smooth2a(corr(DatMat(ModNeur(MatchedNeuron),:)),2,2)), caxis([-0.3 0.3])
subplot(224)
imagesc(smooth2a(corr(DatMat(ModNeur(MatchedNeuron),:)),2,2)-(smooth2a(corr(DatMat(NoModNeur,:)),2,2))), caxis([-0.3 0.3])


