
%% Bus
% 30 min
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
AllMice = 0:37;
Sal = [37,1,3,4,5,9,10,15];% 11 has problem
Drug = [0,2,6,7,8,12,13,14,16,17];

%4h
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/17072020_Bus/FEAR-Mouse-1066-17072020-EPM';
Sal = [18,19,22,23,24,28,29,30,34];
Drug = [20,21,25,26,27,31,32,33,35,36];

%% Drug only
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/27102020_Dzp/FEAR-Mouse-1087-27102020-EPM';
AllMice = 0:14;
Sal = [13,4,5,6,7,8,9];
Drug = [14,0,1,2,3,10,11,12];
%Sal = [7,8,9];
%Drug = [10,11,12];  % not old

%% Drug DMSO
clear all
Base = '/media/mobsmorty/DataMOBs119/EPM/20201118_DzpDMSO/FEAR-Mouse-7-18112020-EPM';
AllMice = 0:9;
Sal = [0,1,2,3,4];
Drug = [5,6,7,8,9];

%%

EPM_Analysis_BM


figure
subplot(331)
PlotErrorBarN_BM({TimeinOA_Sal/300,TimeinOA_Drug/300},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in open arms')
ylabel('%')
subplot(332)
PlotErrorBarN_BM({TimeinCenter_Sal/300,TimeinCenter_Drug/300},'paired',0,'newfig',0,'showpoints',1)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in center')
ylabel('%')
subplot(333)
PlotErrorBarN_BM({(300-TimeinCenter_Sal-TimeinOA_Sal)./(300),(300-TimeinCenter_Drug-TimeinOA_Drug)./(300)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Proportionnal time in closed arms')
ylabel('%')

subplot(346)
PlotErrorBarN_BM({MeanSpeed_Sal,MeanSpeed_Drug},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Mean Speed')
ylabel('cm/s')
subplot(347)
PlotErrorBarN_BM({MeanTemp_Sal-nanmean(MeanTemp_Sal),MeanTemp_Drug-nanmean(MeanTemp_Sal)},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Mean Temp')
ylabel('(°C)')

subplot(349)
PlotErrorBarN_BM({NumEntry_Sal,NumEntry_Drug},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Open arms entries')
ylabel('#')
subplot(3,4,10)
PlotErrorBarN_BM({Tot_Arm_Entries_Sal,Tot_Arm_Entries_Drug},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('All arm entries')
ylabel('#')
subplot(3,4,11)
PlotErrorBarN_BM({MeanDurOpen_Sal,MeanDurOpen_Drug},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Mean duration in open arm')
ylabel('time (s)')
subplot(3,4,12)
PlotErrorBarN_BM({MeanDurClosed_Sal,MeanDurClosed_Drug},'paired',0,'newfig',0)
makepretty
xticks([ 1 2]); xticklabels({'Saline','Drug'})
title('Mean duration in closed arm')
ylabel('time (s)')


a=suptitle('EPM, Buspirone, 30 min, n=19'); a.FontSize=25;
a=suptitle('EPM, Buspirone, 4h, n=19'); a.FontSize=25;
a=suptitle('EPM, Diazepam, 30 min, n=15'); a.FontSize=25;
a=suptitle('EPM, Diazepam + DMSO, 30 min, n=10'); a.FontSize=25;






