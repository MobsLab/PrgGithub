
% Stimulation 10h-12h

clear all

cd /media/nas5/Thierry_DATA/M1076_processed/20200716
load('SleepScoring_Accelero.mat')
EpochStimCtrl1=intervalSet(0,2*3600*1E4);
[durWakeCtrl1,durTWakeCtrl1]=DurationEpoch(and(Wake,EpochStimCtrl1));       
[durSWSCtrl1,durTSWSCtrl1]=DurationEpoch(and(SWSEpoch,EpochStimCtrl1));
[durREMCtrl1,durTREMCtrl1]=DurationEpoch(and(REMEpoch,EpochStimCtrl1));

cd /media/nas5/Thierry_DATA/M1076_processed/Sham_1076_200701_095350
load('SleepScoring_Accelero.mat')
EpochStimCtrl2=intervalSet(370*1E4,7570*1E4);
[durWakeCtrl2,durTWakeCtrl2]=DurationEpoch(and(Wake,EpochStimCtrl2));       
[durSWSCtrl2,durTSWSCtrl2]=DurationEpoch(and(SWSEpoch,EpochStimCtrl2));
[durREMCtrl2,durTREMCtrl2]=DurationEpoch(and(REMEpoch,EpochStimCtrl2));

cd /media/nas5/Thierry_DATA/M1076_processed/20200720/
load('SleepScoring_Accelero.mat')
EpochStimCtrl3=intervalSet(56*1E4,7256*1E4);
[durWakeCtrl3,durTWakeCtrl3]=DurationEpoch(and(Wake,EpochStimCtrl3));       
[durSWSCtrl3,durTSWSCtrl3]=DurationEpoch(and(SWSEpoch,EpochStimCtrl3));
[durREMCtrl3,durTREMCtrl3]=DurationEpoch(and(REMEpoch,EpochStimCtrl3));

cd /media/nas5/Thierry_DATA/M1076_processed/20200723/
load('SleepScoring_Accelero.mat')
EpochStimCtrl4=intervalSet(1520*1E4,8720*1E4);
[durWakeCtrl4,durTWakeCtrl4]=DurationEpoch(and(Wake,EpochStimCtrl4));       
[durSWSCtrl4,durTSWSCtrl4]=DurationEpoch(and(SWSEpoch,EpochStimCtrl4));
[durREMCtrl4,durTREMCtrl4]=DurationEpoch(and(REMEpoch,EpochStimCtrl4));

cd /media/nas5/Thierry_DATA/M1076_processed/20200727
load('SleepScoring_Accelero.mat')
EpochStimCtrl5=intervalSet(1439*1E4,8639*1E4);
[durWakeCtrl5,durTWakeCtrl5]=DurationEpoch(and(Wake,EpochStimCtrl5));       
[durSWSCtrl5,durTSWSCtrl5]=DurationEpoch(and(SWSEpoch,EpochStimCtrl5));
[durREMCtrl5,durTREMCtrl5]=DurationEpoch(and(REMEpoch,EpochStimCtrl5));

%stim

cd /media/nas5/Thierry_DATA/M1076_processed/20200717
load('SleepScoring_Accelero.mat')
EpochStim1012=intervalSet(1625*1E4,8825*1E4);
[durWakeStim1012,durTWakeStim1012]=DurationEpoch(and(Wake,EpochStim1012));       
[durSWSStim1012,durTSWSStim1012]=DurationEpoch(and(SWSEpoch,EpochStim1012));
[durREMStim1012,durTREMStim1012]=DurationEpoch(and(REMEpoch,EpochStim1012));

%Wake
Res(1,1)=durTWakeCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100;
Res(1,2)=durTWakeCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100;
Res(1,3)=durTWakeCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100;
Res(1,4)=durTWakeCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100;
Res(1,5)=durTWakeCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100;
Res(1,6)=durTWakeStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100;

%SWS
Res(2,1)=durTSWSCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100;
Res(2,2)=durTSWSCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100;
Res(2,3)=durTSWSCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100;
Res(2,4)=durTSWSCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100;
Res(2,5)=durTSWSCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100;
Res(2,6)=durTSWSStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100;

