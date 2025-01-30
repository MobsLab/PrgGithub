% FigureRasterRandomToneDelay
% 17.12.2016 KJ
%
% Raster for the random tone, sync on delta and ordered by delay
% 
%   see RandomPethAnalysisPlot
%

clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 

m=1; %Mouse 243

figure, hold on
%raster
subplot(1,2,1), hold on
imagesc(diff.raster_time{m}/1E4, 1:size(diff.raster_matrix{m},1), diff.raster_matrix{m}), hold on
axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(diff.raster_matrix{m},1)], 'XLim', [-4 4],'XTick',-4:2:4,'YTicklabel',{[]},'FontName','Times','fontsize',20), hold on,
colorbar, title('LFP diff','fontsize',20), hold on

subplot(1,2,2), hold on
imagesc(mua.raster_time{m}/1E4, 1:size(mua.raster_matrix{m},2), mua.raster_matrix{m}), hold on
axis xy, xlabel('time (sec)'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(mua.raster_matrix{m},2)], 'XLim', [-4 4],'XTick',-4:2:4,'YTicklabel',{[]},'YLim',[0 630],'FontName','Times','fontsize',20), hold on,
colorbar, title('MUA','fontsize',20), hold on

