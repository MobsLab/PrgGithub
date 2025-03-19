

GetEmbReactMiceFolderList_BM


clear all_mice_onset; 
for zones=1:length(Zones)
%Gathering all episodes in an array
    all_mice_onset.(Zones{zones}).TTemp=[];
    all_mice_onset.(Zones{zones}).MTemp=[];
    all_mice_onset.(Zones{zones}).Respi=[];
    all_mice_onset.(Zones{zones}).HR=[];
    all_mice_onset.(Zones{zones}).HRVar=[];
    all_mice_onset.(Zones{zones}).Speed=[];
    all_mice_onset.(Zones{zones}).Acc=[];
        for mouse=1:length(Mouse_names)
            all_mice_onset.(Zones{zones}).TTemp=[all_mice_onset.(Zones{zones}).TTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).TTemp_Interp')];
            all_mice_onset.(Zones{zones}).MTemp=[all_mice_onset.(Zones{zones}).MTemp ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).MTemp_Interp')];
            all_mice_onset.(Zones{zones}).Respi=[all_mice_onset.(Zones{zones}).Respi; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Respi_Interp')];
            all_mice_onset.(Zones{zones}).HR=[all_mice_onset.(Zones{zones}).HR ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HR_Interp')];
            all_mice_onset.(Zones{zones}).HRVar=[all_mice_onset.(Zones{zones}).HRVar ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).HRVar_Interp')];
            all_mice_onset.(Zones{zones}).Speed=[all_mice_onset.(Zones{zones}).Speed ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Speed_Interp')];
            all_mice_onset.(Zones{zones}).Acc=[all_mice_onset.(Zones{zones}).Acc ; nanmean(On_Offset_Freezing.(Zones{zones}).(Mouse_names{mouse}).Acc_Interp')];
        end
    all_mice_onset.(Zones{zones}).HR([5 8 10],:)=NaN;
    all_mice_onset.(Zones{zones}).HRVar([5 8 10],:)=NaN;
end
       
%for mouse=1:length(Mouse_names)
 %   MeanTTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(Sess2.(Mouse_names{mouse}),'tailtemperature')));
 %   MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(Sess2.(Mouse_names{mouse}),'masktemperature')));
%end

%% Mean values
for mouse=1:length(Mouse_names)
    AccData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
    MTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'masktemperature');
    TTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'tailtemperature');
    FzEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
    RoomTempData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'roomtemperature');
    HRData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartrate');
    HRVarData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartratevar');
    RespiData.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'instfreq','suffix_instfreq','B');
    TotalEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(AccData.(Mouse_names{mouse}))));
    Non_FreezingEpoch.(Mouse_names{mouse})=TotalEpoch.(Mouse_names{mouse}) -FzEpoch.(Mouse_names{mouse});
    OBSpec=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
end