%REM
Res(3,1)=durTREMCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100;
Res(3,2)=durTREMCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100;
Res(3,3)=durTREMCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100;
Res(3,4)=durTREMCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100;
Res(3,5)=durTREMCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100;
Res(3,6)=durTREMStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100;

%Figures
figure, bar([durTREMCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100,durTREMCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100,durTREMCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100,durTREMCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100,durTREMCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100,durTREMStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100])
set(gca,'xtick',[1:6]), set(gca,'xticklabel',{'10-12hCtrl1','10-12hCtrl2','10-12hCtrl3','10-12hCtrl4','10-12hCtrl5','10-12hStim'})
title('Percentage of REM over all')

figure, bar([durTSWSCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100,durTSWSCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100,durTSWSCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100,durTSWSCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100,durTSWSCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100,durTSWSStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100])
set(gca,'xtick',[1:6]), set(gca,'xticklabel',{'10-12hCtrl1','10-12hCtrl2','10-12hCtrl3','10-12hCtrl4','10-12hCtrl5','10-12hStim'})
title('Percentage of NREM over all')

figure, bar([durTWakeCtrl1/(durTWakeCtrl1+durTSWSCtrl1+durTREMCtrl1)*100,durTWakeCtrl2/(durTWakeCtrl2+durTSWSCtrl2+durTREMCtrl2)*100,durTWakeCtrl3/(durTWakeCtrl3+durTSWSCtrl3+durTREMCtrl3)*100,durTWakeCtrl4/(durTWakeCtrl4+durTSWSCtrl4+durTREMCtrl4)*100,durTWakeCtrl5/(durTWakeCtrl5+durTSWSCtrl5+durTREMCtrl5)*100,durTWakeStim1012/(durTWakeStim1012+durTSWSStim1012+durTREMStim1012)*100])
set(gca,'xtick',[1:6]), set(gca,'xticklabel',{'10-12hCtrl1','10-12hCtrl2','10-12hCtrl3','10-12hCtrl4','10-12hCtrl5','10-12hStim'})
title('Percentage of Wake over all')


%Moyenne 10-12
subplot(4,4,1);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total 10-12am')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(1,1),Res(1,2),Res(1,3),Res(1,4), Res(1,5)] [Res(1,6)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,2);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total 10-12am')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(2,1),Res(2,2),Res(2,3),Res(2,4), Res(2,5)] [Res(2,6)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,3);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 10-12am')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1),Res(3,2),Res(3,3),Res(3,4),Res(3,5)] [Res(3,6)],},'newfig',0);

subplot(4,4,4);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 10-12am')
xticks([1 2])
ylim([0 12])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1),Res(3,2),Res(3,3),Res(3,4),Res(3,5)] [Res(3,6)],},'newfig',0);
set(gca,'FontSize', 16)

%% Stimulation 12h-14h
% Controls
cd /media/nas5/Thierry_DATA/M1076_processed/20200716
load('SleepScoring_Accelero.mat')
EpochStimCtrl11214=intervalSet(7200*1E4,14400*1E4);
[durWakeCtrl11214,durTWakeCtrl11214]=DurationEpoch(and(Wake,EpochStimCtrl11214));       
[durSWSCtrl11214,durTSWSCtrl11214]=DurationEpoch(and(SWSEpoch,EpochStimCtrl11214));
[durREMCtrl1214,durTREMCtrl11214]=DurationEpoch(and(REMEpoch,EpochStimCtrl11214));

cd /media/nas5/Thierry_DATA/M1076_processed/Sham_1076_200701_095350
load('SleepScoring_Accelero.mat')
EpochStimCtrl21214=intervalSet(7570*1E4,14770*1E4);
[durWakeCtrl21214,durTWakeCtrl21214]=DurationEpoch(and(Wake,EpochStimCtrl21214));       
[durSWSCtrl21214,durTSWSCtrl21214]=DurationEpoch(and(SWSEpoch,EpochStimCtrl21214));
[durREMCtrl21214,durTREMCtrl21214]=DurationEpoch(and(REMEpoch,EpochStimCtrl21214));

