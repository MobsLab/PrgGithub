% FigureSuccessRateN3
% 21.04.2017 KJ
%
% plot 
%
%
% see 
%   SuccessRateEffectPlot
%  



%% N3/REM, whole light

figure, hold on
%N3/NREM - percentage success
subplot(1,3,1), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', 0, 'xdata', 'percentage', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 70],'YLim',[10 30], 'XTick',0:20:70,'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of success
subplot(1,3,2), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', 0, 'xdata', 'number', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 1300],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of tones
subplot(1,3,3), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', 0, 'xdata', 'tones', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 3200],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,


%% N3/REM, session 2 4

figure, hold on
%N3/NREM - percentage success
subplot(1,3,1), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [2 4], 'xdata', 'percentage', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 70],'YLim',[10 30], 'XTick',0:20:70,'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of success
subplot(1,3,2), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [2 4], 'xdata', 'number', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 1300],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of tones
subplot(1,3,3), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [2 4], 'xdata', 'tones', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 3200],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,


%% N3/REM, session 1 3 5

figure, hold on
%N3/NREM - percentage success
subplot(1,3,1), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [1 3 5], 'xdata', 'percentage', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 70],'YLim',[10 30], 'XTick',0:20:70,'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of success
subplot(1,3,2), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [1 3 5], 'xdata', 'number', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 1300],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,

%N3/NREM - number of tones
subplot(1,3,3), hold on
SuccessRateEffectPlot(3, 6, [2 7], 'session', [1 3 5], 'xdata', 'tones', 'newfig',0,'stat_type','Spearman');
set(gca,'XLim',[0 3200],'YLim',[10 30], 'FontName','Times','fontsize',10), hold on,