%% Gathering data
for mouse=1:length(Mouse)
    FearMean.Acc(mouse,1)=nanmean(Data(Restrict(AccData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.Acc(mouse,2)=nanmean(Data(Restrict(AccData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.MTemp(mouse,1)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.MTemp(mouse,2)=nanmean(Data(Restrict(MTempData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.MTemp(mouse,3)=nanmean(Data(MTempData.(Mouse_names{mouse})));
    FearMean.TTemp(mouse,1)=nanmean(Data(Restrict(TTempData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.TTemp(mouse,2)=nanmean(Data(Restrict(TTempData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.TTemp(mouse,3)=nanmean(Data(TTempData.(Mouse_names{mouse})));
    FearMean.Respi(mouse,1)=nanmean(Data(Restrict(RespiData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.Respi(mouse,2)=nanmean(Data(Restrict(RespiData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.HR(mouse,1)=nanmean(Data(Restrict(HRData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.HR(mouse,2)=nanmean(Data(Restrict(HRData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.HRVar(mouse,1)=nanmean(Data(Restrict(HRVarData.(Mouse_names{mouse}),Non_FreezingEpoch.(Mouse_names{mouse}))));
    FearMean.HRVar(mouse,2)=nanmean(Data(Restrict(HRVarData.(Mouse_names{mouse}),FzEpoch.(Mouse_names{mouse}))));
    FearMean.OBRespi_Fz{mouse}=Data(Restrict( OBSpec , FzEpoch.(Mouse_names{mouse})));
   RespiFromOB(mouse,1)=nanmean(RespiratoryRythmFromSpectrum_BM(FearMean.OBRespi_Fz{mouse}));
end
FearMean.MTemp(:,1)=FearMean.MTemp(:,1)-FearMean.MTemp(:,3);
FearMean.MTemp(:,2)=FearMean.MTemp(:,2)-FearMean.MTemp(:,3);
FearMean.MTemp2=FearMean.MTemp; clear FearMean.MTemp; FearMean.MTemp=FearMean.MTemp(:,1:2);
FearMean.TTemp(:,1)=FearMean.TTemp(:,1)-FearMean.TTemp(:,3);
FearMean.TTemp(:,2)=FearMean.TTemp(:,2)-FearMean.TTemp(:,3);
FearMean.MTemp2=FearMean.TTemp; clear FearMean.MTemp; FearMean.TTemp=FearMean.TTemp(:,1:2);
FearMean.HR(10,:)=NaN;
FearMean.HRVar(10,:)=NaN;


% Substract mean temperature
for mouse=1:length(Mouse_names)
    MeanTTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'tailtemperature')));
    MeanMTempPerMice.(Mouse_names{mouse})=nanmean(Data(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'masktemperature')));
end

% Substract mean temperature
for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        all_mice_onset.(Zones{zones}).TTemp(mouse,:)=all_mice_onset.(Zones{zones}).TTemp(mouse,:)-MeanTTempPerMice.(Mouse_names{mouse});
        all_mice_onset.(Zones{zones}).MTemp(mouse,:)=all_mice_onset.(Zones{zones}).MTemp(mouse,:)-MeanMTempPerMice.(Mouse_names{mouse});
    end
end


%% Shock analysis
figure
subplot(1,6,1)
Conf_Inter=nanstd(all_mice_onset.Stim.Acc)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Acc),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylim([0 1.5e8]);
ylabel('Movement quantity')
makepretty
a=title( 'Accelerometer'); a.Position=[60 15.3e7 0];
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)

subplot(1,6,2)
Conf_Inter=nanstd(all_mice_onset.Stim.HR)/sqrt(size(all_mice_onset.Stim.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)
ylim([12.6 13.4])

subplot(1,6,3)
Conf_Inter=nanstd(all_mice_onset.Stim.HRVar)/sqrt(size(all_mice_onset.Stim.HRVar,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.HRVar),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Variability')
title( 'Heart Rate variability');
makepretty
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)
ylim([0 0.2])

subplot(1,6,4)
Conf_Inter=nanstd(all_mice_onset.Stim.Respi)/sqrt(size(all_mice_onset.Stim.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)
ylim([6 8.5])

subplot(1,6,5)
Conf_Inter=nanstd(all_mice_onset.Stim.MTemp)/sqrt(size(all_mice_onset.Stim.MTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.MTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Normalized Temperature (°C)')
makepretty
title( 'Total Body Temperature');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)
ylim([-0.7 0.1])

subplot(1,6,6)
Conf_Inter=nanstd(all_mice_onset.Stim.TTemp)/sqrt(size(all_mice_onset.Stim.TTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.TTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Normalized Temperature (°C)')
makepretty
title( 'Tail Temperature');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',10);
set(gca,'FontSize',20)
ylim([-2 -0.5])

a=suptitle('Physiological parameters evolution around eyelidshocks (n=10 mice)'); a.FontSize=30;

saveFigure(1,'Physiological_Params_Eyelidshocks','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')

%% Significant figure for transitions
zones=1;
figure

clear FromBegToShock; clear FromShockToEnd; clear FigureTemp;
% Acc
for mouse=1:length(Mouse_names)
    FromBegToShock(mouse)=nanmean(all_mice_onset.(Zones{zones}).Acc(mouse,1:40));
    FromShockToEnd(mouse)=nanmean(all_mice_onset.(Zones{zones}).Acc(mouse,60:100));
end

subplot(1,6,1);
FigureTemp=([FromBegToShock'  FromShockToEnd']);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(FigureTemp,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
ylabel('Movement quantity')
a=title( 'Accelerometer'); a.Position=[1.7000 1.1756e+08 0];
xticklabels({'before shock','after shock'})
makepretty
set(gca,'FontSize',20)
xtickangle(45)

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
xticklabels({'before shock','after shock'})
title('Heart Rate')
makepretty
set(gca,'FontSize',20)
xtickangle(45)

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
xticklabels({'before shock','after shock'})
title('Heart Rate variability')
makepretty
set(gca,'FontSize',20)
xtickangle(45)

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
set(gca,'FontSize',20)
xtickangle(45)

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
ylabel('Normalized Temperature (°C)')
title('Total Body Temperature')
xticklabels({'before shock','after shock'})
makepretty
set(gca,'FontSize',20)
xtickangle(45)

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
ylabel('Normalized Temperature (°C)')
title('Tail Temperature')
xticklabels({'before shock','after shock'})
makepretty
set(gca,'FontSize',20)
xtickangle(45)

a=suptitle('Physiological parameters evolution around eyelidshocks (n=10 mice)'); a.FontSize=30;

saveFigure(2,'Physiological_Params_Norm_Freezing','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')

%% Mean values for freezing
Physio_Param={'Acc','HR','Respi','MTemp','TTemp'};
Cols = {[0, 0.5, 0],[0.494, 0.184, 0.556]};
X = [1,2];
Legends = {'Active','Freezing'};

figure
for param=1:length(Physio_Param)
    
    subplot(1,5,param)
    MakeSpreadAndBoxPlot2_SB(FearMean.(Physio_Param{param}),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
    if param==1; ylabel('Movement quantity'); title('Movement')
    elseif param==2; ylabel('Frequency (Hz)'); title('Heart rate')
    elseif param==3; ylabel('Frequency (Hz)'); title('Respiratory rate')
    elseif param==4; ylabel('NormalizedTemperature (°C)'); title('Body Temperature')
    elseif param==5; ylabel('NormalizedTemperature (°C)'); title('Tail temperature')
    end
    
end

a=suptitle('Physiological parameters and behaviour evolution during fear session, n=10'); a.FontSize=30
a=suptitle('Behaviour & physiological parameters, n=10'); a.FontSize=20;

saveFigure(1,'Physiological_Analysis_Fear_MeanValues','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')


%% Onset Evolution

figure
subplot(3,6,7)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Acc)/sqrt(size(all_mice_onset.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Acc),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylim([0 4e7]);
ylabel('Movement quantity')
makepretty
title( 'Accelerometer');
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
a=text(50,3e7,'Freezing Onset','FontSize',20,'Color','r')
set(gca,'FontSize',20)

subplot(3,6,8)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HR)/sqrt(size(all_mice_onset.FreezingOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
set(gca,'FontSize',20)

subplot(3,6,9)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HRVar)/sqrt(size(all_mice_onset.FreezingOnset.HRVar,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HRVar),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Variability')
title( 'Heart Rate variability');
makepretty
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
set(gca,'FontSize',20)
ylim([0.1 0.3 ]);

subplot(3,6,10)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Respi)/sqrt(size(all_mice_onset.FreezingOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
a=vline(50,'--r'); a.LineWidth=4; 
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

subplot(3,6,11)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.MTemp)/sqrt(size(all_mice_onset.FreezingOnset.MTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.MTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Total Body Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

subplot(3,6,12)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.TTemp)/sqrt(size(all_mice_onset.FreezingOnset.TTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.TTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Tail Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

a=suptitle('Physiological parameters evolution around freezing onset (n=10 mice)'); a.FontSize=40;

saveFigure(1,'Physiological_Params_FreezingOnset','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')

%% Offset Evolution

figure
subplot(3,6,13)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.Acc)/sqrt(size(all_mice_onset.FreezingOffset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.Acc),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylim([0 4e7]);
ylabel('Movement quantity')
makepretty
title( 'Accelerometer');
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
a=text(50,3e7,'Freezing Offset','FontSize',20,'Color','r')
set(gca,'FontSize',20)

subplot(3,6,14)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.HR)/sqrt(size(all_mice_onset.FreezingOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)
a=vline(50,'--r'); a.LineWidth=4; 

subplot(3,6,15)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.HRVar)/sqrt(size(all_mice_onset.FreezingOffset.HRVar,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.HRVar),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Variability')
title( 'Heart Rate variability');
makepretty
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
set(gca,'FontSize',20)

subplot(3,6,16)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.Respi)/sqrt(size(all_mice_onset.FreezingOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

subplot(3,6,17)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.MTemp)/sqrt(size(all_mice_onset.FreezingOffset.MTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.MTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Total Body Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',16)

subplot(3,6,18)
Conf_Inter=nanstd(all_mice_onset.FreezingOffset.TTemp)/sqrt(size(all_mice_onset.FreezingOffset.TTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.TTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Tail Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',16)

a=suptitle('Physiological parameters evolution around freezing offset (n=10 mice)'); a.FontSize=30;

saveFigure(2,'Physiological_Params_FreezingOffset','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')


% call MakeFigureTemperatureShockEpDetailled for significant figure


%% Derivative analysis

Respi_Onset=nanmean(all_mice_onset.FreezingOnset.Respi);
Respi_Offset=nanmean(all_mice_onset.FreezingOffset.Respi);
HR_Onset=nanmean(all_mice_onset.FreezingOnset.HR);
HR_Offset=nanmean(all_mice_onset.FreezingOffset.HR);

for i=1:33
    Respi_Onset2(i)=Respi_Onset(i*3);
    Respi_Offset2(i)=Respi_Offset(i*3); 
end
for i=1:10
    HR_Onset2(i)=HR_Onset(i*10);
    HR_Offset2(i)=HR_Offset(i*10); 
end

Diff_Respi_Onset=diff(Respi_Onset2); RespiOnset_Deriv=-(max(abs(Diff_Respi_Onset)))*5/3; % 5 for 0.2s by bin, 3 for the previous sampling
Diff_Respi_Offset=diff(Respi_Offset2); RespiOffset_Deriv=(max(abs(Diff_Respi_Offset)))*5/3;
Diff_HR_Onset=diff(HR_Onset2); HROnset_Deriv=-(max(abs(Diff_HR_Onset)))*5/10; % 5 for 0.2s by bin, 3 for the previous sampling
Diff_HR_Offset=diff(HR_Offset2); HROffset_Deriv=(max(abs(Diff_HR_Offset)))*5/10;

% y = a*x+b, b? --> b = y - a*x
intercept_Respi_Onset=Respi_Onset(50)-(RespiOnset_Deriv/5)*50;
intercept_Respi_Offset=Respi_Offset(50)-(RespiOffset_Deriv/5)*50;
intercept_HR_Onset=HR_Onset(50)-(HROnset_Deriv/5)*50;
intercept_HR_Offset=HR_Offset(50)-(HROffset_Deriv/5)*50;

x=[1:100];

subplot(222)

Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Respi)/sqrt(size(all_mice_onset.FreezingOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
a=vline(50,'--r'); a.LineWidth=4; 
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

plot(x,(RespiOnset_Deriv/5)*x+intercept_Respi_Onset,'LineWidth',2); ylim([4.5 7])
text(60,4.6,['a = ' num2str(round(RespiOnset_Deriv,2)) ' Hz/s'],'FontSize',20,'Color',[0.4660, 0.6740, 0.1880])

subplot(224)

Conf_Inter=nanstd(all_mice_onset.FreezingOffset.Respi)/sqrt(size(all_mice_onset.FreezingOffset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
a=vline(50,'--r'); a.LineWidth=4; 
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)

plot(x,(RespiOffset_Deriv/5)*x+intercept_Respi_Offset,'LineWidth',2); ylim([4.5 7])
text(60,4.6,['a = ' num2str(round(RespiOffset_Deriv,2)) ' Hz/s'],'FontSize',20,'Color',[0.4660, 0.6740, 0.1880])

subplot(221)

Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HR)/sqrt(size(all_mice_onset.FreezingOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
set(gca,'FontSize',20)

plot(x,(HROnset_Deriv/5)*x+intercept_HR_Onset,'LineWidth',2); ylim([10.5 12.5])
text(60,10.6,['a = ' num2str(round(HROnset_Deriv,2)) ' Hz/s'],'FontSize',20,'Color',[0.4660, 0.6740, 0.1880])

subplot(223)

Conf_Inter=nanstd(all_mice_onset.FreezingOffset.HR)/sqrt(size(all_mice_onset.FreezingOffset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOffset.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})
set(gca,'FontSize',20)
a=vline(50,'--r'); a.LineWidth=4; 

plot(x,(HROffset_Deriv/5)*x+intercept_HR_Offset,'LineWidth',2); ylim([10.5 12.5])
text(60,10.6,['a = ' num2str(round(HROffset_Deriv,2)) ' Hz/s'],'FontSize',20,'Color',[0.4660, 0.6740, 0.1880])





%% Brouillon

subplot(423)
A(:,1)=all_mice_onset.FreezingOnset.MTemp(:,1);
A(:,2)=all_mice_onset.FreezingOnset.MTemp(:,57);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty
subplot(424)
A(:,1)=all_mice_onset.FreezingOffset.MTemp(:,48);
A(:,2)=all_mice_onset.FreezingOffset.MTemp(:,100);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty

subplot(427)
A(:,1)=all_mice_onset.FreezingOnset.TTemp(:,1);
A(:,2)=all_mice_onset.FreezingOnset.TTemp(:,57);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty
subplot(428)
A(:,1)=all_mice_onset.FreezingOffset.TTemp(:,48);
A(:,2)=all_mice_onset.FreezingOffset.TTemp(:,100);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(A,'newfig',0,'showpoints',1)
set(hb, 'linewidth' ,2)
xticklabels({'Avant freezing','Après freezing'})
makepretty




xticks([0 50 100])
xticklabels({'-20s','0s','20s'})

ylabel('Température Normalisée (°C)')
title('Température corps')
title('Température queue')