cd /media/nas5/Thierry_DATA/M1076_processed/20200723/
load('SleepScoring_Accelero.mat')
EpochStimCtrl31214=intervalSet(8720*1E4,15920*1E4);
[durWakeCtrl31214,durTWakeCtrl31214]=DurationEpoch(and(Wake,EpochStimCtrl31214));       
[durSWSCtrl31214,durTSWSCtrl31214]=DurationEpoch(and(SWSEpoch,EpochStimCtrl31214));
[durREMCtrl31214,durTREMCtrl31214]=DurationEpoch(and(REMEpoch,EpochStimCtrl31214));

cd /media/nas5/Thierry_DATA/M1076_processed/20200727
load('SleepScoring_Accelero.mat')
EpochStimCtrl41214=intervalSet(8639*1E4,15839*1E4);
[durWakeCtrl41214,durTWakeCtrl41214]=DurationEpoch(and(Wake,EpochStimCtrl41214));       
[durSWSCtrl41214,durTSWSCtrl41214]=DurationEpoch(and(SWSEpoch,EpochStimCtrl41214));
[durREMCtrl41214,durTREMCtrl41214]=DurationEpoch(and(REMEpoch,EpochStimCtrl41214));

% Stimulation
cd /media/nas5/Thierry_DATA/M1076_processed/20200720
load('SleepScoring_Accelero.mat')
EpochStim1214=intervalSet(7271*1E4,14471*1E4);
[durWakeStim1214,durTWakeStim1214]=DurationEpoch(and(Wake,EpochStim1214));       
[durSWSStim1214,durTSWSStim1214]=DurationEpoch(and(SWSEpoch,EpochStim1214));
[durREMStim1214,durTREMStim1214]=DurationEpoch(and(REMEpoch,EpochStim1214));

%Wake
Res(1,1)=durTWakeCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100;
Res(1,2)=durTWakeCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100;
Res(1,3)=durTWakeCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100;
Res(1,4)=durTWakeCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100;
Res(1,5)=durTWakeStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100;

%SWS
Res(2,1)=durTSWSCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100;
Res(2,2)=durTSWSCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100;
Res(2,3)=durTSWSCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100;
Res(2,4)=durTSWSCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100;
Res(2,5)=durTSWSStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100;

%REM
Res(3,1)=durTREMCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100;
Res(3,2)=durTREMCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100;
Res(3,3)=durTREMCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100;
Res(3,4)=durTREMCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100;
Res(3,5)=durTREMStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100;

%Figures
figure, bar([durTREMCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100,durTREMCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100,durTREMCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100,durTREMCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100,durTREMStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100])
set(gca,'xtick',[1:5]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hCtrl2','12-14hCtrl3','12-14hCtrl4','12-14hStim'})
title('Percentage of REM over all')

figure, bar([durTSWSCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100,durTSWSCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100,durTSWSCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100,durTSWSCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100,durTSWSStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100])
set(gca,'xtick',[1:5]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hCtrl2','12-14hCtrl3','12-14hCtrl4','12-14hStim'})
title('Percentage of NREM over all')

figure, bar([durTWakeCtrl11214/(durTWakeCtrl11214+durTSWSCtrl11214+durTREMCtrl11214)*100,durTWakeCtrl21214/(durTWakeCtrl21214+durTSWSCtrl21214+durTREMCtrl21214)*100,durTWakeCtrl31214/(durTWakeCtrl31214+durTSWSCtrl31214+durTREMCtrl31214)*100,durTWakeCtrl41214/(durTWakeCtrl41214+durTSWSCtrl41214+durTREMCtrl41214)*100,durTWakeStim1214/(durTWakeStim1214+durTSWSStim1214+durTREMStim1214)*100])
set(gca,'xtick',[1:5]), set(gca,'xticklabel',{'12-14hCtrl1','12-14hCtrl2','12-14hCtrl3','12-14hCtrl4','12-14hStim'})
title('Percentage of Wake over all')

%Moyenne 12-14
subplot(4,4,5);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total 12-2pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(1,1),Res(1,2),Res(1,3),Res(1,4)] [Res(1,5)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,6);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total 12-2pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(2,1),Res(2,2),Res(2,3),Res(2,4)] [Res(2,5)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,7);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 12-2pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1),Res(3,2),Res(3,3),Res(3,4)] [Res(3,5)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,8);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 12-2pm')
xticks([1 2])
ylim([0 11])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1),Res(3,2),Res(3,3),Res(3,4)] [Res(3,5)]},'newfig',0);
set(gca,'FontSize', 16)
suptitle('% States Control vs OptoStim 30sON-10sOFF during 2 hours')

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Stimulation 14h-16h
% Controls
cd /media/nas5/Thierry_DATA/M1076_processed/20200723
load('SleepScoring_Accelero.mat')
EpochStimCtrl11416=intervalSet(16604*1E4,23813*1E4);
[durWakeCtrl11416,durTWakeCtrl11416]=DurationEpoch(and(Wake,EpochStimCtrl11416));       
[durSWSCtrl11416,durTSWSCtrl11416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl11416));
[durREMCtrl11416,durTREMCtrl11416]=DurationEpoch(and(REMEpoch,EpochStimCtrl11416));

