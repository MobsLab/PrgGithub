% RandomPethAnalysisPlot
% 07.12.2016 KJ
%
% Plot data to analyse the raster plot of random tone
% 
% 
%   see RandomPethAnalysis RandomPethAnalysis_bis RandomPethAnalysis2
%

clear
load([FolderProjetDelta 'Data/RandomPethAnalysis_bis.mat']) 


%% Raster for each animal
for m=1:length(animals)
    figure, hold on
    %raster
    subplot(1,3,1), hold on
    imagesc(diff.raster_time{m}/1E4, 1:size(diff.raster_matrix{m},1), diff.raster_matrix{m}), hold on
    axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
    line([0 0], ylim), hold on
    set(gca,'YLim', [0 size(diff.raster_matrix{m},1)], 'XLim', [-4 4]);
    colorbar, title([animals{m} 'LFP diff']), hold on
    
    subplot(1,3,2), hold on
    imagesc(deep.raster_time{m}/1E4, 1:size(deep.raster_matrix{m},1), deep.raster_matrix{m}), hold on
    axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
    line([0 0], ylim), hold on
    set(gca,'YLim', [0 size(deep.raster_matrix{m},1)], 'XLim', [-4 4]);
    colorbar, title('LFP deep'), hold on
    
    subplot(1,3,3), hold on
    imagesc(mua.raster_time{m}/1E4, 1:size(mua.raster_matrix{m},2), mua.raster_matrix{m}), hold on
    axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
    line([0 0], ylim), hold on
    set(gca,'YLim', [0 size(mua.raster_matrix{m},2)], 'XLim', [-4 4]);
    colorbar, title('MUA'), hold on
end







