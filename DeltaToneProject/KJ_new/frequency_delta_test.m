% frequency_delta_test
% 13.12.2016 KJ
%
% Quantification of the slope of delta density in the different session
% 
% 
%   see FrequencyEventsDeltaShamEffect
%

function coeff=frequency_delta_test(i)

%% load
try
    frequency_res;
    clearvars -except frequency_res nb_intervals sessions_ind i
catch
    clearvars -except i
    eval(['load ' FolderProjetDelta 'Data/FrequencyEventsDeltaShamEffect.mat'])
end

animals = unique(frequency_res.name); %Mice
conditions = unique(frequency_res.manipe); %Conditions


%params
smoothing = 1;
x_rec1 = [2 3 3 2];
y_rec1 = [0 0 1.5 1.5];
x_rec2 = [4 5 5 4];
y_rec2 = [0 0 1.5 1.5];
thresh_regression_density = 0.4;

%% data
deltas_density_raw = frequency_res.deltas.density{i} * 1E4;
deltas_density = Smooth(deltas_density_raw, smoothing);
x = linspace(1,6,length(deltas_density)+1);
x = x(1:end-1)';

%regression
regression_delta = [];
for s=1:5
    x_session = x>=s & x<s+1;
    x_regression = x_session & deltas_density>thresh_regression_density; %restrict to session, where density is high enough
    [p,~] = polyfit(x(x_regression),deltas_density(x_regression),1);
    regression_delta = [regression_delta;polyval(p,x(x_session))];
    coeff(s,1) = p(1); coeff(s,2) = p(2);
end


%% plot
figure, hold on

plot(x, deltas_density,'-','color', 'r', 'Linewidth', 2), hold on
plot(x, regression_delta,'-','color', 'k'), hold on
ylabel('deltas per sec'); set(gca,'Ylim',[0 1.5]);
xlabel('session');
legend('Delta waves','Fit')
hold on, patch(x_rec1, y_rec1, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
hold on, patch(x_rec2, y_rec2, [0.75 0.75 0.75], 'EdgeColor', 'None', 'FaceAlpha', 0.2);
title(['Delta waves density - '  frequency_res.manipe{i} ' - ' frequency_res.path{i}]);
set(gca, 'XTick',1:5), hold on


%% save fig
%title
filename_fig = ['Delta_density_' frequency_res.name{i}  '_' frequency_res.date{i}];
filename_png = [filename_fig  '.png'];
%save figure
cd([FolderFigureDelta 'IDfigures/SlopeDensityDelta/'])
saveas(gcf,filename_png,'png')
close all

end




