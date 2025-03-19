% FigureDownDensityBar
% 18.02.2017 KJ
%
% plot bar quantification for down states and sleep substages of the spike
% dataset
%
%
% see 
%   FigureDeltaDensityBar QuantifNumberDownPlot QuantifNumberDeltaPlot QuantitySleepDeltaPlot
%  


%% NOT PAIRED - per NIGHTS
paired=0;

figure, hold on
for s=1:3
%Delta number
subplot(2,3,s), hold on
QuantifNumberDownPlot(0, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
set(gca,'XTickLabelRotation', 30);

%Delta density
subplot(2,3,s+3), hold on
QuantifNumberDownPlot(1, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
set(gca,'XTickLabelRotation', 30);

end


%% NOT PAIRED - per NIGHTS
paired=1;

figure, hold on
for s=1:3
%Delta number
subplot(2,3,s), hold on
QuantifNumberDownPlot(0, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
set(gca,'XTickLabelRotation', 30);

%Delta density
subplot(2,3,s+3), hold on
QuantifNumberDownPlot(1, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
set(gca,'XTickLabelRotation', 30);

end