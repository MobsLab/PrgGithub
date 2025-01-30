% FigureDeltaFrequency
% 17.12.2016 KJ
%
% plot data about the density of delta:
%   - regression
%   - tones, success tones and ratio of success
% 
%   see FrequencyEventsDeltaShamEffect2 FrequencyEventsDeltaShamEffect3 FrequencyEventsDeltaShamEffect_bis
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect_bis2.mat'])

%params
smoothing1 = 1;
smoothing2 = [1 0];

x_rec1 = [2 3 3 2];
y_rec1 = [0 0 0.8 0.8];
x_rec2 = [4 5 5 4];
y_rec2 = [0 0 0.8 0.8];

titles_plot = {'Basal','Delta triggered Tone', 'Random Tone'};

for cond=1:length(conditions)
    %data
    deltas_density = Smooth(deltas.all.density{cond},smoothing1);
    events_density = Smooth(events.all.density{cond},smoothing1) * 1E4;
    success_density = Smooth(events.success.density{cond},smoothing1) * 1E4;
    ratio = events.success.density{cond} ./ events.all.density{cond};
    ratio(isnan(ratio)) = 0;
    ratio = Smooth(ratio,smoothing1);
    x = linspace(1,6,length(deltas_density)+1);
    x = x(1:end-1);
    
    x_notone = ismember(floor(x),[1 3 5]);
    events_density(x_notone)=0;
    success_density(x_notone)=0;
    ratio(x_notone)=0;
    
    %regression
    regression_delta = [];
    for s=1:5
        x_session = x>=s & x<s+1;
        [p,S] = polyfit(x(x_session)',deltas_density(x_session),1);
        regression_delta = [regression_delta polyval(p,x(x_session))];
    end
    
    %plot
    figure, hold on
    
    plot(x, deltas_density,'-','color', 'r', 'Linewidth', 2), hold on
    if ~strcmpi(conditions{cond},'Basal')
        plot(x, events_density,'-','color','k'), hold on
        plot(x, success_density,'color', 'b'), hold on
        plot(x, ratio,'-','color', [0.75 0.75 0.75], 'Linewidth', 2), hold on
        legend('Delta waves density(normalized)', 'Tones density', 'success density','success ratio')
    else
        legend('Delta waves (normalized)')
    end
    plot(x, regression_delta,'-','color', 'k'), hold on
    
    xlabel('session');
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    
    set(gca, 'XTick',1:5,'YTick',0:0.2:0.8,'FontName','Times','fontsize',20), hold on,

    title(titles_plot{cond},'fontsize',20);
    
end