cd /media/nas5/Thierry_DATA/M1076_processed/20200716
load('SleepScoring_Accelero.mat')
EpochStimCtrl21416=intervalSet(15084*1E4,22284*1E4);
[durWakeCtrl21416,durTWakeCtrl21416]=DurationEpoch(and(Wake,EpochStimCtrl21416));       
[durSWSCtrl21416,durTSWSCtrl21416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl21416));
[durREMCtrl21416,durTREMCtrl21416]=DurationEpoch(and(REMEpoch,EpochStimCtrl21416));

cd /media/nas5/Thierry_DATA/M1076_processed/Sham_1076_200701_095350
load('SleepScoring_Accelero.mat')
EpochStimCtrl31416=intervalSet(15454*1E4,22654*1E4);
[durWakeCtrl31416,durTWakeCtrl31416]=DurationEpoch(and(Wake,EpochStimCtrl31416));       
[durSWSCtrl31416,durTSWSCtrl31416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl31416));
[durREMCtrl31416,durTREMCtrl31416]=DurationEpoch(and(REMEpoch,EpochStimCtrl31416));

% Stimulation
cd /media/nas5/Thierry_DATA/M1076_processed/20200730
load('SleepScoring_Accelero.mat')
EpochStim11416=intervalSet(16884*1E4,24084*1E4);
[durWakeStim11416,durTWakeStim11416]=DurationEpoch(and(Wake,EpochStim11416));       
[durSWSStim11416,durTSWSStim11416]=DurationEpoch(and(SWSEpoch,EpochStim11416));
[durREMStim11416,durTREMStim11416]=DurationEpoch(and(REMEpoch,EpochStim11416));

%Wake
Res(1,1)=durTWakeCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(1,2)=durTWakeCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100;
Res(1,3)=durTWakeCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100;
Res(1,4)=durTWakeStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%SWS
Res(2,1)=durTSWSCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(2,2)=durTSWSCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100;
Res(2,3)=durTSWSCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100;
Res(2,4)=durTSWSStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%REM
Res(3,1)=durTREMCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100;
Res(3,2)=durTREMCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100;
Res(3,3)=durTREMCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100;
Res(3,4)=durTREMStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100;

%Figures
figure, bar([durTREMCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTREMCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100,durTREMCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100,durTREMStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'14-16hCtrl1','14-16hCtrl2','14-16hCtrl3','14-16hStim'})
title('Percentage of REM over all')

figure, bar([durTSWSCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTSWSCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100,durTSWSCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100,durTSWSStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'14-16hCtrl1','14-16hCtrl2','14-16hCtrl3','14-16hStim'})
title('Percentage of NREM over all')

figure, bar([durTWakeCtrl11416/(durTWakeCtrl11416+durTSWSCtrl11416+durTREMCtrl11416)*100,durTWakeCtrl21416/(durTWakeCtrl21416+durTSWSCtrl21416+durTREMCtrl21416)*100,durTWakeCtrl31416/(durTWakeCtrl31416+durTSWSCtrl31416+durTREMCtrl31416)*100,durTWakeStim11416/(durTWakeStim11416+durTSWSStim11416+durTREMStim11416)*100])
set(gca,'xtick',[1:4]), set(gca,'xticklabel',{'14-16hCtrl1','14-16hCtrl2','14-16hCtrl3','14-16hStim'})
title('Percentage of Wake over all')


