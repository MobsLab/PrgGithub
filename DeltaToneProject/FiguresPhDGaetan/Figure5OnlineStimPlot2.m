% Figure5OnlineStimPlot2
% 11.12.2016 KJ
%
% Plot the figures from the Figure5.pdf of Gaetan PhD
% 
% 
%   see Figure5OnlineStim Figure5OnlineStimPlot1
%


clear
load([FolderProjetDelta 'Data/Figure5OnlineStim_bis.mat'])

delays = unique(cell2mat(figure5_res.delay));
all_raster = [];

for d=1:length(delays)
    for p=1:length(figure5_res.path)
        if figure5_res.delay{p}==delays(d) & strcmpi(figure5_res.manipe,'DeltaToneAll') & ~isempty(figure5_res.raster.detect.mua{p})
            if isempty(all_raster)
                all_raster = zscore(Data(figure5_res.raster.detect.mua{p}));
            else
                all_raster = [all_raster zscore(Data(figure5_res.raster.detect.mua{p}))];
            end
            raster_time = Range(figure5_res.raster.detect.mua{p}) / 1E4;
        end
    end
end
all_raster = all_raster';

%raster plot
figure, hold on
imagesc(raster_time, 1:size(all_raster,1), all_raster), hold on
axis xy, xlabel('time (sec)'), ylabel('# triggered tone'), hold on
line([0 0], ylim), hold on
set(gca,'YLim', [0 size(all_raster,1)], 'XLim', [-2 2]);
colorbar, hold on