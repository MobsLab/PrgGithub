% FigureRandomRasterPlot1
% 14.12.2016 KJ
%
% Plot data to analyse the raster plot of random tone, for one mouse
% 
% 
%   see RandomPethAnalysis RandomPethAnalysisPlot
%


clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 

m = find(strcmpi(animals,'Mouse244'));

%% Raster for each animal
figure, hold on
%raster
subplot(3,1,1), hold on
imagesc(diff.raster_time{m}/1E4, 1:size(diff.raster_matrix{m},1), diff.raster_matrix{m}), hold on
axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(diff.raster_matrix{m},1)], 'XLim', [-3 2]);
colorbar, title('LFP diff'), hold on

subplot(3,1,2), hold on
imagesc(deep.raster_time{m}/1E4, 1:size(deep.raster_matrix{m},1), deep.raster_matrix{m}), hold on
axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(deep.raster_matrix{m},1)], 'XLim', [-3 2]);
colorbar, title('LFP deep'), hold on

subplot(3,1,3), hold on
imagesc(mua.raster_time{m}/1E4, 1:size(mua.raster_matrix{m},2), mua.raster_matrix{m}), hold on
axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(mua.raster_matrix{m},2)], 'XLim', [-3 2]);
colorbar, title('Multi-Unit Activity'), hold on

suplabel(animals{m},'t'); 
