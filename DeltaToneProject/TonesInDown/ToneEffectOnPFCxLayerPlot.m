%%ToneEffectOnPFCxLayerPlot
% 12.04.2018 KJ
%
%
% see
%   ToneEffectOnPFCxLayer
%

%load
clear

load(fullfile(FolderDeltaDataKJ,'ToneEffectOnPFCxLayer.mat'))



%% PLOT
smoothing = 0;


for p=1:length(tones_res.path)
    figure, hold on
    
    k=0;
    for i=1:size(tones_res.met_inside,2)
        if isempty(tones_res.met_inside{p,i})
            continue
        else
            k=k+1;
        end
        
    
        %MUA response to tones
        subplot(2,3,k), hold on
        y_met = Smooth(tones_res.met_inside{p,i}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(1) = plot(tones_res.met_inside{p,i}(:,1), y_met, 'b', 'linewidth', 2); hold on
        y_met = Smooth(tones_res.met_out{p,i}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(2) = plot(tones_res.met_out{p,i}(:,1), y_met, 'r', 'linewidth', 2); hold on
        y_met = Smooth(tones_res.met_shamin{p,i}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(3) = plot(tones_res.met_shamin{p,i}(:,1), y_met, 'color', [0.2 0.2 0.2], 'linewidth', 2); hold on
        line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
        legend(h, ['inside (n=' num2str(tones_res.nb_inside{p,i}) ')'], ['outside (n=' num2str(tones_res.nb_out{p,i}) ')'], ['sham in (n=' num2str(tones_res.nb_shamin{p,i}) ')']),
        title(['MUA on Tones - layer ' num2str(i)]),


        %MUA response to end of down
        subplot(2,3,k+3), hold on 
        y_met = Smooth(tones_res.met_with{p,i}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(1) = plot(tones_res.met_with{p,i}(:,1), y_met, 'b', 'linewidth', 2); hold on
        y_met = Smooth(tones_res.met_without{p,i}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(2) = plot(tones_res.met_without{p,i}(:,1), y_met, 'r', 'linewidth', 2); hold on
        line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
        legend(h, ['with (n=' num2str(tones_res.nb_with{p,i}) ')'],['without (n=' num2str(tones_res.nb_without{p,i}) ')']),
        title('MUA end of down'),
    
    end
    
    %maintitle
    suplabel([tones_res.name{p} '-' tones_res.date{p} ' (' tones_res.manipe{p} ')'], 't');

end






