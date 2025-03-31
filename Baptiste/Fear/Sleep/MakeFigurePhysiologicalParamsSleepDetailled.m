

%% HR
zones=1; time=1;
subplot(241); clear A;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Wake','NREM'})
makepretty
ylabel('Frequenc (Hz)')
title('Window = 20s')

subplot(245); clear A; zones=3;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'NREM','Wake'})
makepretty
ylabel('Frequency (Hz)')

zones=2; time=1;
subplot(242); clear A;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'NREM','REM'})
makepretty
ylabel('Frequency (Hz)')

subplot(246); clear A; zones=4;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'REM','NREM'})
makepretty
ylabel('Frequency (Hz)')



zones=1; time=2;
subplot(243); clear A;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Wake','NREM'})
makepretty
ylabel('Frequency (Hz)')
title('Window = 5 min')

subplot(247); clear A; zones=3;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'NREM','Wake'})
makepretty
ylabel('Frequency (Hz)')

zones=2; 
subplot(244); clear A;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'NREM','REM'})
makepretty
ylabel('Frequency (Hz)')

subplot(248); clear A; zones=4;
A(:,1)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,1:10)');
A(:,2)=mean(all_mice_sleepEKG.(all_mice_sleep_time{time}).(Zones{zones}).HR(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'REM','NREM'})
makepretty
ylabel('Frequency (Hz)')





%% Respi

zones=1; time=1;
subplot(2,4,17); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,21); clear A; zones=3;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

zones=2; time=1;
subplot(2,4,12); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,22); clear A; zones=4;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty


zones=1; time=2;
subplot(2,4,19); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,23); clear A; zones=3;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

zones=2; 
subplot(2,4,20); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,24); clear A; zones=4;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).Respi(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty



%% Temp

zones=1; time=1;
subplot(2,4,17); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,21); clear A; zones=3;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

zones=2; time=1;
subplot(2,4,12); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,22); clear A; zones=4;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty


zones=1; time=2;
subplot(2,4,19); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,23); clear A; zones=3;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

zones=2; 
subplot(2,4,20); clear A;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(2,4,24); clear A; zones=4;
A(:,1)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,1:10)');
A(:,2)=mean(all_mice_sleep.(all_mice_sleep_time{time}).(Zones{zones}).MTemp(:,91:100)');
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty




