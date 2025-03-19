% MemoryPerformancePlot
% 06.07.2017 KJ
%
% Correlation between memory performance and delta stat
% 
% 
%   see ClinicStatSlowWaves ClinicStatSlowWavesPlot1
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'b','k','g'};
device_name = {'Dreem', 'Actiwave'};

show_sig = 'sig';
show_points = 1;
paired = 0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% format data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for p=1:length(quantity_res.filename)
    for i=1:2
        sw_induced = quantity_res.slowwaves.induced{p,i};
        
        data.number(p,i) = sum(sw_induced);
        data.auc(p,i) = nanmean(quantity_res.slowwaves.auc{p,i}(sw_induced));
        data.amplitude(p,i) = nanmean(quantity_res.slowwaves.amplitude{p,i}(sw_induced));
        data.slope(p,i) = nanmean(quantity_res.slowwaves.slope{p,i}(sw_induced));
        data.memory(p) = quantity_res.word.delta(p) * 100;
    end
end


%% for each device
for i=1:2

    %% data
    for cond=1:length(conditions)
        %selected record 
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));

        %data
        slowwaves{cond} = cell2mat(quantity_res.slowwaves.total(path_cond,i));

        auc_sw{cond} = data.auc(path_cond,i);
        amplitude_sw{cond} = data.amplitude(path_cond,i);
        slope_sw{cond} = data.slope(path_cond,i) ./ 1E4;
        memory_perf{cond} = data.memory(path_cond);
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %params
    scattersize = 25;
    x=0:0.1:70;
    
    %% Amplitude of slow waves    
    figure, hold on
    for cond=1:length(conditions)
        %correlation
        polyn_reg = polyfit(amplitude_sw{cond}, memory_perf{cond}', 1);
        [r1,p1] = corrcoef(amplitude_sw{cond}, memory_perf{cond}');
        
        subplot(2,2,cond), hold on
        scatter(memory_perf{cond},amplitude_sw{cond},scattersize,'k','filled'), hold on
        if p1<0.05
            plot(x, polyn_reg(2) + x*polyn_reg(1),'k'), hold on
        end
        text(0.1,0.95,['r = ' num2str(round(r1(1,2),2))],'Units','normalized');
        text(0.1,0.9,['p = ' num2str(round(p1(1,2),4))],'Units','normalized');
        
        xlabel('Delta word'),ylabel('Amplitude of slow waves'),
        title(conditions{cond}),
    end
    subplot(2,2,4), hold on
    [~,eb] = PlotErrorBarN_KJ(memory_perf,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    title('Memory Performance'),
    ylabel('%'),
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    suplabel(['Amplitude of Slow waves vs Memory Performance (' device_name{i} ')'],'t');
    
    
    %% Number of slow waves
    figure, hold on
    for cond=1:length(conditions)
        %correlation
        polyn_reg = polyfit(slowwaves{cond}, memory_perf{cond}', 1);
        [r1,p1] = corrcoef(slowwaves{cond}, memory_perf{cond}');
        
        subplot(2,2,cond), hold on
        scatter(memory_perf{cond},slowwaves{cond},scattersize,'k','filled'), hold on
        if p1<0.05
            plot(x, polyn_reg(2) + x*polyn_reg(1),'k'), hold on
        end
        text(0.1,0.95,['r = ' num2str(round(r1(1,2),2))],'Units','normalized');
        text(0.1,0.9,['p = ' num2str(round(p1(1,2),4))],'Units','normalized');
        
        xlabel('Delta word'),ylabel('Number of slow waves'),
        title(conditions{cond}),
    end
    subplot(2,2,4), hold on
    [~,eb] = PlotErrorBarN_KJ(memory_perf,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    title('Memory Performance'),
    ylabel('%'),
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    suplabel(['Number of Slow waves vs Memory Performance (' device_name{i} ')'],'t');
    
    
    %% AUC of slow waves
    figure, hold on
    for cond=1:length(conditions)
        %correlation
        polyn_reg = polyfit(auc_sw{cond}, memory_perf{cond}', 1);
        [r1,p1] = corrcoef(auc_sw{cond}, memory_perf{cond}');
        
        subplot(2,2,cond), hold on
        scatter(memory_perf{cond},auc_sw{cond},scattersize,'k','filled'), hold on
        if p1<0.05
            plot(x, polyn_reg(2) + x*polyn_reg(1),'k'), hold on
        end
        text(0.1,0.95,['r = ' num2str(round(r1(1,2),2))],'Units','normalized');
        text(0.1,0.9,['p = ' num2str(round(p1(1,2),4))],'Units','normalized');
        
        xlabel('Delta word'),ylabel('AUC of slow waves'),
        title(conditions{cond}),
    end
    subplot(2,2,4), hold on
    [~,eb] = PlotErrorBarN_KJ(memory_perf,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    title('Memory Performance'),
    ylabel('%'),
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    suplabel(['AUC of Slow waves vs Memory Performance (' device_name{i} ')'],'t');
        

    %% Slope of slow waves
    figure, hold on
    for cond=1:length(conditions)
        %correlation
        polyn_reg = polyfit(slope_sw{cond}, memory_perf{cond}', 1);
        [r1,p1] = corrcoef(slope_sw{cond}, memory_perf{cond}');
        
        subplot(2,2,cond), hold on
        scatter(memory_perf{cond},slope_sw{cond},scattersize,'k','filled'), hold on
        if p1<0.05
            plot(x, polyn_reg(2) + x*polyn_reg(1),'k'), hold on
        end
        text(0.1,0.95,['r = ' num2str(round(r1(1,2),2))],'Units','normalized');
        text(0.1,0.9,['p = ' num2str(round(p1(1,2),4))],'Units','normalized');
        
        xlabel('Delta word'),ylabel('Slope of slow waves'),
        title(conditions{cond}),
    end
    subplot(2,2,4), hold on
    [~,eb] = PlotErrorBarN_KJ(memory_perf,'newfig',0,'barcolors',colori,'showPoints',1,'paired',0);
    set(eb,'Linewidth',2); %bold error bar
    title('Memory Performance'),
    ylabel('%'),
    set(gca, 'XTickLabel',conditions, 'XTick',1:numel(conditions),'FontName','Times','fontsize',12), hold on,
    
    suplabel(['Slope of Slow waves vs Memory Performance (' device_name{i} ')'],'t');


end


