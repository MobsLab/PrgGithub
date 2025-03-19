% StimImpactMeanCurvesPlot
% 23.05.2018 KJ
%
% mean curves on stim - STIM IMPACT
% -> Plot
%
%   see 
%       StimImpactMeanCurves 
%

%load
clear
load(fullfile(FolderStimImpactData, 'StimImpactMeanCurves.mat'))


%params
step = 20;
max_edge = 1400;
edges = 0:step:max_edge;
smoothing=2;

channel = 1;

%% Pool data
for k=1:4
    tones.meancurve{k} = [];
    tones.semcurve{k}  = [];
    sham.meancurve{k}  = [];
    sham.semcurve{k}   = [];
    
    tones.nb(k) = 0;
    sham.nb(k) = 0;
    
    for p=1:length(curves_res.filename)
        try
            tones.meancurve{k} = [tones.meancurve{k} curves_res.tones.meancurve{p}{channel,k}(:,2) * curves_res.tones.nb_stim{p}(k)];
            tones.semcurve{k}  = [tones.semcurve{k} curves_res.tones.meancurve{p}{channel,k}(:,4) * curves_res.tones.nb_stim{p}(k)];
            tones.nb(k) = tones.nb(k) + curves_res.tones.nb_stim{p}(k); 
        end
        try
            sham.meancurve{k}  = [sham.meancurve{k} curves_res.sham.meancurve{p}{channel,k}(:,2) * curves_res.sham.nb_stim{p}(k)];
            sham.semcurve{k}  = [sham.semcurve{k} curves_res.sham.meancurve{p}{channel,k}(:,4) * curves_res.sham.nb_stim{p}(k)];
            sham.nb(k) = sham.nb(k) + curves_res.sham.nb_stim{p}(k);
        end
    end

end


%% averaging
for k=1:4
    
    %tones
    tones.x_plot{k}  = curves_res.tones.meancurve{1}{channel,k}(:,1);
    tones.y_plot{k}  = sum(tones.meancurve{k},2) / tones.nb(k);
    tones.y_shade{k} = sum(tones.semcurve{k},2) / tones.nb(k);
    
    %sham
    sham.x_plot{k}  = curves_res.sham.meancurve{1}{channel,k}(:,1);
    sham.y_plot{k}  = sum(sham.meancurve{k},2) / sham.nb(k);
    sham.y_shade{k} = sum(sham.semcurve{k},2) / sham.nb(k);
    
end

%% PLOT

figure, hold on
for k=1:4
    subplot(2,2,k),hold on

    %tones
    h(1) = plot(tones.x_plot{k}, tones.y_plot{k},'color', 'k','Linewidth', 2); hold on
%     shadedErrorBar(tones.x_plot{k}, tones.y_plot{k}, tones.y_shade{k});
    %sham
    h(2) = plot(sham.x_plot{k}, sham.y_plot{k},'color', [0.4 0.4 0.4],'Linewidth', 2); hold on
%     shadedErrorBar(sham.x_plot{k}, sham.y_plot{k}, sham.y_shade{k});
    
    
    ylim([-80 80]), xlim([-2 2]), hold on
    plot(sham.x_plot{k},zeros(length(sham.x_plot{k}),1), 'color',[0.7 0.7 0.7]), hold on
    line([0 0],get(gca,'YLim'), 'color',[0.7 0.7 0.7]), hold on
    
    legend(h, 'tones', 'sham')
    ylabel('EEG averaged on tones/sham'); xlabel('Time (ms)')
    title(['Stim ' num2str(k)])
end
suplabel('Mean curves for each stim/sham','t');


