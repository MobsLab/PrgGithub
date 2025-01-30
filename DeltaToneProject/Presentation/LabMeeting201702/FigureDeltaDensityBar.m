% FigureDeltaDensityBar
% 18.02.2017 KJ
%
% plot the density of delta waves for different sessions
%
%
% see 
%   FigureSleepDuration QuantifNumberDeltaPlot
%  


%% NOT PAIRED - per NIGHTS
paired=0;

figure, hold on
for s=1:3
    %Delta number
    subplot(2,3,s), hold on
    QuantifNumberDeltaPlot(0, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
    set(gca,'XTickLabelRotation', 30);

    %Delta density
    subplot(2,3,s+3), hold on
    QuantifNumberDeltaPlot(1, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
    set(gca,'XTickLabelRotation', 30);

end


%% NOT PAIRED - per NIGHTS
paired=1;

figure, hold on
for s=1:3
    %Delta number
    subplot(2,3,s), hold on
    QuantifNumberDeltaPlot(0, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
    set(gca,'XTickLabelRotation', 30);

    %Delta density
    subplot(2,3,s+3), hold on
    QuantifNumberDeltaPlot(1, 'session', s, 'newfig',0, 'show_sig','sig','paired',paired);
    set(gca,'XTickLabelRotation', 30);

end


%% WHOLE NIGHT
figure, hold on
%Delta number
subplot(2,2,1), hold on
QuantifNumberDeltaPlot(0, 'session', 0, 'newfig',0, 'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);

subplot(2,2,2), hold on
QuantifNumberDeltaPlot(0, 'session', 0, 'newfig',0, 'show_sig','sig','paired',1); %paired
set(gca,'XTickLabelRotation', 30);

%Delta density
subplot(2,2,3), hold on
QuantifNumberDeltaPlot(1, 'session', 0, 'newfig',0, 'show_sig','sig','paired',0);
set(gca,'XTickLabelRotation', 30);

subplot(2,2,4), hold on
QuantifNumberDeltaPlot(1, 'session', 0, 'newfig',0, 'show_sig','sig','paired',1); %paired
set(gca,'XTickLabelRotation', 30);






