% FigureSuccessRate
% 03.05.2017 KJ
%
% plot the correlations between success tones and substage ratio
%
%
% see 
%   CycleSuccessRateEffectPlot SuccessRateEffectPlot
%  


%% WHOLE NIGHT: N3/NREM in session 2

figure, hold on
%deltatone
subplot(3,3,1), hold on
SuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,2), hold on
SuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 700]), ylim([0 40]),

subplot(3,3,3), hold on
SuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 1600]), ylim([0 40]),

%random tone
subplot(3,3,4), hold on
SuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,5), hold on
SuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 700]), ylim([0 40]),

subplot(3,3,6), hold on
SuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 1600]), ylim([0 40]),

%basal
subplot(3,3,7), hold on
SuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,8), hold on
SuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 700]), ylim([0 40]),

subplot(3,3,9), hold on
SuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 1600]), ylim([0 40]),

suplabel('% N3/NREM - Session 2','t');



%% SLEEP CYCLE: N3/NREM in session 2

figure, hold on

%delta tone
subplot(3,3,1), hold on
CycleSuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,2), hold on
CycleSuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,3), hold on
CycleSuccessRateEffectPlot(3, 6, 7, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 140]), ylim([0 40]),

%random tone
subplot(3,3,4), hold on
CycleSuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,5), hold on
CycleSuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,6), hold on
CycleSuccessRateEffectPlot(3, 6, 2, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 140]), ylim([0 40]),

%basal
subplot(3,3,7), hold on
CycleSuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'percentage', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,8), hold on
CycleSuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'number', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 60]), ylim([0 40]),

subplot(3,3,9), hold on
CycleSuccessRateEffectPlot(3, 6, 1, 'session', 2, 'xdata', 'tones', 'showtitle',0,'newfig',0,'stat_type','Spearman');
xlim([0 140]), ylim([0 40]),

suplabel('% N3/NREM - Session 2 (sleep cycles)','t');




