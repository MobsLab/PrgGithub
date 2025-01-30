%%AssessToneEffectNeuronsPlot
% 14.04.2018 KJ
%
%
% see
%   AssessToneEffectNeurons FiguresTonesInDownPerRecordRegularPlot
%   AssessToneEffectNeuronsPlot2
%


%load
clear
sham_distrib = 0; %sham distribution from tones distribution

if sham_distrib
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectNeurons_2.mat'))
else
    load(fullfile(FolderDeltaDataKJ,'AssessToneEffectNeurons.mat'))
end


%% PLOT
smoothing = 1;

for p=1:length(assess_res.path)
    figure, hold on
    
    for n=1:length(neurons_pop)
        npop = neurons_pop{n};
        
        %MUA response to tones/sham
        subplot(2,length(neurons_pop),n), hold on
        
        y_met = Smooth(assess_res.met_inside.(npop){p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(1) = plot(assess_res.met_inside.(npop){p}(:,1), y_met, 'b', 'linewidth', 2); hold on
        y_met = Smooth(assess_res.met_out.(npop){p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(2) = plot(assess_res.met_out.(npop){p}(:,1), y_met, 'r', 'linewidth', 2); hold on
        y_met = Smooth(assess_res.met_shamin.(npop){p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(3) = plot(assess_res.met_shamin.(npop){p}(:,1), y_met, 'color', [0.2 0.2 0.2], 'linewidth', 2); hold on
        line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
        
        if n==1
            lgd = legend(h, ['inside (n=' num2str(assess_res.nb_inside{p}) ')'], ['outside (n=' num2str(assess_res.nb_out{p}) ')'], ['sham in (n=' num2str(assess_res.nb_shamin{p}) ')']);
            lgd.Location = 'northwest';
            title(['On tones - ' npop]),
        else
            title([npop ' (n= ' num2str(assess_res.nb.(npop){p}) ',fr= ' num2str(assess_res.fr.(npop){p}) ')'  ]),
        end
        
        
        %MUA responses to Down ends
        subplot(2,length(neurons_pop),n+length(neurons_pop)), hold on
        
        y_met = Smooth(assess_res.met_with.(npop){p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(1) = plot(assess_res.met_with.(npop){p}(:,1), y_met, 'k', 'linewidth', 2); hold on
        y_met = Smooth(assess_res.met_without.(npop){p}(:,2)/(binsize_mua*1e-3), smoothing);  %in Hz
        h(2) = plot(assess_res.met_without.(npop){p}(:,1), y_met, 'color', [0.5 0.5 0.5], 'linewidth', 2); hold on
        line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
        if n==1
            lgd = legend(h, ['with (n=' num2str(assess_res.nb_with{p}) ')'],['without (n=' num2str(assess_res.nb_without{p}) ')']);
            lgd.Location = 'northwest';
            title(['On down ends - ' npop]),
        else
            title(npop),
        end
    end
    
    %maintitle
    suplabel(['MUA PETH for: ' assess_res.name{p} '-' assess_res.date{p} ' (' assess_res.manipe{p} ')'], 't');

end


