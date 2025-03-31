% ClinicStatAfterStimPlot2
% 17.08.2017 KJ
%
% Mean curves sync on stimulation time - VIRTUAL CHANNEL DATA
% In function of the phase
% -> Plot data
%
%   see 
%       ClinicStatAfterStim ClinicStatAfterStimPlot
%


%load
clear
eval(['load ' FolderPrecomputeDreem 'ClinicStatAfterStim.mat'])

conditions = unique(quantity_res.condition);
conditions = {'sham','random'};

colori = {'k','b','k','b'};
labels_phase = {'peak', 'descending','trough','ascending'}; 
labels_auc = {'AUC 1 - Sham', 'AUC 1 - Stim', 'AUC 2 - Sham', 'AUC 2 - Stim'};
labels_amplitude = {'Amplitude 1 - Sham', 'Amplitude 1 - Stim', 'Amplitude 2 - Sham', 'Amplitude 2 - Stim'};

%% Gather Data
for cond=1:length(conditions)
    for i=1:size(phases_group,1)
        stat_stim.auc1{cond,i} = [];
        stat_stim.amplitude1{cond,i} = [];
        stat_stim.auc2{cond,i} = [];
        stat_stim.amplitude2{cond,i} = [];

        for p=1:length(quantity_res.filename)
            if strcmpi(quantity_res.condition{p},conditions{cond})
                stat_stim.auc1{cond,i} = [stat_stim.auc1{cond} ; nanmedian(quantity_res.auc1{p}(quantity_res.first.phasegroup{p}==i))];
                stat_stim.amplitude1{cond,i} = [stat_stim.amplitude1{cond} ; nanmedian(quantity_res.amplitude1{p}(quantity_res.first.phasegroup{p}==i))];
                stat_stim.auc2{cond,i} = [stat_stim.auc2{cond} ; nanmedian(quantity_res.auc2{p}(quantity_res.first.phasegroup{p}==i))];
                stat_stim.amplitude2{cond,i} = [stat_stim.amplitude2{cond} ; nanmedian(quantity_res.amplitude2{p}(quantity_res.first.phasegroup{p}==i))];
            end
        end
    end
end


%% Table
TableData = cell(0);
for i=1:length(phases_group)
    data = cell(0);
    data{end+1} = stat_stim.auc1{1,i}; data{end+1} = stat_stim.auc1{2,i};
    data{end+1} = stat_stim.auc2{1,i}; data{end+1} = stat_stim.auc2{2,i};
    
    for d=1:length(data)
        D = data{d};
        TableData{end+1,1} = labels_auc{d};
        TableData{end,2} = [labels_phase{i} ' = ' num2str(round(phases_group(i,1)*180/pi)) '° : ' num2str(round(phases_group(i,2)*180/pi)) '°'];
        TableData{end,3} = nanmedian(D);
        TableData{end,4} = nanmean(D);
        TableData{end,5} = nanstd(D)/sqrt(length(D));
    end
    
end
for i=1:length(phases_group)
    data = cell(0);
    data{end+1} = stat_stim.amplitude1{1,i}; data{end+1} = stat_stim.amplitude1{2,i};
    data{end+1} = stat_stim.amplitude2{1,i}; data{end+1} = stat_stim.amplitude2{2,i};
    
    for d=1:length(data)
        D = data{d};
        TableData{end+1,1} = labels_amplitude{d};
        TableData{end,2} = [labels_phase{i} ' = ' num2str(round(phases_group(i,1)*180/pi)) '° : ' num2str(round(phases_group(i,2)*180/pi)) '°'];
        TableData{end,3} = nanmedian(D);
        TableData{end,4} = nanmean(D);
        TableData{end,5} = nanstd(D)/sqrt(length(D));
    end
    
end

%% PLOT


figure, hold on
for i=1:length(phases_group)
    subplot(2,2,i),hold on
    
    data = cell(0);
    data{end+1} = stat_stim.auc1{1,i}; data{end+1} = stat_stim.auc1{2,i};
    data{end+1} = stat_stim.auc2{1,i}; data{end+1} = stat_stim.auc2{2,i};

    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'barcolors',colori,'columntest',[1 2;3 4],'ShowSigstar','sig','showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'XTickLabel',labels_auc, 'XTick',1:numel(labels_auc),'XTickLabelRotation', 30, 'FontName','Times','fontsize',12), hold on,

    
    title([labels_phase{i} ' = ' num2str(round(phases_group(i,1)*180/pi)) '° : ' num2str(round(phases_group(i,2)*180/pi)) '°']),
end
suplabel('AUC for different phases','t');

figure, hold on
for i=1:length(phases_group)
    subplot(2,2,i),hold on
    
    data = cell(0);
    data{end+1} = stat_stim.amplitude1{1,i}; data{end+1} = stat_stim.amplitude1{2,i};
    data{end+1} = stat_stim.amplitude2{1,i}; data{end+1} = stat_stim.amplitude2{2,i};

    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'barcolors',colori,'columntest',[1 2;3 4],'ShowSigstar','sig','showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    set(gca, 'XTickLabel',labels_amplitude, 'XTick',1:numel(labels_amplitude),'XTickLabelRotation', 30, 'FontName','Times','fontsize',12), hold on,

    
    title([labels_phase{i} ' = ' num2str(round(phases_group(i,1)*180/pi)) '° : ' num2str(round(phases_group(i,2)*180/pi)) '°']),
end
suplabel('Amplitude for different phases','t');

