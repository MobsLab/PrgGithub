%% Around Freezing analysis
Zones={'Fz','Shock','Safe'};
figure
% Tail Temp
clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).TTemp(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).TTemp(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).TTemp(mouse,margins_bef*20+1:margins_bef*30));
        Diff.TTemp.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.TTemp.(Zones{zones})(mouse)=(Diff.TTemp.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,12)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
FigureTemp(8,:)=NaN;
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('NormalizedTemperature (°C)')
a=title('Tail Temperature'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)

clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
% Mask Temp
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).MTemp(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).MTemp(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).MTemp(mouse,margins_bef*20+1:margins_bef*30));
        Diff.MTemp.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.MTemp.(Zones{zones})(mouse)=(Diff.MTemp.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,11)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('NormalizedTemperature (°C)')
a=title('Total Body Temperature'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)

clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
% Respi
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Respi(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Respi(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Respi(mouse,margins_bef*20+1:margins_bef*30));
        Diff.Respi.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.Respi.(Zones{zones})(mouse)=(Diff.Respi.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,10)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
a=title( 'Respiratory Rate'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)

clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
% Heart Rate variability
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HRVar(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HRVar(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HRVar(mouse,margins_bef*20+1:margins_bef*30));
        Diff.HRVar.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.HRVar.(Zones{zones})(mouse)=(Diff.HRVar.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,9)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Variability')
a=title( 'Heart Rate variability'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)

clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
% Heart Rate
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HR(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HR(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).HR(mouse,margins_bef*20+1:margins_bef*30));
        Diff.HR.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.HR.(Zones{zones})(mouse)=(Diff.HR.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,8)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
a=title( 'Heart Rate'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)

clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
% Accelerometer
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Acc(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Acc(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(all_mice.(Zones{zones}).Acc(mouse,margins_bef*20+1:margins_bef*30));
        Diff.Acc.(Zones{zones})(mouse)=Before_Freezing.(Zones{zones})(mouse)-Freezing_Epoch_Values.(Zones{zones})(mouse);
        DiffPercent.Acc.(Zones{zones})(mouse)=(Diff.Acc.(Zones{zones})(mouse))/Before_Freezing.(Zones{zones})(mouse);
    end
end

clear FigureTemp
subplot(2,6,7)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Movement quantity')
a=title( 'Accelerometer'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)


a=suptitle('Physiological parameters evolution around freezing episodes (n=10 mice)'); a.FontSize=30;

saveFigure(2,'Physiological_Params_Norm_Freezing','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')




% Corected Respi


clear Before_Freezing; clear Freezing_Epoch_Values; clear After_Freezing; 
for zones=2:length(Zones)
    for mouse=1:length(Mouse_names)
        Before_Freezing.(Zones{zones})(mouse)=nanmean(AllMiceRespiratoryFrequency.(Zones{zones})(mouse,1:margins_bef*10));
        Freezing_Epoch_Values.(Zones{zones})(mouse)=nanmean(AllMiceRespiratoryFrequency.(Zones{zones})(mouse,margins_bef*10+1:margins_bef*20));
        After_Freezing.(Zones{zones})(mouse)=nanmean(AllMiceRespiratoryFrequency.(Zones{zones})(mouse,margins_bef*20+1:margins_bef*30));
    end
end

clear FigureTemp
subplot(2,6,10)
FigureTemp=[Before_Freezing.Shock'  Freezing_Epoch_Values.Shock'  Freezing_Epoch_Values.Safe' Before_Freezing.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
a=title( 'Respiratory Rate'); a.FontSize=25;
xticklabels({'Active shock','Freezing shock','Freezing safe','Active safe'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)



%% Difference study


subplot(1,6,6)
FigurePhysio=[Diff.TTemp.Shock'  Diff.TTemp.Safe'];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
FigurePhysio(8,:)=NaN;
set(hb, 'linewidth' ,2)
ylabel('NormalizedTemperature (°C)')
a=title('Tail Temperature'); a.FontSize=25;
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-1.5 0.5]); a=hline(0,'--k'); a.LineWidth=2;

subplot(1,6,5)
FigurePhysio=[Diff.MTemp.Shock'  Diff.MTemp.Safe']; FigurePhysio(8,:)=NaN;
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('NormalizedTemperature (°C)')
a=title('Body Temperature'); a.FontSize=25;
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-0.3 0.1]); a=hline(0,'--k'); a.LineWidth=2;

subplot(1,6,4)
FigurePhysio=[(nanmean(all_mice.Shock.Respi(:,1:300)')-nanmean((AllMiceRespiratoryFrequency.Shock(:,301:600)')/12))' (nanmean(all_mice.Safe.Respi(:,1:300)')-nanmean((AllMiceRespiratoryFrequency.Safe(:,301:600)')/12))' ];
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
FigurePhysio(8,:)=NaN;
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
title('Respi');
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-2 6]); a=hline(0,'--k'); a.LineWidth=2;

subplot(1,6,3)
FigurePhysio=[Diff.HRVar.Shock'  Diff.HRVar.Safe']; 
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
FigurePhysio(8,:)=NaN;
set(hb, 'linewidth' ,2)
ylabel('Variability')
title('HR Variability');
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-0.12 0.04]); a=hline(0,'--k'); a.LineWidth=2;

subplot(1,6,2)
FigurePhysio=[Diff.HR.Shock'  Diff.HR.Safe']; 
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
FigurePhysio(8,:)=NaN;
set(hb, 'linewidth' ,2)
ylabel('Frequency (Hz)')
title('HR');
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-0.48 1.4]); a=hline(0,'--k'); a.LineWidth=2;

subplot(1,6,1)
FigurePhysio=[Diff.Acc.Shock'  Diff.Acc.Safe']; 
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigurePhysio,'newfig',0,'showpoints',1)
FigurePhysio(8,:)=NaN;
set(hb, 'linewidth' ,2)
ylabel('Movement quantity')
title('Accelerometer');
xticklabels({'Shock side','Safe side'}) 
makepretty
xtickangle(45)
set(gca,'FontSize',20)
ylim([-2.5e7 7e7]); a=hline(0,'--k'); a.LineWidth=2;










