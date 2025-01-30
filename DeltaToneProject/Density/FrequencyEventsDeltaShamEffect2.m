% FrequencyEventsDeltaShamEffect2
% 01.12.2016 KJ
%
% plot data about the density of delta, down, tones and
% (not-)induced/(not-)triggered tones
% 
% 
%   see FrequencyEventsDeltaShamEffect_bis FrequencyEventsDeltaShamEffect 
%


%% load
clear
eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect_bis.mat'])

%params
smoothing1 = 1;
smoothing2 = [1 0];

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
    deltas_density = Smooth(deltas.all.density{cond},smoothing1) * 1E4;
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
    
    %plot
    figure, hold on
    
    yyaxis right
    plot(x, events_density,'-','color','k'), hold on
    plot(x, success_density,'color', 'b'), hold on
    plot(x, ratio,'-','color', [0.75 0.75 0.75], 'Linewidth', 2), hold on
    ylabel([leg_events ' per sec']); set(gca,'Ylim',[0 0.5]);
    
    yyaxis left
    plot(x, deltas_density,'-','color', 'r', 'Linewidth', 2), hold on
    ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
    xlabel('session');
    legend('Delta waves', leg_events, 'success','%')
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    title([leg_events ' and delta waves density']);
    set(gca, 'XTick',1:5), hold on

    suplabel(conditions{cond},'t');
    
end




