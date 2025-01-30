% TonesEffectEpisodeDurationPlot
% 12.04.2017 KJ
%
% Plot data about the effect of tones on substage episode duration
% 
% 
%   see TonesEffectEpisodeDuration_bis TonesEffectEpisodeDuration
%

clear
load([FolderProjetDelta 'Data/TonesEffectEpisodeDuration_bis.mat']) 

%params
sub = 3;
delay_window = (-1:1:4) * 1E4;
duration_minimum = 4E4;
conditionColors = {'k', [0.75 0.75 0.75],'b','b','b', 'b'};


%% Data

%concatenate
duration_basal = basal.duration{sub};
duration_success = [];
duration_failed = [];
duration_notone = [];

delay_success = [];
delay_failed = [];

for cond=2:length(conditions)
    duration_success = [duration_success ; success.duration{cond,sub}];
    duration_failed = [duration_failed ; failed.duration{cond,sub}];
    duration_notone = [duration_notone ; notone.duration{cond,sub}];

    delay_success = [delay_success ; success.delay{cond,sub}];
    delay_failed = [delay_failed ; failed.delay{cond,sub}];
end


%minimum duration
duration_basal(duration_basal<duration_minimum) = [];

delay_success(duration_success<duration_minimum) = [];
delay_failed(duration_failed<duration_minimum) = [];

duration_success(duration_success<duration_minimum) = [];
duration_failed(duration_failed<duration_minimum) = [];
duration_notone(duration_notone<duration_minimum) = [];



%distinguish duration in function of the timing of the tones
labels{1} = 'Basal'; conditionColors{1} = [0.3 0.3 0.3];
data_success{1} = duration_basal / 1E4;
data_failed{1} = duration_basal / 1E4;

labels{2} = 'No Tone'; conditionColors{2} = [0.75 0.75 0.75];
data_success{2} = duration_notone / 1E4;
data_failed{2} = duration_notone / 1E4;

for i=1:length(delay_window)-1
    
    labels{i+2} = [num2str(delay_window(i)/1E4) 's > tone > ' num2str(delay_window(i+1)/1E4) 's'];
    conditionColors{i+2} = 'b';
    
    data_success{i+2} = duration_success(delay_success>=delay_window(i) & delay_success<delay_window(i+1)) / 1E4;
    data_failed{i+2} = duration_failed(delay_failed>=delay_window(i) & delay_failed<delay_window(i+1)) / 1E4;
end



%% PLOT

figure, hold on

%Success tones
subplot(5,2,[1 3 5]), hold on
PlotErrorSpreadN_KJ(data_success,'newfig',0,'plotcolors',conditionColors,'ShowSigstar','none');
title('Basal vs Notone vs Success Tones'), ylabel('duration (s)'), hold on
set(gca, 'XTickLabel',{[]}, 'XTickLabelRotation', 30, 'ylim',[0 50]), hold on,

subplot(5,2,[7 9]), hold on
[~,eb] = PlotErrorBarN_KJ(data_success,'newfig',0,'barcolors',conditionColors,'ShowSigstar','sig','showPoints',0,'paired',0);
ylabel('duration (s)'), hold on
set(eb,'Linewidth',2); %bold error bar
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30, 'ylim',[0 14]), hold on,

%Failed tones
subplot(5,2,[2 4 6]), hold on
PlotErrorSpreadN_KJ(data_failed,'newfig',0,'plotcolors',conditionColors,'ShowSigstar','none');
title('Basal vs NoTone vs Failed Tones'), ylabel('duration (s)'), hold on
set(gca, 'XTickLabel',{[]}, 'XTickLabelRotation', 30, 'ylim',[0 50]), hold on,

subplot(5,2,[8 10]), hold on
[~,eb] = PlotErrorBarN_KJ(data_failed,'newfig',0,'barcolors',conditionColors,'ShowSigstar','sig','showPoints',0,'paired',0);
ylabel('duration (s)'), hold on
set(eb,'Linewidth',2); %bold error bar
set(gca, 'XTickLabel',labels, 'XTick',1:numel(labels), 'XTickLabelRotation', 30, 'ylim',[0 14]), hold on,

suplabel([NamesSubstages{sub} ' episode average duration'],'t');


