% FigureSuccessSubstage
% 17.12.2016 KJ
%
% bar plot with success rate for each substage
% - c
% 
%   see QuantifSuccessDeltaToneSubstage QuantifSuccessDeltaToneSubstage2 FigureSuccessSubstage_bis
%



%% load
cd([FolderProjetDelta 'Data/'])
clear
load QuantifSuccessDeltaToneSubstage.mat

%% Gather data
manipes = unique(deltatone_res.manipe);

%data
for cond=1:length(manipes)
    for sub=substages_ind
        delta_success = [];
        delta_failed = [];
        epoch_duration = [];

        for p=1:length(deltatone_res.path)
            if strcmpi(deltatone_res.manipe{p},manipes{cond})
                if isempty(delta_success)
                    delta_success = deltatone_res.gooddelta_substage{p,sub};
                    delta_failed = deltatone_res.baddelta_substage{p,sub};
                    epoch_duration = deltatone_res.epoch_duration{p,sub};
                    epoch_percentage = 100 * deltatone_res.epoch_duration{p,sub} / sum(cell2mat(deltatone_res.epoch_duration(p,1:5)));
                else
                    delta_success = [delta_success deltatone_res.gooddelta_substage{p,sub}];
                    delta_failed = [delta_failed deltatone_res.baddelta_substage{p,sub}];
                    epoch_duration = [epoch_duration deltatone_res.epoch_duration{p,sub}];
                    epoch_percentage = [epoch_percentage 100*deltatone_res.epoch_duration{p,sub} / sum(cell2mat(deltatone_res.epoch_duration(p,1:5)))];
                end
            end
        end

        deltas.success.nb{cond,sub} = delta_success;
        deltas.success.density{cond,sub} = (delta_success ./ epoch_duration) * 1E4;
        deltas.fail.nb{cond,sub} = delta_failed;
        deltas.fail.density{cond,sub} = (delta_failed ./ epoch_duration) *1E4;

        epoch.tones.nb{cond,sub} = delta_success + delta_failed;
        epoch.tones.density{cond,sub} = ((delta_success + delta_failed) ./ epoch_duration) * 1E4;
        epoch.duration{cond,sub} = epoch_duration;
        epoch.percentage{cond,sub} = epoch_percentage;
            
        percentage_success{cond,sub} = (delta_success ./ (delta_success + delta_failed)) * 100;
    end
end

%total number of tones, per conditions (for each night)
for cond=1:length(manipes)
    nb_total_tones{cond} = [];
    for sub=1:5
        if isempty(nb_total_tones{cond})
            nb_total_tones{cond} = epoch.tones.nb{cond,sub};
        else
            nb_total_tones{cond} = nb_total_tones{cond} + epoch.tones.nb{cond,sub};
        end
    end
end
%percentage of tones per substages, per conditions (for each night)
for cond=1:length(manipes)
    for sub=substages_ind
        epoch.tones.percentage{cond,sub} = 100 * epoch.tones.nb{cond,sub} ./ nb_total_tones{cond};
    end
end


%% Plot

labels={'N1','N2','N3','REM','WAKE','NREM'};
titles_plot = {'Delta triggered Tone', 'Random Tone'};
barcolors = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1], 'r'}; %substage color
columntest=[1 2;2 3];
substage_nrem = 1:3;

% figure, hold on
% for cond=1:length(manipes)
%     %Substage percentage
%     subplot(2,2,cond),hold on
%     data = epoch.percentage(cond,:);             
%     [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 100]);
%     set(eb,'Linewidth',2); %bold error bar
%     ylabel('Percentage of Substage'),
%     set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',12), hold on,
%     
%     %Number of tones
%     subplot(2,2,cond+2),hold on
%     data = epoch.tones.nb(cond,:);             
%     [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 2000]);
%     set(eb,'Linewidth',2); %bold error bar
%     ylabel('Number of tones per night'),
%     set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',12), hold on,
%     
% end


figure, hold on
for cond=1:length(manipes)
    %Percentage of successful
    subplot(2,2,cond),hold on
    data = percentage_success(cond,substage_nrem);            
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 70]);
    set(eb,'Linewidth',2); %bold error bar
    %title(titles_plot{cond}),
    ylabel('Percentage of tone evoking Delta'),
    set(gca, 'XTickLabel',labels(substage_nrem), 'XTick',1:numel(labels(substage_nrem)),'YTick',0:20:70,'FontName','Times','fontsize',18), hold on,
    
    %data substage percentage
    data_substage = epoch.percentage(cond,:);
    
    %Number of tones
    subplot(2,2,cond+2),hold on
    data = epoch.tones.percentage(cond,:);             
    [~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 100]);
%     [~,ax] = PlotErrorLineN_KJ(data_substage, 'newfig',0,'linecolor','k');
%     legend(ax,{'% of substage'});
    set(eb,'Linewidth',2); %bold error bar
    ylabel('%'),
    set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',18), hold on,
    
end






% %Tones density
% figure, hold on
% for cond=1:length(manipes)
%     subplot(1,2,cond),hold on
%     data = epoch.tones.density(cond,:);             
%     PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 0.11]);
%     title(titles_plot{cond})
%     set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels),'FontName','Times','fontsize',20), hold on,
% end
% suplabel('Tones density','t');










