

clear all


%% Stimulation 14h-16h
% Controls
cd /media/nas5/Thierry_DATA/M1055_processed/M1055_Sham_60Hz_20Hz_interstim120sSleep_200602_100150/
load('SleepScoring_Accelero.mat')
EpochStimCtrl11416=intervalSet(10869*1E4,18069*1E4);
[durWakeCtrl11416,durTWakeCtrl11416]=DurationEpoch(and(Wake,EpochStimCtrl11416));       
[durSWSCtrl11416,durTSWSCtrl11416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl11416));
[durREMCtrl11416,durTREMCtrl11416]=DurationEpoch(and(REMEpoch,EpochStimCtrl11416));


% Stimulation
cd /media/nas5/Thierry_DATA/M1055_processed/M1055_Opto_Septum_VLPO_1055_Cont1416_200727_093648
load('SleepScoring_Accelero.mat')
EpochStim11416=intervalSet(15852*1E4,23052*1E4);
[durWakeStim11416,durTWakeStim11416]=DurationEpoch(and(Wake,EpochStim11416));       
[durSWSStim11416,durTSWSStim11416]=DurationEpoch(and(SWSEpoch,EpochStim11416));
[durREMStim11416,durTREMStim11416]=DurationEpoch(and(REMEpoch,EpochStim11416));

%Wake
Res(1,1)=durTWakeCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(1,2)=durTWakeStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%SWS
Res(2,1)=durTSWSCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(2,2)=durTSWSStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%REM
Res(3,1)=durTREMCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(3,2)=durTREMStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%Figures
figure, bar([durTREMCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTREMStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:2]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hStim'})
title('Percentage of REM over all')

figure, bar([durTSWSCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTSWSStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:2]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hStim'})
title('Percentage of NREM over all')

figure, bar([durTWakeCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTWakeStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:2]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hStim'})
title('Percentage of Wake over all')

%Moyenne 14-16
subplot(1,4,1);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(1,1)] [Res(1,2)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(1,4,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(2,1)] [Res(2,2)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(1,4,3);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1)] [Res(3,2)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(1,4,4);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 2-4pm')
xticks([1 2])
ylim([0 11])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1)] [Res(3,2)]},'newfig',0);
set(gca,'FontSize', 16)
suptitle('% States Control vs OptoStim 30sON-10sOFF during 2 hours')