%Moyenne 14-16
subplot(4,4,9);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(1,1), Res(1,2), Res(1,3)] [Res(1,4)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,10);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(2,1), Res(2,2), Res(2,3)] [Res(2,4)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,11);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 2-4pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1), Res(3,2), Res(3,3)] [Res(3,4)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,12);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 2-4pm')
xticks([1 2])
ylim([0 11])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1), Res(3,2), Res(3,3)] [Res(3,4)]},'newfig',0);
set(gca,'FontSize', 16)
suptitle('% States Control vs OptoStim 30sON-10sOFF during 2 hours')


%%%%%%
%% Stimulation 17h-19h
% Controls
cd /media/nas5/Thierry_DATA/M1076_processed/20200716
load('SleepScoring_Accelero.mat')
EpochStimCtrl11719=intervalSet(25446*1E4,30786*1E4);
[durWakeCtrl11719,durTWakeCtrl11719]=DurationEpoch(and(Wake,EpochStimCtrl11719));       
[durSWSCtrl11719,durTSWSCtrl11719]=DurationEpoch(and(SWSEpoch,EpochStimCtrl11719));
[durREMCtrl11719,durTREMCtrl11719]=DurationEpoch(and(REMEpoch,EpochStimCtrl11719));

cd /media/nas5/Thierry_DATA/M1076_processed/20200727
load('SleepScoring_Accelero.mat')
EpochStimCtrl21719=intervalSet(28476*1E4,333816*1E4);
[durWakeCtrl21719,durTWakeCtrl21719]=DurationEpoch(and(Wake,EpochStimCtrl21719));       
[durSWSCtrl21719,durTSWSCtrl21719]=DurationEpoch(and(SWSEpoch,EpochStimCtrl21719));
[durREMCtrl21719,durTREMCtrl21719]=DurationEpoch(and(REMEpoch,EpochStimCtrl21719));

% Stimulation
cd /media/nas5/Thierry_DATA/M1076_processed/20200723
load('SleepScoring_Accelero.mat')
EpochStim11719=intervalSet(27200*1E4,32540*1E4);
[durWakeStim11719,durTWakeStim11719]=DurationEpoch(and(Wake,EpochStim11719));       
[durSWSStim11719,durTSWSStim11719]=DurationEpoch(and(SWSEpoch,EpochStim11719));
[durREMStim11719,durTREMStim11719]=DurationEpoch(and(REMEpoch,EpochStim11719));

%Wake
Res(1,1)=durTWakeCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100;
Res(1,2)=durTWakeCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100;
Res(1,3)=durTWakeStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100;

%SWS
Res(2,1)=durTSWSCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100;
Res(2,2)=durTSWSCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100;
Res(2,3)=durTSWSStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100;

%REM
Res(3,1)=durTREMCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100;
Res(3,2)=durTREMCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100;
Res(3,3)=durTREMStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100;

%Figures
figure, bar([durTREMCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100,durTREMCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100,durTREMStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100])
set(gca,'xtick',[1:3]), set(gca,'xticklabel',{'17-19hCtrl1','17-19hCtrl2','17-19hStim'})
title('Percentage of REM over all')

figure, bar([durTSWSCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100,durTSWSCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100,durTSWSStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100])
set(gca,'xtick',[1:3]), set(gca,'xticklabel',{'17-19hCtrl1','17-19hCtrl2','17-19hStim'})
title('Percentage of NREM over all')

figure, bar([durTWakeCtrl11719/(durTWakeCtrl11719+durTSWSCtrl11719+durTREMCtrl11719)*100,durTWakeCtrl21719/(durTWakeCtrl21719+durTSWSCtrl21719+durTREMCtrl21719)*100,durTWakeStim11719/(durTWakeStim11719+durTSWSStim11719+durTREMStim11719)*100])
set(gca,'xtick',[1:3]), set(gca,'xticklabel',{'17-19hCtrl1','17-19hCtrl2','17-19hStim'})
title('Percentage of Wake over all')


