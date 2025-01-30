% QuantifDensityDeltaPerSession3
% 20.11.2016 KJ
%
%   Use QuantifDensityDeltaPerSessionPlot to plot data
%
% See
%   QuantifDensityDeltaPerSession QuantifDensityDeltaPerSession2 QuantifDensityDeltaPerSessionPlot
%


%params
substages_plot = 1:5;
sessions_plot = 1:5;
delays_ind = [1 2 4 5 6];
NameSubstages = {'N1','N2', 'N3','REM','Wake'}; % Sleep substages
NameSessions = {'S1','S2','S3','S4','S5'}; %Session

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load
cd([FolderProjetDelta 'Data/']) 
clear
load QuantifDensityDeltaPerSession_bis.mat




%% Total stat, on the whole night, per sessions S1 S2 S3 S4 S5
Stat_type = {'total density','delta number','down number'};

for stp=1:length(Stat_type)
    figure, hold on
    for s=sessions_ind
        subplot(2,3,s), hold on,
        data = [];
        labels = cell(0);
        for d=1:length(delays)
            if strcmpi(Stat_type{stp},'total density')
                data = [data sum(squeeze(deltas.total.density(d,s,:,:)),1)'];
                ylab = 'deltas per sec';
            elseif strcmpi(Stat_type{stp},'delta number')
                data = [data sum(squeeze(deltas.total.nb(d,s,:,:)),1)'];
                ylab = 'number of deltas';
            elseif strcmpi(Stat_type{stp},'down number')
                data = [data sum(squeeze(downs.total.nb(d,s,:,:)),1)'];
                ylab = 'number of down';
            end
            if delays(d)==-1
                label = 'Basal';
            elseif delays(d)==0
                label = 'Random';
            else
                label = [num2str(delays(d)*1000) 'ms'];
            end
            labels{end+1} = label;
        end
        PlotErrorBarN_KJ(data,'newfig',0);
        title(['S' num2str(s)]), ylabel(ylab), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(Stat_type{stp},'t');
end







%% Delta Median Density
for ssplot=1:length(substages_plot)
    sub=substages_plot(ssplot);
    figure, hold on
    for s=sessions_ind
        subplot(2,3,s), hold on,
        data = [];
        labels = cell(0);
        for d=1:length(delays)
            data = [data squeeze(deltas.median.density(d,s,sub,:))];
            if delays(d)==-1
                label = 'Basal';
            elseif delays(d)==0
                label = 'Random';
            else
                label = [num2str(delays(d)*1000) 'ms'];
            end
            labels{end+1} = label;
        end
        PlotErrorBarN_KJ(data,'newfig',0);
        title(['S' num2str(s)]), ylabel('delta per sec'), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(['Delta (medians)- ' NameSubstages{ssplot}],'t');
end





%Delta Total Density
for ssplot=1:length(substages_plot)
    sub=substages_plot(ssplot);
    figure, hold on
    for s=sessions_ind
        subplot(2,3,s), hold on,
        data = [];
        labels = cell(0);
        for d=1:length(delays)
            data = [data squeeze(deltas.total.density(d,s,sub,:))];
            if delays(d)==-1
                label = 'Basal';
            elseif delays(d)==0
                label = 'Random';
            else
                label = [num2str(delays(d)*1000) 'ms'];
            end
            labels{end+1} = label;
        end
        PlotErrorBarN_KJ(data,'newfig',0);
        title(['S' num2str(s)]), ylabel('delta per sec'), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(['Delta - ' NameSubstages{ssplot}],'t');
    
end


%% Down Median Density
for ssplot=1:length(substages_plot)
    sub=substages_plot(ssplot);
    figure, hold on
    for s=sessions_ind
        subplot(2,3,s), hold on,
        data = [];
        labels = cell(0);
        for d=1:length(delays)
            data = [data squeeze(downs.median.density(d,s,sub,:))];
            if delays(d)==-1
                label = 'Basal';
            elseif delays(d)==0
                label = 'Random';
            else
                label = [num2str(delays(d)*1000) 'ms'];
            end
            labels{end+1} = label;
        end
        PlotErrorBarN_KJ(data,'newfig',0);
        title(['S' num2str(s)]), ylabel('down per sec'), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(['Down (medians) - ' NameSubstages{ssplot}],'t');
    
end

%Down Total Density
for ssplot=1:length(substages_plot)
    sub=substages_plot(ssplot);
    figure, hold on
    for s=sessions_ind
        subplot(2,3,s), hold on,
        data = [];
        labels = cell(0);
        for d=1:length(delays)
            data = [data squeeze(downs.total.density(d,s,sub,:))];
            if delays(d)==-1
                label = 'Basal';
            elseif delays(d)==0
                label = 'Random';
            else
                label = [num2str(delays(d)*1000) 'ms'];
            end
            labels{end+1} = label;
        end
        PlotErrorBarN_KJ(data,'newfig',0);
        title(['S' num2str(s)]), ylabel('down per sec'), hold on,
        set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30), hold on,
    end
    suplabel(['Down - ' NameSubstages{ssplot}],'t');
    
end