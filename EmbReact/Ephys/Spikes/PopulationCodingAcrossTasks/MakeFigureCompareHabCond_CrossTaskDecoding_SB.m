cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/PopulationCodingAcrossTasks 
load('AllMiceEPMUmazeHABPositions.mat')
load('AllMiceEPMUmazePositions.mat')

UMazeVals = [0:0.07:1];
EPMVals = [-1:0.1:1];
clear AllDatUMazeTrainUMazeTest AllDatEPMTrainEPMTest  AllDatEPMTrainUMazeTest AllDatUMazeTrainEPMTest
figure
clf
for mm = 1 : length(MiceNumber)
    if MiceNumber(mm)~=509
    subplot(221)
    k=1;
    scatter(AllData{k}.XEPM{mm},AllData{k}.YEPM{mm},5,AllData{k}.XYEPMProj{mm}','filled')
    hold on
    clim([-7 7])
    xlim([-1 1])
    ylim([-1 1])
    for ii=1:length(EPMVals)-1
        for iii = 1:length(EPMVals)-1
            GoodX = AllData{k}.XEPM{mm}>EPMVals(ii) & AllData{k}.XEPM{mm}<EPMVals(ii+1);
            GoodY = AllData{k}.YEPM{mm}>EPMVals(iii) & AllData{k}.YEPM{mm}<EPMVals(iii+1);
            
            AllDatEPMTrainEPMTest(mm,ii,iii) = nanmean(AllData{k}.XYEPMProj{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatEPMTrainEPMTest(mm,:,:) = AllDatEPMTrainEPMTest(mm,:,:)./nansum(nansum(squeeze(AllDatEPMTrainEPMTest(mm,:,:))));
    
    subplot(222)
    k=1;
    scatter(AllData{k}.XAlignPosUMaze{mm},AllData{k}.YAlignPosUMaze{mm},5,AllData{k}.ProjLinPosUMaze{mm}','filled')
    hold on
    clim([-7 7])
    for ii=1:length(UMazeVals)-1
        for iii = 1:length(UMazeVals)-1
            GoodX = AllData{k}.XAlignPosUMaze{mm}>UMazeVals(ii) & AllData{k}.XAlignPosUMaze{mm}<UMazeVals(ii+1);
            GoodY = AllData{k}.YAlignPosUMaze{mm}>UMazeVals(iii) & AllData{k}.YAlignPosUMaze{mm}<UMazeVals(iii+1);
            
            AllDatEPMTrainUMazeTest(mm,ii,iii) = nanmean(AllData{k}.ProjLinPosUMaze{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatEPMTrainUMazeTest(mm,:,:) = AllDatEPMTrainUMazeTest(mm,:,:)./nansum(nansum(squeeze(AllDatEPMTrainUMazeTest(mm,:,:))));
    
    subplot(223)
    k=2;
    scatter(AllData{k}.XEPM{mm},AllData{k}.YEPM{mm},5,AllData{k}.XYEPMProj{mm}','filled')
    hold on
    clim([-7 7])
    xlim([-1 1])
    ylim([-1 1])
    for ii=1:length(EPMVals)-1
        for iii = 1:length(EPMVals)-1
            GoodX = AllData{k}.XEPM{mm}>EPMVals(ii) & AllData{k}.XEPM{mm}<EPMVals(ii+1);
            GoodY = AllData{k}.YEPM{mm}>EPMVals(iii) & AllData{k}.YEPM{mm}<EPMVals(iii+1);
            
            AllDatUMazeTrainEPMTest(mm,ii,iii) = nanmean(AllData{k}.XYEPMProj{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatUMazeTrainEPMTest(mm,:,:) = AllDatUMazeTrainEPMTest(mm,:,:)./nansum(nansum(squeeze(AllDatUMazeTrainEPMTest(mm,:,:))));
    
    subplot(224)
    k=2;
    scatter(AllData{k}.XAlignPosUMaze{mm},AllData{k}.YAlignPosUMaze{mm},5,AllData{k}.ProjLinPosUMaze{mm}','filled')
    hold on
    clim([-7 7])
    for ii=1:length(UMazeVals)-1
        for iii = 1:length(UMazeVals)-1
            GoodX = AllData{k}.XAlignPosUMaze{mm}>UMazeVals(ii) & AllData{k}.XAlignPosUMaze{mm}<UMazeVals(ii+1);
            GoodY = AllData{k}.YAlignPosUMaze{mm}>UMazeVals(iii) & AllData{k}.YAlignPosUMaze{mm}<UMazeVals(iii+1);
            
            AllDatUMazeTrainUMazeTest(mm,ii,iii) = nanmean(AllData{k}.ProjLinPosUMaze{mm}(find(and(GoodX,GoodY))));
            
        end
    end
%     AllDatUMazeTrainUMazeTest(mm,:,:) = AllDatUMazeTrainUMazeTest(mm,:,:)./nansum(nansum(squeeze(AllDatUMazeTrainUMazeTest(mm,:,:))));
    end
end

clf
subplot(2,2,1)
imagesc(squeeze(nanmean(AllDatEPMTrainEPMTest,1))'), axis xy
% colormap([0,0,0,;fliplr(redblue')'])
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)
clim([-4 4])
title('Train EPM - Test EPM')

subplot(2,2,2)
imagesc(squeeze(nanmean(AllDatEPMTrainUMazeTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)
clim([-4 4])
title('Train EPM - Test UMaze')


subplot(2,2,3)
imagesc(squeeze(nanmean(AllDatUMazeTrainEPMTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)
clim([-4 4])
title('Train UMaze- Test EPM')

subplot(2,2,4)
imagesc(squeeze(nanmean(AllDatUMazeTrainUMazeTest,1))'), axis xy
colorbar
set(gca,'ycolor','w','xcolor','w','FontSize',11,'XTick',[],'YTick',[])
set(gca,'linewidth',2,'FontSize',11)
clim([-4 4])
title('Train UMaze- Test UMaze')

colormap([fliplr(redblue')'])











