% FigureSuccessSubstage_bis
% 10.05.2011 KJ
%
% bar plot with success rate for each substage
% - c
% 
%   see QuantifSuccessDeltaToneSubstage QuantifSuccessDeltaToneSubstage2 FigureSuccessSubstage
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
substage_success = 1:3;
sustage_occurence = 1:5; 
cond_random = find(strcmpi(manipes,'rdmtone'));


figure, hold on
%Percentage of successful
subplot(2,1,1),hold on
data = percentage_success(cond_random,substage_success);
[~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 70]);
set(eb,'Linewidth',2); %bold error bar
%title(titles_plot{cond}),
ylabel('% success'), xlim([0.5 3.5]),
set(gca, 'XTickLabel',labels(substage_success), 'XTick',1:numel(labels(substage_success)),'YTick',0:20:70,'FontName','Times','fontsize',16), hold on,

%data substage percentage
data_substage = epoch.percentage(cond_random,sustage_occurence);

%Number of tones
subplot(2,1,2),hold on
data = epoch.tones.percentage(cond_random,sustage_occurence);             
[~,eb] = PlotErrorBarN_KJ(data,'newfig',0,'ColumnTest',columntest,'barcolors',barcolors,'showPoints',0,'y_lim',[0 100]);
[~,ax] = PlotErrorLineN_KJ(data_substage, 'newfig',0,'linecolor','k');
legend(ax,{'% of substage'});
set(eb,'Linewidth',2); %bold error bar
ylabel('% occurence'), xlim([0.5 5.5]),
set(gca, 'XTickLabel',labels(sustage_occurence), 'XTick',1:numel(labels(sustage_occurence)),'FontName','Times','fontsize',16), hold on,
    











