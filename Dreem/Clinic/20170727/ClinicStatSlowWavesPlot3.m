% ClinicStatSlowWavesPlot3
% 12.07.2017 KJ
%
% Delta Stat - only delta after tones or sham
% Analyse Memory, auc, slope ...
% 
%   see ClinicStatSlowWaves ClinicStatSlowWavesPlot1 ClinicStatSlowWavesPlot2
%


clear

%% load
load([FolderPrecomputeDreem 'ClinicStatSlowWaves.mat']) 
conditions = {'sham','upphase','random'};
subjects = unique(cell2mat(quantity_res.subject));

%params
colori = {'b','k','g'};
scattersize = 25;
show_sig = 'sig';
stat_type = 'Spearman'; %'Pearson'


%% format data
for p=1:length(quantity_res.filename)
    sw_induced = quantity_res.slowwaves.induced{p};

    data.number(p) = quantity_res.slowwaves.total{p};
    data.success(p) = sum(sw_induced);
    data.auc(p) = nanmean(quantity_res.slowwaves.auc{p}(sw_induced));
    data.amplitude(p) = nanmean(quantity_res.slowwaves.amplitude{p}(sw_induced));
    data.slope(p) = nanmean(quantity_res.slowwaves.slope{p}(sw_induced)) ./ 1E4;
    data.word(p) = quantity_res.word.delta(p);
    
end




%% STAT and PLOT
data_var = {'number','success','auc','amplitude','slope'};
ylabels = {'Number of Slow Waves', 'Number of Success tones', 'AUC of evoked', 'Amplitude of evoked', 'Slope of evoked'}; 


for d=1:length(data_var)
    clear data_x data_y
    
    %conditions
    for cond=1:length(conditions)
        %selected record 
        path_cond = find(strcmpi(quantity_res.condition,conditions{cond}));
        
        data_x{cond} = data.word(path_cond);
        data_y{cond} = data.(data_var{d})(path_cond);
    end
    
    %stat
    if ~strcmpi(stat_type,'none')
        x_points = [];
        y_points = [];
        for cond=1:length(data_y)
            x_points = [x_points data_x{cond}];
            y_points = [y_points data_y{cond}];
        end
        [r1,p1]=corr(x_points',y_points','type',stat_type);
        curve_fit= polyfit(x_points,y_points,1);
    end
    
    
    %Plot
    figure, hold on
    for cond=1:length(conditions)
        scatter(data_x{cond},data_y{cond},scattersize,colori{cond},'filled'), hold on
    end
    legend(conditions), hold on
    xlabel('delta words'),ylabel(ylabels{d}),
    title(['memory vs ' ylabels{d}]), hold on

    %correlation
    if p1<0.05
        line([min(x_points),max(x_points)],curve_fit(2)+[min(x_points),max(x_points)]*curve_fit(1),'Color','k','Linewidth',1), hold on
    end
    text(0.05,0.95,['r = ' num2str(round(r1,2))],'Units','normalized');
    text(0.05,0.9,['p = ' num2str(round(p1,4))],'Units','normalized');
    
end





    










