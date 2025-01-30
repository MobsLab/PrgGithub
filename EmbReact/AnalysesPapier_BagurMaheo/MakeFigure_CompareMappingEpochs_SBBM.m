function MakeFigure_CompareMappingEpochs_SBBM(LinSess1,LinSess2,CellPeak1,CellPeak2,CellOrder1,CellOrder2,SessNames)

figure
subplot(141), 
imagesc( linspace(0,1,100) , [1:size(LinSess1,1)] ,runmean([LinSess1(CellOrder1,:)]',2)')
caxis([0 .05])
colormap viridis
ylabel('HPC neurons no'), xlabel('linear UMaze distance')
vline(.2,'--r')
title(SessNames{1})
makepretty
freezeColors

subplot(142),
imagesc( linspace(0,1,100) , [1:size(LinSess2,1)] ,runmean([LinSess2(CellOrder2,:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title(SessNames{2})
makepretty
freezeColors

subplot(143),
imagesc( linspace(0,1,100) , [1:size(LinSess2,1)] ,runmean([LinSess2(CellOrder1,:)]',2)')
caxis([0 .05])
xlabel('linear UMaze distance'), yticklabels({''})
vline(.2,'--r')
title([SessNames{2} ' ordered by ' SessNames{1}])
makepretty
freezeColors
subplot(244)
PlotCorrelations_BM(CellPeak1,CellPeak2)
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel(['Place cells peak pos  ' SessNames{1}]), ylabel(['Place cells peak pos  ' SessNames{2}])

subplot(248)
imagesc(linspace(0,1,100) , linspace(0,1,100) , corr(LinSess1,LinSess2)),
caxis([-0.5 0.5]), colormap redblue
axis square
line([0 1],[0 1],'LineStyle','--','Color','r','LineWidth',2)
xlabel(['Lin Pos  ' SessNames{1}]), ylabel(['LinPos  ' SessNames{2}])
makepretty

