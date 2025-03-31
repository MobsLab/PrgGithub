% ProbabilitySubstageDeltaConditions2
% 21.11.2016 KJ
%
% plot the data collected from ProbabilitySubstageDeltaConditions
%
%   see ProbabilitySubstageDeltaConditions_bis  ProbabilitySubstageDeltaConditions
%



%% load
clear
eval(['load ' FolderProjetDelta 'Data/ProbabilitySubstageDeltaConditions_bis.mat'])

%params
smoothing1 = 3;
smoothing2 = [3 0];

x_rec1 = [2 3 3 2];
y_rec1 = [0 0 1.5 1.5];
x_rec2 = [4 5 5 4];
y_rec2 = [0 0 1.5 1.5];

substages_plot = 1:5;
delays_ind = [1 2 4 5 6];

NameSubstages = {'N1','N2', 'N3','REM','Wake'}; % Sleep substages
ColorSubstages = {[0.5 0.3 1], [1 0.5 1], [0.8 0 0.7], [0.1 0.7 0], [0.5 0.2 0.1]};
NameConditions = {'Sham','140ms','200ms','320ms','490ms','Random'}; %Session


%% plot
for d=delays_ind
    %legend
    if d==1
        leg_events = 'Sham';
    else
        leg_events = 'Tones';
    end
    %data
    Substage_proba = Smooth(substage.all.density{d}, smoothing2) ;
    deltas_density = Smooth(deltas.all.density{d},smoothing1) *1E4;
    events_density = Smooth(events.all.density{d},smoothing1) *1E4;
    x = linspace(1,6,size(Substage_proba,1)+1);
    x = x(1:end-1);
    
    %plot
    figure, hold on
    subplot(2,1,1), hold on
    for i=1:size(Substage_proba,2)
        plot(x,Substage_proba(:,i)','color', ColorSubstages{i}), hold on
    end
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    ylabel('%'); xlabel('session'); set(gca,'Ylim',[0 0.8]);
    legend('N1','N2', 'N3','REM','Wake')
    title('Substage Probability');
    
    subplot(2,1,2), hold on
    yyaxis right
    plot(x, events_density,'color', 'b'), hold on
    ylabel([leg_events ' per sec']); set(gca,'Ylim',[0 0.3]);
    yyaxis left
    plot(x, deltas_density,'color', 'r'), hold on
    ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
    xlabel('session');
    legend('Delta waves', leg_events)
    hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
    title([leg_events ' and delta waves density']);
    set(gca, 'XTick',1:5), hold on

    suplabel(NameConditions{d},'t');
end



