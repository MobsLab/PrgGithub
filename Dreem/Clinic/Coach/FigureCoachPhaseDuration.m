% FigureCoachPhaseDuration
% 29.03.2017 KJ
%
% plot the durations of each sleep stages
%
%
% see 
%   QuantitySleepDelta QuantifNumberDeltaPlot QuantitySleepDeltaPlot
%  

figure, hold on
for sst=1:6
    subplot(2,3,sst), hold on
    ClinicQuantitySleepPlot(sst, 1:4,'newfig',0, 'paired',0);
end
suplabel('Sleep Stages Duration (s)','t');

figure, hold on
for sst=1:6
    subplot(2,3,sst), hold on
    ClinicQuantitySleepPlot(sst, 1:4,'newfig',0, 'paired',1);
end
suplabel('Sleep Stages Duration (s) - for each subject','t');
