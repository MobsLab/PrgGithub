%%AssessToneEffectNeuronsPlot2
% 16.04.2018 KJ
%
%
% see
%   AssessToneEffectNeurons AssessToneEffectNeuronsPlot
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectNeurons_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectNeurons.mat'))
end

colori = {'k', 'r', [0 0.39 0], 'm'};


%% PLOT
smoothing = 1;

for p=1:length(assess_res.path)
    figure, hold on
    
    % Tones in down
    subplot(2,3,1), hold on
    
    y_met = Smooth(assess_res.met_inside.all{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(assess_res.met_inside.all{p}(:,1), y_met, 'color', colori{1}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_inside.excited{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(assess_res.met_inside.excited{p}(:,1), y_met, 'color', colori{2}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_inside.neutral{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(assess_res.met_inside.neutral{p}(:,1), y_met, 'color', colori{3}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_inside.inhibit{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(4) = plot(assess_res.met_inside.inhibit{p}(:,1), y_met, 'color', colori{4}, 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    lgd = legend(h, neurons_pop);
    lgd.Location = 'northwest';
    title(['Tones in down (n=' num2str(assess_res.nb_inside{p}) ')']),
    y_lim = get(gca, 'ylim');
    
    
    % Tones out of down
    subplot(2,3,2), hold on
    
    y_met = Smooth(assess_res.met_out.all{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(assess_res.met_out.all{p}(:,1), y_met, 'color', colori{1}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_out.excited{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(assess_res.met_out.excited{p}(:,1), y_met, 'color', colori{2}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_out.neutral{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(assess_res.met_out.neutral{p}(:,1), y_met, 'color', colori{3}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_out.inhibit{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(4) = plot(assess_res.met_out.inhibit{p}(:,1), y_met, 'color', colori{4}, 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]); 
    title(['Tones out of down (n=' num2str(assess_res.nb_out{p}) ')']),
    
    
    % Sham in
    subplot(2,3,3), hold on
    
    y_met = Smooth(assess_res.met_shamin.all{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(assess_res.met_shamin.all{p}(:,1), y_met, 'color', colori{1}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_shamin.excited{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(assess_res.met_shamin.excited{p}(:,1), y_met, 'color', colori{2}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_shamin.neutral{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(assess_res.met_shamin.neutral{p}(:,1), y_met, 'color', colori{3}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_shamin.inhibit{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(4) = plot(assess_res.met_shamin.inhibit{p}(:,1), y_met, 'color', colori{4}, 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    title(['Sham in down (n=' num2str(assess_res.nb_shamin{p}) ')']),
    
    
    % End of down, without tone
    subplot(2,3,4), hold on
    
    y_met = Smooth(assess_res.met_without.all{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(assess_res.met_without.all{p}(:,1), y_met, 'color', colori{1}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_without.excited{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(assess_res.met_without.excited{p}(:,1), y_met, 'color', colori{2}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_without.neutral{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(assess_res.met_without.neutral{p}(:,1), y_met, 'color', colori{3}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_without.inhibit{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(4) = plot(assess_res.met_without.inhibit{p}(:,1), y_met, 'color', colori{4}, 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    title(['Down ends (no tone) (n=' num2str(assess_res.nb_without{p}) ')']),
    
    
    % End of down, with tone
    subplot(2,3,5), hold on
    
    y_met = Smooth(assess_res.met_with.all{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(1) = plot(assess_res.met_with.all{p}(:,1), y_met, 'color', colori{1}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_with.excited{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(2) = plot(assess_res.met_with.excited{p}(:,1), y_met, 'color', colori{2}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_with.neutral{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(3) = plot(assess_res.met_with.neutral{p}(:,1), y_met, 'color', colori{3}, 'linewidth', 2); hold on
    y_met = Smooth(assess_res.met_with.inhibit{p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
    h(4) = plot(assess_res.met_with.inhibit{p}(:,1), y_met, 'color', colori{4}, 'linewidth', 2); hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    title(['Down ends with tone (n=' num2str(assess_res.nb_with{p}) ')'] ),
    
    %maintitle
    suplabel(['MUA PETH for: ' assess_res.name{p} '-' assess_res.date{p} ' (' assess_res.manipe{p} ')'], 't');

end







