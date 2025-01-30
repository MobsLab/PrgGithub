% FigureRefractoryPeriod2
% 15.02.2017 KJ
%
% Plot the rate success for random tone relative to the delay between the
% tone and the preceeding delta/down
% 
% 
%   see QuantifRefractoryPeriod QuantifRefractoryPeriod_bis FigureRefractoryPeriod
%


clear
load([FolderProjetDelta 'Data/QuantifRefractoryPeriod_bis.mat']) 

%params
scattersize=25;
colori = {[0.5 0.3 1]; [1 0.5 1]; [0.8 0 0.7]; [0.1 0.7 0]; [0.5 0.2 0.1];'k';'b';'r';'g'};
NameSubstages = {'N1';'N2';'N3';'REM';'Wake'};
max_delay = 7000;
step = 500;

delays_bars = 0:step:max_delay; 
delays_intv = delays_bars(1:end-1) + step/2;


%% percentile
labels = cell(0);
for i=1:length(delays_intv)
    labels{end+1} = num2str(round(delays_intv(i)/10));
end

%% For each animal
for m=1:length(animals)
    %delta
    delay = result.delay{m};
    for i=1:length(delays_bars)-1
        delta.induce(m,i) = sum(result.induce{m}(delay>delays_bars(i) & delay<delays_bars(i+1)));
        delta.number(m,i) = sum(delay>delays_bars(i) & delay<delays_bars(i+1));
    end
    
end

% Data for PlotErrorBar
percentage_delta = (delta.induce ./ delta.number)*100;


%% Restricted to N2+N3
for m=1:length(animals)
    %delta
    delay = result.delay{m};
    restrict_substage = result.substage{m}==2 | result.substage{m}==3;
    for i=1:length(delays_bars)-1
        restrict.induce(m,i) = sum(result.induce{m}(restrict_substage & delay>delays_bars(i) & delay<delays_bars(i+1)));
        restrict.number(m,i) = sum(restrict_substage & delay>delays_bars(i) & delay<delays_bars(i+1));
    end
end

% Data for PlotLineError 
percentage_delta_sws = (restrict.induce ./ restrict.number)*100;



%% stat
x_points = [];
y_points = [];
for m=1:size(percentage_delta_sws,1)
    x_points = [x_points delays_intv];
    y_points = [y_points percentage_delta_sws(m,:)];
end
[r1,p1]=corr(x_points',y_points','type','Spearman');
curve_fit= polyfit(x_points,y_points,1);


%% plot
figure, hold on
for m=1:size(percentage_delta_sws,1)
    scatter(delays_intv,percentage_delta_sws(m,:),scattersize,colori{m},'filled'), hold on
end
legend(animals), hold on
if p1<0.05
    line([min(x_points),max(x_points)],curve_fit(2)+[min(x_points),max(x_points)]*curve_fit(1),'Color','k','Linewidth',1), hold on
end
xlabel('delay'),ylabel('%'),
text(0.1,0.95,['r = ' num2str(round(r1,2))],'Units','normalized');
text(0.1,0.9,['p = ' num2str(round(p1,4))],'Units','normalized');





