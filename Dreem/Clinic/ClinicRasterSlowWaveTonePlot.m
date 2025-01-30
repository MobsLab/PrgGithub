% ClinicRasterSlowWaveTonePlot
% 11.01.2017 KJ
%
% Raster plot of the EEG, synchronized on tones
% -> Plot the raster 
%
%   see 
%       ClinicRasterSlowWaveTone ClinicRasterSlowWaveToneBis
%

%load
clear
eval(['load ' FolderPrecomputeDreem 'ClinicRasterSlowWaveToneBis.mat'])

%params
Clim = {[-200 200]};
channels_to_plot = [1 2 7 10]; %FP1-M1 FP2-M2 REF_F3 REF-F4

%% Raster for each channel

figure, hold on
for i=1:length(channels_to_plot)
    subplot(2,2,i), hold on
    ch = channels_to_plot(i);
    imagesc(raster_time{ch}/1E4, 1:size(raster_matrix{ch},1), raster_matrix{ch}), hold on
    axis xy, xlabel('time (sec)'), ylabel('# tone'), hold on
    line([0 0], ylim), hold on
    set(gca,'YLim', [0 size(raster_matrix{ch},1)], 'XLim', [t_before t_after]/1E4);
    colorbar, caxis(Clim{1}), hold on
    title(labels{ch}), hold on
end