%Moyenne 17-19
subplot(4,4,13);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of Wake/Total 5-7pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(1,1), Res(1,2)] [Res(1,3)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,14);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of NREM/Total 5-7pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(2,1), Res(2,2)] [Res(2,3)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,15);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 5-7pm')
xticks([1 2])
ylim([0 80])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1), Res(3,2)] [Res(3,3)]},'newfig',0);
set(gca,'FontSize', 16)

subplot(4,4,16);
ylabel('Percentage (%)')
xlabel('Conditions')
title('Mean % of REM/Total 5-7pm')
xticks([1 2])
ylim([0 11])
xticklabels({'Ctrl','Stim'})
PlotErrorBarN_KJ({[Res(3,1), Res(3,2)] [Res(3,3)]},'newfig',0);
set(gca,'FontSize', 16)
suptitle('% States Control vs OptoStim 30sON-10sOFF during 2 hours')




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd /media/nas5/Thierry_DATA/M1076_processed/20200723
load('SleepScoring_Accelero.mat')
EpochStimCtrl11416=intervalSet(16604*1E4,23813*1E4);
[durWakeCtrl11416,durTWakeCtrl11416]=DurationEpoch(and(Wake,EpochStimCtrl11416));       
[durSWSCtrl11416,durTSWSCtrl11416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl11416));
[durREMCtrl11416,durTREMCtrl11416]=DurationEpoch(and(REMEpoch,EpochStimCtrl11416));

PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,1)
hold on
title('Example Hypnogram Sham 1076 200723')
line([1.6604*1E4 1.6604*1E4],ylim,'color','b')
line([2.38130*1E4 2.3813*1E4],ylim,'color','b')

cd /media/nas5/Thierry_DATA/M1076_processed/20200716
load('SleepScoring_Accelero.mat')
EpochStimCtrl21416=intervalSet(15084*1E4,22284*1E4);
[durWakeCtrl21416,durTWakeCtrl21416]=DurationEpoch(and(Wake,EpochStimCtrl21416));       
[durSWSCtrl21416,durTSWSCtrl21416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl21416));
[durREMCtrl21416,durTREMCtrl21416]=DurationEpoch(and(REMEpoch,EpochStimCtrl21416));

PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,1)
hold on
title('Example Hypnogram Sham 1076 200716')
line([1.5084*1E4 1.5084*1E4],ylim,'color','b')
line([2.2284*1E4 2.2284*1E4],ylim,'color','b')

cd /media/nas5/Thierry_DATA/M1076_processed/Sham_1076_200701_095350
load('SleepScoring_Accelero.mat')
EpochStimCtrl31416=intervalSet(15454*1E4,22654*1E4);
[durWakeCtrl31416,durTWakeCtrl31416]=DurationEpoch(and(Wake,EpochStimCtrl31416));       
[durSWSCtrl31416,durTSWSCtrl31416]=DurationEpoch(and(SWSEpoch,EpochStimCtrl31416));
[durREMCtrl31416,durTREMCtrl31416]=DurationEpoch(and(REMEpoch,EpochStimCtrl31416));

PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,1)
hold on
title('Example Hypnogram Sham 1076 200701')
line([1.5454*1E4 1.5454*1E4],ylim,'color','b')
line([2.2654*1E4 2.2654*1E4],ylim,'color','b')

% Stimulation
cd /media/nas5/Thierry_DATA/M1076_processed/20200730
load('SleepScoring_Accelero.mat')
EpochStim11416=intervalSet(16884*1E4,24084*1E4);
[durWakeStim11416,durTWakeStim11416]=DurationEpoch(and(Wake,EpochStim11416));       
[durSWSStim11416,durTSWSStim11416]=DurationEpoch(and(SWSEpoch,EpochStim11416));
[durREMStim11416,durTREMStim11416]=DurationEpoch(and(REMEpoch,EpochStim11416));

PlotSleepStage(WakeWiNoise,SWSEpochWiNoise,REMEpochWiNoise,1)
hold on
title('Example Hypnogram Stim 1076 200730')
line([1.6884*1E4 1.6884*1E4],ylim,'color','b')
line([2.4084*1E4 2.4084*1E4],ylim,'color','b')