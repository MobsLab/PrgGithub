%% Shock Episodes analysis
Zones={'Stim'};
zones=1;

clear FromBegToShock; clear FromShockToEnd; clear FigureTemp;
% Acc
for mouse=1:length(Mouse_names)
    FromBegToShock(mouse)=nanmean(all_mice_onset.(Zones{zones}).Acc(mouse,1:40));
    FromShockToEnd(mouse)=nanmean(all_mice_onset.(Zones{zones}).Acc(mouse,60:100));
end

figure
subplot(1,6,1);
FigureTemp=([FromBegToShock'  FromShockToEnd']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Movement quantity')
a=title( 'Accelerometer'); a.Position=[1.7000 1.1756e+08 0];
xticklabels({'before choc','after shock'})
makepretty

% Heart Rate
clear FlatHR; clear ShockHR; clear FigureHR;
for mouse=1:9
    FlatHR(mouse)=nanmean(all_mice_onset.(Zones{zones}).HR(mouse,1:40));
    ShockHR(mouse)=nanmean(all_mice_onset.(Zones{zones}).HR(mouse,60:100));
end

subplot(1,6,2);
FigureHR=([FlatHR'  ShockHR']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureHR,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
xticklabels({'before choc','after shock'})
title('Heart Rate')
makepretty

% Heart Rate variability
clear FlatHRVar; clear ShockHRVar; clear FigureHRVar;
for mouse=1:9
    FlatHRVar(mouse)=nanmean(all_mice_onset.(Zones{zones}).HRVar(mouse,1:40));
    ShockHRVar(mouse)=nanmean(all_mice_onset.(Zones{zones}).HRVar(mouse,60:100));
end

subplot(1,6,3);
FigureHRVar=([FlatHRVar'  ShockHRVar']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureHRVar,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
xticklabels({'before choc','after shock'})
title('Heart Rate variability')
makepretty

% Respi
clear ShockRespi; clear FlatRespi; clear FigureRespi;
for mouse=1:length(Mouse_names)
    FlatRespi(mouse)=nanmean(all_mice_onset.(Zones{zones}).Respi(mouse,1:40));
    ShockRespi(mouse)=nanmean(all_mice_onset.(Zones{zones}).Respi(mouse,60:100));
end

subplot(1,6,4);
%FigureRespi=([FlatRespi'  ShockRespi']./(mean(FlatRespi)).*100);
FigureRespi=([FlatRespi'  ShockRespi']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureRespi,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
xticklabels({'before shock','after shock'})
title('Respiratory rate')
makepretty

% Mask Temp
clear FromBegToShock; clear FromShockToEnd; clear FigureTemp;
for mouse=1:length(Mouse_names)
    FromBegToShock(mouse)=nanmean(all_mice_onset.(Zones{zones}).MTemp(mouse,1:50));
    FromShockToEnd(mouse)=nanmean(all_mice_onset.(Zones{zones}).MTemp(mouse,51:100));
end

subplot(1,6,5);
FigureTemp=([FromBegToShock'  FromShockToEnd']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Temperature Difference (°C)')
title('Total Body Temperature')
xticklabels({'before shock','after shock'})
makepretty

% Tail Temp
clear FromBegToShock; clear FromShockToEnd; clear FigureTemp;
for mouse=1:length(Mouse_names)
    FromBegToShock(mouse)=nanmean(all_mice_onset.(Zones{zones}).TTemp(mouse,1:40));
    FromShockToEnd(mouse)=nanmean(all_mice_onset.(Zones{zones}).TTemp(mouse,60:100));
end

subplot(1,6,6);
FigureTemp=([FromBegToShock'  FromShockToEnd']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Temperature Difference (°C)')
title('Tail Temperature')
xticklabels({'before shock','after shock'})
makepretty

a=suptitle('Physiological parameters evolution around eyelidshocks (n=10 mice)'); a.FontSize=30;


saveFigure(2,'Physiological_Params_Eyelidshocks_Detailled','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')


