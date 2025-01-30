% Figure6GeneratedDelta2
% 10.12.2016 KJ
%
% Plot data from Figure6GeneratedDelta to plot the figures from the Figure6.pdf of Gaetan PhD
% - plot Graph a
% 
%   see Figure6GeneratedDelta Figure6GeneratedDeltaPlot
%

%load
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta.mat'])

delays = unique(cell2mat(figure6_res.delay));
animals = unique(figure6_res.name);
conditions = unique(figure6_res.manipe);
%params
center = -t_before / (binsize_mua*10);


%% LFP Amplitude

for cond = 2:length(conditions)
    tone_deep = [];
    tone_sup = [];
    for p=1:length(figure6_res.path)
        try
            if ~isempty(figure6_res.tone.delta.raster.deep{p}) & strcmpi(figure6_res.manipe{p},conditions{cond})
                %deep
                raster_tsd = figure6_res.tone.delta.raster.deep{p};
                raster_matrix_deep = Data(raster_tsd);
                %sup
                raster_tsd = figure6_res.tone.delta.raster.sup{p};
                raster_matrix_sup = Data(raster_tsd);
                % time and induced
                raster_x = Range(raster_tsd);
                induce = figure6_res.tone.delta.induced{p};

                if isempty(tone_deep)
                    tone_deep = raster_matrix_deep(:,induce==1);
                    tone_sup = raster_matrix_sup(:,induce==1);
                else
                    tone_deep = [tone_deep raster_matrix_deep(:,induce==1)];
                    tone_sup = [tone_sup raster_matrix_sup(:,induce==1)];
                end
            end
        end
    end

    mean_lfp_deep{cond} = mean(tone_deep,2);
    mean_lfp_sup{cond} = mean(tone_sup,2);
    
end

%plot
figure, hold on
for cond = 1:length(conditions)
    subplot(1,2,cond), hold on
    plot(raster_x/1E4, mean_lfp_deep{cond},'k'), hold on
    plot(raster_x/1E4, mean_lfp_sup{cond},'b'), hold on
    line([0 0], ylim), hold on
    set(gca, 'XLim', [-1 1]);
    title(['Amplitude LFP - ' conditions{cond}]), hold on
end







%% Amplitude delta BAR
clear
eval(['load ' FolderProjetDelta 'Data/Figure6GeneratedDelta_bis.mat'])
conditions = unique(figure6_bis_res.manipe);

%mean amplitude for each night
for p=1:length(figure6_bis_res.path)
    amplitudes.tone.peak.deep(p) = mean(figure6_bis_res.tone.peak_deep{p});
    amplitudes.tone.peak.sup(p) = mean(figure6_bis_res.tone.peak_sup{p});
    amplitudes.endog.peak.deep(p) = mean(figure6_bis_res.endog.peak_deep{p});
    amplitudes.endog.peak.sup(p) = mean(figure6_bis_res.endog.peak_sup{p});
    
    amplitudes.tone.trough.deep(p) = mean(figure6_bis_res.tone.trough_deep{p});
    amplitudes.tone.trough.sup(p) = mean(figure6_bis_res.tone.trough_sup{p});
    amplitudes.endog.trough.deep(p) = mean(figure6_bis_res.endog.trough_deep{p});
    amplitudes.endog.trough.sup(p) = mean(figure6_bis_res.endog.trough_sup{p});
end

%create data for each conditions (Random - DeltaTone)
for cond = 1:length(conditions)
    idx_path = ismember(figure6_bis_res.manipe,conditions{cond});
    
    tone.peak.deep{cond} = amplitudes.tone.peak.deep(idx_path)';
    tone.peak.sup{cond} = amplitudes.tone.peak.sup(idx_path)';
    endog.peak.deep{cond} = amplitudes.endog.peak.deep(idx_path)';
    endog.peak.sup{cond} = amplitudes.endog.peak.sup(idx_path)';
    
    tone.trough.deep{cond} = amplitudes.tone.trough.deep(idx_path)';
    tone.trough.sup{cond} = amplitudes.tone.trough.sup(idx_path)';
    endog.trough.deep{cond} = amplitudes.endog.trough.deep(idx_path)';
    endog.trough.sup{cond} = amplitudes.endog.trough.sup(idx_path)';
end


%% plot

barcolors = {'k','b','r','m'};
show_signif_star = 'all';
column_test = [1 2 ; 3 4];
labels = {'Deep - tone', 'Deep - no tone','Sup - tone', 'Sup - no tone'};

figure, hold on
for cond = 1:length(conditions)
    
    %peak
    subplot(2,2,2*cond-1), hold on
    data_peak = [tone.peak.deep{cond} endog.peak.deep{cond} tone.peak.sup{cond} endog.peak.sup{cond}];
    
    PlotErrorBarN_KJ(data_peak, 'newfig',0,'paired',0,'barcolors',barcolors,'ShowSigstar',show_signif_star,'ColumnTest',column_test);
    ylabel('Delta waves - Peak Amplitude'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    title(conditions{cond})
    
    %trough
    subplot(2,2,2*cond), hold on
    data_trough = [tone.trough.deep{cond} endog.trough.deep{cond} tone.trough.sup{cond} endog.trough.sup{cond}];
    
    PlotErrorBarN_KJ(data_trough, 'newfig',0,'paired',0,'barcolors',barcolors,'ShowSigstar',show_signif_star,'ColumnTest',column_test);
    ylabel('Delta waves - Trough Amplitude'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    title(conditions{cond})
    
end




