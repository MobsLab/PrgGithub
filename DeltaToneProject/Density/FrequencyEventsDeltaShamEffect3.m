% FrequencyEventsDeltaShamEffect3
% 01.12.2016 KJ
%
% plot data about the density of delta, down, tones and
% (not-)induced/(not-)triggered tones
% 
% 
%   see FrequencyEventsDeltaShamEffect_bis FrequencyEventsDeltaShamEffect2 
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect_bis.mat'])

%params
smoothing = 3;

x_rec1 = [2 3 3 2];
y_rec1 = [0 0 1.5 1.5];
x_rec2 = [4 5 5 4];
y_rec2 = [0 0 1.5 1.5];


for cond=1:length(conditions)
    %legend
    if strcmpi(conditions{cond},'Basal')
        leg_events = 'Sham';
    else
        leg_events = 'Tones';
    end
    %data
    deltas_density = Smooth(deltas.all.density{cond},smoothing) * 1E4;
    x = linspace(1,6,length(deltas_density)+1);
    x = x(1:end-1)';
    
    regression_delta = [];
    for s=1:5
        x_session = x>=s & x<s+1;
        [p,S] = polyfit(x(x_session),deltas_density(x_session),1);
        regression_delta = [regression_delta;polyval(p,x(x_session))];
    end
    %plot
    figure, hold on
    
    plot(x, deltas_density,'-','color', 'r', 'Linewidth', 2), hold on
    plot(x, regression_delta,'-','color', 'k'), hold on
    ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
    xlabel('session');
    legend('Delta waves','Fit')
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    title(['Delta waves density']);
    set(gca, 'XTick',1:5), hold on

    suplabel(conditions{cond},'t');
    
end
