%%FiguresTonesInDownPerRecordRegularPlot
% 06.04.2018 KJ
%
%
%
%
% see
%   FiguresTonesInDownPerRecord FiguresTonesInDownPerRecordRegular
%   FiguresTonesInDownPerRecordPlot
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInDownPerRecordRegular.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'FiguresTonesInDownPerRecordRegular.mat'))
end



%% distrib
edges_delay = 0:20:400;
edges_norm = 0:0.05:1;

for p=1:length(figure_res.path)
    
    %tones
    [d_before.tones{p}, x_before.tones{p}] = histcounts(figure_res.tones_bef{p}/10, edges_delay, 'Normalization','probability');
    x_before.tones{p} = x_before.tones{p}(1:end-1) + diff(x_before.tones{p});
    
    [d_after.tones{p}, x_after.tones{p}] = histcounts(figure_res.tones_aft{p}/10, edges_delay, 'Normalization','probability');
    x_after.tones{p} = x_after.tones{p}(1:end-1) + diff(x_after.tones{p});
    
    norm_tones{p} = figure_res.tones_bef{p} ./ (figure_res.tones_bef{p} + figure_res.tones_aft{p});
    [d_norm.tones{p}, x_norm.tones{p}] = histcounts(norm_tones{p}, edges_norm, 'Normalization','probability');
    x_norm.tones{p} = x_norm.tones{p}(1:end-1) + diff(x_norm.tones{p});
    
    
    %sham
    [d_before.sham{p}, x_before.sham{p}] = histcounts(figure_res.sham_bef{p}/10, edges_delay, 'Normalization','probability');
    x_before.sham{p} = x_before.sham{p}(1:end-1) + diff(x_before.sham{p});
    
    [d_after.sham{p}, x_after.sham{p}] = histcounts(figure_res.sham_aft{p}/10, edges_delay, 'Normalization','probability');
    x_after.sham{p} = x_after.sham{p}(1:end-1) + diff(x_after.sham{p});
    
    norm_sham{p} = figure_res.sham_bef{p} ./ (figure_res.sham_bef{p} + figure_res.sham_aft{p});
    [d_norm.sham{p}, x_norm.sham{p}] = histcounts(norm_sham{p}, edges_norm, 'Normalization','probability');
    x_norm.sham{p} = x_norm.sham{p}(1:end-1) + diff(x_norm.sham{p});
    
    
    %ratio
    edges_ratio = -3:0.1:7;
    
    ratio_indown = abs(figure_res.tones_bef{p} ./ figure_res.tones_aft{p});
    [y_ratio.tones{p}, x_ratio.tones{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    x_ratio.tones{p}= x_ratio.tones{p}(1:end-1) + diff(x_ratio.tones{p});
    
    ratio_indown = abs(figure_res.sham_bef{p} ./ figure_res.sham_aft{p});
    [y_ratio.sham{p}, x_ratio.sham{p}] = histcounts(ratio_indown, edges_ratio,'Normalization','probability');
    x_ratio.sham{p}= x_ratio.sham{p}(1:end-1) + diff(x_ratio.sham{p});
end



%% PLOT
smoothing = 0;


for p=1:length(figure_res.path)
    figure, hold on
    
    %Distrib start-event
    subplot(2,3,1), hold on
    h(1) = plot(x_before.tones{p}, Smooth(d_before.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_before.sham{p}, Smooth(d_before.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    legend(h, 'tones', 'sham'),
    xlabel('delay (ms)'), ylabel('probability'), 
    title('Delay Start-Down vs tones/sham')
    

    %Distrib end-event
    subplot(2,3,2), hold on
    h(1) = plot(x_after.tones{p}, Smooth(d_after.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_after.sham{p}, Smooth(d_after.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    legend(h, 'tones', 'sham'),
    xlabel('delay (ms)'),
    title('Delay End-Down vs tones/sham')
    
    %Distrib occurence norm
    subplot(2,3,3), hold on
    h(1) = plot(x_norm.tones{p}, Smooth(d_norm.tones{p},smoothing),'b','linewidth',2); hold on
    h(2) = plot(x_norm.sham{p}, Smooth(d_norm.sham{p},smoothing),'color', [0.2 0.2 0.2], 'linewidth',2); hold on
    lgd = legend(h, 'tones', 'sham'); lgd.Location = 'northwest';
    xlabel('normalized time'),
    title('Occurence of tones/sham in Down (norm)')
    
    
    %MUA response to end of down
    subplot(2,3,4), hold on
    y_met = Smooth(figure_res.met_inside{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(figure_res.met_inside{p}(:,1), y_met, 'b', 'linewidth', 2); hold on
    y_met = Smooth(figure_res.met_out{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(figure_res.met_out{p}(:,1), y_met, 'r', 'linewidth', 2); hold on
    y_met = Smooth(figure_res.met_shamin{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(figure_res.met_shamin{p}(:,1), y_met, 'color', [0.2 0.2 0.2], 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    legend(h, ['inside (n=' num2str(figure_res.nb_inside{p}) ')'], ['outside (n=' num2str(figure_res.nb_out{p}) ')'], ['sham in (n=' num2str(figure_res.nb_shamin{p}) ')']),
    title('MUA on Tones'),

    
    %MUA response to tones
    subplot(2,3,5), hold on 
    y_met = Smooth(figure_res.met_with{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(figure_res.met_with{p}(:,1), y_met, 'b', 'linewidth', 2); hold on
    y_met = Smooth(figure_res.met_without{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(figure_res.met_without{p}(:,1), y_met, 'r', 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    legend(h, ['with (n=' num2str(figure_res.nb_with{p}) ')'],['without (n=' num2str(figure_res.nb_without{p}) ')']),
    title('MUA on Down ends'),
    
    
    %Distrib log-ratio
    subplot(2,3,6), hold on
    h(1) = plot(x_ratio.tones{p}, Smooth(y_ratio.tones{p},1), 'color','b', 'linewidth',2); hold on
    h(2) = plot(x_ratio.sham{p}, Smooth(y_ratio.sham{p},1), 'color',[0.2 0.2 0.2], 'linewidth',2); hold on
    line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7]);
    xlabel('log(time before/time after)'), ylabel('probability')
    legend(h, 'tones', 'sham'),
    
    
    %maintitle
    suplabel([figure_res.name{p} '-' figure_res.date{p} ' (' figure_res.manipe{p} ')'], 't');

end


