% FigureSleepDuration
% 17.02.2017 KJ
%
% plot the durations of each sleep substages
%
%
% see 
%   QuantitySleepDelta QuantifNumberDeltaPlot QuantitySleepDeltaPlot
%  


%% NOT PAIRED - per NIGHTS

figure, hold on
%Ratio of NREM - Session 1
subplot(2,2,1), hold on
data=QuantitySleepDeltaPlot(6, 0, 'session', 1, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);
%Ratio of N3 / NREM - Session 1
subplot(2,2,2), hold on
data=QuantitySleepDeltaPlot(3, 6, 'session', 1, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);

%Ratio of NREM - Session 2
subplot(2,2,3), hold on
data=QuantitySleepDeltaPlot(6, 0, 'session', 2, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);
%Ratio of N3 / NREM - Session 2
subplot(2,2,4), hold on
data=QuantitySleepDeltaPlot(3, 6, 'session', 2, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);

figure, hold on
%Ratio of NREM - Session 1
subplot(2,2,1), hold on
data=QuantitySleepDeltaPlot(6, 0, 'session', 3, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);
%Ratio of N3 / NREM - Session 1
subplot(2,2,2), hold on
data=QuantitySleepDeltaPlot(3, 6, 'session', 3, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);

%Ratio of NREM - Session 2
subplot(2,2,3), hold on
data=QuantitySleepDeltaPlot(6, 0, 'session', 4, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);
%Ratio of N3 / NREM - Session 2
subplot(2,2,4), hold on
data=QuantitySleepDeltaPlot(3, 6, 'session', 4, 'newfig',0,'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);



%% Ratio N3/NREM, Session 2 & 4
data=QuantitySleepDeltaPlot(3, 6, 'session', [2 4], 'newfig',1,'show_sig','sig','paired',0);

%% Ratio N3/NREM, All night
data=QuantitySleepDeltaPlot(3, 6, 'session', 0, 'newfig',1,'show_sig','sig','paired',0);

%% Ratio N3/NREM, Session 1 to 4
data=QuantitySleepDeltaPlot(3, 6, 'session', 1:4, 'newfig',1,'show_sig','sig','paired',0);


%% Ratio N3, Session 2 & 4
data=QuantitySleepDeltaPlot(3, 0, 'session', [2 4], 'newfig',1,'show_sig','sig','paired',0);

%% Ratio N3, All night
data=QuantitySleepDeltaPlot(3, 0, 'session', 0, 'newfig',1,'show_sig','sig','paired',0);

%% Ratio N3, Session 1 to 4
data=QuantitySleepDeltaPlot(3, 0, 'session', 1:4, 'newfig',1,'show_sig','sig','paired',0);


